# App Store Optimization: target keywords for the initial release (1.0.0), Saudi Arabia and Egypt first

Researched 2026-11-25. Method and limits are stated first because they decide how far to trust the lists.

## What the evidence is, and is not

- **Observed**: the first 19 to 23 titles Google Play returned for ten searches (public Play search pages fetched on 2026-11-25; the fetch tool may not have honoured the `gl=SA` / `gl=EG` country switch, so country differences are **not verified**). A title's position shows who ranks, not how many people search.
- **No search-volume numbers were found.** Google Play does not publish keyword volumes and no paid ASO tool was run (cost). Every priority below is an **estimate** from rank, title patterns and common sense. To get numbers: Play Console, Statistics, "Search terms" (after launch), or a tool such as AppTweak or Sensor Tower [NEEDS SOURCE for any volume claim].
- Competitor listings were read for patterns only. No text is copied.
- Play indexes the title, short description and full description (plus the developer name). Keywords repeated more than a handful of times in the full description are not rewarded and risk the metadata policy; none is stuffed here.

## Competitor patterns (observed on Play search pages, 2026-11-25)

| App | Title as returned | Pattern worth noting |
|---|---|---|
| Flo | "Flo Period & Pregnancy Tracker" (EN); "Flo مُتتبع الدورة الشهرية" (AR) | Brand first, two category nouns, then "Tracker". The Arabic listing is separately titled, not transliterated |
| Clue | "Clue: Period & Cycle Tracker" (EN); "Clue حساب الدوره الشهريه" (AR) | Arabic title uses the colloquial spelling without the hamza and ta marbuta (الدوره), which matches how many people type |
| Premom | "Ovulation Tracker App - Premom"; "الدورة، الإباضة، والحمل-Premom" | Keywords first, brand last, in both languages |
| Ovia | "Ovia Cycle & Pregnancy Tracker" | Same shape as Flo: brand, Cycle, Pregnancy, Tracker |
| Arabic-market apps | "الملكة حاسبه الدوره والحمل" (Madar Software); "حياة - حاسبة الدورة الشهرية" (Wachanga); "Velle: حاسبة الحمل والتبويض" | Brand plus "حاسبة" (calculator) plus cycle and pregnancy words |

Patterns across the 20 Arabic results for the Saudi "حاسبة التبويض" search: 10 titles contain حاسبة or حاسبه, 3 more contain حساب; الإباضة and التبويض are both common (the two words mean the same thing, so both are needed); many titles are generic keyword strings from small publishers with no brand. In the English "ovulation tracker" search, titles are "[Brand]: Period/Ovulation/Cycle & Pregnancy Tracker". For PCOS the results are small niche apps, with "PCOS Tracker" and "Period Tracker, PCOS" the common forms, so there is room for a period tracker that treats PCOS well.

Opportunity: no Arabic result found combined "private, no account" with cycle tracking in the title, and Arabic searchers see mostly "حاسبة". femio's title does not contain حاسبة. Test it (see the last section).

## Placement rules used

- **T** = title (30 characters), **S** = short description (80), **F** = full description (4,000). Several mentions of a term in F are fine; the first screen of F matters most.
- The wordmark is always Latin "femio". Arabic uses Western digits.
- Never use "free", "best", "#1", claims of accuracy, or contraception words (the title and short description are also checked by `pnpm store-lint`).

## Arabic (SA and EG): 24 keywords

| # | Keyword | Where | Priority (estimate) | Basis |
|---|---|---|---|---|
| 1 | الدورة الشهرية | T (الدورة), S, F | very high | in every Arabic result set |
| 2 | التبويض | T, S, F | very high | top of the SA result list; our title |
| 3 | حاسبة التبويض | F ("حاسبة أيام الخصوبة"), test in T/S | very high | 10 of 20 SA titles contain حاسبة |
| 4 | الإباضة / الاباضة | F (الإباضة beside التبويض) | high | in 7 of the 21 EG titles |
| 5 | متابعة الحمل | F | very high | SA pregnancy search: most titles |
| 6 | حاسبة الحمل | F | very high | same |
| 7 | الحمل | T, S, F | very high | our title |
| 8 | تتبع الدورة / تتبّعي | S | high | in S: تتبّعي الدورة والتبويض والحمل |
| 9 | أيام الخصوبة | F | high | no title contained it, so low competition |
| 10 | نافذة الخصوبة | F | medium | estimate; seen in an App Store snippet as "نافذة الإباضة", not in any Play title |
| 11 | تكيس المبايض | F (heading), articles | medium to high | EG PCOS search shows Arabic apps ranking on it |
| 12 | الدورة غير المنتظمة | F (heading) | medium | |
| 13 | موعد الولادة / حاسبة موعد الولادة | F | high | |
| 14 | الحمل أسبوعًا بأسبوع | F | high | "دليل الحمل الآمن أسبوع بأسبوع" ranks high in SA |
| 15 | مؤقت الانقباضات / مؤقت التقلصات | F | medium | Arabic timer apps ("مؤقت التقلصات", "مؤقت تقلصات الولادة") surfaced in the EG PCOS search; both words are in use |
| 16 | حركة الجنين | F | medium | |
| 17 | محاولة الحمل | F (heading) | medium | |
| 18 | اختبارات التبويض | F | medium | |
| 19 | تقويم الدورة | F | medium | "تقويم" appears in titles |
| 20 | زيادة الوزن أثناء الحمل | F | low to medium | the app has this calculator |
| 21 | الحمل والولادة | F | low | |
| 22 | خصوصية / بلا حساب | F, S ("بلا حساب") | differentiator | no ranked title used it |
| 23 | تاريخ هجري | F | low | femio-specific |
| 24 | حساب الدورة (الدوره الشهريه, colloquial) | not placed yet | medium | Clue and Arabic apps use it; decide after Play's "Search terms" data |

Notes: (a) Whether Play ignores Arabic diacritics (تتبّعي vs تتبعي) is **not verified**; the short description uses the shadda form, so keep the plain spelling in F as well if a test shows a difference. (b) Saudi and Egyptian usage looks similar in these lists; a dialect split is **not verified**.

## English: 22 keywords

| # | Keyword | Where | Priority (estimate) |
|---|---|---|---|
| 1 | ovulation tracker | T ("Ovulation"), F | very high |
| 2 | period tracker | S, F | very high |
| 3 | pregnancy tracker | S, F | very high |
| 4 | pregnancy week by week | F | high |
| 5 | fertile window | F | high |
| 6 | ovulation calculator | F | high |
| 7 | due date calculator | F | high |
| 8 | cycle tracker / cycle tracking | F | high |
| 9 | period calendar | F | medium |
| 10 | trying to conceive (TTC) | F | high |
| 11 | PCOS tracker | F | medium |
| 12 | irregular periods | F | medium |
| 13 | fertility tracker | F | high |
| 14 | pregnancy calendar | F | medium |
| 15 | contraction timer | F | medium |
| 16 | baby movement / kick log | F | low |
| 17 | pregnancy weight gain | F | low |
| 18 | private period tracker / no account | S, F | differentiator |
| 19 | ovulation test (LH) log | F | medium |
| 20 | women's health | F | medium |
| 21 | symptom tracker | F | low |
| 22 | Hijri calendar | F | low |

Avoid "birth control" and "avoid pregnancy" terms: femio is not contraception.

## French: 20 keywords

suivi des règles (S), ovulation (T), grossesse (T), calendrier menstruel (F), calculateur d'ovulation (F), jours fertiles (F), fenêtre de fertilité (F), suivi de grossesse (F), grossesse semaine par semaine (F), date d'accouchement (F), calculateur de grossesse (F), SOPK (F), cycles irréguliers (F), projet bébé (F), essayer de concevoir (F), minuteur de contractions (F), mouvements du bébé (F), application règles (F), confidentialité / sans compte (S, F), calendrier de grossesse (F). All priorities are estimates; no French result set was sampled.

## Spanish: 20 keywords

seguimiento de la regla (S: "Regla"), calendario menstrual (F), período (F, added once), ovulación (T), embarazo (T), días fértiles (F), ventana fértil (F), calculadora de ovulación (F), embarazo semana a semana (F), fecha probable de parto (F), calculadora de embarazo (F), seguimiento del embarazo (F), SOP / ovario poliquístico (F), ciclos irregulares (F), buscar embarazo (F), prueba de ovulación (F), temporizador de contracciones (F), movimientos del bebé (F), sin cuenta / privada (S, F), calendario del embarazo (F). Regional spelling (regla in Spain, período or menstruación in Latin America) is **not verified** per market; femio's first markets are not Spanish-speaking, so this is the lowest priority. No Spanish result set was sampled.

## Top 5 per language (for the report)

- **Arabic:** الدورة الشهرية, التبويض, الحمل, متابعة الحمل, حاسبة التبويض
- **English:** ovulation tracker, period tracker, pregnancy tracker, fertile window, due date calculator
- **French:** suivi des règles, ovulation, grossesse, calendrier menstruel, date d'accouchement
- **Spanish:** ovulación, embarazo, calendario menstrual, días fértiles, fecha probable de parto

## Changes made to the listings from this research

- AR full description: added "(الإباضة)" beside التبويض and "حاسبة أيام الخصوبة".
- ES full description: added "(período)" once.
- Short descriptions carry "تتبّعي الدورة والتبويض والحمل" / "Period, ovulation & pregnancy tracker" / "Règles, ovulation, grossesse" / "Regla, ovulación y embarazo".

## One test worth running after launch (Play Console, Store listing experiments)

Arabic title A (current): `femio: الدورة والتبويض والحمل` (29). Title B: `femio: حاسبة الدورة والتبويض` (28). The word حاسبة leads most competitor titles but is a calculator promise, while femio is a tracker with honest ranges; B must not suggest a single "calculated" date, so run it only if the lead and owner accept the wording. Success measure: store listing conversion for Saudi and Egyptian visitors over at least 14 days, read from Play Console, not estimated here.

## Sources

- Play search pages fetched 2026-11-25: `https://play.google.com/store/search?q=حاسبة التبويض&c=apps&hl=ar&gl=SA`, `...?q=حاسبة الحمل والتبويض...&gl=EG`, `...?q=متابعة الحمل أسبوع بأسبوع...&gl=SA`, `...?q=تكيس المبايض...&gl=EG`, `...?q=ovulation tracker...&gl=SA`, `...?q=pregnancy tracker week by week...&gl=EG`, `...?q=pcos...&gl=EG`.
- Play Console Help, store listing limits: https://support.google.com/googleplay/android-developer/answer/9859152
