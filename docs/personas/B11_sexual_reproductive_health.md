# Persona B11 — Reproductive-age woman seeking sexual & reproductive health / STI awareness

> Femio product + UX research spec. Wellness / education / tracking scope only. Femio never diagnoses, treats, prevents disease, or acts as contraception. Screeners are framed as "screening — discuss with a clinician."
> Research date: 2026-07-18 · Persona band: B (reproductive-age, non-TTC) · Sensitivity: HIGH-stigma topic — discreet-mode aware, Arabic-first/MENA-conscious, age-appropriate
> Inherits: `09_MASTER_ADAPTATION_MODEL.md` (seven invariants, state object, constant core, universal events §6, Z1 fallback, blending rules). This spec adds only B11-specifics.

---

## A. Persona snapshot

**Who she is.** "Nour," 26. Sexually active (or newly so, or considering it), reproductive-age. She has questions about STIs — what they are, how they spread, how to protect herself, what the symptoms look like, when and how to get tested, and what HPV means for her cervical health. She may have had a scare (an unusual symptom, a partner's disclosure, or a new relationship) or simply wants to be informed and responsible. Arabic-first (also reads English), web on her phone. She would be mortified if anyone — a family member, a flatmate, a partner — saw this on her screen or in a notification.

**What she lives with.**
- **High stigma & discretion pressure** — in her cultural context (MENA/Arab-Muslim first, but true for many markets) sexual health is taboo, extramarital sex is socially unacceptable and more harshly judged for women, and an STI carries shame and fear of exposure. Confidentiality is not a nice-to-have; it is the whole reason she'll use an app instead of asking a person.
- **Knowledge gaps** — she was likely never taught this. Studies show most women in the region are unaware of their sexual health and know far less about STI protection than men do.
- **Symptom anxiety** — "is this discharge / itch / bump / sore normal, or is it something?" She wants to know when a symptom warrants seeing a clinician without being told she has a disease.
- **Testing confusion** — she doesn't know what tests exist, when she should test, whether she needs symptoms first, or how to access testing discreetly.
- **HPV / cervical uncertainty** — she's heard HPV causes cervical cancer and there's a vaccine and a "smear test," but doesn't know how they connect or what she should do.

**Core emotional drivers.** She wants to feel *informed, safe, and un-judged* — never lectured, never shamed, never assumed to be promiscuous or "in trouble." She wants facts in private. She needs to trust that the app will not out her (no revealing notifications, no synced data, a way to hide the screen fast).

**Jobs-to-be-done.**
1. Understand STIs — the common ones (chlamydia, gonorrhoea, HPV, herpes, syphilis, trichomoniasis), how they spread, that many have no symptoms.
2. Learn safer-sex basics and how protection works — factually, non-judgementally, without being told what to do with her body.
3. Decode a symptom — "should I get this checked?" — with clear, calm clinician-routing.
4. Understand testing — what exists, when it's recommended, that testing is the only way to know, how to ask for it discreetly.
5. Understand HPV and how it links to cervical screening — and be bridged gently to that (→ B18).
6. Do all of the above privately, with a discreet mode she trusts.

**Success = she gets accurate, calm, private answers she'd otherwise be too afraid or ashamed to seek — and knows exactly when and how to talk to a clinician.**

---

## B. Needs & questions (voice-of-user)

Mined from sexual-health communities, app reviews, qualitative MENA/Muslim-women studies, and Tier-1 patient FAQs (see Sources). Paraphrased to avoid quoting individuals and to respect the sensitivity of the topic.

**On stigma & privacy (the gate that decides whether she engages at all):**
- "I can't ask my doctor or my mother about this. I need to look it up where no one will know."
- "What if a notification pops up and someone sees it? I need this to be invisible."
- "I'm terrified of being judged — by the app, by a clinic, by anyone."
- "After the Flo/Facebook data scandal I don't trust any of these apps with something this sensitive."

**On understanding STIs:**
- "I don't even know the names of the common infections or how you actually catch them."
- "Can you have an STI and feel completely fine?" (Yes — most chlamydia has no symptoms.)
- "Is HPV the same as herpes? What's the difference between the ones that go away and the ones that don't?"

**On symptoms:**
- "I have [itch / unusual discharge / a bump / a sore] — is this an STI or is it nothing?"
- "How long after exposure would symptoms even show up?"
- "I'm too embarrassed to describe this to anyone. I just want to know if I need to see someone."

**On testing:**
- "When am I supposed to get tested? Do I need symptoms first?"
- "What tests are there and how do they even work — is it a swab, urine, blood?"
- "Where can I get tested without my family finding out?"
- "My partner told me he tested positive — what do I do now?"

**On safer sex (kept factual, non-prescriptive):**
- "How does protection actually reduce risk — and what doesn't it cover?"
- "Does anything protect against all of them?" (No single method; condoms reduce many but not all.)

**On HPV & cervical health (bridge to B18):**
- "I heard HPV causes cervical cancer — should I be worried? Is there a vaccine? Am I too old for it?"
- "What is a Pap/smear test and when should I have one?"

**Top recurring questions Femio must answer in-product (discreetly, non-diagnostically):**
1. What are the common STIs and how do they spread?
2. Can I have one without symptoms?
3. This symptom — should I get it checked, and how urgently?
4. When and how often is testing recommended, and how do tests work?
5. How does safer sex reduce risk (and what it doesn't cover)?
6. What is HPV, how does it link to cervical screening, and what should I do? (→ B18)
7. My partner disclosed an STI / I had a possible exposure — what are my next steps? (education + routing)

---

## C. Competitor teardown

Focused on the specific gap: **stigma-free sexual & reproductive health (SRH) education is the topic most apps avoid or lock behind paywalls/communities**, and almost none is built for a high-stigma, Arabic-first user who needs discretion.

| App | Model | STI / SRH education | Stigma-free & discreet | Symptom → clinician routing | Arabic / MENA fit | Privacy | Gap Femio exploits |
|---|---|---|---|---|---|---|---|
| **Flo** | Freemium, AI | Sexual-wellness articles + anonymous community threads (STIs, contraception); much locked behind Premium | Community can be supportive but also noisy/unmoderated; Western framing | Light; general "see a doctor" | Limited AR depth; not discretion-first | **FTC settlement (2021) for sharing cycle/pregnancy data with Facebook/Google** — trust damage on the exact sensitivity that matters here | Referenced, non-community education; discreet-mode; Arabic-first; privacy-by-design |
| **Clue** | Freemium, science-forward | Good neutral encyclopaedia incl. some STI/sexual-health content | Neutral clinical tone (good) | Light | EU/GDPR posture; limited AR | Better reputation | Deeper STI + testing + HPV→screening bridge; RTL; discreet mode |
| **Ovia** | Freemium, health-plan tie-ins | Fertility/pregnancy-oriented; thin SRH/STI education | Not discretion-first | Light | Poor MENA fit | Employer/health-plan data model = trust risk for a stigmatised topic | Non-employer, privacy-first, education-led |
| **Stardust** | Privacy-forward, local-first | Minimal STI education | Privacy strong; astrology framing dilutes clinical trust | Minimal | Limited AR | **Strong: local storage** | Clinical credibility + referenced STI/testing content + AR |
| **Planned Parenthood / Better2Know / Stigma Health** | Clinic/testing services + info sites | Excellent factual STI/testing content | Clinical, fairly stigma-aware | Strong (they route to testing) | US/UK/AU-centric; culturally Western; not private personal apps | Varies | Femio = private, personal, lifespan account with the *education layer* + discreet mode + AR/MENA sensitivity that feeds these services |
| **Generic search / social** | — | Where she actually goes today | Anonymous but unreliable, fear-amplifying, non-referenced | None | Arabic misinformation common | None | Femio replaces this with calm, referenced, private, clinician-routed answers |

**Cross-cutting failure:** general trackers treat sexual health as either a paywalled article set or an unmoderated community, and none is engineered for a user whose primary need is **discretion and non-judgement in a high-stigma culture**. Testing/clinic services have great content but aren't a private, personal, always-on companion. Femio's opening is a **stigma-free, referenced, discreet, Arabic-first SRH education + symptom-routing + HPV→screening-bridge layer** inside a lifespan account she already trusts for cycle tracking.

---

## D. Clinical grounding (cited)

All framed as **education and screening awareness**. Femio never diagnoses an STI, never treats, never claims to prevent disease, and never presents any method as contraception.

**Scale of the topic (why education matters, non-alarming).** STIs are extremely common and often symptomless. WHO estimates more than 1 million curable STIs are acquired every day; in 2020, ~374 million new infections with the four curable STIs — chlamydia (~129M), gonorrhoea (~82M), syphilis (~7.1M) and trichomoniasis (~156M). An estimated 520 million people aged 15–49 (~13%) have HSV-2 (the main cause of genital herpes), and ~300 million women have an HPV infection [WHO STI fact sheet].

**Common STIs (education framing).**
- **Chlamydia** — the most common bacterial STI; *usually no symptoms*, so testing is the only way to know. Female testing is typically a self-taken vaginal swab (or urine). Curable with clinician-prescribed antibiotics [NHS; MedlinePlus].
- **Gonorrhoea** — bacterial; may be symptomless; treated by a clinician [CDC; NHS].
- **HPV (human papillomavirus)** — the most common STI; most infections clear on their own, but persistent oncogenic types (esp. HPV-16/18) cause nearly all cervical cancers. Prevented/reduced by HPV vaccination and detected early by cervical screening — the **direct bridge to B18** [CDC Cervical Cancer / HPV].
- **Genital herpes (HSV)** — viral, lifelong but manageable; painful blisters/sores; symptoms usually appear 2–12 days after contact but can be delayed months/years or never appear; diagnosed by swab of a lesion [NHS].
- **Syphilis** — bacterial, staged, curable if treated; rising globally; serious in pregnancy [WHO; CDC].
- **Trichomoniasis** — common curable parasitic STI, often symptomless in the region-relevant screening literature [WHO; BASHH].
- **Key teaching throughout: many STIs cause no symptoms — feeling fine does not mean uninfected; testing is the only way to know** [MedlinePlus; CDC].

**Testing recommendations (awareness framing — Femio surfaces "here's what guidelines describe; discuss with a clinician," never a personal test verdict).**
- Annual chlamydia + gonorrhoea testing for all sexually active women under 25, and for older women with increased risk (new/multiple partners, or a partner with an STI) [CDC STI screening; USPSTF; MedlinePlus].
- Testing may be appropriate for asymptomatic women in higher-prevalence settings or with risk factors [BASHH 2023 summary guidance].
- Screening looks for infection *before* symptoms appear — the reason "no symptoms" is not a reason to skip testing [MedlinePlus].
- Pregnancy: screening for chlamydia/gonorrhoea and syphilis is part of standard antenatal care [CDC; WHO].

**Safer sex (factual, non-prescriptive, never contraception-as-device claim).** Correct, consistent condom use reduces the risk of many STIs (chlamydia, gonorrhoea, herpes, HPV/warts, syphilis) but does **not** eliminate all risk and does not cover skin-to-skin areas a condom doesn't reach [NHS; CDC]. Femio presents this as **risk-reduction education**, and — per invariant #4 — **never presents condoms or any method as Femio "providing contraception" or a reliable pregnancy-prevention guarantee**; contraception method choice routes to education (→ B13) and to a clinician.

**HPV → cervical screening (bridge to B18).** Because persistent HPV causes nearly all cervical cancer, HPV vaccination + regular cervical screening (Pap/HPV test) are the prevention pathway; women should still screen even if vaccinated [CDC]. Femio educates and **bridges to B18** for the screening journey; it does not perform or interpret screening.

**Partner situations (education + routing, not treatment).** If a partner discloses an STI or there's a possible exposure, guidance is to get evaluated/tested; clinicians may use expedited partner therapy for chlamydia/gonorrhoea where partners can't attend, and always weigh intimate-partner-violence safety before partner notification [ACOG Committee Opinion 737]. Femio explains these as **things a clinician may do**, routes to care, and surfaces IPV-safety and crisis resources — it never dispenses or doses medication.

**Femio scope guardrail restated:** everything above is **wellness education + screening awareness + clinician routing**. Femio does not diagnose an STI, does not treat, does not prevent disease, and is not contraception.

*Global-market rule:* Femio does not display country-specific STI prevalence, promise discreet access, or name a testing clinic unless that market module has been separately verified. Global copy says that STI testing access and cost vary and routes the user to a licensed local clinician or sexual-health service. IPV support uses the explicit country selector and abuse/domestic-violence topic route in [`docs/compliance/CRISIS_RESOURCES.md`](../compliance/CRISIS_RESOURCES.md), with the urgent fallback for immediate danger. ([WHO STI fact sheet, 21 May 2025](https://www.who.int/en/news-room/fact-sheets/detail/sexually-transmitted-infections-%28stis%29); reviewed Mohamed K., 23 July 2026.)

---

## E. Feature set (prioritized)

**P0 — must ship for this persona to trust and use Femio.**
1. **Discreet mode (first-class)** — neutral app name/icon option, generic/disguised notifications (no STI words on a lock screen), quick-hide / "boss key" gesture, optional passcode/biometric lock, no revealing home-screen widgets. Default cautious in high-stigma locale.
2. **Stigma-free STI education library** — the common STIs, how they spread, "many have no symptoms," referenced and calm; grade 6–8; Arabic-first + EN/FR/ES; RTL.
3. **Symptom-guidance / "should I get this checked?" flow** — non-diagnostic, calm, private; maps common concerns (discharge, itch, bump, sore, pain) to *"these can be reasons to see a clinician — here's how to talk about it,"* with red-flag urgency box. Never outputs "you have X."
4. **Testing-awareness module** — what tests exist (swab/urine/blood), what guidelines describe about who/when to test, that testing is the only way to know, how to ask discreetly. Screening-framed.
5. **HPV → cervical-screening bridge (→ B18)** — clear HPV explainer that hands off to the cervical/HPV-screening persona journey.
6. **Privacy-by-design, sensitivity-tier** — special-category handling, no ad/analytics-SDK sharing, local-first where feasible, full export/delete, granular consent; explicitly addresses post-Flo distrust.

**P1 — strong differentiators.**
7. Safer-sex risk-reduction education (factual, non-prescriptive, never contraception-device claim).
8. "Partner disclosed / possible exposure — what next" educational pathway with clinician + IPV-safety routing.
9. Culturally-sensitive, non-judgemental copy layer tuned per market (respectful across all markets; extra-discreet defaults in MENA).
10. Optional, private testing-reminder ("many guidelines suggest routine testing if you're sexually active — set a private, discreetly-labelled reminder?") — opt-in only, never assumes activity.

**P2 — depth / retention.**
11. Myth-vs-evidence module (e.g., "you can tell by looking," "only certain people get STIs," "no symptoms = no infection").
12. Contraception education hand-off (→ B13) when method questions arise (education only).
13. Anonymous, moderated Q&A / referenced FAQ (no public profile; safeguarding-gated for minors) — optional, later.

---

## F. Content modules (referenced, medically-reviewed, grade 6–8, 4 languages, discreet)

1. **STIs 101** — what they are, the common ones (chlamydia, gonorrhoea, HPV, herpes, syphilis, trichomoniasis), how they spread, and the key fact that **many cause no symptoms**.
2. **"Can I have one and feel fine?"** — asymptomatic infection explained; why testing (not how you feel) is the only way to know.
3. **Understanding symptoms — and when to get checked** — common concerns mapped to calm, non-diagnostic "reasons to see a clinician," with urgency red-flags. Explicit "this is not a diagnosis."
4. **Getting tested** — what tests exist and how they work; what guidelines describe about who/when; how to ask for testing discreetly; what results mean in general terms (no personal interpretation).
5. **Safer sex & risk reduction** — factual, non-judgemental; how protection reduces (not eliminates) risk; what it doesn't cover. Clear "not a contraception claim" framing; routes method questions to B13.
6. **HPV, warts & your cervix** — what HPV is, that most clears, why persistent types matter, vaccine + screening as the prevention path → **bridge to B18 (cervical/HPV screening)**.
7. **Herpes, calmly** — reducing fear and stigma; manageable, common; when to see a clinician.
8. **If a partner tells you / you think you were exposed** — steps, testing, clinician routing, and IPV-safety + confidentiality reassurance.
9. **Talking to a clinician without shame** — how to raise sexual-health questions discreetly; your right to confidentiality; what to expect.
10. **Myths vs. evidence** — stigma-busting, culturally-aware, non-judgemental.

Every module: referenced citations, medical-review byline + date, "this is education, not a diagnosis — discuss with your clinician" footer, discreet titling, Arabic-first/RTL QA.

---

## G. Tools, logs & alerts (compliant framing)

**Logs (all optional, private, discreetly labelled)**
- Optional symptom note (private, non-diagnostic) — she can record a concern to remember for a clinician visit; never interpreted as a diagnosis.
- Optional private testing log (dates she chose to test / results she enters herself) — entry-only, no interpretation, no "you're positive/negative" verdicts.
- Optional HPV-vaccination status / cervical-screening date note (feeds B18 bridge).

**Tools**
- **"Should I get this checked?" guide** — non-diagnostic symptom-to-routing helper; outputs "reasons to see a clinician" + urgency + how to ask, never a condition name.
- **Testing-awareness helper** — surfaces what guidelines describe (who/when/how tests work) as education; offers optional discreet reminder.
- **HPV → cervical-screening bridge** — one-tap hand-off to B18 journey.
- **Visit-prep generator** — private, exportable summary of concerns/questions to bring to a clinician (helps her raise a stigmatised topic she'd struggle to voice).
- **Screeners (framed as screening/awareness, not diagnosis):**
  - Sexual-health risk-awareness checklist → "This is awareness information, not a diagnosis. Consider discussing testing with a clinician." Never "you have/likely have an STI."
  - Mood/anxiety screen (symptom anxiety and stigma are heavy here) → screening-framed + crisis resources.

**Alerts (non-alarming, screening-framed, discreetly worded, dismissible, localized/RTL)**
- Optional, opt-in testing reminder (neutral wording; never mentions STIs on a lock screen).
- Red-flag urgency box for symptoms that guidelines say warrant prompt care (educational, "see a clinician," never triage/diagnosis).
- HPV/cervical-screening awareness nudge (bridges to B18), gentle and educational.
- **Never:** "you have an STI"; never a "you're safe / clean" claim; never a safe-day/fertile-window-as-protection claim; never any method presented as Femio-provided contraception or disease prevention.

---

## H. EMR / data fields (core vs persona-specific)

**Core (shared across Femio account — inherited from constant core §3)**
- Account: age/DOB, language (default AR), locale/RTL, units.
- Consent & privacy settings; data-sharing toggles (default off); **sensitivity-tier flag ON** for this persona.
- Life-stage / mode flag (here: reproductive-age, SRH/STI-awareness mode).
- Generic symptom log; mood/energy; content history; screener results (timestamped, non-diagnostic).

**Persona-specific (SRH / STI-awareness) — surfaced or hidden, never destroyed**
- SRH-mode flag + concern focus (multi-select: understanding STIs / a symptom / testing / safer sex / HPV-cervical / partner situation).
- Optional private symptom notes (non-diagnostic, free-text/tagged).
- Optional self-entered testing log (dates, self-recorded results) — **entry only, no interpretation**.
- Optional HPV-vaccination status + cervical-screening date (bridges to B18).
- Discreet-mode settings (disguised name/icon, notification masking, quick-hide, app lock).
- Contraception-education interest flag (routes to B13, education only).
- TTC intent flag = **false** by default; reachable toggle.

*All health fields optional, encrypted, user-deletable. Nothing here is required to use the app. This data class is treated at the highest sensitivity tier; every new sharing scope is re-confirmed (invariant #6).*

---

## I. Personalization rules (wizard → home config; hidden-but-reachable)

**Onboarding wizard branch (B11):**
- Q: life stage → "reproductive age / tracking my cycle / general" then a discreet sub-topic: "Want to learn about sexual & reproductive health?" → **SRH/STI-awareness mode ON**.
- Q: "What brings you here today?" (multi-select, non-judgemental: understanding STIs · a symptom I'm worried about · testing · safer sex · HPV/cervical health · a partner situation) ⇒ orders home modules.
- Q: locale/privacy → high-stigma locale (MENA default) ⇒ **discreet-mode defaults ON** (masked notifications, neutral labelling, app-lock prompt).
- Q: "Are you currently trying to conceive?" → default **No** ⇒ TTC intent false; suppress pregnancy/fertile-window framing.
- Never asks about relationship/marital status as a gate to knowledge; never assumes sexual activity — content is available whether she is active, considering, or just informing herself.

**Home configuration (default for B11):**
- Hero = discreet SRH education entry ("Learn about your sexual & reproductive health, privately") + her top concern surfaced.
- Cards prioritized by concern selection (symptom-guidance surfaced first if she flagged a symptom; HPV→B18 card if she flagged HPV/cervical).
- "Should I get this checked?" and testing-awareness tools pinned when relevant.
- Discreet-mode controls easy to reach; quick-hide always available.
- Cycle/other-lifestage widgets remain but do not push a TTC/pregnancy narrative.

**Hidden-but-reachable principle (invariant #1):** Femio never removes knowledge. All SRH content is reachable via search/library regardless of the market's stigma level — discretion changes *presentation and defaults* (masked notifications, neutral labels), never *access*. Contraception education (→ B13), cervical/HPV screening (→ B18), TTC, pregnancy, and menopause content all stay discoverable.

**Adaptive tuning:** if she repeatedly opens symptom-guidance, raise testing-awareness + visit-prep prominence (educational). If she flags HPV/cervical interest or enters a screening date, strengthen the B18 bridge. If mood/anxiety screens trend low (stigma-driven distress), surface mental-health module + resources.

**Age-appropriateness:** for minor tiers (A-track), SRH content is age-appropriate and safeguarding-aware — community/DMs/UGC gated per invariant #1; **knowledge itself is never gated**, but framing, depth, and testing/clinic routing adapt to age and local age-of-consent, and trusted-adult scope applies.

---

## J. Adaptation triggers (life-stage routing)

Inherits **all universal events** from §6 of the Master Adaptation Model (positive pregnancy test, loss, mood-screen-high/crisis, red-flag symptom, disengagement, toggle-off, age-of-consent). Below are **B11-specific** transitions only.

| Trigger | System response | Route |
|---|---|---|
| Flags **HPV / cervical-screening interest** (or enters vaccination/screening date) | Surface HPV explainer; strengthen and offer hand-off to cervical/HPV-screening journey; carry vaccination/screening notes | **Bridge to B18 (cervical / HPV screening)** — keep SRH mode, add screening layer |
| **Symptom concern logged / opens "should I get this checked?"** repeatedly or flags a red-flag symptom | Non-diagnostic routing: "reasons to see a clinician" + urgency box + how-to-ask + visit-prep; raise testing-awareness | **Route toward B10 (symptom / clinician-routing pathway)** if symptom-driven; else stay B11, raise screening prominence |
| **Contraception / method question** arises | Provide contraception *education* (options, how they differ) with clear "education only, not Femio-provided contraception, discuss with a clinician" framing | **Bridge to B13 (contraception education)** — education only |
| **Partner disclosed STI / possible exposure** | Calm educational pathway: get evaluated/tested, clinician routing, confidentiality reassurance, **IPV-safety + crisis resources** surfaced | Stay B11, raise testing + safety routing |
| **Sets TTC intent = true** | Confirm; add preconception + STI-in-pregnancy awareness (screening is part of antenatal care); retain SRH education | Route to C-track (TTC), SRH context carried |
| **Mood/anxiety screen trends low / crisis flag** (stigma-driven distress) | Surface mental-health module + localized crisis resources; screening-framed | Stay B11 (universal handler) |
| **Locale / discretion-need change** | Re-apply discreet-mode defaults; re-confirm notification masking + sharing scope | Stay B11 |
| **User toggles off SRH mode** | Revert to generic reproductive-age logic; preserve all history (reachable) | General reproductive-age band |

All transitions require **explicit user confirmation**, preserve data continuity, keep the sensitivity tier, and never lock her out of prior/other content. **Respectful and non-judgemental across all markets**; discreet-by-default where stigma is high.

---

## K. Compliance flags

- **Scope:** wellness / education / tracking + screening awareness ONLY. No STI diagnosis, no treatment, no disease-prevention claim, not contraception. (Aligns with Femio compliance-privacy skill + medical-device scope avoidance.)
- **No diagnosis:** the symptom-guidance flow and any screener return "reasons to discuss with a clinician / this is a screening tool, not a diagnosis." **Never** outputs "you have / likely have [STI]," and never a "you're clean/safe" reassurance.
- **Never contraception-as-device claim:** condoms/other methods are described only as **risk-reduction / clinician-and-B13 education**; Femio never presents itself or any method as providing contraception or guaranteeing pregnancy/STI prevention. No safe-day/fertile-window-as-protection framing anywhere.
- **Medication / treatment content (antibiotics, antivirals, expedited partner therapy, PEP):** educational context only — "things a clinician may do." No recommendation, dosing, or "take this." Clinician routing always.
- **Cultural sensitivity / discretion:** Arabic-first/RTL; non-judgemental copy; no marital/relationship-status gate on knowledge; discreet-mode (masked notifications, neutral labels, quick-hide, app-lock) default-on in high-stigma locales; **respectful across all markets**. Never assumes sexual activity or promiscuity.
- **IPV safety:** partner-notification/exposure content surfaces intimate-partner-violence safety and localized crisis resources before any partner-contact suggestion.
- **Mental health:** crisis resources on any low screen; localized per region/language.
- **Privacy (GDPR/PDPL health data):** sexual-health data = **highest special-category sensitivity tier**; explicit granular consent, purpose limitation, **no ad-SDK/third-party sharing** (post-Flo trust is decisive here), local-first where feasible, full export/delete, no revealing notifications/widgets. Data-mapping + DPIA required before launch.
- **Minors (A-track):** age-appropriate SRH education; knowledge never gated but framing/depth/routing age-adapted; community/DMs/UGC safeguarding-gated; trusted-adult scope + local age-of-consent respected.
- **Content integrity:** all medical content referenced, medically reviewed with byline + date, YMYL/E-E-A-T compliant; grade 6–8; 4 languages with Arabic-first/RTL QA.
- **App-store health policy:** framing as education/tracking (not diagnosis/treatment/device) keeps out of regulated-device territory; sexual-content and health-claims store policies reviewed before submission.
- **Global routing constraint:** no market-specific prevalence, discretion, clinic-availability, or access claim is published from this global persona. Any future market module requires separate verification. Global STI and IPV routing follows the WHO and crisis-resource policy cited above. *(Reviewed Mohamed K., 23 July 2026; next review 23 July 2027.)*

---

## Sources

**Clinical — Tier 1 (WHO / CDC / NIH-MedlinePlus / NHS / USPSTF):**
- [Sexually transmitted infections (STIs) — WHO fact sheet](https://www.who.int/news-room/fact-sheets/detail/sexually-transmitted-infections-(stis))
- [STI Screening Recommendations — CDC](https://www.cdc.gov/std/treatment-guidelines/screening-recommendations.htm)
- [Getting Tested for STIs — CDC](https://www.cdc.gov/sti/testing/index.html)
- [Reducing Risk for Cervical Cancer (HPV vaccination + screening) — CDC](https://www.cdc.gov/cervical-cancer/prevention/index.html)
- [Chlamydia and Gonorrhea: Screening — USPSTF](https://www.uspreventiveservicestaskforce.org/uspstf/recommendation/chlamydia-and-gonorrhea-screening)
- [Sexually Transmitted Infection (STI) Tests — MedlinePlus](https://medlineplus.gov/lab-tests/sexually-transmitted-infection-sti-tests/)
- [Chlamydia Test — MedlinePlus](https://medlineplus.gov/lab-tests/chlamydia-test/)
- [Sexually transmitted infections (STIs) — NHS](https://www.nhs.uk/conditions/sexually-transmitted-infections-stis/)
- [Genital herpes — NHS](https://www.nhs.uk/conditions/genital-herpes/)
- [Sex activities and risk (safer sex / condoms) — NHS](https://www.nhs.uk/live-well/sexual-health/sex-activities-and-risk/)

**Clinical — Tier 2 (ACOG / BASHH / society / peer-reviewed):**
- [Expedited Partner Therapy — ACOG Committee Opinion No. 737](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2018/06/expedited-partner-therapy)
- [BASHH Summary Guidance on Testing for STIs, 2023 (PDF)](https://www.bashh.org/_userfiles/pages/files/resources/bashh_summary_guidance_on_stis_testing_2023.pdf)
- [CDC Clinical Guidelines on Doxycycline Post-exposure Prophylaxis for Bacterial STI Prevention, 2024 — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11166373/)
- [Global Estimates of Prevalence and Incidence of Four Curable STIs — PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4672879/)

**Cultural context / stigma / MENA-Arab women (patient-journey + qualitative):**
- [Muslim women's perspectives on barriers to STI testing and diagnosis in Saudi Arabia — Frontiers in Public Health](https://www.frontiersin.org/journals/public-health/articles/10.3389/fpubh.2023.1248695/full)
- [Muslim women's perspectives on barriers to STI testing — PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10595004/)
- [Understanding the Barriers to Sexual Health in Middle Eastern Immigrant Women — Open Forum Infectious Diseases / PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC10678061/)
- [From taboo to revelation: Arab women find sexual freedom online — The New Arab](https://www.newarab.com/features/taboo-revelation-arab-women-find-sexual-freedom-online)

**Competitor / app landscape & privacy:**
- [Positive Singles Review: how an STD/STI dating app fuels stigma — Emily DePasse (Substack)](https://emilydepasse.substack.com/p/positive-singles-review-std-sti-stigma)
- [Stigma Health — online STI testing app (App Store)](https://apps.apple.com/au/app/stigma-health/id6448030303)
- [All About the Flo: A Review of the Period Tracker App — Healthline](https://www.healthline.com/health/flo-period-tracker)
- [Just 1 of 25 reproductive-health apps protect users' data — The Hill](https://thehill.com/changing-america/respect/accessibility/3605540-just-1-of-25-apps-that-track-reproductive-health-protect-users-data-report/)
- [Exploration of Reproductive Health Apps' Data Privacy Policies — JMIR/PMC](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11923453/)
- [Best Period Tracker App 2026: Clue vs Flo vs Ovia — Go-Go Gaia](https://www.go-go-gaia.com/blog/how-to-choose-period-tracker-app.html)
