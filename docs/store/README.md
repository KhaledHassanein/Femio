# docs/store — what goes into Google Play, as it will be pasted

| File | What |
|---|---|
| `play-listing.en.md` | Title, short and full description, screenshot captions, feature graphic line (English, the default listing) |
| `play-listing.ar.md` | The same in Arabic (the primary listing for Egypt and Saudi Arabia via custom store listings) |
| `play-listing.fr.md`, `play-listing.es.md` | French and Spanish, drafted from the English on 2026-11-01 (session drafts until a native reader checks them; `pnpm store-lint` measures them too) |
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
- Screenshots (8 per language, 1080×1920) live in `screenshots/{ar,en}/` and are rendered from the real app screens with synthetic data by `flutter test --update-goldens test/store_screenshots_test.dart` (decided 2026-11-01: a render stays in step with the code; a plain run of the test fails if a screen drifts). A real-phone check of two of them is part of owner action 5.

## Store graphics (`graphics/`, rendered 2026-11-01)

| File | What | Measured |
|---|---|---|
| `graphics/icon-512.png` | Play app icon: the adaptive launcher icon composed as Android does it (plum-900 background layer under `ic_launcher_foreground` from `mipmap-xxxhdpi`), full-bleed, no text | 512×512, 32-bit RGBA, 24 KB |
| `graphics/feature-graphic-en.png` | Feature graphic: femio wordmark, "Your records never leave your phone.", the Bloom, Dusk Bloom gradient | 1024×500, 24-bit RGB (no alpha), 172 KB |
| `graphics/feature-graphic-ar.png` | The same in Arabic, mirrored right-to-left; wordmark stays Latin | 1024×500, 24-bit RGB (no alpha), 169 KB |

Play's limits (Console Help "Add preview assets", <https://support.google.com/googleplay/android-developer/answer/9866151>, read 2026-11-01): icon 512×512, 32-bit PNG with alpha, at most 1024 KB; feature graphic 1024×500, JPEG or 24-bit PNG with no alpha, key content kept near the centre because the edges may be cropped or overlaid.

Rebuild after a token or launcher-icon change, from `apps/mobile`:

```
flutter test --update-goldens test/store_graphics_test.dart
```

A plain `flutter test test/store_graphics_test.dart` builds the three frames and checks their pixel size without writing. The test writes the PNGs itself (a small encoder in the test) because Play wants the feature graphic without an alpha channel, which golden files cannot give. Colours, fonts and the Bloom come from the theme; the lines are the feature-graphic lines of the two listings, so change the test's `_lines` if a listing line changes.
