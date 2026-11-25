// Validates the reading-level guard against passages with known scores, so the number
// in the gate means what it says. Run: node --test scripts/content/reading-level.test.mjs
import assert from "node:assert/strict";
import { test } from "node:test";
import { fleschKincaidGrade, proseOf, syllables } from "./reading-level.mjs";

// Known limit of the heuristic: a vowel pair that is two syllables ("period", "create") counts as one.
test("syllable counter on common words", () => {
  const cases = { the: 1, cat: 1, ovulation: 4, pregnancy: 3, doctor: 2, table: 2, cycle: 2, irregular: 4, estimate: 3, honest: 2, simple: 2, baked: 1, cheese: 1, every: 3 };
  for (const [word, n] of Object.entries(cases)) assert.equal(syllables(word), n, word);
});

test("a plain passage scores in the single digits", () => {
  // Nine short sentences of everyday words: a grade-school passage.
  const text = "The cat sat on the mat. It was warm. The sun came in. She slept all day. Then she woke up. She wanted food. The bowl was full. She ate it all. Then she slept again.";
  const r = fleschKincaidGrade(text);
  assert.ok(r.grade < 2, `grade ${r.grade}`);
});

test("a dense clinical passage scores well above the ceiling", () => {
  const text =
    "Polycystic ovary syndrome represents a heterogeneous endocrinological condition characterised by hyperandrogenism, oligo-anovulation and polycystic ovarian morphology, with substantial metabolic comorbidity including insulin resistance and dyslipidaemia.";
  const r = fleschKincaidGrade(text);
  assert.ok(r.grade > 15, `grade ${r.grade}`);
});

test("the formula matches a hand-computed example", () => {
  // 12 words, 2 sentences, 13 syllables (to-day is the only two-syllable word):
  // 0.39*6 + 11.8*(13/12) - 15.59 = -0.47
  const text = "I like to read a book. We walk to the park today.";
  const r = fleschKincaidGrade(text);
  assert.equal(r.words, 12);
  assert.equal(r.sentences, 2);
  assert.ok(Math.abs(r.grade - -0.5) < 0.15, `grade ${r.grade}`);
});

test("prose extraction drops front matter, headings, tables and link targets", () => {
  const md = "---\ntitle: x\n---\n# Heading\n\nA [link](https://a.b) here.\n\n| a | b |\n|---|---|\n\n- A bullet.\n";
  assert.equal(proseOf(md), "A link here. A bullet.");
});

test("a sentence that starts with the lowercase wordmark is still a sentence", () => {
  const r = fleschKincaidGrade("Log your period. femio shows a range. It is an estimate.");
  assert.equal(r.sentences, 3);
});
