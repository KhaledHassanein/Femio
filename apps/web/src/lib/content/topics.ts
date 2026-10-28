/**
 * The Learn hub's topics (v3 P2.4, OD-12): which row an article belongs to, the order
 * the rows appear in, and the curated "start here" and question entry points.
 *
 * Pure data, no I/O, so the hub, search and a future Flutter client can share it.
 * Rows follow the launch wedge (D1: trying to conceive → pregnancy first); every
 * other stage keeps its own row, because the wedge sets emphasis, not access (rule 2).
 *
 * The slug lists are explicit on purpose. A pattern ("anything with 'birth' in it")
 * would put "contraception-after-birth" and "sex-after-birth" right, and the next
 * article with an unlucky slug wrong, silently. `topics.test.ts` fails when a
 * published article has no topic, so a new guide cannot land in "more" unnoticed.
 */

export const TOPIC_ORDER = [
  "ttc",
  "weeks",
  "pregnancy",
  "afterBirth",
  "newborn",
  "cycles",
  "conditions",
  "teens",
  "menopause",
  "more",
] as const;
export type Topic = (typeof TOPIC_ORDER)[number];

const TOPIC_SLUGS: Record<Exclude<Topic, "weeks" | "more">, readonly string[]> = {
  ttc: [
    "trying-to-conceive-guide",
    "fertile-window-explained",
    "irregular-cycles-and-timing",
    "when-to-take-pregnancy-test",
    "age-and-fertility",
    "preconception-appointment",
    "pcos-and-fertility",
    "endometriosis-and-fertility",
    "thyroid-and-conceiving",
    "fertility-tests-what-to-expect",
    "when-to-seek-fertility-help",
  ],
  pregnancy: [
    "pregnancy-basics",
    "early-pregnancy-changes",
    "first-pregnancy-appointment",
    "pregnancy-warning-signs",
    "ramadan-fasting-pregnancy",
  ],
  afterBirth: [
    "postpartum-recovery-first-six-weeks",
    "postpartum-warning-signs",
    "bleeding-after-birth",
    "afterpains-after-birth",
    "postpartum-wound-healing",
    "mood-after-birth",
    "sleep-and-exhaustion-after-birth",
    "breastfeeding-first-two-weeks",
    "when-breastfeeding-is-not-working",
    "pelvic-floor-after-birth",
    "periods-after-birth",
    "contraception-after-birth",
    "six-week-postnatal-check",
    "sex-after-birth",
  ],
  newborn: [
    "newborn-first-two-weeks",
    "newborn-warning-signs",
    "feeding-your-newborn",
    "bottle-and-formula-feeding",
    "safer-sleep-for-your-baby",
    "newborn-crying",
    "newborn-nappies-skin-and-cord",
    "newborn-checks-and-vaccinations",
  ],
  cycles: [
    "menstrual-cycle-basics",
    "is-my-period-normal",
    "how-to-track-menstrual-cycle",
    "period-pain-care-options",
    "how-painful-periods-are-assessed",
    "heavy-periods-iron-deficiency-anaemia",
    "track-pms-pmdd-symptoms",
    "period-myths-checked",
  ],
  conditions: [
    "pcos-signs",
    "how-pcos-is-assessed",
    "pcos-lifestyle-and-weight",
    "pcos-insulin-resistance",
    "pcos-treatment-options-to-discuss",
    "pcos-hair-skin-and-mood",
    "endometriosis-signs",
    "how-endometriosis-is-assessed",
  ],
  teens: [
    "whats-changing-in-my-body",
    "what-is-a-period",
    "getting-ready-for-your-first-period",
    "choosing-period-products",
    "period-at-school",
    "period-pain-in-teens",
    "tracking-your-cycle-as-a-teen",
    "when-to-tell-an-adult",
  ],
  menopause: [
    "perimenopause-explained",
    "track-perimenopause-symptoms",
    "menopause-explained",
    "menopause-care-options",
    "postmenopausal-bleeding",
  ],
};

const WEEK = /^pregnancy-week-(\d{1,2})$/;

/** The pregnancy week an article covers, or null. */
export function pregnancyWeek(slug: string): number | null {
  const m = WEEK.exec(slug);
  return m ? Number(m[1]) : null;
}

const BY_SLUG = new Map<string, { topic: Topic; rank: number }>();
for (const [topic, slugs] of Object.entries(TOPIC_SLUGS)) {
  slugs.forEach((slug, rank) => BY_SLUG.set(slug, { topic: topic as Topic, rank }));
}

/** Which row an article belongs to. Unknown slugs fall to "more", never dropped. */
export function topicOf(slug: string): Topic {
  if (pregnancyWeek(slug) !== null) return "weeks";
  return BY_SLUG.get(slug)?.topic ?? "more";
}

/** Position within its row: curated order, then anything unknown after it. */
export function rankOf(slug: string): number {
  const week = pregnancyWeek(slug);
  if (week !== null) return week;
  return BY_SLUG.get(slug)?.rank ?? Number.MAX_SAFE_INTEGER;
}

/** Groups any list of articles into ordered, non-empty rows. */
export function groupByTopic<T extends { slug: string }>(
  items: readonly T[],
): { topic: Topic; items: T[] }[] {
  const rows = new Map<Topic, T[]>();
  for (const item of items) {
    const topic = topicOf(item.slug);
    rows.set(topic, [...(rows.get(topic) ?? []), item]);
  }
  return TOPIC_ORDER.filter((t) => rows.has(t)).map((topic) => ({
    topic,
    items: [...rows.get(topic)!].sort((a, b) => rankOf(a.slug) - rankOf(b.slug)),
  }));
}

/** The "start here" row: one pillar per stage, in wedge order. */
export const START_HERE = [
  "trying-to-conceive-guide",
  "pregnancy-basics",
  "menstrual-cycle-basics",
  "pcos-signs",
  "postpartum-recovery-first-six-weeks",
  "perimenopause-explained",
] as const;

/**
 * Question chips (OD-12: "question-shaped topic chips"). Each key is a string in the
 * `learnHub.questions` namespace; each answer is a real published article.
 */
export const QUESTIONS = [
  { key: "fertile", slug: "fertile-window-explained" },
  { key: "test", slug: "when-to-take-pregnancy-test" },
  { key: "normal", slug: "is-my-period-normal" },
  { key: "pcos", slug: "pcos-signs" },
  { key: "urgent", slug: "pregnancy-warning-signs" },
  { key: "bleeding", slug: "bleeding-after-birth" },
  { key: "specialist", slug: "when-to-seek-fertility-help" },
  { key: "perimenopause", slug: "perimenopause-explained" },
] as const;
