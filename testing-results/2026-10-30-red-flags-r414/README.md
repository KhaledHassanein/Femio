# Pregnancy red-flag card: bleeding and movements (R4.14) — evidence, 2026-10-30

**What:** the sentence under the pregnancy calculator (`calculators.rules.redFlag`) and the app's
card and warning-signs screen now name seven signs: the five ACOG/CDC ones plus vaginal bleeding
and the baby's movements slowing down, stopping or changing. Sources: the NHS pages recorded in
MR-29 (`docs/33_REBUILD_V3/01_PRODUCT_SCOPE.md`) and `docs/compliance/PREGNANCY_BP_SAFETY.md`.

| Check | Result | Evidence |
|---|---|---|
| App, Arabic, 390×844, light and dark | the sentence with the seven signs; the list with نزيف مهبلي and the movements line; four source rows (acog.org, cdc.gov, nhs.uk ×2) | `ar_light_red_flags.png`, `ar_dark_red_flags.png` |
| App, English, light and dark | same in English | `en_light_red_flags.png`, `en_dark_red_flags.png` |
| Website, pregnancy calculator | the red-flag box under the result carries the new sentence (English and Arabic, 390 wide) | `web-en-gestational-age.png`, `web-ar-gestational-age.png` |
| Web↔app parity | `pnpm mobile-vocab-lint` green: the app's `pregRedFlagsBody` equals the website sentence in four locales | gate log |
| Toolchain | `pnpm gate` green (689 tests, 22 guards); `flutter analyze` clean; `flutter test` 507 tests | `scratchpad/gate-r414.log`, `flutter-r414.log` |

App screenshots are goldens from the test harness (synthetic, bundled fonts); the website ones are
from the local dev server at 390 wide. Not verified: on a device; the live site until the next deploy.
The Learn guide "Pregnancy warning signs" keeps its own sourced text and was not changed.
