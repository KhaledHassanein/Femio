# Femio V2 — Competitor Landscape (Web / Android / iOS)
Prepared: 2026-07-16 · Complements V1's `competitive_analysis.md` (archived) with 2026 state.

## A. Cycle / period trackers
| App | Platforms | Strengths | Weaknesses (our openings) | Pricing |
|---|---|---|---|---|
| **Flo** | iOS/Android/web(lite) | 320M+ users; broadest features; pregnancy mode; Anonymous Mode; huge dataset insights | Trust damage (FTC 2021); shrinking free tier; generic content; weak for irregular cycles | Freemium, ~€33/yr |
| **Clue** | iOS/Android | Science credibility (peer-reviewed algorithm); GDPR/Berlin positioning; inclusive design | Fewer tools; premium expensive (~€10/mo); no lifecycle breadth | Freemium |
| **Stardust** | iOS/Android | Viral Gen-Z brand; privacy framing; beautiful design | Shallow logging; astrology limits medical credibility; history paywalled | Freemium |
| **Period Calendar / Period Tracker (Simple Design, GP Apps)** | Android-heavy | Massive installs; simple | Ad-stuffed, dated, zero medical depth | Free+ads |
| **Eve/Glow suite** | iOS/Android | Community | 2024 data breach; aging product | Freemium |
| **Apple Cycle Tracking / Samsung Health / Garmin** | OS-native | Free, private, wearable-integrated | No content, no conditions, no lifecycle | Free |
| **WomanLog, Maya, Ovy, Femometer** | mixed | Regional niches | Undifferentiated | Freemium |

## B. Fertility / TTC / IVF
| App | Strengths | Weaknesses | 
|---|---|---|
| **Natural Cycles** | Only FDA-cleared digital contraceptive; BBT algorithm; Oura/Apple Watch integration | Premium-only; contraception focus | 
| **Premom** | OPK strip photo-analysis | FTC settlement 2023 (data sharing); hardware-tied |
| **Fertility Friend** | Deepest BBT charting + education; veteran trust | Dated UX |
| **Mira** | Quantitative hormone home-testing hardware + app | Expensive hardware ecosystem |
| **Kindara** | FAM charting | Stagnant |
| **Ovia Fertility→Pregnancy→Parenting** | Lifecycle continuity (best-in-class concept); free via employers/insurers | US-centric B2B2C; data-sharing concerns |
| **IVF-specific (Embie, Alife, clinic portals)** | Protocol tracking niche | Tiny, fragmented — big opening for Femio's IVF module |

## C. Pregnancy / postpartum
| App | Strengths | Weaknesses |
|---|---|---|
| **What to Expect** | Best editorial content; huge community | Sells personal data (Mozilla flagged); ad-heavy |
| **BabyCenter** | 400M users; birth-club communities; free | Data broker practices (2024 Senate inquiry) |
| **Pregnancy+ (Philips)** | 3D fetus visuals; polish | Content behind subscription; no cycle continuity |
| **Huckleberry / Baby Tracker** | Postpartum/baby logging | Baby-only, mother's recovery ignored |

## D. Menopause (fastest-growing gap)
| App | Strengths | Weaknesses |
|---|---|---|
| **Balance (Newson Health)** | Dr. Louise Newson brand; free tracking; clinical content | ~$99/yr for advanced; UK-centric |
| **Caria** | CBT-based programs; published clinical study | Small; subscription-first |
| **Midday** | Mayo Clinic partnership; specialist access | US-centric; unclear pricing |
| **Peppy, Elektra, Evernow, Alloy** | Telehealth/HRT delivery models | Service businesses, not self-serve tools |

## E. MENA / Islamic-context
- **Afifa** — Muslim-women cycle app (purity/prayer guidance). Small but proves the niche.
- **Hayaa, Nabta Health (UAE), Delfina, local clinic apps** — fragmented, low product quality overall.
- **Opening:** high-quality Arabic-first RTL experience with optional faith-aware features (prayer/fasting-related cycle guidance, discretion modes) + FR for North Africa = distinctly underserved.

## F. Web/content competitors (the SEO battlefield)
Healthline, WebMD, Verywell Health, Mayo Clinic, Cleveland Clinic, Flo's blog, Clue's Helloclue magazine, NHS. They own the search terms but offer no interactive tools → Femio's referenced condition library + free web calculators/trackers is the wedge to capture that traffic and convert to users.

## G. Strategic takeaways
1. **Nobody owns the full lifecycle** — Ovia comes closest conceptually but is US/B2B; global consumer lifecycle play is open.
2. **Trust is the purchasable brand asset** — every major player has a privacy scandal; being verifiably clean is a marketing weapon.
3. **Menopause + PCOS/endo + IVF depth** are the three under-supplied, high-willingness-to-pay veins.
4. **Web-first is uncontested** — top trackers are app-only; content sites are tool-free.
5. **Free tier generosity + honest predictions** directly counter the top review complaints of the two market leaders.
6. **Arabic (RTL) + FR + ES from day one** reaches markets the leaders localize poorly.

---

# H. Craft teardown (R1.1a — desk pass, 2026-08-11)

Sections A–G compare **features**. This section compares **craft**, because the owner's verdict
on Femio was *"the design is from first look AI generated and the user experience sucks"* and
"make it look better" is not a brief (`docs/25` §2).

**Status: desk research.** Everything below came from the live marketing surfaces, the App
Store listings, and aggregated review reporting. **R1.1b — the owner's hour of screen
recordings — is still owed**, and the in-app craft questions (one-handed logging, speed on a
real connection, haptics, how a notification reads on a lock screen) are unanswerable without
it. Claims here are quoted or attributed; where a source only supported a generalisation, it
says so rather than inventing detail. Stardust is **not yet done** — see §H.6.

## H.1 What each one leads with, and what carries it

| | Hero claim (quoted) | What carries it | Trust mechanism |
|---|---|---|---|
| **Flo** | *"a science-backed period tracker… used by over 460 million\* women worldwide"*; *"created with 100+ doctors and medical experts"* | Scale. Type-led, no product screenshot in the store description's first move | **A certification.** Paragraph two of the App Store description is about privacy, and its answer is an award: *"recognized as ISO 27001/ISMS Team of the Year at the 2025 PICCASO Privacy and Security Awards"* |
| **Clue** | *"The #1 women-led period and cycle tracker app"* · *"Science-based, privacy-first. For everyone with a cycle."* | **Product screenshot** in a phone mockup — the tool, not a lifestyle image | Institutional partners named on the homepage (Stanford, Gates Foundation, Oxford), press logos, *"never sold your data"*, EU privacy law, 100M+ downloads, 4.8★ |
| **Balance** | *"Understand your hormones. Feel more prepared"* | Product screenshot plus abstract purple ring graphics and dots. **No photography** | **A named clinician with credentials on the page** — Dr Louise Newson, BSc MBChB MRCP FRCGP DHealth — plus ORCHA certification and Apple Editors' Choice |

**Three things Femio should take from this and one it should refuse.**

- **Nobody in this category uses stock portraiture in their hero.** Clue and Balance both lead
  with a product screenshot; Balance uses abstract geometry. This independently arrives at the
  R1.2 decision (`docs/25` §5a) — botanical line-work over photography — from the market side
  rather than from principle.
- **Balance's move is the strongest and the cheapest to copy honestly:** put the clinician's
  name and post-nominals on the page. Femio already has the reviewer, the credentials field and
  the `people` collection — it is blocked only on P1.9.7, an owner task worth ten minutes.
- **Clue proves a product screenshot outperforms a mood image** in this category. The R1.3
  reference had none, which was its biggest weakness — **closed 2026-08-11 by R1.3a**, which
  put the real cycle dashboard under the hero, drawn from the same tokens as the app.
- **Refuse Flo's answer to privacy.** Their reply to a documented FTC action is a *certification
  won in 2025*. Femio's is structural — there is no channel from health data to an advertiser,
  by construction (ADR-017/025), owner-only RLS proven by an automated audit, and export/delete
  in the app. **A structural claim beats a badge, and Femio can make one Flo cannot.** That is
  the strongest sentence this product owns and it belongs in the hero — it is already in the
  R1.3 reference as the anti-claim line.

## H.2 The whitespace map — what users complain about

This is where Femio's openings actually are, and the striking thing is how precisely the top
complaints map onto rules Femio already committed to before seeing them.

| Complaint (reported of the market leaders) | Femio's existing answer |
|---|---|
| Predictions degrade badly for **PCOS and perimenopause** — repeated wrong forecasts after months of logging | **Product rule 3.** `predictNextPeriod` widens the window and suppresses the "late" counter in irregular mode; the menopause panel reports **variability**, not an average |
| Flo is reported to apply a **day-14 ovulation assumption** regardless of logged data unless an OPK result is entered | Femio's fertile window derives from *her* average cycle, and is framed as conception awareness — never a certainty and never contraception |
| **Pattern analysis sits behind Premium** — described in reviews as *"the one feature I would actually pay for, gated"* | **Unbuilt (P2.5/R4) and therefore still a free decision.** See H.3 |
| Features that were **free are now premium**; long-term users describe feeling *"bait and switched"*; pregnancy content moved behind the paywall | **Product rule 2 — personalize, never restrict.** Whatever the pricing becomes, the "free forever" list must be published and honoured (P2.10) |
| **Subscription prompts after nearly every action** | No monetisation exists yet, so this is a discipline to keep rather than a gap to close |

## H.3 The one strategic finding

*"The one feature I would actually pay for, gated"* — said about **pattern analysis** — is the
most useful sentence in this entire teardown.

It says the willingness-to-pay in this category attaches to **pattern intelligence**, not to
tracking, and that the leaders have already discovered this and put it behind the paywall.
Femio's roadmap calls the pattern engine "the stated differentiator" (`docs/23` §3.2) and has
not built it. Two consequences:

1. **R4 is worth more than its position in the queue suggests.** It is both the differentiator
   *and* the revenue mechanism, evidenced rather than assumed.
2. **The pricing decision has to be made deliberately, not by drift.** Charging for patterns is
   defensible; discovering later that patterns were promised free is the mistake the market
   leaders are being punished for in their own reviews. Feed this into P2.10 before any paywall
   is designed.

## H.4 Ovia — the only lifecycle attempt, and why it does not close the gap

Ovia is the competitor whose *concept* is closest to Femio's, so it deserves its own reading.
Two structural facts decide it, and neither is a design problem they can fix with a redesign.

**It is three apps, not one account.** Ovia ships Fertility, Pregnancy and Parenting as separate
products. A woman moving from trying-to-conceive into pregnancy changes app. Whatever
continuity exists is a hand-off between installs, not a record that re-layers — which is
precisely the thing `docs/09` invariant 2 (constant EMR, additive layers) was written to
guarantee.

**Its business model routes health data toward employers.** The apps are free, and the premium
tier unlocks through an employer or health-plan sponsorship. Reporting from 2019 onward
(Washington Post, and Mozilla's *Privacy Not Included* entries for both Ovia Fertility and Ovia
Pregnancy) describes employers who buy the benefit being able to see **aggregated, de-identified**
data about their workforce — how many faced high-risk pregnancies, the top medical questions
asked, how soon new mothers planned to return. Users of the sponsored version opt in.

Whatever one thinks of the aggregation, note what it means competitively:

> **The only company attempting Femio's product is funded by pointing women's reproductive data
> at their employers.** Femio's `docs/09` invariant 6 already says "no employer/insurer
> visibility" — written in July 2026, before this was looked up. It now has a named competitor
> standing against it, which turns a principle into a positioning line.

## H.5 Where Femio genuinely stands apart

Not one of them markets **continuity**. Flo sells scale, Clue sells science, Balance sells a
clinician, and Ovia — the only lifecycle attempt — splits it across three apps and monetises
through the employer. So the life-stage rail at the top of the R1.3 homepage reference is not a
stylistic choice: it is **the only claim in this category that a competitor cannot answer by
copying a screen**, because answering it would require Flo to build five more products and Ovia
to change how it makes money.

## H.6 What is still owed

- **R1.1b (owner, ~1 hour):** three screen recordings per app — sign up · log a period · open
  cold on day 3. Every in-app craft question above is blocked on it.
- **Stardust is not covered.** Its site returned 403 and its App Store URL 404'd on this pass.
  It matters for one narrow question — *why does a shallow product feel premium?* — which is the
  purest craft question in the set, and the one Femio most needs answered. Retry from the Play
  Store listing or fold it into R1.1b.
- **Ovia is covered structurally (§H.4) but not visually.** Its store listing 404'd, so how the
  three apps actually look and hand off is unread.
- **Localized store screenshots, including Arabic**, were not pulled. Arabic-first is a stated
  differentiator and how the leaders handle RTL is directly relevant.
- **No motion or transition evidence.** That needs video, which lands with R1.1b.

## Sources
- App Store — Flo (listing text, ratings, IAP tiers), retrieved 2026-08-11
- Mozilla Foundation, *Privacy Not Included* — Ovia Fertility and Ovia Pregnancy entries;
  Washington Post (2019) reporting on employer-visible aggregate data, retrieved 2026-08-11
- oviahealth.com/apps and /employer-family-benefits (three-app structure, sponsorship model)
- helloclue.com homepage, retrieved 2026-08-11
- balance-app.com, retrieved 2026-08-11
- Aggregated review reporting on Flo and Clue, retrieved 2026-08-11 (see H.2 — reported, not
  first-party; treat as directional until R1.1b)
- https://unstar.app/blog/flo-clue-stardust-apple-health-period-tracking-apps-ranked-2026
- https://www.go-go-gaia.com/blog/how-to-choose-period-tracker-app.html
- https://cyclesynced.org/best-period-tracker-app-2025-11-apps-compared-tested-reviewed/
- https://www.go-go-gaia.com/blog/best-fertility-tracking-app.html
- https://www.forbes.com/health/womens-health/pregnancy/best-pregnancy-apps/
- https://www.consumerreports.org/health/pregnancy-childbirth/best-pregnancy-tracking-apps-a8731130463/
- https://www.theflowspace.com/reproductive-health/menopause/best-menopause-apps-2941944/
- https://www.go-go-gaia.com/blog/best-perimenopause-tracking-app.html
- https://afifaapp.com/
- V1 archived docs: `references/femio_v1_archive/docs/competitive_analysis.md`
