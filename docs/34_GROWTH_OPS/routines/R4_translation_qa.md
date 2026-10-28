# R4 · Translation and register QA (Haiku, `femio-translator`, on every content PR)

## Read first
`CLAUDE.md`, the skill `femio-i18n-workflow`, the glossary and register decisions in
`docs/content/reviews/2026-10-28-arabic-editor-pass.md`, and the PR's two files.

## Checks
1. **Parity:** walk the English and Arabic paragraph by paragraph. Every fact, number, source
   and safety sentence present in one is present in the other. A missing red-flag line is a
   fail, not a note.
2. **Register:** *العلاقة الزوجية* (never *جماع* or *علاقة حميمة*); *طبيبتكِ أو طبيبكِ*; no
   sexual-wellness content; femio is masculine; Western digits; agreement (المنتظمة، مؤلمة).
3. **Glossary:** each medical term uses the glossary Arabic with the lay alias once at first
   mention; Latin acronyms (PCOS) only in titles and at first mention, then the Arabic term.
4. **Labels:** the two fixed labels appear in the right language.
5. **Wordmark:** Latin lowercase `femio` in Arabic text.
6. **Links:** Arabic internal links point at `/ar/...`.

## Output
One PR comment with a table: `file | line | current | proposed | reason`. Propose, never edit.

## Rubric (lead)
Every proposed row is a real change (no restatements); accepted rows are applied by the lead
with the same commit discipline as R2.
