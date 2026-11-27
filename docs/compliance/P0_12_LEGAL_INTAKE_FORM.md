# P0.12 — Legal & privacy intake form

**Fill this in and hand it back.** Everything here is information only you or your lawyer can
supply — company facts, contact points, and decisions. None of it can be researched, guessed
or generated, and inventing any of it would be worse than leaving it blank.

Once it comes back I can finish P0.12.4 in one pass: replace the draft text in
`/privacy` and `/terms`, remove the "Draft — not yet in force" banner, drop the `noindex`,
add both pages to the sitemap, and build the `/contact` page (P1.9b.3c) that doc 15 §8 needs
for the E-E-A-T trust set.

**What this unblocks:** real users. Not SEO — the content side is already live. Femio cannot
lawfully process a real person's health data under GDPR without a named controller, a lawful
basis, and a working way to exercise rights. That is the only thing standing between the
current state and a public launch.

**Rough effort:** §1–§4 are facts you already know (~20 minutes). §5–§7 are the ones worth a
lawyer's eye. §8 you can skip if you have no staff or processors beyond those listed.

---

## 1. The legal entity (the "data controller")

| Field | Answer |
|---|---|
| Registered company name | |
| Trading name, if different | |
| Company registration number | |
| Country/state of incorporation | |
| Registered address (full) | |
| VAT / tax number, if applicable | |

> If no company exists yet and you are operating personally, say so — it changes who the
> controller is and what has to be published, and it is better to state it than to imply a
> company that does not exist.

---

## 2. Contact points that must be publishable

These appear on the public site. They can be role addresses (`privacy@…`) rather than
personal ones, and role addresses are the better choice.

| Field | Answer |
|---|---|
| General contact email | |
| Privacy / data-protection email | |
| Security disclosure email | |
| Postal address for legal notices | |
| Phone (optional — Femio publishes no numbers in health content, but a company contact number is different) | |

---

## 3. Data-protection roles

| Question | Answer |
|---|---|
| Have you appointed a **Data Protection Officer**? (Likely required: you process special-category health data at scale.) | Yes / No / Unsure |
| If yes — DPO name and contact | |
| Do you have an **EU representative**? (Required under GDPR Art. 27 if the controller is established outside the EU.) | Yes / No / Unsure |
| If yes — name and address | |
| Do you have a **UK representative**? (Same idea, if you target UK users.) | Yes / No / Unsure |

> If "Unsure" on the DPO: the test is whether core activities involve large-scale processing
> of special-category data. A cycle-tracking app arguably meets that. Worth one question to a
> lawyer rather than a guess from me.

---

## 4. Jurisdiction and governing law

| Question | Answer |
|---|---|
| Governing law for the Terms (e.g. "the laws of England and Wales") | |
| Courts with exclusive jurisdiction | |
| Countries you are **launching in first** | |
| Any country you want to **block** at launch | |

---

## 5. Age and consent thresholds

Femio is used by teenagers, which makes this consequential rather than boilerplate.

| Question | Answer |
|---|---|
| Minimum age to use Femio at all | |
| Minimum age to use it **without** parental consent | |
| Do you want a distinct teen mode at launch, or defer? | |
| Will you knowingly serve users under 16 in the EU? (GDPR Art. 8 sets 13–16 by member state; the strictest is 16.) | |

---

## 6. Decisions your lawyer should confirm

Short answers are fine; I need the decision, not the reasoning.

| Question | Answer |
|---|---|
| Lawful basis for processing health data — **explicit consent** (Art. 9(2)(a)) is what the current build implements. Confirm? | |
| Data-retention period after account deletion (currently: immediate delete; some jurisdictions require a short grace period) | |
| Retention for backups (how long can a deleted record survive in backup?) | |
| Will you offer the service to users in the **United States**? (Changes the disclosures materially — state privacy laws, and possibly HIPAA-adjacent framing.) | |
| Liability cap and warranty wording — lawyer's text, or shall I keep the plain-language draft and let them edit? | |

---

## 7. Anything already drafted

| Question | Answer |
|---|---|
| Do you already have a privacy policy or terms from a lawyer? (If so, send them — I will not rewrite them, I will wire them in.) | |
| Any insurance or professional-indemnity wording that must appear? | |
| Any investor/partner requirement affecting the policies? | |

---

## 8. Processors — for the record

These are the third parties that touch data today. I have filled in what the code shows;
confirm or correct, and add any I have missed (accountant, support tool, email provider).

| Processor | Purpose | Data | Status |
|---|---|---|---|
| Supabase (EU) | Database, auth, storage | All user data incl. health | DPA needed — confirm signed |
| Vercel | Hosting, edge | Request metadata, IPs | DPA needed — confirm signed |
| PostHog (EU) | Product analytics, consent-gated | No health data; URL stripped | **DPA outstanding**, plus "Discard client IP data" toggle |
| Sentry (EU) | Error monitoring | Route patterns only; no bodies, no user | Confirm DPA |
| ThroughLine | Crisis-resource directory links | None — outbound links only | Confirmation email drafted at `docs/compliance/THROUGHLINE_LINK_CONFIRMATION.md` |

---

## What happens after you return this

1. I replace the draft privacy and terms text with the real thing, remove the draft banner,
   un-`noindex` both, and add them to the sitemap (**P0.12.4**).
2. I build `/contact` with the published contact points (**P1.9b.3c**).
3. I update the data map in `docs/archive/2026-11/13_LEGAL_COMPLIANCE.md` and the processor register to match
   your answers in §8.
4. Anything you mark "lawyer to confirm" stays visibly marked as draft until they do —
   a policy that looks final and is not is worse than one that admits it.
