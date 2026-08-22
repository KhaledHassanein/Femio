# Partner sharing — the consent design (recommendation)

Status: **scope APPROVED by owner 2026-08-23** · DPIA updated the same day · Owner: Khaled + DPO · For `docs/27` phase 4.5
Ties to `docs/13` §5–6, `DPIA.md`, `PROCESSOR_REGISTER.md`, product rules 1, 2 and 4

The owner's instinct — *"the main user has the right to give full access or restricted, like
checkpoints of what to share and what not"* — is right, and it is already the house pattern.
`consent_records` is an append/revoke ledger of independently grantable purposes; partner sharing
should be the same shape rather than a second mechanism beside it.

But granular scope on its own is **not** what makes this compliant, and three of the five additions
below matter more than the checkboxes do.

---

## 1. A partner is a *recipient*, not a processor — and that changes the legal bar

`PROCESSOR_REGISTER.md` governs processors: Supabase, PostHog, Sentry. Each acts on Femio's
instructions under a DPA. **A partner does none of that.** He is a third party receiving a
*disclosure*, and there is no contract to bind him — once he has seen a cycle date, Femio has no
mechanism to make him forget it.

Consequences that follow, not opinions:

- The lawful basis is **Art. 9(2)(a) explicit consent**, a higher bar than the Art. 6 consent that
  covers analytics. "Explicit" means the specific data and the specific recipient are named at the
  moment of consent — not "allow sharing" in a settings list.
- It needs its **own `version` string** in the ledger, distinct from `CONSENT_VERSION`, because the
  thing consented to is materially different and a future policy change must be able to invalidate
  partner grants without touching analytics grants.
- The register gains a **row that is not a processor row** — a "disclosures" section, or an explicit
  note that partner sharing is disclosure rather than processing. Filing him among processors would
  be the register's first inaccuracy.

## 2. Revocation must be instant, one tap, and **silent**

Art. 7(3) requires withdrawal to be as easy as granting. That is the floor.

The requirement above the floor is that **the partner is not notified when she revokes**. No email,
no "access removed" screen, no state change he can observe. A revocation he can detect is a
revocation she may not feel safe making, and the population this feature serves includes women whose
partner is the reason they would want to revoke.

His view should simply stop returning data, in the same way it would if she had never shared.

## 3. Hiding a category must be invisible — this is the design point that matters most

If she shares cycle dates but not symptoms, the partner's view must not say *"Symptoms: hidden"*, or
show an empty section, or render a locked row. **He must see a view in which that category does not
exist**, identical to what he would see if Femio had no symptom feature at all.

Otherwise granular sharing produces a **map of what she chose to conceal**, which is more dangerous
than sharing everything: it turns each hidden category into a question she now has to answer.

This is the single most common failure in comparable products, and it is invisible in a screenshot —
which is why it belongs in the design decision rather than in review.

## 4. Some categories are never offered — the absence of a checkbox is the protection

**Recommended never shareable, not even as an unticked option:**

- **Screener results.** PHQ-9, GAD-7, EPDS. Mental-health scores are the highest-harm disclosure in
  the product and the most weaponisable in a custody or immigration dispute.
- **Anything from the crisis surface.** `help-now` collects nothing by design (P1.26); nothing from
  that flow should become shareable later either.
- **Free-text appointment questions** (`prep_json`). She writes these for a clinician. They are the
  most candid text in the record.

The reasoning is the part worth keeping: **a checkbox she can be pressured into ticking is worse
than no checkbox.** Granularity gives her control in the ordinary case and gives a coercive partner
a checklist in the bad one. For the highest-harm categories, removing the option removes the
argument — she can say truthfully that Femio does not offer it.

This is the same logic as product rule 2 read in reverse. Rule 2 forbids *restricting her* access to
her own record; it says nothing about restricting what a third party may be given.

## 5. Not available to minors, and unknown age counts as a minor

`isMinor(null)` is `true` (`lib/persona/minor.ts:43`). Partner sharing must inherit that gate
exactly as analytics and research do (R3.0.8), and for a stronger reason: Art. 8 verifiable parental
consent has no bearing on a 15-year-old disclosing her cycle to a boyfriend.

If she has skipped the age question, the R3.0.8 pattern applies — explain, offer to answer, and
refuse until she does.

---

## Recommended shape

**Scope: per-category, opt-in, nothing on by default.** Reusing the `consent_records` reduction
pattern, with a `partner_shares` table carrying the scope flags and the recipient.

| Category | Shareable | Note |
|---|---|---|
| Next-period window | ✅ | the common case, and the least sensitive |
| Cycle dates and length | ✅ | |
| Phase / "where she is" | ✅ | |
| Symptoms | ✅ | off by default |
| Medications | ✅ | off by default |
| Pregnancy week / due date | ✅ | |
| Fertility charting (BBT/LH/CM) | ✅ | off by default; TTC is the main use case |
| **Screener results** | ❌ never | §4 |
| **Crisis / help-now** | ❌ never | §4 |
| **Appointment questions** | ❌ never | §4 |

**Against a "share everything" shortcut.** The owner asked about full vs restricted; the
recommendation is **restricted-only, with no one-tap "full" option**. A single toggle is the thing a
coercive partner asks for, and its convenience is worth less than the friction it removes from that
conversation. Ticking six boxes is a small cost to her and a real obstacle to him.

**Time-boxed.** Grants expire after a stated period (suggest 6 months) unless renewed. Consent that
never expires stops being informed; a renewal prompt is also a natural, unsuspicious moment to
reconsider.

**Visible at all times.** A "what he can see right now" panel in Settings, listing exactly the
categories currently shared — never buried behind a link, and worded as the partner's view rather
than as her settings.

**Account-based, not link-based.** A shared link cannot be revoked from her side once forwarded. A
named recipient with an account can be cut off, and revocation is meaningless without that.

---

## Status of the gates

1. ✅ **Scope approved** by the owner, 2026-08-23 — including the three "never" rows and
   restricted-only with no one-tap "share everything".
2. ✅ **DPIA updated** the same day: partner sharing added to §1 as a *disclosure*, **coercion**
   added to §3 as a new risk class with its three named harms, and six mitigations recorded in §4.
3. ⏸ **`docs/13` §5 disclosures section** — needed before launch, not before code.
4. ⏸ **DPO sign-off** on the Art. 9(2)(a) consent wording — needed before launch. Femio has no DPO
   appointed yet (`DPIA.md` §5 is unsigned), which is a P0.12 dependency rather than a blocker on
   building.

**Building may now proceed.** What may not proceed without 3 and 4 is *launching* it to real users —
the same line `docs/13` already draws for every other processing activity.
