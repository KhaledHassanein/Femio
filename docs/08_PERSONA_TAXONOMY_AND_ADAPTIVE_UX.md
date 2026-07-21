# Femio V2 — Persona Taxonomy & Adaptive-UX Plan
Prepared: 2026-07-16 · Status: living document · Aligns with 02_MARKET_USER_RESEARCH, 03_COMPETITOR_ANALYSIS, 05_PRODUCT_STRATEGY_PLAN

Purpose: a per-persona research + design pipeline. For each scenario a research agent role-plays the user, mines real needs + competitor coverage + clinical guidelines, then specs the features, content, tools, EMR fields and **personalization/adaptation rules**. Outputs feed one **master adaptation model** and the **Figma UX flows**.

**Non-negotiable scope (from 05 + compliance skill):** wellness / education / tracking only. Never diagnose, treat, prevent disease, or act as contraception. Screeners = "screening, discuss with clinician." Every persona spec inherits these guardrails.

---

## 1. Adaptive-UX principle

```
Welcome wizard ─►  Persona resolver  ─►  Personalized state
   (editable/            │                (home · tools · content ·
    resettable in        │                 alerts · EMR view)
    settings)            │                        │
Live updates ───────────┘                         ▼
(new log · positive test · lab result ·   Re-resolves continuously.
 diagnosis · gestational milestone · loss) Nothing is ever locked away —
                                           everything stays reachable.
```

Two rules that protect the user from frustration:
1. **Personalize, never restrict.** The wizard tailors emphasis and defaults; it never removes access. Any feature or article is always reachable via search/library.
2. **Graceful fallback.** A user who doesn't fit a defined persona (or declines to specify) gets the full generic experience and is *progressively* nudged toward the nearest-matching persona(s) as she logs data.

---

## 2. Master persona taxonomy (expanded v2)

Life-stage tracks × condition modifiers. This is intentionally broad; Wave plan (§4) sequences the research.

### Track A — Puberty / Adolescent  *(teen mode: no ads, minimal data, trusted-adult, extra privacy)*
A1 Pre-menarche (≈9–12) learning about puberty · A2 Newly menstruating teen (12–15) · A3 Teen heavy/painful periods · A4 Teen PCOS-type signs · A5 Teen absent/late periods (primary amenorrhea) · A6 Teen athlete — low energy availability / RED-S *(wellbeing-sensitive)*

### Track B — Cycle & gynae health  *(reproductive, not TTC, not pregnant)*
B1 General cycle/wellness tracker · B2 PMS/PMDD (DRSP) · B3 Dysmenorrhea · B4 Heavy menstrual bleeding · B5 Irregular/absent cycles · B6 PCOS (not TTC) · B7 Endometriosis · B8 Fibroids · B9 Adenomyosis · B10 Vaginal/pelvic health (BV, candidiasis, UTIs) · B11 Sexual & reproductive health / STI awareness · B12 Sexual wellbeing (low libido, dyspareunia, pelvic floor) · B13 Contraception method user (pill/ring/patch/IUD/implant) — reminders + side-effects · B14 Coming off contraception (cycle recovery) · B15 Menstrual migraine · B16 Hypothalamic amenorrhea / eating-disorder-adjacent *(wellbeing-sensitive)* · B17 Thyroid affecting cycle (non-TTC) · B18 Cancer screening & prevention (Pap/HPV, breast self-exam, family history/BRCA) · B19 Gynae cancer survivor / in treatment

### Track C — Trying to conceive (TTC)
C1 TTC general / fertile-window awareness · C2 Primary infertility <35 · C3 Primary infertility ≥35 · C4 Secondary infertility · C5 Recurrent pregnancy loss (RPL) · C6 TTC + PCOS · C7 TTC + endometriosis · C8 TTC + thyroid · C9 TTC + male-factor (partner) · C10 TTC in ART (IUI/IVF) · C11 TTC after stopping contraception · C12 TTC + high anxiety/prior loss · C13 LGBTQ+ / donor-conception TTC · C14 Single mother by choice · C15 Fertility preservation (egg freezing / pre-oncology) · C16 Premature ovarian insufficiency / low reserve

### Track D — Pregnancy
D1 Uncomplicated · D2 Pregnancy after loss (anxiety-aware) · D3 Gestational diabetes · D4 Pre-existing diabetes (T1/T2) · D5 Chronic hypertension · D6 Pre-eclampsia / gestational HTN · D7 Thyroid disease · D8 Prior preterm birth · D9 Multiple gestation · D10 Anemia / nutritional risk · D11 Antenatal depression/anxiety (EPDS) · D12 High BMI / obesity · D13 Advanced maternal age · D14 Prior C-section / VBAC · D15 Hyperemesis gravidarum · D16 Intrahepatic cholestasis · D17 Rh-negative / sensitization

### Track E — Postpartum
E1 Recovery (general) · E2 Breastfeeding / lactation · E3 Postpartum mood disorder (EPDS) · E4 After complicated pregnancy (GDM→T2DM screen, HTN follow-up) · E5 Postpartum contraception / return of fertility · E6 Pregnancy loss / stillbirth grief · E7 Postpartum thyroiditis

### Track F — Perimenopause & Menopause
F1 Perimenopause symptom tracking (MRS) · F2 Menopause / postmenopause · F3 Menopause + comorbidity (bone, cardiovascular) · F4 Surgical / induced menopause · F5 Premature ovarian insufficiency / early menopause (<40) · F6 Genitourinary syndrome of menopause (GSM)

### Cross-cutting modes
X1 Parent/guardian mode (adult supporting a teen) · X2 Partner mode (shared TTC/pregnancy view)

### Fallback persona (universal safety net)
**Z1 — Other / Custom.** For any user whose situation isn't a defined persona, or who declines to specify. She is **never blocked or forced**: she gets the full generic experience with everything reachable, and a **nearest-persona resolver** progressively personalizes her home/tools/content as she logs data (similarity match to the closest one or blend of defined personas). Guarantees zero limitation or frustration. Every wizard also offers "Skip / I'm not sure" → Z1.

*≈70 personas + fallback. Deep research runs in waves (§4).*

---

## 3. Standard schema every persona agent fills
A Persona snapshot · B Needs & questions (voice-of-user) · C Competitor teardown (Flo, Clue, Ovia, Glow, Premom, Natural Cycles, What to Expect, Pregnancy+, Peanut, condition tools) · D Clinical grounding (ACOG/RCOG/NICE/ASRM/ESHRE/NIH/WHO, cited) · E Feature set (prioritized) · F Content modules · G Tools/logs/alerts (with compliant framing) · H EMR fields (core vs. persona-specific) · I Personalization rules · J Adaptation triggers (state transitions) · K Compliance flags.

---

## 4. Execution — waves
- **Wave 1 — Spine (approved):** A2, B6 (PCOS), C1 (TTC), D1 (pregnancy), E1 (postpartum), F1 (perimenopause). Plus Z1 fallback logic defined alongside.
- **Wave 2 — Named high-value cases:** A1, C2, C4, C5, C8, D3, D6, D7, D4, D5.
- **Wave 3 — Remaining modifiers** across all tracks + cross-cutting modes.

Then: master adaptation model (once, from all specs) → Figma flows.

Outputs land in `docs/personas/<id>_<slug>.md` (report + spec per persona).
