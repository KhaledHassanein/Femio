# Privacy review and DPIA: femio app and website (2026-11-24, ADR-080)

**This is research, not legal advice.** A qualified lawyer should review it before the Play release
(owner action 36). Sources were read on 2026-11-24 unless marked. "Not verified" means the primary
source could not be opened.

## 1 · What leaves the phone or reaches us (code audit, 2026-11-24, after ADR-080)

| Flow | When | What | Recipient | Evidence |
|---|---|---|---|---|
| Cloud boost: question | She ticked "questions", phone has no Nano, she approves the text | Redacted question (`CloudSafeText`), public passages, language | Google (Firebase AI Logic, Gemini Developer API, paid tier) as processor | `lib/domain/assistant/cloud_prompt.dart`, `redaction.dart`, `ask_screen.dart` |
| Cloud boost: tips | She ticked "tips", phone has no Nano; runs in the background | Four bands (`PseudonymisedProfile`) + every tip for her stage | Same | `pseudonymised_profile.dart`, `tips_card.dart` |
| Request metadata | With each Cloud boost call | IP address, App Check token (Play Integrity), `x-firebase-client` heartbeat header; no Firebase installation ID (no `firebase-installations` in the build) | Google | merged manifest, dex inspection by the audit agent |
| Gemini Nano | She taps Download | Model download and updates through Android AICore | Google (system service) | `FemioAssistant.kt` |
| ML Kit / DataTransport telemetry | Possibly, from the on-device AI library | Technical usage data; contents **not verified** | Google | merged manifest (`MlKitInitProvider`, `TransportBackendDiscovery`) |
| Play Billing | Only if she buys Plus (probe only today) | Purchase handled by Play | Google Play | `features/plus/` |
| Website host logs | Every visit | IP, time, path, browser, referrer | Vercel (processor) | `apps/web/vercel.json` |
| Website visit counts | Every visit | Path without query, referrer, country, device/OS/browser; daily hash discarded after 24 h; no cookie | Vercel Web Analytics | `@vercel/analytics`, `beforeSend` in the locale layout |
| Website ads | Content pages; ad box only after `ad_storage` granted | AdSense script loads before consent (IP, user agent); ads after consent | Google (independent controller for ads) | `apps/web/src/lib/ads/` |

Removed by ADR-080: AdMob and the advertising ID in the app; GTM, GA4 and the Meta pixel on the website.

## 2 · Requirements and how femio meets them

| Rule | Source | Status |
|---|---|---|
| Health data (bands, pregnancy, TTC, symptoms) needs explicit consent for a specified purpose | GDPR Art. 9(2)(a); EDPB Guidelines 05/2020 §§93–98 (edpb.europa.eu) | Met: one unticked box per purpose, "I agree" button, explicit statement on screen |
| Withdrawal as easy as consent | GDPR Art. 7(3); EDPB §113 | Met: one tap on the screen or the Settings switch; withdrawal recorded |
| Controller must be able to show consent | GDPR Art. 7(1); EDPB §§104–108 | Partly: dated, versioned receipt on her phone (`CloudConsent`); keep an archive of every consent-text version with release dates (`cloudConsentVersion` history below). No authority confirms on-device proof is enough |
| Notice contents (identity, purposes, bases, recipients, transfers, retention, rights, complaint) | GDPR Art. 13; Saudi IR Art. 4(1) | Met in the rewritten privacy policy (EN/AR/FR/ES) |
| EU/UK representative unless processing is occasional | GDPR / UK GDPR Art. 27; EDPB 3/2018 p.25 | **Owner decision** (action 34): Cloud boost is a standing feature, so the exemption is unlikely |
| Processor terms with Google | GDPR Art. 28; Gemini API Additional Terms (aistudio.google.com/docs/terms, eff. 23 Mar 2026); Google processor terms v10 (business.safety.google/processorterms) | Paid tier: no product improvement; covered by the processor addendum (whether Gemini API is in the product list: not verified) |
| Retention at Google | aistudio.google.com/docs/usage-policies (abuse monitoring 55 days); /docs/logs-policy (request logging on by default for projects created after 26 Oct 2026) | Owner action 29: logging off; the notice says up to 55 days |
| Transfers to the US | GDPR Arts. 44–46; EDPB 05/2021 | Google: SCCs + DPF via the processor terms (DPF listing not opened: not verified) |
| DPIA | GDPR Art. 35; WP248 criteria 4 (sensitive) + 8 (new technology); Saudi IR Art. 25(1)(a) | This document §3 |
| Device storage for ads needs consent | ePrivacy Art. 5(3); AdMob help 7676680 | Moot in the app (no ads). Website: Consent Mode default denied + Google's certified message |
| Pixel on health pages = special-category processing | CJEU C-252/21, 4 July 2023 | Resolved: no Meta pixel |
| Unauthorised disclosure of health data = breach | FTC HBNR 16 CFR §318.2; Flo, GoodRx, Premom, BetterHelp | Resolved for ads/analytics; notice matches the code; breach plan below |
| Separate consumer health data policy, homepage link; separate consent to share; rights within 45 days with appeal | RCW 19.373.020, .030, .040 (app.leg.wa.gov, read 2026-11-24) | Met: `/consumer-health-data` page in the footer of every page; Cloud boost consent is separate and per purpose |
| Saudi: explicit, documented, per-purpose consent; DPIA; 72 h breach; transfer conditions | PDPL Arts. 2, 5, 6(4), 29; IR Arts. 11, 24, 25; Transfer Regulation Arts. 2–7 (sdaia.gov.sa) | Consent met; transfer risk assessment = §3 below; adequacy list not verified |
| Egypt: written, explicit consent; licence for sensitive data; transfer permit | Law 151/2020 Arts. 2, 12, 14–15 (Andersen translation, secondary); Exec. Regs. Decision 816/2025 (CMS, secondary) | **Owner action 35**: licence question for a lawyer; Arabic consent text exists in the app |
| Play: prominent disclosure + affirmative action for sensitive data; Data safety truthful | Play User Data policy; Data safety help 10787469 | Met by the consent screen; `docs/store/data-safety-and-declarations.md` rewritten |

## 3 · DPIA for Cloud boost (GDPR Art. 35, Saudi IR Art. 25, Transfer Regulation Art. 7)

- **Processing:** on phones without Gemini Nano, send (a) a redacted general question she approves each time, or (b) four coarse bands, to Google's Gemini model to summarise public sources or order reviewed tips.
- **Necessity and proportionality:** the bands are the minimum that orders tips (no dates, no free text, intimate terms excluded, symptom kinds only when logged on 2+ days in 30); the question is redacted, length-capped (300 characters) and shown to her before sending; the cloud never sees which tips fit her (it receives every tip for her stage). Without consent everything works on rules on the phone.
- **Risks:** (1) re-identification through IP + timing at Google: low, Google is a contracted processor, no account or identifier from femio; (2) first-person health detail slipping past redaction: mitigated by the first-person word lists in four languages and her approval of the exact text; (3) retention or human review at Google: up to 55 days for abuse monitoring, disclosed; request logging must stay off; (4) foreign transfer: SCCs/DPF; (5) misuse of the consent screen as a dark pattern: nothing pre-ticked, "Not now" equal in reach, per-purpose choice.
- **Residual risk:** low to medium; acceptable with the owner actions below. Review again when the consent text, the bands or the model change (bump `cloudConsentVersion`).

## 4 · Consent-text versions (keep this archive)

| `cloudConsentVersion` | Released | What changed |
|---|---|---|
| 1 | not yet released (built 2026-11-24, ADR-080) | First recorded consent: two purposes, Google as processor, US location, 55-day retention, what Google also sees |

## 5 · Breach plan additions

Exposure of anything femio is responsible for: Egypt PDPC 72 h (Law 151 Art. 7), SDAIA 72 h (IR Art. 24(1)), EU/UK authority 72 h if risk (Art. 33), FTC and individuals within 60 days if the HBNR applies (§318.4). Keep the incident log described in `docs/33_REBUILD_V3/03_LEGAL_PACK.md` §1.

## 6 · Not verified

ICO guidance pages; Washington AG FAQ; Nevada NRS 603A; the Egyptian Official Gazette text; Google's DPF listing page; whether the Gemini API is in Google's processor-terms product list; Saudi adequacy list; what ML Kit / DataTransport sends (verify with a traffic capture on a real phone, owner action 33).
