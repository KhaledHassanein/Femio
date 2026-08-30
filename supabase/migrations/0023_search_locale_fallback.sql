-- ============================================================================
-- Femio — search falls back to English, and says so (D4, follows `0022`)
--
-- ## The problem `0022` shipped with
--
-- Every row in the CMS is `_locale = 'en'` (R3.8). `0022` filters by locale, so
-- an Arabic, French or Spanish reader searching **anything** gets nothing, for
-- every query, forever. That was verified on the running site: `endometriosis`
-- in Arabic returned zero results while the same word in English returned twelve.
--
-- What makes it incoherent rather than merely empty is that Payload is configured
-- with `fallback: true`. Those readers are **already served the English article**
-- when they open it — the content is reachable by browsing and unreachable by
-- searching. Search was the only part of the product pretending the library does
-- not exist in a language it is being served in anyway.
--
-- ## So: try her locale, and fall back the way the rest of the product already does
--
-- This is not a new policy. It is `0022` catching up with the behaviour Payload
-- has had since the CMS was configured, and it disappears on its own the day
-- translated rows exist — the fallback only fires when the locale pass is empty.
--
-- ## It returns which locale answered, and the UI must say so
--
-- `matched_locale` is added to the result. Silently showing English results to
-- someone who searched in Arabic would be the same class of dishonesty as an
-- empty state that really means "the request failed" (ADR-046): she would
-- conclude Femio has an Arabic library that happens not to cover her subject,
-- rather than that it has no Arabic library yet. The screen renders a line saying
-- results are in English.
--
-- Fixing the underlying gap is R3.8 and is an owner call about content, not code.
-- ============================================================================

-- ----------------------------------------------------------------------------
-- The single-locale search: `0022`'s function, unchanged except for its name.
--
-- Extracted so the fallback above has something to call twice. Copied from the
-- applied migration rather than retyped, so the two cannot differ in a way nobody
-- would notice until a query returned subtly different results.
-- ----------------------------------------------------------------------------
create or replace function public.search_content_in(
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

comment on function public.search_content_in(text, text, int) is
  'Single-locale full-text search. `search_content` wraps this with the English fallback; call that, not this.';

revoke all on function public.search_content_in(text, text, int) from public;
grant execute on function public.search_content_in(text, text, int) to anon, authenticated;

drop function if exists public.search_content(text, text, int);

create or replace function public.search_content(
  p_query  text,
  p_locale text default 'en',
  p_limit  int  default 20
)
returns table (
  kind           text,
  slug           text,
  title          text,
  summary        text,
  rank           real,
  matched_locale text
)
language plpgsql
stable
security definer
set search_path = payload, public, pg_temp
as $$
declare
  v_count int;
begin
  -- Her own locale first. If it answers, nothing else happens and this behaves
  -- exactly as `0022` did.
  return query
    select s.*, p_locale as matched_locale
    from public.search_content_in(p_query, p_locale, p_limit) s;

  get diagnostics v_count = row_count;
  if v_count > 0 or p_locale = 'en' then
    return;
  end if;

  -- Nothing in her language. Answer from the library that does exist, and label
  -- it — see the header for why the label is not optional.
  return query
    select s.*, 'en'::text as matched_locale
    from public.search_content_in(p_query, 'en', p_limit) s;
end;
$$;

comment on function public.search_content(text, text, int) is
  'Full-text search across published articles, conditions and glossary terms. Tries the caller''s locale, then falls back to English exactly as Payload''s `fallback: true` already does when serving a document — and returns `matched_locale` so the UI can say which library answered. The fallback stops firing on its own once translated rows exist (R3.8).';

revoke all on function public.search_content(text, text, int) from public;
grant execute on function public.search_content(text, text, int) to anon, authenticated;
