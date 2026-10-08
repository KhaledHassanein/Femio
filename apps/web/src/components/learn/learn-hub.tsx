import { getTranslations } from "next-intl/server";
import { Search } from "lucide-react";
import type { ContentDoc } from "@/lib/cms/client";
import { lede } from "@/lib/cms/format";
import { Link } from "@/i18n/navigation";
import { PageView } from "@/components/analytics/page-view";
import { TopicArt } from "@/components/learn/topic-art";
import { QUESTIONS, START_HERE, groupByTopic, pregnancyWeek, topicOf } from "@/lib/content/topics";

/**
 * The Learn hub (v3 P2.4, OD-12).
 *
 * OD-12 asked for Flo's Insights *structure*: search, question-shaped chips, a
 * "start here" row, category rows and bold illustrated cards, with our citations,
 * clinician names and four languages. What it replaced was one 21,504px list of 100
 * text cards with no grouping at all.
 *
 * Everything here is a server component and the page is ISR, so the hub ships no
 * JavaScript of its own. Rows scroll sideways (with snap) so the page height stays
 * proportional to the number of topics, not articles; every article is still one tap
 * from the hub (rule 2).
 *
 * Titles and ledes come from the CMS and may be English on /ar, /fr, /es. They carry
 * `dir="auto"`, so English text lays out left-to-right inside an RTL page instead of
 * having its punctuation reordered (the defect fixed on article pages in P1.7).
 */
export async function LearnHub({ locale, articles }: { locale: string; articles: ContentDoc[] }) {
  const t = await getTranslations({ locale, namespace: "learnHub" });
  const learn = await getTranslations({ locale, namespace: "learn" });
  const bySlug = new Map(articles.map((a) => [a.slug, a]));
  const start = START_HERE.map((s) => bySlug.get(s)).filter((a): a is ContentDoc => a != null);
  const questions = QUESTIONS.filter((q) => bySlug.has(q.slug));
  const rows = groupByTopic(articles.filter((a) => a.slug !== "meet-femio"));

  return (
    <main className="flex flex-col pb-16">
      <PageView area="library" />

      {/* ── Hero: the promise, the search, the questions ─────────────────────── */}
      <section className="aurora text-text-on-brand">
        <div className="mx-auto flex w-full max-w-5xl flex-col gap-5 px-4 pb-10 pt-10 sm:px-6">
          <div className="flex flex-col gap-2">
            <h1 className="font-display text-4xl font-medium leading-tight">{learn("title")}</h1>
            <p className="max-w-xl text-sm leading-relaxed opacity-90">{learn("subtitle")}</p>
          </div>
          <form
            action={`/${locale}/search`}
            method="get"
            role="search"
            className="relative max-w-xl"
          >
            <Search
              className="pointer-events-none absolute start-4 top-1/2 size-5 -translate-y-1/2 text-text-subtle"
              aria-hidden
            />
            <input
              type="search"
              name="q"
              aria-label={t("searchLabel")}
              placeholder={t("searchPlaceholder")}
              className="h-12 w-full rounded-pill border border-white/30 bg-surface ps-12 pe-4 text-sm text-text shadow-md placeholder:text-text-subtle focus-visible:outline-none"
            />
          </form>
          {questions.length > 0 ? (
            <div className="flex flex-col gap-2">
              <h2 className="text-2xs font-semibold uppercase tracking-wider opacity-75">
                {t("questionsTitle")}
              </h2>
              <ul className="-mx-4 flex gap-2 overflow-x-auto px-4 pb-1 [scrollbar-width:none] sm:mx-0 sm:flex-wrap sm:px-0 [&::-webkit-scrollbar]:hidden">
                {questions.map((q) => (
                  <li key={q.key} className="shrink-0">
                    <Link
                      href={`/learn/${q.slug}`}
                      className="inline-flex h-10 items-center rounded-pill border border-white/30 bg-white/10 px-4 text-sm backdrop-blur hover:bg-white/20"
                    >
                      {t(`questions.${q.key}`)}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          ) : null}
        </div>
      </section>

      {articles.length === 0 ? (
        <p className="mx-auto w-full max-w-5xl px-4 py-12 text-sm text-text-muted sm:px-6">
          {learn("empty")}
        </p>
      ) : null}

      {/* ── Start here: one pillar per stage, large cards ──────────────────────── */}
      {start.length > 0 ? (
        <Row title={t("startHere")}>
          {start.map((doc) => (
            <Card key={doc.id} doc={doc} size="lg" />
          ))}
        </Row>
      ) : null}

      {/* ── One row per stage, wedge first ─────────────────────────────────────── */}
      {rows.map(({ topic, items }) =>
        topic === "weeks" ? (
          <section
            key={topic}
            id={topic}
            className="reveal mx-auto flex w-full max-w-5xl scroll-mt-24 flex-col gap-3 px-4 pt-10 sm:px-6"
          >
            <RowHeading title={t(`topics.${topic}`)} count={t("guides", { count: items.length })} />
            <p className="text-sm text-text-muted">{t("weeksHint")}</p>
            <ul className="grid grid-cols-6 gap-2 sm:grid-cols-10">
              {items.map((doc) => {
                const week = pregnancyWeek(doc.slug);
                return (
                  <li key={doc.id}>
                    <Link href={`/learn/${doc.slug}`} aria-label={t("week", { n: week ?? 0 })} className="learn-week">
                      {week}
                    </Link>
                  </li>
                );
              })}
            </ul>
          </section>
        ) : (
          <Row
            key={topic}
            id={topic}
            title={t(`topics.${topic}`)}
            count={t("guides", { count: items.length })}
          >
            {items.map((doc) => (
              <Card key={doc.id} doc={doc} />
            ))}
          </Row>
        ),
      )}
    </main>
  );
}

function RowHeading({ title, count }: { title: string; count?: string }) {
  return (
    <div className="flex items-baseline justify-between gap-3">
      <h2 className="font-display text-2xl font-medium text-text">{title}</h2>
      {count ? <span className="text-2xs text-text-subtle">{count}</span> : null}
    </div>
  );
}

function Row({
  title,
  id,
  count,
  children,
}: {
  id?: string;
  title: string;
  count?: string;
  children: React.ReactNode;
}) {
  return (
    <section id={id} className="reveal mx-auto flex w-full max-w-5xl scroll-mt-24 flex-col gap-3 pt-10">
      <div className="px-4 sm:px-6">
        <RowHeading title={title} count={count} />
      </div>
      <ul className="flex snap-x snap-mandatory gap-3 overflow-x-auto scroll-px-4 px-4 pb-2 [scrollbar-width:none] sm:scroll-px-6 sm:px-6 [&::-webkit-scrollbar]:hidden">
        {children}
      </ul>
    </section>
  );
}

function Card({ doc, size = "md" }: { doc: ContentDoc; size?: "md" | "lg" }) {
  // Styling lives in `.learn-card` (globals.css), not in utility lists: with ~70
  // cards, every class string was paid for twice (HTML and React payload).
  const summary = lede(doc);
  return (
    <li className={size === "lg" ? "learn-card learn-card-lg" : "learn-card"}>
      <Link href={`/learn/${doc.slug}`}>
        <TopicArt topic={topicOf(doc.slug)} slug={doc.slug} className="learn-card-art" />
        <div>
          <h3 dir="auto">{doc.title}</h3>
          {summary ? <p dir="auto">{summary}</p> : null}
        </div>
      </Link>
    </li>
  );
}
