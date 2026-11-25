# #BuildHybridAI submission: femio (SUPERSEDED)

> **Superseded 2026-11-24 by `DEVPOST_SUBMISSION.md`** (ADR-079: registry answers replaced Google Search
> grounding, Cloud boost added). Do not paste from this file; it is kept for the record only.

Agent doc: the owner reads these through the hackathon pack page; a session keeps them in step
with the code. Every claim below is checked against the repository at the commit named in the
PROGRESS line R7.5. Nothing here is a medical claim.

## Project name
femio: AI-assisted women's health and wellness

## Tagline (under 200 characters)
A private period, fertility, pregnancy and menopause companion: Gemini Nano reads her own words
on her phone; the cloud answers only general questions, from trusted health sources.

## What it does
femio is a women's health and wellness app in English, Arabic, French and Spanish. Her record
(cycles, symptoms, moods, ovulation tests, temperatures, pregnancy logs) lives only on her phone:
no account, no server.

The hybrid assistant adds three things:
- **Say it in your words.** She types or dictates one sentence ("bad cramps, light bleeding, so
  tired", or the same in Egyptian Arabic) and it becomes log entries. femio's phrase rules read it
  on the phone, and Gemini Nano (`ONLY_ON_DEVICE`) adds what the rules missed. She confirms the
  chips before anything is saved; the sentence itself is never stored or sent.
- **Visit summary.** One page for her doctor, counted from her own log (cycle range, the symptoms
  she logged most, heavy-flow days, ovulation tests), with questions picked from a reviewed bank.
  Gemini Nano orders the questions for her, on the phone; it can never add one.
- **Ask femio.** A health question answered from trusted sources. A personal question ("I'm 34 and
  my cramps are awful") is first rewritten on the phone by Gemini Nano into a general one ("What
  helps with period cramps?"). She sees and can edit the exact text before it leaves. Only then is
  it sent to the cloud model with Grounding with Google Search, and the answer is shown only when at
  least one source is on femio's trusted list (WHO, NHS, CDC, NIH, ACOG, RCOG, NICE, ASRM, ESHRE,
  and the Saudi and Egyptian health ministries). Every source and Google's search suggestions are
  shown with the answer.

## How we built it
- Flutter app; Firebase AI Logic (`firebase-ai` 18.2.0, `firebase-ai-ondevice` 16.0.0-beta08)
  called from Kotlin behind one method channel, so the Dart code holds no network client.
- **Private by type.** The cloud call accepts only a `CloudSafeText`, a Dart type whose constructor
  is private to the redaction step (first-person wording refused, numbers, links and contacts
  stripped). A privacy tripwire in CI fails the build if Firebase appears outside the Kotlin
  assistant package or if the cloud call stops requiring `CloudSafeText`.
- **Rules before models.** Safety rules in four languages run first: crisis and urgent signs open
  the help page with local crisis lines, pregnancy warning signs open the warning-signs screen,
  and birth-control questions get a fixed answer. None of these reach a model.
- **Works without AI.** With no Gemini Nano on the phone, the rules still turn sentences into log
  entries and the visit summary still works; with no cloud config, Ask femio shows femio's guides.
- App Check: the debug provider in debug builds, Play Integrity in release.
- 46 new tests (31 domain, 15 widget) plus screenshots at 390×844 in light, dark and Arabic.

## Challenges
- Gemini Nano is validated for English and Korean; our users write Arabic dialects. The model gets
  short English instructions and returns keys from a fixed vocabulary, and a four-language phrase
  lexicon is the floor it builds on.
- Health data and the cloud: we drew the line in code, not in a policy.

## What's next
Postpartum and perimenopause depth, iOS, and a reviewed Arabic evaluation set for the on-device
extraction.

## What was built in the hackathon period (since 11 November 2026)
The whole hybrid assistant: the on-device and cloud paths, the Kotlin bridge, the redaction type,
the trusted-source allowlist, the safety rules, the three screens in four languages, and their
tests. Before the period femio was an unreleased offline tracker with no AI.

## Built with
flutter, dart, kotlin, firebase-ai-logic, gemini-nano, gemini, google-search-grounding,
firebase-app-check, android
