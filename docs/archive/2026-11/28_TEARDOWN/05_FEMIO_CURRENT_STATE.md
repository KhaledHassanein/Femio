# 28.05 — Femio, measured

Everything here is counted from the repository at commit `c1123e1` on 2026-08-23,
not taken from `docs/STATE.md` or the master TODO. Where a doc claims something the
code does not show, this chapter reports the code. The point of the exercise is to
have one set of numbers that can be set beside chapter 02's without argument.

## 1. The shape of the thing

```
apps/web     Next.js 15 — 40 page routes, 144 .tsx files, 2 API routes
apps/cms     Payload — 8 collections (Articles, Conditions, FAQs, Glossary,
             Media, People, Tips, Users)
supabase     14 migrations, 27 tables
assets/brand 144 design tokens
docs         73 persona specs, 69 ADRs, 105 authored articles
```

Seventy test files under `apps/web/src`, plus golden fixtures in `fixtures/domain`.

## 2. Routes

Fifteen application routes behind auth:

```
dashboard · track · tools · fertility · appointments · medications
patterns · screeners · summary · sharing · shared-with-me · settings
mfa · admin/insights · admin/translations
```

Twenty public routes: home, about, learn (+ `[slug]`), conditions (+ `[slug]`),
authors (+ `[slug]`), glossary, faq, five calculators (BMI, cycle length, due date,
fertile window, gestational age), editorial-policy, medical-review, privacy, terms.
Five more for auth and onboarding: welcome, sign-in, reset-password, help-now,
components.

**One dashboard route.** Every persona's home screen is the same URL rendering a
different served document — which is the architecture working as designed, and is
the thing chapter 02 says Flo spent years migrating toward.

## 3. The experience engine — our strongest asset

`lib/experience` is 2,909 lines and `lib/persona` is 2,100, making them by a wide
margin the two largest modules in the codebase. That ratio is worth noting: more
code goes into deciding what to show than into any single thing being shown.

The contract in `lib/experience/types.ts`:

```ts
ExperienceConfig {
  version, resolvedAt,
  track, personaId, modifiers[], emotionalContext[], confidence,
  offer:      { personaId, confidence } | null,
  transition: { id, to, personaId } | null,
  phase,
  home:    { modules: ModuleSpec[], quickLog: LogKind[] },
  tools:   LogKind[],
  content: ContentSkin,
  alerts:  AlertSpec[],
  emrView: string[],
  tone
}
```

`ModuleSpec` is `{ id, emphasis, params? }`. There are **54 module ids** across six
tracks:

| Track | Modules |
|---|---|
| A — adolescent | `teen.reassurance`, `teen.window`, `teen.worthMentioning`, `teen.body`, `teen.readiness`, `teen.privacy` |
| B — cycle & gynae | `cycle.window`, `cycle.variability`, `cycle.phase`, `cycle.flowStrip`, `cycle.personalNormal`, `cycle.changeAwareness` |
| C — trying to conceive | `ttc.window`, `ttc.logSummary`, `ttc.workup`, `ttc.conditionContext` |
| D — pregnancy | `pregnancy.week`, `.milestone`, `.appointments`, `.weight`, `.movement`, `.contractions`, `.birthPrep`, `.warningSigns`, `.screeningPrep` |
| E — menopause | `menopause.trend`, `.since`, `.marker`, `.symptomStrip`, `.longTerm`, `.pmb` |
| F / cross-cutting | `strip.glucose`, `strip.thyroid`, `strip.medication`, `strip.labs`, `strip.devices`, `followup.schedule`, `thyroid.watch`, `support.checkIn`, `support.moodScreener`, `support.moodSupport`, `support.intrusiveThoughts`, `support.feeding`, `support.breastSymptoms`, `support.lossAware`, `support.reassurance` |

**24 personas are registered** in `lib/experience/registry/` (A1, A2, B1, B5, B6,
C1, C2, C3, C6, C8, D1, D2, D3, D4, D7, E1, E2, E3, E4, E6, E7, F1, F2, Z1) against
**73 specced** in `docs/personas/`. Roughly one in three of the taxonomy we wrote is
wired to anything.

The three-source resolution in `client.ts` — Edge Function, then local cache, then
the identical tier-1 code running in the browser — is genuinely good engineering and
has no analogue in any of the three apps. It is also, per its own comment, working
around the Edge Function not being deployed yet.

## 4. Data model

27 tables:

```
profiles · persona_state · adaptation_events · cycles · symptom_logs
fertility_logs · pregnancy · key_dates · contractions · fetal_movement_sessions
vitals · labs · meds_supplements · appointments · screener_results
conditions_flagged · notification_prefs · push_subscriptions · partner_links
consent_records · audit_log · staff_roles · subscriptions
content · content_history · content_i · ui_strings
```

Every table now holds real data — that was the R3 milestone and it is done. The
model is broader than any competitor's: none of the three has `labs`,
`meds_supplements`, `screener_results`, `conditions_flagged`, `consent_records` or
`audit_log`, and none has a partner-sharing model with per-recipient consent.

## 5. Design tokens

144 tokens in `assets/brand/tokens/femio.tokens.css`. The families:

| Family | Count | Notes |
|---|---|---|
| Colour ramps | 24 | `violet`, `rasp`, `teal`, `amber`, `red`, `neutral` at 50/300/600/900 |
| Semantic colour | ~40 | `primary-*` (12), `text-*` (10), `accent-*` (10), `surface-*` (6), `on-*` (4), `border-*` (4), `state-*` (4), `success-*` (4) |
| **Phase** | 5 | Cycle phases as tokens |
| Gradient | 7 | |
| Shadow | 7 | |
| Typography | ~12 | `font-ui`, `font-display`, **`font-ar`**, `font-mono`, `fs-*`, `fw-*`, `lh-*`, `ls-*` |
| Spacing / radius | ~10 | `space-*`, `radius-*` |
| Motion | 4 | `ease-*` |

Two things we have that Flo does not: a dedicated Arabic typeface token (`font-ar`)
and cycle-phase tokens. Several things Flo has that we do not: per-event-category
colours, illustration skin tones, avatar backgrounds, chart active/inactive pairs,
button hover and pressed states, and a named focus-ring colour.

144 tokens against Flo's nine token *files* is the honest ratio. Ours is a palette
with some semantics; theirs is a system.

## 6. Charts and data visualisation — the thinnest surface

**One chart component exists in the entire codebase**: `components/pregnancy/weight-chart.tsx`,
209 lines. There is no charting library in `apps/web/package.json` — no Recharts, no
D3, no visx, no Chart.js.

Flo ships six chart surfaces natively plus three server-driven chart element types.
Femio ships one weight chart. Against Khaled's stated priority — "delightful views
and dashboards and info and graphics" — this is the single largest measured gap in
the study.

## 7. Tracking vocabulary

`lib/cycle/symptoms.ts` carries roughly 24 keys: acne, anxious, backache, bloating,
calm, constipation, cramps, cravings, diarrhea, dizziness, fatigue, happy, headache,
insomnia, irritable, nausea, sad, spotting, tearfulness, tingling, tinnitus, plus
mood and other.

Flo carries 47 symptoms, 16 moods, 11 discharge types and 10 sex/libido entries —
84 loggable concepts to our 24. Mood is mixed into the symptom list for us rather
than being its own dimension, and we have no discharge or libido vocabulary at all.

Where we are ahead: `lib/patterns` (410 lines) does timing, co-occurrence and
severity with confidence scoring, which none of the three apps attempts. Flo's 84
concepts are a flat list; our 24 are analysed.

## 8. Screeners

Three validated instruments in `lib/screeners`: **EPDS** (Edinburgh Postnatal
Depression Scale), **MRS** (Menopause Rating Scale), and a mood screener. All
scored, banded, and phrased as "screening — discuss with your clinician" per
product rule 1.

Flo has a symptom checker (`feature.symptomchecker`) and a wellbeing level, but no
validated clinical instrument is visible anywhere in its binary. This is a real and
defensible Femio advantage, and it is currently three screens deep with no
discoverability.

## 9. Content

105 articles authored in `docs/content/articles/`, including **37 pregnancy week
articles covering weeks 4 through 40** — comparable coverage to the pregnancy
tracker's 40, with far better structure: every file carries SEO frontmatter
(`search_intent`, `primary_query`, `secondary_topics`, `meta_title`,
`meta_description`, `canonical_url`, robots directives for draft and published
states), and the pipeline enforces citations and clinician bylines.

But every one of those 105 files is `status: "draft"` and `locale: "en"`. The live
article count — `CLAUDE.md` says 31 — is a CMS/Supabase fact, not a repository one,
so it is the single number in this chapter taken on trust rather than counted. **The content layer
is English-only.** The UI is fully four-language; the medical content is not. That
gap is not visible in `docs/STATE.md` and it undercuts the Arabic-first position
more than anything else in this chapter.

## 10. Internationalisation — where we are genuinely first

1,836 message keys, in perfect parity across `en.json`, `ar.json`, `fr.json` and
`es.json`. That is 7,344 translated strings shipping in the client.

Flo ships 2,422 strings in a single hardcoded English file with
`android:supportsRtl="false"`. The pregnancy tracker ships English and French with
only 140 strings externalised at all. GO Flo has a complete French translation and
a 40-string Arabic stub.

**No competitor in this study has a real Arabic translation, and the market leader
does not mirror its layout for RTL.** Our i18n workflow, the RTL-native component
work in `docs/22`, and `font-ar` are the most defensible thing we have built.

## 11. What else exists that competitors lack

`lib/partner` (475 lines) with per-recipient named consent (ADR-069) — Flo has
partner mode but no evidence of granular per-recipient consent. `lib/consent`,
`lib/observability`, an `audit_log`, staff MFA and RBAC (`docs/18`), k-anonymous
insights, an offline queue, export and delete. `lib/notifications` (342 lines) from
P2.8. Five public calculators. A conditions library, glossary, editorial policy and
medical-review pages — the entire trust apparatus that none of the three apps has
any equivalent of.

## 12. The honest summary

Femio's decision layer is better than anything in the three apps. Its data model is
broader. Its i18n is in a different league. Its trust and privacy apparatus has no
competitor equivalent, and its screeners and pattern engine are genuinely ahead.

Femio's *surface* is the problem. One chart. 24 loggable concepts. Eleven pregnancy
tools missing. No animation layer. No remote config or experiments. No wearable or
platform-health input. Two-thirds of our own persona taxonomy unwired. Content in
one language.

We have built the engine and most of the chassis, and almost none of the body.
