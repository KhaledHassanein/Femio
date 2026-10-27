"use client";

import { useEffect, useMemo, useState } from "react";
import { Search as SearchIcon } from "lucide-react";
import { useLocale, useTranslations } from "next-intl";

import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { LoadingState } from "@/components/patterns/loading-state";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Link } from "@/i18n/navigation";
import { groupByKind, search, type SearchHit } from "@/lib/search";
import { toolDocs } from "@/lib/search/corpus";
import type { LibraryIndex } from "@/lib/search/library";

/**
 * Search across everything Femio knows how to explain (D4, TD-14).
 *
 * Chapter 04's opening line: 100 published articles, a conditions library and a
 * glossary, and no way to search any of it.
 *
 * ## No database request (P2.2)
 *
 * The library is ranked in the browser over a static index built from the content
 * that ships with the site (`/api/search-index/{locale}`, see `lib/search/library`).
 * It is fetched once, on the first search, and every keystroke after that is local.
 * It used to be a Supabase RPC per keystroke: egress on a plan that had run out of
 * it, and a search that failed outright while the project was restricted.
 *
 * Tools are ranked by the same `lib/search` ranker, so library and tools now share
 * one scale. Results still render **grouped by kind** in a fixed order, because a
 * condition and the calculator for it answer different questions.
 *
 * ## A failed search says so
 *
 * Empty results and a failed request are different answers and are rendered
 * differently, the distinction RB-C7 exists to protect. Telling her nothing
 * matched when the index never loaded is the lie that costs trust in a search
 * box, because she will conclude Femio has nothing on her subject.
 */

type State =
  | { status: "idle" }
  | { status: "searching" }
  | { status: "ready"; hits: SearchHit[]; englishOnly: boolean }
  | { status: "error" };

/** One fetch per locale per page load; a failure is not cached, so retyping retries. */
const indexes = new Map<string, Promise<LibraryIndex>>();
function loadIndex(locale: string): Promise<LibraryIndex> {
  let pending = indexes.get(locale);
  if (!pending) {
    pending = fetch(`/api/search-index/${locale}`).then((res) => {
      if (!res.ok) throw new Error(`search index ${res.status}`);
      return res.json() as Promise<LibraryIndex>;
    });
    pending.catch(() => indexes.delete(locale));
    indexes.set(locale, pending);
  }
  return pending;
}

/** Short now that ranking is local: just enough to not re-rank on every key repeat. */
const DEBOUNCE_MS = 120;

export function SearchScreen() {
  const t = useTranslations("search");
  const locale = useLocale();
  const tt = useTranslations("tools");
  const [query, setQuery] = useState("");
  const [state, setState] = useState<State>({ status: "idle" });

  // Arriving from the Learn hub's search box (`/search?q=…`, a plain GET form that
  // works without JavaScript): start with her words already in the field. Read once
  // from the URL rather than via useSearchParams, which would force this static page
  // into a client-rendered bailout.
  useEffect(() => {
    const q = new URLSearchParams(window.location.search).get("q");
    if (q) setQuery(q.slice(0, 200));
  }, []);

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
    // Keep the last results on screen while the next query ranks, so typing does
    // not flash a skeleton between every letter.
    setState((prev) => (prev.status === "ready" ? prev : { status: "searching" }));

    const timer = setTimeout(() => {
      void (async () => {
        // Tools are always available, even if the library index fails to load:
        // she can still reach the calculator she was looking for.
        const toolHits = search(trimmed, tools, 5);
        try {
          const index = await loadIndex(locale);
          if (cancelled) return;
          const libraryHits = search(trimmed, index.docs, 20);
          setState({
            status: "ready",
            hits: [...libraryHits, ...toolHits],
            englishOnly: index.englishOnly && libraryHits.length > 0,
          });
        } catch {
          if (!cancelled) setState({ status: "error" });
        }
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
   * The library that answered was not hers (`0023`'s rule).
   *
   * Every article is English today (R3.8), so this fires for every non-English
   * search that finds something. Saying so is not optional: silently returning
   * English would let her conclude Femio has an Arabic library that happens not to
   * cover her subject, rather than that it has no Arabic library yet.
   */
  const fellBack = state.status === "ready" && state.englishOnly;

  return (
    <main className="mx-auto flex w-full max-w-2xl flex-col gap-5 px-5 py-6">
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
                  {/* An English title on an Arabic page: `auto` lays it out by its own
                      script, so "Can PCOS affect fertility?" keeps its question mark. */}
                  <span dir="auto" className="font-semibold text-text">
                    {hit.title}
                  </span>
                  {hit.summary ? (
                    <span dir="auto" className="line-clamp-2 text-sm text-text-muted">
                      {hit.summary}
                    </span>
                  ) : null}
                </Link>
              </li>
            ))}
          </ul>
        </section>
      ))}
    </main>
  );
}
