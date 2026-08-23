# Femio V2 — Legal & Compliance Foundation (P0.12)
Prepared: 2026-07-16 · Status: **DRAFTS for qualified counsel to finalize** · Owner: Khaled + legal/DPO

> **Not legal advice.** This is an engineering/compliance foundation and a first draft of policies to hand to a qualified lawyer and a data-protection specialist. Femio processes **special-category health data** across GDPR, Saudi/UAE PDPL, and Egypt Law 151/2020 jurisdictions — a lawyer and a DPO must review and finalize every policy before launch. Items needing counsel are flagged **→ COUNSEL**.

## 0. Why this matters (context)
Privacy is Femio's headline differentiator in a scandal-ridden category (Flo FTC 2021, Premom FTC 2023, Glow breach 2024). We must be **verifiably clean, not just legally adequate**. Two existential rules run through everything: (a) stay **outside medical-device scope** (wellness/education/tracking only — never diagnose/treat/prevent/contracept), and (b) **never let health data reach ad/analytics SDKs**.

---

## 1. Entity & jurisdiction (brief — decision needed → COUNSEL)
Femio serves **MENA (Egypt/Gulf) and EU/global** users and hosts in the **EU region**. The entity choice drives tax, liability, data-controller identity, and which DPA templates apply. Factors to weigh with counsel/accountant (this doc does **not** recommend one):
- **Home-market entity (Egypt)** — closest to founder/ops; must still appoint an EU representative (GDPR Art. 27) if targeting EU users, and comply with Egypt 151/2020 (registration with the Egyptian Data Protection Center).
- **EU/EEA entity** (e.g. Ireland/Estonia) — simplifies GDPR controller status + EU hosting story; adds cost/admin.
- **Gulf entity** (e.g. UAE free zone) — strong for Gulf market/payments; check PDPL specifics.
- **Holding + operating split** — common for fundraising; premature pre-revenue.
Deliverable for counsel: pick controller entity, appoint DPO (health data at scale likely triggers a mandatory DPO under GDPR Art. 37), appoint EU + any local representatives, and register where required. **→ COUNSEL: entity + DPO + representatives + registrations.**

## 2. Regulatory map (what applies)
| Regime | Applies because | Key obligations we must meet |
|---|---|---|
| **GDPR** (EU/EEA users) | targeting EU users, EU hosting | lawful basis + **explicit consent** for Art. 9 health data; DPIA; DSAR/export/delete; processor DPAs; breach 72h; Arts. 13/14 transparency; Art. 27 rep |
| **Saudi PDPL / UAE PDPL** | Gulf users | consent, purpose limitation, cross-border transfer rules, breach notice, data-subject rights |
| **Egypt Law 151/2020** | Egypt users/ops | consent, PDPC registration/licensing, DPO, cross-border rules |
| **ePrivacy / cookie law** | any tracking/storage | prior consent for non-essential cookies/SDKs |
| **App-store health rules** (Phase 4) | iOS/Play | Apple 5.1.3 (no health-data ad use, no false medical claims), Play Health declaration + Data Safety form matching the data map |
| **Medical-device (FDA SaMD / EU MDR)** | AVOID by scope | keep intended purpose = wellness/education/tracking; never diagnose/treat/prevent/contracept (see §7) |
| **Consumer/health-claims & advertising** | marketing | no diagnosis/prevention claims; affiliate disclosure; no health-data-targeted ads |

---

## 3. Privacy Policy — draft (health-specific) → COUNSEL to finalize
Plain-language, layered (short summary + full). Sections:
1. **Who we are** — controller entity + DPO + EU/local rep contacts. **→ COUNSEL.**
2. **What we collect** — account (pseudonymous ID, email if account, DOB/age for gating, locale); **health data (special category):** cycle/period, symptoms, mood, vitals, meds, labs the user enters, screener results, life-stage/persona state; device/technical (minimal); **never** collect data no active feature needs (data minimization — the #1 user resentment).
3. **Why & lawful basis** — **explicit consent** for health-data processing, captured **before the first health field is stored**, per purpose and **separately**: (a) tracking/core, (b) insights/pattern engine, (c) research opt-in. Contract basis for account/billing. Legitimate interest only for non-health security/analytics (pseudonymous, health-field-free).
4. **How predictions/insights work** — uncertainty-honest, not medical advice, not diagnosis.
5. **Sharing / processors** — named sub-processors (hosting, email, error monitoring, analytics), each under a **DPA**; **no health data to ad networks or third-party analytics SDKs — ever**; affiliate links disclosed. Maintain processor register.
6. **International transfers** — EU hosting; transfer mechanism (SCCs/adequacy) for any non-EU processor. **→ COUNSEL.**
7. **Retention** — per data map; delete on request (cascade incl. backups schedule); default retention windows per field. Anonymous-mode data device-keyed.
8. **Your rights** — access, **export (JSON + PDF)**, **full deletion (cascade)**, rectification, withdraw consent, object; in-product, target <72h automated.
9. **Anonymous mode** — full tracking without identity; upgradeable to account without data loss.
10. **Minors** — teen mode: no ads, minimal data, no community DMs; parental/guardian consent flow per country age-of-consent (13–16). **→ COUNSEL: per-jurisdiction ages + verifiable parental consent mechanics.**
11. **Security** — encryption in transit/at rest, access controls, RLS, breach runbook.
12. **Changes & contact** — versioned; DPO/privacy contact; complaint right to supervisory authority.

## 4. Terms of Service — draft → COUNSEL
Eligibility & age; **wellness disclaimer** ("Femio provides educational and tracking tools, not medical advice, diagnosis, or treatment; it is **not a contraceptive** and does not replace your clinician — in an emergency contact local services"); **no doctor–patient relationship**; account responsibilities; acceptable use (no scraping/abuse); **subscriptions & billing** (Pro tier, renewal, refunds, price changes — align to store rules in Phase 4); **UGC/community** rules + moderation; intellectual property (Femio owns content/marks; licensed medical sources respected); **disclaimers & limitation of liability** (health context — draft carefully); indemnity; governing law & dispute resolution (ties to entity §1); modification & termination. **→ COUNSEL: liability, governing law, arbitration, consumer-law carve-outs.**

## 5. DPIA — structure (mandatory before launch & before each new data category)
1. **Description** — systematic processing of special-category health data of a large number of individuals, incl. minors; profiling (insights/predictions). *(This combination itself triggers a DPIA under GDPR Art. 35.)*
2. **Necessity & proportionality** — data minimization (field→feature map), purpose limitation, explicit granular consent, storage limits.
3. **Risks to data subjects** — sensitive health inference; re-identification of pseudonymous data; unauthorized access/breach; secondary use / ad-targeting; minors' exposure; cross-border exposure; reproductive-data risk (post-Dobbs-style / regional criminalization concerns).
4. **Mitigations** — no health data to SDKs; RLS + least privilege; encryption; anonymous mode + local-first option; consent gating; deletion/export; DPAs; region hosting; retention limits; teen safeguards; breach runbook (72h).
5. **Residual risk & sign-off** — DPO + Khaled sign-off; review cadence. **→ COUNSEL/DPO to run the formal DPIA.**
6. Store at `docs/compliance/DPIA.md`; update before each new data category (CI checklist item).

## 5b. Disclosures — third parties who are **not** processors

`PROCESSOR_REGISTER.md` governs processors: Supabase, Vercel, PostHog, Sentry. Each acts only on
Femio's documented instructions, under a DPA, and can be made to delete. **A disclosure recipient
is none of those things.** There is no contract, no instruction, and no mechanism to make him
forget a cycle date once he has read it. Filing such a recipient in the processor register would
be the register's first inaccuracy, so this section exists as their home.

**One entry today.**

| Recipient | What may be disclosed | Lawful basis | Controls | Retention |
|---|---|---|---|---|
| **A person the user names and invites** (partner sharing, Phase 4.5) | Only the categories she ticks, from a closed list of seven: next-period window, recent period dates, cycle phase, pregnancy week, symptom names and dates, medicine names, charting dates. **Never** screener results, anything from the crisis surface, or free-text appointment questions — those have no id in the schema and are rejected by a CHECK constraint. | **Art. 9(2)(a)** explicit consent. Recorded in `partner_links` with its own `version` string, deliberately distinct from `CONSENT_VERSION`, so partner grants can be invalidated without touching analytics grants. | Per-category opt-in, nothing on by default, **no "share everything" control**. Recipient named by her at the moment of consent (migration 0012). Account-based, never a forwardable link. Not offered under 18, and an unknown age counts as under 18. | Six months from redemption unless she renews; fourteen days for an unredeemed invite. Revocation is immediate, one tap, and **silent**. |

**Three properties that are compliance measures rather than features**, all verified by
`scripts/dev/partner-sharing-check.mjs` against the live project:

1. **A withheld category is absent from the payload, not empty.** The recipient's view is
   byte-identical to one in which Femio has no such feature. Granular sharing that displays its own
   gaps produces a map of what she chose to conceal, which is more dangerous than sharing
   everything — see `DPIA.md` §3, coercion.
2. **Revocation is not observable.** A revoked share, an expired one and one that never existed all
   return the same response. Art. 7(3) requires withdrawal to be as easy as granting; the
   requirement above that floor is that she can withdraw without being seen to.
3. **The recipient can read no row.** He reaches everything through a curated function; the RLS
   policy that would have shown him the scope was removed in migration 0011 (ADR-068).

**What Femio cannot control, stated plainly:** once a recipient has seen a screen, he has seen it.
Revocation stops future access; it cannot reach a screenshot, a memory or a photograph. This is
disclosed in the consent copy rather than implied, and it is the reason the never-shareable class
exists at all.

**Adding a second recipient type requires a new row here, a DPIA update, and the review gate in
§9.** Nothing may be disclosed to a non-processor that is not described in this table.


## 6. Cookie & consent plan
- **Essential-only by default**; **no non-essential cookies/SDKs fire before consent** (CMP gate).
- **Granular, revocable** consent recorded per purpose (essential / analytics / research) — mirrors the privacy-policy split; consent log stored.
- Analytics = **PostHog EU**, pseudonymous, **health-field-free** event schema (documented); no cross-site tracking.
- Ads (freemium): **contextual only** (page topic), never targeted on logged symptoms/cycle/pregnancy status; affiliate disclosed inline.
- Cookie policy page lists every cookie/SDK, purpose, duration; SDK allowlist reviewed quarterly.

## 7. Medical-device scope guardrail (existential — engineering + copy)
Intended purpose stays **wellness / education / tracking**. Any feature/copy using *diagnose / detect / prevent / treat / contraception* is flagged and rewritten. Fertile-window = conception **awareness**, explicitly **not** birth control (that is Natural Cycles' regulated SaMD lane). Screeners (EPDS, PHQ-9, DRSP, MRS…) = "screening/awareness — discuss with your clinician." AI features (later): educational, citation-only, no personalized medical advice; boundary logged in system prompts + UX.

## 8. Data map (maintained per-field) — `docs/compliance/DATA_MAP.md`
Columns: **field → purpose → lawful basis → special-category? → retention → processors → region → consent group**. Rule: **every new field is added to the data map in the same PR that introduces it** (CI checklist item); labels must exactly match Play Data-Safety / Apple nutrition labels at store submission.

## 9. Feature review gate (every PR touching data or claims)
Filled block, reviewer blocks merge if incomplete: *fields added? consent needed & which group? data map updated? claims language checked (no diagnose/treat/prevent/contraception)? third parties/SDKs involved? retention set? minors impact?* (From `femio-compliance-privacy`.)

## 10. Open items → next
- **→ COUNSEL:** entity + DPO + EU/local representatives + registrations (§1); finalize Privacy Policy, ToS, DPIA; per-jurisdiction minor-consent ages + verifiable parental consent; international-transfer mechanism; liability/governing-law; app-store legal (Phase 4).
- Create `docs/compliance/DATA_MAP.md`, `DPIA.md`, `PROCESSOR_REGISTER.md`, `BREACH_RUNBOOK.md` skeletons (engineering, alongside P1.3 schema).
- Publish plain-language public privacy page as part of P1 (trust surface).
