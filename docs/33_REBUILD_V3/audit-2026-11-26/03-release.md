# 03 Release and launch-readiness audit (Google Play release manager view)

Audit date 2026-11-26. Worktree `judge-audit-bd6d27` at `fb45488`. Read-only: no tests, no installs, no builds. Only this file was written.
Labels: VERIFIED = I read or measured it myself today. NOT VERIFIED = could not be checked here. LIVE SITE = fetched from femioapp.com today. LOCAL CODE = the repo, the APK or the build folders on this PC.

## Launch-readiness score: 5 / 10

- The paperwork is strong. Four listings inside Play's limits, a pass on the store-lint guard, correct screenshot and graphic sizes, a manifest with no ad-ID, camera, storage or location permissions, and a Data safety answer that matches the APK I inspected (no Firebase Installations component).
- A judge today cannot install anything. The live site says "Coming soon", the Devpost entry has `<APK link>` and `<public GitHub repo>` placeholders, and no public repo exists yet.
- Nothing has started on the Play side. There is no verified Play Console account, no closed test, no tester roster and no upload-signed bundle. The 14-day clock has not begun.
- The 1.0.0 test APK is current (built 2026-11-26 14:44, after the last app commit at 14:41) and its Firebase config is baked in. It is signed with the Android Debug certificate, so it is good for sideloading and useless for Play.
- Score for the hackathon deadline (2026-11-30, 2 pm PT): 4/10 today. It rises to 8/10 once an APK link and a repo exist, which is about an hour of owner work.
- Score for Play production: 3/10. The calendar, not the code, is the constraint (section 5).

## 1. Checklist

| Item | Status | Evidence | Owner-only? |
|---|---|---|---|
| Title <= 30, short <= 80, full <= 4000, EN/AR/FR/ES | ready | Measured by my own script on the code blocks: EN 28/71/3982, AR 29/65/3577, FR 30/70/3994, ES 27/68/3964. `node scripts/store/listing-check.mjs` prints "within Play's limits, no gate marks, wordmark Latin, disclaimer present". The numbers in the listing headers (3991, 3995, ...) differ by a few characters from mine (line endings), all inside the limit. | no |
| Health disclaimer in all four descriptions | ready | The guard checks it. The EN text contains "not a medical device and does not diagnose, treat, cure or prevent any medical condition" plus "talk to your doctor". Required by https://support.google.com/googleplay/android-developer/answer/16679511 | no |
| No testimonials, "best", "#1", performance or price claims | ready | Grep of the four full descriptions found no `best`, `#1`, `guarantee` (only the negated "not guarantees"), `testimonial`, `proven` or `clinically`. Rule: https://support.google.com/googleplay/android-developer/answer/9898842 | no |
| ALL CAPS in descriptions | not ready (P2) | Section headers `WHY FEMIO`, `TRYING TO CONCEIVE`, `PCOS AND IRREGULAR CYCLES`, `PREGNANCY`, `PRIVATE BY DESIGN`, `IMPORTANT` are in capitals in EN. The metadata policy says "Avoid ALL CAPS unless it is part of your brand name" (same URL as above). | no |
| Listing matches the app (no stale ads or AI claims) | ready | EN says "no account, no ads, no analytics", which matches ADR-080 and the manifest. The Cloud boost line says it is off unless turned on and sends only a general question or four broad facts. Matches `docs/store/data-safety-and-declarations.md`. | no |
| Data safety answers vs the APK | ready, one row unproven | See section 2. | partly (Console entry is owner-only) |
| Health apps declaration | ready (text); Console option names not verified | The doc itself says the option names are not verified (answer 16679511 does not list them). | yes |
| Target audience 18+ | ready | An 18+ gate exists as a domain rule (STATE.md R4.8). The Console box "restrict minor access" is owner-only. | yes |
| Content rating (IARC) and AI-content question | not verified | Console wording not available offline. | yes |
| Phone screenshots | ready, EN and AR only | 8 per locale, all 1080x1920 RGB, PIL-measured (`docs/store/screenshots/{en,ar}/01..08`). Play wants 2 to 8 phone screenshots per listing. FR and ES have none, so they inherit the default listing's shots. | no |
| Feature graphic 1024x500 | ready | `docs/store/graphics/feature-graphic-{en,ar,fr,es}.png`, 1024x500 RGB. | no |
| 512x512 icon | ready | `assets/brand/logo/femio-app-icon-dusk-512.png`, 512x512 RGBA, 55 KB. | no |
| Screenshots match the current app | ready (synthetic fixture) | R8.30 re-render, 16 files. Mtime 11-26 14:50, after the nav-bar change. I did not open and judge the images. Real-phone comparison is owner action 5. | partly |
| versionName / versionCode | ready | `pubspec.yaml` `1.0.0+1`. The test APK badging says versionCode 1, versionName 1.0.0. | no |
| targetSdk / compileSdk / minSdk | ready | APK badging: targetSdk 36, compileSdk 36, minSdk 26. Google's current rule is below. | no |
| Release signing config | ready in code; not yet used for any artifact I saw | `build.gradle.kts` signs with `android/key.properties` when present, else debug. `key.properties` is git-ignored (`git check-ignore` confirms) and not tracked. See REL-6. | yes |
| R8 / shrink | ready, thin keep rules | `isMinifyEnabled` and `isShrinkResources` true. `proguard-rules.pro` only keeps `io.flutter.**`. The 2026-11-25 release build ran and the APK has the Firebase and Play Integrity components. Runtime behaviour of the minified build is not verified on a device (owner action 5, 33). | partly |
| Upload-signed .aab | not ready | The .aab files found are `E:\Femio\.claude\worktrees\firebase-hackathon-eligibility-833c52\apps\mobile\build\app\outputs\bundle\release\app-release.aab` (2026-11-25 23:56, debug-signed per the Data safety doc) and `E:\Femio\apps\mobile\build\...\app-release.aab` (2026-11-02, stale). I did not check the signer of either. | yes (needs the key) |
| Release APK in `E:\femio-builds` | ready for sideload | `femio-1.0.0-test.apk`, 65,840,952 bytes, 2026-11-26 14:44. Identical size and time to the firebase worktree's `app-release.apk`. `apksigner` shows "CN=Android Debug". | no |
| Closed test started with 12 testers | not ready | PROGRESS R5.4 is `[ ]`. R4.12 is `[BLOCKED]` on owner actions 1, 2, 5. | yes |
| Website "get the app" path | not ready | See section 6. | partly |

## 2. Data safety, permissions, dependencies (VERIFIED, LOCAL CODE)

I used `aapt2` (build-tools 36.1.0) on `E:\femio-builds\femio-1.0.0-test.apk` (an R8-minified release build; debug-signed).

- Permissions in the APK: `INTERNET`, `RECEIVE_BOOT_COMPLETED`, `ACCESS_NETWORK_STATE`, `VIBRATE`, `POST_NOTIFICATIONS`, `com.google.android.apps.aicore.service.BIND_SERVICE`, `com.android.vending.BILLING`, and the app's own `DYNAMIC_RECEIVER_NOT_EXPORTED_PERMISSION`.
  - No `AD_ID`, no `ACCESS_ADSERVICES_*`, no `CAMERA`, no storage or media permissions, no location, no exact-alarm. This matches the Data safety doc's list for 2026-11-25.
- Firebase components registered in the manifest: `FirebaseAIRegistrar`, `FirebaseAIOnDeviceRegistrar`, `FirebaseAppCheckPlayIntegrityRegistrar`, `FirebaseAppCheckRegistrar` and `FirebaseAppCheckKtxRegistrar`, `FirebaseCommonKtxRegistrar`, ML Kit `CommonComponentRegistrar`.
  - There is no `FirebaseInstallationsRegistrar`, and `classes.dex` has zero hits for `FirebaseInstallations`, `firebase/installations` or `firebase-installations`.
  - This supports the doc's "leave Device or other IDs unticked", for this build only.
  - A full `gradlew :app:dependencies` was not run (builds are out of scope). R7.6 stays `[~]` on that basis. The ML Kit telemetry question stays unproven until owner action 33 (traffic capture on a phone).
- Dependencies: Dart packages are `cryptography`, `file_picker`, `flutter_local_notifications`, `flutter_secure_storage`, `image_picker 1.2.2`, `in_app_purchase`, `in_app_review`, `in_app_update`, `intl`, `path_provider`, `timezone`. Kotlin adds `firebase-ai 18.2.0`, `firebase-ai-ondevice 16.0.0-beta08` (a beta library in a store release) and `firebase-appcheck-playintegrity 20.1.0`.
- `data-safety-and-declarations.md` lists the Dart packages without `image_picker` (added with R11.2 documents, camera capture in `lib/data/document_source.dart:87`). The APK carries no CAMERA permission, so the doc is stale but harmless. See REL-9.
- The billing probe tile returns nothing in release builds (`billing_probe_tile.dart:39`, `if (kReleaseMode) return const SizedBox.shrink()`). The doc's "not verified that the probe is absent" can be closed for source. `BILLING` stays in the manifest, and Play shows it as a permission.
- Firebase config is baked into the test APK (one app-id-shaped string, one `AIza` key shape, `gemini-3.5-flash-lite` present in the dex). So Cloud boost can be attempted. The build came from the firebase worktree, which holds the git-ignored `assistant.env`; the judge worktree has none.
- Health Connect: not requested. The doc says so and the manifest agrees.

## 3. Policy facts used (each from the Google page)

- Target API: from 31 Aug 2026 new apps and updates must target API 36 or higher (extension to 1 Nov 2026 existed). femio targets 36, so it is compliant. The brief's "35" is out of date; the runbook is right. https://support.google.com/googleplay/android-developer/answer/11926878
- New personal accounts (created after 13 Nov 2023): closed test with at least 12 opted-in testers continuously for 14 days, then apply for production access; review "usually seven days or less, but can occasionally take longer". https://support.google.com/googleplay/android-developer/answer/14151465
- Health apps: non-medical-device health apps need a description disclaimer "not a medical device and does not diagnose, treat, cure, or prevent any medical condition" and a prompt to consult a professional. https://support.google.com/googleplay/android-developer/answer/16679511
- Metadata: no unattributed testimonials, no emoji or repeated special characters, avoid ALL CAPS, no ranking, price or promotion text in title or icon. https://support.google.com/googleplay/android-developer/answer/9898842
- Data safety: SDK-transmitted data counts as collected. https://support.google.com/googleplay/android-developer/answer/10787469 (cited by the repo doc; I did not re-fetch this page).

## 4. Account timeline (earliest production date)

- Assumptions: the Play Console account exists and is verified today (NOT VERIFIED, owner action 1); an upload-signed .aab is accepted on the first try; 12 real people join and stay opted in.
- Today, Thu 2026-11-26: start the closed test. Day 14 completes on Thu 2026-12-10. Apply for production access that day.
- Google review of 7 days or fewer gives production on about Thu 2026-12-17, if every tester stays in and nothing is rejected. Allow slack for the first-release review before the closed test goes live (not documented, assume several days) and for rejections.
- Realistic window: 2026-12-17 to early January 2027. If the account is not yet verified or no bundle is signed today, add those days on top.
- Production is impossible before the 2026-11-30 hackathon deadline. Only the APK and website routes matter for that deadline.
- Owner actions that gate the closed test:
  - 1 Play account: status NOT VERIFIED.
  - 2 keystore: the file and `key.properties` exist (see REL-6), so action 2 looks done. The runbook and PROGRESS R4.12 still list it as open (stale).
  - 5 install the APK on a phone and report: not done (no evidence).
  - 6 find 12 testers: not done.
- Also needed before the first upload: owner actions 33 and 36 (traffic check, privacy-lawyer review). They are not Play rules, but they are the owner's own conditions for the release.

## 5. Website as the front door (LIVE SITE, 2026-11-26)

| URL | HTTP |
|---|---|
| /en, /ar, /en/app, /en/privacy, /en/terms | 200 |
| /en/calculators/fertile-window, /en/calculators/due-date, /ar/calculators/fertile-window | 200 |
| /robots.txt, /sitemap.xml | 200 |
| /en/delete-data (a guess of mine, not a documented route) | 404 |

- Get-the-app path: `/en` hero shows "Google Play · Coming soon · iPhone · Coming soon". `/en/app` shows "Coming to Google Play. Google Play Coming soon iPhone Coming soon". `PLAY_STORE_URL` is `null` in `apps/web/src/lib/site.ts:15`. There is no APK link, no waitlist and no email capture. Every "Get the app" button leads back to the "coming" page.
- Is the live site behind this branch? Only partly verified.
  - `git ls-remote origin main` returns `4136d24`. HEAD is 54 commits ahead.
  - Five of those touch `apps/web`: 232bcf5, ae3a239, decc4c9, 68becf2, 9450300 (the last is the SEO pass and Play lines in the privacy notice).
  - Which commit Vercel actually serves is NOT VERIFIED. STATE.md names main `2bdbe7c` for the 2026-11-25 deploy, and `4136d24` is later.
  - The live /en/app privacy text already mentions Play update and rating prompts and femio Plus billing, so 9450300-era wording may be live. The code-to-live comparison was not done.

## 6. Hackathon testing instructions (docs/hackathon/DEVPOST_SUBMISSION.md lines 66 and 78-86)

- Step 1 says "Install the APK on an Android phone that supports Gemini Nano". The "Try it out" line is `https://femioapp.com · <public GitHub repo> · <APK link>`. Both placeholders are unfilled.
- Judge's route today: none. The only APK is `E:\femio-builds\femio-1.0.0-test.apk` on the owner's PC (62.8 MB).
- The APK link would come from the public repo's GitHub Release (owner action 27, "make it public", a session creates `femio-app`). `gh repo view KhaledHassanein/femio-app` returned "could not resolve", so the repo does not exist yet (the account name was my guess; NOT VERIFIED).
- Cloud boost may be refused for a sideloaded APK because App Check uses Play Integrity (owner accepted this on 2026-11-24, `OWNER_ACTIONS.md` row 25). The rest runs on rules. The text already says so.
- Not in the instructions, and a judge will hit it: allow "Install unknown apps", Play Protect may warn on a debug-signed APK, and minSdk is 26 and arm64 or x86_64 only (badging `native-code`).

## 7. Findings

| ID | Sev | Finding | Evidence | Status | Source | Fix | Owner? |
|---|---|---|---|---|---|---|---|
| REL-1 | P0 hackathon | No installable artifact is public. Devpost has `<APK link>` and `<public GitHub repo>`. | `DEVPOST_SUBMISSION.md:66`; the only APK is on `E:\femio-builds`; `gh repo view` could not resolve `femio-app` | VERIFIED | LOCAL CODE | Owner action 27, then attach `femio-1.0.0-test.apk` (sha1 in `app-release.apk.sha1`) as a GitHub Release asset and paste the link. Rebuild from the final commit first. | yes |
| REL-2 | P0 hackathon | The live site's every "Get the app" is "Coming soon"; a judge clicking "Try it out" finds nothing to install. | `/en` and `/en/app` text; `site.ts:15` `PLAY_STORE_URL = null` | VERIFIED | LIVE SITE | Until Play exists, add a clearly labelled "Early test build (APK)" button to `/app`, in four locales, pointing at the GitHub Release. A web change that goes live is the owner's call. | yes (deploy) |
| REL-3 | P0 hackathon | Testing steps assume a Gemini Nano phone and omit sideload steps (unknown sources, Play Protect, API 26+, 64-bit). Cloud boost likely refused on sideload. | Devpost lines 80-85; APK badging; `OWNER_ACTIONS.md` row 25 | VERIFIED | LOCAL CODE | Add two lines for installing; say plainly "on any phone, steps 2 to 4 work without Nano". Provide a screenshot or short video fallback in case no judge has a Nano phone. | no (text) |
| REL-4 | P0 closed test | The 14-day clock has not started; no Play account is evidenced and no tester roster exists. Earliest production is about 2026-12-17 (section 4). | PROGRESS R5.4 `[ ]`, R4.12 `[BLOCKED]`; policy page 14151465 | VERIFIED (state), NOT VERIFIED (account) | LOCAL CODE | Owner actions 1, 6 today. Upload the .aab to internal and closed tracks together (allowed for personal accounts, per runbook §5). | yes |
| REL-5 | P0 closed test | No upload-signed bundle is in hand. The test APK is debug-signed, and the .aab files are stale (2026-11-02) or debug-signed (2026-11-25, per the Data safety doc). | `apksigner` "CN=Android Debug"; the two .aab paths in section 1 | VERIFIED (APK), NOT VERIFIED (aab signer) | LOCAL CODE | Build `flutter build appbundle --release` in a checkout that has `key.properties` and `assistant.env`, from the final commit. Check the signer with `apksigner` or `jarsigner` before upload. | yes |
| REL-6 | P1 | The owner docs say the keystore is still to do, but it exists. `E:\_Private\femio-upload-keystore.jks` is dated 2026-10-29 and `E:\Femio\apps\mobile\android\key.properties` exists (git-ignored, not tracked). | file listing; `git check-ignore -v`; `git ls-files` finds no key, jks or key.properties | VERIFIED | LOCAL CODE | Mark action 2 done. The signing config only works in a checkout that has the file: the judge worktree and the firebase worktree build debug-signed. Back the .jks up in two places (runbook §2). | yes |
| REL-7 | P1 | Data safety "Device or other IDs" is still marked open. My scan supports "unticked" for this build, but the repo owner's proof (the dependency tree) has not been run. ML Kit telemetry is unverified. | aapt2 manifest dump: no Installations registrar; dex has none; `data-safety-and-declarations.md` row; R7.6 `[~]` | PARTLY VERIFIED | LOCAL CODE | Run `gradlew :app:dependencies \| grep firebase-installations` on the release .aab build, then owner action 33. Record both results and close R7.6. | owner for the phone check |
| REL-8 | P1 | The privacy-policy sentence about Play rating and update prompts is "not verified" on the live page; the live page was fetched and mentions them, but the doc item is still open. | doc row "Privacy policy URL"; live `/en/app` text | PARTLY VERIFIED | LIVE SITE | Read `/en/privacy` once and tick the doc item. Do this before the form. | no |
| REL-9 | P2 | `data-safety-and-declarations.md` is stale in two places: it omits `image_picker` and the camera capture for documents; it says the billing probe is unverified though source hides it in release. | pubspec line 31; `document_source.dart:87`; `billing_probe_tile.dart:39` | VERIFIED | LOCAL CODE | Update the doc. Check the Console's camera and photos questions on submission day: no permission, the user picks one file, nothing is collected. | no |
| REL-10 | P2 | ALL CAPS section headers in the descriptions may draw a metadata-policy flag. | EN full description; policy 9898842 | VERIFIED text, risk is a judgement | LOCAL CODE | Use sentence case headers in the four listings. Zero cost. | no |
| REL-11 | P2 | FR and ES have no phone screenshots (EN and AR only). Their listings fall back to the default language's images. | `docs/store/screenshots/{ar,en}` | VERIFIED | LOCAL CODE | Fine for launch. Add translated screenshots later (the README says the test can render them). | no |
| REL-12 | P2 | `firebase-ai-ondevice 16.0.0-beta08` ships in a store release, and the keep rules are only `io.flutter.**`. | `build.gradle.kts`, `proguard-rules.pro` | VERIFIED | LOCAL CODE | The first install of the minified build on a phone (owner action 5) must exercise Say it, Ask femio and the Cloud boost consent screen. Add keep rules only if something breaks. | yes (phone) |
| REL-13 | P2 | The live site may lag the branch by five web commits; the deployed commit is not known. | `git ls-remote` vs HEAD | NOT VERIFIED | LIVE SITE | Before the hackathon, compare the Vercel deployment's commit with `main`; decide on the merge with the owner. | yes (merge and deploy) |

## 8. What I did not check

- Whether the Play Console account exists or is verified.
- Any Console form wording (Health apps options, IARC, AI question).
- The signer of the two .aab files.
- A device run of the minified build.
- Whether the screenshots look right (sizes and times only).
- The Play pages' content beyond the scraped excerpts above.
- The Arabic, French and Spanish disclaimers beyond what the guard checks.
