#!/usr/bin/env node
/**
 * Mutation tests for `scripts/content-lint.mjs` (P1.9.1).
 *
 * The content guard reported only nine findings on its first run over 31 drafts.
 * That is either very good content or a guard that cannot fail, and those two look
 * identical from the outside — so each rule here is handed a deliberately broken
 * article and required to catch it. A rule that stays silent on input built to
 * violate it is decoration, and this file fails the build when that happens.
 *
 * Each case also implicitly asserts the converse: the baseline fixture is a valid
 * article that produces no findings, so any rule firing on the *unmutated* copy
 * would surface as a failure in every other case at once.
 *
 * Run: node scripts/content-lint.test.mjs
 */
import { mkdtempSync, writeFileSync, rmSync, mkdirSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { execFileSync } from "node:child_process";

/** A minimal article that satisfies every rule; each test breaks exactly one thing. */
const BASE = {
  title: "Heavy Periods: What Is Normal and When to Ask for Help",
  slug: "fixture-article",
  locale: "en",
  status: "draft",
  content_type: "condition cluster",
  search_intent: "informational",
  primary_query: "fixture heavy periods query",
  excerpt: "A fixture article used by the content guard's own tests.",
  meta_title: "Heavy Periods: What Is Normal and When to Ask",
  meta_description:
    "Learn what counts as a heavy period, which patterns are worth discussing with a clinician, what care can involve, and when bleeding needs urgent help.",
  canonical_url: "https://femioapp.com/en/learn/fixture-article",
  robots_while_draft: "noindex,nofollow",
  robots_when_published: "index,follow,max-image-preview:large",
  open_graph_title: "Heavy Periods: What Is Normal",
  open_graph_description: "What counts as heavy bleeding and when to seek help.",
  open_graph_image: "PENDING — upload a crawlable 1200 x 630 px image",
  open_graph_image_alt: "Illustration of a menstrual cycle calendar",
  written_by: "PENDING",
  medically_reviewed_by: "PENDING",
  reading_level_ok: true,
  reading_level_method: "Approximate Flesch-Kincaid grade 8 or lower.",
  disclaimer_type: "emergency",
};

function buildFrontMatter(overrides = {}, drop = []) {
  const fm = { ...BASE, ...overrides };
  const line = (k, v) => {
    if (v === null) return `${k}: null`;
    if (typeof v === "boolean") return `${k}: ${v}`;
    return `${k}: "${v}"`;
  };
  const out = [
    "---",
    line("title", fm.title),
    line("slug", fm.slug),
    line("locale", fm.locale),
    line("status", fm.status),
    line("content_type", fm.content_type),
    line("search_intent", fm.search_intent),
    line("primary_query", fm.primary_query),
    "secondary_topics:",
    '  - "heavy menstrual bleeding"',
    line("excerpt", fm.excerpt),
    line("meta_title", fm.meta_title),
    line("meta_description", fm.meta_description),
    line("canonical_url", fm.canonical_url),
    line("robots_while_draft", fm.robots_while_draft),
    line("robots_when_published", fm.robots_when_published),
    line("open_graph_title", fm.open_graph_title),
    line("open_graph_description", fm.open_graph_description),
    line("open_graph_image", fm.open_graph_image),
    line("open_graph_image_alt", fm.open_graph_image_alt),
    line("written_by", fm.written_by),
    line("medically_reviewed_by", fm.medically_reviewed_by),
    line("date_published", overrides.date_published ?? null),
    line("date_modified", overrides.date_modified ?? null),
    line("last_reviewed", overrides.last_reviewed ?? null),
    line("next_review_due", overrides.next_review_due ?? null),
    line("reading_level_ok", fm.reading_level_ok),
    line("reading_level_method", fm.reading_level_method),
    line("disclaimer_type", fm.disclaimer_type),
    "structured_data_required:",
    '  - "Article"',
    ...(overrides.__sources ?? [
      "sources:",
      '  - title: "NICE: Heavy menstrual bleeding assessment and management"',
      '    url: "https://www.nice.org.uk/guidance/ng88"',
      '    tier: "1"',
      '  - title: "RCOG: Heavy periods information"',
      '    url: "https://www.rcog.org.uk/for-the-public/"',
      '    tier: "2"',
    ]),
    ...(overrides.__links ?? [
      "internal_links:",
      '  - "/en/learn"',
      '  - "/en/conditions"',
      '  - "/en/calculators/cycle-length"',
    ]),
    "---",
  ];
  return out.filter((l) => !drop.some((d) => l.startsWith(`${d}:`))).join("\n");
}

const BODY = `
# Heavy Periods: What Is Normal and When to Ask for Help

A period is heavy when it soaks through pads or tampons every hour, lasts longer
than seven days, or stops you doing everyday things. Heavy bleeding is common and
often treatable, and it is worth discussing with a clinician. This is health
information for learning and planning, not a substitute for your own clinician.

## What counts as a heavy period

Bleeding varies between people and between cycles. A clinician may ask how often
you change protection and whether clots are large.

## When to see a doctor

Ask for an appointment if bleeding affects daily life, or if you feel breathless
or very tired.

> **Seek care now:** Bleeding that soaks a pad every hour for two hours, fainting,
> or chest pain needs urgent care.

## Related reading

Explore the [learning library](/en/learn) and the [conditions index](/en/conditions),
or estimate your [cycle length](/en/calculators/cycle-length).
`;

function makeArticle(overrides = {}, drop = [], body = BODY) {
  return `${buildFrontMatter(overrides, drop)}\n${body}`;
}

/** Run the guard over a one-file fixture directory; return its findings. */
function lint(files) {
  const dir = mkdtempSync(join(tmpdir(), "femio-content-lint-"));
  try {
    for (const [name, content] of Object.entries(files)) {
      writeFileSync(join(dir, name), content, "utf8");
    }
    let stdout = "";
    try {
      stdout = execFileSync(
        process.execPath,
        ["scripts/content-lint.mjs", `--dir=${dir}`, "--json"],
        { encoding: "utf8", cwd: process.cwd() },
      );
    } catch (err) {
      stdout = err.stdout ?? "";
    }
    return JSON.parse(stdout).findings;
  } finally {
    rmSync(dir, { recursive: true, force: true });
  }
}

const cases = [
  // ---- the baseline must be clean, or every other assertion is meaningless ----
  {
    name: "baseline fixture is valid",
    files: { "fixture-article.md": makeArticle() },
    expect: null,
  },
  {
    name: "missing required key",
    files: { "fixture-article.md": makeArticle({}, ["excerpt"]) },
    expect: "required-key",
  },
  {
    name: "unknown key breaks parity",
    files: {
      "fixture-article.md": makeArticle().replace("locale:", 'invented_key: "x"\nlocale:'),
    },
    expect: "key-parity",
  },
  {
    name: "status must be draft",
    files: { "fixture-article.md": makeArticle({ status: "published" }) },
    expect: "status",
  },
  {
    name: "invented author is rejected",
    files: { "fixture-article.md": makeArticle({ written_by: "Dr Jane Smith" }) },
    expect: "invented-byline",
  },
  {
    name: "invented reviewer is rejected",
    files: { "fixture-article.md": makeArticle({ medically_reviewed_by: "Dr A Khan, MRCOG" }) },
    expect: "invented-byline",
  },
  {
    name: "invented publication date is rejected",
    files: { "fixture-article.md": makeArticle({ date_published: "2026-08-04" }) },
    expect: "invented-date",
  },
  {
    name: "slug must match filename",
    files: { "fixture-article.md": makeArticle({ slug: "something-else" }) },
    expect: "slug",
  },
  {
    name: "canonical_url must agree with slug",
    files: {
      "fixture-article.md": makeArticle({
        canonical_url: "https://femioapp.com/en/learn/a-different-slug",
      }),
    },
    expect: "canonical",
  },
  {
    name: "canonical_url must use a real section",
    files: {
      "fixture-article.md": makeArticle({
        canonical_url: "https://femioapp.com/en/blog/fixture-article",
      }),
    },
    expect: "canonical",
  },
  {
    name: "meta_title length is bounded",
    files: { "fixture-article.md": makeArticle({ meta_title: "Too short" }) },
    expect: "meta-length",
  },
  {
    name: "meta_description length is bounded",
    files: { "fixture-article.md": makeArticle({ meta_description: "Far too short to be useful." }) },
    expect: "meta-length",
  },
  {
    name: "fewer than two sources",
    files: {
      "fixture-article.md": makeArticle({
        __sources: [
          "sources:",
          '  - title: "NICE: Heavy menstrual bleeding"',
          '    url: "https://www.nice.org.uk/guidance/ng88"',
          '    tier: "1"',
        ],
      }),
    },
    expect: "sources",
  },
  {
    name: "no Tier-1 source",
    files: {
      "fixture-article.md": makeArticle({
        __sources: [
          "sources:",
          '  - title: "A journal article"',
          '    url: "https://www.bmj.com/one"',
          '    tier: "2"',
          '  - title: "Another journal article"',
          '    url: "https://www.bmj.com/two"',
          '    tier: "2"',
        ],
      }),
    },
    expect: "sources",
  },
  {
    name: "forbidden source host",
    files: {
      "fixture-article.md": makeArticle({
        __sources: [
          "sources:",
          '  - title: "NICE: Heavy menstrual bleeding"',
          '    url: "https://www.nice.org.uk/guidance/ng88"',
          '    tier: "1"',
          '  - title: "Wikipedia: Menstruation"',
          '    url: "https://en.wikipedia.org/wiki/Menstruation"',
          '    tier: "2"',
        ],
      }),
    },
    expect: "sources",
  },
  {
    name: "internal link to a route that does not exist",
    files: {
      "fixture-article.md": makeArticle({
        __links: [
          "internal_links:",
          '  - "/en/learn"',
          '  - "/en/conditions"',
          '  - "/en/does-not-exist"',
        ],
      }),
    },
    expect: "internal-links",
  },
  {
    name: "internal link to an unwritten article slug",
    files: {
      "fixture-article.md": makeArticle({
        __links: [
          "internal_links:",
          '  - "/en/learn"',
          '  - "/en/conditions"',
          '  - "/en/learn/never-written"',
        ],
      }),
    },
    expect: "internal-links",
  },
  {
    name: "internal link into the authenticated app",
    files: {
      "fixture-article.md": makeArticle({
        __links: ["internal_links:", '  - "/en/learn"', '  - "/en/conditions"', '  - "/en/dashboard"'],
      }),
    },
    expect: "internal-links",
  },
  {
    name: "too few internal links",
    files: {
      "fixture-article.md": makeArticle({
        __links: ["internal_links:", '  - "/en/learn"'],
      }),
    },
    expect: "internal-links",
  },
  {
    name: "body link not declared in internal_links",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## Related reading", "## Related reading\n\nSee the [glossary](/en/glossary)."),
      ),
    },
    expect: "internal-links",
  },
  {
    name: "missing 'When to see a doctor'",
    files: {
      "fixture-article.md": makeArticle({}, [], BODY.replace("## When to see a doctor", "## Getting help")),
    },
    expect: "structure",
  },
  {
    name: "emergency article without a red-flag box",
    files: {
      "fixture-article.md": makeArticle({}, [], BODY.replace(/> \*\*Seek care now:\*\*[\s\S]*?\n\n/, "")),
    },
    expect: "red-flag",
  },
  {
    name: "heading immediately after H1 (no answer-first opening)",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace(/A period is heavy[\s\S]*?clinician\.\n/, ""),
      ),
    },
    expect: "answer-first",
  },
  {
    name: "one-sentence opening is not an answer",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace(/A period is heavy[\s\S]*your own clinician\./, "Heavy periods are common."),
      ),
    },
    expect: "answer-first",
  },
  {
    name: "Femio framed as diagnosing",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nFemio can diagnose the cause of your heavy bleeding."),
      ),
    },
    expect: "claims",
  },
  {
    name: "Femio framed as treating",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nWe treat heavy bleeding with a personalised plan."),
      ),
    },
    expect: "claims",
  },
  {
    name: "tracking framed as contraception",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nSome people use these dates as birth control."),
      ),
    },
    expect: "claims",
  },
  {
    name: "describing clinical care is allowed (no false positive)",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace(
          "## What counts as a heavy period",
          "## What counts as a heavy period\n\nNICE guidance says clinicians may offer treatment such as tranexamic acid, and a clinician can diagnose the underlying cause.",
        ),
      ),
    },
    expect: null,
  },
  {
    name: "Femio boundary statements are allowed (no false positive)",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace(
          "## What counts as a heavy period",
          "## What counts as a heavy period\n\nFemio cannot diagnose a condition and does not treat symptoms.",
        ),
      ),
    },
    expect: null,
  },
  {
    name: "ADR-028 decorative framing",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nRead about Femio's medical review process."),
      ),
    },
    expect: "health-framing",
  },
  {
    name: "boundary wording keeps 'medical' (no false positive)",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace(
          "## What counts as a heavy period",
          "## What counts as a heavy period\n\nThis is not medical advice. Seek urgent medical care for severe symptoms. Femio is not a medical device.",
        ),
      ),
    },
    expect: null,
  },
  {
    name: "phone number in crisis-adjacent copy",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nIf you need urgent help call +44 20 7946 0958 straight away."),
      ),
    },
    expect: "safety",
  },
  {
    name: "crisis topic without a link to /en/help-now",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nSome people have thoughts of self-harm before a period."),
      ),
    },
    expect: "safety",
  },
  {
    name: "crisis topic that does link to /en/help-now (no false positive)",
    files: {
      "fixture-article.md": makeArticle(
        { __links: ["internal_links:", '  - "/en/learn"', '  - "/en/conditions"', '  - "/en/calculators/cycle-length"', '  - "/en/help-now"'] },
        [],
        BODY.replace(
          "## What counts as a heavy period",
          "## What counts as a heavy period\n\nIf you have thoughts of self-harm, the [Need help now](/en/help-now) page lists the next safe step.",
        ),
      ),
    },
    expect: null,
  },
  {
    name: "fertile window without the approved sentence",
    files: {
      "fixture-article.md": makeArticle(
        {},
        [],
        BODY.replace("## What counts as a heavy period", "## What counts as a heavy period\n\nYour fertile window is the days around ovulation."),
      ),
    },
    expect: "fertile-window",
  },
  {
    name: "duplicate meta_title across the set",
    files: {
      "fixture-article.md": makeArticle(),
      "second-article.md": makeArticle({
        slug: "second-article",
        canonical_url: "https://femioapp.com/en/learn/second-article",
        primary_query: "a different query entirely",
        meta_description:
          "A second fixture article whose description differs from the first one so that only the title collides across the set for this test.",
      }),
    },
    expect: "uniqueness",
  },
  {
    name: "two articles competing for one query",
    files: {
      "fixture-article.md": makeArticle(),
      "second-article.md": makeArticle({
        slug: "second-article",
        canonical_url: "https://femioapp.com/en/learn/second-article",
        meta_title: "Second Fixture Article About Heavy Bleeding",
        meta_description:
          "A second fixture article whose title and description differ from the first so that only the primary query collides across the set here.",
      }),
    },
    expect: "cannibalisation",
  },
  {
    name: "unparseable front matter",
    files: { "fixture-article.md": makeArticle().replace('locale: "en"', "locale: en") },
    expect: "front-matter",
  },
  {
    name: "duplicate front-matter key",
    files: { "fixture-article.md": makeArticle().replace('locale: "en"', 'locale: "en"\nlocale: "fr"') },
    expect: "front-matter",
  },
];

let failed = 0;
for (const testCase of cases) {
  const findings = lint(testCase.files);
  const rules = new Set(findings.map((f) => f.rule));
  if (testCase.expect === null) {
    if (findings.length > 0) {
      failed++;
      console.error(`✗ ${testCase.name}`);
      console.error(`    expected no findings, got: ${findings.map((f) => `[${f.rule}] ${f.message}`).join("; ")}`);
    } else {
      console.log(`✓ ${testCase.name}`);
    }
  } else if (!rules.has(testCase.expect)) {
    failed++;
    console.error(`✗ ${testCase.name}`);
    console.error(`    expected rule "${testCase.expect}" to fire; got ${rules.size ? [...rules].join(", ") : "no findings at all"}`);
  } else {
    console.log(`✓ ${testCase.name}`);
  }
}

console.log("");
if (failed > 0) {
  console.error(`✗ content-lint self-test: ${failed} of ${cases.length} case(s) failed.`);
  console.error("A rule that does not fire on input built to violate it is not protecting anything.");
  process.exit(1);
}
console.log(`✓ content-lint self-test: all ${cases.length} rules fire when broken, and stay quiet when not.`);
