# Stitch round 1 vs the app (2026-11-24)

- `app/`: the current app's screens, from `apps/mobile/test/stitch_compare_screenshots_test.dart --update-goldens` (synthetic data, 390x844 at 2x).
- `page/`: the published comparison (https://claude.ai/artifact/2wbNyvPh6eVLDkUUoMpvRT); `page/img` holds 360px JPEGs of both sides.
- `stitch/texts.json`: the visible text of each Stitch mockup. The full-size Stitch PNGs are not kept; `render-stitch.mjs` rebuilds them from the export in Downloads.
- `build_page.py`: rebuilds `page/index.html` (it writes to an absolute worktree path; adjust `ROOT`).

Round 2 prompts: `docs/design/STITCH_PROMPTS_2026-11-24.md`; requirements: PROGRESS R8.
