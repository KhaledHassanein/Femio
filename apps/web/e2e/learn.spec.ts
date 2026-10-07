import { expect, test } from "@playwright/test";

// Learn hub (P1.6.2, v3 P2.4). Content is built in from the repo snapshot (D3), so
// this needs no network and checks the real library, not an empty state.
test("learn hub renders the library in rows, with search and question chips", async ({ page }) => {
  await page.goto("/en/learn");
  await expect(page.getByRole("heading", { name: /^learn$/i })).toBeVisible();
  await expect(page.getByRole("search")).toBeVisible();
  await expect(page.getByRole("heading", { level: 2, name: /^trying to conceive$/i })).toBeVisible();
  // A question chip leads to its guide.
  await page.getByRole("link", { name: /when am i most fertile/i }).click();
  await expect(page).toHaveURL(/\/en\/learn\/fertile-window-explained$/);
});

test("home surfaces the library and links to the learn hub", async ({ page }) => {
  await page.goto("/en");
  // Content-first homepage: the library section is still reachable from it
  // (product rule 2), now as a list below the life-stage rail (R1.3).
  await expect(page.getByRole("heading", { name: /start reading now/i })).toBeVisible();
  await page.getByRole("link", { name: /^learn/i }).first().click();
  await expect(page).toHaveURL(/\/en\/learn$/);
});

test("conditions hub renders (empty state when no CMS content)", async ({ page }) => {
  await page.goto("/en/conditions");
  await expect(page.getByRole("heading", { name: /conditions & topics/i })).toBeVisible();
  await expect(page.getByText(/new topics are on the way|guides to conditions/i).first()).toBeVisible();
});

test("faq and glossary pages render", async ({ page }) => {
  await page.goto("/en/faq");
  await expect(page.getByRole("heading", { name: /frequently asked questions/i })).toBeVisible();
  await page.goto("/en/glossary");
  await expect(page.getByRole("heading", { name: /^glossary$/i })).toBeVisible();
});

test("trust pages render and are linked from the footer", async ({ page }) => {
  await page.goto("/en/about");
  await expect(page.getByRole("heading", { name: /about femio/i })).toBeVisible();
  await page.getByRole("contentinfo").getByRole("link", { name: /editorial policy/i }).click();
  await expect(page).toHaveURL(/\/en\/editorial-policy$/);
  await expect(page.getByRole("heading", { name: /editorial policy/i })).toBeVisible();
  await page.goto("/en/medical-review");
  await expect(page.getByRole("heading", { name: /how we review content/i })).toBeVisible();
});

test("persistent header nav lets you move between content pages", async ({ page }) => {
  await page.goto("/en/learn");
  await page.getByRole("banner").getByRole("link", { name: /^conditions$/i }).click();
  await expect(page).toHaveURL(/\/en\/conditions$/);
  // Footer is present on content pages too.
  await expect(page.getByRole("contentinfo")).toBeVisible();
});
