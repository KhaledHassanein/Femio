# Play Billing spike (R6.9, step one) — 2026-10-29

**Question.** Can the app talk to Google Play Billing without asking for the INTERNET permission,
so the Data safety answer "no data collected" and the privacy tripwire both stay true?

**Answer (from the build, synthetic — no device yet).** Yes, with one manifest line. The billing
library itself needs only `com.android.vending.BILLING` (it talks to the Play Store app on the
device over a bound service). But its 9.1.0 artifact pulls in Google's telemetry library
`com.google.android.datatransport:transport-backend-cct`, whose manifest declares `INTERNET` and
`ACCESS_NETWORK_STATE`. The first release build with `in_app_purchase` 3.3.1 therefore carried
INTERNET; the fix is two `tools:node="remove"` lines in `apps/mobile/android/app/src/main/AndroidManifest.xml`.

| Build | Permissions in the signed release APK (`aapt2 dump permissions`) |
|---|---|
| Before the fix (08:27) | RECEIVE_BOOT_COMPLETED, VIBRATE, POST_NOTIFICATIONS, **BILLING**, **ACCESS_NETWORK_STATE**, **INTERNET** |
| After the fix (08:36) | RECEIVE_BOOT_COMPLETED, VIBRATE, POST_NOTIFICATIONS, **BILLING** — see `aapt2-permissions-after-remove.txt` |

`manifest-merger-release-report.txt` lines 115–124 show both permissions **REJECTED** from
`transport-backend-cct-3.1.8`. The privacy tripwire (`scripts/analytics-lint.mjs`) now also reads
the merged release manifest whenever a local release build exists, so a future library bump that
re-adds INTERNET fails the gate instead of shipping.

**What the code does.** `apps/mobile/lib/features/plus/billing_probe.dart` asks the store two
read-only questions (is billing reachable; does `femio_plus` exist) and never starts a purchase.
`billing_probe_tile.dart` shows the answer under Settings → About in debug and profile builds and
compiles to nothing in release. 3 widget tests (`test/billing_probe_test.dart`, EN + AR).

**Not verified — owner's device test (dashboard item `billing-probe`).** Whether the billing
library misbehaves when its telemetry cannot reach the network. Expected: the probe reports
"reachable: yes" and the telemetry fails quietly. To check: `flutter run --profile` on a phone
signed in to Play, Settings → About → tap *femio Plus · billing check*, then
`adb logcat | grep -i "billing\|SecurityException\|transport"`. A `SecurityException` naming
INTERNET would mean the library cannot live without the permission, and the premium plan moves to
ADR-076's alternatives.

**Decision recorded.** None needed yet; R6.9 integration still waits for owner action 16
(payments profile, `femio_plus` product).
