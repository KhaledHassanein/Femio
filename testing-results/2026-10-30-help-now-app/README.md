# Help now in the app: sixteen countries (R6.17) — evidence, 2026-10-30

**What:** the app's Help now screen now lists the website's sixteen countries and 37 numbers
(`apps/mobile/lib/domain/crisis_numbers.dart`, generated from
`apps/web/src/lib/crisis/country-numbers.ts`), with the website's reviewed labels in the four ARB
files. `scripts/crisis-compliance.mjs` check 5 fails the gate when the two lists drift.

| Check | Result | Evidence |
|---|---|---|
| Arabic, 390×844, light | sixteen chips, Lebanon chosen: 140 (Red Cross) under emergency, 1564 under support, source host under each | `ar_light_help_now.png` |
| Arabic, dark | same screen in dark | `ar_dark_help_now.png` |
| English, light | United Kingdom chosen: 999 emergency; 111 and 0808 2000 247 (Refuge) support | `en_light_help_now.png` |
| Data test | 16 countries in order, emergency first, 37 unique ids, digits only, https non-social sources, a label for every id in EN/AR/FR/ES | `test/crisis_numbers_test.dart` (4 tests) |
| Widget test | no number before a choice; Egypt; Lebanon (140, 1564, no 123); Kuwait draws no empty support group; sixteen chips | `test/help_now_test.dart` |
| Drift guard | a wrong number injected into the Dart file fails `pnpm crisis-lint` with two `[app]` lines; restored, green | session log |
| Toolchain | `flutter analyze` no issues; `flutter test` 507 tests pass; `pnpm crisis-lint`, `mobile-untranslated-lint`, `mobile-vocab-lint` green | `scratchpad/flutter-r617.log` |

Screenshots are goldens written by `flutter test --update-goldens test/help_now_screenshots_test.dart`
(synthetic, test harness, bundled fonts), not from a device.

**Not verified:** the screen on a real phone; the French and Spanish screens were not
screenshotted (their labels are the website's reviewed catalogues, checked by the data test).
