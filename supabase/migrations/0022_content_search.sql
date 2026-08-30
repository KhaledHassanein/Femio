-- ============================================================================
-- Femio — content search (D4, TD-14, `docs/29_REBUILD/04_CONTENT.md` §4)
--
-- Chapter 04 opens on the gap: 100 published articles, a conditions library and a
-- glossary, and **no way to search any of it**. This is the search.
--
-- ## Why a function over `payload.*` rather than a table of our own
--
-- Payload owns its schema and migrates it on its own schedule, in its **own
-- `payload` schema** in this same database. Three shapes were possible and only
-- one of them is safe:
--
-- - **A generated `tsvector` column** on Payload's tables — invasive. Payload's
--   adapter reconciles schema on deploy and would be entitled to drop it.
-- - **A view** over those tables — creates a hard dependency, so a future Payload
--   `ALTER TABLE` would *fail* because our view depends on the column. That turns
--   our search feature into a thing that can block the CMS from deploying.
-- - **A function** — Postgres does not track function-to-column dependencies, so
--   this can never block a Payload migration. If Payload renames `title`, this
--   errors when called and the CMS still ships. That is the right failure: ours
--   breaks, not theirs.
--
-- ## Arabic is not a blocker any more
--
-- Chapter 04 said Arabic *"needs its own configuration, and that is the whole
-- reason it is not a one-line change"*. That was true once. This database is
-- Postgres 17 and ships a stemmed `arabic` configuration alongside `english`,
-- `french` and `spanish`, verified before this migration was written. Anything
-- else falls back to `simple`, which tokenises without stemming — correct
-- behaviour for a language we have not deliberately configured, rather than
-- pretending English rules apply to it.
--
-- ## The body is Lexical JSON, so it is indexed as strings only
--
-- `articles_locales.body` is `jsonb`. `jsonb_to_tsvector(config, body, '["string"]')`
-- walks it and takes **only string values**, which is exactly right: the raw JSON
-- would otherwise contribute node types and format keys as searchable words, so
-- every article would match "paragraph".
--
-- ## No indexes yet, deliberately
--
-- A GIN index needs a *literal* text-search config to be immutable, so an index
-- built on `'english'` cannot serve a query whose config is a variable. Creating
-- four per-locale indexes this query provably cannot use would be a lie in the
-- schema — write cost and an implied guarantee, for nothing.
--
-- At 105 rows the sequential scan is immaterial. **When the corpus passes roughly
-- a thousand rows**, the fix is to split the query into one branch per locale with
-- the config written as a literal, and add a matching partial GIN index per
-- branch, e.g.
--
--   create index articles_locales_fts_en on payload.articles_locales using gin (
--     (to_tsvector('english', coalesce(title,'') || ' ' || coalesce(excerpt,''))
--      || jsonb_to_tsvector('english', body, '["string"]'))
--   ) where _locale = 'en';
--
-- Written down here because the reason this is absent is not obvious from its
-- absence.
-- ============================================================================

-- Locale to stemmer. `simple` for anything we have not deliberately configured:
-- tokenise, do not stem, do not apply another language's stopwords.
create or replace function public.femio_ts_config(p_locale text)
returns regconfig
language sql
immutable
parallel safe
as $$
  select case p_locale
    when 'en' then 'english'::regconfig
    when 'fr' then 'french'::regconfig
    when 'es' then 'spanish'::regconfig
    when 'ar' then 'arabic'::regconfig
    else 'simple'::regconfig
  end;
$$;

comment on function public.femio_ts_config(text) is
  'Locale to Postgres text-search configuration. `simple` for unconfigured languages — tokenise without stemming, rather than applying English rules to a language that is not English.';

-- ----------------------------------------------------------------------------
-- Query text to `tsquery`, with the last word treated as a prefix.
--
-- Full-text search matches whole stemmed words, so a plain
-- `websearch_to_tsquery` finds nothing for `pregnan` until the `cy` is typed.
-- In a search box that is not a rough edge, it is the whole experience: the
-- results are empty for most of the time the user is typing.
--
-- So the final token becomes a prefix term and the earlier ones stay exact:
--
--   `pregnan`      -> pregnan:*
--   `period pain`  -> period & pain:*
--
-- **The last token is prefixed, not OR-ed in.** OR-ing would let `period pain`
-- match anything containing merely `pain`, which trades the precision the ranking
-- depends on for nothing — the user typed both words.
--
-- A quoted query is left entirely to `websearch_to_tsquery`: quotes mean she asked
-- for that exact phrase, and silently widening the last word of it would be
-- ignoring what she said.
-- ----------------------------------------------------------------------------
create or replace function public.femio_search_tsquery(p_config regconfig, p_query text)
returns tsquery
language sql
immutable
parallel safe
as $$
  with t as (
    select
      trim(coalesce(p_query, '')) as raw,
      -- Only letters, digits and separators survive. Everything else is tsquery
      -- punctuation waiting to raise a syntax error on input a person may well
      -- type, and `to_tsquery` — unlike `websearch_to_tsquery` — does raise.
      regexp_replace(
        regexp_replace(coalesce(p_query, ''), '[^[:alnum:][:space:]]', ' ', 'g'),
        '\s+', ' ', 'g'
      ) as clean
  ),
  parts as (
    select
      raw,
      clean,
      -- Everything except the final word, and the final word on its own.
      trim(regexp_replace(trim(clean), '\S+$', '')) as head,
      substring(trim(clean) from '\S+$') as tail
    from t
  )
  select case
    when clean = '' then null::tsquery
    -- A quoted phrase is an exact request; leave it alone.
    when raw like '%"%' then websearch_to_tsquery(p_config, raw)
    when head = '' then to_tsquery(p_config, tail || ':*')
    -- **Both readings, OR-ed.** Prefixing the last token alone measurably hurt
    -- complete queries: for `period pain`, `period & pain:*` pushed two of the
    -- most relevant pages out of the top five in favour of generic cycle
    -- articles, because a prefix term ranks differently from an exact one.
    -- OR-ing the exact reading back in restores it, and a document matching both
    -- readings now scores higher than one matching only the prefix — which is
    -- the ordering we wanted all along.
    else websearch_to_tsquery(p_config, clean)
         || (websearch_to_tsquery(p_config, head) && to_tsquery(p_config, tail || ':*'))
  end
  from parts;
$$;

comment on function public.femio_search_tsquery(regconfig, text) is
  'Search text to tsquery, with the final token as a prefix so results appear while she is still typing. Quoted phrases are passed through untouched.';


-- ----------------------------------------------------------------------------
-- The search itself.
--
-- `security definer` because `payload` is not exposed to PostgREST and the web
-- role has no rights in it. The content this returns is **already public** — these
-- are published pages served on the marketing site — so this widens no access that
-- a visitor did not already have by reading the site.
--
-- `search_path` is pinned. A `security definer` function without one is the
-- classic privilege-escalation hole: a caller who can create objects in a schema
-- earlier on the path can shadow a table this body names.
-- ----------------------------------------------------------------------------
create or replace function public.search_content(
  p_query  text,
  p_locale text default 'en',
  p_limit  int  default 20
)
returns table (
  kind    text,
  slug    text,
  title   text,
  summary text,
  rank    real
)
language sql
stable
security definer
set search_path = payload, public, pg_temp
as $$
  with cfg as (select public.femio_ts_config(p_locale) as c),
       q as (
         -- Prefix-aware, so results appear while she is still typing. See
         -- `femio_search_tsquery` for why the last token is special.
         select public.femio_search_tsquery((select c from cfg), p_query) as tsq
       )
  select * from (
    select
      'article'::text as kind,
      a.slug,
      al.title,
      al.excerpt as summary,
      ts_rank(
        setweight(to_tsvector((select c from cfg), coalesce(al.title, '')), 'A')
        || setweight(to_tsvector((select c from cfg), coalesce(al.excerpt, '')), 'B')
        || setweight(jsonb_to_tsvector((select c from cfg), al.body, '["string"]'), 'D'),
        (select tsq from q)
      ) as rank
    from payload.articles a
    join payload.articles_locales al on al._parent_id = a.id
    where a._status = 'published'
      and al._locale::text = p_locale
      and (
        setweight(to_tsvector((select c from cfg), coalesce(al.title, '')), 'A')
        || setweight(to_tsvector((select c from cfg), coalesce(al.excerpt, '')), 'B')
        || setweight(jsonb_to_tsvector((select c from cfg), al.body, '["string"]'), 'D')
      ) @@ (select tsq from q)

    union all

    select
      'condition'::text,
      c.slug,
      cl.title,
      cl.summary,
      -- Title weighted the same as an article's, but a condition wins ties in the
      -- client's ranking (`lib/search`): someone typing a condition name wants the
      -- library entry that gathers everything, not an article that shares the word.
      ts_rank(
        setweight(to_tsvector((select c from cfg), coalesce(cl.title, '')), 'A')
        || setweight(to_tsvector((select c from cfg), coalesce(cl.summary, '')), 'B')
        || setweight(jsonb_to_tsvector((select c from cfg), cl.body, '["string"]'), 'D'),
        (select tsq from q)
      )
    from payload.conditions c
    join payload.conditions_locales cl on cl._parent_id = c.id
    where c._status = 'published'
      and cl._locale::text = p_locale
      and (
        setweight(to_tsvector((select c from cfg), coalesce(cl.title, '')), 'A')
        || setweight(to_tsvector((select c from cfg), coalesce(cl.summary, '')), 'B')
        || setweight(jsonb_to_tsvector((select c from cfg), cl.body, '["string"]'), 'D')
      ) @@ (select tsq from q)

    union all

    select
      'glossary'::text,
      g.slug,
      gl.term,
      -- The definition is Lexical JSON; the first string in it is the opening
      -- sentence, which is the right one-line summary for a result row.
      left(coalesce(jsonb_path_query_first(gl.definition, '$.**.text')::text, ''), 300),
      ts_rank(
        setweight(to_tsvector((select c from cfg), coalesce(gl.term, '')), 'A')
        || setweight(jsonb_to_tsvector((select c from cfg), gl.definition, '["string"]'), 'C'),
        (select tsq from q)
      )
    from payload.glossary g
    join payload.glossary_locales gl on gl._parent_id = g.id
    where g._status = 'published'
      and gl._locale::text = p_locale
      and (
        setweight(to_tsvector((select c from cfg), coalesce(gl.term, '')), 'A')
        || setweight(jsonb_to_tsvector((select c from cfg), gl.definition, '["string"]'), 'C')
      ) @@ (select tsq from q)
  ) hits
  order by rank desc, title asc
  limit greatest(1, least(coalesce(p_limit, 20), 50));
$$;

comment on function public.search_content(text, text, int) is
  'Full-text search across published articles, conditions and glossary terms, per locale. Reads Payload''s own schema through a function rather than a view, so a CMS schema change can never block on us. Calculators are searched client-side — they live in code, not in the database.';

-- Published content is public. `anon` matters: search has to work on the
-- marketing site before anyone signs in, which is where it is most needed.
revoke all on function public.search_content(text, text, int) from public;
grant execute on function public.search_content(text, text, int) to anon, authenticated;
grant execute on function public.femio_ts_config(text) to anon, authenticated;
grant execute on function public.femio_search_tsquery(regconfig, text) to anon, authenticated;
