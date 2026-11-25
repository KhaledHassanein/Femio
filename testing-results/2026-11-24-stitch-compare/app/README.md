# Current-app screenshots for the Stitch comparison

Rendered by `apps/mobile/test/stitch_compare_screenshots_test.dart` (`flutter test ... --update-goldens`).
390x844 logical phone, device pixel ratio 2 (780x1688 PNG). Variants: `en_light`, `ar_light`, `ar_dark`.
All data is synthetic (dates in 2026, no person). "Today" is fixed at 2026-11-24.

1. `1_onboarding` - `FemioApp` with an empty store, so it shows `OnboardingFlow`, first step (language chips and Get started).
2. `2_today_ttc_pcos` - `FemioApp` Today tab. Goal trying to conceive, `irregular: true`, five period starts 36 to 45 days apart (May to Oct 2026), three heavy/medium days logged. `_b` = same screen scrolled down (past the fold: test timing, tips).
3. `3_today_pregnancy` - `FemioApp` Today tab. Goal pregnant, due date 2027-03-10.
4. `4_say_it_to_log` - `SayItSheet` in a Scaffold, example sentence typed and converted (fake on-device model returns "bloating"), chips shown.
5. `5_ask_femio` - `AskScreen` with the real bundled source registry; question typed, answered by a fake on-device model with numbered sources.
6. `6_calendar` - `FemioApp`, Calendar tab (November 2026), trying-to-conceive profile with logs.
7. `7_patterns` - NONE. No patterns/insights/history/trends screen exists in the app. Closest pieces: the BBT temperature chart card inside the Today hero (`2_today_ttc_pcos_*_b` may show it only if temperatures are logged; none are in this synthetic profile), the pregnancy weight chart (`features/pregnancy/weight_screen.dart`), and the "Logged most in the last 90 days" block inside the visit summary (screen 8). Skipped.
8. `8_doctor_visit_pack` - `VisitSummaryScreen` (cycles logged, most-logged symptoms, questions to ask), fake on-device model orders the questions. Only the top of the list fits one screenful; later questions are below the fold (no `_b`).
9. `9_help_now` - `HelpNowScreen`, no country chosen (default state).

Not rendered: screen 7 only. Screens 4, 5 and 8 are shown without the app shell (bare screen, as in the assistant tests); the real app opens them as sheets/pushed routes.
