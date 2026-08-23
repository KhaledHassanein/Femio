# 28.10 — Flo, running

Chapters 02–09 were written from a decompiled binary. This chapter was written from
the app actually running: Flo 10.3.0 installed on an Android emulator
(Medium_Phone, API 36.1, 1080×2400 @ 420dpi ≈ 411×914 dp, x86_64 with ARM
translation) on 2026-08-23. Seventy-two screens captured, in `E:/re/shots/`, not
committed.

**Method note that supersedes chapter 01.** Running the app *does* contact Flo's
servers — that is how a server-driven product works, and it is the only way to see
the served experience rather than the bundled fallback. No account was created. The
two required consents (privacy policy/terms, health-data processing) were accepted to
pass the gate; the optional AppsFlyer/Firebase/TikTok tracking consent was declined.
The owner subscribed to a free trial on his own Google account to expose the premium
surfaces; Claude did not and does not make purchases.

---

## 1. The finding that justifies the whole exercise

**The live app and the shipped APK disagree, and the disagreement is strategic.**

The bundled `onboarding.json` offers nine goals: track my period, get pregnant, track
my pregnancy, understand my body, decode my discharge, enhance my sex life, explore
contraception, manage my weight, none of the above.

The live app offers eight, and **four of them are midlife**:

```
Get pregnant                          Track my pregnancy
Learn more about perimenopause        Track perimenopause symptoms
Track my period                       Understand my body
Enhance my sex life                   Manage my transition through menopause
```

Discharge, contraception and weight are gone. Perimenopause and menopause now occupy
half the grid. The header also changed: "Choose as many as you'd like" — it is
multi-select now, where the bundled flow was single.

Two conclusions. First, their server-driven claim is real and load-bearing: the
product changed materially without a release. Second, **Flo is repositioning toward
midlife**, which is the exact segment Femio's Track E covers with seven personas.
Chapter 02's goal list should be read as historical.

## 2. The onboarding, walked end to end

Fifty-seven screens from cold launch to the paywall. In order:

| Beat | What it does |
|---|---|
| Privacy first | Three consents, all unchecked, "Next" disabled until the two required ones are ticked. Third is explicitly marked optional |
| Are you using Flo for yourself? | Yes / No, I have a partner code — the fork into partner mode |
| How did you find out about us? | Nine-option attribution, skippable |
| When were you born? | Wheel picker; the centre slot reads "Select" until a year is scrolled in |
| **What can we help you do?** | The eight goals above, multi-select |
| Feature card | "Flo's tracked over 2.2 billion cycles" + product preview + a real tweet |
| **Can you tell us more about your goals?** | Eight intents — second segmentation layer |
| **What can we help you do?** (again) | Six more, third layer |
| How do you feel about your period? | Five emoji answers — tone, not data |
| How would you rate your knowledge about periods? | Four answers — reading level |
| Did you know? | Social-impact card (menstrual knowledge in Malawi) |
| Currently supporting 16 million women | Social-impact card (donated subscriptions) |
| Join the discussion | Community sell |
| Are your periods regular? | Yes / No / I don't know |
| Tap the day your last period started | Calendar, with "I don't remember" |
| Don't remember? | Recovery screen: approximate now, update later |
| What birth control do you use, if any? | Nine options |
| **Do you experience any of these health conditions?** | Yeast infections, UTIs, BV, PCOS, endometriosis, fibroids, I'm not sure, none |
| Always know what's coming | **Pre-permission primer**, then the OS notification dialog |
| Discharge / symptoms / pain / hormone-imbalance blocks | Four clinical triage screens |
| **Do you want to see sex-related questions?** | Consent gate before any sexual content |
| How tall are you? / How much do you weigh? | Wheel pickers |
| Six social-proof cards | "69% say Flo helps them sleep better", "#1 Health and Fitness app in the USA and UK", etc. |
| **Commitment** | "I will use Flo to… Tap and hold on the Flo logo to commit" |
| **Paywall** | Prices, trial toggle, three rotating reviews |

Confirmations worth recording: the six condition options match exactly the six
`onb_track_health_conditions_*` tags found in the transitions JSON, so the bundled
graph and the served graph share a tag vocabulary even where the content differs.
And the `Commitment` UIC element from chapter 02 §2 turns out to be a press-and-hold
gesture on the logo — a physical ritual immediately before the price.

### The clinician bridge — they are already selling it

Four consecutive screens:

> "Your body signals matter — don't ignore what they mean"
> "Get symptom checkups in just 2 minutes, not years"
> "How would you rate your experiences with talking to doctors in the past?"
> "Help your doctor to help you"

This is chapter 08's **D3** — the visit pack — being used as a conversion argument by
the market leader, without any of the apparatus behind it (no validated screeners, no
citations, no clinician byline, no export). They have the story; we have the
substance and no story. That asymmetry is the opportunity, and it is more urgent than
chapter 08 implied.

### Owner direction, 2026-08-23 — this onboarding is an anti-pattern

Khaled's assessment on seeing this flow: *extensive, soliciting and boring rather
than practical and comfortable; a pain point to kill in our app. Good-looking,
detailed, joyful but simple. No overselling. Behave ethically.*

That is a direct amendment to **TD-09**. Keep from Flo: the answer-then-respond
rhythm, the reason-for-asking subtitle on every question, "I don't know" as a
first-class answer, the recovery screen when she does not remember a date, and the
pre-permission primer. Reject: the six social-proof stat cards, the two donation
cards, the commitment ritual, the triple-layered goal interrogation, and the paywall
as the terminus. Femio's onboarding should get her to a working dashboard and earn
the rest later.

## 3. The dashboard

Empty state, and it is designed rather than blank — the hero reads *"Log the first
day of your last period to make better predictions"*.

```
avatar(badge)          August 23              calendar icon
TODAY 23  M 24  T 25  W 26  T 27  F 28  S 29
┌──────────────────────────────────────────┐
│   soft peach/pink gradient, organic blob  │
│   shapes; the prediction ring lives here  │
└──────────────────────────────────────────┘
   ( Log period )    ( + Symptoms )   ( ♡ Sex )
My daily insights · Today   → horizontal card carousel
Suggested for you           → second content row
[ Today ] [ Insights ] [ Secret Chats ] [ Messages ] [ Partner ]
```

Four things to take from it.

**Only three quick-log actions.** Period, symptoms, sex. Everything else is one level
down. Femio's `quickLog` in `ExperienceConfig` currently carries more than three for
several personas; three is the discipline to aim for.

**Content is on the home screen, twice.** "My daily insights" and "Suggested for you"
are both content rows above the fold-and-a-half. Flo's home is a tracker *and* a feed.

**The visual language is soft-organic.** Peach-to-pink gradient wash with large blob
shapes, generous whitespace, big circular buttons, everything rounded — set against
high-contrast dark editorial cards in the carousel. The contrast between the calm
background and the loud cards is the whole composition.

**Bottom nav is five tabs, two of which are social.** "Secret Chats" and "Messages"
sit beside Today, Insights and Partner. Flo's home is a community product as much as
a tracker.

### "Insights" is not what the name suggests

The Insights tab is a **content library** — search, topic chips ("Am I pregnant?",
"Orgasms and pleasure", "Vaginal discharge"), a "Most popular" row, then category
rows. There is no chart on it. Flo's actual data visualisation lives deeper, in cycle
details, cycle history and the BBT chart.

This corrects chapter 06 §E: Flo's charts are not a headline surface either. The
delight in their product is carried by illustration, motion and editorial cards, not
by data graphics. **That means TD-01 is not just parity work — a genuinely good
chart layer would be a differentiator, not a catch-up.**

**But the tab itself is the best model in the study for our Learn section** (owner
direction, 2026-08-23). Strip its subject matter — the "Sex & pleasure" row and its
articles are out of scope for Femio per §6 — and the *structure* is exactly what
`/learn` on femioapp.com and the app's content surface should become:

| Element | Why it works |
|---|---|
| Search at the top | 105 articles, a glossary and a conditions library, and today no way to search any of it (TD-14) |
| Topic chips as questions | "Am I pregnant?" is an entry point; "Pregnancy" is a filing cabinet. Question-shaped chips are how people actually arrive |
| "Most popular" row | Social proof that costs nothing and orients a first-time reader |
| Category rows below | Browse for people who did not arrive with a question |
| Bold illustrated cards | Each article is a designed object, not a list row with a title |

Ours would carry the things they cannot: a citation count, the reviewing clinician's
name, a review date, and the four languages. Bright and useful, in a restrained
register — the visual energy comes from illustration, colour and card design, not
from the subject matter.

## 4. The symptom panel

The `SymptomsPanel` UIC element, rendered:

- A date navigator (`‹ Today ›`) — log for any day without leaving
- **Search across every trackable**
- "Categories" with an **Edit** action — she can reorder and hide categories, which
  is the `core.reordable` module doing its job
- One white rounded card per category, containing pill chips
- Every chip has a bespoke icon and a category tint — `eventSex` pink, `eventMood`
  orange, exactly as the token table predicted

Default category order puts "Sex and sex drive" first and "Mood" second.

Structurally this is the best logging screen in the study and Femio should match its
*mechanics*: search, per-day navigation, user-reorderable categories, one card per
category, iconed chips. All of that is tone-neutral.

## 5. Monetisation, measured

### The free/paid line, in Flo's own words

After purchase the app shows a four-card carousel headed "Exclusive to Premium":

| # | Premium feature |
|---|---|
| 1 | **Know your body better** — understand emotions, cravings and body changes when you log |
| 2 | **Discover 1,000+ articles** — expert-led articles, videos and courses |
| 3 | **Connect with your partner** — partner mode |
| 4 | **Unlock expert support** — decode cycle and symptoms with expert tips and daily insights |

So free gets you: tracking, the calendar, predictions, and a limited content feed.
Paid gets you: interpretation of what you logged, the full content library, partner
sharing, and the assistant. **The paywall sits exactly at the point where the app
starts telling you something back.**

That is worth staring at, because Femio's pattern engine, screeners and visit pack
all sit on the paid side of that line by Flo's logic — and they are the things we
argue are the product.

Note also the content asymmetry: 1,000+ articles against our 105 authored / 31 live.

### Prices, localised to Egypt

The emulator's Play account resolved to Egyptian pricing:

| Plan | Price | Effective |
|---|---|---|
| Yearly — "SAVE 40%" | EGP 929.99 / 12 mo | EGP 77.50 / mo |
| Monthly | EGP 129.99 / mo | — |

Roughly USD 19/year or USD 2.65/month. That is the real price point in our primary
market, not a US list price — useful input whenever billing is un-deferred.

### The paywall's construction

A "Not sure yet? Enable free trial." switch (not a separate flow), a yearly/monthly
toggle with the yearly plan pre-selected and its monthly-equivalent shown beside the
total, three rotating user reviews with names, and a close button that is present but
small. Post-purchase there is *another* offer — "A gift just for you. Open the box to
reveal your offer." — before the app opens.

### Owner direction, 2026-08-23 — the model

Khaled: *a very basic app should be free, enough to hint at the capabilities and
build interest, then monetise.* Freemium with a genuinely useful free tier, and the
specific payment model to be decided later. Recorded here so chapter 09's block 6 has
the constraint; the detailed model is out of scope for this study.

## 6. Owner direction on tone — and how it changes chapters 07 and 08

Khaled, on seeing Flo's sexual content, 2026-08-23:

> Femio is professional and conservative in register. **No "sex" or "anal sex"
> logging categories.** Where the fact matters clinically we mark it as an
> **intercourse** or **conception** day, with conservative wording in every
> language. We are not a sexual-education or sexual-wellness platform. Anything
> educational of that kind belongs in an article or a short, conservative tip —
> never as a product surface.

This is a firmer line than chapter 07 drew, and it amends **TD-06** outright.

**What Femio logs.** A single conservative marker — *intercourse* / *conception
attempt* — carrying the date and nothing else. That is all the fertility engine
needs: `lib/fertility` already computes from dates, and there is no clinical use for
act type. No ten-chip category, no "sex and sex drive" panel, no orgasm or
masturbation entries.

**What stays, because it is a symptom and not a lifestyle.** Painful intercourse
(dyspareunia), vaginal dryness, bleeding after intercourse, pelvic pain, discharge
changes, and libido change *when it is a marker* of perimenopause, postpartum
recovery or a medication side effect. These are in the persona specs already, they
are what a clinician asks about, and they belong in the symptom vocabulary under
their clinical names.

**Translation is part of the rule, not an afterthought.** "Intercourse" and
"conception day" must be rendered conservatively in Arabic, French and Spanish —
this is a `femio-i18n-workflow` matter and a `docs/13` matter, not a copywriting
detail. A term that reads as clinical in English and as crude in Arabic fails the
rule.

**Education has one home: content.** Sexual and reproductive health can be covered
in `docs/16`'s conditions library and in articles, cited and clinician-reviewed,
written in a restrained register. It never becomes a tracker category, a home
module, a goal option or a daily-insight card.

For the record, and it supports the position rather than undermining it: **Flo itself
gates this content.** One onboarding step asks *"Do you want to see sex-related
questions?"* before any of it appears. Even the least conservative product in the
category treats it as opt-in. Femio going further — clinical facts in, lifestyle
content out — is a defensible product position in every market we serve, and the
decisive one in MENA.

## 7. What this chapter changes elsewhere

| Chapter | Amendment |
|---|---|
| 01 | Method now includes a running app and therefore server contact; no account created, no purchase made by Claude |
| 02 §3 | The nine bundled goals are historical; the live set is eight and half of it is midlife |
| 02 §13 | Live consent names **AppsFlyer, Firebase and TikTok Ad Manager** — broader than the bundled strings showed |
| 06 §E | Flo's charts are not a headline surface; a strong chart layer is a differentiator for us, not just parity |
| 07 TD-06 | Sexual-health scope narrowed to clinical symptoms only, per owner direction |
| 07 TD-09 | Onboarding target sharpened: keep the rhythm, reject the selling |
| 08 D3 | More urgent — Flo already sells the clinician bridge without the substance to back it |
| 09 | Freemium constraint recorded for the monetisation block |

## 8. Still not captured

The dashboard was seen in its empty state only — no period was logged, so the
prediction ring, the cycle-day copy and the two-tier probability calendar from
chapter 02 §7 were not observed live. Cycle details, cycle history, the BBT chart and
the assistant were not opened. Partner mode was entered accidentally at first and
then abandoned. None of the perimenopause or pregnancy tracks were walked.

If more is wanted, the emulator is still running with a subscribed account and the
next pass is cheap.
