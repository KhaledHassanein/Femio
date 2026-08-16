import { describe, expect, it, vi, beforeEach } from "vitest";

const listContent = vi.hoisted(() => vi.fn());
vi.mock("@/lib/cms/client", () => ({ listContent }));

import { GET } from "./route";

/** What the CMS serves an unauthenticated caller: published documents only. */
const published = [
  { slug: "pregnancy-basics", title: "Pregnancy basics" },
  { slug: "postpartum-warning-signs", title: "Postpartum warning signs" },
  { slug: "mood-after-birth", title: "Your mood after birth" },
];

const get = async (query: string) => {
  const res = await GET(new Request(`https://femioapp.com/api/reading${query}`));
  return (await res.json()) as { articles: { slug: string; title: string }[] };
};

beforeEach(() => {
  listContent.mockReset();
  listContent.mockResolvedValue(published);
});

describe("the reading route", () => {
  it("returns the requested articles in the order they were asked for", async () => {
    const { articles } = await get("?slugs=mood-after-birth,pregnancy-basics");
    expect(articles.map((a) => a.slug)).toEqual(["mood-after-birth", "pregnancy-basics"]);
    expect(articles[0]?.title).toBe("Your mood after birth");
  });

  /**
   * The property the whole design rests on. A drafted article is absent from the
   * CMS's answer, so it contributes nothing here — which is what lets a persona
   * foreground an article before a clinician has approved it without the dashboard
   * ever linking to a page that 404s (ADR-032).
   */
  it("cannot surface a slug the CMS is not publishing", async () => {
    const { articles } = await get("?slugs=six-week-postnatal-check,bleeding-after-birth");
    expect(articles).toEqual([]);
  });

  it("answers an empty ask without troubling the CMS", async () => {
    expect((await get("")).articles).toEqual([]);
    expect(listContent).not.toHaveBeenCalled();
  });

  it("ignores anything that is not a slug", async () => {
    const { articles } = await get("?slugs=../../etc/passwd,mood-after-birth,%20");
    expect(articles.map((a) => a.slug)).toEqual(["mood-after-birth"]);
  });

  it("falls back to the default locale rather than trusting the query", async () => {
    await get("?slugs=pregnancy-basics&locale=xx");
    expect(listContent).toHaveBeenCalledWith("articles", "en");
    await get("?slugs=pregnancy-basics&locale=ar");
    expect(listContent).toHaveBeenLastCalledWith("articles", "ar");
  });

  /** A reading card is the least important thing on the screen; it fails quiet. */
  it("returns nothing when the CMS has nothing", async () => {
    listContent.mockResolvedValue([]);
    expect((await get("?slugs=mood-after-birth")).articles).toEqual([]);
  });
});
