# #BuildHybridAI submission: femio (SUPERSEDED, pointer only)

> **Do not paste from this file.** The text to submit is `DEVPOST_SUBMISSION.md` (truth pass
> 2026-11-27). The demo video is `VIDEO_SCRIPT.md`; publishing the repo and the APK is
> `RELEASE_STEPS.md`.

This file held the first draft (2026-11-24, before ADR-079). Its body was removed on 2026-11-27
because it described a design the app no longer has, and a judge comparing it with the code would
find contradictions. It is in git history (`git log -- docs/hackathon/DEVPOST.md`). What it got
wrong, so no later draft brings it back:

| The old draft said | The code does (ADR-079, ADR-080, ADR-081) |
|---|---|
| Ask femio sends a rewritten question to the cloud with Google Search grounding (`ONLY_IN_CLOUD`), filtered by a trusted-host list | Answers come only from the bundled trusted-source registry; Gemini Nano summarises on the phone (`ONLY_ON_DEVICE`); Cloud boost is opt-in, off by default, and uses `PREFER_ON_DEVICE` with no tools; the tripwire forbids search grounding |
| WHO, NHS, CDC, ACOG and others are answer sources | Passages are copied only from US federal public-domain publishers (CDC, MedlinePlus, Office on Women's Health, NIH institutes); WHO, NHS, ACOG, RCOG and NICE are further-reading links |
| The cloud call accepts a `CloudSafeText` | It accepts only a `CloudPrompt`, built from a `CloudSafeText` question or a `PseudonymisedProfile` |
| Redaction strips names and dates | It removes numbers, e-mail addresses and links; she sees and edits the exact text before it is sent |
| Before the period, femio was an offline tracker with no network code | The app had no AI and no network code of its own, but carried an ad SDK from 29 Oct to 24 Nov 2026 (removed by ADR-080) |
| "46 new tests" | 812 tests pass in the public export (2026-11-27); the count grows with every change |
