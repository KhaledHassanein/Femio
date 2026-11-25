# Play graphics brief — initial release (1.0.0, build 1)

Specs read on 2026-11-25 from the official page, [Add preview assets to showcase your app](https://support.google.com/googleplay/android-developer/answer/9866151) (Play Console Help). Re-read it on submission day; Google edits these numbers.

## What Play requires today

| Asset | Requirement (from the page above) |
|---|---|
| App icon | 512 × 512 px, 32-bit PNG with alpha, at most 1,024 KB |
| Feature graphic | 1024 × 500 px, JPEG or 24-bit PNG with **no alpha** |
| Phone screenshots | 2 to 8; PNG or JPEG; at most 8 MB each; each side 320 to 3,840 px; 16:9 or 9:16; the longer side at most 2.3 times the shorter |
| Promotion eligibility (recommended, not required to publish) | At least 4 screenshots, 1080 px minimum side, 9:16 (1080 × 1920 or larger) or 16:9 (1920 × 1080 or larger) |
| 7-inch and 10-inch tablet screenshots | Minimum 4 each for tablet promotion, 1,080 to 7,680 px per side. Optional for a phone-first release; femio's tablet layout is **not verified** |
| Promo video | Optional; a public or unlisted YouTube URL, monetisation off, not age-restricted. Only the first 30 seconds autoplay |

Not stated on the page and therefore **not verified**: a ban on alpha in screenshots, and any "safe area" for feature-graphic text (the brief's central safe area is a design rule, not a Play rule).

## The existing assets against those specs

| Asset | File | Fits? |
|---|---|---|
| App icon | `assets/brand/logo/femio-app-icon-dusk-512.png`: 512 × 512, RGBA, 55 KB | Fits (32-bit PNG with alpha, under 1 MB). Confirm it is the icon the app ships |
| Screenshots EN and AR | `docs/store/screenshots/{en,ar}/01..08-*.png`: all 1080 × 1920 (9:16), RGBA with alpha fully opaque (checked on all 16 by script) | Size, ratio, count and file size fit. Flatten to RGB before upload to be safe (the alpha rule is not verified for screenshots) |
| Feature graphic | none in the repo | **To make** (1024 × 500, RGB PNG or JPEG): wordmark femio, one line "Your records stay on your phone." (listing files give each language) |
| FR and ES screenshots | none | Optional: Play falls back to the default (English) set; AR is the primary set for Saudi Arabia and Egypt. Render FR and ES only if the owner wants localised stores |
| Tablet screenshots | none | Optional, skip for the first release |

## Which screenshots need re-shooting

The existing set was rendered on 2026-11-01 (commit 0d2bf25) from the Flutter golden test `apps/mobile/test/store_screenshots_test.dart`, which holds the caption text. App code under `apps/mobile/lib/features` has changed since (latest commit 2026-11-25), so:

1. **Re-render all 16 anyway** with `flutter test --update-goldens test/store_screenshots_test.dart` (the test is the source of truth; a plain run fails when a screen drifts) and look at each one. Not run in this pass because `apps/` was out of scope.
2. **#1 caption must change**: the baked-in text reads "Your records never leave your phone" (AR "سجلاتكِ لا تغادر هاتفكِ"). With the optional Cloud boost that sentence is too strong. The listings now say "Your records stay on your phone" / "سجلاتكِ تبقى على هاتفكِ". The caption lives in `store_screenshots_test.dart` line 83, so it needs a one-line edit there before re-rendering. The in-app "Private by design" card in the same frame ("no account and no server") should be checked against the privacy notice.
3. **Add one new shot, Ask femio with sources** (caption in the listing files, row 9). Play allows at most 8 phone screenshots, so it replaces #8 (Settings: lock and backup), because #1 already carries privacy. The listing tables mark it "9 (new)"; renumber when the set is final.
4. Keep #2 to #7 as they are unless the re-render shows drift. The rest do not mention anything changed in this release.

Per CLAUDE.md, judge each at 390 × 844 in light and dark; the store frames are light only.

## Content rules for every asset

- Wordmark is the Latin lowercase **femio**, also on the Arabic frames. Western digits in Arabic.
- No photos of people, no verdict language, no single certain date, no "late" counter, no claims of accuracy, nothing that suggests contraception.
- Data on screen is synthetic; say so in the commit, not on the image.
