/**
 * Does the visit report actually survive a print to PDF? (R3.1c.4)
 *
 * `window.print()` was chosen because it keeps her health data on the device — no
 * server ever renders the document. What that buys in privacy it costs in
 * verification: nothing in the test suite renders print media, so the report's
 * **derived** section — its dashed border and its heading, the thing that tells a
 * clinician which numbers are estimates rather than observations (R3.1c) — has
 * never been looked at on a printed page. The cleanup register listed it as
 * "verified by hand, not by machine". This is the machine.
 *
 * It checks the two things a print can plausibly break, and it checks them in
 * **dark mode as well as light**, because that is where the failure would be:
 * `globals.css` forces a white page under `@media print`, and if the app's colour
 * tokens are still the dark-theme values at that moment, grey-on-white becomes
 * near-white-on-white and the section quietly disappears from the page a woman
 * hands to her doctor.
 *
 *   1. The derived section is still in the print layout, with its dashed border.
 *   2. Its border and its text are legible against the paper — measured by
 *      compositing every alpha layer down to the page background rather than
 *      reading one `backgroundColor` (STATE.md: a semi-transparent background read
 *      without its alpha reported 3.09:1 for a badge that is actually 5.4–8.9:1).
 *
 * It also writes the real PDF, so the artefact exists to look at.
 *
 *   node scripts/dev/print-check.mjs [--out DIR]
 *
 * Needs the app running on :3000 and `apps/web/.env.local` for Supabase.
 */
// Resolved by path, the way `seed-and-shoot.mjs` does: this script runs from the
// repo root, where Playwright is not a dependency — it lives in `apps/web`.
import { chromium } from "../../apps/web/node_modules/@playwright/test/index.mjs";
import { mkdirSync, readFileSync } from "node:fs";
import { join } from "node:path";

const args = Object.fromEntries(
  process.argv.slice(2).reduce((acc, a, i, arr) => {
    if (a.startsWith("--")) acc.push([a.slice(2), arr[i + 1]]);
    return acc;
  }, []),
);
const OUT = args.out ?? "screenshots";
const BASE = "http://localhost:3000";
mkdirSync(OUT, { recursive: true });

const env = Object.fromEntries(
  readFileSync("apps/web/.env.local", "utf8")
    .split(/\r?\n/)
    .filter((l) => l && !l.startsWith("#") && l.includes("="))
    .map((l) => [l.slice(0, l.indexOf("=")).trim(), l.slice(l.indexOf("=") + 1).trim()]),
);
const SB = env.NEXT_PUBLIC_SUPABASE_URL;
const KEY = env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY;

const labels = JSON.parse(readFileSync("apps/web/messages/en.json", "utf8"));
// Read from the catalog the buttons render from, never guessed (STATE.md).
const NEXT = labels.onboarding.nav.next;
const START = labels.onboarding.confirm.start;

let failures = 0;
const check = (name, ok, detail = "") => {
  console.log(`  ${ok ? "ok  " : "FAIL"}  ${name}${detail ? ` — ${detail}` : ""}`);
  if (!ok) failures += 1;
};

async function onboard(page) {
  await page.goto(`${BASE}/en/welcome`, { waitUntil: "networkidle", timeout: 180_000 });
  await page.getByRole("radio").nth(1).click();
  const band = page.getByRole("button", { name: /^25–34$/ });
  if (await band.count()) await band.first().click();
  for (let i = 0; i < 6; i += 1) {
    const btn = page.getByRole("button", { name: NEXT, exact: true });
    if ((await btn.count()) === 0) break;
    await btn.first().click();
    await page.waitForTimeout(700);
  }
  await page.getByRole("button", { name: START, exact: true }).click();
  await page.waitForURL(/dashboard/, { timeout: 90_000 });
  await page.waitForTimeout(1200);
}

async function seed(context, page) {
  const cookies = (await context.cookies())
    .filter((c) => /auth-token(\.\d+)?$/.test(c.name))
    .sort((a, b) => a.name.localeCompare(b.name));
  let raw = cookies.map((c) => c.value).join("");
  if (raw.startsWith("base64-")) raw = Buffer.from(raw.slice(7), "base64").toString("utf8");
  const jwt = JSON.parse(raw).access_token;
  const uid = JSON.parse(Buffer.from(jwt.split(".")[1], "base64").toString("utf8")).sub;
  const rows = [16, 44, 72].map((back) => {
    const d = new Date();
    d.setDate(d.getDate() - back);
    return { profile_id: uid, period_start: d.toISOString().slice(0, 10), flow: "medium" };
  });
  await page.evaluate(
    async ({ sb, key, token, body }) => {
      await fetch(`${sb}/rest/v1/cycles`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
          apikey: key,
          Prefer: "return=minimal",
        },
        body: JSON.stringify(body),
      });
    },
    { sb: SB, key: KEY, token: jwt, body: rows },
  );
  return jwt;
}

/**
 * Composite every ancestor background down to an opaque colour, then measure.
 *
 * Reading one `backgroundColor` is what produced two false contrast failures in
 * the 2026-08-21 audit: a transparent element reports `transparent` and an
 * `rgba(...)` one has to be blended with what is behind it before any ratio means
 * anything. This runs in the page so it sees the print-media cascade.
 */
/**
 * A real function, not a string.
 *
 * It was a template literal first, and `page.evaluate` treats a string first
 * argument as an **expression** rather than a function body — so the selector was
 * never passed, the expression evaluated to an unserialisable function, and every
 * assertion read `undefined` and failed. Written up unchecked that would have been
 * "the derived section does not survive a print", a product defect that does not
 * exist. Ninth measurement artifact in this workstream; caught by dumping the DOM
 * before believing the result.
 */
function measure(selector) {
  const el = document.querySelector(selector);
  if (!el) return null;

  const parse = (c) => {
    const m = c.match(/rgba?\(([^)]+)\)/);
    if (!m) return null;
    const p = m[1].split(",").map((n) => parseFloat(n.trim()));
    return { r: p[0], g: p[1], b: p[2], a: p.length > 3 ? p[3] : 1 };
  };
  const over = (fg, bg) => ({
    r: fg.r * fg.a + bg.r * (1 - fg.a),
    g: fg.g * fg.a + bg.g * (1 - fg.a),
    b: fg.b * fg.a + bg.b * (1 - fg.a),
    a: 1,
  });
  const lum = ({ r, g, b }) => {
    const f = (v) => {
      const s = v / 255;
      return s <= 0.03928 ? s / 12.92 : Math.pow((s + 0.055) / 1.055, 2.4);
    };
    return 0.2126 * f(r) + 0.7152 * f(g) + 0.0722 * f(b);
  };
  const ratio = (a, b) => {
    const [hi, lo] = [lum(a), lum(b)].sort((x, y) => y - x);
    return (hi + 0.05) / (lo + 0.05);
  };

  // Walk down from the root compositing every layer onto white, which is what the
  // paper is. Elements painting a gradient are skipped: they report a transparent
  // `backgroundColor` and measuring through them invents a defect (STATE.md).
  let bg = { r: 255, g: 255, b: 255, a: 1 };
  const chain = [];
  for (let n = el; n; n = n.parentElement) chain.unshift(n);
  for (const n of chain) {
    const cs = getComputedStyle(n);
    if (cs.backgroundImage && cs.backgroundImage !== "none") continue;
    const c = parse(cs.backgroundColor);
    if (c && c.a > 0) bg = over(c, bg);
  }

  const cs = getComputedStyle(el);
  const box = el.getBoundingClientRect();
  const heading = el.querySelector("h2");
  const border = parse(cs.borderTopColor);
  const text = heading ? parse(getComputedStyle(heading).color) : null;

  return {
    visible: box.width > 0 && box.height > 0,
    width: Math.round(box.width),
    height: Math.round(box.height),
    display: cs.display,
    borderStyle: cs.borderTopStyle,
    borderWidth: cs.borderTopWidth,
    borderColor: cs.borderTopColor,
    headingText: heading ? heading.textContent.trim() : null,
    headingColor: heading ? getComputedStyle(heading).color : null,
    bg: `rgb(${Math.round(bg.r)}, ${Math.round(bg.g)}, ${Math.round(bg.b)})`,
    borderRatio: border ? Number(ratio(over(border, bg), bg).toFixed(2)) : null,
    headingRatio: text ? Number(ratio(over(text, bg), bg).toFixed(2)) : null,
  };
}

const DERIVED = "main section.border-dashed";

const browser = await chromium.launch();
for (const scheme of ["light", "dark"]) {
  console.log(`\n${scheme} →`);
  const context = await browser.newContext({
    viewport: { width: 390, height: 844 },
    colorScheme: scheme,
  });
  const page = await context.newPage();
  try {
    await onboard(page);
    await seed(context, page);

    await page.goto(`${BASE}/en/summary`, { waitUntil: "networkidle" });
    // The summary reads its own data in the browser (ADR-048), so `networkidle`
    // only means the document arrived. Wait for the section itself rather than a
    // fixed timeout — a skeleton measured as "absent" would be a tool bug reported
    // as a product defect, which is the failure mode this workstream keeps hitting.
    await page.waitForSelector(DERIVED, { timeout: 30_000 }).catch(() => {});

    const onScreen = await page.evaluate(measure, DERIVED);
    check("the derived section exists on screen", Boolean(onScreen?.visible),
      onScreen ? "" : `url=${page.url()} · ${(await page.evaluate(() => document.body.innerText)).slice(0, 120).replace(/\s+/g, " ")}`);

    // The whole point: the print cascade, not the screen one.
    await page.emulateMedia({ media: "print" });
    await page.waitForTimeout(400);
    const printed = await page.evaluate(measure, DERIVED);

    check("the derived section survives into the print layout", Boolean(printed?.visible),
      printed ? `${printed.width}×${printed.height}, display ${printed.display}` : "absent");
    check("its heading survives", Boolean(printed?.headingText), printed?.headingText ?? "");
    check("the border is still dashed", printed?.borderStyle === "dashed",
      `${printed?.borderStyle} ${printed?.borderWidth}`);
    check("the page prints on white", printed?.bg === "rgb(255, 255, 255)", printed?.bg);
    // 3:1 is the WCAG 1.4.11 bar for a non-text boundary; the heading is text.
    check("the dashed border is visible against the paper", (printed?.borderRatio ?? 0) >= 3,
      `${printed?.borderRatio}:1 (${printed?.borderColor})`);
    check("the derived heading is legible against the paper", (printed?.headingRatio ?? 0) >= 4.5,
      `${printed?.headingRatio}:1 (${printed?.headingColor})`);

    await page.pdf({
      path: join(OUT, `visit-summary-${scheme}.pdf`),
      format: "A4",
      printBackground: true,
    });
    await page.screenshot({ path: join(OUT, `visit-summary-print-${scheme}.png`), fullPage: true });
  } catch (cause) {
    check(`${scheme} run completed`, false, String(cause).slice(0, 200));
  }
  await context.close();
}
await browser.close();

console.log(failures === 0 ? "\nprint-check: PASS" : `\nprint-check: ${failures} FAILURE(S)`);
process.exit(failures === 0 ? 0 : 1);
