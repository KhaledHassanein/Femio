# Persona A2 — Newly Menstruating Teenager (12–15)

Persona ID: **A2** · Track A (Puberty / Adolescent) · Mode: **Teen mode** (no ads, minimal data, trusted-adult, extra privacy)
Prepared: 2026-07-16 · Status: research + spec · Wave 1 (Spine)
Inherits Femio scope guardrail: **wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with a clinician."**

---

## A. Persona snapshot

| | |
|---|---|
| **Who** | "Layla," 13. Got her first period (menarche) ~4–8 months ago. Cycles jump around: 24 days, then 45, then a skipped month — all developmentally normal at her gynecologic age. |
| **Emotional state** | Curious + anxious + embarrassed. Oscillates between "is this normal?" and "please nobody find out." |
| **Health literacy** | Low. Learned fragments from a rushed school session, a friend, her mother (often "too little, too late"), and TikTok. Holds a few misconceptions. |
| **Privacy needs** | Very high. Fears a parent or sibling seeing the app. **May share a device** (family tablet / hand-me-down phone). Does not want ads or her data sold. |
| **Device / context** | Web-first; often a shared browser. Uses the app in short, private bursts (bathroom, bedroom). |
| **Language** | May be an Arabic-first / RTL user; menstruation is culturally sensitive → shame/secrecy pressure is higher, information access lower. |
| **Primary jobs-to-be-done** | (1) "Tell me what's normal so I stop worrying." (2) "Let me track discreetly and predict *roughly* when it's coming." (3) "Teach me my body in plain language." (4) "Let me reach *any* topic I'm curious about without the app deciding I'm too young." |
| **What success feels like** | Reassurance ("irregular is expected right now"), a period she wasn't ambushed by, a private space, and honest answers instead of a locked door. |
| **Anti-goals (things that break trust)** | Being surveilled by a parent by default; pink-flowers-only infantilizing UI; predictions stated as certainties then wrong; "you're too young to see this"; ads; pregnancy/fertility-optimization framing aimed at her. |

**Design tension to hold:** she needs *protection* (teen mode, minimal data, trusted-adult pathways) **and** *non-restriction* (full library reachable). Femio's rule — "personalize, never restrict" — is the whole game for A2. Teen mode changes **data handling, ads, and social exposure**, not **knowledge access**.

---

## B. Needs & questions (voice-of-user)

Mined from teen health forums, r/PeriodProblems / r/AskDocs-style threads, app-store reviews of teen period trackers, TikTok-menstrual-health research, and adolescent menstrual-literacy studies. Phrased in her voice; each mapped to what Femio should surface.

**"Is this normal?" (the dominant emotion — reassurance-seeking)**
- "My period was 3 weeks apart, then I skipped a month — is something wrong with me?" → *Normalize: irregular cycles are expected for the first 1–3 years (§D).*
- "I got it once and then nothing for 4 months. Is that okay?" → *Mostly normal early, but ~90 days is the evidence-based flag to raise with a clinician (§D).*
- "How long is a period *supposed* to last? Mine was 7 days." → *2–7 days is typical; frame as range, not a rule (§D).*
- "How much blood is too much?" → *Practical rule: soaking a pad/tampon more often than every 1–2 hours, or doubling up, = discuss with a clinician (§D).*
- "Is brown blood / spotting normal?" → yes, commonly.

**"How do I actually deal with this?" (coping > biology — studies show teens want *coping*, not just the science)**
- "How do I use a pad / tampon / period underwear? Can a tampon get lost inside me?"
- "How do I not leak at school / through white trousers? What do I keep in my bag?"
- "What helps cramps?" → *education on heat, movement, OTC pain relief per label / caregiver — never a Femio "treatment" instruction (§K).*
- "Can I swim / do PE / pray / fast on my period?" → practical + culturally-aware (Arabic-first) answers.

**"When is it coming?" (prediction, but honest)**
- "Can this app tell me exactly when my next period is?" → *No app can be exact for irregular teens; Femio gives a **wide, uncertainty-honest window** and says why (§D, §G).*
- "It said my period would come Tuesday and it didn't — is the app broken / am I broken?" → *pre-empt this; irregularity is the reason, not a defect.*

**"Am I okay?" (worry / red-flag-adjacent)**
- "My periods are SO heavy / I feel dizzy and tired." → iron/anemia education + "discuss with a clinician."
- "The pain makes me miss school / throw up." → not something to "push through"; screening + clinician.
- "I'm 15 and still haven't started" (adjacent A5) or "acne + hair + very irregular" (adjacent A4/PCOS).

**"Please keep this private." (privacy / shame)**
- "How do I hide this app if my mum uses the same tablet?" → *quick-hide / discreet naming / no lock-screen leakage / per-profile privacy.*
- "Will my parents see what I track?" → *by default, no. Trusted-adult involvement is opt-in and transparent, not covert surveillance.*
- "Do they sell my data? Do I get ads?" → *teen mode = no ads, minimal data.*

**"Don't treat me like a baby OR an adult."**
- Wants grown-up, straight answers in **plain grade 6–8 language**, without adult TTC/fertility/contraception-optimization framing pushed at her.
- Wants to be *able* to read about anything (sex, contraception, PCOS, pregnancy) out of curiosity — being blocked drives her to worse sources (TikTok). Femio keeps the door open; teen mode governs *data + social + ads*, not *reading*.

> **Key research insight:** literacy programs that raise knowledge **lower menstruation-related stress and raise self-efficacy** — reassurance is not fluff, it is the core clinical-adjacent value for A2 (§D, sources).

---

## C. Competitor teardown

How the major apps serve — or fail — a 12–15-year-old, feature by feature. The recurring failure is the **"17+ gap"**: apps rated/oriented for adults, monetized by ads/subscriptions, framed around fertility/TTC, and privacy-porous.

| App | Teen fit | Strengths for A2 | Fails A2 on |
|---|---|---|---|
| **Flo** | Min age 13 (16 in EU). Markets a teen/first-period space. | Large content library; some age-appropriate first-period education; added **Anonymous Mode** (decouples name/email from health data) post-Roe. | History of **sharing period/pregnancy data with Facebook/Google** → FTC settlement (2021) + jury finding Meta liable + class settlement; heavy upsell/ads pressure; fertility-first framing; Anonymous Mode is opt-in, loses data on device change, and can't sync wearables. Not privacy-by-**default**. |
| **Clue** | Popular with teens; science-forward. | **GDPR / Berlin-based**, publishes transparency reports, states it won't hand data to US authorities; neutral, non-infantilizing, education-strong; good "is this normal" content. | Not teen-*designed*: paywalls key predictions; still an adult product; no true teen mode / trusted-adult layer; no shared-device discreteness built for minors. |
| **Stardust** | Trendy with teens (astrology hook). | Marketed privacy-forward; engaging aesthetic. | Astrology framing muddies medical accuracy; scrutiny over data/privacy claims; not clinically referenced; no teen-safeguarding architecture. |
| **Spot On (Planned Parenthood)** | Genuinely teen-friendly design. | **Gender-neutral, non-stereotyped** ("fewer flowers, more dinosaurs"); plain language; reputable educational voice; birth-control + period tracking; free. | US-reproductive-politics brand may be a non-starter for Arabic-first / conservative-market families; contraception-forward; limited condition-grade depth; English-centric; not Arabic-first/RTL. |
| **Eve (by Glow)** | Skews older/sexual-health. | Frank sexual-health content. | **Sex-forward + community** tone unsuitable as a *default* for a 13-yo; Glow ecosystem is fertility/TTC-monetized; privacy concerns historically. |
| **My Calendar / Period Calendar (Simple Design)** | Widely installed by teens (free, simple). | Low-friction, simple logging; theme/lock options. | Ad-supported (bad for minors); shallow, **unreferenced** content; data-practice opacity; no clinical grounding, no teen safeguarding. |
| **Generic "period tracker" apps** | Default download for teens. | — | Ads, data brokering, exact-date predictions that mislead irregular teens, no red-flag literacy, no privacy-by-design. |

**White space Femio can own for A2:**
1. **Privacy-by-**default** teen mode** (not opt-in anonymous bolt-on): no ads, minimal data, no community DMs, discreet on shared devices, trusted-adult *opt-in* and *transparent*.
2. **Uncertainty-honest predictions** built for irregular adolescent cycles — a *window*, with a plain "here's why it's a range."
3. **Referenced, medically-reviewed** content at grade 6–8 — vs. TikTok myths and unreferenced app blurbs.
4. **Arabic-first / RTL** menstrual education — a near-empty niche; the incumbents are English-centric.
5. **Personalize-never-restrict**: the *only* app that gives a teen full knowledge access while still protecting her data — closing the "17+ gap" without slamming doors.

---

## D. Clinical grounding (cited)

All numbers below are from Tier-1 (NIH/MedlinePlus/CDC/WHO/NHS) and Tier-2 (ACOG/AAP/RCOG/NICE) sources; URLs in **Sources**. Femio surfaces these as *education*, never as diagnosis. Where a stat could not be firmly sourced, it is flagged `[NEEDS SOURCE]`.

**What's normal in the first years after menarche**
- **Average age at menarche ≈ 12**, with a normal range roughly **8–16** (Mayo/KidsHealth/UChicago).
- **Irregular cycles are normal for the first ~1–3 years** because many early cycles are **anovulatory** (KidsHealth, Johns Hopkins, ACOG).
- **Cycle length** in adolescents is *wider* than adults: roughly **~20/21–45 days** is common (adult norm is ~21–34/35). Mean ~32 days in the first two gynecologic years (ACOG "Menstrual cycle as a vital sign"; Johns Hopkins).
- **Period (bleed) duration** typically **≤ 7 days** (ACOG). `[NEEDS SOURCE — exact "2–7 day" lower bound to confirm to ACOG/NHS wording before publishing content]`
- It can be normal to **skip months** in the first year or two (KidsHealth, UChicago).

**Evidence-based "raise it with a clinician" thresholds (screening language, NOT diagnosis)**
- **> ~90 days (≈3 months) between periods**, even in the first gynecologic year — ACOG sets the 95th-percentile cycle length at **90 days**, so ~3 months (not the old "6 months") is the evidence-based flag.
- **No period by age 15**, or by **~3 years after breast development begins** → evaluate (primary amenorrhea; ACOG/KidsHealth) — adjacent persona A5.
- **Heavy menstrual bleeding signals:** soaking through a pad/tampon **more often than every 1–2 hours**, needing to **double up** on protection, or bleeding that disrupts daily life → discuss with a clinician; untreated heavy bleeding risks **iron-deficiency anemia** (ACOG bleeding-disorder screening; CHLA; UChicago). A **family bleeding history** (easy bruising/nosebleeds, heavy periods in relatives) raises the flag.
- **Severe pain** that causes missed school or vomiting is **not something to just endure** → screening + clinician (CHLA/Cleveland Clinic) — adjacent persona A3.

**PCOS caution (adjacent A4 — critical framing)**
- **PCOS generally should not be diagnosed within ~2–3 years of menarche** because irregular cycles are developmentally normal that early. Femio must **never** suggest PCOS to a newly menstruating teen from irregularity alone; it may, if a *pattern* of red flags persists (cycles >45 days, marked hyperandrogenic signs like severe jaw/back acne or hirsutism, acanthosis nigricans), gently surface **"these are things to screen for — please discuss with a clinician,"** and consider an adaptation nudge (§J). (PMC adolescent-PCOS review; KidsHealth; NYU Langone.)

**Menstrual cycle as a vital sign** — ACOG/AAP endorse treating the cycle as a health signal in adolescents; this legitimizes gentle tracking + "know your normal" as clinically supported behavior, which is exactly Femio's A2 value.

---

## E. Feature set (prioritized: must-have → nice-to-have)

**Must-have (MVP for A2)**
1. **Teen mode by default when age 12–15** — no ads; minimal data collection; **no community DMs**; trusted-adult involvement **opt-in**; GDPR age-of-consent handling; privacy-by-design.
2. **Discreet period + symptom logging** — few taps; works on **shared devices** (per-profile privacy; no lock-screen/notification leakage; neutral app naming; quick-hide).
3. **"Is this normal?" reassurance engine** — contextual, referenced answers tied to what she just logged (e.g., after a 44-day gap: "This is common in your first years — here's why").
4. **Uncertainty-honest prediction** — a **window** ("your next period is likely between ___ and ___"), with a one-line plain explanation that irregular teen cycles can't be pinned to a date. Never a single confident date.
5. **Plain-language first-period education hub** (grade 6–8, referenced, medically reviewed) — see §F.
6. **Gentle red-flag literacy** — teaches the §D thresholds as *"things worth mentioning to a trusted adult / clinician,"* never as a diagnosis or alarm.
7. **Full-library reachability** — search reaches *every* topic; teen mode governs data/ads/social, **not** reading access (personalize-never-restrict).
8. **Arabic-first / RTL** + EN/FR/ES; culturally sensitive tone.

**Should-have**
9. **Cycle-as-vital-sign summary** she can optionally show a parent/doctor.
10. **Pad/tampon/period-underwear how-to** + "period kit for your bag" checklist.
11. **Cramp & coping education** (heat, movement, OTC-per-label/caregiver) — education, not prescription.
12. **Myth-busting module** (counter common TikTok/peer misconceptions).
13. **Trusted-adult sharing** — opt-in, granular, transparent ("here's exactly what would be shared").
14. **Gentle, private reminders** ("period may be near — pack supplies"), no sensitive content in the notification text.

**Nice-to-have**
15. Optional mood/energy/skin logging (framed as self-knowledge, not diagnosis).
16. Discreet "first aid at school" quick card.
17. Age-appropriate body-literacy illustrations (neutral, non-infantilizing, not pink-flowers-only).
18. Journal / questions-for-my-doctor note.
19. Cultural add-ons (fasting/prayer guidance for Arabic-first users), clearly educational.

---

## F. Content modules (reading order)

Sequenced from reassurance → basics → coping → self-knowledge → boundaries. All grade 6–8, referenced, medically reviewed, in 4 languages.

1. **"You're normal" (start here)** — irregular cycles are expected in the first 1–3 years; what a cycle is; you're not broken. *(Reassurance-first, per literacy research.)*
2. **What is a period? The cycle in plain words** — cycle length range, bleed duration, why early cycles skip (anovulation), cycle-as-a-vital-sign.
3. **Using period products** — pads, tampons (incl. "it can't get lost"), period underwear, cups; changing frequency; hygiene.
4. **Surviving the school day** — leak-proofing, what to pack, what to do if caught off guard.
5. **Cramps & feeling rough** — what helps (heat, movement, OTC per label / with a trusted adult), what's normal vs. worth mentioning.
6. **"Is this normal?" — the honest guide to flags** — the §D thresholds framed as *talk-to-a-trusted-adult/clinician*, calm not scary.
7. **Tracking without stress** — how to log, why predictions are a *window* not a date.
8. **Myth-busting** — common peer/TikTok myths corrected with references.
9. **Your body, your privacy** — what Femio does/doesn't do with her data; how to keep it private on a shared device; what a trusted adult would/wouldn't see.
10. **Curious about more? (open door)** — respectful, age-appropriate gateway into the wider library (bodies, growing up, and — reachable, not pushed — sex/contraception/conditions), so she never has to leave for worse sources.

---

## G. Tools, logs & alerts (with compliant framing)

**Logs (minimal, discreet, self-knowledge framing)**
- Period start/end; flow (spotting → light → medium → heavy).
- Optional: cramps/pain (0–3 scale), mood, energy, skin, notes.
- Product-change frequency (feeds heavy-bleeding *education*, not a diagnosis).
- **Data minimization:** only what she chooses; no location; no default cloud-of-brokers.

**Tools**
- **Uncertainty-honest predictor** — outputs a **range + confidence + plain reason** ("irregular now = wider window; this will narrow as your cycles settle"). Never a lone confident date; never a "safe day / fertile" framing for A2 (not contraception — §K).
- **"Know your normal" summary** — her ranges vs. typical adolescent ranges, shareable *by her choice* with a trusted adult/clinician.
- **Screeners** (heavy bleeding, very-long-gap, PCOS-adjacent) → output is always **"this is screening — please discuss with a clinician,"** never a result/label.

**Alerts (private, gentle, non-clinical wording)**
- "Your period may be near — you might want supplies." (Neutral notification text; no health detail on lock screen.)
- Reassurance nudge after an irregular gap ("this is common — here's why").
- **Soft red-flag prompt** when logs cross a §D threshold: *"Some people find it helpful to mention this to a trusted adult or clinician,"* + link to the calm flags article. **No alarms, no diagnosis, no "you might have X."**
- **Never:** ads, fertility/TTC upsell, "get pregnant/avoid pregnancy" messaging, or anything implying contraception reliability.

---

## H. EMR fields (core vs. persona-specific)

**Core (shared across all personas)**
- Account: pseudonymous ID, age/DOB (drives teen-mode gating), language/locale, RTL flag, consent records (incl. age-of-consent + guardian linkage state).
- Cycle log: period start/end dates, flow intensity, cycle length (derived), bleed duration (derived).
- Symptom log: pain, mood, energy, skin, notes (all optional).
- Privacy/state: teen-mode flag, ads-off flag, trusted-adult link (opt-in) + scope, data-minimization settings.

**Persona-specific (A2)**
- **Gynecologic age** (months/years since menarche) — the key adolescent variable driving "what's normal."
- **Menarche date** (approx allowed).
- **Cycle-regularity status** (irregular-expected / settling / persistently-irregular).
- **Longest inter-period gap** (feeds the ~90-day education flag).
- **Product-change frequency** (feeds heavy-bleeding education).
- **Adjacent-flag markers** (non-diagnostic booleans for education/adaptation only): heavy-bleeding-pattern, severe-dysmenorrhea-pattern, long-gap-pattern, PCOS-adjacent-signs, primary-amenorrhea-watch.
- **Trusted-adult involvement** status + exactly what is shared.
- Explicitly **NOT** stored for A2: fertility/ovulation intent, contraception-as-contraception fields, sexual-activity data by default (reachable content, but not defaulted logging).

---

## I. Personalization rules (wizard config + hidden-but-reachable)

**Wizard resolves A2 when:** age 12–15 **and** ("recently started periods" / menarche within ~0–3 years) — or she self-selects "I just started my periods."

**Home is configured to lead with:**
1. Reassurance card ("you're normal") + next-window predictor (as a range).
2. One-tap discreet log.
3. First-period education hub (§F order).
4. Privacy quick-controls (hide, what's shared).

**Defaults set by the wizard:**
- Teen mode ON (ads OFF, minimal data, no community DMs, trusted-adult opt-in).
- Predictions rendered as **windows** with the uncertainty explainer.
- Notifications = neutral text, no health detail on lock screen.
- Tone = plain, grown-up, non-infantilizing; imagery neutral (not pink-flowers-only).
- Locale = Arabic-first/RTL if selected; culturally sensitive framing on.

**Hidden-but-reachable (personalize, never restrict):**
- Everything TTC / pregnancy / contraception / condition-grade (PCOS, endo, etc.) is **not shown on her home** but is **fully reachable via search/library**. Teen mode changes *data handling, ads, and social exposure* — **not** what she can read.
- Adult-community/DM features are the *only* things genuinely gated off for minors (safeguarding), and the reason is stated plainly.
- "Skip / I'm not sure" → Z1 generic experience, then progressive nudge toward A2 as she logs.

---

## J. Adaptation triggers (state transitions)

Events that move her **into** or **out of** A2, or branch to an adjacent persona. All transitions are gentle, transparent, reversible, and never phrased as a diagnosis.

**Into A2:** wizard match (age + recent menarche) or first period logged by an A1 (pre-menarche) user → A1 → A2.

**Out of / branch from A2:**
- **Turning 16** → exits strict minor teen-mode gating per **GDPR age-of-consent** (consent/privacy re-confirmed); may move toward **B1** (general cycle/wellness) as cycles mature. Knowledge access unchanged.
- **Cycles regularize** (consistent within adult ranges after the expected 1–3 years) → transition toward **B1**; reassurance messaging dials down.
- **Persistent long gaps / >~90-day pattern** → surface amenorrhea *screening* education, nudge toward **A5** (late/absent periods) + "discuss with a clinician."
- **Persistent PCOS-adjacent pattern** (long cycles >45d **plus** hyperandrogenic signs, sustained beyond the 2–3-year window) → gentle **A4** screening nudge — *screening only, never a PCOS label* (§D caution).
- **Heavy-bleeding pattern** (soaking >q1–2h / doubling up / anemia-type symptoms) → **A3**-adjacent HMB education + clinician prompt.
- **Severe dysmenorrhea** (missing school / vomiting) → **A3** education + clinician prompt.
- **Content signals she's exploring sexual activity / contraception** → keep content reachable + age-appropriate; **do not** convert her to a contraception persona automatically; surface trusted-adult/clinician education. (Femio is never contraception — §K.)

---

## K. Compliance flags

- **Scope:** wellness / education / tracking **only**. A2 content and tools must never diagnose, treat, or prevent disease. All screeners output **"screening — discuss with a clinician."**
- **Not contraception:** for a minor especially, **no fertile-window/"safe day" framing** and no implication that tracking prevents pregnancy. Predictions are cycle-education windows only.
- **Predictions = uncertainty-honest:** never a single confident date; always a range + reason. Avoids implied medical certainty (medical-device-claim risk).
- **Minor privacy (highest tier):** teen mode by default — **no ads, minimal data, no community DMs, trusted-adult opt-in, GDPR age-of-consent** handling; guardian consent/linkage where required by jurisdiction. Privacy-by-design; data minimization; no location; no selling/brokering (explicitly the anti-pattern behind the Flo/Meta FTC actions).
- **Shared-device safety:** per-profile isolation, quick-hide, no sensitive lock-screen/notification content.
- **Safeguarding vs. surveillance:** trusted-adult involvement is **opt-in and transparent**, never covert monitoring of the teen.
- **Non-restriction principle:** teen mode governs data/ads/social — it must **not** be used to block knowledge; every topic stays reachable via library/search (prevents pushing her to unsafe sources).
- **Referenced content:** every clinical claim medically reviewed + cited (§D). No invented stats; open items flagged `[NEEDS SOURCE]` before publish.
- **Cultural sensitivity (Arabic-first/RTL):** menstruation is high-shame in some target markets — tone must reduce, not amplify, stigma; keep education accessible without exposing the user.
- **`[NEEDS SOURCE]` register:** confirm exact ACOG/NHS wording for bleed-duration lower bound; confirm any market-specific age-of-consent numbers per launch jurisdiction before shipping copy.

---

## Sources

**Adolescent menstruation — what's normal / clinical grounding**
- [Mayo Clinic — Irregular periods can be common at first](https://newsnetwork.mayoclinic.org/discussion/mayo-clinic-q-and-a-irregular-periods-can-be-common-at-first/)
- [Nemours KidsHealth (Teens) — Irregular Periods](https://kidshealth.org/en/teens/irregular-periods.html)
- [UChicago Medicine — Normal teen menstrual cycles: when to see a gynecologist](https://www.uchicagomedicine.org/forefront/pediatrics-articles/2025/september/getting-your-period-normal-menstrual-cycle-teens-preteens)
- [Johns Hopkins Medicine — Menstrual Cycle Management in Adolescents](https://www.hopkinsmedicine.org/health/conditions-and-diseases/menstrual-conditions/menstrual-cycle-management-in-adolescents)
- [ACOG Committee Opinion — Menstruation in Girls and Adolescents: Using the Menstrual Cycle as a Vital Sign](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2015/12/menstruation-in-girls-and-adolescents-using-the-menstrual-cycle-as-a-vital-sign)
- [AAP/Pediatrics — Menstruation in Girls and Adolescents (vital sign)](https://publications.aap.org/pediatrics/article/118/5/2245/69874/Menstruation-in-Girls-and-Adolescents-Using-the)
- [Brown University Health — Menstruation and Teenagers: All About Periods](https://www.brownhealth.org/be-well/menstruation-and-teenagers-all-about-periods)
- [PMC — Menstruation in Adolescents: What's Normal?](https://pmc.ncbi.nlm.nih.gov/articles/PMC2644006/)

**Heavy bleeding / red flags / PCOS (adjacent)**
- [ACOG — Screening and Management of Bleeding Disorders in Adolescents With Heavy Menstrual Bleeding](https://www.acog.org/clinical/clinical-guidance/committee-opinion/articles/2019/09/screening-and-management-of-bleeding-disorders-in-adolescents-with-heavy-menstrual-bleeding)
- [Children's Hospital Los Angeles — Teens With Heavy Menstruation](https://www.chla.org/blog/advice-experts/teens-heavy-menstruation-dont-need-suffer-silence-period)
- [UChicago Medicine — Heavy Menstrual Bleeding in Teens & Preteens](https://www.uchicagomedicine.org/comer/conditions-services/pediatric-adolescent-gynecology/heavy-menstrual-bleeding)
- [Cleveland Clinic — Why Are My Teen's Periods So Heavy?](https://health.clevelandclinic.org/why-are-my-teens-periods-so-heavy-should-i-be-concerned)
- [PMC — Polycystic Ovarian Syndrome in Adolescents](https://pmc.ncbi.nlm.nih.gov/articles/PMC9951123/)
- [Nemours KidsHealth (Teens) — PCOS](https://kidshealth.org/en/teens/pcos.html)
- [NYU Langone — Diagnosing PCOS in Adolescents](https://nyulangone.org/conditions/polycystic-ovary-syndrome-in-adolescents/diagnosis)

**Menstrual health literacy (why reassurance/education is the core value)**
- [PMC — Adolescent Menstrual Health Literacy in Low, Middle and High-Income Countries: A Narrative Review](https://pmc.ncbi.nlm.nih.gov/articles/PMC7956698/)
- [PMC — Menstrual Health Literacy in Schools Reduces Stress and Increases Self-Efficacy (Mexico)](https://pmc.ncbi.nlm.nih.gov/articles/PMC9047952/)
- [OHSU News — Study using TikTok finds teens lack understanding of menstrual health](https://news.ohsu.edu/2023/11/17/study-using-tiktok-finds-teens-lack-understanding-of-menstrual-health)
- [The Conversation — The US lacks adequate education around puberty and menstruation](https://theconversation.com/the-us-lacks-adequate-education-around-puberty-and-menstruation-for-young-people-an-expert-on-menstrual-health-explains-187501)
- [BMC Public Health — Menstrual experiences of adolescent girls in schools (England)](https://link.springer.com/article/10.1186/s12889-025-24681-1)

**Competitor teardown & privacy**
- [Protect Young Eyes — Best Period Tracking Apps for Young Girls](https://www.protectyoungeyes.com/blog-articles/the-best-period-tracking-apps-for-young-girls)
- [Flo — Can I use Flo below the age of 13?](https://help.flo.health/hc/en-us/articles/360042626231-Can-I-use-Flo-below-the-age-of-13)
- [Unstar.app — Flo vs Clue vs Stardust: Period Apps Ranked (2026)](https://unstar.app/blog/flo-clue-stardust-apple-health-period-tracking-apps-ranked-2026)
- [The Teen Magazine — Are Period Apps Right for Teenagers?](https://www.theteenmagazine.com/the-truth-about-period-apps-are-they-right-for-teenagers)
- [Planned Parenthood Direct — Spot On Period Tracker](https://www.plannedparenthooddirect.org/spot-on-period-tracker)
- [NPR — Period tracking apps and data privacy post-Roe](https://www.npr.org/2022/05/10/1097482967/roe-v-wade-supreme-court-abortion-period-apps)
- [The Bureau of Investigative Journalism — Meta caught eavesdropping on Flo](https://www.thebureauinvestigates.com/stories/2025-09-03/meta-was-caught-eavesdropping-on-a-period-app-could-this-be-the-start-of-a-pushback-against-big-tech)
- [KFF Health News — Should You Worry About Period-Tracking App Data?](https://kffhealthnews.org/news/period-tracking-apps-data-privacy/)
- [Healthcare Dive — Flo launches Anonymous Mode](https://www.healthcaredive.com/news/flo-anonymous-mode-period-tracker-app-abortion-roe/631926/)
- [Clue vs Flo comparison (GDPR / data-sharing history)](https://www.go-go-gaia.com/blog/clue-vs-flo.html)
