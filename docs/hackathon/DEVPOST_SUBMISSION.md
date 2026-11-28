# Devpost submission: #BuildHybridAI 2026 (final answers, revised 2026-11-28)

Agent-facing record of what femio's Devpost entry promises. **The build must match this text exactly.**
Anything not working by the deadline (2026-11-30, 2:00 PM PT) must be cut from the submission text, never faked.
**Truth pass 2026-11-27 (R14.2, R14.5), checked against the code at `47fe540`:**
- redaction now says "numbers, e-mail addresses and links", not names or dates (JUDGE-3, PRIV-1);
- "no network code" is now "no network code of its own", with the October ad SDK named (JUDGE-5);
- the tripwire is a CI check covering the Dart code, not a build step (C14, PRIV-16);
- "identifiers of any kind" is now what is true: femio attaches none, Google still sees the internet address and an App Check token (PRIV-16);
- PCOS is 10–13% (WHO fact sheet, 22 Jan 2026), with links (JUDGE-16);
- sleep is a kind of symptom, not its own output (JUDGE-15);
- testing steps use the real "+" path, a question without "we", the sideload steps and the honest no-Nano and App Check paths (UX-14, JUDGE-10, REL-3);
- added the ledger, "What the AI can see", Say it over several days and the AI-off switch (JUDGE-12).

Still open before submitting: the APK link and video link (owner, `RELEASE_STEPS.md`), and the real-phone proof run (OWNER_ACTIONS row 43). If Cloud boost has not answered on a real phone by then, cut every sentence that says it does.
Owner rulings in force: no "Arabic-first" framing, no Ramadan content; answers from trusted external sources; whole-life AI-assisted app; opt-in pseudonymised personalisation.
Thumbnail: `docs/hackathon/thumbnail.png` (source `thumbnail.html`, headless Chrome at 1500x1000).

## Project name
Femio: AI Assisted Female Health & Wellness App

## Elevator pitch (192 chars)
Private AI women's health app: log symptoms in your words, get answers cited from trusted sources like CDC and MedlinePlus, personal tips, cycle insights and visit prep. Hybrid Gemini Nano AI.

## About the project
## The problem
A woman's health questions don't wait for clinic hours. At midnight she gets ads, forum guesses, or confident AI answers with no source. The apps that track her health usually ask her to upload the most private data she owns. Infertility affects about 1 in 6 people worldwide ([WHO, 2023](https://www.who.int/news/item/04-04-2023-1-in-6-people-globally-affected-by-infertility)), and PCOS affects an estimated 10–13% of women of reproductive age ([WHO fact sheet](https://www.who.int/news-room/fact-sheets/detail/polycystic-ovary-syndrome)). Yet good, private, sourced help is still hard to find.

I'm a physician and clinical claims auditor. I built femio as the assistant I wanted my own patients to have: useful, sourced and private at the same time.

## What femio does
One app for her whole health life. It adapts its emphasis to her life stage without hiding anything: periods and cycle health, trying to conceive, pregnancy, the year after birth, PCOS and endometriosis, and perimenopause.

- **Say it in your words.** She types how she feels ("bad cramps and a headache since this morning", or "yesterday light spotting, today cramps"). femio's word rules and, where the phone has it, Gemini Nano on the phone turn it into draft entries for each day she mentions: symptoms (including sleep problems), flow, mood and ovulation tests. She unticks anything wrong; nothing is saved until she taps Save.
- **Ask femio.** Health questions answered only from a library of trusted sources carried on the phone: passages from CDC, MedlinePlus, the US Office on Women's Health and NIH, with further reading from WHO, NHS, ACOG, RCOG and NICE. It works offline. Every answer numbers its sources and shows publisher, link and date. If the sources don't cover it, femio says so instead of guessing.
- **Cycle and pregnancy views.** Predictions shown as ranges with confidence, never a single certain date or a verdict.
- **Personal tips.** Reviewed tips, each with its source, chosen on her phone from her life stage and what she logs; Gemini Nano only puts them in order. Reminders stay neutral.
- **Visit prep.** A one-page summary of her recent months and a question list for her next appointment; she can write her worry in her own words and femio offers reviewed questions to match.
- **She can check the AI.** "What the AI can see" lists, for each AI feature, where it runs and exactly what it receives. "What the AI did" is a list, kept only on her phone, of every model call; for a Cloud boost call it keeps the exact text that was sent, as her receipt.
- **AI off, everything still works.** One switch turns every AI use off, on the phone and in the cloud. Each feature then answers from femio's rules and shows the sources word for word.
- **Safety before AI.** Red-flag wording (heavy bleeding with dizziness, reduced fetal movement, warning signs in the year after birth, thoughts of self-harm) opens emergency guidance and local help numbers before any model runs. femio educates and tracks; it never diagnoses and never replaces a clinician.
- **Private by design.** No account, no ads, no analytics or tracking SDK in the app. Backup is a file she saves herself. The app has no network code of its own: it reaches the internet only through Firebase AI Logic and App Check, Android's AICore (to download Gemini Nano), and Google Play (updates, ratings, purchases). Available in English, Arabic, French and Spanish.

## Where the AI helps her, in plain words

femio never asks her to "chat with the AI". The AI shows up inside things she already does, and
every one of them still works when the AI is off.

- **She says her day in one sentence.** "Cramps since this morning, tired, didn't sleep" becomes
  today's log, ready for her to tick and save, instead of hunting through forty buttons. She can
  type it or tap the mic, and her voice is turned into text on the phone.
- **She asks a question and gets a short answer she can trust.** Instead of a wall of search
  results, she reads two or three plain sentences built only from the trusted medical sources
  bundled in femio, with each source linked. Red-flag questions get the safety message first,
  always, AI or not.
- **Before a doctor visit**, the questions that matter most for her situation rise to the top of
  her visit sheet, so the short appointment goes to what counts.
- **Her tips follow where she is** (trying to conceive, pregnant, after birth, perimenopause, how
  regular her cycles are, what she logs), so the first tip she sees fits her, not everyone.
- **She photographs a lab report or prescription** (or picks a PDF), and Gemini Nano reads it on
  the phone into results and medicines she checks line by line, with the report's own date. The
  page never leaves the phone; on a phone without Nano the document is simply saved.
- **After a visit she says what the doctor told her**, and it becomes a draft of new medicines,
  results and the next appointment for her to confirm.
- **She asks in Arabic, French or Spanish**, and an on-device translator carries the question to
  English for Gemini Nano and the cited answer back, still on the phone.
- **Her voice becomes text with Gemini Nano** on phones that have it, and with Android's own
  on-device recognizer on the rest. No audio is ever sent.
- **On a phone without built-in AI**, she can choose Cloud boost: her question, with anything
  personal taken out and approved by her, goes to Google's AI, which writes the same kind of
  short, sourced answer. Without Cloud boost she reads the sources word for word, and femio says
  why the AI did not run.

What the AI never does: diagnose, predict her dates, see her whole record, or change her record
without her tick.

## How femio uses Firebase AI Logic: hybrid inference with privacy built into the code
1. **Her record stays on the phone.** Logging from her words, answers to questions about her, and the order of her tips and visit questions run with `ONLY_ON_DEVICE` on Gemini Nano. Where the phone offers it, femio asks for the newest on-device model first (`OnDeviceModelOption.PREVIEW`, Gemini Nano 4) and falls back to the stable Nano model if the phone does not have it. If Nano isn't available at all, the feature falls back to deterministic rules on the phone, never silently to the cloud; a private reply that did not run on the device is discarded.
2. **Opt-in Cloud boost, pseudonymised only.** Only on a phone without Nano, and only if she agrees, the hybrid call (`PREFER_ON_DEVICE`, cloud Gemini model) may receive her `PseudonymisedProfile`: four coarse bands (life stage, cycle regularity, kinds of symptom, logging streak). No dates, no free text, intimate terms excluded, and femio attaches no account or identifier; like any connection, Google still sees the phone's internet address and an App Check token. The consent screen shows her own values, names Google as processor, where and how long, and asks per purpose (one unticked box for general questions, one for tips), then "Confirm my choice" and a confirmation dialog; every choice is kept on the phone as a dated, versioned receipt she can read under "My AI choices". The cloud is offered every tip for her life stage, never the subset that fits her. She can step down or switch the AI off at any time with no boxes to tick, and that is recorded too.
3. **General questions are cleaned first, and she approves the exact text.** A question written about herself ("I", "my", "we" and their Arabic, French and Spanish forms) stays on the phone. Any other question becomes `CloudSafeText`: numbers, e-mail addresses and links are removed, and she sees and can edit the exact text in a box before anything is sent.
4. **Grounded, never from memory.** Every answer retrieves passages from a versioned registry of trusted sources bundled on the phone. The model may only summarise them and must cite them by number; an answer that cites nothing is discarded and the passages are shown word for word. No Google Search grounding, no tools. Tips and visit questions are reviewed sentences with sources; the model only puts them in order.
5. **Rules outrank the model.** Red flags and birth-control questions are handled by fixed, reviewed rules that run first and always win, and run again before a cloud send.
6. **App Check on every call:** debug provider in development, Play Integrity in release. femio uses no other Firebase product: Analytics and Remote Config would add a per-install identifier, and Auth an account, which the privacy promise rules out.

The privacy boundary is enforced by the type system and checked in CI: the cloud-capable call that carries anything of hers accepts one type, `CloudPrompt`, which can be built only from a `CloudSafeText` question or the `PseudonymisedProfile`. The only other cloud call, "Check Cloud boost", sends one fixed sentence ("Reply with the single word OK.") and nothing about her, so she can see whether Cloud boost works and why not. A privacy tripwire in CI fails if either changes, if search grounding is wired in, if Firebase appears outside the Kotlin assistant package, or if the app's Dart code gains network code. One gateway is the only caller of the model; it waits at most 20 seconds and returns the rules answer on any failure.

## How I built it
- Flutter app; Firebase AI Logic calls in a Kotlin layer behind one method channel and one gateway.
- One domain layer holds every medical threshold and prediction rule, bound by golden fixtures shared with the website.
- Companion website (Next.js, static) with cited articles and interactive calendar calculators.
- Over 800 unit and widget tests (812 pass in the public repo; its screenshot tests are skipped there), plus guards for wording, translations, medical claims and crisis content before every commit.

## Challenges
- **Languages.** On-device Gemini Nano is validated for English and Korean; other languages go through a phrase lexicon first and the model is used for classification and extraction.
- **Trust.** Limiting the model to retrieved, cited passages, and letting it say "not covered", mattered more than any prompt.
- **Provable privacy.** Typed boundaries, opt-in consent with a receipt, an on-phone ledger and a CI tripwire make it checkable.

## What I learned
Hybrid AI is at its best when the device/cloud split follows the data's sensitivity. In health, the model should choose and explain, never invent.

## What's next
Google Play release, iOS with Apple Foundation Models through Firebase AI Logic, more life stages, and a clinician review loop for the source registry.

## Built with
Firebase AI Logic, Gemini Nano, Gemini API, Firebase App Check, Play Integrity, Flutter, Dart, Kotlin, Android, Next.js, TypeScript, Tailwind CSS, next-intl, Vercel

## Other fields
- Try it out: https://femioapp.com · https://femioapp.com/en/demo (scripted demos of the app's screens; no AI runs on the website) · https://github.com/KhaledHassanein/femio-app · APK: https://github.com/KhaledHassanein/femio-app/releases/tag/v1.0.0-hackathon (live after `RELEASE_STEPS.md` B)
- Video: <YouTube, public, ≤3 min, English>
- Submitter: Individual · Egypt · KM Digital Labs · start date 07-21-26 · Existing · Platform: Android

## What existed vs what I built
Before Nov 11, 2026: femio's app had never been released and had no users. What existed was a Flutter tracker (records kept on the phone, backup file, PIN lock), shared medical rules with test fixtures, four-language scaffolding, and a signed release candidate (0.5.0) with a draft store listing that was never published. The companion website with articles and calendar calculators has been public at femioapp.com since October 2026. The app had no AI features and no network code of its own; an ad SDK (AdMob) added on 29 October 2026 was removed on 24 November 2026, during the period, when I decided the app ships no ads.

Built during the submission period (the public repo's HISTORY.md lists the commits with dates): the AI layer across the whole app. That covers on-device logging from her own words, over several days in one note; Ask femio grounded in a trusted-source registry with citations; personal tips and visit questions with sources, and the visit companion; the opt-in Cloud boost with the pseudonymised profile and recorded consent; redaction; the Kotlin Firebase AI Logic bridge with hybrid inference and App Check; one gateway with typed prompts; "What the AI can see", the "What the AI did" ledger and the AI-off switch; the updated privacy tripwire; and the public Apache-2.0 repository. Also new in the period: removing in-app ads, her health record with documents and medicines, the after-birth and perimenopause views, and the calendar's widening ranges.

## Main technology requirement
femio's Android app imports and calls Firebase AI Logic at runtime (Kotlin layer, `assistant/FemioAssistant.kt`) using hybrid inference with Gemini Nano. Requests involving her record run `ONLY_ON_DEVICE`. With her opt-in, on a phone without Nano, a pseudonymised four-band profile, or a general question she approved after redaction on the phone, may use `PREFER_ON_DEVICE` with a cloud Gemini model. All answers are grounded in a bundled registry of trusted medical sources and shown with citations. Firebase App Check protects every call (debug provider in development, Play Integrity in release).

## Testing instructions
No account or login needed. Android 8.0 or later, 64-bit.
1. **Install.** On the phone, open https://github.com/KhaledHassanein/femio-app/releases/tag/v1.0.0-hackathon and download `femio-hackathon.apk`. Allow your browser to install unknown apps when asked, open the file, and if Play Protect warns, tap More details, then Install anyway. Finish the short setup.
2. **Say it.** On Today, tap the box "Tell femio anything, like “cramps since this morning”" (or **+** → **Log with femio**). Type *yesterday light spotting, today cramps and I could sleep for a week*, tap **Turn into log entries**, check the two days of chips, untick anything wrong, and tap **Save**.
3. **Ask femio.** On Today, tap **Ask femio**, type *When should a couple see a doctor about getting pregnant?* and tap **Ask**. Check the numbered sources (publisher, link, date). On a Gemini Nano phone the answer says "Summarised on your phone by Gemini Nano"; otherwise it says "Word for word from trusted sources".
4. **Safety.** In Ask femio type *heavy bleeding and dizzy*: ACOG's emergency guidance and Help now appear before any AI runs.
5. **See what the AI did.** Settings → Assistant → "What the AI can see" (each feature and what it receives) and "What the AI did" (every model call).
6. **AI off.** Settings → Assistant → **AI and Cloud boost** → **No AI** → **Next** → **Next** → **Confirm my choice** → **Confirm** (nothing to tick: withdrawing is one step). Ask femio (step 3) and Log → **Say it in your words** still work, on femio's rules (with the assistant off, the "+" sheet hides its AI shortcuts).
7. **Cloud boost.** Settings → Assistant → **AI and Cloud boost** → **AI on this phone, plus Cloud boost** → **Next** (your own four values and what may be sent) → **Next** → tick the statements and at least one purpose → **Confirm my choice** → **Confirm**. **Check Cloud boost** then says whether Google's cloud AI answered or names the reason, and **My AI choices** lists your dated receipt. **App Check enforcement is on.** The release APK attests with Play Integrity, set up for an app installed outside Google Play, so Cloud boost needs a real phone with Google Play services (not rooted, not an emulator). You see the exact question to approve before anything is sent; if the check fails, femio says no summary was available and shows the sources word for word. The video shows a real Cloud boost run (1:30).
**On a phone without Gemini Nano (most phones today), steps 1 to 6 all work:** Say it uses femio's word rules, Ask femio shows the trusted passages word for word, and nothing leaves the phone unless you agree to Cloud boost.
The repo contains no keys or credentials; Firebase config lives in a git-ignored file (see README).

## License
Apache-2.0 at `https://github.com/KhaledHassanein/femio-app/blob/main/LICENSE`, visible in the repo's About section.
