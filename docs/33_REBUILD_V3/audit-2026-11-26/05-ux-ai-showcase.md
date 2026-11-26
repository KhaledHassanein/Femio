# 05 · UX and AI showcase: what a #BuildHybridAI judge sees (audit 2026-11-26)

Agent-facing audit record. Read-only review of worktree `judge-audit-bd6d27` at `fb45488`, plus the live
site on 2026-11-26. Scope: the judge's journey, how visible the AI is, and the submission assets.
Per-screen Stitch comparison is out of scope (another agent covers it).

Labels used below:
- **LOCAL CODE**: read in the repo.
- **LIVE SITE**: fetched from femioapp.com today.
- **RENDER**: a PNG/WebP in the repo.
- **VERIFIED**: checked directly.
- **NOT VERIFIED**: inferred, or needs a real device.

Every AI render in the repo comes from a **fake bridge (synthetic)**, as PROGRESS R7.4 records: "13 screenshots
... from a fake bridge, synthetic; ... not yet run against real Firebase or Nano". No real Gemini Nano or cloud
output has been seen by anyone yet.

---

## Scores

| Score | Value | Why (facts first, then opinion) |
|---|---|---|
| **Hybrid-AI showcase** | **4 / 10** | **Facts:** the hybrid architecture is real in code: `ONLY_ON_DEVICE` / `PREFER_ON_DEVICE` (`FemioAssistant.kt:117-132`), a typed `CloudPrompt`, consent, a ledger. The first-run Welcome screen says "AI-assisted women's health & wellness" (`welcome_step.dart:61`). But the first viewport of Today shows no AI at all (render `testing-results/2026-11-26-r8-add-sheet/nav_ar_dark.png`; `today_screen.dart:213-247` puts Ask femio after the hero, the log buttons and medicines). Gemini Nano is credited on screen in only two places: the Ask answer label, and the Say it footnote when the model *added* something. The demo sentences in the Devpost text and the video script are fully covered by the phrase lexicon, so Nano adds nothing and gets no credit. On a phone without Nano a judge sees no AI at all. The cloud half is never shown running in the video. **Opinion:** the privacy engineering is best-in-class but invisible. A judge has to dig to find the AI. |
| **Presentation and polish** | **6 / 10** | **Facts:** Dusk Bloom is consistent; Arabic RTL and Western digits are correct in the renders; the thumbnail is strong and has a clear HYBRID AI strip. Against that: none of the 8 Play screenshots shows AI running (the only Ask shot, `en/08-ask.png`, is the *verbatim, no-AI* path). The synthetic renders show an invented symptom ("Bloating"), a duplicated source and the Flutter DEBUG ribbon. The thumbnail credits WHO/NHS/ACOG as answer sources, which DEVPOST_SUBMISSION cut on purpose. The live home H1 is still about TTC and pregnancy only. No install path exists for a judge (Play "Coming soon"; the Devpost APK and repo links are placeholders). |

---

## 1 · The judge's 10-second journey (cold start, sideloaded APK)

1. **Cold start → Welcome.** `main.dart:22-31` loads the record; `app.dart:561-565` routes `profile == null` to
   `OnboardingFlow`. Welcome shows the Bloom, "femio", and the tagline **"AI-assisted women's health & wellness"**
   (`welcome_step.dart:61`, string `welcomeTagline`). The body text is about privacy only ("Your records stay on this
   phone…"). **This is the only AI cue in the first 10 seconds, and it is a claim, not a demonstration.** LOCAL CODE, VERIFIED.
2. **Tap 1** "Get started" → Goal (`onboarding_flow.dart:186-197`).
3. **Tap 2** pick a goal → Birth year. **Tap 3** Continue (`:203-213`).
4. **Taps 4–5** pick a last-period date, then Continue (`:221-233`). **Tap 6** period length Continue (`:236-249`).
   **Tap 7** cycle length Continue (`:251-273`). TTC only: **tap 8** "trying for" (`:275-285`).
   Onboarding never mentions the assistant. Roughly 40–60 s.
5. **Today.** The first viewport (390×844) shows: header (femio, Help now, Settings), the "Private by design" first-run
   notice (`today_screen.dart:112-130`; it says nothing about AI or the cloud), and the hero. **No AI element, no
   on-device or cloud indicator, no "Gemini Nano ready" chip.** The bottom bar's "+" (`home_shell.dart:118`) has no AI
   mark. On a TTC profile, Ask femio sits about 940 logical px down, below the fold (render
   `testing-results/2026-11-24-r8-today/today_ttc_en_light.png`: the button is at about y=1884 of 4200 px, at 2×).
   LOCAL CODE + RENDER, VERIFIED.
6. **First AI moment, shortest path:** **tap 9** "+" → the sheet's top row is "✦ Tell femio anything, like 'cramps since this
   morning'" (`add_sheet.dart:103-122`, render `add_sheet_en_light.png`) → **tap 10** → the first-use sheet "Meet
   femio's assistant" (`assistant_pill.dart:71-86`, `115-153`). This is the **only screen that explains the
   phone/cloud split** → **tap 11** "Continue on this phone" → Say it sheet → type → **tap 12** "Turn into log
   entries" (`say_it_sheet.dart:172-178`).
   **Result: 9 taps to the first AI entry point and 12 to the first AI output.** The first AI cue comes at second 0 (tagline);
   the first AI proof comes after about 60–90 s.
7. **Alternative door:** scroll Today → "Ask femio" (`today_screen.dart:217-229`). This opens `AskScreen` **directly,
   skipping the first-use explainer**, which only the "+" sheet route shows (`add_sheet.dart:53-55` → `openAssistantDoor`).
   The same applies to Learn's Ask (`learn_screen.dart:71-79`) and Log's "Say it in your words" (`log_screen.dart:186-190`).

### Every AI entry point

| Where | Door | File:line | Explainer shown first? | Notes |
|---|---|---|---|---|
| Bottom bar "+" | Say it pill, Ask femio, For my visit | `add_sheet.dart:103-140` | Yes, once | Hidden when the master switch is off (`:87,103`) |
| Today | Ask femio, Visit summary (outlined, below the fold) | `today_screen.dart:213-247` | No | Not gated by `assistantOn`, unlike "+" (inconsistent, though both work with AI off) |
| Today | "For you" tips card | `tips_card.dart:111-160`, `today_screen.dart:248` | — | Says "Chosen on your phone from your log…" (`:155`), even when Gemini Nano ordered them; Nano never credited |
| Log tab | "Say it in your words" | `log_screen.dart:186-190` | No | |
| Learn header | Ask femio text button | `learn_screen.dart:69-79` | No | |
| Settings → Assistant | master switch, "AI on your phone (Gemini Nano)" status, Cloud boost, What the AI can see, What the AI did | `assistant_settings_screen.dart:73-171`, `settings_screen.dart:120` | — | The **only** place the Nano status appears. 2 taps from Today (gear, then Assistant) |
| Ask "not covered" | → Visit pack | `ask_screen.dart:286-301` | — | |
| `AssistantPill` (FAB) | all three doors | `assistant_pill.dart:22-38` | Yes | **Not mounted on any screen** (grep: no `AssistantPill(` use outside its file) |

### A judge with a sideloaded APK on a phone without Gemini Nano

LOCAL CODE, VERIFIED unless marked.
- `AssistantStatus.canRunPrivate` needs `onDevice == available` (`assistant_channel.dart:29`). Without Nano every private
  call returns `AssistantResult.rules()` (`assistant_gateway.dart:126,156,192`).
- **Ask femio** → the label "Word for word from trusted sources" and raw English passages (`answer_card.dart:40-44,73-85`;
  `ask_screen.dart:119-143`). **No model ran.**
- **Say it** → phrase rules only. The footnote is "This runs on your phone…" without the Nano line
  (`say_it_sheet.dart:221`). The ✦ icon on the button still suggests AI.
- **Tips** → "Chosen on your phone from your log" with rule order (`tips_card.dart:155`).
- **Settings → Assistant** → "Not available on this phone. femio uses its own word list on the phone instead." (string
  `assistantOnDeviceUnavailable`).
- **Cloud boost**: the switch is enabled whenever the build is configured (`canRunHybrid => configured`,
  `assistant_channel.dart:32`). She agrees on the consent screen; Ask then offers "send"; the hybrid call goes out.
  OWNER_ACTIONS #25 keeps **App Check enforcement on through judging**, and the release `AppCheckInstaller` uses Play
  Integrity (`android/app/src/release/.../AppCheckInstaller.kt:13`). A sideloaded APK will therefore likely be refused
  (NOT VERIFIED on a device). The bridge returns null for every failure, and the screen then says **"The AI could not
  write an answer that cites its sources, so here they are word for word."** (`ask_screen.dart:175`, string
  `askModelFellBack`). That blames the model's quality for what is really a connection refusal. The ledger still records
  it as "Sent with Cloud boost" (`assistant_gateway.dart:115-116`). Honest, but it reads as broken.
- **Verdict:** this judge sees **no AI output anywhere**, and one apparent AI failure. Opinion: most judges' phones will
  not have Nano (AICore supports a short list of flagship devices; exact list NOT VERIFIED).
- Also: the build needs `assistant.env`. Without it, `configured == false`, so even a Nano phone shows no AI
  (`assistant_channel.dart:29`, `FemioAssistant.kt:149-151`). The judge APK must be built with it.

---

## 2 · Renders reviewed

| Image | What a judge sees | Verdict |
|---|---|---|
| `testing-results/2026-11-24-r8-today/today_ttc_en_light.png` | Hero range, a when-to-test card with source, temperatures, log buttons, then Ask/Visit, then "For you" with 3 sourced tips | Good hierarchy for the product; AI below the fold; no Nano credit. Built before the "+" bar (R8.29), so the bar is outdated |
| `testing-results/2026-11-26-r8-add-sheet/nav_ar_dark.png` | Today's first viewport in Arabic dark: correct RTL mirror, Western digits, Latin wordmark | RTL VERIFIED correct. Zero AI in the viewport. The "إضافة" label under the raised "+" sits lower than the other labels (P2) |
| `.../add_sheet_en_light.png` | "Add to today" → ✦ Say it pill, filled "Ask femio", "For my visit", flow and mood chips | **The best AI placement in the app**, but it is behind the "+" |
| `docs/store/screenshots/en/01-private.png` … `08-ask.png` (and `ar/`) | 01 privacy, 02 fertile range, 03 irregular, 04 pregnancy, 05 Hijri, 06 Learn, 07 Tools, 08 Ask | Only 08 involves the assistant, and it shows **"Word for word from trusted sources"**: the path where no AI ran. No AI is visible in any store shot |
| `testing-results/2026-11-24-r7-assistant/en_light_say_it.png` | "Bad cramps and a headache today, so tired" → Cramps, Headache, **Bloating**, Fatigue; "Gemini Nano… helped with this"; DEBUG ribbon top right; button "Add to this day's log" | **Do not use.** A fake-bridge "model" added a symptom she never said, which looks like hallucination. The ribbon is visible. The button text is stale (code now says "Save N entries on N days") |
| `.../ar_dark_ask_answer.png`, `apps/web/public/app-screens/ask-en-light.webp` | Label "Summarised on your phone by Gemini Nano", a 2-sentence answer with [1][2], Sources | Synthetic summary text. Sources [1] and [2] are both "Period Pain · MedlinePlus", which looks like a duplicate bug (two passages from one page are not grouped). The question field shows the grey hint, not a typed question. Published on the live /app page tabs |
| `.../2026-11-25-r10-transparency/en_light_ledger.png` | "What the AI did": one ledger entry "On this phone (Gemini Nano)" and one "Sent with Cloud boost" with the exact text sent | **The strongest hybrid-split visual in the product**, buried 3 taps deep. Raw tip ids (`urineInfectionSeeClinician:`) in the receipt look technical (acceptable as a receipt) |
| `apps/web/public/app-screens/boost-en-light.webp` | Consent: two unticked boxes and the 4 bands shown with her values | Clear and credible. Good judge material |
| `docs/hackathon/thumbnail.png` | Title, 6 feature tiles, two phone mocks (Pregnancy Today, Calendar), floating "ON-DEVICE · GEMINI NANO" Say it card, HYBRID AI strip (ONLY_ON_DEVICE → PREFER_ON_DEVICE → App Check) | Strong. But the tile "Answers cited to **WHO, NHS, CDC and ACOG**" contradicts DEVPOST_SUBMISSION line 7 (WHO/NHS/ACOG are further-reading links, not answer sources). Neither phone mock shows an AI screen |

Dusk Bloom adherence (opinion, RENDER): no rings, ranges rather than single dates, no late counter, no photos of people.
Consistent.

---

## 3 · Live website (LIVE SITE, fetched 2026-11-26)

- **https://femioapp.com/en**:
  - H1: "femio is the private companion for trying to conceive and pregnancy."
  - Sub: "…an assistant that runs on your phone…".
  - The AI appears only in the small tagline. "Gemini", "Nano", "hybrid" and "Firebase" do not appear.
  - **Hybrid AI is not the headline.** The same H1 is in the local code (`apps/web/messages/en.json:121`), so this is
    not a deploy lag.
  - It also lags the ADR-078 §8 positioning ("every life stage").
- **https://femioapp.com/en/app**:
  - H1: "Your records never leave your phone."
  - Sub: "A private Android app… with an assistant that runs on your phone."
  - It has "Say it, and it becomes your log", "Ask femio, and see where every sentence comes from", and "What can leave
    this phone", which names Cloud boost, Gemini Nano and AICore. Good privacy-split content.
  - **No install path.** Google Play and iPhone both say "Coming soon" with no link (`en.json:1687,1691`). No APK, no
    GitHub link.
  - Only one app image has alt text (Today). The other screens sit in tabs.
- **Devpost:** "Try it out: https://femioapp.com · `<public GitHub repo>` · `<APK link>`" and "Video: `<YouTube…>`"
  are still placeholders (`DEVPOST_SUBMISSION.md:66-67`). They wait on owner actions 27–28.

---

## 4 · Video script and thumbnail against the code

**The first 20 seconds** (`VIDEO_SCRIPT.md:11-12`):
- 0:00–0:15 shows Today scrolled to For you, whose on-screen text is "Chosen on your phone from your log", with no AI
  shown. The voice-over says "hybrid AI".
- 0:15–0:25 shows Settings → Assistant with Nano "Ready" and Cloud boost "Off".
- So the on-device half appears at about 0:15, as a status line. **The cloud half appears only at 2:15–2:40, and only as
  a consent screen tapped "Not now". The video never shows a cloud inference running.** For a #BuildHybridAI judge that
  is the missing half.

**Script lines checked against the code:**

| Script claim | Code | Status |
|---|---|---|
| Settings → Assistant shows Nano "Ready", Cloud boost "Off" | `assistant_settings_screen.dart:94-123`; strings "Ready. It reads your notes…", "Off. Everything is done on this phone." | Built (LOCAL CODE) |
| Log → Say it → "Turn into log entries, then Add" | `log_screen.dart:186`; save button is "Save {n} entries on {d} days" (`sayItSaveCount`) | Built; **wording mismatch** ("Add" → "Save") |
| "femio's rules and Gemini Nano… turn it into entries" for *"bad cramps, light bleeding and so tired"* | The lexicon covers cramps (`log_phrases_lexicon.dart:272`), tired (`:563`), light (`:1191`, flow `log_phrases.dart:87`). The model only adds; `_usedModel` is true only when it added something (`say_it_sheet.dart:95-98,221`) | **Nano likely adds nothing, so no Nano credit appears on screen.** Not faked, but the demo shows the rules, not the AI. NOT VERIFIED on a device |
| Tips: "Nano only puts them in order" | `tips_card.dart:78` orders only when more than 3 tips fit; the label never names Nano (`:155`) | Built; invisible on screen |
| Ask: "Gemini Nano summarises them with numbered citations… here MedlinePlus" | `ask_screen.dart:119-129`, `answer_card.dart:41` | Built; the MedlinePlus hit for this exact question is NOT VERIFIED |
| "heavy bleeding and dizzy" → ACOG emergency guidance + help page | `safety_notice.dart` heavyBleeding → `safetyHeavyBleedingBody` ("ACOG says: …") + Help now | Built, VERIFIED |
| Cloud boost consent: "four broad facts… general questions she approves" | `boost-en-light.webp`, `cloud_boost_screen.dart` | Built |

**Nothing in the script depends on unbuilt code.** The real risk is that **no real Nano or Firebase run has happened
yet** (PROGRESS R7.4; owner actions 23–26 open). If Nano fails on the demo phone, every AI shot fails with it. Any
fake-bridge render (all of `testing-results/2026-11-24-r7-assistant/`, `app-screens/ask-*`, `today-*` tips) **must not
appear in the video or the Devpost gallery as if it were real output**.

**Thumbnail:**
- Fix the "WHO, NHS, CDC and ACOG" tile.
- "Smart tips & reminders": OK.
- The floating Say it card ("Bad cramps and a headache… → Cramps, Headache, Today") is an illustration of a real
  feature. Acceptable, but note that "Today" is a date chip, not a symptom.

---

## 5 · Findings

| ID | Sev | Finding | Evidence | Status | Source | Fix | Effort |
|---|---|---|---|---|---|---|---|
| UX-1 | **P0** | A judge without Gemini Nano sees no AI output anywhere; Ask shows "Word for word", Say it shows rules only | `assistant_channel.dart:29`; `assistant_gateway.dart:126,156`; `answer_card.dart:43` | VERIFIED (code path) | LOCAL CODE | Make the AI *state* visible even when it is absent (UX-2 chip), give an honest Cloud boost path that works for judges (UX-3), and write testing instructions that set expectations | S–M |
| UX-2 | **P0** | Today's first viewport has no AI element and no on-device/cloud indicator; Nano status lives only in Settings → Assistant | `today_screen.dart:84-131,213-247`; render `nav_ar_dark.png`, `today_ttc_en_light.png` | VERIFIED | LOCAL CODE + RENDER | Status chip under "Today" (proposal 1) and Say it bar above the fold (proposal 2) | S |
| UX-3 | **P0** | With App Check enforced (owner action 25) and a sideloaded APK, Cloud boost is likely refused; the screen blames the AI ("could not write an answer that cites its sources") | `release/AppCheckInstaller.kt:13`; `OWNER_ACTIONS.md:17`; `ask_screen.dart:175`; `assistant_gateway.dart:110-116` | NOT VERIFIED (needs a device) | LOCAL CODE | Owner decides how judges reach the cloud: (a) enforcement off for the judging window, with a hard quota (AI Logic per-user rate limit or API key restriction), or (b) distribute through Play internal testing (Play Integrity verdict for that track NOT VERIFIED). Separately, have the bridge return a reason so the screen can say "Cloud boost could not connect" | M |
| UX-4 | **P0** | No install path for a judge: Play "Coming soon" with no link, Devpost APK and repo links are placeholders | LIVE `/en/app`; `en.json:1687,1691`; `DEVPOST_SUBMISSION.md:66` | VERIFIED | LIVE SITE + LOCAL CODE | Release APK (built with `assistant.env`) as a GitHub Release on the public repo; link it from Devpost and a "For hackathon judges" README section | S (owner) |
| UX-5 | **P0** | Real Gemini Nano and Firebase have never run; every AI render is synthetic | PROGRESS R7.4 | VERIFIED (ledger) | LOCAL CODE | Owner actions 23–26 first; re-shoot every AI screen on the device | M (owner) |
| UX-6 | P1 | The demo sentences (Devpost step 2, video 0:25) are fully caught by the lexicon, so Nano adds nothing and is never credited on screen | `log_phrases_lexicon.dart:272,340,563,1191`; `say_it_sheet.dart:95-98,221` | VERIFIED (lexicon); outcome on device NOT VERIFIED | LOCAL CODE | Credit the model whenever it *ran* ("Checked by Gemini Nano on this phone"), not only when it added; pick a demo sentence outside the lexicon and confirm it on the device | S |
| UX-7 | P1 | Nano work on tips and visit questions is never attributed (`tipsChosenOnPhone` is shown even after Nano ordered them) | `tips_card.dart:89-93,155`; `visit_summary_screen.dart:59-61` | VERIFIED | LOCAL CODE | When `ranOn == phone`: "Put in order by Gemini Nano on this phone" | S |
| UX-8 | P1 | The hybrid-split explainer appears only on the "+" route; Today, Learn and Log doors skip it | `today_screen.dart:217-229`; `learn_screen.dart:71-79`; `log_screen.dart:186-190` vs `add_sheet.dart:53-55` | VERIFIED | LOCAL CODE | Route every door through `openAssistantDoor` | S |
| UX-9 | P1 | The only Ask screenshot in the Play set shows the no-AI verbatim path; no store shot shows AI running | `docs/store/screenshots/{en,ar}/08-ask.png` | VERIFIED | RENDER | Re-shoot 08 on a Nano phone; add Say it and the "What the AI did" ledger | M |
| UX-10 | P1 | Synthetic renders show an invented "Bloating", a duplicate "Period Pain" source, the DEBUG ribbon and stale button text | `r7-assistant/en_light_say_it.png`, `ar_dark_ask_answer.png`, `app-screens/ask-*.webp` | VERIFIED | RENDER (live on /app tabs) | Keep them out of Devpost and the video; replace the web `ask-*` images with device captures; group passages from the same page in `AnswerCard` | S–M |
| UX-11 | P1 | Thumbnail says answers are "cited to WHO, NHS, CDC and ACOG", which contradicts the Devpost text (those are read-more links) | `thumbnail.png`; `DEVPOST_SUBMISSION.md:6-7,28` | VERIFIED | RENDER | Change to "CDC, MedlinePlus and NIH"; swap one phone mock for the Ask answer with the Nano label | S |
| UX-12 | P1 | Video never shows a cloud inference; the cloud appears only as a consent screen with "Not now" | `VIDEO_SCRIPT.md:18` | VERIFIED | LOCAL CODE | Add 15 s: a non-Nano phone (or Nano disabled) with Cloud boost on, sending an approved question, plus the ledger receipt "Sent with Cloud boost" and the exact text | S (owner) |
| UX-13 | P1 | Live home H1 is TTC + pregnancy only; hybrid AI is not the headline | LIVE `/en`; `en.json:121` | VERIFIED | LIVE SITE | Hero headline names the private AI companion; add a 3-box hybrid strip (same as the thumbnail) to `/en/app` | S–M |
| UX-14 | P1 | Devpost testing step 2 says tap "Say it in your words", but Today has no such button (it is in Log, or "+" → "Tell femio anything") | `DEVPOST_SUBMISSION.md:81`; `add_sheet.dart:117` | VERIFIED | LOCAL CODE | "Tap + → Tell femio anything" | S |
| UX-15 | P2 | Ask femio uses the `travel_explore` (globe search) icon, which suggests web search in an app that searches offline | `today_screen.dart:227`; `add_sheet.dart:128` | VERIFIED | LOCAL CODE | Use the ✦ / book icon pair | S |
| UX-16 | P2 | Today's Ask and Visit buttons ignore the master switch while "+" hides them | `today_screen.dart:213-247` vs `add_sheet.dart:103` | VERIFIED | LOCAL CODE | Decide one rule. Both work with AI off (rule 7), so show them everywhere with the label "sources only" when off | S |
| UX-17 | P2 | Video says "then Add"; the button says "Save N entries on N days" | `VIDEO_SCRIPT.md:13`; `sayItSaveCount` | VERIFIED | LOCAL CODE | Edit the script | S |
| UX-18 | P2 | The first-run "Private by design" notice says nothing about the assistant or the cloud | `today_screen.dart:112-119`; `firstRunStorageNotice` | VERIFIED | LOCAL CODE | Add one line: "Its AI runs on this phone; the cloud only if you choose." Legal wording check | S |
| UX-19 | P2 | `AssistantPill` (FAB) is unused | `assistant_pill.dart:22-38` | VERIFIED | LOCAL CODE | Delete it, or reuse it for proposal 1 | S |
| UX-20 | P2 | In Arabic dark, the "+" label baseline sits lower than the other nav labels | `nav_ar_dark.png` | VERIFIED | RENDER | Align labels | S |

---

## 6 · Proposals, ranked by judge impact against effort (deadline 2026-11-30 14:00 PT)

All respect rule 7. The AI stays a companion: these are read-only status lines, entry points and attribution. Nothing
here lets the AI touch core functions, and every feature still works with AI off.

1. **"How femio's AI runs" chip on Today**, under the "Today" title.
   - Impact: very high. Effort: S.
   - It reads `AssistantScope.of(context).status()` plus the Cloud boost setting and shows one honest line:
     - "✦ Gemini Nano · on this phone" when Nano is available;
     - "✦ On this phone · femio's rules (no on-phone AI here)" when Nano is absent;
     - "+ Cloud boost on" when she has switched it on;
     - "AI off" when the master switch is off.
   - Tapping it opens Settings → Assistant, or "What the AI can see".
   - Purely informational, and it answers "is the split obvious?" in the first viewport, Arabic included.
   - The same chip at the top of Ask, Say it and the tips card makes the split visible everywhere.
2. **Credit the model wherever it ran.** Impact: high. Effort: S. Covers UX-6 and UX-7.
   - Say it: "Checked by Gemini Nano on this phone" whenever the model ran.
   - Tips and visit questions: "Put in order by Gemini Nano".
   - Pick and device-test a demo sentence the lexicon misses, so the video shows Nano adding a chip she then
     confirms. Rule 7 holds: nothing is saved until she confirms.
3. **A judge path that works, stated honestly.** Impact: very high. Effort: S–M, mostly owner. Covers UX-3, UX-4, UX-5.
   - Run owner actions 23–26 now.
   - Build the release APK with `assistant.env` and publish it as a GitHub Release.
   - Choose the App Check stance for the judging window.
   - Make the refusal message honest ("Cloud boost could not connect…").
   - Testing instructions: name Nano-capable phones, and say plainly what a non-Nano phone shows.
4. **Re-shoot every AI asset on the real phone.** Impact: high. Effort: M (owner, about 1 h). Covers UX-9, UX-10, UX-11, UX-12.
   - Video order:
     - 0:00 a split diagram (phone | cloud) taken from the thumbnail strip;
     - 0:05 the Today chip "Gemini Nano · on this phone";
     - Say it with Nano credit;
     - Ask with the Nano label;
     - a cloud run on a second phone;
     - the "What the AI did" ledger showing one on-phone and one cloud receipt.
   - Store shot 08 becomes the Nano answer.
   - Fix the thumbnail source names.
   - Use no fake-bridge image anywhere a judge could take it for real output.
5. **Say it bar on Today, above the fold.** Impact: high. Effort: S.
   - Reuse the "+" sheet's "Tell femio anything" pill (`add_sheet.dart:106-122`) directly under the hero.
   - Route it, and every other door, through `openAssistantDoor` so the hybrid explainer shows once (UX-8).
   - With AI off it still works on rules (rule 7).

Next tier: the website hero and hybrid strip on `/en/app` (UX-13, S–M); Devpost step wording (UX-14, S); the P2 polish items.

**Demo mode with synthetic data: not recommended before the deadline.** A clearly labelled "Try with a sample record"
loader would make tips ordering (which needs more than 3 fitting tips) and the visit summary show something on first
run. But it writes medical-looking data into the record path, needs a clear-out flow and legal wording, and does not
create any AI. That is M–L effort with real risk. If it is built later, it must be labelled on every screen ("Sample
record, not yours") and never mixed with her own record.
