# Return handover — Arabic, French, and Spanish content translation

## What was produced

`docs/content/GLOSSARY_TERMS.md` was produced as the terminology source of truth. No localized article or condition draft was retained. The working output therefore contains **0 Arabic files, 0 French files, and 0 Spanish files** in `docs/content/articles/`; all **315 requested drafts** remain.

The translation run stopped before the first condition page because every available translation engine failed a fixed medical-safety gate. Experimental `endometriosis.fr.md` and `endometriosis.es.md` outputs were removed after manual comparison found clinically or linguistically unsafe wording. They were untracked working outputs and are not recoverable from Git; the English source was never changed. No Arabic draft reached the write stage.

The following 105 slugs remain in each of `ar`, `fr`, and `es`:

```text
afterpains-after-birth, age-and-fertility, bleeding-after-birth, bottle-and-formula-feeding, breastfeeding-first-two-weeks, choosing-period-products, contraception-after-birth, early-pregnancy-changes, endometriosis, endometriosis-and-fertility, endometriosis-signs, feeding-your-newborn, fertile-window-explained, fertility-tests-what-to-expect, first-pregnancy-appointment, getting-ready-for-your-first-period, heavy-periods, heavy-periods-iron-deficiency-anaemia, how-endometriosis-is-assessed, how-painful-periods-are-assessed, how-pcos-is-assessed, how-to-track-menstrual-cycle, irregular-cycles-and-timing, is-my-period-normal, meet-femio, menopause-care-options, menopause-explained, menstrual-cycle-basics, mood-after-birth, newborn-checks-and-vaccinations, newborn-crying, newborn-first-two-weeks, newborn-nappies-skin-and-cord, newborn-warning-signs, painful-periods, pcos, pcos-and-fertility, pcos-signs, pelvic-floor-after-birth, perimenopause-explained, period-at-school, period-myths-checked, period-pain-care-options, period-pain-in-teens, periods-after-birth, pms-pmdd, postmenopausal-bleeding, postpartum-recovery-first-six-weeks, postpartum-warning-signs, postpartum-wound-healing, preconception-appointment, pregnancy-basics, pregnancy-warning-signs, pregnancy-week-10, pregnancy-week-11, pregnancy-week-12, pregnancy-week-13, pregnancy-week-14, pregnancy-week-15, pregnancy-week-16, pregnancy-week-17, pregnancy-week-18, pregnancy-week-19, pregnancy-week-20, pregnancy-week-21, pregnancy-week-22, pregnancy-week-23, pregnancy-week-24, pregnancy-week-25, pregnancy-week-26, pregnancy-week-27, pregnancy-week-28, pregnancy-week-29, pregnancy-week-30, pregnancy-week-31, pregnancy-week-32, pregnancy-week-33, pregnancy-week-34, pregnancy-week-35, pregnancy-week-36, pregnancy-week-37, pregnancy-week-38, pregnancy-week-39, pregnancy-week-4, pregnancy-week-40, pregnancy-week-5, pregnancy-week-6, pregnancy-week-7, pregnancy-week-8, pregnancy-week-9, safer-sleep-for-your-baby, sex-after-birth, six-week-postnatal-check, sleep-and-exhaustion-after-birth, thyroid-and-conceiving, tracking-your-cycle-as-a-teen, track-perimenopause-symptoms, track-pms-pmdd-symptoms, trying-to-conceive-guide, what-is-a-period, whats-changing-in-my-body, when-breastfeeding-is-not-working, when-to-seek-fertility-help, when-to-take-pregnancy-test, when-to-tell-an-adult
```

## Terminology list

The terminology list is `docs/content/GLOSSARY_TERMS.md`. It contains **111 unique medical terms**, one preferred rendering in Arabic, French, and Spanish for each term, and a plain-English reader-facing definition. Target-language cells contain no slash-separated alternatives. “Blood clot” and “thrombosis” were separated because they are related but not interchangeable concepts.

The first clinical terminology review should check these judgment calls. Arabic distinguishes amenorrhoea as `انقطاع الحيض` from menopause as `انقطاع الطمث`; endometriosis is `الانتباذ البطاني الرحمي`; PCOS is `متلازمة المبيض المتعدد الكيسات`; PMDD is `الاضطراب المزعج السابق للحيض`; lochia is the formal `الهُلابة`; and pre-eclampsia is `مقدمات الارتعاج`. The glossary uses `العقم` for infertility and the single Arabic term `الحيض` for “menstrual period / period.” French uses `post-partum`, and Spanish uses `posparto`, as the single rendering for “postnatal / postpartum.” These choices are defensible medical terms, but they should be checked against Femio's intended regional audience before use across the full library.

## Uncertainties and reviewer worklist

No translated sentence remains in the repository, so there is no retained sentence-level hedge worklist. The rejected safety samples establish the main risks a future translator must explicitly test. Smaller multilingual instruction models changed “severe headache” in Spanish, strengthened self-harm language in French, and used masculine Arabic address. Dedicated machine-translation models omitted complete clauses when translating multi-sentence medical paragraphs. Sentence-by-sentence translation prevented the omissions but still produced errors such as Spanish `dátiles` for calendar “dates,” a literal “keyhole” rendering for keyhole surgery, mixed `tú` and `usted`, an untranslated English term in French, and awkward fertility-referral language.

The Arabic-specific X-ALMA model also failed. It used masculine imperatives for “discuss,” “read,” and “seek”; sometimes treated the feminine-address cue as part of the medical sentence; added the word “code” before a protected link placeholder; and changed “feel faint” to “feel dizzy.” Those are meaning, urgency, routing, and register failures, not stylistic defects. Glossary substitution could correct a condition name, but it could not safely repair the changed claims or reader address.

## What was not done, and why

No article or condition translation was retained because none of the tested automated paths was safe enough to inherit the English clinical approval. Continuing would have converted known, reproducible medical mistranslation into 315 apparently complete drafts. Manual translation of approximately 115,000 English source words into three languages was not feasible within this run without native medical translators.

No CMS import, dry run, approval update, publication, source substitution, slug change, or internal-link target change was attempted. The experimental generator and its Python cache were removed so that an unsafe pipeline is not mistaken for an approved repository tool.

There is also a receiving-side importer defect to resolve before condition translations can be imported: `apps/cms/scripts/import-translations.mjs` hard-codes the `articles` collection, so translated condition pillars would not be routed to `conditions`.

## State of the checks

`pnpm content-lint` passes:

```text
✓ Content guard: 105 draft(s) conform to the authoring brief (run with --check-urls to resolve sources).
```

This result covers the existing 105 English drafts. It does not validate translated files because none remain, and therefore there were no non-English reading-level findings to accept or reject. The glossary was separately checked to contain 111 unique rows and no target-language cell with slash-separated alternatives.

## What the receiving project must do next

First, have Arabic-, French-, and Spanish-speaking medical translators review and lock the 111 glossary choices, starting with the judgment calls above. Second, translate the five condition pillars in the mandated order and compare every sentence against the English source, with a separate explicit pass for negation, diagnostic hedges, fertility statements, self-harm language, and urgent-care instructions. Third, fix and test condition routing in `apps/cms/scripts/import-translations.mjs` before attempting any condition import. Fourth, run `pnpm content-lint` after each small batch and independently verify frontmatter parity, source order and URLs, numerals, Markdown links, slugs, and internal-link targets. Fifth, continue with first-session content, then all urgent-care content, then the remainder, using the exact priority order in `docs/content/HANDOVER_TRANSLATION.md`.

Nothing in this handover is marked reviewed, approved, ready to import, or ready to publish.
