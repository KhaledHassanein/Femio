# Femio — Data Protection Impact Assessment (skeleton)

Status: **SKELETON for DPO to run formally** · Last updated **2026-08-23** (partner sharing) · Owner: DPO + Khaled · Ties to `docs/13` §5
A DPIA is mandatory here: systematic, large-scale processing of special-category health
data, including minors, with profiling (GDPR Art. 35). Update **before each new data
category** (CI checklist item). This skeleton is engineering input, not the formal DPIA.

## 1. Description of processing
- **What:** cycle/symptom/mood/vitals/labs/fertility/pregnancy/screener data + derived
  persona state; education delivery; uncertainty-honest predictions.
- **Whom:** women/girls across life stages, incl. minors (teen mode).
- **How:** web PWA → Supabase (Postgres + RLS, EU); server-side resolver/predictions;
  pseudonymous product analytics (health-field-free).
- **Disclosure to a third party (partner sharing, scope approved 2026-08-23).** A user may
  disclose selected categories of her own record to **one named recipient** — typically a partner.
  This is a **disclosure, not processing**: the recipient acts for himself, is bound by no DPA, and
  cannot be made to forget what he has seen. Basis: **Art. 9(2)(a) explicit consent**, captured
  per category, revocable per category, with its own consent `version` distinct from the
  analytics/research ledger. Design and approved scope: `PARTNER_SHARING_DESIGN.md`.
- **Scale:** consumer scale, multi-jurisdiction (EU, Gulf PDPL, Egypt 151/2020).
- Data map: `DATA_MAP.md`. Processors: `PROCESSOR_REGISTER.md`.

## 2. Necessity & proportionality
- Data minimization: field→feature mapping (data map); prefer `age_band` over DOB; collect
  nothing no active feature needs.
- Purpose limitation + **granular explicit consent** (core / insights / research), captured
  **before the first health field is stored** and enforced at the DB (consent gate, 0002).
- Storage limits + export/delete (cascade). Anonymous mode (native anon auth) for identity-free use.

## 3. Risks to data subjects
- Sensitive health inference; re-identification of pseudonymous data; unauthorized access/breach;
  secondary use / ad-targeting; minors' exposure; cross-border exposure; **reproductive-data risk**
  (regional criminalization / disclosure concerns).
- **Coercion (new, 2026-08-23 — introduced by partner sharing).** The risk is not that data leaks;
  it is that a person with influence over her *obtains* it with her nominal consent. Three specific
  harms, each with a design consequence in §4:
  - **Consent that is not freely given.** A partner present when she is asked can make a "yes"
    meaningless. GDPR recital 43: consent is not freely given where there is a clear imbalance.
  - **Revocation she does not feel safe making.** If withdrawing access is observable, the option
    exists on paper and not in practice.
  - **Concealment becoming evidence.** If a withheld category is *shown as withheld*, granular
    sharing hands him a list of what she chose to hide — a worse outcome than sharing everything.
  This risk sits alongside the reproductive-data risk above and is **not** covered by it: that one
  concerns states and institutions, this one concerns her household.

## 4. Mitigations (state — verify at review)
- [x] No health data to analytics/ad SDKs (health-field-free event schema) — enforced by policy + review gate.
- [x] **Crisis-safety routing collects nothing** (ADR-013): the global "Need help now?" interface and `/help-now` page take no reason/score/country/health-data input, carry **no analytics** (opening it could reveal mental-health intent), and store/transmit nothing; the single outbound directory link is env-gated to a canonical host with `referrerPolicy="no-referrer"`. **Global-only posture (no country phone packs) awaits DPO + medical sign-off** — see §5.
- [x] Owner-only RLS on every health table; consent-gated inserts (0002).
- [x] Anonymous mode; export/delete pipelines planned (P1.16); EU region.
- [x] **Partner sharing is per-category and opt-in**, with nothing shared by default and **no
      one-tap "share everything"** — the single toggle is what a coercive partner asks for, and its
      convenience is worth less than the friction it removes from that conversation.
- [x] **Three categories are never offered**, not even unticked: screener results (PHQ-9/GAD-7/
      EPDS), anything from the crisis surface, and free-text appointment questions. A checkbox she
      can be pressured into ticking is worse than no checkbox; the absence of the option lets her
      say truthfully that Femio does not offer it.
- [x] **Revocation is silent.** One tap, and the recipient is never notified — no email, no state
      he can observe. Art. 7(3) requires withdrawal to be as easy as granting; the coercion risk
      requires it to be undetectable.
- [x] **A withheld category is invisible, not marked withheld.** The recipient's view renders as
      though the feature did not exist, so concealment cannot be read off the screen.
- [x] **Minors excluded, and unknown age counts as a minor** (`isMinor(null) === true`), matching
      the analytics/research gate (R3.0.8).
- [x] **Account-based, never a shareable link**, since a forwarded link cannot be revoked; grants
      are **time-boxed** (6 months) so consent is renewed rather than inherited indefinitely.
- [ ] Encryption at rest/in transit — confirm Supabase config + document.
- [ ] Teen safeguards (no ads/DMs/UGC; parental consent flow) — P1.12 / counsel.
- [ ] Breach runbook operational (`BREACH_RUNBOOK.md`) — 72h.
- [ ] Retention windows set per field.

## 5. Residual risk & sign-off
- Residual risk assessment: **TBD by DPO.**
- Sign-off: DPO ______  Khaled ______  Date ______  Review cadence: ______

## 6. Open → DPO/counsel
Run the formal DPIA; decide reproductive-data risk posture per jurisdiction; confirm minors'
handling and DPIA consultation triggers.

**Added 2026-08-23, for the DPO when one is appointed** — none of these blocks building partner
sharing, and all of them block *launching* it:
1. **Art. 9(2)(a) wording.** This is Femio's first disclosure of special-category data to a
   non-processor. The consent text must name the recipient and the categories at the moment of
   consent; generic "allow sharing" language would not be explicit consent.
2. **`docs/13` §5 needs a disclosures section.** `PROCESSOR_REGISTER.md` governs processors bound
   by a DPA. A partner is neither, and filing him there would be the register's first inaccuracy.
3. **Coercion posture.** The mitigations in §4 are engineering's answer. Whether they are
   *sufficient* — or whether the feature should ship at all in some jurisdictions — is a DPO call.
4. **Retention after revocation.** What happens to the recipient's account and any cached view once
   she revokes. Femio can delete its side; it cannot reach a screenshot.
