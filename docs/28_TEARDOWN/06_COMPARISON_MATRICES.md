# 28.06 — Four-way comparison

Every cell is sourced from chapters 02–05. `—` means absent, not merely weak.
"Femio" is the repository at `c1123e1`, 2026-08-23.

Read the matrices with one caution: Flo's column understates it. Most of Flo's
content, copy and layout is delivered from servers we did not contact, so wherever a
row counts something, Flo's real number is at or above the number shown.

---

## A. Scale

| | Flo | Pregnancy Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Classes / files | 35,196 classes | — | 5,346 classes | 144 `.tsx`, 70 test files |
| Screens / routes | 157 activities | 24 routes | 45 activities | 40 routes (15 app, 20 public) |
| Feature modules | 79 `feature.*` + 119 `core.*` | 10 feature packages | 17 `function.*` | 30 `lib/*` modules |
| Onboarding steps | 442, 634 transitions | 4 | — | wizard, single path |
| Data model | not enumerable from binary | 5 Room entities | — | 27 Postgres tables |
| Tests visible | — | — | — | 70 files + golden fixtures |

## B. Life stages covered

| Stage | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Puberty / adolescent | partial (age cohorts) | — | — | ✅ Track A, 2 personas |
| Cycle tracking | ✅ | — | ✅ basic | ✅ Track B |
| Conditions (PCOS, endo, fibroids…) | onboarding triage only | — | — | ✅ triage + `conditions_flagged` |
| TTC | ✅ full track | — | — | ✅ Track C |
| Pregnancy | ✅ full track + widget | ✅ the whole product | — | ✅ Track D |
| Postpartum | partial (`pm_parent`, EPDS absent) | — | — | ✅ + EPDS |
| Perimenopause | ✅ full track | — | — | ✅ Track E |
| Menopause | ✅ | — | — | ✅ + MRS |
| **One record across all** | goal switcher between tracks | — | — | ✅ constant EMR, additive layers |

Femio already wins this row, and it is the only row it wins outright today. No
competitor spans puberty to menopause on one record. **This is the product thesis and
it is real** — chapters 08 and 09 exist to make it visible rather than merely true.

## C. Tracking vocabulary

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Symptoms | 47 | symptom tracker (count unknown) | basic | ~22 |
| Moods | 16 (own dimension) | — | — | mixed into symptoms |
| Discharge / cervical fluid | 11 types, each animated | — | — | — |
| Intercourse / conception marker | 10 sex & libido entries | — | — | — (scoped conservative — see below) |
| Flow levels | 3, each animated | — | ✅ | ✅ flow strip |
| Weight | ✅ | ✅ | — | ✅ `vitals` |
| Temperature / BBT | ✅ + chart + UIC element | — | — | — |
| Water | ✅ | — | — | — |
| Activity / steps / sleep | ✅ via Health Connect | — | — | — |
| Glucose | — | — | — | ✅ `strip.glucose` |
| Labs | — | — | — | ✅ `labs` table |
| Medications / supplements | contraceptives + pills | — | — | ✅ `meds_supplements` |
| Contractions | — | ✅ | — | ✅ |
| Fetal movement | — | ✅ | — | ✅ |
| **Pattern analysis** | flat lists | — | — | ✅ timing, co-occurrence, severity, confidence |

Flo logs 84 concepts; Femio logs ~30 but is the only one that *analyses* them. The
right target is not 84 — it is our 30 plus the ones that carry clinical weight
(discharge and cervical fluid, BBT, mood as its own dimension), all of them feeding
the pattern engine.

Flo's ten-entry "sex and sex drive" category is **not** a gap to close. Per owner
direction of 2026-08-23 (`10_FLO_RUNNING.md` §6) Femio logs a single conservative
*intercourse* / *conception* marker carrying a date — which is all `lib/fertility`
needs — and keeps the clinical symptoms (painful intercourse, dryness, bleeding after
intercourse, libido change as a perimenopause or medication marker) under their
clinical names. Femio is not a sexual-wellness platform.

## D. Design system

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Token files | 9 typed token classes | — | — | 1 CSS file, 144 tokens |
| Spacing scale | dual, mid-migration to numeric | per-screen metrics objects | — | `space-*` |
| Radius / border scales | ✅ both, incl. `radiusFull` | — | — | `radius-*` only |
| Typography styles | 19 named, on stock Roboto | Material default | — | `font-ui/display/ar/mono` + scales |
| **Custom brand typeface** | — (Roboto) | — | — | ✅ incl. Arabic face |
| Cycle-state colours | ✅ 6 semantic tokens | — | — | ✅ 5 phase tokens |
| Per-event-category colours | ✅ 19, each with Alternate | — | — | — |
| Button hover / pressed | ✅ tokens | — | — | — |
| Focus ring | ✅ `borderFocus` | — | — | — |
| Chart colours | ✅ active/inactive pairs | — | — | — |
| Illustration skin tones | ✅ 5 | — | — | — |
| Avatar backgrounds | ✅ 15 | — | — | — |
| Dark mode | ✅ authored `values-night` | Material dynamic | — | ✅ |
| Wear OS / secondary surface | ✅ | — | — | — |

## E. Dashboards, charts and motion

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Chart surfaces | 6 native + 3 UIC element types | growth + weight | 1 analysis view | **1** (weight) |
| Charting library | none — all bespoke | Compose canvas | — | **none, and no charts** |
| Server-driven charts | ✅ `TemperatureChart`, `ScoreChart`, `ProgressCircular` | — | — | — |
| Lottie / motion assets | ~50 own animations | — | — | **0** |
| Animated logging feedback | ✅ 10 (flow ×3, fluid ×7) | — | — | — |
| Prediction-change animation | ✅ | — | — | — |
| Streak / gamification motion | ✅ `streak_bolt`, `streak_unfreeze` | — | — | — |
| Runtime-fetched animation (Rive) | ✅ | — | — | — |
| Device-capability gating of motion | ✅ | — | — | — |
| Designed offline state | ✅ copy + refresh affordance | — | — | ✅ offline queue |
| Home-screen widget | ✅ pregnancy | — | — | — |

This is the matrix Khaled's brief is really about, and it is close to a shutout.

**One correction from running the app (chapter 10).** Flo's charts are not a headline
surface — its "Insights" tab is a content library with no chart on it, and the data
graphics live several levels down in cycle details, cycle history and the BBT chart.
Their delight is carried by illustration, motion and editorial cards. So a genuinely
good chart layer is not only parity work for us; done well it is a differentiator
nobody in this study holds.

## F. Personalisation engine

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Server-driven UI | ✅ ~65 element types | — | — | ✅ 54 module ids |
| Element/module contract | 11-field envelope | — | — | `{ id, emphasis, params? }` |
| Accessibility in the contract | ✅ | — | — | — |
| Analytics impressions in the contract | ✅ | — | — | — |
| Reactive variables in the contract | ✅ `output` / `onVariableChanged` | — | — | — |
| Onboarding as data | ✅ 442 steps / 634 edges | enum, 4 steps | — | coded wizard |
| Segments / personas | ~5 tracks × cohorts × tiers | 1 | 1 | **73 specced, 24 wired** |
| Remote config | ✅ 149 features, supplier chain | — | — | — |
| Experiments / A-B | ✅ concurrent arms in prod | — | — | — |
| Device-capability targeting | ✅ | — | — | — |
| Market-tier targeting | ✅ `tier0` vs `en` | — | — | — |
| Offer / transition suggestions | goal switcher | — | — | ✅ `offer` + `transition`, never auto-applied |

Femio's module contract is thinner than Flo's by eight fields, and those eight
fields are where accessibility and analytics live. Femio's persona taxonomy is an
order of magnitude richer than Flo's segmentation — on paper. Two-thirds of it is
unwired.

## G. Content and community

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| CMS | ✅ Contentful | hardcoded in Kotlin | — | ✅ Payload, 8 collections |
| Article count | server-delivered | 40 weeks + 5 guide categories | — | 105 authored / 31 live |
| Pregnancy week-by-week | ✅ | ✅ 40 weeks, 3 registers each | — | ✅ 37 weeks (4–40) |
| Citations / sources | — | — | — | ✅ Tier-1/2 enforced |
| Named clinician byline | — | — | — | ✅ |
| Editorial / review policy page | — | — | — | ✅ |
| Conditions library | onboarding triage | — | — | ✅ |
| Glossary | — | — | — | ✅ |
| Video | ✅ | — | — | — |
| Stories format | ✅ | — | — | — |
| Vertical feed | ✅ | — | — | — |
| Search | ✅ | — | — | — |
| Community / groups | ✅ full | — | — | — |
| Expert blog / expert replies | ✅ `bubbleExpert` | — | — | — |
| AI assistant | ✅ + "not medical advice" | — | — | — |
| Validated screeners | — | — | — | ✅ EPDS, MRS, mood |

## H. Integrations

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Platform health (Health Connect / HealthKit) | ✅ 21 data types | — | — | — |
| Wearables | ✅ Oura, Wear OS | — | — | — |
| Background health reads | ✅ | — | — | — |
| Partner / family sharing | ✅ partner mode, family plan | — | — | ✅ per-recipient consent |
| Clinician-facing export | — | — | — | ✅ summary + export |

## I. Monetisation

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Subscription | ✅ + family plan | ✅ RevenueCat, 2 tiers | — | deferred |
| Server-composed paywall | ✅ 4 UIC element types | — | — | — |
| Free-trial toggle on paywall | ✅ | — | — | — |
| Referral programme | ✅ | — | — | — |
| Payment-issue recovery flow | ✅ | — | — | — |
| Icon changes for premium/sale | ✅ 3 launcher aliases | — | — | — |
| **Advertising** | AppsFlyer attribution (consented) | AdMob incl. post-success interstitials | MoPub + FAN + AppsFlyer + AdMob | **forbidden by rule 4** |

## J. Privacy, security and trust

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| Anonymous mode | ✅ flagship, animated | — | — | — |
| App lock / passcode | ✅ | — | — | — |
| Biometric unlock | ✅ | — | — | — |
| MFA | ✅ | — | — | ✅ (staff + user) |
| Granular consent | ✅ | — | GDPR screen | ✅ `consent_records` |
| Export data | ✅ | — | — | ✅ |
| Delete account | ✅ + exit survey | — | — | ✅ |
| Audit log | — | — | — | ✅ |
| RBAC | — | — | — | ✅ `docs/18` |
| k-anonymous aggregate insights | — | — | — | ✅ |
| Screenshot detection | ✅ | — | — | — |
| Ad-SDK access to health data | attribution only, consented | ✅ yes | ✅ extensively | **never** |
| Invasive permissions | none notable | ad IDs | `READ_PHONE_STATE`, `GET_ACCOUNTS`, `SYSTEM_ALERT_WINDOW`, `MOUNT_UNMOUNT_FILESYSTEMS` | none |

## K. Localisation

| | Flo | Preg. Tracker | GO Flo | **Femio** |
|---|---|---|---|---|
| UI languages in client | 1 file, server-translated | 2 (en, fr) | ~2 real (en, fr) | **4 at parity** |
| Client string keys | 2,422 (one language) | 140 externalised | 764 | **1,836 × 4 = 7,344** |
| Arabic UI | server-side only, unverified | — | 40-string stub | ✅ complete |
| **RTL layout mirroring** | **`supportsRtl="false"`** | declared, unused | partial | ✅ RTL-native |
| Arabic typeface | — | — | — | ✅ `font-ar` |
| Content localisation | server-delivered | en only | — | **en only — our gap** |
| Translator workflow | not in client | none | none | ✅ `admin/translations` |

---

## The verdict, in one paragraph

Against the standing rule — *better than the three combined* — Femio today wins
decisively on life-stage breadth, data model, localisation, clinical trust apparatus,
pattern analysis and privacy architecture. It loses decisively on visual and motion
craft, charts and dashboards, tracking vocabulary breadth, pregnancy tool depth,
platform-health integration, content volume and languages, community, assistant, and
every piece of release-time infrastructure (remote config, experiments, kill
switches). It is roughly level on server-driven architecture, where our contract is
younger and thinner but our persona model is far richer.

Six matrices out of eleven currently go against us. Chapter 07 turns those into a
ranked list of work.
