# docs/store — what goes into Google Play, as it will be pasted

| File | What |
|---|---|
| `play-listing.en.md` | Title, short and full description, screenshot captions, feature graphic line (English, the default listing) |
| `play-listing.ar.md` | The same in Arabic (the primary listing for Egypt and Saudi Arabia via custom store listings) |
| `play-listing.fr.md`, `play-listing.es.md` | French and Spanish, drafted from the English on 2026-11-01 (session drafts until a native reader checks them; `pnpm store-lint` measures them too) |
| `aso-keywords.md` | Target keywords per language, competitor title patterns, placement (researched 2026-11-25; volumes are estimates) |
| `release-notes-1.0.0.md` | "What's new" for the initial release, four languages, 500-character limit |
| `graphics-brief.md` | Play's icon, feature-graphic and screenshot specs, and which screenshots fit |
| `data-safety-and-declarations.md` | Data safety answers, Health apps declaration, disclaimer, audience, content rating, closed-test rule, each tied to the build |

`pnpm store-lint` (`scripts/store/listing-check.mjs`) measures every field against Play's limits, checks the
wordmark and the mandated disclaimer, and fails on a leftover `†` gate mark.

## Ship gates resolved (2026-10-28, build `32c872e` on the v3 branch)

The growth pack marked lines `†` to be deleted if the release candidate lacked the feature. Checked against the app:

| Claim | In the build? | Line kept or changed |
|---|---|---|
| Encrypted storage behind an app lock; backup she saves herself | Yes (R4.1–R4.3) | Kept |
| Hijri dates beside Gregorian | Yes (R4.9) | Kept |
| Physician-written library with sources, weeks 4–40 | Yes (R4.5; `pregnancy-week-4.md` … `-40.md`) | Kept |
| Appointment reminders on the phone | **No**: reminders are a log nudge and "period expected" only | Changed to "Your appointments and the questions you want to ask, kept on your phone" (the Appointments screen) |
| Kick counter | The app has a baby-movement log, not a counter with a target | Worded "baby-movement log" |
| App lock and encrypted storage; backup and restore | Yes | Kept |

## Owner placeholders (do not paste before filling)

- ~~`[SUPPORT EMAIL: owner action 3]`~~ filled 2026-11-01 with info@femioapp.com (owner action 3, done 2026-10-30) in the EN, AR, FR and ES descriptions.
- Screenshot 8 (updated 2026-11-25) is Ask femio: a real registry answer to "How long should we try to conceive before seeing a doctor?" (Office on Women's Health passage, cited [1]), shown word for word as on a phone without a model; it replaced the Settings frame. In the Arabic frame the passage text stays English because the bundled passages are English.
- Screenshots (8 per language, 1080×1920) live in `screenshots/{ar,en}/` and are rendered from the real app screens with synthetic data by `flutter test --update-goldens test/store_screenshots_test.dart` (decided 2026-11-01: a render stays in step with the code; a plain run of the test fails if a screen drifts). A real-phone check of two of them is part of owner action 5.
