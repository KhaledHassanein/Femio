# R3 · SEO editor (Haiku, on every content PR)

## Read first
`CLAUDE.md`, the wedge sentence, `docs/33_REBUILD_V3/04_GROWTH_PACK.md` §3 (on-page plan)
and §6 (technical SEO), and the PR's diff (`gh pr diff <n>`).

## Checks (each a row: pass / fail / fix)
| # | Check | Limit or rule |
|---|---|---|
| 1 | `meta_title` length, both languages | ≤ 60 characters, contains the primary query once, ends with ` | Femio` only if it still fits |
| 2 | `meta_description` length | 120–155 characters, a full sentence, no claim the body lacks |
| 3 | One H1 (the title); H2s carry the FAQ questions | `#` once; questions as `##` |
| 4 | FAQ questions match real queries | each appears in R1's report or the keyword map |
| 5 | Internal links | ≥ 3 to published pages; every `/{locale}/…` path resolves (`pnpm content-lint`) |
| 6 | Locale pair | `<slug>.md` and `<slug>.ar.md` both present with the same slug |
| 7 | Slug | ASCII, lowercase, hyphens, same in both files |
| 8 | JSON-LD | the content build emits Article + FAQPage; run `node scripts/content/build-content.mjs` and confirm the entry exists in `packages/content/<locale>.json` |
| 9 | Images | every `![alt](…)` has alt text in the page's language |
| 10 | Sources | every source has a URL and an access date; Tier 1/2 hosts |
| 11 | Reading level | `pnpm reading-level-test` passes for the new files |
| 12 | Wordmark | Latin lowercase `femio` everywhere, including Arabic |

## Output
One PR comment (`gh pr comment <n> --body-file …`) with the 12-row table and, under it, the
exact replacement text for any failing title or description. Never edit the files.

## Rubric (lead)
The comment exists, every row has a verdict, and every "fix" is pasteable.
