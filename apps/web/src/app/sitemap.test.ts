import { describe, expect, it } from "vitest";
import sitemap from "./sitemap";
import { siteConfig } from "@/lib/seo/config";

// The sitemap reads the content snapshot in the repo, so this runs offline.
describe("sitemap", () => {
  it("never submits a page that is marked noindex", async () => {
    const urls = (await sitemap()).map((e) => e.url);
    // The five condition hubs and the six English teen guides are drafts (`noindex`).
    expect(urls.some((u) => /\/conditions\/pcos$/.test(u))).toBe(false);
    expect(urls.some((u) => /\/en\/learn\/what-is-a-period$/.test(u))).toBe(false);
    // A published guide is still there, in every locale it exists in.
    expect(urls).toContain(`${siteConfig.baseUrl}/en/learn/pcos`);
  });

  it("carries x-default in every hreflang cluster and omits lastmod it cannot vouch for", async () => {
    const entries = await sitemap();
    for (const e of entries) {
      expect(e.alternates?.languages?.["x-default"]).toBeTruthy();
    }
    const about = entries.find((e) => e.url.endsWith("/en/about"));
    expect(about?.lastModified).toBeUndefined();
  });
});
