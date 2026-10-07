# Private launch (v1): health records on the device, not with Femio

Written 2026-10-07 at the owner's request: *"launch without falling under the data
protection licensing, by not holding data ourselves in the first versions, and change that
later."* This file is the honest assessment of that idea. It is **not legal advice**. It
narrows what a lawyer must answer from a whole compliance build to the questions in §6.
Status: **proposed as D7** in `docs/runbooks/OWNER_ACTIONS.md`, awaiting the owner's yes.

## 1 · The short answer

- **A disclaimer, waiver or "by using Femio you agree…" removes none of these duties.**
  Statutory data-protection duties cannot be signed away, and consent is a lawful basis,
  not an exemption from licensing. Disclaimers still matter for the *medical* side
  ("wellness, not diagnosis, not contraception"), which Femio already has.
- **Not holding the data does work, and it is the strongest lever there is.** If
  cycle, fertility, pregnancy and symptom records live only on her phone and Femio cannot
  receive or read them, the heaviest obligations attach to nothing: the sensitive-data
  licence (Egypt), cross-border transfer licences and safeguards (Egypt, Saudi), SCCs and
  transfer risk assessments (Saudi), and most of the breach and DPIA exposure. This is
  privacy by design, the thing every one of these laws asks for, not a loophole.
- **It does not make Femio invisible to the law.** Femio stays a controller of whatever
  it still touches: website server logs (IP addresses), error reports, analytics, support
  email, store purchase records. Ordinary personal data, not health data, but still
  personal data. §3 shows how to shrink that to almost nothing.

## 2 · Corrections to the ChatGPT drafts before anything is reused

The drafts the owner pasted are a reasonable outline but describe a different product:

- **Femio does not use Firebase/Firestore/Google Cloud.** It uses Supabase (Postgres +
  auth), Vercel (hosting), Sentry (errors), PostHog EU (analytics, consent-gated).
- **The database is in Ireland, not Frankfurt.** Supabase project region `eu-west-1`
  (verified via the connector 2026-10-07). Every "Frankfurt" sentence would be false.
- **The drafts assume cloud sync of health data.** Under this proposal v1 has none, so
  most of the privacy policy's transfer, retention and breach sections change meaning.
- **Egypt: a licence is required even with no health data.** The 2025 Executive
  Regulations (Art. 2, as summarised by several firms) require a controller licence for
  *any* entity collecting personal data, and a foreign entity targeting Egypt needs an
  accredited local representative. Holding 1–100,000 records waives the **fee**, not the
  licence. So local-first removes the *sensitive-data* and *cross-border* licences but may
  leave a basic controller licence, unless Femio collects literally no personal data from
  Egyptian users (§3 makes that close to true). Where Femio's operating entity is
  registered changes this a lot: an Egyptian entity needs no "foreign representative".

## 3 · What v1 would look like ("Private mode")

| Area | v1 (launch) | Later, once compliance is in place |
|---|---|---|
| Health records (cycles, symptoms, TTC, pregnancy, meds, notes) | **On the device only** (IndexedDB in the PWA/TWA; SQLite in Flutter). Never sent to Femio. | Optional account + end-to-end-encrypted sync |
| Predictions, patterns, screeners, persona rules | **Run on the device.** Rules are still authored once as versioned data with golden fixtures (ADR-060/061 tier 2) and ship in the build; no screen hard-codes them | Same rules, also server-side where sync needs them |
| Accounts / sign-in | **None.** Onboarding creates a local profile | Email or Google sign-in for sync |
| Backup | **A file she saves herself** ("Save a backup" → Files / Drive / email, her choice), plus import | Encrypted cloud backup |
| Partner sharing | **Off**, or a summary she sends herself (PDF/image). No Femio server in the loop | Server-mediated sharing (`PARTNER_SHARING_DESIGN.md`) |
| Doctor-visit summary | **Generated on the phone**, printed or shared by her | unchanged |
| Reminders | Local notifications only (TWA/Flutter); none on plain web | Push |
| Analytics | **Cookieless page counts only** (Vercel Web Analytics), no events about health, no identifiers. PostHog off | Consent-gated product analytics, never health values |
| Errors | Sentry with **IP storage off**, no user content, no replay (already scrubbed) | unchanged |
| Articles, calculators, search | Static, already shipped with the site (P2.1, P2.2) | unchanged |
| Age | **Tracker 18+ at launch**; all articles stay open to everyone (rule 2). Play target audience 18+ (avoids Play's Families policy) | Teen mode with guardian flows per country |
| Supabase | **Not used by the app** (dormant; no egress, no 402 risk) | Sync backend |

### What it costs the product

- **Losing the phone loses the record** unless she saved a backup. This works against
  rule 5 ("one record spans life"). Mitigations: a backup nudge after the first month of
  logging, and `navigator.storage.persist()`. Then honesty in the UI: "Your records live on
  this phone. Save a backup."
- **iPhone Safari deletes a website's stored data after 7 days of Safari use without a
  visit** (WebKit ITP). Home-screen web apps keep their own counter and in practice keep
  their data. So on iOS, v1 must ask her to *Add to Home Screen* before she logs, until the
  Flutter iOS app exists. Android (Chrome PWA and the Play TWA) does not have this cap.
- **No phone-to-laptop continuity** in v1. On Android the Play app (TWA) and Chrome share
  storage for femioapp.com, so web and app on the same phone are one record.
- **Engineering:** 58 files call Supabase directly today. Phase 3 rebuilds the wedge app
  anyway; it would be rebuilt over a `Store` interface with a local implementation now and
  a sync implementation later, so this is a change of target, not extra work on top.

## 4 · What still applies to Femio in v1 (small, but real)

- A **privacy policy** (Google Play requires one for every app, and for health apps) that
  says precisely what does and does not leave the phone. The Play **Data safety** form can
  then truthfully say health data is *not collected*; crash diagnostics are declared.
- The Play **Health apps declaration**.
- **Cookies:** only strictly necessary ones (locale, theme), so no consent banner is
  needed under the UK's PECR or the EU ePrivacy rules.
- **Medical-device scope:** unchanged. Femio stays wellness/education (rule 1); local
  storage neither helps nor hurts this.
- **Consumer and product-liability law:** unchanged. Terms with honest disclaimers (not
  diagnosis, not contraception, emergencies → local services) still matter here.
- **Egypt:** possibly a fee-free basic controller licence + local representative for the
  residual data (§2). One narrow question for counsel (§6).

## 5 · Market by market (v1)

- **Saudi Arabia.** The PDPL reaches foreign controllers of residents' data, but with no
  health data received there is no sensitive-data processing by Femio and no transfer of it
  abroad. Residual data (logs, crash reports) is ordinary data. The transfer regulation's SCC
  and risk-assessment duties fall away for health data. Best fit of the three.
- **Egypt.** Largest residual question (§2): the regulations' licence requirement for any
  collection, and scope over Egyptian citizens anywhere. Local-first moves Femio from the
  hardest category (sensitive data + cross-border) to the easiest. Enforcement is reported
  to start with large data holders. Still worth one written answer from counsel.
- **UK** (new: the owner asked; it was web-only in D4). UK GDPR covers a foreign service
  targeting UK users, but where an app's code runs solely on the device and sends nothing
  to the developer, ICO guidance has said the developer is unlikely to be a controller of
  that data. The UK representative duty would then attach only to the residual ordinary
  data. A low-risk, occasional-processing exemption may apply. Reasonable to include.

## 6 · The questions for counsel (one short engagement, not a compliance programme)

1. **Egypt.** "Health records are created and stored only on the user's device; Femio
   cannot receive or access them. Femio's servers receive only server logs and anonymous
   crash reports. Does Femio need a controller licence and a local representative, and is
   any sensitive-data or cross-border licence required?" Also: does the answer change if
   the operating entity is Egyptian?
2. **Saudi.** Same facts: is registration as an external entity or a DPO required for the
   residual data alone?
3. **UK.** Same facts: is a UK representative required (Art. 27 exemption)?
4. Review the v1 privacy policy and terms (to be drafted from this file, in §3's terms).

## 7 · The upgrade path ("change it later")

The data map is written so that adding cloud features later is a deliberate step with
its own gate: v1.x adds end-to-end-encrypted sync **only after** §6's answers and the
licences/registrations they call for are in place. Encryption alone does not take synced
data out of the law (pseudonymised data is still personal data), so sync is when
the full compliance package from the ChatGPT drafts becomes necessary, and not before.

## Sources

- Egypt Executive Regulations summaries: [Chambers](https://chambers.com/articles/a-first-look-at-egypt-s-personal-data-protection-executive-regulations),
  [Al Tamimi](https://www.tamimi.com/our-knowledge/publications/general/Articles/from-policy-to-practice-egypt-issues-executive-regulations-of-the-personal-data-protection-law/),
  [Eldib](https://eldib.com/egypts-pdpl-executive-regulations-beyond-customers-beyond-tech-companies/),
  [Baker McKenzie](https://connectontech.bakermckenzie.com/egypt-important-data-protection-update/),
  [DLA Piper](https://www.dlapiperdataprotection.com/?t=law&c=EG). Official Arabic text not retrieved.
- On-device processing and controller status: [Ashfords on ICO app guidance](https://www.ashfords.co.uk/insights/articles/information-commissioners-office-highlights-the-importance-of-privacy-in-the-design-and-development-of-mobile-applications),
  [Chino.io (counter-view)](https://www.chino.io/post/do-we-avoid-gdpr), [WIPO app guide](https://wipo.int/ip-development/en/agenda/docs/wipo-guide-data-protection-mobile-apps.pdf).
- Safari storage cap: [Search Engine Land](https://searchengineland.com/what-safaris-7-day-cap-on-script-writeable-storage-means-for-pwa-developers-332519),
  [WebKit bug 237350](https://bugs.webkit.org/show_bug.cgi?id=237350).
