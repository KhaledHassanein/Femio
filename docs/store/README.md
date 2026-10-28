# docs/store — what goes into Google Play, as it will be pasted

| File | What |
|---|---|
| `play-listing.en.md` | Title, short and full description, screenshot captions, feature graphic line (English, the default listing) |
| `play-listing.ar.md` | The same in Arabic (the primary listing for Egypt and Saudi Arabia via custom store listings) |
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

- `[SUPPORT EMAIL: owner action 3]` in both full descriptions (`docs/runbooks/OWNER_ACTIONS.md`).
- Screenshots themselves (8 per language) are produced from the release candidate on a real phone (owner action 5), not from the emulator.
