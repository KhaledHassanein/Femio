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

  // Track D.
  "appointments-and-tests": "first-pregnancy-appointment",
  "warning-signs": "pregnancy-warning-signs",

  // Track E — the fourteen postpartum drafts (B2, approved 2026-08-16).
  "recovery-after-birth": "postpartum-recovery-first-six-weeks",
  "when-to-seek-care": "postpartum-warning-signs",
  "bleeding-after-birth": "bleeding-after-birth",
  "mood-after-birth": "mood-after-birth",
  "your-postnatal-check": "six-week-postnatal-check",
  "return-of-your-cycle": "periods-after-birth",
  "breastfeeding-first-two-weeks": "breastfeeding-first-two-weeks",
  "if-breastfeeding-is-not-working": "when-breastfeeding-is-not-working",
};

/**
 * Foregrounded topics with no article behind them yet. Each is a real content
 * commitment from a persona spec, and each is queued:
 *
 * - `week-by-week` and the pregnancy topics — **P2.2.2**, still needing its own
 *   title approval; the brief forbids hand-writing a 40-entry set.
 * - the Track A topics — **P2.13**.
 * - the D2/D3/D4/D7 topics — clinical layers, unwritten.
 * - `is-baby-getting-enough` and `mastitis-and-blocked-ducts` — both are *covered
 *   inside* the two feeding articles rather than standing alone. They stay listed
 *   because E2 §E names them, and because a standalone "is the baby getting enough"
 *   page is a decision about scope (B7) rather than an oversight.
 * - the E6 loss topics — **not covered by B2**. Grief content needs its own title
 *   list and its own review, and drafting it unasked would be exactly the thing the
 *   authoring brief forbids.
 */
export const NO_ARTICLE_YET: readonly string[] = [
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
   * Track F — R2.9. Five topics F1 and F2 name that the library does not answer,
   * and **`postmenopausal-bleeding` is the one to write first.** F2 §F module 10
   * is the page behind the only red flag in the track, said calmly and without
   * minimising: any bleeding after twelve months is checked promptly. The module
   * exists, the alert exists, and there is nowhere for a woman who taps through to
   * land. The other four are `why-cycles-are-unpredictable` (F1 §F 2),
   * `mood-and-brain-fog` (F1 §F 4 — the "am I going crazy?" page),
   * `getting-taken-seriously` (F1 §F 10), and the bone and heart pair (F2 §F 4–5),
   * which must stay awareness rather than risk-scoring.
   */
  "postmenopausal-bleeding",
  "why-cycles-are-unpredictable",
  "mood-and-brain-fog",
  "getting-taken-seriously",
  "bones-after-menopause",
  "heart-after-menopause",
  "gsm-explained",
  // Track D — P2.2.2 and the clinical layers.
  "week-by-week",
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
  "is-baby-getting-enough",
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

/** Candidate slugs for a foreground list, in the order the personas asked for them. */
export function articleSlugsFor(foreground: readonly string[]): string[] {
  const slugs: string[] = [];
  for (const topic of foreground) {
    const slug = ARTICLE_FOR_TOPIC[topic];
    if (slug && !slugs.includes(slug)) slugs.push(slug);
  }
  return slugs;
}
