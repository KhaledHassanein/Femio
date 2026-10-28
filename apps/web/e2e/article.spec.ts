import { expect, test } from "@playwright/test";

// Article template (R2.3): red-flag box, honest review line, app hand-off card.
// `pregnancy-warning-signs` names a reviewer; `age-and-fertility` does not (the snapshot
// is the source of truth; 25 of 100 articles carry a named reviewer).
const REVIEWED = "/en/learn/pregnancy-warning-signs";
const UNREVIEWED = "/en/learn/age-and-fertility";

test("a 'Seek care now:' quote renders as the danger red-flag box with an icon", async ({ page }) => {
  await page.goto(REVIEWED);
  const box = page.getByTestId("red-flag-box").first();
  await expect(box).toBeVisible();
  await expect(box).toContainText(/seek care now:/i);
  await expect(box.locator("svg")).toHaveCount(1);
  // It is a box, not a plain blockquote.
  await expect(page.locator("article blockquote")).toHaveCount(0);
});

test("an article with a named reviewer says who reviewed it and when", async ({ page }) => {
  await page.goto(REVIEWED);
  await expect(page.getByText(/^Reviewed by Dr\. Khaled M\., MBBCh, CPC, /)).toBeVisible();
  await expect(page.getByText(/editorially checked/i)).toHaveCount(0);
});

test("an article without a reviewer says clinician review is pending, never 'reviewed'", async ({ page }) => {
  await page.goto(UNREVIEWED);
  await expect(page.getByText("Editorially checked · clinician review pending")).toBeVisible();
  await expect(page.getByText(/clinician reviewed|reviewed by/i)).toHaveCount(0);
});

test("every article ends with the app hand-off card", async ({ page }) => {
  await page.goto(UNREVIEWED);
  const card = page.getByRole("complementary").filter({ hasText: /track this automatically/i });
  await expect(card).toBeVisible();
  await expect(card.getByRole("link", { name: /what the app does/i })).toHaveAttribute("href", "/en/app");
});

test("the Arabic article page keeps the card and the English-only notice", async ({ page }) => {
  await page.goto("/ar/learn/age-and-fertility");
  await expect(page.locator("html")).toHaveAttribute("dir", "rtl");
  await expect(page.getByRole("complementary").filter({ has: page.getByRole("link") })).toBeVisible();
});

test("the guide and conditions subtitles no longer claim every guide is clinician-reviewed", async ({ page }) => {
  await page.goto("/en/learn");
  await expect(page.getByText(/each reviewed by a clinician/i)).toHaveCount(0);
  await expect(page.getByText(/says whether a clinician has reviewed it/i).first()).toBeVisible();
});
