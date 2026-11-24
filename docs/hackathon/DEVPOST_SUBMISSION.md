# Devpost submission: #BuildHybridAI 2026 (final answers, 2026-11-24)

Agent-facing record of what Femio's Devpost entry promises. **The build must match this text exactly.**
Anything not working by the deadline (2026-11-30, 2:00 PM PT) must be cut from the submission text, never faked.
**Aligned with the build on 2026-11-24 (commits ac3d2e0..d39e1ae, ADR-079).** Cut: medication logging, notification
wording, the rotating install id, "every path", "two typed values", WHO/NHS/ACOG as answer sources (they are
further-reading links), Settings → AI (it is Settings → Assistant).
Owner rulings in force: no "Arabic-first" framing, no Ramadan content; AI grounded in trusted external sources (not
only Femio's own guides); product is a whole-life AI-assisted app; opt-in pseudonymised personalisation.
Thumbnail: `docs/hackathon/thumbnail.png` (source `thumbnail.html`, rendered with headless Chrome at 1500x1000).

## Project name
Femio: AI Assisted Female Health & Wellness App

## Elevator pitch (192 chars)
Private AI women's health app: log symptoms in your words, get answers cited from trusted sources like CDC and MedlinePlus, personal tips, cycle insights and visit prep. Hybrid Gemini Nano AI.

## About the project
## The problem
A woman's health questions don't wait for clinic hours. At midnight she gets ads, forum guesses, or confident AI answers with no source. The apps that track her health usually ask her to upload the most private data she owns. Infertility alone affects about 1 in 6 people worldwide (WHO, 2023), and PCOS affects an estimated 8–13% of women of reproductive age (WHO fact sheet). Yet good, private, sourced help is still hard to find.

I'm a physician and clinical claims auditor. I built Femio as the assistant I wanted my own patients to have: useful, sourced and private at the same time.

## What Femio does
One app for her whole health life. It adapts its emphasis to her life stage without hiding anything: periods and cycle health, trying to conceive, pregnancy, postpartum, PCOS and endometriosis, and perimenopause.

- **Say it in your words.** She types how she feels ("bad cramps and a headache since this morning"). On-device Gemini Nano and femio's phrase rules turn it into structured entries: symptoms, flow, mood, sleep and ovulation tests. No forms.
- **Ask femio.** Health questions answered only from a library of trusted sources carried on the phone: passages from CDC, MedlinePlus, the US Office on Women's Health and NIH, with further reading from WHO, NHS, ACOG, RCOG and NICE. It works offline. Every answer numbers its sources and shows publisher, link and date. If the sources don't cover it, Femio says so instead of guessing.
- **Cycle and pregnancy views.** Predictions shown as ranges with confidence, never a single certain date or a verdict.
- **Personal tips.** Reviewed tips, each with its source, chosen on her phone from her life stage and what she logs; Gemini Nano puts them in order. Reminders stay neutral.
- **Visit prep.** A one-page summary of her recent months and a personalised question list for her next appointment, ready to show her doctor.
- **Safety before AI.** Red-flag wording (heavy bleeding with dizziness, reduced fetal movement, warning signs in the year after birth, thoughts of self-harm) opens emergency guidance and local help numbers before any model runs. Femio educates and tracks; it never diagnoses and never replaces a clinician.
- **Private by design.** No account, no ads profile built from her data, no analytics on her health. Backup is a file she saves herself. Available in English, Arabic, French and Spanish.

## How Femio uses Firebase AI Logic: hybrid inference with privacy built into the code
1. **Her raw record stays on the phone.** Logging from her words, answers to questions about her, and the order of her tips and visit questions run ONLY_ON_DEVICE on Gemini Nano. If Nano isn't available, the feature falls back to deterministic rules on the phone, never silently to the cloud.
2. **Opt-in cloud boost, pseudonymised only.** If she switches it on, the phone builds a `PseudonymisedProfile`: coarse, derived features only (cycle-regularity band, life stage, symptom categories, logging streak). No dates, free text, names, contacts or identifiers of any kind; no account. The consent screen shows her own values before she agrees. The cloud is offered every tip for her life stage, never the subset that fits her. She can switch it off at any time.
3. **General questions are redacted first.** A question with no personal details is cleaned on the phone into `CloudSafeText` (numbers, dates, names, contacts removed), and she sees and approves the exact text before it may use the cloud model.
4. **Grounded, never from memory.** Every answer retrieves passages from a versioned registry of trusted sources bundled on the phone. The model may only summarise them and must cite them by number; an answer that cites nothing is discarded and the passages are shown word for word. Tips and visit questions are reviewed sentences with sources; the model only puts them in order.
5. **Rules outrank the model.** Red flags and birth-control questions are handled by fixed, reviewed rules that run first and always win.
6. **App Check on every call:** debug provider in development, Play Integrity in release.

The privacy boundary is enforced by the compiler and the build: the cloud-capable call accepts one type, `CloudPrompt`, which can be built only from a `CloudSafeText` question or the `PseudonymisedProfile`; a build-time tripwire fails if that changes, if search grounding is wired in, or if network code appears outside the one allowed layer.

## How I built it
- Flutter app; Firebase AI Logic calls in a Kotlin layer behind one method channel.
- One domain layer holds every medical threshold and prediction rule, bound by golden fixtures shared with the website.
- Companion website (Next.js, static) with cited articles and interactive calendar calculators.
- Hundreds of unit tests plus guards for wording, translations, medical claims and crisis content before every commit.

## Challenges
- **Languages.** On-device Gemini Nano is validated mainly for English; other languages go through a phrase lexicon first and the model is used for classification and extraction.
- **Trust.** Limiting the model to retrieved, cited passages, and letting it say "I don't know", mattered more than any prompt.
- **Provable privacy.** Typed boundaries, opt-in consent and a failing build make it checkable.

## What I learned
Hybrid AI is at its best when the device/cloud split follows the data's sensitivity. In health, the model should choose and explain, never invent.

## What's next
Google Play release, iOS with Apple Foundation Models through Firebase AI Logic, more life stages, and a clinician review loop for the source registry.

## Built with
Firebase AI Logic, Gemini Nano, Gemini API, Firebase App Check, Play Integrity, Flutter, Dart, Kotlin, Android, Next.js, TypeScript, Tailwind CSS, next-intl, Vercel

## Other fields
- Try it out: https://femioapp.com · <public GitHub repo> · <APK link>
- Video: <YouTube, ≤3 min, English>
- Submitter: Individual · Egypt · KM Digital Labs · start date 07-21-26 · Existing · Platform: Android

## What existed vs what I built
Before Nov 11, 2026: Femio was an unfinished prototype in development. The app had never been released and had no users. What existed was an early Flutter tracker (records kept on the phone, backup file, PIN lock), shared medical rules with test fixtures, four-language scaffolding, a draft store listing that was never published, and a companion website with articles and calendar calculators. The prototype had no AI features and no network code.

Built during the submission period: the AI layer across the whole app. That covers on-device logging from her own words; Ask femio grounded in a trusted-source registry with citations; personal tips and visit questions with sources; visit prep; the opt-in cloud boost with the pseudonymised profile and consent flow; redaction; the Kotlin Firebase AI Logic bridge with hybrid inference and App Check; the updated privacy tripwire; and the public Apache-2.0 repository.

## Main technology requirement
Femio's Android app imports and calls Firebase AI Logic at runtime (Kotlin layer, assistant/FemioAssistant.kt) using hybrid inference with Gemini Nano. Requests involving her record run ONLY_ON_DEVICE. With her opt-in, a pseudonymised derived profile, and general questions redacted on the phone, may use PREFER_ON_DEVICE with a cloud Gemini model. All answers are grounded in a registry of trusted medical sources and shown with citations. Firebase App Check protects every call (debug provider in development, Play Integrity in release).

## Testing instructions
No account or login needed.
1. Install the APK on an Android phone that supports Gemini Nano (for example, a recent Pixel).
2. Log: tap "Say it in your words", type "bad cramps and a headache since this morning", check the structured entries.
3. Ask femio: ask "How long should we try to conceive before seeing a doctor?" and check the cited sources.
4. Safety: in Ask femio type "heavy bleeding and dizzy"; ACOG's emergency guidance and Help now open before any AI runs.
5. Settings → Assistant → Cloud boost: off by default; switching it on opens the consent screen showing exactly which pseudonymised features it would send.
On a phone without Nano, Ask femio shows the trusted passages word for word and every feature still works on rules; with Cloud boost on, a general question can be summarised in the cloud after she approves it. The cloud call is protected by Firebase App Check (Play Integrity), so on an APK installed outside Google Play it may be refused; Ask femio then shows the passages word for word, as designed.
The repo contains no keys or credentials; Firebase config lives in a git-ignored file (see README).

## License
Apache-2.0 at `<public-repo>/blob/main/LICENSE`, visible in the repo's About section.
