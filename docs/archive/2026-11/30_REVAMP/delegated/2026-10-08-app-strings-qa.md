# App strings QA: Android ARB files (EN source vs AR, FR, ES)

> **Lead review, 2026-10-08: accepted with fixes.** Reviewed every Arabic row and every
> FR/ES row; applied in the same commit as P3.6.
>
> - **Rejected (8 rows): the brand rows.** `docs/12` §2 fixes the *logo wordmark* in Latin;
>   running Arabic text spells the name فيميو (86 uses in the website catalogue). The agent
>   was misled by our own brief, which said "the wordmark is always femio in every
>   language"; `.claude/agents/femio-translator.md` now says what the rule is.
> - **Rejected: masculine يمكنك (2 rows).** Unvocalised, يمكنك is read in either gender;
>   the file does not vocalise elsewhere.
> - **Rejected: فريق رعاية الحمل → فريق الولادة, FR soignant → clinicien·ne, the EN intro
>   rewording, and the movement-claim concern** (NHS: "there's no set number of normal
>   movements"; the sentence comes from the reviewed warning-signs article).
> - **Accepted with a better fix:** waters breaking now reads السائل الأمنيوسي (ماء الرأس):
>   the agent's term alone is accurate but clinical, and ماء الرأس is how women in Egypt and
>   the Gulf say it. IVF reads أطفال الأنابيب (IVF), the everyday term. The Arabic trimester
>   uses the CLDR `one/two/few` categories because gen-l10n rejects `=3`.
> - **Accepted:** the plural rows (now ICU plurals at the source, the website catalogues,
>   carried into the app by the generator as `int`), the French *tu* movement block
>   (now *vous*), FR/ES "by {date}", the AR due-date and conception terms, the AR
>   period-length question, perimenopause in AR and FR, the ES hedges and articles.
> - **Follow-up queued:** the website's French mixes *vous* (≈477) and *tu* (≈146) across
>   37 sections; a whole-catalogue register pass goes to the translator as its own task.


Date: 2026-10-08. Scope: `apps/mobile/lib/l10n/app_{en,ar,fr,es}.arb`. Findings only: no source file was edited.

## Snapshot note (read first)

The four ARB files were rewritten on disk at 12:20:13 UTC, during this review. They grew from 171 to 204 keys: new `preg*`, `contractions*` and `movements*` keys were added, and `git status` shows them as uncommitted. This report covers that 12:20:13 snapshot. Checksums (sha256):

```
187bbfdb590f31638a4e22834c2c0f45d6f107c119fc96df72d6faea91f60a7b  app_ar.arb
330a07fe98d7718673b91f790918c6a00e54bf96d677de5c41abdaab65c114dc  app_en.arb
87977df8bf8da7ab707ad8d7806ddcfde0137c735f7dfbb8fea80599a0243cea  app_es.arb
1cedae81e5efcd3f383d4a40b2fd1ebb854690ecb51543257a5183c3a08622b3  app_fr.arb
```

If the files change again, the rows below need re-checking against the new text.

## Scope and counts

- Non-metadata keys in the snapshot: 204.
- Skipped per instruction: 74 (`log*` 57, `flow*` 6, `opk*` 5, and `bbtChartHeading`, `bbtChartNeedData`, `bbtChartNote`, `invalidBbt`, `testTimingGeneral`, `testTimingSource`: 6).
- Reviewed keys per locale: **EN (source) 130, AR 130, FR 130, ES 130**. All four locales have every key; no missing or extra keys.
- Placeholder names match in all reviewed keys. The only ICU concern is number agreement, covered below.
- The Dart call sites were checked with grep, not by reading the screen files. `daysValue` is the only new-style call site found, and it passes an int. The `preg*`, `contractions*` and `movements*` keys have no Dart call sites yet.

Severity: **error** = wrong meaning, wrong gender or register, brand-rule violation, a medical or safety term that is wrong, or ungrammatical output. **awkward** = readable but unnatural or inconsistent.

## Systemic findings

1. **Brand (AR).** Arabic transliterates the brand as فيميو in 8 reviewed keys (plus skipped `bbtChartNote`). The rule is the Latin wordmark "femio" in every language.
2. **Plural agreement.** Six keys put a count or day number in a `String` placeholder and attach a noun: `pregDaysToGo`, `pregOverdue`, `movementsSessionSummary`, `movementsCounted`, `movementsNeedMore`, `contractionsSummaryHeading`. Arabic (1, 2, 3–10, 11+) and French/Spanish ("1 jours", "1 días") all break at 1 or 2. Nothing calls these keys yet, so change the metadata type to `int` and use ICU `plural` before wiring them. `movementsNeedMore` uses a fixed threshold, so it is only a risk if the threshold changes.
3. **French register.** The movement-log block (8 keys) switches to `tu`. Every other FR key uses `vous`.
4. **Feminine address (AR).** Two keys use masculine `يمكنك`. The rest of the Arabic file is feminine.
5. **Safety-critical wording.** The red-flag "waters break" phrase is wrong in AR; the AR due-date line says "birth date"; the FR/ES test-timing lines say "on" the date where the English says "by" it; the AR IVF label uses the IUI term.
6. **EN source issues** (for the English owner; not edited here): see the `en` rows.
7. **Typography (nit, not in table).** FR uses plain spaces before `?` and `:` (21 occurrences). French typography prefers a no-break space. FR also mixes straight and curly apostrophes (42 vs 14). Fix in one pass if you like.
8. **Source claim to confirm.** `movementsIntro` says "There is no normal number of movements." This is a strong clinical statement. The translations inherit its strength, so confirm it against the source before release. Not a translation error.

## Table: strings that need a change

Only changed fragments are shown; the rest of each string is unchanged unless the proposed cell gives the whole string.

| key | locale | current | proposed | reason | severity |
|---|---|---|---|---|---|
| welcomeBody | ar | …ولا تراها **فيميو** أبدًا. | …ولا تراها **femio** أبدًا. | Brand: keep the Latin wordmark. | error |
| birthYearSub | ar | …يساعد هذا **فيميو** على فهم… | …يساعد هذا **femio** على فهم… | Brand. | error |
| under18Body | ar | المتابعة في **فيميو** للنساء… | المتابعة في **femio** للنساء… | Brand. | error |
| irregularNote | ar | …لذا يعرض **فيميو** نطاقًا أوسع… | …لذا يعرض **femio** نطاقًا أوسع… | Brand. | error |
| noPredictionBody | ar | …وسيتوقّع **فيميو** الدورة التالية. | …وسيتوقّع **femio** الدورة التالية. | Brand. | error |
| menoUnknown | ar | …وسيحتفظ **فيميو** بالسجل… | …وسيحتفظ **femio** بالسجل… | Brand. | error |
| contractionsIntro | ar | …يحتفظ **فيميو** بالأوقات… | …يحتفظ **femio** بالأوقات… | Brand. | error |
| contractionsSummaryNote | ar | …لا يقرّر **فيميو** معناها… | …لا يقرّر **femio** معناها… | Brand (and see the "قسم الولادة" row). | error |
| goalSub | ar | يمكنك تغيير هذا في أي وقت. | يمكنكِ تغيير هذا في أي وقت. | Gender: feminine address used throughout the AR file (بكِ, ابدئي, لست متأكدة). | error |
| movementsFinishNote | ar | يمكنك التوقف في أي وقت. | يمكنكِ التوقف في أي وقت. | Gender, as above. | error |
| periodLengthTitle | ar | كم يومًا تستمر **دورتك** عادةً؟ | كم يومًا يستمر **نزيف دورتك** عادةً؟ | "دورتك" reads as "your cycle", the same word as the cycle-length question below it. The answer feeds the prediction, so the two can be confused. | error |
| dueMethodIvf3 | ar | نقل أجنة **بالتلقيح الصناعي** (جنين اليوم الثالث) | نقل جنين اليوم الثالث **بالإخصاب في المختبر (IVF)** | "التلقيح الصناعي" is also the term for IUI (artificial insemination). The method changes the due-date calculation, so a wrong label gives a wrong date. | error |
| dueMethodIvf5 | ar | نقل أجنة **بالتلقيح الصناعي** (جنين اليوم الخامس) | نقل جنين اليوم الخامس **بالإخصاب في المختبر (IVF)** | Same as above. | error |
| trimesterLabel | ar | الثلث {n} | `{n, plural, =1{الثلث الأول} =2{الثلث الثاني} =3{الثلث الثالث} other{الثلث {n}}}` | "الثلث 1" is not Arabic; trimesters are ordinal words. The placeholder is already `int`. | error |
| testTimingBody | fr | Si vos règles n'ont pas commencé **le {date}** | Si vos règles ne sont pas arrivées **d'ici le {date}** | "le {date}" means "on that day"; the English "by {date}" means "no later than". If the period began before the date, "not started on that day" is true and the message wrongly says the test is reliable. | error |
| testTimingBody | es | Si tu regla no ha empezado **el {date}** | Si **para el {date}** tu regla aún no ha empezado | Same "on" versus "by" problem. | error |
| pregEstimateNote | ar | …على **تاريخ الولادة** الذي أدخلتِه. | …على **موعد الولادة المتوقّع** الذي أدخلتِه. | "تاريخ الولادة" means date of birth. The user entered a due date. | error |
| contractionsContactBody | ar | …أو إن نزل **ماء الرأس**، أو حدث نزيف… | …أو إن نزل **السائل الأمنيوسي**، أو حدث نزيف… | "ماء الرأس" means water of the head, which is a different condition. This is a red-flag item: the waters breaking (amniotic fluid). | error |
| goalMenopause | fr | **Préménopause** et ménopause | **Périménopause** et ménopause | EN "Perimenopause" is the transition period. "Préménopause" is an earlier stage in French clinical use. | error |
| pregDaysToGo | en | {days} days to go (`days`: String) | `{days, plural, =1{1 day to go} other{{days} days to go}}`, with `days` typed `int` | "1 days to go". Source change for the English owner. | error |
| pregDaysToGo | ar | بقي {days} يومًا | `{days, plural, =1{بقي يوم واحد} =2{بقي يومان} few{بقي {days} أيام} other{بقي {days} يومًا}}` | "يومًا" is wrong for 1, 2 and 3–10. | error |
| pregDaysToGo | fr | Encore {days} jours | `{days, plural, =1{Encore 1 jour} other{Encore {days} jours}}` | "1 jours". | error |
| pregDaysToGo | es | Quedan {days} días | `{days, plural, =1{Queda 1 día} other{Quedan {days} días}}` | "1 días". | error |
| pregOverdue | en | {days} days past your due date (`days`: String) | `{days, plural, =1{1 day past your due date} other{{days} days past your due date}}`, with `days` typed `int` | "1 days past". Source change for the English owner. | error |
| pregOverdue | ar | مضى {days} يومًا على تاريخ الولادة المتوقّع | `{days, plural, =1{مضى يوم واحد على موعد الولادة المتوقّع} =2{مضى يومان على موعد الولادة المتوقّع} few{مضى {days} أيام على موعد الولادة المتوقّع} other{مضى {days} يومًا على موعد الولادة المتوقّع}}` | Number agreement for 1, 2, 3–10. "تاريخ الولادة" changed to "موعد الولادة المتوقّع" (the due-date term used elsewhere, e.g. dueDateTitle). | error |
| pregOverdue | fr | {days} jours après la date prévue | `{days, plural, =1{1 jour après la date prévue} other{{days} jours après la date prévue}}` | "1 jours". | error |
| pregOverdue | es | {days} días después de la fecha prevista | `{days, plural, =1{1 día después de la fecha probable de parto} other{{days} días después de la fecha probable de parto}}` | "1 días". "Fecha probable de parto" is the ES due-date term (dueDateTitle). | error |
| movementsSessionSummary | en | {count} movements · about {minutes} min apart | `{count, plural, =1{1 movement} other{{count} movements}} · about {minutes} min apart`, with `count` typed `int` | "1 movements". Source change for the English owner. | error |
| movementsSessionSummary | ar | {count} حركة · نحو {minutes} دقيقة بين كل حركة | `{count, plural, =1{حركة واحدة} =2{حركتان} few{{count} حركات} other{{count} حركة}} · نحو {minutes, plural, =1{دقيقة واحدة} =2{دقيقتان} few{{minutes} دقائق} other{{minutes} دقيقة}} بين كل حركة` | Number agreement for the count and the minutes. | error |
| movementsSessionSummary | fr | {count} mouvements · environ {minutes} min d'intervalle | `{count, plural, =1{1 mouvement} other{{count} mouvements}} · environ {minutes} min d'intervalle` | "1 mouvements". | error |
| movementsSessionSummary | es | {count} movimientos · unos {minutes} min de diferencia | `{count, plural, =1{1 movimiento} other{{count} movimientos}} · unos {minutes} min de diferencia` | "1 movimientos". | error |
| movementsCounted | ar | {count} مسجّلة | `{count, plural, =1{حركة واحدة مسجّلة} =2{حركتان مسجّلتان} few{{count} حركات مسجّلة} other{{count} حركة مسجّلة}}` | Number agreement at 1, 2, 3–10. | error |
| movementsCounted | fr | {count} enregistrés | `{count, plural, =1{1 mouvement enregistré} other{{count} enregistrés}}` | "1 enregistrés". | error |
| movementsCounted | es | {count} registrados | `{count, plural, =1{1 registrado} other{{count} registrados}}` | "1 registrados". | error |
| movementsIntro | fr | …habitudes de **ton** bébé : ce journal enregistre ce que **tu** ressens et **te** montre **ton** propre rythme… | …habitudes de **votre** bébé : ce journal enregistre ce que **vous** ressentez et **vous** montre **votre** propre rythme… | Register: `tu` where the rest of FR uses `vous`. | error |
| movementsUrgentBody | fr | Contacte ton équipe de maternité maintenant. N'attends pas la fin de cette séance, et n'attends pas demain. | Contactez votre équipe de maternité maintenant. N'attendez pas la fin de cette séance, et n'attendez pas demain. | Register. | error |
| movementsStartBody | fr | Installe-toi confortablement, puis commence. Appuie chaque fois que tu sens un mouvement. | Installez-vous confortablement, puis commencez. Appuyez chaque fois que vous sentez un mouvement. | Register. | error |
| movementsFinishNote | fr | Tu peux arrêter à tout moment. | Vous pouvez arrêter à tout moment. | Register. | error |
| movementsRecentHeading | fr | Tes séances récentes | Vos séances récentes | Register. | error |
| movementsSlowerHeading | fr | …plus espacés que d'habitude pour toi | …plus espacés que d'habitude pour vous | Register. | error |
| movementsSlowerBody | fr | …à tes séances récentes. Ce que cela signifie, c'est à ton équipe de maternité de le dire : contacte-la pour qu'on vérifie. | …à vos séances récentes. Ce que cela signifie, c'est à votre équipe de maternité de le dire : contactez-la pour qu'on vérifie. | Register. | error |
| movementsNeedMore | fr | Après {count} séances, tu pourras comparer avec ton propre rythme. | Après {count} séances, vous pourrez comparer avec votre propre rythme. | Register. | error |
| contractionsSummaryHeading | en | Your last {count} | `{count, plural, =1{Your last contraction} other{Your last {count} contractions}}`, with `count` typed `int` | The heading has no noun, so it is unclear what is counted. Source change for the English owner. | awkward |
| contractionsSummaryHeading | ar | آخر {count} | `{count, plural, =1{آخر انقباضة} =2{آخر انقباضتين} few{آخر {count} انقباضات} other{آخر {count} انقباضة}}` | No noun, and numeral agreement is missing. FR "Vos {count} dernières" and ES "Tus últimas {count}" are acceptable as they are, because the noun is implied. | awkward |
| contractionsIntro | en | Press start when one begins and stop when it eases. | Press "Start a contraction" when one begins and "It has eased" when it does. | No button is called "stop". Quoting the real labels lets each locale match them (AR already does). Source change for the English owner. | awkward |
| contractionsContactHeading | ar | اتصلي بقسم الولادة متى شئتِ | اتصلي بوحدة الولادة متى احتجتِ إلى ذلك | "وحدة الولادة" is the term in pregRedFlagsBody. "متى شئتِ" means "whenever you like", not "whenever you need to". | awkward |
| contractionsSummaryNote | ar | …اقرئيها على القابلة أو **قسم الولادة**… | …اقرئيها على القابلة أو **وحدة الولادة**… | Terminology: one term for "maternity unit". | awkward |
| movementsUrgentBody | ar | تواصلي مع **فريق رعاية الحمل** الآن. | تواصلي مع **فريق الولادة** الآن. | "Maternity team" is not the same service as a pregnancy-care team. | awkward |
| movementsSlowerBody | ar | تفسير ذلك يعود إلى **فريق رعاية الحمل** | تفسير ذلك يعود إلى **فريق الولادة** | Same as above. | awkward |
| movementsStartBody | ar | …انقري في كل مرة تشعرين فيها بحركة. | …**اضغطي** في كل مرة تشعرين فيها بحركة. | "انقري" is an unfamiliar verb for tap. The file uses "اضغطي" for taps (calendarHint, contractionsIntro). | awkward |
| movementsUrgentHeading | ar | إذا كانت **الحركة** أقل من المعتاد | إذا قلّت **الحركات** عن المعتاد | Singular "الحركة" for plural "movements". | awkward |
| goalMenopause | ar | **ما قبل** انقطاع الطمث وانقطاعه | **ما حول** انقطاع الطمث وانقطاعه | "ما قبل" means pre-; "peri-" means around. | awkward |
| dueMethodConception | ar | **تاريخ الحمل** (الإخصاب) | **تاريخ الإخصاب** | "تاريخ الحمل" reads as a pregnancy date. Conception is الإخصاب. | awkward |
| conceptionTitle | ar | متى **حدث الحمل**؟ | متى **حدث الإخصاب**؟ | Same term as dueMethodConception. | awkward |
| dueMethodTitle | ar | كيف نحسب موعد ولادتك**؟** | كيف نحسب موعد ولادتك **المتوقّع**؟ | "موعد ولادتك" can read as a birth date; dueDateTitle uses المتوقّع. | awkward |
| pregTermFrom | ar | **تمام الحمل** اعتبارًا من {date} | **الحمل تامّ المدة** اعتبارًا من {date} | "Full term" is تام المدة. "تمام الحمل" is unclear. | awkward |
| dueMethodTitle | fr | Comment calculer votre **date d'accouchement** ? | Comment calculer votre **date prévue** ? | "Date d'accouchement" is the actual delivery date (birthDateTitle asks that). Use "date prévue" as elsewhere. | awkward |
| legendSpotting | fr | **Saignement léger** | **Spotting** | Spotting is "Spotting" in logSpotting (skipped key) and "Léger (spotting)" in flowSpotting. Use one term. | awkward |
| calendarHint | fr | …ce que vous notez est **plein**. | …ce que vous notez est **rempli**. | "Plein" is an odd word for filled-in. | awkward |
| menoUnknown | fr | …pour votre **soignant**. | …pour votre **clinicien·ne**. | Clinician term: the skipped bbtChartNote uses "clinicien·ne" (website catalogue). | awkward |
| contractionsIntro | fr | Appuyez sur démarrer quand une contraction commence et sur **arrêter** quand elle passe. Femio garde les temps pour que vous les ayez **au téléphone**. | Appuyez sur « Démarrer une contraction » quand elle commence, et sur « Elle s’est atténuée » quand elle s’atténue. Femio garde les temps pour que vous les ayez sous la main quand vous appelez. | No button says "arrêter"; the labels are "Démarrer une contraction" and "C’est passé". Quote the real labels. "Au téléphone" is ambiguous. | awkward |
| contractionsStop | fr | **C’est passé** | **Elle s’est atténuée** | EN "It has eased" means lessened. "C’est passé" says the contraction is over. | awkward |
| legendPredicted | es | La regla **podría** empezar | La regla **puede** empezar | Hedge: EN "may". "Podría" (could) is the more hypothetical form. | awkward |
| predictionNextPeriod | es | Próxima regla **hacia** {range} | Próxima regla **alrededor de** {range} | Hedge: EN "around". "Hacia" means toward. | awkward |
| dueDateLabel | es | Fecha de parto **hacia el** {date} | Fecha **probable** de parto **alrededor del** {date} | Same hedge fix. Due-date term: "fecha probable de parto". Bare "fecha de parto" can mean the actual delivery. | awkward |
| dueMethodTitle | es | ¿Cómo calculamos tu fecha de parto? | ¿Cómo calculamos tu fecha **probable** de parto? | Due-date term consistency with dueDateTitle. | awkward |
| sectionDischarge | es | **Flujo** | **Flujo vaginal** | "Flujo" alone is also the period-flow label (flowLabel), on the same log screen. | awkward |
| calendarHint | es | …lo que registras, **relleno**. | …lo que registras **aparece relleno**. | Elliptical; "relleno" reads as a noun. | awkward |
| basisStated | es | Según la duración **de ciclo** que nos indicaste | Según la duración **del ciclo** que nos indicaste | Missing article. | awkward |
| seeClinicianTtc | es | …es **buen momento** para hablar con un profesional. | …es **un buen momento** para hablar con un profesional. | Missing article. | awkward |
| contractionsIntro | es | Pulsa empezar cuando comience una y parar cuando afloje. | Pulsa **«Empezar una contracción»** cuando comience y **«Ya aflojó»** cuando afloje. | Quote the real button labels, as the AR does. | awkward |

## Terminology (for consistent future work)

| English | AR | FR | ES | Note |
|---|---|---|---|---|
| femio (brand) | femio (Latin, never فيميو) | femio | femio | Brand rule, all locales. |
| period (the bleed) | الدورة / دورتي | règles | regla | Use "نزيف الدورة" when precision is needed. |
| cycle (whole interval) | طول الدورة; الدورة الشهرية | cycle | ciclo | Do not use bare "دورة" for the interval in questions. |
| due date | موعد الولادة المتوقّع (short: موعد ولادتك) | date prévue (never "date d'accouchement") | fecha probable de parto (never bare "fecha de parto") | Keep "fecha de parto" out of the new keys. dueMethodKnown and goalPregnantDesc still use it. Decide and align. |
| fertile window | أيام الخصوبة / أيام خصوبتك | fenêtre de fertilité | ventana fértil | Consistent across the file. |
| ovulation / likely ovulation | الإباضة / الإباضة المرجّحة | ovulation / ovulation probable | ovulación / ovulación probable | Consistent. |
| around (approximate) | حوالي | vers / environ | alrededor de (not hacia) | Hedge strength matches "around". |
| may (hedge) | قد | peut / peuvent | puede (not podría) | Hedge strength matches "may". |
| conception | الإخصاب | conception | concepción | Replace الحمل where it means conception. |
| IVF | الإخصاب في المختبر (IVF) (not التلقيح الصناعي, which is IUI) | FIV | FIV | |
| embryo transfer | نقل جنين / نقل أجنة | transfert d'embryon | transferencia de embriones | |
| trimester | الثلث الأول / الثاني / الثالث | Trimestre {n} | Trimestre {n} | AR needs ordinal words, not a number. |
| perimenopause / menopause | ما حول انقطاع الطمث / انقطاع الطمث | périménopause / ménopause | perimenopausia / menopausia | FR "préménopause" is wrong for perimenopause. |
| spotting | تنقيط | Spotting | Manchado | FR legendSpotting currently differs. |
| discharge | الإفرازات | Pertes | Flujo vaginal (not "Flujo") | "Flujo" is the period-flow label. |
| clinician (generic) | طبيبة أو طبيب / طبيبكِ | clinicien·ne (not soignant) | profesional sanitario / tu profesional | |
| maternity unit / team | وحدة الولادة / فريق الولادة | la maternité / équipe de maternité | unidad de maternidad / equipo de maternidad | AR "قسم الولادة" to be replaced by "وحدة الولادة". |
| midwife | القابلة | sage-femme | matrona | |
| tap (button) | اضغطي | Appuyez | Pulsa / Toca | |
| contraction | الانقباضة / الانقباضات | contraction | contracción | |
| waters break | نزول السائل الأمنيوسي | perdre les eaux | romper aguas | Not "ماء الرأس". |
| fetal movement | حركة الجنين | mouvements du bébé | movimientos del bebé | |
| log (verb) / log (title) | سجّلي / السجل | Notez / Journal | Registra / Registro | |
| stored on this phone | محفوظ على هذا الهاتف | Enregistré sur ce téléphone | Guardado en este teléfono | |
| estimate / confidence | تقديرات / ثقة | estimations / Confiance | Estimaciones / Confianza | |
| register | feminine second person (ابدئي, بكِ) | vous | tú | Only the FR movement block breaks this. |

## Keys reviewed per locale

| locale | keys reviewed | notes |
|---|---|---|
| en (source) | 130 | Source issues listed above (pregDaysToGo, pregOverdue, movementsSessionSummary, contractionsSummaryHeading, contractionsIntro). |
| ar | 130 | Rows above. |
| fr | 130 | Rows above. |
| es | 130 | Rows above. |

Skipped (not reviewed): 74 keys, as instructed. One out-of-scope item noticed: skipped key `bbtChartNote` (ar) also transliterates the brand as فيميو. It should get the same fix when that catalogue is next touched.

## Checked and fine (no change needed)

Placeholders match in every reviewed key. Arabic plurals in `daysValue`, `postpartumWeeks`, `menoMonths` and `loggedTodayCount` are correct. The hedges in `predictionOvulation`, `irregularNote`, `seeClinicianTtc`, `awarenessNote` and `confidenceLow` match the English. The red-flag wording in `pregRedFlagsBody` is accurate in all locales. Not reviewed beyond the grep: the screen files, apart from the Dart call sites.
