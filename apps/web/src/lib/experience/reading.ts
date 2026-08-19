/**
 * Topic id → article slug, for the reading list a persona foregrounds (P2.3c).
 *
 * ## The gap this closes
 *
 * `ExperienceConfig.content.foreground` has existed since R2.1 and **nothing has
 * ever read it**. Every registry record names three to five topics it wants in
 * front of her, and the dashboards rendered either a hardcoded list of three
 * pregnancy articles or a card saying the content is being written. That is the
 * same write-only shape `docs/23` §3.1 opened this workstream with: a field that
 * looks like a decision and reaches no screen.
 *
 * ## Why a mapping rather than slugs in the registry
 *
 * The registry speaks in **topics** — "when-to-seek-care", "return-of-your-cycle" —
 * and a topic outlives the article that answers it. Slugs are an SEO artefact: they
 * get renamed, split in two, or replaced by a better page, and a persona spec should
 * not have to change when that happens. Keeping the vocabularies apart also means
 * the registry can name a topic **before** anyone has written it, which is the
 * normal state of a content set that is still being authored.
 *
 * ## Unmapped topics are listed, not silent
 *
 * `NO_ARTICLE_YET` names every foregrounded topic that has no article behind it, and
 * `reading.test.ts` asserts the two lists together cover every topic in the registry.
 * That is the `UNIMPLEMENTED` idiom from `module-registry.tsx`, and it exists because
 * of what R2.5/P2.7a proved: a gap nobody counted is a gap nobody notices. A topic
 * dropped from this file without a home fails the suite rather than quietly vanishing
 * from a reading list.
 *
 * ## What it renders is what the CMS has published
 *
 * A slug here is a *candidate*. `/api/reading` returns only the ones the CMS is
 * actually serving, so a draft awaiting clinician approval contributes nothing and
 * then appears on its own the moment it is published — no code change, and no window
 * in which the dashboard links to a 404. Publication is the review gate's decision
 * (ADR-032), and this file must never be able to pre-empt it.
 */

/** Foregrounded topics that have an authored article. */
export const ARTICLE_FOR_TOPIC: Readonly<Record<string, string>> = {
  /**
   * Track A — the teen ten (P2.13, drafted 2026-08-17).
   *
   * The topics were named in `registry/track-a.ts` at R2.5c and had no articles
   * behind them for two weeks; these are the pages A1 §D and A2 §F asked for.
   * `menstrual-cycle-basics` stays pointed at the adult page on purpose — A2 §B
   * says she reads being talked down to as being locked out, and the teen set says
   * plainly where an article is written for adults.
   */
  "menstrual-cycle-basics": "menstrual-cycle-basics",
  "whats-changing": "whats-changing-in-my-body",
  "what-is-a-period": "what-is-a-period",
  "first-period-plan": "getting-ready-for-your-first-period",
  "myth-busting": "period-myths-checked",
  "youre-normal": "is-my-period-normal",
  "using-period-products": "choosing-period-products",
  "school-day": "period-at-school",
  "tracking-without-stress": "tracking-your-cycle-as-a-teen",
  // Added to A2's foreground with the set (P2.13): the two the dashboard had no
  // way to reach, and the two a teen is most likely to be searching for alone.
  "period-pain": "period-pain-in-teens",
  "telling-an-adult": "when-to-tell-an-adult",

  /**
   * Track B (R2.8) — and this is the first track whose reading card fills from the
   * library that already exists rather than waiting on a batch. Six of B1/B5/B6's
   * sixteen topics have a published article today, and B6's card fills completely.
   */
  "how-to-track": "how-to-track-menstrual-cycle",
  "pms-and-the-week-before": "pms-pmdd",
  "pcos-explained": "pcos",
  "pcos-signs": "pcos-signs",
  "how-pcos-is-assessed": "how-pcos-is-assessed",

  // Track F (R2.9) — three of F1/F2's twelve topics are already published.
  "perimenopause-explained": "perimenopause-explained",
  "menopause-explained": "menopause-explained",
  "menopause-care-options": "menopause-care-options",
  "tracking-menopause-symptoms": "track-perimenopause-symptoms",
  /**
   * R2.9b. F2 §F module 10 — the page behind the only red flag in Track F, and the
   * one topic in this file that was a genuine hole rather than a queue item: the
   * `menopause.pmb` module was live and the alert was live, and a woman who tapped
   * through had nowhere to land.
   */
  "postmenopausal-bleeding": "postmenopausal-bleeding",

  // Track C (R2.11) — four of its topics already have published articles.
  "ttc-basics": "trying-to-conceive-guide",
  "fertile-window": "fertile-window-explained",
  "when-to-seek-help": "when-to-seek-fertility-help",
  "preconception-visit": "preconception-appointment",
  "pcos-and-conceiving": "pcos-and-fertility",

  // Track D.
  "appointments-and-tests": "first-pregnancy-appointment",
  "warning-signs": "pregnancy-warning-signs",
  /**
   * `week-by-week` is deliberately **not** here — it is the one topic in this file
   * that has no single answer. See `WEEK_AWARE_TOPICS` below.
   */

  // Track E — the fourteen postpartum drafts (B2, approved 2026-08-16).
  "recovery-after-birth": "postpartum-recovery-first-six-weeks",
  "when-to-seek-care": "postpartum-warning-signs",
  "bleeding-after-birth": "bleeding-after-birth",
  "mood-after-birth": "mood-after-birth",
  "your-postnatal-check": "six-week-postnatal-check",
  "return-of-your-cycle": "periods-after-birth",
  "breastfeeding-first-two-weeks": "breastfeeding-first-two-weeks",
  "if-breastfeeding-is-not-working": "when-breastfeeding-is-not-working",

  /**
   * Track E, newborn (P2.13c, drafted 2026-08-17) — the first slugs in this file
   * about **a person who is not the account holder**.
   *
   * `is-baby-getting-enough` has been in `NO_ARTICLE_YET` since R2.5f with a note
   * saying a standalone page was a scope decision rather than an oversight. B7 made
   * that decision, so it resolves to a real article now — one that answers the 2am
   * question by describing what a midwife or health visitor looks at, and refuses to
   * give a verdict on her baby. The topic keeps its name because the topic outlived
   * the answer, which is the whole reason this file exists.
   *
   * Only three of the eight drafts appear here, because a slug may only be mapped if
   * a persona foregrounds its topic (`reading.test.ts`) — and only E2 may carry them.
   * See the note on E2's `foreground` for why E1 cannot.
   */
  "is-baby-getting-enough": "feeding-your-newborn",
  "newborn-warning-signs": "newborn-warning-signs",
  "bottle-and-formula-feeding": "bottle-and-formula-feeding",
};

/**
 * Topics answered by a **set** rather than by one article, resolved from a fact
 * about her record instead of from a lookup (P2.2.2).
 *
 * `week-by-week` is the first and, today, the only one. D1 has foregrounded it since
 * R2.1 and it sat in `NO_ARTICLE_YET` for as long as there was nothing behind it;
 * there are now 37 entries, weeks 4 to 40, and the right one depends on how pregnant
 * she is. A static map cannot express that, and a component computing it would put a
 * content decision in a screen — so it lives here, in tier 1, beside the map.
 *
 * These topics are counted by `reading.test.ts` exactly like the two lists are: a
 * topic must be in the map, in `NO_ARTICLE_YET`, or here.
 */
export const WEEK_AWARE_TOPICS: readonly string[] = ["week-by-week"];

/**
 * The week entry for a gestational week, or `null` when there is none to give.
 *
 * Two boundaries, both deliberate and both from `docs/content/HANDOVER_WEEK_BY_WEEK.md`:
 *
 * - **Below week 4 there is no article, and none is substituted.** Dating counts from
 *   the last period, so weeks 1–3 precede conception and an entry for them would teach
 *   the wrong thing. Returning week 4 to fill the slot would be the invented-window
 *   defect (ADR-041/042) in content form.
 * - **Past week 40 the week-40 entry stands**, because it is the one that covers going
 *   past the due date, and because term runs to 42 weeks (ADR-053). Falling off the end
 *   into no article at 41 weeks would remove the page precisely when it is being
 *   searched for.
 */
export function weekArticleSlug(gestationalWeek: number | null | undefined): string | null {
  if (gestationalWeek == null || !Number.isFinite(gestationalWeek)) return null;
  const week = Math.floor(gestationalWeek);
  if (week < 4) return null;
  return `pregnancy-week-${Math.min(week, 40)}`;
}

/**
 * Foregrounded topics with no article behind them yet. Each is a real content
 * commitment from a persona spec, and each is queued:
 *
 * - the remaining pregnancy topics — `nutrition` and the clinical layers.
 *   (`week-by-week` left this list with P2.2.2; it is answered by the 37 week
 *   entries and resolved through `weekArticleSlug`.)
 * - the Track A topics — **P2.13**.
 * - the D2/D3/D4/D7 topics — clinical layers, unwritten.
 * - `mastitis-and-blocked-ducts` — covered *inside* `when-breastfeeding-is-not-working`
 *   rather than standing alone. It stays listed because E2 §E names it.
 *   (`is-baby-getting-enough` left this list with P2.13c: B7 answered the scope
 *   question and `feeding-your-newborn` is the page.)
 * - the E6 loss topics — **not covered by B2**. Grief content needs its own title
 *   list and its own review, and drafting it unasked would be exactly the thing the
 *   authoring brief forbids.
 */
export const NO_ARTICLE_YET: readonly string[] = [
  /**
   * Track C — R2.11. Four topics C2, C3, C6 and C8 name that the library does not
   * answer. **`what-a-workup-involves` is the one to write first:** it is the hero
   * of both C2 and C3, so a woman past her evaluation window gets a roadmap card
   * with nothing behind it — the same shape as the red flag Track F carried with no
   * page until R2.9b.
   */
  "what-a-workup-involves",
  "age-and-fertility",
  "irregular-cycles-and-timing",
  "thyroid-and-conceiving",
  // Track A is fully covered as of P2.13 (2026-08-17) — the ten teen drafts are in
  // `docs/content/articles/`, so every A1 and A2 topic has an article above. It was
  // the whole of this list two weeks ago, which is the fastest a foreground list in
  // this project has gone from empty to answered.
  /**
   * Track B — R2.8. Four topics the cycle personas name and the library does not
   * answer yet, and each is a real content ask rather than an oversight:
   *
   * - `whats-normal-whats-worth-checking` is B1 §F module 4 and B5's second-most
   *   wanted page. The closest published article is `heavy-periods`, which answers
   *   one symptom rather than the question.
   * - `prediction-honestly` is B1 §F module 6 — *why no app can give a certain
   *   date* — and it is the page that explains Femio's own posture. It is arguably
   *   the highest-value unwritten article in the product.
   * - `your-data-your-rules` is B1 §F module 8, the privacy explainer. §K calls
   *   privacy a primary acquisition argument for this persona, so leaving it to the
   *   legal pages is a decision rather than a gap.
   * - `irregular-cycles-explained` and `when-a-gap-is-worth-checking` are B5's, and
   *   they are the two that need the most care: B5's whole design is that a cause
   *   is *undetermined*, so neither page may name one as hers.
   */
  "whats-normal-whats-worth-checking",
  "prediction-honestly",
  "your-data-your-rules",
  "irregular-cycles-explained",
  "when-a-gap-is-worth-checking",
  /**
   * Track F — R2.9. Four topics F1 and F2 name that the library does not answer.
   * **`postmenopausal-bleeding` has left this list (R2.9b)** — it was the one that
   * mattered, because the module and the alert were both live with nowhere to land.
   * The rest are `why-cycles-are-unpredictable` (F1 §F 2), `mood-and-brain-fog`
   * (F1 §F 4 — the "am I going crazy?" page), `getting-taken-seriously` (F1 §F 10),
   * and the bone and heart pair (F2 §F 4–5), which must stay awareness rather than
   * risk-scoring.
   */
  "why-cycles-are-unpredictable",
  "mood-and-brain-fog",
  "getting-taken-seriously",
  "bones-after-menopause",
  "heart-after-menopause",
  "gsm-explained",
  // Track D — the clinical layers, and the one general topic still unwritten.
  "nutrition",
  "milestone-at-a-time",
  "however-you-feel",
  "scan-literacy",
  "just-diagnosed",
  "understanding-your-numbers",
  "carbs",
  "gdm-delivery",
  "planning-with-diabetes",
  "tighter-targets",
  "hypo-safety",
  "devices-in-labour",
  "your-thyroid-and-your-baby",
  "why-my-dose-often-goes-up",
  "how-often-checked",
  "taking-levothyroxine-right",
  // Track E — feeding facets, condition follow-up, and the loss shelf. The E4 and
  // E7 topics are new with R2.5f and unwritten: postpartum condition follow-up and
  // the thyroid year are their own content asks, and neither is covered by B2.
  "partner-explainer",
  "your-follow-up-tests",
  "what-this-means-long-term",
  "could-this-be-my-thyroid",
  "mastitis-and-blocked-ducts",
  "grief-and-what-helps",
  "your-body-after-a-loss",
  "telling-people",
];

/**
 * How many links a dashboard reading card carries. Four is a card; ten is a library,
 * and the library already exists at `/learn`. The cap applies after the CMS has
 * filtered to what is published, so an unapproved draft never costs a slot.
 */
export const READING_LIST_LIMIT = 4;

/**
 * Candidate slugs for a foreground list, in the order the personas asked for them.
 *
 * `gestationalWeek` is what makes the pregnancy card week-aware (P2.2.2). It is
 * optional because every other track resolves without it, and because a caller that
 * does not know how pregnant she is should drop the topic rather than guess a week.
 */
export function articleSlugsFor(
  foreground: readonly string[],
  opts: { gestationalWeek?: number | null } = {},
): string[] {
  const slugs: string[] = [];
  for (const topic of foreground) {
    const slug = WEEK_AWARE_TOPICS.includes(topic)
      ? weekArticleSlug(opts.gestationalWeek)
      : ARTICLE_FOR_TOPIC[topic];
    if (slug && !slugs.includes(slug)) slugs.push(slug);
  }
  return slugs;
}
