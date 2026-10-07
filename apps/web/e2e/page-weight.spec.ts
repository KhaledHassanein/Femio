import { expect, test } from "@playwright/test";

/**
 * Page-weight budget (P1.11.1).
 *
 * Femio's growth plan is organic search, and Core Web Vitals is a ranking signal, so
 * HTML weight is a product concern rather than a nicety. P1.11.2 cut `/en/learn` from
 * ~62 KB to ~40 KB by sending only the message namespaces client components actually
 * use; without a budget that gain quietly erodes — one `useTranslations` in a shared
 * component and the whole catalog is back on every page.
 *
 * Deliberately a byte budget on the served HTML rather than a Lighthouse run: it is
 * deterministic, needs no extra dependency or headless-Chrome scoring variance, and it
 * measures the exact thing that regressed before. A full Lighthouse/CWV budget is worth
 * having later for LCP and CLS, which this cannot see.
 *
 * Ceilings sit ~25% above the measured size, so ordinary copy edits pass and a
 * structural regression (a whole catalog, an inlined blob) fails. If a change genuinely
 * needs more, raise the number in the same commit — that way the cost is a decision
 * somebody made, not a drift nobody noticed.
 */
const BUDGETS: Array<{ path: string; maxKb: number; measuredKb: number }> = [
  // CI builds without NEXT_PUBLIC_CMS_URL, so this measures the hub's shell. With the
  // live library baked in (100 guides as cards), the v3 hub measured 161 KB raw /
  // 27 KB gzipped on 2026-10-07, down from 484 KB before the covers became cached
  // files and the card styles moved into CSS classes.
  { path: "/en/learn", maxKb: 50, measuredKb: 39 },
  // R1.3 (2026-08-11): the homepage went from a hero over five link cards to seven
  // sections — a product shot, the life-stage rail, three proof cards and the trust
  // list. Raised deliberately, and the growth is rendered content, not payload: the
  // `home` namespace is server-only and does not ship to the browser.
  // v3 (2026-10-07): the Dusk Bloom header (actions row + section row) and the
  // grouped footer add ~8 KB of rendered markup to every public page; /en measured
  // 98 KB raw, 18 KB gzipped. Raised deliberately; the client i18n payload did not
  // grow (the namespace check below still guards it).
  { path: "/en", maxKb: 104, measuredKb: 98 },
  { path: "/en/calculators", maxKb: 57, measuredKb: 45 },
  // Arabic is the heaviest locale — non-Latin script costs more bytes per character.
  { path: "/ar/learn", maxKb: 58, measuredKb: 45 },
];

for (const { path, maxKb, measuredKb } of BUDGETS) {
  test(`${path} stays within its HTML budget (${maxKb} KB)`, async ({ request }) => {
    // These ceilings were measured against a production build, and CI serves one
    // (`pnpm start`, see playwright.config.ts). A local run serves `next dev`,
    // whose HTML carries the dev overlay and unminified inline scripts — every
    // budget here fails by a wide margin for reasons that have nothing to do with
    // the payload being guarded. Skipping locally keeps the signal trustworthy;
    // four failures that always fail are four failures nobody reads.
    test.skip(
      !process.env.CI,
      "budgets are calibrated against a production build; run with CI=1 after `pnpm build`",
    );

    const response = await request.get(path);
    expect(response.status()).toBe(200);

    const kb = (await response.body()).byteLength / 1024;
    expect(
      kb,
      `${path} is ${kb.toFixed(1)} KB, over its ${maxKb} KB budget (was ${measuredKb} KB when set). ` +
        "Most likely the client i18n payload grew — run `pnpm i18n-client-lint`. " +
        "If the growth is intended, raise the budget in this file in the same commit.",
    ).toBeLessThan(maxKb);
  });
}

test("the client i18n payload does not include server-only namespaces", async ({ request }) => {
  // The specific regression P1.11.2 fixed: privacy, terms and the insights dashboard were
  // serialised into every page. Probing for their copy is a direct check that the layout
  // still narrows the catalog, and it fails for a reason a reader of the diff understands.
  const html = await (await request.get("/en/learn")).text();

  expect(html, "the Terms copy is on a content page — the whole catalog is shipping again").not.toContain(
    "The deal between you and Femio",
  );
  expect(html, "the insights dashboard copy is on a content page").not.toContain("How Femio is being used");
});
