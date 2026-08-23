# 28.03 — Pregnancy Tracker (com.teamthree), torn down

`com.teamthree.pregnancytracker` 1.0.20. A small, modern, unobfuscated Jetpack
Compose app built on feature-based Clean Architecture. Where Flo is the study in
scale and machinery, this is the study in **how much product one small team can ship
without any design-system investment at all** — and it is the more uncomfortable
comparison, because its feature set is closer to what Femio's pregnancy experience
should already be.

Its Kotlin `@Metadata` annotations survive decompilation intact, so original
parameter names, property names and source file names are all readable. Tracing a
flow in this binary is nearly as easy as reading source.

## 1. Architecture

```
com.teamthree.pregnancytracker
  core/        ads, config, notifications, premium, util
  data/        articles, local (dao, datastore, db, entity), model, repository
  features/    calendar, growth, guide, home, intro, legal, onboarding,
               premium, profile, tools
  navigation/  AppNavGraph, Routes, AppBottomNavItem, BottomNavItem
  ui/theme/    ColorKt
```

Single-activity Compose with a Navigation-Compose graph. Only 13 XML layouts remain
in the whole APK; everything else is Compose. Room for local persistence, DataStore
for preferences, RevenueCat for subscriptions, AdMob for advertising, and
`pairip` — Google Play's automatic integrity protection — wrapping it.

## 2. Navigation: 24 routes

`Routes.java` is a flat constant list, which makes the entire IA readable in one
screen:

```
onboarding · home · growth · tools · guide · calendar · profile
kick_counter · contraction_timer · weight_tracker · symptom_tracker
appointment_tracker · my_questions · my_question_topic · todo
shopping_list · hospital_bag · birth_plan · notes · baby_names
article_detail · reminders · premium
```

Six of those are bottom-nav destinations (`home`, `growth`, `tools`, `guide`,
`calendar`, `profile`); eleven are tools; the rest are content and account.

## 3. Onboarding: four steps

`OnboardingStep` is an enum with exactly four values:

```
WELCOME → METHOD_CHOICE → LMP_INPUT | DUE_DATE_INPUT
```

Ask the user whether they know their due date or their last menstrual period, take
the one they know, done. Against Flo's 442 steps this looks trivial — and it is —
but it is worth noting that it gets a user to a working dashboard in four screens.
Flo optimises for segmentation and conversion; this optimises for time-to-value.
Femio's wizard should be honest about which of those it is optimising for, because
right now it does neither especially well.

There is a separate `features/intro` with an `IntroPage` model, so the marketing
carousel is distinct from the data-capture flow.

## 4. The eleven tools — the real substance

This is where the app earns its place in the study. Each tool is a proper feature
with its own repository and, notably, its own metrics object:

| Tool | Backing |
|---|---|
| Kick counter | `KickSession` + `KickSessionDao` + `KickCounterRepository` |
| Contraction timer | `ContractionSession` + `ContractionSessionDao` + `ContractionTimerRepository` |
| Weight tracker | `WeightEntryEntity` + `WeightDao` + `WeightRepository` |
| Symptom tracker | `SymptomEntryEntity` + `SymptomDao` + `SymptomRepository` |
| Appointment tracker | `AppointmentEntryEntity` + `AppointmentDao` |
| Birth plan | `BirthPlanData`, `BirthPlanOptions`, `BirthPlanState`, `SavedBirthPlan` |
| My questions | Questions to ask your clinician, grouped by topic |
| To-do | Trimester-aware task list |
| Shopping list | |
| Hospital bag | |
| Baby names | |

Five of those are session/entry-based with real Room persistence. The birth plan is
a structured document with saved state, not a note field. "My questions" — a place
to collect questions for your next appointment, organised by topic — is a small,
obvious, genuinely useful feature that Femio does not have and should.

The kick counter and contraction timer are the two tools that define a credible
third-trimester product. Femio has both — `components/pregnancy/contraction-timer.tsx`
(187 lines, backed by `lib/contractions` and the `contractions` table) and
`components/pregnancy/movement-counter.tsx` (229 lines, backed by
`fetal_movement_sessions`). What Femio does not have is the other nine: birth plan,
my questions, to-do, shopping list, hospital bag, baby names, and a symptom tracker
scoped to pregnancy.

## 5. Content: 40 weekly articles, hardcoded

`data/articles/week/` contains `Week10Article.java` through to week 40 — forty
article classes compiled into the binary. The content model is clean:

```
PregnancyWeekData {
  weekNumber, trimester,
  babySize, babyLengthCm, babyWeightGrams,
  developmentSummary, momBodyChanges, nutritionNote,
  fullArticle
}
```

Three separate registers per week — what the baby is doing, what the mother's body
is doing, and a nutrition note — plus a size comparison and hard measurements. That
is a better-shaped weekly content model than a single article body, and it maps
directly onto what a pregnancy home card needs.

The guide is organised into five categories: `babydevelopment`, `firsttrimester`,
`healthsafety`, `lifestyle`, `mentalhealth`. Mental health as a top-level content
category in a small pregnancy app is worth noting.

The cost of hardcoding: no CMS, no medical review workflow, no citations, no
versioning, and every content fix requires an app release. Femio's Payload CMS with
clinician bylines is unambiguously the better architecture here — this is one of the
few places where we are ahead by design rather than behind.

## 6. Design: stock template tokens, per-screen metrics

`ui/theme/ColorKt` defines exactly six colours:

```
Purple80  PurpleGrey80  Pink80
Purple40  PurpleGrey40  Pink40
```

Those are the **unmodified Android Studio Compose project template colours**. The
team shipped a feature-rich pregnancy app and never touched the theme file.

But the picture is not simply "no design system", and the nuance matters. Every
screen and tool has a companion metrics data class — `HomeMetrics`,
`ToolsMetrics`, `KickCounterMetrics`, `ContractionTimerMetrics`,
`WeightTrackerMetrics`, `SymptomTrackerMetrics`, `AppointmentTrackerMetrics`.
`HomeMetrics` carries:

```
screenHorizontalPadding, screenVerticalPadding,
sectionSpacing, heroImageHeight, maxContentWidth
```

So they *do* have a systematic approach to spacing and responsive layout — including
a `maxContentWidth` for large screens — it is just expressed per screen instead of
as shared tokens. This is the classic shape of a codebase that solved layout
consistency without solving visual identity.

**The lesson for Femio is the inverse of Flo's.** Flo says: invest in tokens, and
the surfaces cohere. This app says: you can ship eleven working tools and forty
articles on template colours, and users will still use it. Feature depth and visual
polish are separable investments, and we currently have neither at the depth this
11 MB app has.

## 7. Monetisation and advertising

RevenueCat with two plan types, `MONTHLY` and `YEARLY`. And `core/ads` with AdMob:

```
AdMobInitializer · AdUnitIds · AdsManager · AppOpenAdManager
InterstitialManager · MrecAdPool · BannerAdViewKt · SuccessInterstitialAd
```

App-open ads, interstitials, banners, and a pool of MREC placements. The class named
`SuccessInterstitialAd` is the one to sit with: an interstitial shown *after the user
completes something successfully*. In a pregnancy app, that means an ad after
logging a kick count.

The manifest requests `AD_ID`, `ACCESS_ADSERVICES_AD_ID`,
`ACCESS_ADSERVICES_ATTRIBUTION` and `ACCESS_ADSERVICES_TOPICS`.

Femio's product rule 4 forbids ad-SDK access to health data outright. This app is the
concrete illustration of what that rule is protecting against, in a product that is
otherwise well-built and well-intentioned.

## 8. Notifications and reminders

`core/notifications` has `ReminderScheduler`, `ReminderReceiver`,
`ReminderRescheduler` and `ReminderRescheduleReceiver`, with
`SCHEDULE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED` and `POST_NOTIFICATIONS`. Reminders
survive reboot and reschedule themselves — the boring correctness that makes a
reminder feature trustworthy. Femio's P2.8 reminders work should be checked against
exactly this behaviour.

## 9. Localisation

The XAPK ships `config.en.apk` and `config.fr.apk`. English and French only, no
Arabic, no RTL content. `supportsRtl="true"` is declared, so the layout would mirror
if a translation existed.

`values/strings.xml` holds only 140 strings, which for an app with 24 screens means
most user-facing text is hardcoded in Compose composables. That is a localisation
debt that gets more expensive every release, and it is the specific mistake Femio's
`femio-i18n-workflow` skill exists to prevent.

## 10. Summary judgement

A genuinely competent product. Eleven working tools, forty weeks of structured
content, clean architecture, sensible reminders, responsive metrics — shipped by
what is evidently a very small team. It beats Femio's current pregnancy experience
on tool depth and on weekly content structure.

It loses on everything that requires investment over time: no design system, no CMS,
no medical review, no citations, two languages, no personalisation beyond the
trimester, and an advertising layer that would be disqualifying for us.

The single most useful thing to take from it is the **tool inventory**. Those eleven
tools are the price of entry for a credible pregnancy product, and Femio has
appointments and weight and nothing else.
