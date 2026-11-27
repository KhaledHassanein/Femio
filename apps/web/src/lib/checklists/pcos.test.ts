// The PCOS visit checklist's two promises (R13.6): every line is the wording of a cited
// femio guide in that language, and the page never scores, stores or sends anything.
import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";
import { PCOS_EXPERIENCES, PCOS_QUESTIONS, pcosChecklistGuides } from "./pcos";
import ar from "../../../messages/ar.json";
import en from "../../../messages/en.json";
import es from "../../../messages/es.json";
import fr from "../../../messages/fr.json";

const CATALOGUES = { en, ar, fr, es } as const;
type Locale = keyof typeof CATALOGUES;
const LOCALES = Object.keys(CATALOGUES) as Locale[];

const WEB = join(__dirname, "../../..");
const ARTICLES = join(WEB, "../../docs/content/articles");

/** Prose only: links reduced to their text, marks and final punctuation removed. */
function plain(text: string): string {
  return text
    .replace(/<\/?help>/g, "")
    .replace(/\[([^\]]+)\]\([^)]*\)/g, "$1")
    .replace(/\*\*|^>\s*/gm, "")
    .replace(/[’']/g, "'")
    .replace(/\s+/g, " ")
    .trim()
    .toLocaleLowerCase("en");
}
const line = (text: string) => plain(text).replace(/\s*[.]$/, "");

function guide(slug: string, locale: Locale): string {
  const file = locale === "en" ? `${slug}.md` : `${slug}.${locale}.md`;
  // The body only: a title or a meta description is not the guide's text.
  return plain(readFileSync(join(ARTICLES, file), "utf8").replace(/^---[\s\S]*?\n---/, ""));
}

describe("PCOS visit checklist", () => {
  for (const locale of LOCALES) {
    const t = CATALOGUES[locale].pcosChecklist;
    const sections = [
      { groups: PCOS_EXPERIENCES, headings: t.experienceGroups, texts: t.experiences },
      { groups: PCOS_QUESTIONS, headings: t.questionGroups, texts: t.questions },
    ];

    it(`${locale}: every line is in the guide it names`, () => {
      for (const { groups, headings, texts } of sections) {
        const keys = groups.flatMap((g) => g.lines.map((l) => l.key));
        expect(Object.keys(texts).sort()).toEqual([...keys].sort());
        expect(Object.keys(headings)).toEqual(groups.map((g) => g.key));
        for (const { key, guide: slug } of groups.flatMap((g) => g.lines)) {
          const text = (texts as Record<string, string>)[key] ?? "";
          expect(text, key).not.toBe("");
          expect(guide(slug, locale), `${key} in ${slug}`).toContain(line(text));
        }
      }
    });

    it(`${locale}: the safety and context notes quote their guides`, () => {
      const signs = guide("pcos-signs", locale);
      for (const text of [t.note, t.rapid, t.urgentBody]) expect(signs).toContain(line(text));
      expect(guide("pcos-hair-skin-and-mood", locale)).toContain(line(t.urgentMood));
    });
  }

  it("quotes only published guides", () => {
    for (const slug of pcosChecklistGuides()) {
      for (const locale of LOCALES) {
        const file = locale === "en" ? `${slug}.md` : `${slug}.${locale}.md`;
        expect(readFileSync(join(ARTICLES, file), "utf8"), file).toMatch(/^status: "published"$/m);
      }
    }
  });

  it("computes, stores and sends nothing", () => {
    const sources = [
      "src/components/checklists/pcos-visit-checklist.tsx",
      "src/components/checklists/print-button.tsx",
      "src/app/[locale]/(public)/conditions/pcos/visit-checklist/page.tsx",
    ].map((f) => readFileSync(join(WEB, f), "utf8"));
    for (const source of sources) {
      expect(source).not.toMatch(
        /localStorage|sessionStorage|indexedDB|document\.cookie|fetch\(|sendBeacon|useState|useReducer|useRef|onChange|<form|track\(/,
      );
    }
  });

  it("never words a result", () => {
    const text = JSON.stringify(en.pcosChecklist).toLowerCase();
    expect(text).not.toMatch(/you (may|might|could|probably) have|\bscore|\brisk level|your result/);
    expect(en.pcosChecklist.intro).toBe("A list to bring to your clinician; it is not a test.");
  });
});
