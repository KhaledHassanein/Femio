import { expect, type Page } from "@playwright/test";

/**
 * Drive the onboarding wizard to the dashboard.
 *
 * This exists because the wizard was being driven by hand in six spec files, and
 * they rotted independently: `mfa`, `offline` and `summary` still clicked
 * `getByRole("button", { name: /tracking my cycle/i })` after the life-stage
 * options became radios, `onboarding` asserted four options against six, and every
 * one of them clicked Continue twice against a four-step wizard. None of it was
 * caught because all six are `@live` and the CI run excludes that tag — so the
 * suite tested a product that no longer existed (docs/26 §1.2, §9).
 *
 * One helper means the next wizard change breaks one file, loudly, instead of six
 * files silently.
 *
 * Deliberately tolerant about *shape* and strict about *outcome*: it advances
 * through however many steps the wizard currently has, but asserts it landed on
 * the dashboard. A step added tomorrow should not fail every spec that merely
 * needs a signed-in session; a wizard that stops reaching the dashboard should
 * fail all of them.
 */
export async function completeOnboarding(
  page: Page,
  options: { stage?: RegExp; locale?: string } = {},
): Promise<void> {
  const { stage = /tracking my cycle/i, locale = "en" } = options;

  await page.goto(`/${locale}/welcome`);

  // Step 1 — life stage. Six options since the teen and postpartum tracks landed.
  await page.getByRole("radio", { name: stage }).click();

  // Age band, when the wizard asks for one. Deliberately answered rather than
  // skipped: `isMinor(null)` is `true` (persona/minor.ts:43), so a session that
  // skips this is treated as a child for the rest of its life and cannot grant
  // analytics or research consent at all. That is the right default for child
  // protection, but it means a skipped age silently changes what the rest of the
  // suite is even allowed to exercise — the consent spec timed out waiting for a
  // write the age gate had already refused. Specs that want the minor path should
  // ask for it explicitly rather than inherit it by omission.
  const adultBand = page.getByRole("button", { name: /^25–34$/ });
  if ((await adultBand.count()) > 0) await adultBand.first().click();

  // Advance while the wizard still offers a Continue. Bounded rather than
  // `while (true)`: a wizard that never finishes should fail the test, not hang
  // it until the 60s timeout with no useful message.
  for (let step = 0; step < 6; step += 1) {
    const next = page.getByRole("button", { name: /^continue$/i });
    if ((await next.count()) === 0) break;
    await next.first().click();
    await page.waitForTimeout(400);
  }

  // Final step — the commit action, which creates the anonymous session.
  await page.getByRole("button", { name: /start using femio/i }).click();

  await expect(page).toHaveURL(new RegExp(`/${locale}/dashboard$`));
}
