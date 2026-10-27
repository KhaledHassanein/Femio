# Femio public website audit — 9 October 2026

**Source-parity confirmation:** the owner confirmed the local checkout is not synced. Read-only GitHub access later confirmed local HEAD `0ee7dffe…` differs from GitHub main `88f5aeda…` (8 October). Local-source appendix findings remain unverified against current source; neither repository tip was established as the deployed web commit. No application code was pulled or changed.

**Target:** https://femioapp.com. **Owner-confirmed scope:** current public website first. **Outcome:** worthwhile English education library, but significant correctness, Arabic navigation, provenance and product-promise failures prevent a credible claim of category leadership.

This is an audit, not a release certification. No application code, existing documentation, accounts, health records or external communications were changed. Results are confined to this folder. Three focused subagents assessed persona scenarios and researched primary competitor sources; their local-source observations are separated in `LOCAL-SOURCE-APPENDIX.md`.

## 1. What was actually tested

The live site currently offers education and seven public calculators. Its app page advertises Android as coming soon, iPhone later, no accounts and on-device health records. This differs from the account-based application at local checkout `E:\Femio`, HEAD `0ee7dff` (6 October 2026). Source inspection therefore cannot prove deployed behavior.

Live Chrome checks covered:

- Every one of the **99 health guides linked from the English library**: navigation, title, visible review label/date, named reviewer links, external source links, headings and internal links. All 99 opened. This was a structural/provenance sweep, not clinician validation of every sentence.
- All **five condition pages**: navigation, attribution, sources, urgent-care framing and links.
- All **seven calculators**, including ordinary inputs and selected invalid, sparse-history, long-cycle, reversed-range, future-date and unit-switch scenarios.
- Homepage, app landing, library, search, conditions, About, Privacy, Terms, Editorial policy, Medical review, Authors, reviewer bio, FAQ, glossary, help page, crisis dialog, robots and sitemap.
- English and Arabic phone layout at a verified **390 × 844** viewport; desktop content at approximately **1536 × 639**. French and Spanish homepage/library navigation and content fallback were sampled. Light and dark themes were sampled.
- Representative clinical-content reading: irregular-cycle TTC, pregnancy warning signs, week 28, feeding difficulties, postmenopausal bleeding and teen content pathways. Selected statements were compared with primary guidance.
- Focused search tasks: miscarriage, IVF, PCOS, endometriosis, HRT, hot flashes, no period and breastfeeding. Results were read after they settled; an initial rapid query batch was discarded because it observed stale debounced results.

**Not tested or certified:** the unavailable mobile product; signed-in tracker; all 73 individual persona implementations; backend access control; deployed build identity; actual network/analytics payloads; cookie/storage lifecycle; offline fault injection; screen reader speech; every browser/device; 200–400% browser zoom; Lighthouse/Core Web Vitals; security headers; load or penetration testing; exhaustive external-link checking; full medical or legal compliance. A requested 320px override did not produce a verified 320px viewport, so no 320px pass is claimed.

Native date-entry automation initially changed the visible field without updating application results. Calculator findings below were reproduced using the native accessible date-field setter and settled results. Browser extensions injected unrelated DOM elements; those were excluded from findings. Some Arabic screenshots had capture-scaling artifacts; layout conclusions use measured DOM geometry and actual navigation, not those artifacts.

Evidence levels: **L** = observed live; **M** = measured live DOM; **R** = primary-source comparison; **S** = local source only. P1 = high-impact correctness, safety access or trust problem; P2 = meaningful usability/capability gap; P3 = polish. These priorities are audit judgments, not proof of injury or legal violations.

## 2. Executive assessment

Femio currently has breadth of reading material, but breadth is being mistaken for depth of product service. A visitor can read good material on many stages; she cannot presently use the public site to maintain a health history, understand longitudinal patterns, prepare an automatically generated visit report, or move between stages. Those are future app promises, not tested public capabilities.

The strongest demonstrated assets are free access, calm answer-first English content, visible source links, useful mother-focused postpartum topics, clear non-contraceptive framing in the ovulation calculator, and simple phone-sized forms. The strongest weaknesses are arithmetic that silently replaces entered data, broken Arabic links, English-only health content behind multilingual navigation, inconsistent privacy architecture, and incomplete reviewer attribution.

Do not add features ahead of fixing those foundations. A richer product needs more completed jobs per persona, clearer evidence, and stronger continuity—not more screens or more claims.

## 3. Highest-priority findings and reproduction

### F01 — Arabic navigation produces 404s (P1, L/M)

Open `https://femioapp.com/ar`, then choose **تعلَّمي**. It navigates to `https://femioapp.com/ar/ar-u-nu-latn/learn` and shows the bare framework 404. Direct `https://femioapp.com/ar/learn` opens the library, but its urgent pregnancy link **أي علامات الحمل تستدعي رعاية عاجلة؟** navigates to `https://femioapp.com/ar/ar-u-nu-latn/learn/pregnancy-warning-signs`, again a 404.

The rendered header/library links contain `/ar-u-nu-latn/...`, while canonical URLs and the sitemap use `/ar/...`. This suggests an extended formatting locale is being used as a route locale; the root cause is not confirmed without matching deployed source.

**Impact:** a primary promised market cannot browse normally; safety information is blocked through ordinary navigation. **Fix:** keep formatting locale separate from the supported route language; exercise actual clicks through Arabic header, footer, tools, articles, author and help links. Acceptance: every link stays under the intended `/ar/...` route and reaches the intended content.

### F02 — Several calculators silently cap 90-day input at 45 (P1, L/M)

Period calculator: LMP `2026-10-01`, shortest `24`, longest `90`, duration `5`. Field remains **90**, but first predicted start range is **25 October–15 November 2026**. The upper bound is LMP + 45 days, not + 90. Later ranges also use the substituted 45-day value. DOM says `max=45`, `validity.valid=false`; there is no visible field error and results remain present.

Ovulation calculator: same LMP, average cycle **90**, gives ovulation **1 November**, next period **15 November**, and fertile window **27 October–2 November**: again the 45-day result. Pregnancy-test calculator gives **15 November** for the period-based path. Due-date calculator gives **25 July 2027**, consistent with a 45-day adjustment, while the input still says 90. Arabic period results reproduce the same behavior.

**Impact:** people with irregular cycles, including a PCOS persona, receive output based on different data from what they entered. **Fix:** reject unsupported values visibly or support them with appropriately limited output. Never silently clamp a health input. Clear derived results when an input is invalid; explain the supported population and direct irregular-cycle users to useful guidance. Do not simply expand the number limit and continue promising a precise ovulation day.

### F03 — BMI unit switch changes meaning without converting values (P1, L)

Enter **70 kg / 170 cm**: BMI **24.2**, “Healthy range.” Click **Imperial**: fields become **70 lb / 170 in**, with the same numbers, and output becomes BMI **1.7**, “Underweight.”

**Fix:** convert both measurements while preserving the physical quantity, or clear both fields and state why. Acceptance: toggling units round-trips within display rounding and preserves the result for equivalent measurements. Add plausible-entry validation and explicit adult-tool scope; NHS supplies different calculators for adults and ages 2–17 ([NHS BMI tools](https://www.nhs.uk/health-assessment-tools/calculate-your-body-mass-index/)).

### F04 — One interval is declared regular, even when it is one day (P1, L)

Cycle-length calculator: `2026-08-01` and `2026-08-29` produces average/range **28 days** and “Your cycles look regular.” Only one interval has been measured; there is no variation evidence. Replace the second date with `2026-08-02`: average **1 days**, range **1 days–1 days**, still “Your cycles look regular.” Identical dates instead return “Add at least two period start dates,” without explaining duplicates.

**Fix:** distinguish observations from conclusions. With one interval, state the measured interval and insufficient history to describe variability. Explain that dates must be starts of separate periods, detect duplicate dates, and flag implausible intervals without diagnosing their cause. The current tool can reassure a user entering consecutive bleeding days.

### F05 — Privacy and product architecture contradict each other (P1, L)

Homepage and `/en/app`: no account; records on the phone; Femio never sees entries. About: “one account” for lifelong health. Privacy: email/account/health fields collected, explicit granular consent, EU database, staff access, database row isolation and deletion through server systems. Terms discusses sign-in, account suspension and community posting. Privacy also says Femio is not open to the public, on a public website accepting calculator inputs.

**Fix:** write one accurate present-tense account of the current website and a separately identified future app. Describe calculator-input handling, website technical data, processors, cookies/analytics where applicable, device storage and user-chosen backups. Supply a usable contact route. Draft status is candid; contradictory architecture is not transparency. This audit did not verify actual data flows or determine legal compliance.

### F06 — Most health guides lack the reviewer promised by trust pages (P1, L/M)

Of 99 library guides, **25 contain named reviewer links; 74 do not**. **All 37 weekly pregnancy guides lack them.** They still display “Clinician reviewed” and a review date. All five condition pages do have named author/reviewer links.

The homepage and medical-review policy promise names, credentials and a linked bio on reviewed pages. Postmenopausal-bleeding page is a concrete counterexample; its inspected Article/MedicalWebPage JSON-LD also lacks named author/reviewer attribution.

**Fix:** bind visible reviewer identity, reviewed version and date to every reviewed publication. Require these fields on publication and test the rendered page. Do not remove dates or weaken the promise solely to make counts pass. The single reviewer bio explains role and broad scope but does not independently establish the site's licensing/topic-appropriateness claims; make verification appropriately specific without inventing credentials or affiliation.

### F07 — Arabic-first health information is not delivered (P1, L/M)

Arabic homepage and library headings are translated, but the displayed guide cards are English. At direct Arabic pregnancy-warning URL, the site clearly says the guide is not translated, then presents the safety body in English. This is an honest fallback, not an Arabic health-content service. French and Spanish libraries also show English cards under translated headings.

**Fix:** prioritize medically reviewed Arabic urgent pregnancy, postpartum, newborn, heavy bleeding, teen help, and core calculator explanations. Show language availability on cards before the click; narrow marketing claims until actual reviewed content supports them. Preserve the good `lang=en`/`dir=ltr` markup observed on fallback article content. Do not publish unreviewed machine-translated safety text.

### F08 — A menopause article misstates its cited HRT guidance (P1, L/R; clinician review required)

The postmenopausal-bleeding article says NICE expects unscheduled HRT bleeding to be investigated rather than watched, “particularly in the first months and after any change.” Current NICE NG23 §1.8.4 distinguishes common bleeding during the first six months of systemic HRT and within three months of a dose/preparation change, with prompt medical help for unscheduled bleeding beyond those timeframes. §1.8.5 notes limited evidence and points to BMS guidance ([current NICE recommendations](https://www.nice.org.uk/guidance/ng23/chapter/Recommendations)).

This is a source-fidelity issue, not a recommendation to ignore bleeding. **Fix:** have a clinician reconcile the page with current guidance and make the HRT-specific distinction clearly, while retaining appropriate urgent symptom advice and individual care boundaries. A source link plus an August review date does not by itself prove a statement is current or faithful.

## 4. Further findings: navigation, design and task completion

| ID | Priority / evidence | Finding | Recommended improvement / acceptance |
|---|---|---|---|
| F09 | P2 / L | “Get the app” repeatedly ends on “Coming soon”; no installation is possible through the audited page. | Use a truthful “See the app preview” or availability action until download exists. Prioritize usable calculators/reading on today's homepage. |
| F10 | P2 / L | Menopause homepage card opens the generic library at TTC-led content; it does not select/jump to menopause. | Open a stage collection or verified anchor. One tap should show the requested stage. |
| F11 | P2 / L/M | Library exposes 99 guides in one long surface; pregnancy weeks dominate before later stages. | Add stage/question chips, direct collection pages, jump navigation and clear section-return controls. Keep all knowledge available. |
| F12 | P2 / L | “hot flashes,” “no period,” and “miscarriage” return no results. PCOS, endometriosis, HRT and breastfeeding return useful results. IVF returned one general fertility-help guide. | Add symptom synonyms and intent vocabulary, then dedicated reviewed content where coverage is genuinely absent. Do not confuse a synonym gap with missing content. |
| F13 | P2 / L | FAQ says questions are on the way; glossary says terms are on the way. Both are advertised as useful from the homepage and/or article links. | Populate a useful core or stop routing urgent learning tasks into placeholders. Article FAQs do not make the standalone FAQ functional. |
| F14 | P2 / L/M | `/en/learn/heavy-periods` and `/en/learn/painful-periods` are 404s. Three guides link to them: bleeding after birth, periods after birth and period pain in teens. | Repair to the actual `/conditions/...` destinations and add durable redirects. Validate the actual destination, not just URL syntax. |
| F15 | P2 / L | Future LMP `2027-10-01` creates period predictions; due-date tool creates a 2028 EDD. | Clarify historical versus planning input. For a field labeled “last period,” reject future dates with an inline explanation. |
| F16 | P2 / L | Gestational-age tool silently removes results for a future LMP or an implausibly old pregnancy date. Negative BMI weight likewise produces no explanation. | Give actionable validation, associate errors with fields, and distinguish empty from invalid results. |
| F17 | P2 / L/M | “As of” default was 8 October while Cairo date was 9 October (observed UTC 22:48 on 8 October). | Use the user's local civil date for day-based tools, or clearly explain the chosen timezone. Test midnight boundaries. |
| F18 | P2 / L | Due-date tool offers LMP + average cycle only; week tool offers LMP + as-of. No IVF transfer dating or clinician EDD method is exposed. | Add supported dating methods or clearly state scope and direct users to clinician dates. Flo has a public IVF/FET comparator. |
| F19 | P2 / L | Default 28/28-day period inputs can create a one-date estimate before a user supplies cycle knowledge. No “I don't know / irregular / no periods” path is offered. | Ask rather than silently assume; give useful non-prediction education when data is unknown or inappropriate. |
| F20 | P2 / L | Shortest 40/longest 20 is silently treated as a 20–40 range. | Explain reversed inputs and offer deliberate correction. Do not let users infer their entries were used literally. |
| F21 | P2 / L | Irregular-cycle guide says Femio has no ovulation-day logic, while the public ovulation calculator explicitly displays an estimated ovulation day. | Separate educational calendar estimates from observed ovulation and any future tracker; align all product statements. |
| F22 | P2 / L/M | No visible language switch exists in the tested header/footer despite four-language claims. | Add a language selector that preserves destination, identifies actual content language and uses canonical route codes. |
| F23 | P2 / L | Help page supplies generic emergency advice and an external worldwide directory, without a Saudi/Egypt selection or directly usable local contacts. | Add reviewed, dated region choices and clear emergency versus advice distinctions. Do not infer location or call services automatically. |
| F24 | P2 / L | Loss, IVF protocols, surgical/early menopause and no-period experiences have little or no dedicated public journey in the audited inventory. | Add stage/context collections and practical preparation resources before claiming whole-life superiority. Availability in unpublished source does not count. |
| F25 | P2 / L | Many articles describe what Femio can log, yet the public site has no tracking action and the app is unavailable. | Label these as future app capabilities; offer a printable blank record/question checklist usable now. |
| F26 | P2 / L | Local-only data promise says there is nothing to lose; phone loss, shared-device access, backup exposure and restore limits remain unexplained. | Use precise wording and a readable future-app threat/recovery explanation. Actual mobile security remains unverified. |
| F27 | P2 / L/R | “Most apps cover one chapter” and “other apps give up” oversimplify current competitors. | Compare a specific proven advantage. Ovia, Clue, Flo and Balance now overlap multiple stages and irregular/no-period jobs. |
| F28 | P2 / L | Saudi/Egypt positioning is stronger than regional practical content. Week 28 describes UK services and conditional screening; feeding article uses UK service terms. | Keep source-country distinctions, then add reviewed Saudi/Egypt service explanations and appointment-preparation examples. Do not universalize one country's schedule. |
| F29 | P2 / M | Calculator dates update without a result status/live region; the only main-region alert observed is the static disclaimer. | Announce the settled result or errors politely without repeating all calendar cells on each keystroke. Validate with a real screen reader. |
| F30 | P2 / M | Calendar dates are plain spans with CSS states, no individual accessible date/state labels. | Give the visual calendar an equivalent semantic/text representation. Text result ranges are useful partial alternatives, but ovulation/bleeding states should also be clear. |
| F31 | P2 / L/M | Crisis dialog opens with focus on Close and Escape restores launcher focus, but Tab from its final link reached the document body rather than cycling to Close. | Verify and contain modal focus, including Shift+Tab. Test with assistive technology before declaring conformance. |
| F32 | P2 / M | No skip-to-main link was found on the tested public shell. | Provide a keyboard-visible skip link and useful reading landmarks. Do not declare this alone an automatic WCAG failure: alternatives matter. |
| F33 | P3 / L | Copy includes “1 weeks and 1 days” and “1 days.” | Use locale-aware plural rules throughout calculators, with singular/plural and RTL examples. |
| F34 | P3 / M | 39 of 99 guide titles contain a duplicate brand suffix such as “| Femio — Femio.” All five condition titles sampled also duplicate it. | Own branding in one metadata layer. This is polish and search presentation, not a demonstrated ranking penalty. |
| F35 | P3 / L | Helpful source/review conventions are inconsistent between earlier and later article batches. Patient-visible “Tier 1” adds internal classification without explanation. | Standardize provenance and explain evidence in reader terms; keep internal tiering out of the primary reading flow where it adds no decision value. |

## 5. Calculator-by-calculator verdict

| Calculator | Observed useful behavior | Failure / missing boundary | Persona impact and next step |
|---|---|---|---|
| Period | Three start estimates, expanding ranges when shortest/longest differ, calendar and Arabic labels. | Silent 45-day cap; defaults, future LMP and reversed inputs; no user-facing invalid state. | Particularly weak for teens/PCOS/perimenopause. Show assumptions, explicit unsupported states and useful education. |
| Ovulation | Ordinary LMP 1 Oct + 28 days gives fertile window 10–16 Oct, estimated ovulation 15 Oct, next period around 29 Oct; non-contraceptive warning. | 90-day input uses 45; single estimated day without meaningful context/unknown-cycle path. | Keep the warning; eliminate hidden substitution and make irregular-cycle limitations prominent before output. |
| Pregnancy test | Intercourse 1 Oct gives 22 Oct (21 days); method switch clears incompatible date; NHS source appears. | Period path silently caps long cycles; lacks prominent next-step explanation on the calculator itself for a negative result with ongoing uncertainty. | Retain tested date rule and link the fuller reviewed test guide. NHS confirms the 21-day pathway ([source](https://www.nhs.uk/pregnancy/trying-for-a-baby/doing-a-pregnancy-test/)). |
| Due date | LMP 1 Oct + 28 days gives EDD 8 Jul 2027 and approximate arrival window. | Long-cycle cap, future LMP, no IVF/clinician-date path. | Explain dating basis and support the right input method; avoid implying a delivery guarantee. |
| Pregnancy week | LMP 1 Oct / as-of 9 Oct gives 1 week + 1 day. | Local-date default off by one; invalid dates disappear without reason; grammar. | Correct civil-date handling and explicit invalid/stale explanations. |
| Cycle length | Two distinct starts give a measured interval; duplicate dates are not counted as two intervals. | One interval called regular; one-day interval also regular; duplicate explanation poor. | Present history coverage separately from variability conclusions. |
| BMI | Metric 70/170 computes 24.2; both unit labels exist; body-composition limitation appears. | Unit switch reinterprets numbers; negatives disappear; no age-specific scope. | Preserve physical values on unit change and state the tool's adult boundary. |

## 6. Persona assessment against current public jobs

These are scenario groups spanning the taxonomy; **they are not evidence that all 73 individual personas were tested**. Public availability is judged separately from native competitor features.

| Persona / goal | Live result | Critique | Improvement / comparison |
|---|---|---|---|
| First period / young teen | Eight teen guides plus a teen-normal-period guide; practical school/products/help pathways. | Strong educational intent; named reviewer missing; pain route broken; calculator is adult/default-cycle shaped. | Lead with knowledge and support, not precise forecasting. Benchmark luna's concrete teen/privacy communication. |
| Regular-cycle adult | All seven tools reachable, useful ordinary results. | Cannot save a history today; defaults and uncertainty are insufficiently explained. | Make the free public tools correct and link a transparent record template; compare Clue/Flo longitudinal tools separately. |
| PCOS / irregular cycles | Condition and article results good; dedicated irregular-cycle TTC guide. | Calculator contradicts the educational caution and substitutes 45 days. | Make irregular mode an honest educational outcome; clinician preparation is more useful than a false ovulation day. |
| Endometriosis / disabling pain | Condition, signs, assessment and fertility guides found. | Reading is available; location/impact tracking and a usable appointment output are not public capabilities. | Offer a printable impact/question worksheet; benchmark Clue contextual tags and doctor reports. |
| PMS / PMDD | Condition and symptom-recording articles exist; help route is available. | Public daily longitudinal diary absent. | Reviewed blank diary and help-first framing; no automated diagnosis or community-chat expansion. |
| No periods / contraception / hysterectomy | “no period” search empty; no dedicated public starting route found. | A major whole-life blind spot. | Explain different contexts and route to appropriate education without assuming menopause. Clue Tracking explicitly serves no-period users. |
| TTC with regular cycles | Eleven guides and public fertility/test tools. | Static estimates do not demonstrate personalized fertility tracking. | Explain evidence and useful signals; benchmark Ovia/Flo multi-indicator logging without claiming clinical interpretation. |
| Infertility / IVF | IVF query returned a general fertility-help article; no transfer-date calculator. | Generic TTC does not solve the IVF dating or clinic-organization job. | Dedicated reviewed IVF orientation, clinician-entered dates, appointment questions; Flo's public IVF tool is a direct website benchmark. |
| Pregnancy, ordinary | Thirty-seven weekly guides plus four pregnancy guides and dating tools. | Breadth is good; every weekly page lacks named reviewer; practical personal organization is unavailable. | Verify provenance and offer week-specific printable questions/checklists. Compare Pregnancy+ practical planning. |
| Pregnancy, high risk | Warning-signs guide is answer-first with urgent advice; condition-specific high-risk collections limited. | Arabic safety access fails through links and body translation is absent. | Prioritize reviewed Arabic safety, then condition-aware education; never reassure from a calculator. |
| Pregnancy after loss / current loss | Miscarriage search empty; no dedicated loss collection in the 99-guide inventory. | Whole-life marketing skips an emotionally consequential transition. | Sensitive reviewed grief/recovery/appointment resources; optional development imagery in the future app. Competitor loss-mode behavior was not tested. |
| Postpartum / feeding difficulty | Fourteen mother-focused guides; practical, non-shaming feeding choices and urgent distinctions in sampled content. | Broken bleeding link; UK service examples; reviewer attribution absent across this batch. | Preserve the tone, repair pathways, localize service navigation, add usable recovery/visit worksheets. |
| Newborn caregiver | Eight guides and safety content, feeding/sleep/first checks. | Static reading, not the feeding/sleep/growth tool depth of BabyCenter. | Choose intentional scope: strong reviewed practical education before expanding into baby tracking. |
| Perimenopause / menopause | Five guides; urgent postmenopausal-bleeding explanation, HRT and symptom-recording material. | Entry card unfiltered; common “hot flashes” search fails; HRT source wording needs review. | Direct stage collection, synonyms and clinician preparation. Benchmark Clue/Flo/Balance longitudinal usefulness. |
| Early/surgical menopause / multiple conditions | No dedicated public collection found in the audited inventory. | General age/stage content does not demonstrate tailored support. | Reviewed context-specific education and relevant questions, without diagnosing from missing periods. |
| Arabic-only / limited digital confidence | RTL and translated calculator UI exist; translated crisis page exists at direct URL. | Ordinary links break and guide bodies/cards are English. | This is a foundational delivery failure, not a cosmetic localization task. |
| Limited vision / dexterity / cognitive load | Forms have accessible labels and generous input heights; sampled 390px pages had no measured horizontal overflow. | Dynamic result feedback, calendar states, long-library navigation and modal focus need work. | Validate real keyboard/screen-reader completion, not just automated scores. |

## 7. Competitor comparisons with current primary evidence

Competitor claims below were verified from official product/support pages in this session. **Their apps were not independently installed or exercised.** Paid versus free availability may differ; no pricing, outcome superiority, universal privacy ranking or clinical effectiveness is asserted.

| Product | Verified benchmark | What it means for Femio |
|---|---|---|
| Clue | [No-period tracking](https://support.helloclue.com/hc/en-us/articles/23179811790621-How-can-I-use-Clue-if-I-don-t-have-a-period), [endometriosis tracking](https://helloclue.com/articles/cycle-a-z/how-to-track-endometriosis-symptoms-with-clue), [doctor report contents](https://support.helloclue.com/hc/en-us/articles/37230262486685-What-kind-of-data-is-shown-in-the-report), [perimenopause](https://support.helloclue.com/hc/en-us/articles/13059487439261-What-s-Clue-Perimenopause-mode). | It already covers more than a regular-cycle chapter. Femio must demonstrate better difficult-context support and practical record completeness, rather than name more personas. |
| Flo | [Anonymous Mode](https://flo.health/anonymous-mode), [IVF/FET calculator](https://flo.health/tools/ivf-due-date-calculator), [perimenopause product announcement](https://flo.health/newsroom/flo-for-perimenopause-is-launching-to-empower-the-1-billion-women-who-experience-perimenopause-without-the-support-they-deserve). | Public dating breadth and multiple life stages already overlap Femio's promises. Compare privacy mechanisms and restrictions accurately; do not claim a categorical privacy win from marketing alone. |
| Ovia | [Current all-stage app](https://www.oviahealth.com/ovia-app/), [OPK options](https://www.oviahealth.com/guide/11/tracking-your-ovulation-tests/). | Cycle, TTC, pregnancy, postpartum and menopause plus multiple fertility signals contest the “whole book” differentiator. Continuity must be better in practice. |
| Pregnancy+ | [Official feature inventory/terms](https://info.philips-digital.com/TermsOfUse?country=US&locale=en): weekly reads, appointments, weight, personal clinician questions and preparation tools, with some premium features. | Thirty-seven articles do not equal practical pregnancy depth. Useful questions, preparation and dated records are the meaningful benchmarks. |
| BabyCenter | [Official developer listing](https://play.google.com/store/apps/details?id=com.babycenter.pregnancytracker): pregnancy guidance, reviewed content and postpartum growth/sleep/feeding tools. | Femio's mother-centered tone is a strength, but static newborn guides do not establish tool parity. Community availability is a benchmark fact, not a suggestion to add chat. |
| Balance | [Current product](https://balance-app.com/) and [health-report description](https://www.balance-menopause.com/balance-new/): evidence-based support, symptom monitoring and consultation preparation, now broader than menopause alone. | A narrow “Balance only handles menopause” comparison is outdated. Test treatment-context history and consultation usefulness. |
| luna | [Teen privacy explanation](https://weareluna.app/teen-privacy-policy/). | Specific explanations of parental visibility, access and deletion beat general “safe teen mode” claims. The future on-device Femio app needs its own accurate explanation. |

The fairest comparisons use three separate columns: **Femio website today**, **Femio future app claims**, and **competitor verified offerings**. A website lacking native logging is not necessarily defective; advertising native superiority before that journey can be demonstrated is a positioning problem.

## 8. Accessibility, visual design and technical limits

The overall visual system is coherent: a warm reading surface, recognizable plum brand, clear serif headings and large input fields. The main weaknesses are semantic and navigational rather than a need to repaint everything. The primary hero emphasizes family planning, while the broader lifelong promise includes people not trying for a family; give those readers a visible, equally usable entry point.

Measured text contrast sampling found **no failures** among 61 eligible homepage elements in light mode, 27 calculator elements in light/dark, and 66 eligible content/shell elements in dark mode. Gradient-backed elements were excluded; transparent backgrounds were composited; `color(srgb ...)` values were correctly scaled. These samples do not certify whole-site contrast or non-text graphics. A preliminary calculation with the wrong color parser was rejected, not reported as a defect.

Header navigation and unit pills measured around 36px high; primary form inputs around 48px. Prefer 44px interaction targets where practical, but **do not call all sub-44px controls WCAG AA failures**. WCAG 2.2 AA minimum target size is generally 24×24 or its specified exceptions ([W3C target-size guidance](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)).

The dynamic result and error issues should be evaluated against [W3C status messages](https://www.w3.org/WAI/WCAG22/Understanding/status-messages.html) and input-assistance requirements, followed by actual assistive-technology tests. Proper labels, language parts and Escape restoration are observed strengths.

Robots allows public crawling, disallows `/api/`, and points to the sitemap. Sitemap contained **173 distinct URLs**, including the 99 library guides plus `meet-femio`; health article URLs were English-only, consistent with actual published content rather than pretending translated bodies exist. Article canonicals and sampled structured data were present. Missing reviewer identity and duplicate title branding remain concerns. No Core Web Vitals or server-header pass is claimed; subjective quick navigation is not a performance measurement.

The tailored English 404 offers recovery links, though it incorrectly says a tracker is still here. The malformed Arabic path instead produces a bare framework 404. Standardize recovery and present current capabilities accurately.

## 9. Recommended order and acceptance gates

### Gate 1 — Make current public use dependable

1. Repair Arabic routing end to end, including help and safety articles.
2. Remove silent input substitution; implement meaningful invalid/unsupported states across calculators.
3. Fix BMI unit conversion and cycle-history conclusions.
4. Repair the two broken article paths and the three inbound links.
5. Replace contradictory Privacy/About/Terms/product wording with one accurate current model.
6. Correct the HRT citation statement through clinical review and enforce named reviewer publication evidence.

Acceptance examples: 24–90-day cycles are never calculated as 24–45 without explanation; 70kg/170cm remains the same body and BMI after toggling units; one interval is not declared regular; Arabic clicks reach the intended page; all reviewed guides name their reviewer; all marketing promises match available behavior.

### Gate 2 — Make each public persona journey useful

Deliver reviewed Arabic priority safety/core content, stage collections, language switching, search synonyms, loss/no-period/IVF/early-menopause guidance, and a usable FAQ/glossary or honest removal from promoted flows. Add printable blank tracking and appointment-question resources that work today without accounts. Region-specific care navigation should be reviewed and dated; the [Saudi national emergency directory](https://my.gov.sa/en/emergency-contact) and [MOH 937](https://www.moh.gov.sa/en/937/pages/default.aspx) provide primary starting points. Do not conflate advice lines with ambulance dispatch.

Acceptance: a teen, irregular-cycle user, pregnant Arabic-only reader, grieving user and menopause reader can each answer a relevant question, see the limit of the information and prepare an appropriate next step without a 404, placeholder or unsupported prediction.

### Gate 3 — Demonstrate the richer app rather than announce it

Use a current build with synthetic records. Test empty, sparse, rich, conflicting and historical data; correction/undo; stage transitions including prior loss followed by live birth; backup/restore; shared-device privacy; notifications; exports; date/timezone handling; offline retries and device replacement. Judge depth by task completion and useful explanations. Keep all tools reachable without restricting knowledge by persona.

Avoid expanding into unsolicited chat, messaging or diagnostic AI. Existing repository owner directions explicitly exclude chat and defer AI; competitors having those features does not make them required gaps.

### Gate 4 — Verify quality independently

Run measured mobile performance, browser/device coverage, real screen-reader and zoom testing, network/privacy inspection on the matching deployed product, a clinician content-fidelity review and appropriate legal review of final policies. Prove backup loss/recovery and privacy claims against the shipped mobile architecture.

## 10. Discussion decisions

The next discussion should settle what the public website must accomplish while the app is unavailable: attract readers, help them use correct tools, and prepare them for care—or also act as a functioning tracker. The current site promises both education and rich tracking, but delivers only the former.

For today's public audit, login and additional GitHub access were unnecessary. For repairs or a subsequent app audit, access to the **source/build actually serving this site** would be more valuable than credentials for the different local web tracker. Read-only access is enough for diagnosis; a dedicated synthetic test build/account is needed only when exercising a product that actually supports persistence.

## Evidence files

- `ARTICLE-INVENTORY.csv`: all 99 guide checks. External-link count includes repeated inline/reference links, not distinct sources; word counts include main-region labels and are approximate.
- `TEST-LEDGER.csv`: selected reproducible live scenario inputs/outcomes and limitations.
- `LOCAL-SOURCE-APPENDIX.md`: independent subagent concerns about the unmatched account-based checkout; none is attributed to the public website.

This report separates observed failure, unavailable capability and unverified risk. No numeric “overall score” is supplied because it would imply measurement precision that this audit does not have.
