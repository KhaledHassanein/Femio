# 02 · Privacy and data-protection audit (2026-11-26)

Read-only audit of worktree `judge-audit-bd6d27` at `fb45488` (app and site source) and of the live
site `https://femioapp.com` (deployed from `2bdbe7c`, 2026-11-25). Done by an agent acting as a
privacy lawyer with engineering literacy. **This is not legal advice**: owner action 36 (a paid
lawyer review) still stands.

The core test: does every privacy sentence match what the code sends?

Labels:
- **VERIFIED**: I read the code, ran the command or fetched the live page myself.
- **NOT VERIFIED**: inferred from documentation or reasoning. It needs a device traffic capture or a console check.
- **LOCAL CODE**: this branch. **LIVE SITE**: femioapp.com today.

Not done, on instruction: no `flutter test`, no `pnpm install`, no builds. Every test I cite was
read, not run.

---

## Score: 8 / 10 (privacy, as a hackathon judge)

**Why 8.** The privacy design beats almost every women's-health app I know:

- The cloud boundary is a type. `CloudPrompt` has a private constructor and only two factories:
  `CloudSafeText` (a redacted question) or `PseudonymisedProfile` (four bands).
- Every on-phone call runs `ONLY_ON_DEVICE`. Dart then throws away any reply whose `source` is not
  `ON_DEVICE`.
- One gateway is the only caller of the model, and it checks consent before any hybrid call.
- A build tripwire guards all of the above.
- Consent is off by default, one box per purpose, dated, versioned and withdrawable. A restored
  backup withdraws it.
- The app has its own "What can leave this phone" screen.
- The website CSP is closed and the `Referrer-Policy` hides paths.

**Why not 9 or 10.** Three things are not true as written:

1. Several privacy sentences, including the consent text itself and the live website, say that
   femio removes **names** from a question. The code does not.
2. The on-device AI library (`firebase-ai-ondevice` → `com.google.mlkit:genai-prompt`) is
   documented by Google as sending usage analytics with device and installation identifiers. Today
   the app says "nothing is sent", the listing says "no analytics", and the Play Data safety draft
   leaves "Device or other IDs" unticked.
3. The website policies have not caught up with the R11 health record: documents and photos,
   medicines, sexual-activity logs and custom reminder words. The privacy policy still says "No …
   photos … or files".

None of these exposes a record today, because no public app build exists. They are the kind of
gap regulators punish (the Flo and GoodRx pattern: a promise wider than the code).

---

## 1 · Inventory of what can leave the phone (from the code)

| # | Flow | Trigger | Content | Recipient | Evidence | Status |
|---|---|---|---|---|---|---|
| F1 | Cloud boost, question | Ticked "questions" + no Nano + she approves the edited text | `CloudSafeText` (email, URLs and digits stripped; first-person questions blocked) + public registry passages + language | Google, Firebase AI Logic, Gemini Developer API (`GenerativeBackend.googleAI()`) | `redaction.dart:57-80`, `cloud_prompt.dart:142-150`, `ask_screen.dart:131-167`, `FemioAssistant.kt:128-130` | VERIFIED (code) |
| F2 | Cloud boost, tips | Ticked "tips" + no Nano; runs in the background | `PseudonymisedProfile.features` (stage, regularity, symptom categories, streak) + every tip for the stage | Same | `pseudonymised_profile.dart:258-263`, `cloud_prompt.dart:155-165`, `assistant_gateway.dart:105-116` | VERIFIED (code) |
| F3 | Request metadata with F1/F2 | Every hybrid call | IP address; App Check token (Play Integrity, release) or debug token (debug); Firebase `x-firebase-client` heartbeat (SDK names and versions) | Google | `AppCheckInstaller.kt` (debug, profile, release), `FemioAssistant.kt:149-163` | Code VERIFIED; wire content NOT VERIFIED |
| F4 | ML Kit GenAI telemetry | Likely on each on-device model use and status check, **with Cloud boost off** | Per Google: device info, app info, "user, device or other identifiers", per-installation IDs, latency, input/output **size**, event types, error codes, configured languages | Google (ML Kit) | `firebase-ai-ondevice-16.0.0-beta08.pom` declares `com.google.mlkit:genai-prompt:1.0.0-beta5` (runtime), fetched 2026-11-26; Google, "ML Kit: Prepare for Google Play's data disclosure requirements", GenAI rows (page updated 2026-07-15) | Dependency VERIFIED; actual traffic NOT VERIFIED (owner action 33) |
| F5 | Gemini Nano download and updates | She taps Download | Model fetch by the system service AICore | Google (system) | `FemioAssistant.kt` `download()` | VERIFIED (code) |
| F6 | Play Core and Billing | Store, update prompt, rating prompt, billing probe | Play's own traffic; femio passes no record data | Google Play | `pubspec.yaml` (`in_app_update`, `in_app_review`, `in_app_purchase`), `lib/data/play_store.dart` | VERIFIED (deps) |
| F7 | User-initiated sharing | She taps Share (document, visit pack) | Plain copy of the document, or the visit-pack text | The app she picks | `FilesChannel.kt:54-…`, `share_channel.dart:15`, `visit_summary_screen.dart:97` | VERIFIED |
| F8 | CSV export | She saves the spreadsheet | **Unencrypted** CSV of her logs, to a location she picks (it can be a cloud drive) | Her chosen location | `csv_actions.dart:38-47`; warning `app_en.arb:1849` | VERIFIED |
| F9 | Backup | She saves a backup | Passphrase-sealed file, documents included | Her chosen location | `backup_actions.dart:74`; `app_en.arb:1175` | VERIFIED |
| F10 | Links | She opens a source | URL to her browser (https only) | Third-party site | `FemioAssistant.kt` `openInBrowser` | VERIFIED |
| — | On-phone only, never sent | — | Notifications are local. The widget keeps two strings in plain SharedPreferences. Documents are sealed with the record key. Android backup and device transfer are excluded. | — | `FemioWidgetProvider.kt:36-39`, `attachment_store.dart:64`, `backup_rules.xml`, `data_extraction_rules.xml`, `AndroidManifest.xml:25-37` | VERIFIED |

Dart has no network client: the tripwire passed (§5).

Firebase is set up lazily, only through the assistant channel. `status()` (`FemioAssistant.kt:93`)
already calls `firebase()`, which installs App Check, even when Cloud boost is off. Whether that
alone makes a network call is NOT VERIFIED (see PRIV-15).

---

## 2 · Claims compared with the code

| # | Claim (quoted, shortened) | Where | What the code does | Verdict |
|---|---|---|---|---|
| C1 | "femio removes numbers, dates, **names** and contacts first" | Consent text `app_en.arb:855` (`boostAgreeQuestions`); `aiSeesApprovedQuestion` `:1206`; web `en.json:1160`, `:1300`, `:1843`; LIVE privacy page and consumer health data page; Play listing `play-listing.en.md:60`; Devpost `DEVPOST_SUBMISSION.md:38` | `toCloudSafe` strips only `\S+@\S+`, URLs and digit runs (`redaction.dart:57-59,69-74`). **No name removal.** Spelled-out dates ("in March", "last Tuesday") survive. No test covers names (`assistant_core_test.dart:131-158`). | **MISMATCH** |
| C2 | "Ready. It reads your notes on the phone; **nothing is sent**." | `app_en.arb:801` | Her words stay on the phone (`ONLY_ON_DEVICE`, `FemioAssistant.kt:118`; Dart drops any non-`ON_DEVICE` reply, `assistant_channel.dart:101`). But ML Kit GenAI telemetry with identifiers is documented by Google (F4). | **MISMATCH** (content true; "nothing" not verified) |
| C3 | "No account … **no analytics**" | Play listing `play-listing.en.md:24,27`; web `en.json:1135`, `:1839`; `leaveNever` `app_en.arb:1178` | No analytics SDK of femio's own: VERIFIED (pubspec, tripwire). The bundled Google library does "diagnostics and usage analytics" (F4). | **MISMATCH**, pending traffic proof |
| C4 | Data safety: "Device or other IDs: **leave unticked**"; no "App info and performance" row | `docs/store/data-safety-and-declarations.md:35` | Google's ML Kit disclosure lists identifiers for GenAI features. The doc's own dex check found "ML Kit common" registered. | **MISMATCH** (likely) |
| C5 | "No contacts, **photos**, location or **files**" | Web `en.json:1152`; LIVE `/en/privacy` | `image_picker` 1.2.2 and `file_picker` 13.3.0 attach photos and documents to her record (R11.2, `attachment_store.dart`) | **MISMATCH** (LOCAL CODE vs LIVE SITE; PROGRESS R11.2a is open) |
| C6 | "What the app stores": birth year, cycle dates, symptoms, mood, notes, weight, appointments, pregnancy, movements, contractions | Web `en.json:1148`; health data list `:1290s`; LIVE | Also stores medicines with dose marks (R11.6), lab results and visits (R11), documents and photos, BBT, OPK and discharge. Also **sexual-activity terms** (intercourse, libido, pain during sex), which are GDPR Art. 9 "sex life" data (`pseudonymised_profile.dart:213-214`). | **MISMATCH** (incomplete) |
| C7 | "birth year (**only** to check that you are 18 or over)"; "The app asks your birth year once and stops if you are under 18" | Web `en.json:1148`, Age section | The age gate is a yes/no question: "Has your 18th birthday passed? … Nothing here is saved" (`app_en.arb:29-30`). Birth year is asked separately "so this shapes what femio expects" (`:25-26`), stored (`profile.dart:302`) and used in tip reasons. | **MISMATCH** (purpose) |
| C8 | "a notification shows only 'femio'" | Web `en.json:1211`; LIVE | Medicine reminders show her own words if she writes them (`app_en.arb:505,516,2146-2150`). The app discloses this; the website does not. | **MISMATCH** (website) |
| C9 | "It uses the internet **only** for its AI features" | Web summary `en.json:1135`; LIVE | Play update and rating prompts and Billing (F6) also use it. The full list further down names Google Play. | Minor mismatch |
| C10 | "This is the **complete list**" / "Nothing else leaves" | Web `en.json:1156`, `:1839`; app `app_en.arb:1178` | The app list includes sharing (`leaveShareBody`). It omits the unencrypted CSV export (F8) and clipboard copy. The website lists neither sharing nor CSV. | Partial mismatch |
| C11 | Cloud boost "off unless you agree", per purpose, dated and versioned receipt, withdrawal recorded, a restored backup asks again | App `:812-881`; web; ADR-080 | `CloudConsent` (`cloud_consent.dart:17,78-99`). Nothing is pre-ticked (`cloud_boost_screen.dart:48`). Grant at `:149`, withdraw at `:98` and `assistant_settings_screen.dart:137`. Restore at `backup.dart:78`. Gate at `assistant_gateway.dart:107`. Tests: `cloud_consent_test.dart:13-62`, `assistant_gateway_test.dart:126-160`. | **MATCH** (tests read, not run) |
| C12 | "Your notes, dates, log entries, cycle lengths, name, email, contacts or advertising ID" are never sent | `app_en.arb:852` | `CloudPrompt` has only the two factories (tripwire `analytics-lint.mjs:251-258`). The profile is bands only (`pseudonymised_profile.dart:258-263`). `AD_ID` is removed (`AndroidManifest.xml:25-28`). | **MATCH** |
| C13 | "Google also sees your phone's internet address, and a check from Google Play" | `app_en.arb:863`; web `:1164` | App Check is installed (`FemioAssistant.kt:159`). The web text also names the library-version header. | **MATCH** |
| C14 | "Gemini Developer API, paid tier"; "Google does not use it to improve its products"; "keeps it up to 55 days"; "We keep Google's optional request logging switched off" | `app_en.arb:860-862`; web `:1189-1192` | Depends on console state: billing plan, AI Studio logging, Firebase AI monitoring (owner actions 29 and 30) | **NOT VERIFIED** (OWNER) |
| C15 | "Records … encrypted with a key held by your phone's secure hardware" | Web `:1148` | Record and documents are sealed with the key in `flutter_secure_storage` (`key_vault.dart`, `attachment_store.dart:64`). Widget strings and scheduled-notification text are in plain SharedPreferences (opt-in, small). | **MATCH**, with a small exception |
| C16 | "We have switched off Android's automatic cloud backup and phone-to-phone transfer" | Web | `allowBackup="false"` plus full exclusions in both rule files | **MATCH** |
| C17 | "Visit counts, without cookies" (Vercel Web Analytics) | Web `:1222`; LIVE | Code renders `<Analytics beforeSend={pathOnly}/>` (`visit-measurement.tsx`). **LIVE: `/_vercel/insights/script.js` returns 404**, so nothing is counted today. LIVE also sets a session cookie `NEXT_LOCALE=en`. | Over-disclosed (harmless); cookie not named |
| C18 | "until you allow ads, no ad is shown … your browser still loads Google's ad script" | Web `:1226`; LIVE | Code: Consent Mode default is all denied, and a unit fills only after an `ad_storage` grant (`ad-consent.ts`, `consent-mode-default.ts`). **LIVE: no AdSense client set.** `ads.txt` says "no advertising configured", and the CSP has no ad hosts, so no ad script loads. | Over-disclosed (harmless) |
| C19 | "Our links send the other site only our address, never the page" | Web | LIVE header `Referrer-Policy: strict-origin-when-cross-origin` | **MATCH** (VERIFIED live) |
| C20 | "No dates, free text, names, contacts or **identifiers of any kind**" | Devpost `:37` | True of the profile payload. Not true of the request: IP, App Check token, heartbeat, and possibly ML Kit identifiers (F4). | Overclaim |
| C21 | "a build-time tripwire fails … if network code appears outside the one allowed layer" | Devpost `:43` | The tripwire scans Dart `lib/` for network code. In Kotlin it checks only Firebase imports and search grounding (`analytics-lint.mjs:216-237`). | Overclaim |
| C22 | Requests "never silently [go] to the cloud"; private features `ONLY_ON_DEVICE` | Devpost `:36`; `FemioAssistant.kt` header | `private()` uses `ONLY_ON_DEVICE` (`:118`), and Dart double-checks the source (`assistant_channel.dart:101`) | **MATCH** |

---

## 3 · Findings

Severity:
- **P0**: a false privacy statement shipping now, or a cloud path without consent.
- **P1**: fix before the Play release.
- **P2**: polish.

| ID | Sev | Finding | Evidence | Verified | Scope | Fix | Owner |
|---|---|---|---|---|---|---|---|
| PRIV-1 | **P0** | The consent text, both live website policies, the Play listing and Devpost all say femio removes **names** (and dates) from a Cloud boost question. The code removes only digits, emails and URLs. A question such as "Can Sara take letrozole while breastfeeding" goes out with the name. Mitigation: she sees and can edit the exact text first (`ask_screen.dart:136-137`). P0 because the sentence is live on femioapp.com now and sits in the consent text she agrees to (GDPR Art. 7 and 9: consent must be informed). | `redaction.dart:57-80`; `app_en.arb:855,1206`; `en.json:1160,1300,1843`; LIVE `/en/privacy` and `/en/consumer-health-data` (text extracted 2026-11-26); `play-listing.en.md:60`; `DEVPOST_SUBMISSION.md:38` | VERIFIED | LIVE SITE + LOCAL CODE | Either (a) drop "names" and say "numbers, links and email addresses" in all four languages, everywhere listed, and bump `cloudConsentVersion` to 2. Or (b) add name and month or weekday stripping (a capitalised-token heuristic is weak in Arabic), keep the claim, and add tests. (a) is the honest fast fix. | — |
| PRIV-2 | P1 | The on-device AI library brings `com.google.mlkit:genai-prompt`. Google documents that its GenAI features collect "user, device or other identifiers", per-installation IDs, device and app info, latency, input and output **size** and event types for "diagnostics and usage analytics". This likely happens even with Cloud boost off. It contradicts "nothing is sent", "no analytics" and the Data safety plan to leave "Device or other IDs" unticked. A Data safety form that is wrong is a Play policy violation. "No analytics" plus an SDK that collects is the Flo pattern. | POM `firebase-ai-ondevice-16.0.0-beta08.pom` (runtime dep `genai-prompt 1.0.0-beta5`, fetched 2026-11-26); developers.google.com/ml-kit/android-data-disclosure (GenAI rows); `app_en.arb:801,1171,1178`; `data-safety-and-declarations.md:35`; `play-listing.en.md:24,27` | Dependency VERIFIED; traffic NOT VERIFIED | LOCAL CODE | Run owner action 33 (PCAPdroid or HTTP Toolkit capture). Check whether `FirebaseApp.setDataCollectionDefaultEnabled(false)` or an ML Kit switch stops it (not verified). If it does not: declare **Device or other IDs** and **App info and performance → Diagnostics** (collected, not shared, app functionality and analytics by the SDK). Change "nothing is sent" to "your words are not sent; Google's AI software sends technical usage data". Change "no analytics" to "no analytics of our own". Move the web and app "technical information" line out of "If you tap Download" so it covers every on-phone AI use. | OWNER (capture) |
| PRIV-3 | P1 | The website privacy and consumer health data policies omit the R11 record: documents and photos, medicines and dose marks, lab results, visits, BBT, OPK, discharge. They also omit **sexual-activity** logs, which are Art. 9 "sex life" data and MHMDA consumer health data. They still say "No … photos … or files". | `en.json:1148,1152`, health data list; R11.2a open in `PROGRESS.md:264`; `pubspec.yaml` (`image_picker`, `file_picker`); `pseudonymised_profile.dart:213-214` | VERIFIED | LIVE SITE vs LOCAL CODE | Do R11.2a now. Rewrite "What the app stores" and the consumer health data list from the schema v3 types. Replace "No … photos or files" with "Photos and documents you choose stay on your phone, sealed". Add the camera intent (no CAMERA permission). Do it in four languages and bump the privacy edition. | Lawyer review (36) |
| PRIV-4 | P1 | Birth-year purpose is stated wrongly. The policy says the birth year is "only to check that you are 18". In the app the 18+ check is a separate yes/no that saves nothing. The birth year is kept and shapes predictions and tip reasons. | `en.json:1148` + Age section; `app_en.arb:25-30`; `profile.dart:302,429` | VERIFIED | LIVE SITE vs LOCAL CODE | Restate: "your birth year, to tailor what femio expects at your age; a separate question confirms you are 18 or over". | — |
| PRIV-5 | P1 | The website says a notification shows only "femio". Medicine reminders show the words she writes. | `en.json:1211`; `app_en.arb:505,516,2146-2150` | VERIFIED | LIVE SITE vs LOCAL CODE | Add "unless you write your own words for a medicine reminder" to the web policy (four languages) and the Play listing line 56. | — |
| PRIV-6 | P1 | The consent text and policies assert console facts no one has checked: Gemini **paid** tier (Blaze billing), AI Studio request logging off, Firebase AI monitoring prompts off, Firebase data sharing off. If the project runs on the unpaid tier, `boostKept` ("Google does not use it to improve its products") is false. | `app_en.arb:860-862`; `en.json:1189-1192`; `OWNER_ACTIONS.md` rows 29, 30 | NOT VERIFIED | Console | Confirm the Blaze plan, logging off, monitoring prompts off and data sharing off. Screenshot each into `docs/compliance/evidence/`. | **OWNER** (29, 30) |
| PRIV-7 | P2 | "Complete list" gaps. The website lists neither user sharing nor the CSV export. The app's "Nothing else leaves" omits the **unencrypted** CSV, which the system save dialog can put on a cloud drive. Clipboard copy of the visit pack can sync through keyboard or OEM clipboard clouds. | `en.json:1156,1839`; `app_en.arb:1178,2010`; `csv_actions.dart:46` | VERIFIED | LIVE SITE + LOCAL CODE | Add "Files you export or share" (CSV, documents, visit pack) to both lists. | — |
| PRIV-8 | P2 | The website summary says the app uses the internet "only for its AI features". Google Play's update, rating and billing traffic is missing there, though it appears in the full list. The repo adds a Play update/rating sentence that the live site lacks: the live build is older (`9450300` came after `2bdbe7c`). | `en.json:1135`; LIVE text check (`"Google Play also checks"` absent) | VERIFIED | LIVE SITE | Edit the summary line. Redeploy after the PRIV-1, 3, 4 and 5 fixes. | OWNER (deploy) |
| PRIV-9 | P2 | Live site against its own policy: Vercel Web Analytics is **not enabled** (`/_vercel/insights/script.js` 404). AdSense is unconfigured (`ads.txt`: "no advertising configured"; CSP has no ad hosts). The privacy pages show **Effective date 2026-11-30**, a future date, on a page already live. | `curl` 2026-11-26: 404 on the script; `ads.txt` body; LIVE CSP header; `placeholders.ts:35-37` | VERIFIED | LIVE SITE | Do owner action 31, or say "may count visits". Set the effective date to the deploy day. | **OWNER** (31) |
| PRIV-10 | P2 | The live site sets the session cookie `NEXT_LOCALE` on every response. The policy says only "may remember your language … in your browser" next to "counts visits without cookies". It is probably exempt as a UI-preference cookie (not verified), but it should be named. | LIVE response header `Set-Cookie: NEXT_LOCALE=en; Path=/; SameSite=lax` | VERIFIED | LIVE SITE | Add: "one session cookie, NEXT_LOCALE, remembers your language; it is deleted when you close the browser". | — |
| PRIV-11 | P2 | Tripwire gaps compared with what is claimed for it: (a) Kotlin network code outside `assistant/` (java.net, OkHttp, Ktor) is not checked; only Firebase imports are. (b) Gradle checks only Firebase, google-services, crashlytics, analytics and messaging, so any other tracking SDK added in Gradle passes. (c) The merged-manifest checks skip silently when no build exists, as in this worktree (no `apps/mobile/build/app`). (d) No check binds consent or policy wording to the code. That is why PRIV-1 passed. | `analytics-lint.mjs:199-237,324-333`; run output below | VERIFIED | LOCAL CODE | Add a Kotlin network regex outside `assistant/`. Allow-list Gradle `implementation` lines. Fail (or warn loudly in CI) when no merged manifest exists for a release job. Add a Dart test per claim, for example "a name in a general question is removed". | — |
| PRIV-12 | P2 | Redaction is heuristic: a first-person word list in four languages plus digit stripping. Third-person questions with personal detail, and dialect forms not in the list (for example "بنتي" or a bare "حامل") pass to the approval box. The approval step is the real control. | `redaction.dart:29-55`; `assistant_core_test.dart:131-158` | VERIFIED (code) | LOCAL CODE | Keep the approval box. Expand the lexicon from persona phrasings. Optionally block on detected given names. | — |
| PRIV-13 | P2 | The consent receipt stores purposes, UTC time and version, but not the **language** of the text shown. The only proof is on her phone, which meets GDPR Art. 7(1) only "partly", as the repo's own review says. PRIVACY_REVIEW §4 lists v1 as "not yet released". | `cloud_consent.dart:33-47`; `PRIVACY_REVIEW_2026-11-24.md` §2, §4 | VERIFIED | LOCAL CODE | Add `lang` to the receipt. Archive each version's four-language text with its release date. Ask the lawyer whether proof on the phone is enough. | Lawyer (36) |
| PRIV-14 | P2 | Small unencrypted stores sit beside the "encrypted" claim: widget lines when details are on, and scheduled-notification text, including her medicine-reminder words, in plugin SharedPreferences. Note fields do not set `enableIMEPersonalizedLearning: false`, so the keyboard may learn her health words. Gboard's cloud voice typing is outside femio's control, yet `app_en.arb:644` says her words are "not … sent anywhere". | `FemioWidgetProvider.kt:36-39`; grep shows no `enableIMEPersonalizedLearning` in `lib/` | VERIFIED (code); keyboard behaviour NOT VERIFIED | LOCAL CODE | Set `enableIMEPersonalizedLearning: false` on the note, Say-it and Ask fields. Add a line to the policy: "widget and reminder text you turn on are stored unencrypted so Android can show them". | — |
| PRIV-15 | P2 | `status()` initialises the Firebase app and installs App Check (Play Integrity) the first time any assistant status is read, with or without consent. It probably makes no network call until a cloud request (not verified). If it does, femio contacts Google with Cloud boost off. | `FemioAssistant.kt:93-104,149-163` | NOT VERIFIED (traffic) | LOCAL CODE | Install App Check only inside `hybrid()`. Confirm with the owner action 33 capture. | OWNER (33) |
| PRIV-16 | P2 | Devpost overclaims: "identifiers of any kind" (IP, App Check token, heartbeat and possibly ML Kit IDs travel), and a tripwire on "network code outside the one allowed layer" (it covers Dart only). | `DEVPOST_SUBMISSION.md:37,43` | VERIFIED | Devpost | Say "no personal identifiers from femio; Google sees the IP address and an app-integrity token". Scope the tripwire sentence to "the app's Dart code". | — |

**No P0 for consent.** I found **no code path that reaches the cloud without a current receipt.**
`runHybrid` has one caller (tripwire, `analytics-lint.mjs:276-281`). That caller refuses unless
`consent.allows(purpose)` holds on the current `cloudConsentVersion` (`assistant_gateway.dart:107`,
`cloud_consent.dart:78-81`). The default is an empty log. The legacy hackathon `cloudBoost` flag
is not consent (`cloud_consent_test.dart:47`). A restore withdraws (`backup.dart:78`).

---

## 4 · Consent receipts (question 4)

| Requirement | Code | Test (read, not run) | Verdict |
|---|---|---|---|
| Default off | `CloudConsent()` has an empty log, so `allows` is false (`cloud_consent.dart:68,78-81`) | `cloud_consent_test.dart:13` | Met |
| Specific, per purpose, unbundled | `CloudPurpose {questions, tips}`. Unticked boxes (`cloud_boost_screen.dart:48`). The Agree button is disabled until one is ticked (`:147-149`). | `:19` | Met |
| Dated and versioned | `CloudConsentEvent(purposes, at ISO UTC, version)` (`:33-47`) | `:19,51` | Met. The language is not recorded (PRIV-13). |
| Wording change lapses consent | `c.version == cloudConsentVersion` (`:80`). Text unchanged since `e5695a9` (git log -G on every `boost*` key). | `:34` | Met |
| Withdrawal recorded and as easy as consent | An empty purpose set is appended (`:94-95`). One tap on the screen (`:98`) or the Settings switch (`assistant_settings_screen.dart:137`). | `:27`; gateway `:140` | Met |
| No carry-over to a new phone | `afterRestore` → `withdraw` (`backup.dart:78`) | `:62` | Met |
| Damaged log means no consent | Bad entries are dropped (`:109-116`) | `:41` | Met |
| Consent checked before every cloud call | `_hybrid` gate (`assistant_gateway.dart:107`). The ask screen also checks (`ask_screen.dart:131`). | `assistant_gateway_test.dart:126-160` (no consent, wrong purpose, withdrawn, master switch off) | Met |
| Receipt of what was sent | The ledger keeps `prompt.text` for cloud or unknown-location calls (`assistant_gateway.dart:116`) | `r10_transparency_logic_test.dart` | Met |

Gap: there is no gateway test for `answerWithBoost` **without** consent. The tips path is tested
both ways. The ask path is tested only with consent (`assistant_boundary_test.dart:128`). The code
path is shared (`_hybrid`), so the risk is low. Add the test anyway.

---

## 5 · Privacy tripwire (question 5)

Command, run from the repo root on 2026-11-26. It exited 0.

```
$ node scripts/analytics-lint.mjs
✓ privacy tripwire: no analytics, error-reporting or database client in either product; website: no Tag Manager, GA4 or Meta pixel, Vercel Web Analytics (cookieless, path only) the only measurement, AdSense host inside lib/ads only, ad units only in the article and hub; app: no ads, analytics or attribution package and no ad-ID permission (source and merged manifest), no network code of its own, Firebase AI Logic only inside the Kotlin assistant behind CloudPrompt (CloudSafeText or PseudonymisedProfile only), no search grounding, no personal permission (source and merged manifest, when built).
EXIT=0
```

What it really guards (read in full, 350 lines):

- **Website:**
  - forbidden packages;
  - tracking hosts in `src/`;
  - `dataLayer.push` only in `lib/ads`;
  - `@vercel/analytics` only in `visit-measurement.tsx`;
  - ad units only in article and hub pages.
- **App:**
  - forbidden pub packages (direct dependencies only);
  - no HTTP client, socket, WebSocket or network image in Dart `lib/`;
  - Gradle Firebase artifacts limited to AI, AI on-device and App Check;
  - Firebase imports in Kotlin only under `assistant/`;
  - no search grounding;
  - one file names the assistant channel;
  - `runHybrid(CloudPrompt` and `runPrivate(PrivatePrompt` signatures;
  - `CloudPrompt` has exactly the two factories and a private constructor;
  - only the gateway calls the model;
  - `AD_ID` and ad-services permissions removed;
  - no personal permissions;
  - merged manifests checked when present.

Does it cover the claims? **It covers the structural claims (C11, C12, C22) well.** It does not cover:

- wording claims (C1, C7, C8);
- SDK telemetry (C2 to C4);
- Kotlin network code outside the assistant package, or non-Firebase Gradle SDKs (PRIV-11);
- merged manifests in a fresh checkout. In this worktree they were skipped silently.

The data-safety doc records a release merge from 2026-11-25. I did not see it. The only merged
manifests on disk (main checkout, dated 29 Oct) are stale AdMob-era builds that still contain
`AD_ID`.

---

## 6 · Website (question 6)

Live checks, 2026-11-26, with curl on `/en`, `/en/privacy`, `/en/consumer-health-data`,
`/en/learn` and `/ar/privacy`.

**Third-party origins in the HTML.** None loads a script. The only external hrefs are
`findahelpline.com` and the site's own origin. No `googletagmanager`, `gtag`, `googlesyndication`,
`adsbygoogle` or Meta pixel appears in the HTML. VERIFIED.

**Headers.**
- CSP: `script-src 'self' 'unsafe-inline'; connect-src 'self'; frame-src 'none'`. No ad hosts, because the ad client is unset (`next.config.mjs:20-49`).
- `Referrer-Policy: strict-origin-when-cross-origin`.
- `Permissions-Policy` denies camera, microphone and geolocation.
- `Set-Cookie: NEXT_LOCALE=en` (a session cookie).

VERIFIED.

**JS bundles.** The Vercel Analytics loader is present (`/_vercel/insights/script.js` is named in
the chunk) but the script returns **404**, so nothing is collected. The ad unit code is present in
the Learn chunk, inert without the client id. `ads.txt` says "no advertising configured".
VERIFIED.

**Repo code.**
- Analytics strip the query and hash (`visit-measurement.tsx`).
- AdSense loads only on content pages, after an inline Consent Mode default with everything denied (`adsense-script.tsx`, `consent-mode-default.ts`).
- A unit fills only after an `ad_storage` grant (`ad-consent.ts`).

The code matches the policy. When the owner switches AdSense on:
- the ad script will load on health article pages **before** consent;
- the policy already discloses that;
- the referrer header still hides the path.

What the loaded script itself reports before consent (page URL or context) is NOT VERIFIED. Test
it with a browser capture on the day.

**Live policy compared with the repo policy.** The text is identical apart from the Google Play
update and rating sentence, which is in the repo (`9450300`) and not live. Both share PRIV-1, 3, 4
and 5. The live effective date is 2026-11-30, in the future (PRIV-9). Both footers link
`/consumer-health-data` on every page, including home, as RCW 19.373.020 requires. VERIFIED on
`/en`.

---

## 7 · Legal exposure for a Play release from Egypt to Saudi Arabia, Egypt and the EU (question 7)

All items are **OWNER**: decisions or paid advice only Khaled can buy. Treat legal citations not
confirmed in `PRIVACY_REVIEW_2026-11-24.md` as `[NEEDS SOURCE]`.

### What the lawyer review (owner action 36) must cover

1. **Controller analysis.** Is femio a controller of records that never leave the phone (the
   on-device-only theory)? It clearly is for Cloud boost and for website logs. Get the notice's
   "data controller" wording confirmed.
2. **Consent validity in four languages.** The Arabic consent text must carry the same scope.
   Settle PRIV-1 before the lawyer reads it. Is on-phone proof of consent enough under GDPR
   Art. 7(1), Saudi PDPL and Egypt Law 151 (PRIV-13)?
3. **Processor terms for Google.**
   - Is the *Gemini Developer API* (not Vertex AI) covered by Google's processor terms or the Cloud DPA? The repo's review marks this not verified.
   - Do the paid-tier and abuse-monitoring terms (55 days, human review) fit health data?
   - Does Google's Generative AI prohibited-use policy allow health summarisation `[NEEDS SOURCE]`?
4. **Cross-border transfers.**
   - EU and UK: SCCs and DPF through Google.
   - **Saudi PDPL:** health data leaving the Kingdom, the Transfer Regulation conditions, and whether a risk assessment is needed beyond the DPIA in §3 of the review.
   - **Egypt Law 151:** a cross-border transfer licence or permit (Arts. 14-15).
5. **Telemetry (PRIV-2).** Does ML Kit's identifier-bearing telemetry from a fertility app make
   Google an independent controller or a processor? Does it need consent under ePrivacy Art. 5(3)
   (device access for non-essential purposes) in the EU and UK? Decide the Data safety answers.
6. **US exposure.** MHMDA applies if the app or site targets Washington consumers. Check the Play
   country list. Decide whether aggregate Vercel analytics of health-page paths is "consumer health
   data", given the claim that the website "collects no consumer health data". Check the FTC Health
   Breach Notification Rule fit.
7. **DPIA sign-off.** Records of processing (GDPR Art. 30; the small-business exemption does not
   apply to Art. 9 data). The breach plan's 72-hour clocks.
8. **Play policies.** User Data policy (prominent disclosure: met), Health apps declaration, Data
   safety truthfulness (PRIV-2), AI-generated content disclosures.

### Owner actions 34 and 35

**EU/UK representative (34).** GDPR and UK GDPR Art. 27 apply to a non-EU controller offering
services to people in the EU or UK. The "occasional, no large-scale special-category data"
exemption is unlikely to fit a standing Cloud boost that handles health data. Options:

- (a) appoint an EU and a UK representative (a few hundred euros a year, per the repo's note);
- (b) switch Cloud boost off for EEA and UK phones. This does **not** end Art. 27 on its own if the app still offers services there and processes data. Ask the lawyer.
- (c) not distribute in the EEA and UK at launch.

**Egypt PDPC licence (35).** Law 151 Art. 12 covers processing sensitive data, including health
data. The Executive Regulations (Decision 816/2025) start the licensing regime; the grace period
reportedly ended about 1 Nov 2026 `[NEEDS SOURCE]`. Ask:

- whether a sole proprietorship whose only sensitive-data processing is consented Cloud boost needs the licence;
- whether a DPO appointment is required `[NEEDS SOURCE]`;
- whether a transfer permit is needed for Google (US).

**Saudi PDPL (add to 36).** Ask:

- whether a controller outside the Kingdom serving Saudi residents must appoint a representative or register on SDAIA's national register `[NEEDS SOURCE]`;
- the 72-hour breach notice;
- whether consent covers the health-data transfer.

### A bigger idea for the owner (not asked)

Switch the cloud backend from `GenerativeBackend.googleAI()` to Firebase AI Logic's **Vertex AI**
backend with a regional location: an EU region for EU users, and possibly `me-central2` (Dammam)
for Saudi users. That brings:

- Google Cloud's data processing addendum;
- region pinning;
- a cleaner transfer story;
- no AI Studio logging question.

Whether Gemini Flash-Lite is offered in those regions through Firebase AI Logic is **not verified**.
Check before deciding. It is a one-line change in `FemioAssistant.kt:141` plus consent-text v2.

---

## 8 · Facts, hypotheses, unknowns

**Facts (VERIFIED):**
- PRIV-1, 3, 4, 5, 7, 8, 9, 10, 11, 12, 13, 16.
- The consent gate (§4).
- The tripwire run (§5).
- The live HTML, headers, 404 and `ads.txt` (§6).
- The `firebase-ai-ondevice` → `genai-prompt` dependency.

**Hypotheses:**
- PRIV-2: that ML Kit telemetry is actually sent in this build, and with which identifiers.
- PRIV-15: that `status()` makes no network call.
- What the AdSense script reports before consent.

**Unknowns (OWNER):**
- PRIV-6 console states.
- Google's terms coverage for the Gemini Developer API.
- Saudi and Egyptian licensing and representative duties.
- The Play country list (MHMDA reach).
