"use client";

import { useEffect, useMemo, useState } from "react";
import { Search as SearchIcon } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";

import { AppScreen } from "@/components/patterns/app-screen";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { LoadingState } from "@/components/patterns/loading-state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { createClient } from "@/lib/supabase/client";
import { groupByKind, search, type SearchHit, type SearchKind } from "@/lib/search";
import { hrefForContent, toolDocs } from "@/lib/search/corpus";

/**
 * Search across everything Femio knows how to explain (D4, TD-14).
 *
 * Chapter 04's opening line: 100 published articles, a conditions library and a
 * glossary, and no way to search any of it.
 *
 * ## Two rankers, and deliberately no common scale between them
 *
 * The library is ranked in Postgres by `ts_rank` (migration `0022`, full-text over
 * titles, summaries and Lexical bodies). The tools are ranked in the browser by
 * `lib/search`, because they are routes in code and no database row will ever
 * describe them. Those two scores are not comparable, and normalising one onto the
 * other would invent a precision neither has.
 *
 * So they are never compared. Results render **grouped by kind** in a fixed order,
 * and each group is ordered by its own ranker. The cross-scale comparison simply
 * never happens, which is why it cannot be wrong.
 *
 * ## Why the query is debounced and not submitted
 *
 * `0022` makes the last token a prefix so results appear mid-word. That only pays
 * off if the search runs while she types, and 250ms is long enough that a typed
 * word is one request rather than seven.
 *
 * ## A failed search says so
 *
 * Empty results and a failed request are different answers and are rendered
 * differently — the distinction RB-C7 exists to protect. Telling her nothing
 * matched when the request never completed is the lie that costs trust in a search
 * box, because she will conclude Femio has nothing on her subject.
 */

type ContentRow = {
  kind: string;
  slug: string;
  title: string;
  summary: string | null;
  rank: number;
  /** Which library actually answered (`0023`). Differs from hers on fallback. */
  matched_locale: string;
};

type State =
  | { status: "idle" }
  | { status: "searching" }
  | { status: "ready"; hits: SearchHit[]; matchedLocale: string | null }
  | { status: "error" };

const DEBOUNCE_MS = 250;

export function SearchScreen() {
  const t = useTranslations("search");
  const locale = useLocale();
  const tt = useTranslations("tools");
  const [query, setQuery] = useState("");
  const [state, setState] = useState<State>({ status: "idle" });

  // Titles come from the tools namespace the launcher already uses, so a tool is
  // never called one thing there and another here.
  const tools = useMemo(
    () =>
      toolDocs(
        (key) => tt(`${key}.label`),
        (key) => tt(`${key}.note`),
      ),
    [tt],
  );

  useEffect(() => {
    const trimmed = query.trim();
    if (trimmed.length === 0) {
      setState({ status: "idle" });
      return;
    }

    let cancelled = false;
    setState({ status: "searching" });

    const timer = setTimeout(() => {
      void (async () => {
        // Tools are matched locally and are always available, even if the library
        // request fails — she can still reach the calculator she was looking for.
        const toolHits = search(trimmed, tools, 5);

        const { data, error } = await createClient().rpc("search_content", {
          p_query: trimmed,
          p_locale: locale,
          p_limit: 20,
        });
        if (cancelled) return;

        if (error) {
          setState({ status: "error" });
          return;
        }

        const contentHits: SearchHit[] = ((data ?? []) as ContentRow[]).map((row, i) => ({
          id: `${row.kind}:${row.slug}`,
          kind: row.kind as SearchKind,
          title: row.title,
          summary: row.summary ?? undefined,
          href: hrefForContent(row.kind, row.slug),
          // Postgres already returned these in rank order. The index is kept as
          // the score so `groupByKind` preserves that order without pretending
          // `ts_rank` and the client ranker share a scale.
          score: 1000 - i,
        }));

        setState({
          status: "ready",
          hits: [...contentHits, ...toolHits],
          matchedLocale: (data as ContentRow[] | null)?.[0]?.matched_locale ?? null,
        });
      })();
    }, DEBOUNCE_MS);

    return () => {
      cancelled = true;
      clearTimeout(timer);
    };
  }, [query, tools, locale]);

  const groups = state.status === "ready" ? groupByKind(state.hits) : [];
  const nothing = state.status === "ready" && state.hits.length === 0;

  /**
   * The library that answered was not hers (`0023`).
   *
   * Every CMS row is English today (R3.8), so this fires for every non-English
   * search. Saying so is not optional: silently returning English would let her
   * conclude Femio has an Arabic library that happens not to cover her subject,
   * rather than that it has no Arabic library yet.
   */
  const fellBack =
    state.status === "ready" && state.matchedLocale !== null && state.matchedLocale !== locale;

  return (
    <AppScreen>
      <h1 className="font-display text-lg text-text">{t("title")}</h1>

      <div className="flex flex-col gap-2">
        <label htmlFor="site-search" className="sr-only">
          {t("label")}
        </label>
        <div className="relative">
          <SearchIcon
            aria-hidden
            className="pointer-events-none absolute start-3 top-1/2 size-4 -translate-y-1/2 text-text-subtle"
          />
          <Input
            id="site-search"
            type="search"
            autoFocus
            value={query}
            onChange={(e) => setQuery(e.target.value)}
            placeholder={t("placeholder")}
            className="ps-9"
          />
        </div>
        <p className="text-xs text-text-muted">{t("hint")}</p>
      </div>

      {state.status === "searching" ? <LoadingState rows={3} label={t("searching")} /> : null}

      {state.status === "error" ? (
        <Alert variant="warning">
          {/* Not "no results". She would conclude Femio has nothing on her
              subject, which is a different and worse thing to be told. */}
          <AlertDescription>{t("failed")}</AlertDescription>
        </Alert>
      ) : null}

      {nothing ? (
        <Card>
          <CardContent className="flex flex-col gap-2 p-6">
            <p className="text-sm text-text">{t("noResults", { query: query.trim() })}</p>
            <p className="text-sm text-text-muted">{t("noResultsHint")}</p>
          </CardContent>
        </Card>
      ) : null}

      {fellBack ? (
        <Alert>
          <AlertDescription>{t("englishFallback")}</AlertDescription>
        </Alert>
      ) : null}

      {groups.map((group) => (
        <section key={group.kind} className="flex flex-col gap-2">
          <h2 className="text-sm font-semibold uppercase tracking-widest text-text-subtle">
            {t(`kinds.${group.kind}`, { count: group.hits.length })}
          </h2>
          <ul className="flex flex-col gap-2">
            {group.hits.map((hit) => (
              <li key={hit.id}>
                <Link
                  href={hit.href}
                  className="flex min-h-11 flex-col gap-1 rounded-md border border-border bg-surface p-4 hover:bg-surface-sunken"
                >
                  <span className="font-semibold text-text">{hit.title}</span>
                  {hit.summary ? (
                    <span className="line-clamp-2 text-sm text-text-muted">{hit.summary}</span>
                  ) : null}
                </Link>
              </li>
            ))}
          </ul>
        </section>
      ))}
    </AppScreen>
  );
}
