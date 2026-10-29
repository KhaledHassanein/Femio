# 02 · Monetization: ads on the website, premium in the app

**Status: strategy with defaults; implementation gated by ADR-075 (ads, consent) and by the
app's second release (premium).** The competitor benchmark that informs the free/premium
matrix is `reports/2026-10-28-competitor-monetization.md` (Sonnet subagent, verified by the
lead; §4.3 below folds it in). Prices and traffic numbers are *hypotheses* until measured.

## 1 · Ads on the website (Google AdSense)

### 1.1 Where ads appear and where they never do

| Page type | Units | Why |
|---|---|---|
| Article (`/[locale]/learn/<slug>`, `/conditions/<slug>`) | 2: `article-mid` between the first H2 section and the second H2 (none when the body has one section); `article-end` after the sources, before the app hand-off | the reader has engaged; the sources box stays ad-free |
| Learn index and the 5 condition hubs | 1: `hub-top`, on the Learn index after the "start here" row; on a condition hub after the third card (the first card is above the fold on a phone) | low intrusion on a browsing page |
| Calculators | 0 in the interactive area; 1 under the explanatory text far below the calendar, only on desktop widths | the calendar is the product's promise; nothing competes with it |
| Home, `/app` hand-off, help-now, legal, privacy, 404 | 0 | trust pages |
| Any page, above the fold on mobile | 0 | Core Web Vitals and the design language |

Formats: responsive display units only; no anchors, no vignettes (full-screen interstitials),
no auto ads. Labelled "Advertisement" in the page's language (`ads.label`). **Built 2026-10-29 (R6.8)**
in `apps/web/src/lib/ads/`: each placement reads its own slot id (`NEXT_PUBLIC_ADSENSE_SLOT_ARTICLE_MID`,
`…_ARTICLE_END`, `…_HUB_TOP`) beside `NEXT_PUBLIC_ADSENSE_CLIENT`, so one placement can be switched off
in Vercel without a deploy; a unit stays hidden until the consent tool grants `ad_storage` (the notice
says "only after you allow them", and the component makes it so); the AdSense script is loaded only by
the article and hub components, and the tripwire fails the gate if any other file imports `lib/ads`.
`/ads.txt` is a static route built from the publisher id. The Content-Security-Policy adds the AdSense
hosts only when the publisher id is set (`apps/web/next.config.mjs`).

### 1.2 Requirements before the first unit renders

1. ADR-075 accepted; consent banner live (AdSense requires a Google-certified CMP with IAB TCF for EEA/UK/Swiss traffic since 16 Jan 2024; TCF v2.3 strings since 1 Mar 2026; Consent Mode v2 since Mar 2024. Sources: support.google.com/adsense/answer/13554116; Cookiebot summaries 2026).
2. Site content and traffic that pass AdSense review. Google publishes no traffic number; the site must have original content, an about/author page, privacy page, and be at least a few weeks old. *Hypothesis threshold for applying: 1,000 sessions a week or 8 weeks after launch, whichever first.*
3. Payment: AdSense pays Egypt-based publishers by **wire transfer or cheque** (secondary source, lilachbullock.com 2026; **not verified** against Google's own payment table, which varies by country: confirm in AdSense → Payments → Payments info once the account exists). Payment threshold $100.
4. Google's publisher policies on health: educational health content is allowed; what is restricted is personalised advertising based on health interest (Google Ads policy "Health in personalized advertising", support.google.com/adspolicy/answer/16701855). That restriction is on advertisers and on Google's own serving, not on us, but expect lower fill and lower CPMs on health pages because fewer personalised ads qualify.

### 1.3 Revenue hypothesis (to be replaced by month 1 data)

| Input | Hypothesis | Source of the number |
|---|---|---|
| Article page views, month 3 | 20,000 | first-100-women plan + Arabic search ramp; **no data yet** |
| Consent rate (allow) | 40 % | industry banners 30–60 %; **[NEEDS SOURCE]** for MENA |
| Viewable impressions per consented page view | 1.5 | 2 units, ~75 % viewability |
| RPM (revenue per 1,000 impressions), Arabic health display | $0.5–1.5 | Egypt/Saudi display CPMs are low; **[NEEDS SOURCE]** |
| **Monthly ad revenue, month 3** | **$6–18** | 20,000 × 0.4 × 1.5 × ($0.5–1.5) / 1000 |

Reading: ads will not pay the bills in year one; they cover hosting if traffic grows tenfold.
They are kept because the owner asked, because they cost nothing to run once set up, and
because the inventory exists. The decision point is the first quarter's RPM: below $0.5 and
the units go, and the site sells only the app.

### 1.4 What ads cost us

Lighthouse performance on articles (budget: stay ≥ 85 mobile with ads); a consent banner for
everyone; a privacy notice rewrite; the risk that a stranger's ad sits beside a sourced article.
The style rule: AdSense "Blocking controls" exclude sensitive categories (Google's own
sensitive category blocks: dating, drugs & supplements, get-rich-quick, politics, religion,
sexual & reproductive health **ads**, weight loss) so that no ad contradicts the register.

## 2 · Premium in the app (Google Play Billing)

### 2.1 Why Play Billing and nothing else

An Egyptian seller cannot use Stripe or LemonSqueezy; PayPal and Paddle need a server to verify
entitlements, which femio does not have. Google Play Billing verifies the purchase on the
device, needs no server of ours, pays the merchant account in EGP (Google supports developer
and merchant registration for Egypt; support.google.com/googleplay/android-developer/
answer/9306917), and is the only route that keeps "no account, no server" true. Fee: 15 % on
subscriptions (support.google.com/googleplay/android-developer/answer/112622; the 2026
restructure reported by secondary sources is **not verified** here). Google Play Billing
Library 7+ through the `in_app_purchase` Flutter plugin, pinned.

### 2.2 Plans and prices (owner's proposal, rounded to store convention)

| Plan | USD (base) | EGP (Play converts; owner rounds) | SAR | Note |
|---|---|---|---|---|
| femio Plus, monthly | **$0.99** | ≈ EGP 49 **[check floor in Console]** | ≈ SAR 3.99 | Play shows the allowed range per country when the price is typed |
| femio Plus, yearly | **$9.99** | ≈ EGP 499 | ≈ SAR 37.99 | about 16 % off monthly; the anchor |
| Free trial | 7 days on yearly only | | | one trial per Google account, Play handles it |
| Introductory offer | none at launch | | | keep the Ramadan offer for Feb 2027 |

Keep one product (`femio_plus`) with two base plans (`monthly`, `yearly`), not two products:
Play handles upgrades and proration. Grace period 7 days; account hold on; pause allowed
(Play defaults). Restore purchases from Settings works offline by Play's cached entitlement.

### 2.3 The rule that shapes the matrix

Rule 2, *personalise, never restrict*: every article and every tool stays reachable. Premium
therefore **adds layers** on the one constant record (rule 5) and never gates the core. The
app shows no ads at any tier, so "remove ads" is not a premium benefit; "femio never shows
ads" is a store-listing sentence instead.

### 2.4 Free vs premium (default matrix; §4.3 adjusts it with the benchmark)

| Area | Free (forever) | femio Plus |
|---|---|---|
| Record | Full logging: cycle, flow, symptoms, mood, notes, pregnancy milestones; unlimited history | same |
| Predictions | Ranges with confidence, Hijri beside Gregorian, "no confident window" honesty | same (no "better predictions" tier: accuracy is never sold) |
| 7 calculators and interactive calendar | all | same |
| 100 articles, 5 hubs, screeners, help-now | all | same |
| Backup | Manual backup file, restore | **Scheduled reminder + one-tap export; backup file encrypted with her passphrase** |
| Doctor visit | — | **PDF "cycle and symptom summary" for the last 3–12 months, Arabic or English, to show the clinician** |
| Reports | 3-cycle overview | **12-cycle and pregnancy-journey charts; printable** |
| TTC → pregnancy | Core guidance cards | **The in-depth series: 12-week TTC companion, PCOS-and-conceiving programme, first-trimester week-by-week (new content, additive, still education-only)** |
| Appearance | Dusk Bloom light/dark | **Seasonal palettes (Ramadan, Eid), app icon variants, widget** |
| Partner | — | **Partner view: a read-only summary card she chooses to share by file (PARTNER_SHARING_DESIGN.md), never a server** |
| Reminders | Period and fertile-window reminders | **Custom reminders: medication, supplements, appointments (wording stays non-medical: "your reminder", not a prescription)** |
| Support | Help pages | **"Ask the editor" email line (content questions only, never medical advice; answered weekly)** |

Everything in the Plus column is a layer over the same record and leaves every existing
screen untouched when the subscription lapses (the PDF export simply greys out; data stays).

### 2.5 Revenue hypothesis

| Input | Hypothesis |
|---|---|
| Retained installers after 6 months | 2,000 |
| Conversion to Plus | 3 % (consumer health apps commonly 2–5 %; **[NEEDS SOURCE]**) |
| Mix | 60 % yearly, 40 % monthly |
| Gross per month | 60 × ($9.99/12) × 0.6 + 60 × $0.99 × 0.4 ≈ **$54** |
| Net after Play 15 % | **≈ $46 a month** |

Reading: at these prices the tier is a signal of value and a seed for later pricing, not an
income. The lever is retained installers, which is why measurement and content come first.

## 3 · Implementation phases

| Phase | What | Where | Gate |
|---|---|---|---|
| M0 (now) | This strategy; ADR-075 decision; competitor report | docs | owner |
| M1 (Nov) | Consent + GTM + GA4 + Meta Pixel on the website (`01_ANALYTICS_AND_PIXELS.md` §6) | `apps/web` | ADR-075 accepted; e2e consent test |
| M2 (Dec–Jan) | AdSense application; after approval, the two article units + hub unit behind `NEXT_PUBLIC_ADSENSE_CLIENT`; blocking controls set; Lighthouse budget | `apps/web/src/components/ads/` | approval email; Lighthouse ≥ 85 |
| M3 (Jan) | Premium design: the Plus features above sized; the entitlement model (`domain/entitlements.dart`, golden fixture `fixtures/domain/entitlements.json`: every route reachable without Plus) | `apps/mobile/lib/domain` | fixture passes in Dart and TS |
| M4 (Feb–Mar) | Play Billing: product + 2 base plans in Console (owner), `in_app_purchase` integration, Settings → "femio Plus" screen, restore, lapse behaviour; closed-test with licence testers | `apps/mobile` | Play licence testing green; 390×844 screenshots AR/EN light/dark |
| M5 | First revenue month report; decide ads keep/drop by RPM | reports | — |

## 4 · Competitor benchmark

### 4.1 Questions the benchmark answers

What is free and what is paid in Flo, Clue, Natural Cycles, Ovia, Stardust, Premom, Glow,
Period Tracker, BabyCenter, What to Expect, Pregnancy+, Balance and the Arabic-market apps;
how ads appear in the free tiers; monthly and yearly prices and the yearly discount; whether
$0.99/$9.99 sits inside Play's EGP/SAR ranges; three risks.

### 4.2 Report

`reports/2026-10-28-competitor-monetization.md` (Sonnet, 2026-10-28; accepted by the lead, R6.2).

### 4.3 What the benchmark changes in this plan (lead's reading, 2026-10-28)

Sample-checked by the lead: 2,283 words, 40 numbered sources read on 2026-10-28, every
unfetched page marked *not verified*. Accepted with these consequences:

1. **Free tier confirmed as in §2.4.** Clue's and Flo's core tracking is free and Clue's article
   pages carry no paywall; rule 2 and the YMYL funnel agree. Nothing moves to Plus.
2. **Premium ranking adopted:** doctor-visit PDF first, then pattern insights with ranges, the
   TTC/PCOS programme, pregnancy extras, expert-style courses. The matrix in §2.4 keeps all of
   them; M3 sizes them in that order.
3. **"Removes ads" is dropped as a promise** (the report reaches the same conclusion as ADR-075:
   no ads in the app, no accounts on the site). The listing says "femio never shows ads".
4. **Price: keep the owner's base ($0.99 / $9.99) for Egypt; Saudi Arabia is a per-country
   hypothesis.** Arabic competitors charge SAR 19.99–39.99 a month (Hawaa, Al Malika, roony+),
   Clue SAR 34.99–37.99. A Saudi price of **SAR 9.99 a month / SAR 79.99 a year** (about $2.66 /
   $21) is the test; Egypt stays at the converted base (about EGP 55 / 560 at 56 EGP per USD,
   third-party rate). Play lets each country row be edited (guide part I). Decide after the
   first 100 women; the Play minimums (2015: E£2, SAR 0.99; sub-dollar markets since 2021)
   are not a constraint at these levels, exact current floors not verified.
5. **AdSense blocking list extended** with Birth control, Cosmetic procedures and Astrology
   (owner guide part H step 5 updated).
6. **Two risks go on the ledger:** (a) the Play Billing library must work without the INTERNET
   permission the release gate forbids; it talks to the Play Store app on the device, not to the
   network, so it should, but **M4 starts with a one-screen spike that proves it** (R6.7);
   (b) the legal pack's "no ads, no tracking cookies" lines are rewritten only if ADR-075 is
   accepted, in the same commit as the consent component, never earlier.
7. **One test the owner can run (from the report):** install Flo, Clue and one Arabic app on the
   phone, open an article and a calculator in each, count ad units and note where the paywall
   appears; 20–60 minutes; write the counts into `reports/2026-10-28-competitor-monetization.md`
   §2 where it says *not verified*.
