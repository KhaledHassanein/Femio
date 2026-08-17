import { describe, expect, it } from "vitest";
import { PERSONA_RECORDS } from "./registry";
import {
  ARTICLE_FOR_TOPIC,
  NO_ARTICLE_YET,
  READING_LIST_LIMIT,
  articleSlugsFor,
} from "./reading";

const foregroundTopics = [
  ...new Set(PERSONA_RECORDS.flatMap((r) => [...r.content.foreground])),
];

describe("the reading list mapping", () => {
  /**
   * The rule that makes this file worth having. Every topic a persona foregrounds
   * is either answered by an article or counted as missing — the `UNIMPLEMENTED`
   * idiom, for the same reason: R2.5 shipped a track whose hero id was listed and
   * never asked for, and a listed id was the only reason anyone found it.
   */
  it("accounts for every topic any persona foregrounds", () => {
    const unaccounted = foregroundTopics.filter(
      (t) => !(t in ARTICLE_FOR_TOPIC) && !NO_ARTICLE_YET.includes(t),
    );
    expect(unaccounted).toEqual([]);
  });

  /** The inverse: a stale entry here would quietly promise content nobody wants. */
  it("lists nothing that no persona asks for", () => {
    const known = new Set(foregroundTopics);
    expect(Object.keys(ARTICLE_FOR_TOPIC).filter((t) => !known.has(t))).toEqual([]);
    expect(NO_ARTICLE_YET.filter((t) => !known.has(t))).toEqual([]);
  });

  it("never claims a topic twice", () => {
    expect(NO_ARTICLE_YET.filter((t) => t in ARTICLE_FOR_TOPIC)).toEqual([]);
  });

  it("keeps the personas' order and drops what is unwritten", () => {
    expect(articleSlugsFor(["when-to-seek-care", "week-by-week", "recovery-after-birth"])).toEqual([
      "postpartum-warning-signs",
      "postpartum-recovery-first-six-weeks",
    ]);
  });

  it("de-duplicates when two topics resolve to one article", () => {
    expect(articleSlugsFor(["when-to-seek-care", "when-to-seek-care"])).toEqual([
      "postpartum-warning-signs",
    ]);
  });

  it("answers an empty foreground with nothing rather than a default", () => {
    expect(articleSlugsFor([])).toEqual([]);
  });

  /**
   * Track E is the reason this shipped, so it is pinned rather than left to the
   * general rule: a woman weeks after birth should reach recovery, the warning
   * signs and her mood from the dashboard without going looking.
   */
  it("gives the postpartum spine a real shelf", () => {
    const e1 = PERSONA_RECORDS.find((r) => r.id === "E1")!;
    expect(articleSlugsFor(e1.content.foreground)).toEqual([
      "postpartum-recovery-first-six-weeks",
      "postpartum-warning-signs",
      "mood-after-birth",
      "bleeding-after-birth",
      "six-week-postnatal-check",
      "periods-after-birth",
    ]);
  });

  /**
   * E6 is the loss layer, and the one place where the wrong article is worse than
   * no article. Nothing about feeding may reach it — E2 is gated on a stated live
   * birth for the same reason (P2.3).
   */
  it("puts no feeding content in front of a loss", () => {
    const e6 = PERSONA_RECORDS.find((r) => r.id === "E6")!;
    const slugs = articleSlugsFor([...e6.content.foreground]);
    expect(slugs.some((s) => s.includes("breastfeed"))).toBe(false);
  });

  /**
   * The same rule, for the set that made it urgent (P2.13c).
   *
   * `foreground` merges additively up `extends` and **E6 extends E1**, so the guard
   * that keeps newborn content away from a woman after a loss is not a comment on a
   * registry record — it is this. It resolves E6 the way the engine does, through the
   * whole inheritance chain, rather than reading E6's own list. If someone later adds
   * a newborn topic to E1 because E1 is obviously where a mother of a newborn lives,
   * this fails, and that is the entire point.
   */
  it("puts no newborn content in front of a loss, through the whole extends chain", () => {
    const chain: string[] = [];
    let record = PERSONA_RECORDS.find((r) => r.id === "E6");
    while (record) {
      chain.unshift(...record.content.foreground);
      record = record.extends ? PERSONA_RECORDS.find((r) => r.id === record!.extends) : undefined;
    }
    const slugs = articleSlugsFor(chain);
    expect(slugs.filter((s) => s.startsWith("newborn-") || s === "feeding-your-newborn")).toEqual(
      [],
    );
    expect(slugs.some((s) => s.includes("safer-sleep") || s.includes("bottle"))).toBe(false);
  });

  /**
   * E2's shelf, pinned like E1's. The order is the persona's ask: two pages about
   * her own feeding, then the baby's side of it, then the one newborn page that must
   * be one tap away. `mastitis-and-blocked-ducts` is still unwritten and drops out,
   * which is what the card is supposed to do with an unanswered topic.
   */
  it("gives the feeding layer the baby's side of feeding, and the warning signs", () => {
    const e2 = PERSONA_RECORDS.find((r) => r.id === "E2")!;
    expect(articleSlugsFor(e2.content.foreground)).toEqual([
      "breastfeeding-first-two-weeks",
      "when-breastfeeding-is-not-working",
      "feeding-your-newborn",
      "newborn-warning-signs",
      "bottle-and-formula-feeding",
    ]);
  });

  it("caps a card at four links", () => {
    expect(READING_LIST_LIMIT).toBe(4);
  });
});
