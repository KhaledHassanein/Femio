# 28.02 — Flo, torn down

`org.iggymedia.periodtracker` 10.3.0. 35,196 classes. 157 activities of its own.
119 `core.*` modules, 79 `feature.*` modules, 149 feature-flag classes. 1,880 vector
drawables. An onboarding flow with 442 steps and 634 conditional transitions.

Those numbers are the honest headline. Everything `docs/23` and `docs/26` said about
Femio being thin is true, and this is the thing it is thin *against*. But scale is
not the interesting part of Flo — the interesting part is that almost none of it is
hand-built screens. Flo's engineering bet, made visibly over several years, is that
the client should be a renderer and the server should own the product. That bet is
the same one ADR-060/061 makes for Femio, which means Flo is not just a competitor
here; it is a working reference implementation of our own architecture, several
years further down the road.

## 1. Two generations, and a migration in progress

Flo's source has a visible fault line. There is a legacy layer at
`org.iggymedia.periodtracker.p915ui.*` — `EditCalendarActivity`, `BbtChartActivity`,
`WeightChartActivity`, `PasscodeActivity`, `NotificationsActivity`, the whole
`pregnancy.start.*` family — written the old way, one activity per screen with a
presenter behind it. And there is a modern layer at
`org.iggymedia.periodtracker.feature.*`, one module per feature, with dependency
injection boundaries between them.

Cutting across both is a third pattern, and it is the one to pay attention to.
Several screens exist twice, once native and once with a `Uic` in the name:

```
feature.calendar.screen.CalendarScreenActivity        feature.calendar.uic.UicCalendarActivity
feature.personalinsights.cycledetails.CycleDetailsActivity    ...CycleDetailsUicActivity
feature.personalinsights.cyclehistory.CycleHistoryActivity    ...CycleHistoryUicActivity
feature.overview.FeaturesOverviewActivity             ...UicFeatureOverviewActivity
```

"UIC" is Flo's UI Constructor. Each of those pairs is a screen mid-migration from
native code to a server-delivered document. Flo is not planning to move to
server-driven UI; it is most of the way there, screen by screen, with both
implementations shipping simultaneously behind a flag.

**The lesson for Femio.** `docs/24` framed the experience engine as a rewrite we
have to finish. Flo's binary says it is a migration you can run one screen at a
time, keeping the native implementation alive beside the served one until the served
one wins. That is a materially cheaper path than the one we have been assuming, and
it is the single most useful architectural finding in this study.

## 2. The experience engine

Flo's UI Constructor lives at `core.p602ui.constructor` and serialises to a JSON
document. Its element vocabulary is roughly 65 types, extracted from
`core/p602ui/constructor/data/remote/model/*Json.java`:

**Layout and structure** — `FlexContainer`, `EdgeContainer`, `Layered`,
`ViewThatFits`, `Spacer`, `Deck`, `UiList`, `Aspect`, `LayoutParams`

**Content** — `Text`, `Image`, `ImageLocal`, `Lottie`, `Rive`, `VideoPreview`,
`ScrollableImage`, `Slideshow2`, `ExpandableContent`, `Shimmer`, `Blur`

**Input** — `Button`, `ToggleButton`, `Switch`, `Slider`, `TextField`, `DatePicker`,
`SelectableItem`, `SelectionBlock`, `Signature`, `CodeInput`

**Domain-specific** — `EditableCalendar`, `SymptomsLogPanel`, `SymptomsSelection`,
`SymptomsStatic`, `SymptomsToggle`, `SymptomsSelectionButton`,
`CarouselLogSymptomsButton`, `TemperatureChart`, `TemperatureDayWidget`,
`ScoreChart`, `ProgressCircular`, `SymptomCheckerIntentHeader`

**Commerce** — `Premium`, `PremiumNonRenewable`, `PremiumFeature`, `CompactPaywall`

**Assistant and social** — `AskFloHeader`, `AskFloHeader2`, `AskFloSearch`,
`AskFloTutorialAnchor`, `StoriesCarousel`, `StoriesAnimatorContainer`

**Survey** — `QuizSelectorContainer`, `QuizSelectorContainerOption`,
`QuizTemplateText`, `Commitment`

### The element contract

Every element, regardless of type, carries the same envelope. Read off
`ScoreChartJson` and `TemperatureChartJson`, it is:

| Field | Purpose |
|---|---|
| `visible` | Static visibility |
| `visibilityAnimation` | How it enters and leaves |
| `style` | A style object typed per element (`StyleJson$Text`, `StyleJson$Button`, ...) |
| `layoutParams` | Positioning within its container |
| `accessibility` | Label and role, as data — not an afterthought |
| `actionClick` | What tapping it does |
| `floatingMenu` | Long-press / contextual menu |
| `impressionConfig` | Analytics impression tracking, declared per element |
| `onFirstAppearance` | Fires once when first seen |
| `onVariableChanged` | Reactive binding to a named variable |
| `output` | The variable this element writes |

This envelope is worth studying closely, because it is small, complete, and solves
four problems Femio has not yet solved. Accessibility is part of the contract rather
than something a developer remembers. Analytics impressions are declared where the
element is declared, so a served screen cannot ship untracked. `output` plus
`onVariableChanged` give a whole screen a reactive local state model without any
client code. And `style` being typed per element means the server cannot send a
button style to a text node.

**For Femio:** our `ExperienceConfig` module registry should adopt this envelope
shape — designed from our own tokens and our own analytics schema (`docs/19`), but
with the same eleven concerns, and specifically with `accessibility` and
`impressionConfig` mandatory rather than optional. This is the highest-value
structural borrowing in the study.

## 3. Onboarding is a 442-step state machine

`res/raw/onboarding.json` is 868 KB and is the single most instructive artifact in
the binary. It is the *local fallback* copy of a document Flo normally fetches, and
its shape is:

```
{ survey_id, survey: { steps, transitions, presentation_settings } }
```

`steps` is a map of 442 step ids to step definitions. `transitions` is a list of 634
edges. Together they are a directed graph with conditional branching — which is to
say, exactly the wizard-resolver-state machine `docs/09_MASTER_ADAPTATION_MODEL.md`
describes for Femio, expressed as data rather than code.

### Step types

| Count | Type | What it is |
|---|---|---|
| 124 | `feature_card` | A sell/teach card — the bulk of the flow |
| 90 | `question` | A branching question with an answer set |
| 65 | `empty` | Transitional / loading beat |
| 59 | `uic` | A full UI-Constructor screen embedded in onboarding |
| 23 | `announcement` | Social proof, milestones |
| 21 | `notification_permission` | Permission asked *in context*, 21 different times |
| 8 | `user_value` | Structured value capture (height, weight) |
| 8 | `user_goal` | Goal selection |
| 7 | `promo` | Paywall |
| 7 | `feature_card_with_list` | Card variant |
| 5 | `fullscreen_resource` | Full-bleed animation |
| 5 | `finish` | Terminal states — five of them, one per track |
| 3 | `auth` | Account creation |
| 3 | `intro_completion` | |
| 2 each | `user_pregnancy_calendar`, `user_birth_year`, `code_input`, `calendar`, `text_value` | Typed capture |
| 1 each | `initial`, `personalization`, `user_birth_month`, `user_pregnancy_week` | |

The ratio is the finding: **124 teaching/selling cards to 90 questions**. Flo's
onboarding is not a form with some decoration. It is a guided narrative in which
questions are the minority, and after most answers the app says something back —
teaching, reassuring, or showing what it will do with the answer. Femio's wizard is
a form.

Twenty-one separate `notification_permission` steps is the other number worth
sitting with. Flo does not ask for notifications once at a system-chosen moment. It
asks at twenty-one different points in twenty-one different narrative contexts, and
the graph decides which one you reach.

### Transitions

Each edge is minimal:

```json
{ "in": "android_tier0_uic_pregnant_symptoms",
  "out": "android_en_pregnant_feature_card_know_the_signs",
  "progress": 0.76 }
```

with an optional condition:

```json
{ "in":  "android_en_track_prototype_v3_survey_health_conditions",
  "out": "android_en_track_prototype_v3_feature_card_health_condition_1",
  "condition": ["onb_track_health_conditions_pcos|onb_track_health_conditions_fibroids|onb_track_health_conditions_bv|onb_track_health_conditions_endometriosis|onb_track_health_conditions_yeast_infections|onb_track_health_conditions_uti"],
  "progress": 0.535 }
```

Three things to take from this. Conditions are string tags OR-ed within an entry and
AND-ed across the array — there are 141 distinct tags across the whole graph, and no
expression language, no operators beyond that. It is deliberately too simple to
express anything clever, which is why it can be authored by non-engineers and
validated cheaply. Second, `progress` is precomputed per edge rather than derived,
so a branch that skips ten steps still shows an honest bar. Third,
`presentation_settings` is per-survey (`closable`, `show_progress`,
`enable_back_navigation`), not per-step.

**For Femio:** our persona resolver should serialise to this shape. Tags, not
expressions. Precomputed progress. A resolver expressed as data is a resolver a
clinician can review, and `docs/09` has always wanted that without saying how.

### What the graph reveals about their segmentation

The step ids are self-describing, and reading 442 of them gives Flo's entire
segmentation for free:

- **Tracks** — `tc` (cycle tracking), `ttc` (trying to conceive), `pregnant`,
  `perimenopause`/`peri`, plus `intro`
- **Partner mode** — a parallel set: `pm_tc`, `pm_ttc`, `pm_pregnant`, `pm_parent`.
  An entire onboarding written for the *partner* of a user
- **Age cohorts** — `user_goal_30_39`, `user_goal_40_plus`
- **Experiment arms shipping concurrently** — `track_prototype_v3`,
  `track_prototype_v4`, `legal_exp_relaunch`, `v2_high_level`
- **Locale tiers** — `tier0` versus `en`: different flows for different market tiers
- **Device capability** — `high_level_device`, `high_performance_device`. Heavy
  animated steps are served only to phones that can render them

That last one deserves a sentence of its own. Flo authors two versions of the same
onboarding beat, one animated and one not, and routes by device capability. It is a
small thing that says a great deal about how seriously they take the animated layer:
it is important enough to build twice.

### The nine goals

`res/raw/` carries nine goal animations, which are the entry point to everything
downstream:

`track_my_period` · `get_pregnant` · `track_my_pregnancy` · `understand_my_body` ·
`decode_my_discharge` · `enhance_my_sex_life` · `explore_contraception` ·
`manage_my_weight` · `none_of_above`

Two observations. "Decode my discharge" and "enhance my sex life" are goals most
health apps would not put on an early screen, and they are precisely the ones that
signal the app is not squeamish. And `none_of_above` exists, with its own animation —
the refusal path is designed, not a dead end. Femio's Z1 fallback persona in
`docs/08` is the same idea; Flo gives it artwork.

### Voice

One question, quoted because the voice is the point:

> **How are you feeling about what's coming up?**
> *Pregnancy can be an exciting but often overwhelming time — so we're checking in.*
> Excited to be on this journey! / A bit unsure or unprepared / Worried or stressed /
> Happy, nervous and excited — all at the same time! / I don't know

Each answer carries an emoji. The subtitle explains *why* the question is being
asked. "I don't know" is a first-class answer. This is not a form; it is a
conversation, and the copy was written by someone who was given room to write.

## 4. Remote config, experiments, and the supplier chain

`core.featureconfig` models a feature as `feature_id` plus `dependencies`,
`experiments`, and `suppliers`. There are 149 `Feature*` classes in the binary.
The supplier chain is the notable part: a feature's value is resolved through an
ordered list of suppliers, so a remote value can override a local one which
overrides a compiled default, and a feature can declare dependencies on other
features so that turning one off cascades correctly.

Alongside it sit `core.experiments`, `core.targetconfig` and `core.variables`.
Between them, and combined with the onboarding graph's concurrently-shipping
experiment arms, Flo can run several product variants against several market tiers
against several device classes at once, without a release.

Femio has none of this. We have no remote config, no experiment framework, and no
kill switches. For a product whose medical content and thresholds must be
changeable without an app-store review cycle, that is a structural gap rather than
a feature gap — and ADR-060/061 already imply we need it.

## 5. The design system

`org.iggymedia.periodtracker.design` is a first-class module with a real token
system. Its files are `ColorToken`, `SpacingToken`, `RadiusToken`, `BorderToken`,
`TypographyToken`, `ShadowToken`, `GradientToken`, `BrushToken`, `TransitionToken`,
plus `DesignSystemColorPalette`, `DesignSystemGradientPalette`,
`DesignSystemShadowPalette`, `FloTypography`, `FloTypographyCompose`,
`GradientDescriptor`, and a `DelicateDesignSystemApi` opt-in annotation guarding the
escape hatches. There is a `compose/` subpackage and a `wear/` one — the design
system spans phone, Compose and Wear OS.

### Scales, mid-migration

Spacing carries two parallel scales, which is what a token migration looks like
frozen in a binary:

```
legacy:  spacing0x spacing0_5x spacing1x spacing2x ... spacing16x spacing20x spacing30x spacing40x
current: spacing0 spacing050 spacing100 spacing200 ... spacing1600 spacing2000 spacing2500 spacing3000 spacing4000
```

Radius does the same (`radius0x ... radius5x` beside `radius0, radius050, radius100
... radius600`, plus `radiusFull`), and so does border (`border0x ... border3x`
beside `border0, border050, border100, border200, border300`). The numeric scale is
the destination; the `Nx` scale is what they are migrating off. Femio's
`assets/brand/tokens/femio.tokens.css` should be checked against this: if we are
still on a multiplier scale, we are starting where Flo is trying to leave.

### Typography is stock Roboto

Nineteen named styles: `titleLargeBold`, `title1Bold`, `title2Bold`, `title3Bold`,
`title3Regular`, `headlineSemibold`, `headlineRegular`, `bodyBold`, `bodySemibold`,
`bodyRegular`, `footnoteBold`, `footnoteSemibold`, `footnoteRegular`,
`caption1Semibold`, `caption1Regular`, `caption2Bold`, `caption2Regular`.

The typeface behind them is **Roboto** — the Android system font — shipped as ten
static files including a `roboto_medium_numbers.ttf` for tabular figures in charts
and counters.

This is worth stating plainly because it cuts against an instinct. The global market
leader in this category has no custom brand typeface in its Android app. Its visual
identity is carried entirely by colour, illustration and motion. Femio's brand work
in `docs/12` is therefore not behind on type; the place to spend is the other three.

### The colour system is the real asset

`DesignSystemColorPalette` is where Flo's design investment actually shows. The
tokens are semantic, not literal, and they are organised by *what the thing means in
this product* rather than by hue. The families:

| Family | Examples | What it tells us |
|---|---|---|
| Surface | `backgroundBase`, `backgroundPrimary/Secondary/Tertiary`, `backgroundMinor`, `backgroundClear`, `backgroundWarmTint`, `backgroundHighlighted`, `backgroundColourful` | A full surface hierarchy, plus a warm tint used to soften content areas |
| **Cycle domain** | `backgroundPeriod`, `backgroundPeriodProbable`, `backgroundOvulation`, `backgroundFertility`, `backgroundDelay`, `backgroundPregnancy` | Cycle *states* are tokens. A probable period day has its own colour, distinct from a certain one |
| **Event categories** | `eventFlow`, `eventDischarge`, `eventMood`, `eventSymptoms`, `eventSex`, `eventSleep`, `eventActivity`, `eventWater`, `eventWeight`, `eventTemperature`, `eventPills`, `eventContraceptives`, `eventOvulation`, `eventPregnancy`, `eventHygiene`, `eventSwelling`, `eventNotes`, `eventOther`, `eventDefault` — each with an `...Alternate` variant | Every tracked category owns a colour, and every colour has a second variant for a different surface |
| Interactive | `buttonAccent/Hover`, `buttonContrast/Hover`, `buttonGhost/Hover`, `buttonGhostWhite/Hover`, `buttonNeutral`, `buttonPressed`, `buttonSubtleWhite` | Hover and pressed are tokens, not opacity hacks |
| Border | `borderPrimary/Secondary/Minor/Brand/Focus/Error/Success/Warning` plus `...White`/`...Black` variants | A named `borderFocus` — focus rings are designed |
| Feedback | `bannerError/Success/Warning` with `Alternate`/`Inverse` variants, `badgeAccent/Contrast/Ghost` | |
| Chat | `bubbleIncoming`, `bubbleOutgoing`, `bubbleOutgoingAlternate`, **`bubbleExpert`** | Expert messages are visually distinct from both user and system |
| Charts | `chartActivity`, `chartActivityInactive`, `chartSteps`, `chartStepsInactive` | Active/inactive pairs baked into the palette |
| **Inclusivity** | `characterSkinColorTone1` through `5`, `avatarBackground1` through `15` | Five illustration skin tones and fifteen avatar backgrounds, as tokens |
| Experiment | `expHaChat...` prefixed tokens | Even palette values ship behind experiment prefixes |

Three of these families are the ones Femio should copy the *idea* of immediately.
Cycle-state-as-token means the calendar, the home card and the chart cannot drift
apart. Event-category-as-token with an Alternate variant means a symptom keeps its
identity across every surface it appears on. And `characterSkinColorTone1-5` is a
design-system-level commitment to inclusive illustration that we have talked about
in `docs/12` and never tokenised.

Themes are `Theme.Flo.Light` and `Theme.Flo.Dark` with real `values-night`,
`values-night-v31` and `values-night-v33` resource sets. Dark mode is not an
inversion; it is authored.

## 6. Screens and information architecture

157 activities, of which the product-bearing ones group like this:

**Core loop** — `MainActivity` with tabs, `CalendarScreenActivity` /
`UicCalendarActivity` / `EditCalendarActivity` / `StandaloneCalendarActivity` /
`CalendarSettingsActivity`, `SymptomsPanelActivity` and a bottom-sheet variant.

**Insight surfaces** — `CycleDetailsActivity` and `CycleDetailsUicActivity`,
`CycleHistoryActivity` and `CycleHistoryUicActivity`, `TimelineActivity`,
`TemperatureInsightsActivity`, `WellBeingLevelActivity` and
`WellBeingLevelWithChatActivity`.

**Charts** — `GraphsActivity`, `BbtChartActivity`, `WeightChartActivity`,
`WaterChartActivity`, `ActivityChartActivity`, `CycleLengthChartActivity`.

**Content** — `StandaloneFeedActivity`, `TopicActivity`, `VerticalFeedActivity`,
`StoriesActivity`, `VideoActivity`, `ImageViewerActivity`, `SearchActivity`,
`SeeAllActivity`, `ContentPreferencesActivity`.

**Assistant and screening** — `VirtualAssistantActivity`, `VaImageActivity`,
`AskFloContentActivity` and `AskFloContentActivityV2`, `AllConditionsActivity`,
`ConditionIntentPageActivity`, `StartNewChatActivity`.

**Social** — `SocialGroupsActivity`, `SocialGroupDetailsActivity`,
`SocialCommentsActivity`, `SocialRepliesActivity`, `SocialExpertBlogActivity`,
`SocialBookmarksActivity`, `SocialUserProfileActivity`, and five profile editors
including `EditSocialUserBackgroundActivity` and `EditSocialUserTagsActivity`.

**Life stage** — the whole `pregnancy.*` family (`PregnancyActivationActivity`,
`PregnancyWeekSelectActivity`, `PregnancySettingsActivity`,
`PregnancyDetailsActivity`, `PregnancyFinishActivity`,
`PregnancyEditFinishedActivity`, `BabyBornActivity`, `PregnancyBanActivity`),
plus `GoalSwitcherActivity` for moving between tracks.

**Home-screen widget** — `PregnancyWidgetConfigurationActivity`. Flo ships an
Android home-screen widget for pregnancy.

**Account, privacy, security** — `AnonymousModeStatusActivity`,
`EnableAnonymousModeActivity`, `AppLockPromoActivity`, `PasscodeActivity`,
`CheckPasscodeActivity`, `MfaActivity`, `ConsentsManagementActivity`,
`GdprActivity`, `ManageUserDataActivity`, `AccountDeletionActivity` and
`AccountDeletionSurveyActivity`, `RestoreUserDataActivity`.

**Commerce and growth** — `SubscriptionHubActivity`, `HtmlPromoActivity`,
`PaymentIssueActivity`, `FamilySubscriptionManagementActivity`,
`JoinFamilyActivity`, `GetReferralCodeActivity`, `SignUpPopupActivity`,
`SignUpPromoSplashActivity`, `CreateAccountActivity`, `InAppReviewActivity`,
`PartnerModeModalActivity` plus cancel/stop dialogs.

**Integrations** — `SetupHealthConnectActivity`, `DataSourcesActivity`,
`HowToManageActivity`, `HealthConnectRationaleActivity`,
`ConnectOuraRingSettingsActivity`.

One detail from the manifest worth copying: Flo ships three launcher-icon aliases —
`flo_ic_launcher`, `flo_ic_launcher_premium`, `flo_ic_launcher_sale` — and enables
them conditionally. The app icon on the home screen changes when you are a premium
subscriber or when a sale is running.

## 7. Dashboards, charts and data visualisation

Flo's charts split across the same two generations as everything else.

The legacy charts are native activities: BBT, weight, water, activity, cycle length,
and a `GraphsActivity` hub. The modern ones are UIC elements — `TemperatureChart`
(with a `TemperatureChartStates`/`TemperatureChartStateIcon` model, so the chart's
states and their icons are server-described), `ScoreChart` (with `lineWidth` and
`progress` in its style), `ProgressCircular`, and `TemperatureDayWidget`.

No third-party charting library is bundled. Every chart is drawn by Flo, which is
why the chart tokens (`chartActivity`, `chartActivityInactive`, `chartSteps`,
`chartStepsInactive`) sit in the design system rather than in a wrapper.

The information layer around the calendar is more interesting than the charts
themselves. The prediction copy distinguishes four states on a single day:

| String key | Copy |
|---|---|
| `day_info_panel_legend_high_probable_period_day_description` | "Your period is likely to start on this day." |
| `day_info_panel_legend_future_low_probable_period_day_description` | "Future cycle: Your period may start on this day." |
| `day_info_panel_legend_fertile_day` | "Predicted fertile window" |
| `day_info_add_cycle_delay_prognose` | "The next cycle is likely to start with a delay of {count} days" |

"Likely to start" versus "may start" is a two-tier probability band rendered on the
calendar, with a `{learnMore}` link on each legend entry. Fertility language is
deliberately non-contraceptive throughout — "Low chance of getting pregnant",
"Chance to get pregnant", "High chance of getting pregnant", never a safe/unsafe
binary.

**This matters for our positioning.** Femio's product rule 3 — uncertainty-honest
predictions with ranges and confidence — is not the differentiator we have assumed.
Flo already ships a version of it. We are not introducing honesty to this category;
we are competing on how well it is done. Chapter 08 has to say what "better" means
here, concretely, rather than restating the principle.

There is also a designed offline state: "Flo is offline. Connect to the internet to
refresh and restore your cycle predictions. Tap to refresh." Predictions degrade
visibly rather than silently.

## 8. Motion and the delight layer

`res/raw/` contains Flo's own Lottie animations. Stripping out the timezone data and
CMS-delivered media leaves about 50 files, and the list is a precise map of where
Flo decided motion was worth paying for:

**Tracking feedback** — `event_flow_light`, `event_flow_medium`, `event_flow_heavy`;
`event_fluid_dry`, `event_fluid_sticky`, `event_fluid_creamy`,
`event_fluid_eggwhite`, `event_fluid_watery`, `event_fluid_bloody`,
`event_fluid_unusual`. Ten animations whose entire job is to make logging a period
flow level or a cervical-fluid type feel like something happened.

**Prediction and state change** — `anim_cycle_day_prediction_update`,
`day_update_animation_redesign`, `day_update_animation_sex`,
`day_improving_process_white`.

**Onboarding** — nine goal animations, `welcome_animation`, `onboarding_privacy_shield`
and `onboarding_max_track_prototype_privacy_shield`.

**Gamification** — `streak_bolt`, `streak_unfreeze`.

**System states** — `loader_simple`, `error_white`, `error_wifi_white`,
`check_white`, `typing_indicator`, `bookmark_saved_tutorial`,
`notify_available_groups_animation`, `skippable_checkout`.

Two things stand out. First, the *privacy shield* is an animation — Flo made privacy
a visual moment in onboarding rather than a paragraph. Second, no `.riv` files ship
in the APK despite a `core.rive` module and a `Rive` UIC element, which means Rive
animations are fetched at runtime and can be changed without a release.

The 18 `.glsl` shaders in `res/raw/` are from Media3's video transformer, not Flo's
own work — worth noting only so a future reader does not mistake them for a custom
rendering layer.

## 9. What Flo lets you track

**47 symptoms**, spanning life stages in one flat vocabulary: abdominal pain, acne,
backache, bladder leaks, bleeding gums, bloating, brain fog, burning mouth,
constipation, cramps, cravings, decreased appetite, diarrhea, dizziness, dry eyes,
dry hair, dry skin, exhaustion, fatigue, food aversions, frequent urination, hair
loss, headache, heartburn, hormonal therapy, hot flashes, hyperpigmentation,
increased appetite, insomnia, joint pain, leg cramps, milky nipple discharge,
nausea, night sweats, normal digestion, normal stool, palpitations, perineum pain,
sleepiness, stretch marks, swelling, tender breasts, vaginal dryness, vaginal
itching, vomiting — plus "Everything is fine" as an explicit positive log.

The composition is the signal: perimenopause symptoms (hot flashes, night sweats,
brain fog, vaginal dryness, burning mouth, bladder leaks, dry eyes/hair/skin, joint
pain, palpitations) and pregnancy/postpartum symptoms (perineum pain, milky nipple
discharge, stretch marks, heartburn, food aversions) sit in the same list as cycle
symptoms. One vocabulary spans the life stages — which is Femio's "constant EMR,
additive layers" rule, implemented.

**16 moods** — anxious, apathetic, calm, confused, depressed, energetic, feeling
guilty, frisky, happy, irritated, low energy, mood swings, obsessive thoughts, sad,
very self-critical.

**11 discharge types** — clumpy white, creamy, egg white, gray, increased discharge,
no discharge, spotting, sticky, unusual, watery.

**10 sex and libido entries** — anal sex, oral sex, sensual touch, sex toys, orgasm,
no orgasm, painful sex, low sex drive, neutral sex drive.

That sex vocabulary is a positioning statement. Femio will need to decide
deliberately, not by default, how much of it we carry across four languages and
several conservative markets — and `docs/13` is where that decision belongs.

## 10. Content, community and the assistant

Flo's content stack is `core.content`, `core.cards`, `core.cardconstructor`,
`core.cardslist`, `core.feed`, `core.topics`, `core.stories`, `core.search`, plus
`feature.feed`, `feature.verticalfeed`, `feature.stories`, `feature.video`. The
bundled CMS media files are named `contentful_media_resource_*`, so their CMS is
Contentful. Content is delivered as constructed cards, not as articles with a
template — the same engine that renders the home screen renders the feed.

Community is `feature.social`: groups, comments, replies, bookmarks, an expert blog,
and a profile with an avatar constructor (`feature.avatarconstructor`), background
image, nickname and tags. Ninety-six `community_*` and ninety-four `social_*`
strings.

The assistant is `feature.virtualassistant` plus `feature.ask` and
`feature.askflotab`, with `feature.messages` behind it and a `bubbleExpert` colour
token for expert replies. Its disclaimer is one line: *"Created with the help of AI.
Not medical advice."* Its empty state is instructive — *"Log your signs and symptoms
to get the chats that are most relevant to you"* — the assistant is positioned as a
consumer of tracked data, not a chatbot bolted on.

`feature.symptomchecker` with `AllConditionsActivity` and
`ConditionIntentPageActivity` is a screener surface, and `feature.wellbeing` scores
a wellbeing level with an optional chat attached.

## 11. Integrations

Flo reads 21 Health Connect data types: menstruation, intermenstrual bleeding,
cervical mucus, ovulation test, sexual activity, basal body temperature, body
temperature, heart rate, resting heart rate, heart rate variability, sleep, steps,
distance, exercise, active calories, total calories, weight, height — and it holds
`READ_HEALTH_DATA_IN_BACKGROUND`. There is a dedicated `feature.ouraconnector` for
Oura ring, `core.wear`/`core.wearable` for Wear OS, and `core.googlehealth`.

Femio has no wearable or platform-health integration at all. For a tracking product
this is the largest single category of user-supplied data we are not accepting.

## 12. Monetisation

`core.premium` with a supervisor and a debug API, `core.purchase`/`core.purchases`,
`core.billing`, `feature.subscriptionhub`, `feature.promo` with an HTML promo
activity, `feature.scheduledpromo`, `feature.signuppromo` (popup, splash and
registration variants), `feature.paymentissue`, `feature.family` (family plan
management and join), `feature.referralprogram`, and `feature.rateme` /
`feature.inappreview`.

On the UIC side there are four commerce elements — `Premium`, `PremiumNonRenewable`,
`PremiumFeature` and `CompactPaywall` — so paywalls are server-composed and can be
restructured without a release. The paywall copy is heavily ICU-pluralised, with
trial duration, tier, discount and billing period all interpolated from a single
string, which is what a paywall looks like when it is A/B tested constantly.

The free-trial toggle deserves a note: *"Not sure yet? Enable free trial"* is a
switch on the paywall, not a separate flow.

## 13. Privacy and security

Flo's flagship privacy feature is **Anonymous Mode** — a first-class account state,
with `AnonymousModeStatusActivity`, an `EnableAnonymousModeActivity` wizard, and
seventy-nine `anonymous_*` strings. It is honest about its cost, in its own copy:

> "Your account will be deleted and cycle and symptoms data transferred to a new
> Anonymous Mode account. Some data during transfer will be lost (eg. notes or
> bookmarks) but cycle data and symptoms will be transferred fully."

Illustration content-descriptions for the three states — a woman holding a black hat
and dark glasses, putting them on, then finger to lips — show the feature was
designed as a character moment rather than a settings toggle.

Beyond it: app lock with passcode (`PasscodeActivity`, `CheckPasscodeActivity`,
`AppLockPromoActivity`), MFA, biometric unlock (`core.biometric`), granular consent
management, a GDPR flow, `ManageUserDataActivity`, account deletion with an exit
survey, and a screenshot detector (`core.screenshotdetector`).

The honest counterweight: Flo asks for consent to cross-app tracking via AppsFlyer,
in the app, with the dialog title *"Your body, your data"*. The consent text is
explicit about age-group, subscription status and technical identifiers going to
AppsFlyer and its partners. It is consented and it is disclosed — and it is still an
ad-attribution SDK in a menstrual-health app. **Femio's product rule 4 forbids this
outright, and that is a genuine, defensible difference we can state publicly.**

## 14. Localisation and RTL — the finding

Flo 10.3.0 ships **zero `values-<lang>` resource folders**. All 2,422 strings sit in
the default `values/strings.xml`. The only `values-ldrtl` file contains two arrow
drawables inherited from Material Components, not Flo's own work. And the manifest
declares:

```xml
android:supportsRtl="false"
```

Localisation happens at runtime through `core.localization`
(`Localization`, `MutableLocalization`, `LocalizationApi`, plus an `interpreter`)
and `core.icu`, with strings delivered from the server. The `tier0` versus `en`
split in the onboarding graph is the market-tier machinery around it.

So: Flo can serve translated strings, but the Android app does not mirror its layout
for right-to-left languages. **Arabic-native, RTL-first is not a catch-up feature for
Femio. It is open ground against the market leader.** This is the strongest
competitive finding in the study and it should shape how we talk about the product
in MENA.

## 15. Where Flo is weak

Worth recording, because the gap register in chapter 07 runs both ways.

The legacy layer is real technical debt — `p915ui.*` still owns the passcode,
notifications, several pregnancy flows and most charts, and those screens are
visibly a generation behind the UIC ones. Two implementations of the calendar, cycle
details and cycle history ship simultaneously, which is a migration cost they are
carrying in every release.

The onboarding at 442 steps has an obvious failure mode: it is long, and 124 selling
cards against 90 questions means a lot of it is marketing. There is no evidence in
the binary of a fast path for a returning or expert user.

Symptom, mood and discharge vocabularies are flat lists with no severity, no
duration, no free-text structure and no co-occurrence model. Femio's pattern engine
(P2.5) is genuinely ahead here.

There is no clinician-facing surface and no export for a doctor's appointment.
**Corrected by chapter 10 §6b:** this section originally claimed Flo has no
citations. It does — its served articles carry numbered markers and a full
References list with DOIs. What it does not carry is a named reviewing clinician, a
review date or an editorial policy, which is the narrower and defensible form of our
advantage.

And the localisation gap above is not just RTL: an app that ships one hardcoded
string file and translates at runtime has no translator workflow visible in the
client, no plural rules per locale at build time, and a hard dependency on network
for correct copy.
