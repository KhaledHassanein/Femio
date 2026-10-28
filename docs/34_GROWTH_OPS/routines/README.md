# Growth routines (R6.6)

One file per routine. A routine is a Claude Code scheduled session (`/schedule`) whose
prompt is "Follow `docs/34_GROWTH_OPS/routines/<file>` exactly." Changing a routine is a
commit; nothing is configured only in a dashboard. The design, cadence and rubrics are in
`../03_CONTENT_SEO_AUTOMATION.md`; this folder is the executable form.

| File | Role | Model | Schedule (Cairo) | Output |
|---|---|---|---|---|
| `R1_search_researcher.md` | queries, gaps, refreshes | Sonnet | Mon 07:00 | `reports/weekly/YYYY-WW-search.md` |
| `R2_content_drafter.md` | 1–2 articles EN + AR, or a refresh | Sonnet | Tue 07:00 | branch `content/YYYY-WW` + PR |
| `R3_seo_editor.md` | on-page checks on a content PR | Haiku | on PR | PR comment table |
| `R4_translation_qa.md` | EN/AR parity and register | Haiku | on PR | PR comment table |
| `R5_social_producer.md` | 3 posts × 2 languages + designs | Sonnet | Wed 07:00 | `social/YYYY-WW/` |
| `R6_ideation_analyst.md` | 10 ranked ideas | Sonnet | first Fri 07:00 | `reports/monthly/YYYY-MM-ideas.md` |
| `R7_measurement_reporter.md` | the weekly numbers page | Haiku | Sun 18:00 | `reports/weekly/YYYY-WW-measurement.md` |

Every routine starts with the same four lines, in this order, and stops if any is missing:

1. Read `CLAUDE.md`, then `docs/STATE.md`.
2. Read the wedge sentence: *Arabic-first, trying to conceive → pregnancy, with PCOS depth, Saudi Arabia + Egypt.* Work outside it is listed under "outside the wedge", never promoted.
3. Read the rules that apply to the role (named in the file).
4. Write only to the output path named in the file. Never push to `main`; never merge; never post to a platform. The lead and the owner do that.

Shared rules every routine obeys: no invented facts (cite Tier-1/2 or `[NEEDS SOURCE]`);
no health data from any person in any file; the wordmark is the Latin lowercase **femio**;
the conservative Arabic register; Western digits in Arabic; a `[ ]` line in
`docs/33_REBUILD_V3/PROGRESS.md` for any new task the routine identifies.

To create the schedules (owner, once): in Claude Code say *"create the growth routines
from docs/34_GROWTH_OPS/routines"*. To pause one: *"pause R5"*.
