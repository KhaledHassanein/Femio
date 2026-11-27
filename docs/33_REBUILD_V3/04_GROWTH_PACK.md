# 04 — Growth pack: SEO, ASO and the first 100 women (opened 2026-10-27)

**Owner:** Growth lead (Opus 5.5) under `00_PLAN.md` §0. **Status:** draft for the lead's review; nothing here is live until the lead applies it through the content pipeline (R3), the teaser (R2) and the Play listing (R5).

**What this is.** Everything the soft launch needs to be found: the positioning, the Arabic-first keyword map for Saudi Arabia and Egypt, title tags and FAQ questions for the 7 calculators and the 20 wedge pages, the Google Play listing in Arabic and English, a plan for the first 100 women, and the technical SEO checklist for the static teaser.

**Sources read:** `CLAUDE.md`; `00_PLAN.md`; `docs/32_STUDY/00_SYNTHESIS.md`; study reports 07 and 08; `docs/archive/2026-11/30_REVAMP/02_MARKET_RESEARCH_2026-10.md` (§6 distribution, §6.3 keyword candidates, §10.3 positioning); `docs/archive/2026-11/30_REVAMP/delegated/2026-10-08-competitor-benchmark.md`; `docs/17_TECHNICAL_SEO.md`; `apps/web/src/lib/content/topics.ts`; `apps/web/src/lib/seo/{config,metadata,jsonld}.ts`; `apps/web/src/app/sitemap.ts` and `robots.ts`; `apps/web/messages/{en,ar}.json` (calculator titles); `docs/content/articles/ramadan-fasting-pregnancy{,.ar}.md`; the `femio-seo-aso` skill.

**Labels.** **Checked** = verified today (2026-10-27). **From the docs** = a repo file says so. **Hypothesis** = my reading. **[NEEDS SOURCE]** = no number we can cite. **[NEEDS CHECK]** = a platform rule to confirm in the console before relying on it.

**Search volumes: none in this pack are measured.** The Ahrefs MCP answered `Insufficient plan` on 2026-10-27 (Checked), the same result the October research got (`02` §12), and Semrush has no API units. Every volume cell is therefore **[NEEDS SOURCE]**. Rank order in §2 is judgement from competitor pages and the October candidate list, not data. §2.4 says how to get real numbers for $0.

---

## 0 · Decisions this pack takes (each with a default, per the owner's rule)

| # | Decision | Default | Why |
|---|---|---|---|
| G1 | Slugs across locales | **Same ASCII slug in every locale** (`/ar/learn/pcos-and-fertility`) | The Arabic drafts already do this (`ramadan-fasting-pregnancy.ar.md` canonical). Arabic slugs percent-encode into 80-character strings when shared on WhatsApp, which is our main sharing layer. This overrides `docs/17` §2 ("localized slugs"); the lead should note it there |
| G2 | Arabic locale code | **One `ar`**, not `ar-SA` / `ar-EG` | One MSA text serves both markets; dialect words go inside the page (§2.3), not in a second URL set |
| G3 | `x-default` | **`/en`** (as coded today) | English is the only complete set until the wedge is in Arabic. Revisit when Arabic covers the wedge |
| G4 | Play category | **Health & Fitness**, not Medical | "Medical" reads as a clinical tool, against rule 1 |
| G5 | Play target audience | **18 and over** | Teen mode is out of v1; an under-18 audience brings the Families policy into scope |
| G6 | Arabic name of the ovulation calculator | **"حاسبة التبويض (الإباضة)"** | The live AR title is "حاسبة الإباضة" (Checked in `ar.json`). Egyptians write التبويض; Gulf and MSA pages use both. One title carries both words |
| G7 | Paid acquisition in v1 | **None**: no ads, no paid creators | $0–50/month budget; Saudi paid promotion needs a Mawthooq-licensed creator (`02` §6.2); health-targeted ads are restricted |
| G8 | Wordmark in titles | Store and Arabic surfaces: **femio** (Latin, lower case). English web titles keep the coded template `%s — Femio` | S8 in the study; the English template is already shipped and tested |

---

## 1 · Positioning and the three messages

**Positioning line (EN).** femio is the private, Arabic-first companion for trying to conceive and pregnancy: honest ranges instead of promises, physician-written guidance with its sources, and records that never leave your phone.

**Positioning line (AR).** femio رفيقتكِ الخاصة من محاولة الحمل حتى الولادة، بالعربية أولًا: تقديرات أمينة تُظهر لكِ المدى لا يومًا واحدًا، ومعلومات كتبها طبيب مع مصادرها، وسجلاتكِ لا تغادر هاتفكِ.

**Register rules for every line in this pack.** Conservative and clinical: no sexual-wellness framing, no "get pregnant fast", no baby-sex prediction, no "safe days". Never "guaranteed", "accurate to the day", "diagnose", "treat". Feminine address in Arabic (تابعي، اعرفي، سجلاتكِ). Western digits in Arabic. The word "contraception" never appears in marketing copy; the one mandated sentence ("not a method of birth control") appears only where `docs/compliance/HEALTH_APP_CLAIMS_AND_DATA_SAFETY.md` requires it.

| # | Message | English | Arabic | Proof the product must carry |
|---|---|---|---|---|
| M1 | **Privacy** (the differentiator) | Your records never leave your phone. No account, no cloud, no ads reading your health. | سجلاتكِ لا تغادر هاتفكِ. بلا حساب، بلا سحابة، وبلا إعلانات تقرأ بياناتكِ الصحية. | No network calls with health data; encrypted store, app lock, user-saved backup (R4); Play Data safety "no data collected" |
| M2 | **Honesty** | Estimates you can trust, not promises. Your fertile days as a range, and no "late" counter when cycles are irregular. | تقديرات أمينة لا وعود. أيام خصوبتكِ كنطاق، وبلا عدّاد للتأخير حين تكون دورتكِ غير منتظمة. | Rule 3 in the domain layer; irregular/PCOS mode (the study flags the 14-day fertile-window bug for PCOS cycles: fix before this claim ships) |
| M3 | **In your language, by a physician** | Written in Arabic for you, by a physician, with sources, from the first try to the last week of pregnancy. | بلغتكِ، بقلم طبيب ومع المصادر، من أول محاولة حتى آخر أسبوع في الحمل. | Arabic wedge articles reviewed (R3); every article lists sources and reviewer |

Tagline candidates carried from `02` §10.3 for testing in social posts (not yet reviewed by a native editor): "صحتكِ، بلغتكِ، بخصوصية تامة" and "من أول محاولة حتى أول لحظة مع طفلكِ".

---

## 2 · Keyword map (Arabic first, then English)

### 2.1 How to read the table

**Intent:** **C** = calculator (she wants a number now), **L** = learn (she wants an answer), **A** = app (she wants a tool to keep). **Page** = the URL that should rank: an existing slug at `/ar/learn/<slug>`, a hub at `/ar/conditions/<slug>`, a calculator at `/ar/calculators/<slug>`, `/ar/app`, or **to write**. Today every Arabic article is **to translate** (0 Arabic articles live, Checked in the synthesis), so "existing slug" means "the English page exists; the Arabic version must ship before this query can rank". **EG / Gulf** = the wording each market tends to type (Hypothesis from competitor pages and common usage; confirm with Play search terms after launch, §2.4). **Vol** = monthly volume; all **[NEEDS SOURCE]**. **P** = priority for the soft launch (1 = ship Arabic page first).

### 2.2 The Arabic map (57 queries)

| # | Arabic query (MSA head term) | Gloss | Int | Page | EG variant | Gulf variant | Vol | P |
|---|---|---|---|---|---|---|---|---|
| 1 | حاسبة التبويض | ovulation calculator | C | calculators/fertile-window | حساب أيام التبويض | حاسبة الإباضة | [NEEDS SOURCE] | 1 |
| 2 | حساب أيام التبويض | count ovulation days | C | calculators/fertile-window | امتى التبويض بعد الدورة | متى يصير التبويض | [NEEDS SOURCE] | 1 |
| 3 | أيام الخصوبة عند المرأة | fertile days | L | fertile-window-explained | أيام التبويض للحمل | أيام الإباضة | [NEEDS SOURCE] | 1 |
| 4 | علامات التبويض | signs of ovulation | L | fertile-window-explained (add section) | علامات التبويض الأكيدة | علامات الإباضة | [NEEDS SOURCE] | 1 |
| 5 | إفرازات التبويض | ovulation discharge | L | fertile-window-explained (add section) | شكل إفرازات التبويض | إفرازات الإباضة | [NEEDS SOURCE] | 2 |
| 6 | اختبار التبويض | ovulation test (OPK) | L | **to write**: ovulation-tests | شرايط التبويض | جهاز الإباضة | [NEEDS SOURCE] | 2 |
| 7 | ألم التبويض | ovulation pain | L | **to write** (section of fertile-window-explained) | وجع التبويض | ألم الإباضة | [NEEDS SOURCE] | 3 |
| 8 | أفضل أيام لحدوث الحمل | best days to conceive | L | fertile-window-explained | أنسب وقت للحمل بعد الدورة | أفضل وقت للحمل | [NEEDS SOURCE] | 1 |
| 9 | حاسبة الدورة الشهرية | period calculator | C | calculators/period | امتى الدورة الجاية | متى تجي الدورة | [NEEDS SOURCE] | 1 |
| 10 | حساب طول الدورة الشهرية | cycle length | C | calculators/cycle-length | الدورة كام يوم | كم يوم الدورة الطبيعية | [NEEDS SOURCE] | 2 |
| 11 | الدورة الشهرية الطبيعية كم يوم | how long is a normal period | L | is-my-period-normal | الدورة بتقعد كام يوم | كم تجلس الدورة | [NEEDS SOURCE] | 2 |
| 12 | تأخر الدورة الشهرية | late period | L | is-my-period-normal + when-to-take-pregnancy-test | الدورة اتأخرت | تأخرت الدورة | [NEEDS SOURCE] | 1 |
| 13 | تأخر الدورة مع تحليل سلبي | late period, negative test | L | **to write**: late-period-negative-test | الدورة متأخرة والتحليل سلبي | تأخر الدورة والتحليل سلبي | [NEEDS SOURCE] | 1 |
| 14 | الدورة غير المنتظمة والحمل | irregular cycles and pregnancy | L | irregular-cycles-and-timing | الدورة مش منتظمة | الدورة غير منتظمة | [NEEDS SOURCE] | 1 |
| 15 | حاسبة الحمل | pregnancy calculator | C | calculators/due-date | حساب الحمل | حاسبة الحمل بالأسابيع | [NEEDS SOURCE] | 1 |
| 16 | حساب موعد الولادة | due date | C | calculators/due-date | امتى ميعاد الولادة | متى موعد ولادتي | [NEEDS SOURCE] | 1 |
| 17 | حاسبة الحمل بالأسابيع | pregnancy weeks | C | calculators/gestational-age | أنا حامل في الأسبوع الكام | كم صار لي حامل | [NEEDS SOURCE] | 1 |
| 18 | حساب الحمل بالشهور | pregnancy in months | C | calculators/gestational-age (add month line) | أنا في الشهر الكام | كم شهر حملي | [NEEDS SOURCE] | 2 |
| 19 | حساب الحمل بالهجري | pregnancy by Hijri date | C | calculators/gestational-age (Hijri label, R2) | — (rare) | حاسبة الحمل بالهجري | [NEEDS SOURCE] | 2 |
| 20 | متى أعمل اختبار الحمل | when to test | C | calculators/pregnancy-test | امتى أعمل تحليل حمل | متى أسوي تحليل الحمل | [NEEDS SOURCE] | 1 |
| 21 | اختبار الحمل المنزلي | home pregnancy test | L | when-to-take-pregnancy-test | تحليل الحمل المنزلي | تحليل الحمل بالبول | [NEEDS SOURCE] | 1 |
| 22 | تحليل الحمل في الدم | blood hCG test | L | **to write**: pregnancy-blood-test | تحليل الدم للحمل | تحليل هرمون الحمل | [NEEDS SOURCE] | 2 |
| 23 | أعراض الحمل المبكرة | early pregnancy symptoms | L | early-pregnancy-changes | أعراض الحمل في أول أسبوع | علامات الحمل الأكيدة | [NEEDS SOURCE] | 1 |
| 24 | أعراض الحمل قبل موعد الدورة | symptoms before missed period | L | early-pregnancy-changes | أعراض الحمل قبل الدورة | علامات الحمل قبل الدورة | [NEEDS SOURCE] | 1 |
| 25 | دم الانغراس | implantation bleeding | L | **to write** (section of early-pregnancy-changes) | دم الحمل | نزول دم الانغراس | [NEEDS SOURCE] | 2 |
| 26 | غثيان الحمل | nausea | L | early-pregnancy-changes; **to write** later | الوحم | الوحام | [NEEDS SOURCE] | 2 |
| 27 | الحمل أسبوعًا بأسبوع | week by week | L | learn row "weeks" | الحمل أسبوع بأسبوع | مراحل الحمل بالأسابيع | [NEEDS SOURCE] | 2 |
| 28 | الأسبوع 12 من الحمل (pattern N = 4–40) | week N | L | pregnancy-week-N | الأسبوع 12 حمل | الأسبوع 12 من الحمل | [NEEDS SOURCE] | 2 |
| 29 | الشهر الثالث من الحمل (pattern 1–9) | month N | L | **to write**: 9 month pages linking their weeks (Hypothesis: Arabic search is month-led) | الشهر التالت حمل | الشهر الثالث | [NEEDS SOURCE] | 2 |
| 30 | متى يظهر نبض الجنين | when heartbeat shows | L | pregnancy-week-6/7 (add answer box) | امتى نبض الجنين يظهر | متى يطلع النبض | [NEEDS SOURCE] | 2 |
| 31 | متى أشعر بحركة الجنين | first movements | L | pregnancy-week-18 to 20 (+ app kick counter) | امتى الجنين يتحرك | متى يتحرك الجنين | [NEEDS SOURCE] | 2 |
| 32 | قلة حركة الجنين | reduced movements | L | pregnancy-warning-signs | الجنين مش بيتحرك | حركة الجنين قليلة | [NEEDS SOURCE] | 1 |
| 33 | علامات الخطر في الحمل | warning signs | L | pregnancy-warning-signs | علامات خطر الحمل | متى أروح الطوارئ وأنا حامل | [NEEDS SOURCE] | 1 |
| 34 | نزيف في بداية الحمل | early bleeding | L | pregnancy-warning-signs | نزول دم في الحمل | نزيف بسيط في الحمل | [NEEDS SOURCE] | 1 |
| 35 | تسمم الحمل | pre-eclampsia | L | pregnancy-warning-signs; **to write** | تسمم الحمل | ارتفاع الضغط في الحمل | [NEEDS SOURCE] | 3 |
| 36 | سكر الحمل | gestational diabetes | L | **to write**: gestational-diabetes | سكر الحمل | سكري الحمل | [NEEDS SOURCE] | 2 |
| 37 | أول زيارة للطبيبة في الحمل | first antenatal visit | L | first-pregnancy-appointment | أول زيارة لدكتورة النسا | متى أراجع الدكتورة | [NEEDS SOURCE] | 2 |
| 38 | تكيس المبايض | PCOS | L | conditions/pcos | تكيس المبايض | متلازمة تكيس المبايض | [NEEDS SOURCE] | 1 |
| 39 | أعراض تكيس المبايض | PCOS symptoms | L | pcos-signs | أعراض التكيس | علامات تكيس المبايض | [NEEDS SOURCE] | 1 |
| 40 | تكيس المبايض والحمل | PCOS and pregnancy | L | pcos-and-fertility | هل التكيس يمنع الحمل | الحمل مع تكيس المبايض | [NEEDS SOURCE] | 1 |
| 41 | تشخيص تكيس المبايض | PCOS diagnosis | L | how-pcos-is-assessed | تحاليل تكيس المبايض | سونار تكيس المبايض | [NEEDS SOURCE] | 2 |
| 42 | تكيس المبايض ومقاومة الإنسولين | PCOS and insulin resistance | L | **to write**: pcos-insulin-resistance | التكيس ومقاومة الإنسولين | — | [NEEDS SOURCE] | 2 |
| 43 | نظام غذائي لتكيس المبايض | PCOS diet | L | **to write**: pcos-lifestyle | رجيم تكيس المبايض | أكل لتكيس المبايض | [NEEDS SOURCE] | 2 |
| 44 | علاج تكيس المبايض للحمل | PCOS treatment to conceive | L | **to write**: pcos-treatment-options (what a clinician may discuss; no dosing) | علاج التكيس للحمل | علاج تكيس المبايض للحمل | [NEEDS SOURCE] | 3 |
| 45 | تأخر الحمل | delay in conceiving | L | when-to-seek-fertility-help | تأخر الإنجاب | تأخر الحمل | [NEEDS SOURCE] | 1 |
| 46 | تحاليل تأخر الحمل | fertility tests | L | fertility-tests-what-to-expect | تحاليل تأخر الإنجاب | فحوصات تأخر الحمل | [NEEDS SOURCE] | 2 |
| 47 | السن والخصوبة | age and fertility | L | age-and-fertility | الحمل بعد الخامسة والثلاثين | الحمل بعد سن 35 | [NEEDS SOURCE] | 2 |
| 48 | مخزون المبيض | ovarian reserve (AMH) | L | age-and-fertility; **to write** later | تحليل مخزون المبيض | تحليل AMH | [NEEDS SOURCE] | 3 |
| 49 | الحقن المجهري | ICSI | L | **to write**: ivf-icsi-basics | الحقن المجهري | أطفال الأنابيب | [NEEDS SOURCE] | 3 |
| 50 | حساب الحمل بعد الترجيع | due date after embryo transfer | C | **to write**: IVF dating in due-date calc (phase 2; competitors are criticised for this, benchmark §2) | الحمل بعد الترجيع | الحمل بعد الإرجاع | [NEEDS SOURCE] | 3 |
| 51 | الغدة الدرقية والحمل | thyroid and pregnancy | L | thyroid-and-conceiving | الغدة والحمل | الغدة الدرقية وتأخر الحمل | [NEEDS SOURCE] | 3 |
| 52 | حمض الفوليك قبل الحمل | folic acid before pregnancy | L | preconception-appointment (add answer box) | الفوليك قبل الحمل | حبوب الفوليك | [NEEDS SOURCE] | 2 |
| 53 | بطانة الرحم المهاجرة والحمل | endometriosis and pregnancy | L | endometriosis-and-fertility | البطانة المهاجرة والحمل | — | [NEEDS SOURCE] | 3 |
| 54 | الصيام أثناء الحمل | fasting in pregnancy | L | ramadan-fasting-pregnancy (AR draft exists, publish by 11 Jan) | صيام الحامل | صيام الحامل في رمضان | [NEEDS SOURCE] | 1 (seasonal) |
| 55 | الصيام وتكيس المبايض | fasting with PCOS | L | **to write**: ramadan-pcos | الصيام والتكيس | — | [NEEDS SOURCE] | 2 (seasonal) |
| 56 | تطبيق متابعة الحمل بالعربي | Arabic pregnancy app | A | /ar/app → Play | برنامج متابعة الحمل | تطبيق حمل عربي | [NEEDS SOURCE] | 1 |
| 57 | تطبيق حساب الدورة والتبويض | period/ovulation app | A | /ar/app → Play | برنامج الدورة الشهرية | تطبيق الدورة | [NEEDS SOURCE] | 1 |

**Do not target (register and rule 1).** الجدول الصيني لمعرفة نوع الجنين، حساب التبويض لحمل بولد أو ببنت، أيام الأمان، حبوب منع الحمل، "هل يجوز" religious rulings (the Ramadan page says plainly that a ruling is for a scholar and the health question is for her doctor), any abortion-method query. WebTeb ranks for the Chinese chart (benchmark §2); we leave it.

### 2.3 Dialect rules for writers

1. **Title and H1 in MSA; the dialect word appears once in the first 100 words and once in an FAQ.** Example: the PCOS page title says "تكيس المبايض"; the intro adds "(ويسمّى أيضًا التكيس)".
2. **Pairs to always cover on the same page:** التبويض / الإباضة; الحقن المجهري / أطفال الأنابيب; الترجيع / الإرجاع; سكر الحمل / سكري الحمل; الوحم / الوحام; ميعاد / موعد (keep ميعاد out of titles).
3. **Questions in Egyptian spelling** ("امتى", "الكام") belong in FAQ headings only when they are what women type; the answer stays MSA.
4. **Western digits everywhere** ("الأسبوع 12"), per the rejected-patterns list in `00_PLAN.md` §4.

### 2.4 How to replace [NEEDS SOURCE] with real numbers for $0

1. **Google Keyword Planner** (free with a Google Ads account, no spend): paste §2.2 column 2, location Egypt then Saudi Arabia, language Arabic. It gives ranges, enough to re-rank P1/P2. (Owner, 20 min.)
2. **Google Trends**: compare التبويض vs الإباضة, الحقن المجهري vs أطفال الأنابيب, by country. Settles G6.
3. **After launch:** Play Console search-term report and Search Console queries are our own data; replace this table's volume column at week 6 (§5.4).

### 2.5 The English map (secondary; EN pages exist, so these can rank now)

| # | Query | Int | Page | Vol |
|---|---|---|---|---|
| 1 | ovulation calculator | C | calculators/fertile-window | [NEEDS SOURCE] |
| 2 | due date calculator | C | calculators/due-date | [NEEDS SOURCE] |
| 3 | how many weeks pregnant am I | C | calculators/gestational-age | [NEEDS SOURCE] |
| 4 | when to take a pregnancy test | C | calculators/pregnancy-test + when-to-take-pregnancy-test | [NEEDS SOURCE] |
| 5 | period calculator / next period | C | calculators/period | [NEEDS SOURCE] |
| 6 | cycle length calculator | C | calculators/cycle-length | [NEEDS SOURCE] |
| 7 | fertile window | L | fertile-window-explained | [NEEDS SOURCE] |
| 8 | trying to conceive with irregular periods | L | irregular-cycles-and-timing | [NEEDS SOURCE] |
| 9 | PCOS and pregnancy / getting pregnant with PCOS | L | pcos-and-fertility | [NEEDS SOURCE] |
| 10 | PCOS symptoms | L | pcos-signs | [NEEDS SOURCE] |
| 11 | how is PCOS diagnosed | L | how-pcos-is-assessed | [NEEDS SOURCE] |
| 12 | when to see a fertility specialist | L | when-to-seek-fertility-help | [NEEDS SOURCE] |
| 13 | early pregnancy symptoms | L | early-pregnancy-changes | [NEEDS SOURCE] |
| 14 | pregnancy warning signs | L | pregnancy-warning-signs | [NEEDS SOURCE] |
| 15 | fasting in Ramadan while pregnant | L | ramadan-fasting-pregnancy | [NEEDS SOURCE] |
| 16 | pregnancy week N | L | pregnancy-week-N | [NEEDS SOURCE] |
| 17 | private period tracker / period tracker no account | A | /en/app | [NEEDS SOURCE] |

English head terms (rows 1–3, 13) are owned by large publishers; Hypothesis: our realistic English wins are long-tail (rows 8, 11, 15, 17) and the Arabic map. English is not where the first 100 women come from.

---

## 3 · On-page plan

**Common rules.** (Every title and meta below was measured by script on 2026-10-27: all titles ≤ 60 with the suffix, all metas ≤ 155; Checked.) Title tag ≤ 60 characters including the suffix (` — Femio` in EN, ` | femio` in AR), so the page part is ≤ 52. Meta description ≤ 155, ends with a reason to click. H1 is the question the woman asked. One answer box of 40–60 words under the H1. FAQ questions are **real headings on the page** with answers lifted from the reviewed text; no answer is written for schema alone, and no answer here is drafted by growth (medical text comes from the reviewed article). Titles and metas below go into the article frontmatter (`meta_title`, `meta_description`, as the Ramadan draft does).

**FAQ rich results: expect none.** Google limited FAQ rich results to well-known government and health sites in August 2023 ([Google Search Central blog](https://developers.google.com/search/blog/2023/08/howto-faq-changes)). Keep `FAQPage` markup for structure and for answer engines, but do not plan traffic on the snippet.

### 3.1 The 7 calculators (`/{locale}/calculators/<slug>`)

| Slug | EN title tag | EN H1 | AR title tag | AR H1 |
|---|---|---|---|---|
| fertile-window | Ovulation Calculator: Your Fertile Days as a Range | Ovulation and fertile window calculator | حاسبة التبويض (الإباضة): أيام الخصوبة المتوقعة | حاسبة التبويض وأيام الخصوبة |
| due-date | Due Date Calculator: Estimate When Your Baby Is Due | Due date calculator | حاسبة الحمل وموعد الولادة المتوقع | احسبي موعد ولادتكِ المتوقع |
| gestational-age | How Far Along Am I? Pregnancy Week Calculator | How many weeks pregnant am I? | كم عمر حملي؟ حاسبة الحمل بالأسابيع | كم أسبوعًا عمر حملكِ؟ |
| period | Period Calculator: When Is My Next Period Due? | When is my next period due? | حاسبة الدورة الشهرية: موعد الدورة القادمة | متى موعد دورتكِ القادمة؟ |
| pregnancy-test | Pregnancy Test Calculator: When to Test | When should I take a pregnancy test? | متى أُجري اختبار الحمل؟ حاسبة موعد الاختبار | متى تُجرين اختبار الحمل؟ |
| cycle-length | Cycle Length Calculator: Is My Cycle Regular? | How long is my cycle? | حاسبة طول الدورة الشهرية | كم يومًا طول دورتكِ؟ |
| bmi | BMI Calculator for Women Planning Pregnancy | BMI calculator | حاسبة مؤشر كتلة الجسم قبل الحمل | احسبي مؤشر كتلة الجسم |

| Slug | EN meta description | AR meta description |
|---|---|---|
| fertile-window | Tap the first day of your last period and see your likely fertile days on a calendar, as a range, not one day. Free and private. | اختاري أول يوم من آخر دورة على التقويم لتظهر لكِ أيام الخصوبة المتوقعة كنطاق لا كيوم واحد. مجانية وخاصة، ولا نحفظ أي بيانات. |
| due-date | Tap the first day of your last period to see your estimated due date, your week and your trimester on one calendar. Nothing is stored. | اختاري أول يوم من آخر دورة لتعرفي موعد الولادة المتوقع وأسبوع الحمل والثلث الذي أنتِ فيه على تقويم واحد، دون حفظ أي بيانات. |
| gestational-age | Find your pregnancy week and trimester from your last period or due date, shown on a calendar. Free, private, no sign-up. | اعرفي أسبوع حملكِ والثلث الذي أنتِ فيه من تاريخ آخر دورة أو موعد الولادة، على تقويم واضح. مجانية وخاصة وبلا تسجيل. |
| period | See when your next period may start, shown as a range from your own cycle length. Works for irregular cycles too. No sign-up. | اعرفي متى قد تبدأ دورتكِ القادمة كنطاق محسوب من طول دورتكِ أنتِ، حتى لو كانت غير منتظمة. بلا تسجيل ولا حفظ بيانات. |
| pregnancy-test | Find the earliest day a home pregnancy test is likely to give a clear result, based on your cycle. Free, private, instant. | اعرفي أنسب يوم لإجراء اختبار الحمل المنزلي للحصول على نتيجة أوضح، بحسب دورتكِ. أداة مجانية وخاصة وفورية. |
| cycle-length | Count your average cycle length from your last periods and see how much it varies. A first step before talking to your doctor. | احسبي متوسط طول دورتكِ من آخر الدورات واعرفي مقدار تغيّرها، خطوة أولى قبل الحديث مع طبيبتكِ. |
| bmi | Work out your BMI and what it does and does not tell you before pregnancy. A screening number, not a verdict. Free and private. | احسبي مؤشر كتلة جسمكِ واعرفي ما يعنيه وما لا يعنيه قبل الحمل. رقم للمتابعة لا حكم. مجانية وخاصة. |

| Slug | FAQ questions (EN) | FAQ questions (AR) |
|---|---|---|
| fertile-window | 1. Why does it show a range, not one day? 2. Can I use it if my cycles are irregular or I have PCOS? 3. What signs can tell me ovulation is near? | 1. لماذا تظهر النتيجة كنطاق لا كيوم واحد؟ 2. هل تفيدني إن كانت دورتي غير منتظمة أو لديّ تكيس المبايض؟ 3. ما العلامات التي تدل على اقتراب التبويض؟ |
| due-date | 1. How is the due date worked out? 2. What if my cycle is longer or shorter than 28 days? 3. Does the ultrasound date replace this one? | 1. كيف يُحسب موعد الولادة المتوقع؟ 2. ماذا لو كانت دورتي أطول أو أقصر من 28 يومًا؟ 3. هل يحلّ تاريخ السونار محلّ هذا التاريخ؟ |
| gestational-age | 1. Why are weeks counted from my last period? 2. How do pregnancy weeks turn into months? 3. Which trimester am I in? | 1. لماذا تُحسب أسابيع الحمل من آخر دورة؟ 2. كيف تتحول أسابيع الحمل إلى أشهر؟ 3. في أي ثلث من الحمل أنا؟ |
| period | 1. How is my next period estimated? 2. Is a period a few days late normal? 3. What if my cycle changes every month? | 1. كيف يُقدَّر موعد دورتي القادمة؟ 2. هل تأخر الدورة بضعة أيام أمر طبيعي؟ 3. ماذا لو تغيّر طول دورتي كل شهر؟ |
| pregnancy-test | 1. How soon can a home test show a positive? 2. Is first-morning urine better? 3. My test is negative but my period has not come: what next? | 1. متى يمكن أن يظهر الحمل في الاختبار المنزلي؟ 2. هل بول الصباح الأول أفضل؟ 3. الاختبار سلبي ولم تأتِ الدورة: ماذا أفعل؟ |
| cycle-length | 1. What cycle length is typical? 2. How do I count my cycle length? 3. When should irregular cycles be checked by a doctor? | 1. ما طول الدورة المعتاد؟ 2. كيف أحسب طول دورتي؟ 3. متى تحتاج الدورة غير المنتظمة إلى مراجعة الطبيب؟ |
| bmi | 1. What does BMI tell me, and what does it miss? 2. Can weight affect getting pregnant? 3. Is BMI used during pregnancy? | 1. ماذا يخبرني مؤشر كتلة الجسم، وما الذي لا يقيسه؟ 2. هل يؤثر الوزن في فرص الحمل؟ 3. هل يُستخدم المؤشر أثناء الحمل؟ |

Each calculator page also carries, under the result: the mandated sentence on the fertile-window and period pages only ("Predictions are estimates, not guarantees, and are not a method of birth control." / "التوقعات تقديرات وليست ضمانات، ولا تصلح وسيلةً لمنع الحمل."), the wellness line, two links to articles (§3.4) and the app hand-off (§3.5).

### 3.2 The 20 wedge pages: title tags and Arabic H1

English H1 = the article's current title (listed in study report 07 §2.5) unless shown here. Article URLs are `/{locale}/learn/<slug>`; the PCOS hub is `/{locale}/conditions/pcos`.

| # | Slug | EN title tag | AR title tag | AR H1 |
|---|---|---|---|---|
| 1 | trying-to-conceive-guide | Trying to Conceive: A Doctor's Step-by-Step Start | محاولة الحمل: من أين تبدئين؟ | محاولة الحمل: من أين تبدئين؟ |
| 2 | fertile-window-explained | Fertile Window and Ovulation Days, Explained | أيام التبويض ونافذة الخصوبة | ما أيام الخصوبة، ومتى يحدث التبويض؟ |
| 3 | irregular-cycles-and-timing | Trying to Conceive With Irregular Periods | الدورة غير المنتظمة ومحاولة الحمل | محاولة الحمل مع دورة غير منتظمة |
| 4 | pcos-and-fertility | PCOS and Getting Pregnant: What Helps | تكيس المبايض والحمل: ما الذي يساعد؟ | هل يؤثر تكيس المبايض في الحمل؟ |
| 5 | when-to-take-pregnancy-test | When to Take a Pregnancy Test for a Clear Result | متى تُجرين اختبار الحمل المنزلي؟ | متى تُجرين اختبار الحمل؟ |
| 6 | when-to-seek-fertility-help | Not Pregnant Yet? When to See a Fertility Doctor | تأخر الحمل: متى تراجعين الطبيب؟ | متى تحتاجين إلى مساعدة في الخصوبة؟ |
| 7 | fertility-tests-what-to-expect | Fertility Tests: What a First Assessment Involves | تحاليل تأخر الحمل: ماذا تتوقعين؟ | تحاليل الخصوبة: ماذا يتضمن الفحص الأول؟ |
| 8 | age-and-fertility | Age and Fertility: What the Numbers Really Say | العمر والخصوبة: ماذا تقول الأرقام؟ | العمر والخصوبة: ما تقوله الأرقام وما لا تقوله |
| 9 | thyroid-and-conceiving | Thyroid Problems and Trying to Conceive | الغدة الدرقية ومحاولة الحمل | الغدة الدرقية ومحاولة الحمل |
| 10 | preconception-appointment | Preconception Checkup: What Happens and Why | زيارة ما قبل الحمل: ماذا يحدث فيها؟ | ماذا يحدث في زيارة ما قبل الحمل؟ |
| 11 | endometriosis-and-fertility | Endometriosis and Fertility: What to Know | بطانة الرحم المهاجرة والحمل | هل تؤثر بطانة الرحم المهاجرة في الحمل؟ |
| 12 | early-pregnancy-changes | Early Pregnancy Symptoms: The Common Changes | أعراض الحمل المبكرة: التغيرات الشائعة | ما أعراض الحمل المبكرة الشائعة؟ |
| 13 | first-pregnancy-appointment | Your First Pregnancy Appointment: What to Expect | أول زيارة لمتابعة الحمل: ماذا تتوقعين؟ | ماذا يحدث في أول زيارة لمتابعة الحمل؟ |
| 14 | pregnancy-basics | Pregnancy Trimesters: What Usually Happens | مراحل الحمل: ما الذي يحدث عادةً؟ | ماذا تتوقعين خلال حمل معتاد؟ |
| 15 | pregnancy-warning-signs | Pregnancy Warning Signs That Need Urgent Care | علامات الخطر في الحمل: متى تطلبين الرعاية؟ | علامات الخطر في الحمل التي تحتاج رعاية عاجلة |
| 16 | conditions/pcos | PCOS (Polycystic Ovary Syndrome): A Clear Guide | تكيس المبايض: الأعراض والتشخيص والحمل | تكيس المبايض: دليل واضح |
| 17 | pcos-signs | PCOS Symptoms: The Common Signs to Know | أعراض تكيس المبايض: العلامات الشائعة | ما العلامات الشائعة لتكيس المبايض؟ |
| 18 | how-pcos-is-assessed | How Is PCOS Diagnosed? Tests and Criteria | كيف يُشخَّص تكيس المبايض؟ | كيف يقيّم الطبيب تكيس المبايض؟ |
| 19 | is-my-period-normal | Late or Irregular Period: Is My Period Normal? | تأخر الدورة أو عدم انتظامها: هل دورتي طبيعية؟ | هل دورتي طبيعية؟ |
| 20 | ramadan-fasting-pregnancy | Ramadan Fasting in Pregnancy: What to Discuss | (keep the draft's `meta_title`) الصيام في رمضان أثناء الحمل: الأدلة وعلامات الخطر | هل يمكنني الصيام في رمضان وأنا حامل؟ |
| — | pregnancy-week-N (template, N = 4–40) | Pregnancy Week {N}: Baby, Body and What to Expect | الأسبوع {N} من الحمل: جنينكِ وجسمكِ | الأسبوع {N} من الحمل |

### 3.3 The 20 wedge pages: meta descriptions and FAQ questions

| # | EN meta | AR meta |
|---|---|---|
| 1 | Where to start when you want to get pregnant: cycle basics, a preconception check, healthy habits and when to ask for help. | من أين تبدئين حين ترغبين في الحمل: أساسيات الدورة، وزيارة ما قبل الحمل، وعادات صحية، ومتى تطلبين المساعدة. |
| 2 | What the fertile window is, why it is a range of days, and the signs that ovulation may be near. Written by a physician. | ما نافذة الخصوبة، ولماذا هي أيام لا يوم واحد، وما العلامات التي قد تدل على قرب التبويض. كتبها طبيب مع المصادر. |
| 3 | Irregular cycles make timing harder, not impossible. How to read your own pattern and when to talk to a doctor. | الدورة غير المنتظمة تجعل التوقيت أصعب لا مستحيلًا. كيف تقرئين نمط دورتكِ، ومتى تتحدثين مع الطبيب. |
| 4 | How PCOS can affect ovulation and getting pregnant, what a clinician may check, and the questions to bring to your visit. | كيف قد يؤثر تكيس المبايض في التبويض والحمل، وما الذي قد يفحصه الطبيب، وأسئلة تأخذينها معكِ إلى الزيارة. |
| 5 | When a home pregnancy test is most likely to give a clear answer, and what to do if it is negative but your period is late. | متى يعطي اختبار الحمل المنزلي نتيجة أوضح، وماذا تفعلين إن كانت النتيجة سلبية والدورة متأخرة. |
| 6 | How long to try before seeing a doctor, why age changes the answer, and when to go sooner. Clear, sourced guidance. | كم تنتظرين قبل مراجعة الطبيب، ولماذا يغيّر العمر الإجابة، ومتى تذهبين أبكر. معلومات واضحة وموثّقة. |
| 7 | The blood tests, scans and history a first fertility assessment usually includes, for both partners, explained simply. | التحاليل والسونار والأسئلة التي يتضمنها عادةً أول فحص لتأخر الحمل، بشرح بسيط. |
| 8 | What age-and-fertility numbers mean, what they cannot predict for one woman, and when to plan a check. | ماذا تعني أرقام العمر والخصوبة، وما الذي لا تستطيع التنبؤ به لامرأة بعينها، ومتى تخططين لفحص. |
| 9 | How thyroid conditions can affect cycles and conceiving, and why a check before pregnancy helps. | كيف قد تؤثر اضطرابات الغدة الدرقية في الدورة وفرص الحمل، ولماذا يفيد الفحص قبل الحمل. |
| 10 | What a preconception visit covers, from folic acid to medicines and vaccines, and how to prepare your questions. | ما الذي تشمله زيارة ما قبل الحمل، من حمض الفوليك إلى الأدوية والتطعيمات، وكيف تجهّزين أسئلتكِ. |
| 11 | How endometriosis can affect fertility, what assessment may involve, and what to ask your doctor. | كيف قد تؤثر بطانة الرحم المهاجرة في الخصوبة، وما الذي قد يتضمنه التقييم، وما الذي تسألين عنه الطبيب. |
| 12 | The early pregnancy changes many women notice, why every pregnancy differs, and which symptoms need a call to your doctor. | تغيرات بداية الحمل التي تلاحظها كثير من النساء، ولماذا يختلف كل حمل، وأي الأعراض تستدعي الاتصال بالطبيب. |
| 13 | What usually happens at the first pregnancy visit: questions, tests and scans, and how to prepare. | ما الذي يحدث عادةً في أول زيارة لمتابعة الحمل: الأسئلة والتحاليل والسونار، وكيف تستعدين لها. |
| 14 | A clear walk through a typical pregnancy, trimester by trimester, and the checks you can expect along the way. | جولة واضحة في حمل معتاد، ثلثًا بعد ثلث، والفحوصات التي تتوقعينها على الطريق. |
| 15 | The pregnancy warning signs that mean you should seek care now, including bleeding, severe pain and fewer baby movements. | علامات الخطر في الحمل التي تعني طلب الرعاية فورًا، ومنها النزيف والألم الشديد وقلة حركة الجنين. |
| 16 | PCOS explained: common signs, how it is assessed, what it can mean for cycles and pregnancy, and questions for your doctor. | تكيس المبايض بوضوح: العلامات الشائعة، وكيف يُقيَّم، وما قد يعنيه للدورة والحمل، وأسئلة لطبيبتكِ. |
| 17 | The common signs of PCOS, from irregular cycles to skin and hair changes, and when to ask for an assessment. | العلامات الشائعة لتكيس المبايض، من عدم انتظام الدورة إلى تغيرات البشرة والشعر، ومتى تطلبين التقييم. |
| 18 | How clinicians assess PCOS: history, blood tests and scans, and why other causes are ruled out first. | كيف يقيّم الأطباء تكيس المبايض: التاريخ المرضي والتحاليل والسونار، ولماذا تُستبعد أسباب أخرى أولًا. |
| 19 | What a normal period looks like, how much cycles can vary, and when a late or irregular period needs a doctor. | كيف تبدو الدورة الطبيعية، وكم يمكن أن تتغير، ومتى تحتاج الدورة المتأخرة أو غير المنتظمة إلى الطبيب. |
| 20 | What research says about fasting in Ramadan while pregnant, its limits, questions for your doctor, and signs to stop. | (keep the draft's `meta_description`) ما تقوله الأبحاث عن الصيام في رمضان أثناء الحمل، وحدود الأدلة، وأسئلة تطرحينها على طبيبتكِ، وعلامات التوقف وطلب الرعاية. |

| # | FAQ questions (EN) | FAQ questions (AR) |
|---|---|---|
| 1 | How long does it usually take to get pregnant? · Should I start folic acid before trying? · When should we see a doctor? | كم يستغرق الحمل عادةً؟ · هل أبدأ حمض الفوليك قبل المحاولة؟ · متى نراجع الطبيب؟ |
| 2 | How many days is the fertile window? · Can I feel when I ovulate? · Do ovulation tests help? | كم يومًا تستمر نافذة الخصوبة؟ · هل أشعر بالتبويض؟ · هل تفيد اختبارات التبويض؟ |
| 3 | Can I ovulate with irregular cycles? · Is a calendar method reliable for me? · When are irregular cycles a reason to see a doctor? | هل يحدث التبويض مع الدورة غير المنتظمة؟ · هل يكفي الحساب بالتقويم في حالتي؟ · متى تستدعي الدورة غير المنتظمة زيارة الطبيب؟ |
| 4 | Can women with PCOS get pregnant? · Does weight change matter with PCOS? · What might a doctor check first? | هل يمكن الحمل مع تكيس المبايض؟ · هل لتغير الوزن أثر مع التكيس؟ · ما الذي قد يفحصه الطبيب أولًا؟ |
| 5 | How many days after a missed period should I test? · Can a test be falsely negative? · When is a blood test better? | بعد كم يوم من تأخر الدورة أُجري الاختبار؟ · هل يمكن أن تكون النتيجة سلبية خطأً؟ · متى يكون تحليل الدم أفضل؟ |
| 6 | How long should we try before seeing a doctor? · Does my age change that? · Should my husband be tested too? | كم نحاول قبل مراجعة الطبيب؟ · هل يغيّر عمري المدة؟ · هل يحتاج زوجي إلى فحص أيضًا؟ |
| 7 | Which blood tests are usually done? · Is an ultrasound needed? · Are men tested as part of the assessment? | ما التحاليل المعتادة؟ · هل يلزم السونار؟ · هل يشمل الفحص الرجل أيضًا؟ |
| 8 | Does fertility drop at a certain age? · What can an AMH test tell me? · When should I plan a check? | هل تنخفض الخصوبة عند عمر معين؟ · ماذا يخبرني تحليل مخزون المبيض؟ · متى أخطط لفحص؟ |
| 9 | Can thyroid problems delay pregnancy? · Should I test my thyroid before trying? · Is thyroid medicine safe in pregnancy? | هل تؤخر مشكلات الغدة الدرقية الحمل؟ · هل أفحص الغدة قبل المحاولة؟ · هل أدوية الغدة آمنة في الحمل؟ |
| 10 | When should I book a preconception visit? · Which supplements are usually advised? · Should I review my medicines first? | متى أحجز زيارة ما قبل الحمل؟ · ما المكملات التي يُنصح بها عادةً؟ · هل أراجع أدويتي أولًا؟ |
| 11 | Can I get pregnant with endometriosis? · Does endometriosis always affect fertility? · When should I ask for referral? | هل يمكن الحمل مع بطانة الرحم المهاجرة؟ · هل تؤثر دائمًا في الخصوبة؟ · متى أطلب التحويل إلى مختص؟ |
| 12 | How early do pregnancy symptoms start? · Is it normal to have no symptoms? · Which early symptoms need a doctor? | متى تبدأ أعراض الحمل؟ · هل من الطبيعي ألا أشعر بأعراض؟ · أي الأعراض المبكرة تستدعي الطبيب؟ |
| 13 | When is the first pregnancy visit? · What tests are done? · What should I bring? | متى تكون أول زيارة للحمل؟ · ما التحاليل التي تُجرى؟ · ماذا أُحضر معي؟ |
| 14 | How are the trimesters divided? · How often are checkups? · What changes in each trimester? | كيف يُقسَّم الحمل إلى أثلاث؟ · كم مرة تكون المتابعة؟ · ما الذي يتغير في كل ثلث؟ |
| 15 | Is bleeding in early pregnancy always serious? · When do fewer movements need care? · What headache needs urgent care? | هل النزيف في بداية الحمل خطير دائمًا؟ · متى تحتاج قلة حركة الجنين إلى رعاية؟ · أي صداع يحتاج رعاية عاجلة؟ |
| 16 | Is PCOS the same as cysts on the ovaries? · Can PCOS go away? · How does PCOS affect pregnancy plans? | هل تكيس المبايض يعني وجود أكياس؟ · هل يزول التكيس؟ · كيف يؤثر في التخطيط للحمل؟ |
| 17 | Can you have PCOS with regular periods? · Is acne a sign of PCOS? · Does PCOS cause weight gain? | هل يمكن وجود التكيس مع دورة منتظمة؟ · هل حب الشباب علامة على التكيس؟ · هل يسبب التكيس زيادة الوزن؟ |
| 18 | Do I need an ultrasound to be diagnosed? · Which blood tests are used? · What other conditions look like PCOS? | هل يلزم السونار للتشخيص؟ · ما التحاليل المستخدمة؟ · ما الحالات التي تشبه التكيس؟ |
| 19 | How many days late is still normal? · Can stress delay a period? · When is a late period a reason to see a doctor? | كم يومًا من التأخر يُعد طبيعيًا؟ · هل يؤخر التوتر الدورة؟ · متى يستدعي التأخر زيارة الطبيب؟ |
| 20 | Who should talk to a doctor before fasting? · What signs mean stop fasting? · Can fasting affect baby movements? | من تحتاج إلى استشارة الطبيب قبل الصيام؟ · ما العلامات التي تعني التوقف عن الصيام؟ · هل يؤثر الصيام في حركة الجنين؟ |

**Gap check.** Some FAQs (for example #8 AMH, #9 thyroid medicine, #17 acne) may not be answered in the current English text; the medical editor adds a sourced answer or drops the question. Never ship an FAQ the page does not answer.

### 3.4 Internal linking map

| From | Links to (in this order) |
|---|---|
| calculators/fertile-window | fertile-window-explained · irregular-cycles-and-timing · calculators/pregnancy-test · /app |
| calculators/period | is-my-period-normal · calculators/cycle-length · calculators/fertile-window · /app |
| calculators/cycle-length | is-my-period-normal · irregular-cycles-and-timing · conditions/pcos · /app |
| calculators/pregnancy-test | when-to-take-pregnancy-test · early-pregnancy-changes · calculators/due-date · /app |
| calculators/due-date | calculators/gestational-age · first-pregnancy-appointment · pregnancy-week-N for her result · /app |
| calculators/gestational-age | pregnancy-week-N for her result · pregnancy-warning-signs · pregnancy-basics · /app |
| calculators/bmi | preconception-appointment · pcos-and-fertility · trying-to-conceive-guide |
| conditions/pcos (hub) | pcos-signs · how-pcos-is-assessed · pcos-and-fertility · irregular-cycles-and-timing · calculators/cycle-length · /app |
| TTC articles (1–11) | trying-to-conceive-guide (pillar) · calculators/fertile-window · when-to-seek-fertility-help · /app |
| Pregnancy articles (12–15) | pregnancy-basics (pillar) · calculators/due-date · pregnancy-warning-signs · /app |
| pregnancy-week-N | week N−1 and N+1 · pregnancy-warning-signs · calculators/gestational-age · /app |
| ramadan-fasting-pregnancy | pregnancy-warning-signs · first-pregnancy-appointment · conditions/pcos (when ramadan-pcos exists) |
| Every page footer | /help-now (noindex, always linked) · editorial-policy · medical-review · authors |

Anchor text is the target query in the page's language ("حاسبة التبويض", not "اضغطي هنا"). Arabic pages link only to Arabic pages; where the Arabic target is not live yet, link to the calculator, not to an English article.

### 3.5 The app hand-off: CTA copy

Button (both locales): the official Google Play badge, Arabic badge on Arabic pages ([badge guidelines](https://partnermarketinghub.withgoogle.com/brands/google-play/visual-identity/badge-guidelines/) **[NEEDS CHECK]** for the current Arabic badge file). Link: the Play URL with a referrer tag per page (`&referrer=utm_source%3Dfemioapp%26utm_medium%3Dweb%26utm_campaign%3D<slug>`), so Play Console can count web-sourced installs without any SDK.

| Where | English | Arabic |
|---|---|---|
| Generic (every article footer) | Keep your cycle and pregnancy on your phone, privately. femio stores your records only on your device. | تابعي دورتكِ وحملكِ على هاتفكِ بخصوصية تامة. يحفظ femio سجلاتكِ على جهازكِ فقط. |
| Fertile-window result | Want this to update every cycle? The app learns your own cycle lengths and shows you honestly when the range widens or narrows. | تريدين أن تتجدد هذه الأيام مع كل دورة؟ يتعلّم التطبيق أطوال دوراتكِ أنتِ، ويُريكِ بصدق متى يتسع المدى أو يضيق. |
| Period / cycle-length result | Log your next few periods in the app and see your own pattern, with no "late" counter. | سجّلي دوراتكِ القادمة في التطبيق لتري نمطكِ أنتِ، بلا عدّاد للتأخير. |
| Due-date / week result | Follow your pregnancy week by week in Arabic or English, with a kick counter and a contraction timer, on your phone, not in a cloud. | تابعي حملكِ أسبوعًا بأسبوع بالعربية أو الإنجليزية، مع عدّاد لحركة الجنين ومؤقّت للانقباضات، على هاتفكِ لا على سحابة. |
| PCOS hub | Irregular cycles? femio has a mode with no "late" counter and no single-date promises. | دورتكِ غير منتظمة؟ في femio وضعٌ بلا عدّاد للتأخير وبلا وعود بيوم واحد. |
| Article end (library) | Read this article and the rest of the library inside the app, even offline. | اقرئي هذا المقال وبقية المكتبة داخل التطبيق، حتى دون إنترنت. |
| /app page hero | Your records never leave your phone. | سجلاتكِ لا تغادر هاتفكِ. |

No CTA appears inside a red-flag box or on `/help-now`. A woman reading urgent-care advice is not a conversion.

---

## 4 · ASO pack for Google Play

All limits are Google Play's: title 30, short description 80, full description 4,000 characters ([Play Console Help: store listing](https://support.google.com/googleplay/android-developer/answer/9859152) **[NEEDS CHECK]** that the limits are unchanged). Character counts below were measured with a script on 2026-10-27 (Checked). Lines marked **†** are **ship-gated**: delete the line if the release candidate does not have the feature (R4).

### 4.1 Title and short description

| Field | Arabic (primary listing for EG and SA) | Chars | English (default listing) | Chars |
|---|---|---|---|---|
| App title | femio: الدورة والتبويض والحمل | 29 | femio: Ovulation & Pregnancy | 28 |
| Short description | تتبّعي الدورة والتبويض والحمل بخصوصية تامة. سجلاتكِ تبقى على هاتفكِ. | 68 | Private period, ovulation & pregnancy tracker. Your records stay on your phone. | 79 |

Title rules followed: no "free", "best", "#1", emoji or capitals for emphasis (Play metadata policy). Make Arabic the default for the Egypt and Saudi listings via Play's custom store listings by country **[NEEDS CHECK]** that custom listings are available before production access.

### 4.2 Full description: English (2,679 characters with the † marks; Checked)

```
femio is a private companion for trying to conceive and pregnancy, made for Arabic-speaking women first, with full English too. Track your period and ovulation, see your fertile days as an honest range, then follow your pregnancy week by week. Your records stay on your phone.

WHY FEMIO
• Your records never leave your phone. No account, no sign-up, no cloud. Your log is stored encrypted on your device, behind an app lock you choose. † You decide when to save a backup, and where. †
• Honest predictions. femio shows your next period and fertile window as a range, never one "certain" date. If your cycles are irregular or you have PCOS, there is no "late" counter and no false precision.
• Arabic first. Clear Arabic written for women, not machine-translated, with Hijri dates beside Gregorian. † English whenever you want it.
• Written by a physician, with sources. The library inside the app explains ovulation, PCOS, early pregnancy and every week of pregnancy, and each article lists its sources. †
• Everything stays open to you. femio adapts its home screen to where you are, trying to conceive, pregnant, or tracking PCOS, and every article and tool stays one tap away.
• One record that grows with you. When you move from trying to pregnant, femio adds pregnancy to the same record. Nothing is deleted.

TRYING TO CONCEIVE
• Period and ovulation tracking on a calendar
• Your fertile window as a range, updated from your own cycles
• Log symptoms, ovulation tests and cervical mucus
• Clear guidance on when to talk to a doctor

PCOS AND IRREGULAR CYCLES
• A mode built for long or unpredictable cycles
• Track what matters to your doctor: cycle length, skin, hair and weight
• Sourced articles on PCOS and fertility

PREGNANCY
• Due date, pregnancy week and trimester
• A week-by-week guide from week 4 to week 40
• Kick counter and contraction timer that never give a verdict and point you to care when something needs checking
• Appointment reminders on your phone †

PRIVATE BY DESIGN
• No account. No ads. No third-party analytics in the app.
• App lock and encrypted storage on your phone †
• Backup and restore from a file you save yourself †
• Delete everything in one step

IMPORTANT
femio is for education and tracking. It is not a medical device and does not diagnose, treat, cure or prevent any medical condition. Predictions are estimates, not guarantees, and are not a method of birth control. Always talk to your doctor or midwife about your health. If you have heavy bleeding, severe pain or fewer baby movements, seek medical care right away.

femio is made by KM Digital Labs, founded by a physician in Cairo. Questions or feedback: [support email].
```

Keyword placement (Google indexes the full description): "ovulation" ×4, "pregnancy/pregnant" ×7, "period" ×3, "PCOS" ×4, "private/privately" ×2, "fertile" ×2. Natural density; do not add more. Remove the † marks before pasting.

### 4.3 Full description: Arabic (2,333 characters with the † marks; Checked)

```
femio رفيقتكِ الخاصة في رحلة محاولة الحمل ثم الحمل، صُمّم للمرأة العربية أولًا، مع نسخة إنجليزية كاملة. تابعي دورتكِ الشهرية والتبويض، واعرفي أيام الخصوبة المتوقعة كنطاق صادق، ثم تابعي حملكِ أسبوعًا بأسبوع. وسجلاتكِ تبقى على هاتفكِ.

لماذا femio؟
• سجلاتكِ لا تغادر هاتفكِ: بلا حساب ولا تسجيل ولا سحابة. تُحفظ بياناتكِ مشفّرة على جهازكِ خلف قفل تختارينه أنتِ، † وأنتِ من تقرّر متى تحفظين نسخة احتياطية وأين. †
• توقعات أمينة: يعرض femio موعد دورتكِ القادمة وأيام الخصوبة كنطاق، لا كيوم واحد "مؤكد". وإن كانت دورتكِ غير منتظمة أو لديكِ تكيس المبايض، فلا عدّاد للتأخير ولا دقة زائفة.
• العربية أولًا: نصوص عربية واضحة كُتبت لكِ ولم تُترجم آليًا، مع التاريخ الهجري إلى جانب الميلادي. † والإنجليزية متاحة متى شئتِ.
• معلومات كتبها طبيب، مع مصادرها: مكتبة داخل التطبيق تشرح التبويض وتكيس المبايض وبداية الحمل وكل أسبوع من أسابيعه، وكل مقال يذكر مصادره. †
• كل شيء متاح لكِ: تتكيّف الشاشة الرئيسية مع مرحلتكِ، سواء كنتِ تحاولين الحمل أو حاملًا أو تتابعين تكيس المبايض، ويبقى كل مقال وكل أداة على بُعد لمسة.
• سجل واحد يكبر معكِ: حين تنتقلين من محاولة الحمل إلى الحمل، يضيف femio الحمل إلى السجل نفسه، ولا يُحذف شيء.

محاولة الحمل
• متابعة الدورة والتبويض على تقويم واضح
• أيام الخصوبة كنطاق يتجدد من أطوال دوراتكِ أنتِ
• تسجيل الأعراض واختبارات التبويض وإفرازات عنق الرحم
• إرشاد واضح عن الوقت المناسب للحديث مع الطبيب

تكيس المبايض والدورة غير المنتظمة
• وضع مخصص للدورات الطويلة أو غير المتوقعة
• تابعي ما يهم طبيبتكِ: طول الدورة والبشرة والشعر والوزن
• مقالات موثّقة عن تكيس المبايض والحمل

الحمل
• موعد الولادة المتوقع وأسبوع الحمل والثلث الذي أنتِ فيه
• دليل أسبوعي من الأسبوع 4 حتى الأسبوع 40
• عدّاد لحركة الجنين ومؤقّت للانقباضات، لا يُصدران حكمًا، ويوجّهانكِ إلى الرعاية حين يلزم
• تذكيرات بالمواعيد على هاتفكِ †

خصوصية في التصميم
• بلا حساب، بلا إعلانات، بلا أدوات تحليل خارجية داخل التطبيق
• قفل للتطبيق وتخزين مشفّر على هاتفكِ †
• نسخة احتياطية واستعادتها من ملف تحفظينه بنفسكِ †
• حذف كل شيء بخطوة واحدة

تنبيه مهم
femio للتثقيف والمتابعة فقط. ليس جهازًا طبيًا، ولا يشخّص أي حالة صحية ولا يعالجها ولا يشفيها ولا يقي منها. التوقعات تقديرات وليست ضمانات، ولا تصلح وسيلةً لمنع الحمل. استشيري طبيبتكِ أو طبيبكِ دائمًا في ما يخص صحتكِ. وإن لاحظتِ نزيفًا شديدًا أو ألمًا قويًا أو قلّة في حركة الجنين، فاطلبي الرعاية الطبية فورًا.

femio من KM Digital Labs، وقد أسّسها طبيب في القاهرة. للأسئلة والملاحظات: [البريد الإلكتروني للدعم].
```

**One wording for counsel (03).** "ولا تصلح وسيلةً لمنع الحمل" is the Arabic of the mandated sentence and contains منع الحمل. It is a disclaimer, not a feature claim, and is the only place the concept appears. If counsel prefers, the alternative is "ولا يُعتمد عليها لتجنّب الحمل".

### 4.4 Screenshots: 8 captions (phone, 1080×1920 or larger, Arabic set first)

Captions sit in the top third, Dusk Bloom tokens, Arabic set right-aligned. The first three carry the three messages, because most visitors never scroll past them (Hypothesis, common ASO practice). No photos of people (`00_PLAN.md` §4); real app screens with synthetic data only.

| # | Screen | English caption | Arabic caption |
|---|---|---|---|
| 1 | Privacy screen / lock | Your records never leave your phone | سجلاتكِ لا تغادر هاتفكِ |
| 2 | Calendar with fertile range | Your fertile days as an honest range | أيام خصوبتكِ كنطاق صادق، لا يوم واحد |
| 3 | Irregular/PCOS mode home | Irregular cycles or PCOS? No "late" counter | دورة غير منتظمة أو تكيس مبايض؟ بلا عدّاد للتأخير |
| 4 | Pregnancy week card | Your pregnancy, week by week | حملكِ أسبوعًا بأسبوع |
| 5 | Calendar with Hijri on | Your calendar, with Hijri dates beside each day (2026-11-01: the calendar draws no due-date mark, so the caption names what the screen shows) | تقويمكِ، والتاريخ الهجري بجانب كل يوم |
| 6 | Library article with sources | Physician-written articles, with sources † | مقالات كتبها طبيب، مع مصادرها † |
| 7 | Kick counter | Kick counter and contraction timer | عدّاد حركة الجنين ومؤقّت الانقباضات |
| 8 | Backup / settings | App lock, and a backup you keep † | قفل للتطبيق، ونسخة احتياطية بين يديكِ † |

### 4.5 Feature graphic (1024×500) and promo video

**Feature graphic.** Wordmark **femio** at start, one line, nothing else: EN "Your records never leave your phone." / AR "سجلاتكِ لا تغادر هاتفكِ." Keep text inside the central safe area; Play may crop edges or overlay a play button when a video is attached **[NEEDS CHECK]**.

**Promo video, 30 seconds** (YouTube, unlisted is allowed **[NEEDS CHECK]**). Screen recordings and the Dusk Bloom bloom mark only; no faces. Arabic voice-over (female, calm MSA) with English captions; an English cut swaps the two.

| Time | Picture | Arabic voice-over | English caption |
|---|---|---|---|
| 0–4 s | Bloom mark opens to the calendar | حين تحاولين الحمل، تكثر الأسئلة. | When you are trying to conceive, the questions start. |
| 4–10 s | Tap a day; fertile range draws on the calendar | femio يُريكِ أيام خصوبتكِ كنطاق صادق، لا كوعد بيوم واحد. | femio shows your fertile days as an honest range, not a one-day promise. |
| 10–15 s | Irregular-cycle mode; no late counter | دورتكِ غير منتظمة؟ لا عدّاد للتأخير ولا دقة زائفة. | Irregular cycles? No "late" counter, no false precision. |
| 15–21 s | Switch to pregnancy; week card, kick counter | وحين تحملين، يكمل معكِ أسبوعًا بأسبوع، بالعربية. | When you are pregnant, it follows you week by week, in Arabic. |
| 21–27 s | Lock screen; "on this phone only" | وسجلاتكِ لا تغادر هاتفكِ. بلا حساب، بلا سحابة. | And your records never leave your phone. No account, no cloud. |
| 27–30 s | Wordmark + Play badge + small disclaimer | femio. للتثقيف والمتابعة، وليس جهازًا طبيًا. | femio. For education and tracking, not a medical device. |

### 4.6 Category, tags, rating, declarations

| Item | Setting |
|---|---|
| Category | Health & Fitness (G4) |
| Tags (up to 5) | Period tracker · Pregnancy · Fertility · Women's health · Health tracking — exact labels come from Play's fixed tag list **[NEEDS CHECK]** in Play Console |
| Target audience | 18+ only (G5). Answer "No" to appealing to children |
| Content rating (IARC questionnaire) | Answer as an educational reference app: no violence, no gambling, no user interaction or sharing, no location sharing, no purchases. Reproductive-health education is factual; answer the sexuality questions honestly per the questionnaire's own definitions. Expected rating **[NEEDS CHECK]**; do not guess the answers to steer it |
| Ads | "No, my app does not contain ads" |
| Data safety | Draft in `03_LEGAL_PACK.md`. If nothing leaves the device, "No data collected" and "No data shared"; the feedback link (§5.4) opens an external page the woman chooses to use, which counsel confirms is outside the app's collection ([Data safety help](https://support.google.com/googleplay/android-developer/answer/10787469)) |
| Health apps declaration | Required for every track including closed testing. Tick menstrual and cycle tracking, ovulation and fertility awareness, pregnancy tracking; nothing under medical device or clinical use ([Health apps declaration](https://support.google.com/googleplay/android-developer/answer/14738291), Checked 2026-10-27 via search) |
| Privacy policy URL | `https://femioapp.com/en/privacy` and `/ar/privacy`, live, indexable once final, matching the Data safety form word for word |

### 4.7 What Play reviewers look for in a health app (pre-submission checklist)

1. **The disclaimer in the description**: "not a medical device and does not diagnose, treat, cure or prevent" (Google's own wording for non-medical health apps). Present in §4.2 and §4.3.
2. **Health apps declaration** filed and true to the build.
3. **Privacy policy** reachable from the listing and inside the app, describing the on-device product (the current policy describes the old cloud product: study §4.5).
4. **Data safety matches behaviour.** A mismatch is a rejection and a trust failure.
5. **No unproven health claims.** No accuracy percentages, no "clinically proven", no "doctor approved" unless a named review exists.
6. **Metadata policy.** No keyword lists, no repeated keywords, no ranking or price words in the title, no testimonials attributed to unnamed users.
7. **Sensitive permissions justified.** Notifications for reminders; if exact alarms are used, the `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` policy applies **[NEEDS CHECK]**; prefer inexact alarms for daily reminders.
8. **Target audience and content** consistent: 18+ in the form, nothing in screenshots aimed at teens.
9. **Screenshots show the real app.** No features that are not in the build (hence the † gates).
10. **Account deletion rule** does not apply (no accounts), but "delete everything" should exist in Settings because the listing says so.

---

## 5 · The first 100 women (soft launch, Egypt + Saudi Arabia)

**Goal.** 100 women who installed from Egypt or Saudi Arabia and kept the app 30 days, by the end of January 2027. Not 100 installs: 100 retained installers, as Play Console reports them.

**What is fixed first: the closed test.** Google requires a closed test with at least 12 opted-in testers for 14 continuous days before a new personal account can apply for production ([Play Console Help 14151465](https://support.google.com/googleplay/android-developer/answer/14151465), Checked via search 2026-10-27; whether a dropped tester resets the clock is disputed by secondary sources, **[NEEDS CHECK]**). The plan's window is 11–25 Nov; production review then takes "usually within 7 days" per secondary sources, which makes the week of 30 Nov tight. **Recruit 16, not 12**, and send the opt-in link on 10 Nov.

### 5.1 Channels, ranked by cost and fit

| # | Channel | Market | How | Rules we keep |
|---|---|---|---|---|
| 1 | **The founder's own network: doctors and clinics** | EG first | Khaled asks 5–10 OB-GYN and family-medicine colleagues to place a bilingual QR card in the waiting room (A6, one line: "سجلاتكِ لا تغادر هاتفكِ" + QR to `/ar/app?ref=clinic-<n>`) | Clinic owner's permission; no claim that the clinic endorses femio; **nothing through Bupa** (no Bupa colleagues' channels, members or data: the founder's employer is kept separate) |
| 2 | **WhatsApp** | EG + SA | (a) A femio WhatsApp Channel (one-to-many; followers' numbers are not shown to admins) carrying the 3 weekly posts; (b) personal forwards from the founder's network of a week card or a calculator link | No cold messaging. No joining women's groups uninvited; share only where a member invites it |
| 3 | **Facebook groups (Egypt)** | EG | Egypt's mass channel (`02` §6.1: 51.6M ad reach). TTC, ICSI (الحقن المجهري) and PCOS support groups: answer questions as Dr Khaled with a link to the Arabic article, not the app | Follow each group's rules; disclose being the founder; never post a medical opinion about a member's own case |
| 4 | **Instagram + TikTok (Arabic)** | EG + SA | Founder-led short videos: one question, one answer, one link, from §5.3. Reels and TikTok share the same cut | No paid creators (G7). Saudi paid promotion needs Mawthooq (`02` §6.2). Egyptian creators: gifting or collaboration only after the owner decides; rules unverified |
| 5 | **Snapchat** | SA + EG | Highest female share in both markets (`02` §6.1). Public profile + Spotlight with the same vertical videos | Same as 4 |
| 6 | **X (Saudi)** | SA | Threads on Ramadan + pregnancy and PCOS myths from the reviewed articles | No replies to individual medical questions beyond "talk to your doctor" + article link |
| 7 | **Reddit (English)** | Expat women in both | r/TTC, r/PCOS, r/BabyBumps, r/Egypt, r/saudiarabia: only where self-promotion rules allow; lead with the privacy design ("no account, nothing leaves the phone") | Read each subreddit's rules first; one post per subreddit; disclose founder |
| 8 | **Arabic forums** | SA | Women's forums such as عالم حواء (activity in 2026 **[NEEDS CHECK]**). Answer existing threads with the Arabic article | Same as 3 |
| 9 | **Search (§2)** | Both | Arabic wedge pages live; calculators hand off to Play | Slow: count it from week 4 |

### 5.2 Ramadan 2027 (expected to begin about 8 February 2027)

Ramadan 1448 is expected to begin on or about **Monday 8 February 2027**, subject to moon sighting, with Eid al-Fitr about 9–10 March ([Gulf News](https://gulfnews.com/uae/ramadan/when-does-ramadan-2027-begin-everything-you-need-to-know-1.500630523); [The National](https://www.thenationalnews.com/news/uae/2026/10/06/ramadan-2027-uae-dates-eid-al-fitr-holiday/)). Search interest builds before the month (Hypothesis), so pages must be indexed weeks ahead.

| Date | Action | Asset |
|---|---|---|
| By 11 Jan | Publish `ramadan-fasting-pregnancy` (EN + AR drafts exist; clinician review first) and submit in Search Console | Article |
| By 25 Jan | Publish `ramadan-pcos` (to write; review) | Article |
| 1 Feb | Shareable WhatsApp card: "5 questions to ask your doctor before fasting while pregnant" | Card linked to the article |
| 8 Feb – 8 Mar | 2 posts a week: hydration at suhoor and iftar from the article's text; the warning signs that mean stop fasting (verbatim from the reviewed red-flag box); TTC and fasting questions for the doctor; Eid gentle return to routine | Posts → article |
| Throughout | Every Ramadan post says plainly that religious rulings belong to a scholar and health decisions to her doctor | Standard line |

### 5.3 Six-week content calendar (3 posts a week, soft launch week of 30 Nov)

Every post links to one page. Medical facts in a post come only from the linked reviewed page. Arabic first; the English version goes to Reddit, the English Instagram caption and the website.

| Week | Date | Post (AR topic / EN topic) | Format | Links to |
|---|---|---|---|---|
| 1 | Mon 30 Nov | femio وصل: سجلاتكِ لا تغادر هاتفكِ / femio is here: your records never leave your phone | 30 s video (§4.5) | /app |
| 1 | Wed 2 Dec | ما أيام الخصوبة؟ ولماذا هي نطاق لا يوم؟ / The fertile window is a range, not a day | Carousel | fertile-window-explained |
| 1 | Sat 5 Dec | جرّبي حاسبة التبويض على التقويم / Try the ovulation calculator on a calendar | Screen recording | calculators/fertile-window |
| 2 | Mon 7 Dec | تأخرت الدورة والتحليل سلبي: ماذا بعد؟ / Late period, negative test: what next? | Q&A video | when-to-take-pregnancy-test |
| 2 | Wed 9 Dec | تكيس المبايض: 3 علامات شائعة / PCOS: common signs | Carousel | pcos-signs |
| 2 | Sat 12 Dec | لماذا لا يحتاج femio إلى حساب؟ / Why femio needs no account | Founder talk | /app |
| 3 | Mon 14 Dec | هل يمكن الحمل مع تكيس المبايض؟ / Can you get pregnant with PCOS? | Q&A video | pcos-and-fertility |
| 3 | Wed 16 Dec | متى أُجري اختبار الحمل؟ / When to take a pregnancy test | Calculator demo | calculators/pregnancy-test |
| 3 | Sat 19 Dec | الدورة غير المنتظمة ومحاولة الحمل / Irregular cycles and trying to conceive | Carousel | irregular-cycles-and-timing |
| 4 | Mon 21 Dec | تأخر الحمل: متى نراجع الطبيب؟ / When to see a doctor about fertility | Q&A video | when-to-seek-fertility-help |
| 4 | Wed 23 Dec | زيارة ما قبل الحمل: ماذا تسألين؟ / Preconception visit: what to ask | Checklist card | preconception-appointment |
| 4 | Sat 26 Dec | العمر والخصوبة: ما تقوله الأرقام وما لا تقوله / Age and fertility, honestly | Founder talk | age-and-fertility |
| 5 | Mon 28 Dec | أعراض الحمل المبكرة الشائعة / Early pregnancy changes | Carousel | early-pregnancy-changes |
| 5 | Wed 30 Dec | احسبي موعد ولادتكِ على التقويم / Your due date on a calendar | Calculator demo | calculators/due-date |
| 5 | Sat 2 Jan | علامات الخطر في الحمل: لا تنتظري / Pregnancy warning signs: do not wait | Card (red-flag text verbatim) | pregnancy-warning-signs |
| 6 | Mon 4 Jan | أول زيارة لمتابعة الحمل / Your first pregnancy appointment | Checklist card | first-pregnancy-appointment |
| 6 | Wed 6 Jan | حملكِ أسبوعًا بأسبوع في التطبيق / Week by week in the app | Screen recording | pregnancy-week-N, /app |
| 6 | Sat 9 Jan | قريبًا رمضان: الصيام والحمل / Ramadan is coming: fasting in pregnancy | Teaser | ramadan-fasting-pregnancy |

### 5.4 What to measure without analytics SDKs

| Signal | Where | Cadence | Target by end of Jan |
|---|---|---|---|
| Store listing visitors, installs, conversion rate, by country | Play Console acquisition reports | Weekly | EG + SA installs ≥ 200 **(Hypothesis target)** |
| Retained installers (30 days) | Play Console | Weekly | ≥ 100 (the goal) |
| Installs by source (Play search vs web referrer tags vs other) | Play Console, `utm_campaign` per page (§3.5) **[NEEDS CHECK]** report name | Weekly | Know which 3 pages send installs |
| Play search terms that led to installs | Play Console | Week 6 | Replace §2 volume column with real terms |
| Pages viewed, countries, referrers (aggregate, cookieless) | Vercel Web Analytics, if the lead enables it (S6); Hobby-plan terms for a commercial product **[NEEDS CHECK]** | Weekly | AR share of views; top 10 pages |
| Queries, impressions, clicks, positions | Google Search Console (§6) | Weekly | First Arabic queries with impressions |
| Ratings and reviews | Play Console; reply to every review in its language within 48 h | Daily in week 1 | — |
| One-question feedback | In-app "Tell us one thing" link in Settings → an external one-question form: "What is one thing femio should do better?" (free text; the form warns: do not include health details) | Read weekly | 20 answers |
| Clinic QR cards | Referrer tag per clinic (`ref=clinic-<n>`) | Weekly | Which clinics work |

Nothing in this list reads a woman's health record or sends an event from the app.

### 5.5 Tester recruitment message (12+ testers, closed test)

**Mechanics:** a Google Group (`femio-testers`) added to the closed track; testers join the group, then open the opt-in link, then install from Play. They need an Android phone and a Google account. They must keep the app installed for the whole 14 days. They may use invented data: nothing leaves the phone. Adults only.

**Arabic (MSA, warm):**

> السلام عليكم،
> أنا د. خالد حسنين، طبيب من القاهرة. أطلقنا femio، تطبيقًا عربيًا لمتابعة الدورة والتبويض والحمل،
> وسجلاتكِ فيه لا تغادر هاتفكِ: بلا حساب ولا سحابة.
> قبل نشره على Google Play نحتاج إلى 12 مختبِرة تستخدمه 14 يومًا متتالية، من 11 إلى 25 نوفمبر.
> ما المطلوب؟ هاتف أندرويد وحساب Google، والانضمام إلى مجموعة المختبرين عبر هذا الرابط: [رابط]،
> ثم تثبيت التطبيق وإبقاؤه على الهاتف حتى نهاية المدة، وفتحه مرتين أو ثلاثًا في الأسبوع.
> يمكنكِ إدخال بيانات تجريبية لا تخصكِ، فلا شيء يُرسَل إلينا. وفي آخر المدة سؤال واحد فقط عن رأيكِ.
> هل يمكنني إضافتكِ؟ شكرًا لكِ.

**Egyptian variant for the founder's WhatsApp (optional):**

> أهلًا، أنا د. خالد. عاملين تطبيق اسمه femio لمتابعة الدورة والتبويض والحمل بالعربي، وكل بياناتك
> بتفضل على موبايلك بس. محتاجين 12 واحدة يجربوه 14 يوم من 11 لـ 25 نوفمبر قبل ما ينزل على Google Play.
> محتاجة موبايل أندرويد وحساب Google وتدخلي من اللينك ده: [رابط]. ممكن تكتبي بيانات تجريبية مش بتاعتك.
> لو ينفع أضيفك، قوليلي. شكرًا.

**English:**

> Hello, I am Dr Khaled Hassanein, a physician in Cairo. We are launching femio, an Arabic-first app
> for tracking periods, ovulation and pregnancy, where your records never leave your phone: no
> account, no cloud.
> Before it goes live on Google Play we need 12 testers to use it for 14 days in a row, 11 to 25
> November. You need an Android phone and a Google account. Join the tester group here: [link], install
> the app, keep it installed until the end, and open it two or three times a week.
> You can enter made-up data; nothing is sent to us. At the end there is one question about what you
> think. May I add you? Thank you.

---

## 6 · Technical SEO checklist for the static teaser

Grounded in the shipped plumbing (`lib/seo/*`, `sitemap.ts`, `robots.ts`; Checked by reading) and the static-export change in R2. Each line is a box for the R2 gate.

### 6.1 Domain, canonical, hreflang

- [ ] `NEXT_PUBLIC_APP_URL=https://femioapp.com` in Vercel production; `docs/17` still names `femio-web.vercel.app`, update it.
- [ ] One host: apex `femioapp.com`; `www` 308-redirects to it. One trailing-slash rule (`trailingSlash` in `next.config`, matched by every internal link and the sitemap).
- [ ] `/` (no locale) is a static page or a Vercel redirect to `/en` (x-default, G3); static export has no middleware, so locale detection by header is out.
- [ ] Self-referencing canonical per locale (already coded in `localizedAlternates`). Never a cross-locale canonical.
- [ ] hreflang: UI pages (home, calculators, `/app`, legal) list `en`, `ar`, `fr`, `es` + `x-default`. Articles list **only the locales that exist** (already coded, P1.6.15): an English-only article emits `en` + `x-default`; it gains `ar` the day the Arabic file is published.
- [ ] Preview deployments are `noindex` (Vercel adds `X-Robots-Tag: noindex` on non-production URLs **[NEEDS CHECK]**); verify with `curl -I` on a preview URL.
- [ ] Google removed its International Targeting report in 2022, so hreflang errors are not shown in Search Console: add a build check that every hreflang target exists in the export (extend `sitemap-check`).

### 6.2 Sitemap and robots

- [ ] `sitemap.xml` generated at build from the content package (R3), not from the CMS client; drop `export const revalidate = 3600` (meaningless in a static export).
- [ ] Each article listed once per **existing** locale with `alternates.languages` (coded). `lastModified` = the article's `last_reviewed` date, not build time (a sitemap where everything changed every deploy teaches Google to ignore `lastmod`).
- [ ] Excluded: `/help-now` (noindex by design), `/search`, empty `/faq` and `/glossary`; drafts (`robots_while_draft: noindex,nofollow` in frontmatter, as the Ramadan draft already sets).
- [ ] `/privacy` and `/terms` added once `03_LEGAL_PACK.md` text is final (the current sitemap excludes them as drafts).
- [ ] `robots.txt`: allow all; `Sitemap: https://femioapp.com/sitemap.xml`; remove the `/api/` disallow once no API routes exist; no `host` directive needed (Google ignores it).

### 6.3 Open Graph and social cards per locale

- [ ] `og:locale` = `en_US` / `ar_AR` (coded in `siteConfig.ogLocale`), plus `og:locale:alternate` for the other existing locale.
- [ ] One 1200×630 OG image per locale and page type (home, calculator, article), Dusk Bloom, Arabic text set RTL in IBM Plex Sans Arabic or Noto Naskh, wordmark **femio** Latin. The study found **no OG image today** (synthesis §2). Generate at build (static PNG), not at request time.
- [ ] `twitter:card=summary_large_image` (coded). WhatsApp uses OG tags: test each wedge URL by pasting it into a WhatsApp chat and checking title, image and Arabic direction.

### 6.4 Structured data (JSON-LD)

| Page | Types | Notes |
|---|---|---|
| Home | `WebSite` + `Organization` | Coded. Add `logo` (Dusk mark PNG) and `sameAs` (Play listing, social profiles once live) |
| `/app` | `MobileApplication` | `operatingSystem: ANDROID`, `applicationCategory: HealthApplication`, `offers.price: 0`, `downloadUrl` = Play URL. **No `aggregateRating`** until real Play ratings exist, and then only if shown on the page |
| Calculators | `WebApplication` (coded) + `BreadcrumbList` | `isAccessibleForFree: true` |
| Articles | `MedicalWebPage` + `Article` (author and reviewer `Person`) + `BreadcrumbList` | Builders exist (`medicalWebPageJsonLd`, `articleJsonLd`). `lastReviewed` and `reviewedBy` only where a named review exists (25 of 100 today) |
| Articles with FAQ headings | `FAQPage` | Only questions answered on the page (§3) |
| Condition hub | `MedicalWebPage` with `about: MedicalCondition` | PCOS first |
| Author page | `Person` with credentials and `sameAs` | E-E-A-T for a YMYL site |

- [ ] Validate every template with the Rich Results Test and the Schema.org validator in EN and AR.
- [ ] JSON-LD `inLanguage` set per locale (`ar`, `en`).

### 6.5 Core Web Vitals targets (mobile, 390×844, field data when available)

| Metric | Target | Notes |
|---|---|---|
| LCP | < 2.0 s | Skill budget (stricter than Google's 2.5 s "good") |
| INP | < 200 ms | The calendar input is the only heavy island; tap-to-draw must stay under budget on a mid-range Android |
| CLS | < 0.05 | Reserve space for the calendar and the result; font `display: swap` with metric-matched fallbacks for Arabic fonts |
| Lighthouse mobile | ≥ 95 performance, 100 SEO | `00_PLAN.md` R2 gate |
| Page weight (article) | < 200 KB JS on article pages **(Hypothesis budget)** | Articles need no client JS beyond the header |

- [ ] Arabic font files subset to Arabic + Latin used, self-hosted via `next/font`.
- [ ] Measure on throttled 4G in Lighthouse CI; field data appears in Search Console once traffic exists.

### 6.6 Search Console setup (owner, about 30 minutes)

1. Go to search.google.com/search-console, add a **Domain property** `femioapp.com`.
2. Copy the TXT record; add it at the domain registrar's DNS (Vercel DNS if the domain is there). Wait for verification (minutes to hours). DNS verification covers `www`, apex and every locale path.
3. **Sitemaps** → submit `https://femioapp.com/sitemap.xml`. Check "Success" and the discovered count matches the export.
4. **URL Inspection** → request indexing for: `/ar`, `/en`, the 7 Arabic calculators, `/ar/app`, and each Arabic wedge article as it ships (the tool has a daily quota; do the P1 pages first).
5. Add the lead as a **Full user** (Settings → Users and permissions) so weekly reports can be read.
6. Optional, 10 minutes: Bing Webmaster Tools → "Import from Google Search Console".
7. Week 2 onward: Performance report filtered by country (Egypt, Saudi Arabia) and by page `/ar/`; log the first Arabic queries with impressions into §2.2's volume column as **real use** data.

---

## 7 · Not verified (keep separate from the plan)

- Every search volume (Ahrefs blocked by plan, Checked 2026-10-27).
- Egyptian vs Gulf wording frequencies (§2.2 variants are Hypothesis).
- Play Console report names for UTM attribution and the current tag list.
- Whether a dropped tester resets the 14-day clock; production-access review time.
- IARC outcome for a reproductive-health education app.
- Vercel Hobby plan terms for this product; Vercel preview `noindex` header.
- Activity level of Arabic women's forums in 2026; Egyptian rules on paid creator health promotion.
- That every † feature ships in the release candidate (R4).
