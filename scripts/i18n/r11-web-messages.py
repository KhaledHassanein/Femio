"""Merge the R13 calculator strings into the four website catalogues (one-off, kept for review).

Why it exists: the four catalogues must gain the same keys in one step, with every
language written as full sentences (no English left in AR/FR/ES). Re-running is safe:
keys are set, not appended.

Run from the repo root: python scripts/i18n/r11-web-messages.py
"""

from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
MESSAGES = ROOT / "apps" / "web" / "messages"

# ---------------------------------------------------------------------------------
# Due date: other methods (R13.1)
# ---------------------------------------------------------------------------------
DUE = {
    "en": {
        "intro": "Tap the first day of your last period, or choose conception, IVF transfer or a dating scan, to see your estimated due date and your week on one calendar. Nothing is stored.",
        "methodLabel": "How do you know the date?",
        "method": {"lmp": "Last period", "conception": "Conception", "transfer": "IVF transfer", "scan": "Dating scan"},
        "embryoLabel": "Embryo age at transfer",
        "embryo": {"day3": "Day 3", "day5": "Day 5"},
        "prompt": {
            "conception": "Tap the day you conceived",
            "transfer": "Tap the day of the embryo transfer",
            "scan": "Tap the day of your scan",
        },
        "scanWeeksLabel": "Weeks on the scan report",
        "scanDaysLabel": "Extra days on the report",
        "weeksUnit": "weeks",
        "weeks": "{count, plural, one {# week} other {# weeks}}",
        "fewerWeeks": "Fewer weeks",
        "moreWeeks": "More weeks",
        "fewerDays": "Fewer days",
        "moreDays": "More days",
        "scanNote": "This uses the weeks and days on your scan report as written. If your clinician has given you a due date, follow theirs.",
        "faq2": {
            "q": "Does the ultrasound date replace this one?",
            "a": "If a clinician has given you a due date from a scan, follow theirs. You can also choose \"Dating scan\" and enter the weeks and days from your report; the calculator takes them as written and does not compare them with your period.",
        },
    },
    "ar": {
        "intro": "اضغطي على أول يوم من آخر دورة، أو اختاري الإخصاب أو نقل الأجنة أو سونار تحديد عمر الحمل، لتري موعد الولادة المتوقع وأسبوع الحمل على تقويم واحد، دون حفظ أي بيانات.",
        "methodLabel": "كيف تعرفين التاريخ؟",
        "method": {"lmp": "آخر دورة", "conception": "الإخصاب", "transfer": "نقل الأجنة", "scan": "سونار تحديد العمر"},
        "embryoLabel": "عمر الجنين عند النقل",
        "embryo": {"day3": "اليوم الثالث", "day5": "اليوم الخامس"},
        "prompt": {
            "conception": "اضغطي على يوم الإخصاب",
            "transfer": "اضغطي على يوم نقل الأجنة",
            "scan": "اضغطي على يوم السونار",
        },
        "scanWeeksLabel": "الأسابيع في تقرير السونار",
        "scanDaysLabel": "الأيام الزائدة في التقرير",
        "weeksUnit": "أسابيع",
        "weeks": "{count, plural, zero {# أسبوع} one {أسبوع واحد} two {أسبوعان} few {# أسابيع} many {# أسبوعًا} other {# أسبوع}}",
        "fewerWeeks": "أسابيع أقل",
        "moreWeeks": "أسابيع أكثر",
        "fewerDays": "أيام أقل",
        "moreDays": "أيام أكثر",
        "scanNote": "تُستخدم الأسابيع والأيام كما وردت في تقرير السونار. إذا أعطتكِ طبيبتكِ موعدًا للولادة فاعتمدي موعدها.",
        "faq2": {
            "q": "هل يحلّ تاريخ السونار محلّ هذا التاريخ؟",
            "a": "إذا أعطتكِ طبيبتكِ موعدًا محسوبًا من السونار فاعتمدي موعدها. ويمكنكِ أيضًا اختيار «سونار تحديد العمر» وإدخال الأسابيع والأيام من تقريركِ؛ تأخذها الحاسبة كما هي ولا تقارنها بتاريخ دورتكِ.",
        },
    },
    "fr": {
        "intro": "Touchez le premier jour de vos dernières règles, ou choisissez la conception, un transfert de FIV ou une échographie de datation, pour voir votre date prévue et votre semaine sur un même calendrier. Rien n'est enregistré.",
        "methodLabel": "D'où vient votre date ?",
        "method": {"lmp": "Dernières règles", "conception": "Conception", "transfer": "Transfert FIV", "scan": "Échographie de datation"},
        "embryoLabel": "Âge de l'embryon au transfert",
        "embryo": {"day3": "Jour 3", "day5": "Jour 5"},
        "prompt": {
            "conception": "Touchez le jour de la conception",
            "transfer": "Touchez le jour du transfert d'embryon",
            "scan": "Touchez le jour de votre échographie",
        },
        "scanWeeksLabel": "Semaines sur le compte rendu",
        "scanDaysLabel": "Jours en plus sur le compte rendu",
        "weeksUnit": "semaines",
        "weeks": "{count, plural, one {# semaine} other {# semaines}}",
        "fewerWeeks": "Moins de semaines",
        "moreWeeks": "Plus de semaines",
        "fewerDays": "Moins de jours",
        "moreDays": "Plus de jours",
        "scanNote": "Le calcul reprend les semaines et les jours de votre compte rendu tels quels. Si votre soignant vous a donné une date prévue, suivez la sienne.",
        "faq2": {
            "q": "La date de l'échographie remplace-t-elle celle-ci ?",
            "a": "Si un soignant vous a donné une date prévue d'après une échographie, suivez la sienne. Vous pouvez aussi choisir « Échographie de datation » et saisir les semaines et les jours de votre compte rendu ; le calculateur les reprend tels quels et ne les compare pas à vos règles.",
        },
    },
    "es": {
        "intro": "Toca el primer día de tu última regla, o elige concepción, transferencia de FIV o ecografía de datación, para ver tu fecha probable de parto y tu semana en un mismo calendario. No se guarda nada.",
        "methodLabel": "¿De dónde sale tu fecha?",
        "method": {"lmp": "Última regla", "conception": "Concepción", "transfer": "Transferencia FIV", "scan": "Ecografía de datación"},
        "embryoLabel": "Edad del embrión al transferirlo",
        "embryo": {"day3": "Día 3", "day5": "Día 5"},
        "prompt": {
            "conception": "Toca el día de la concepción",
            "transfer": "Toca el día de la transferencia de embriones",
            "scan": "Toca el día de tu ecografía",
        },
        "scanWeeksLabel": "Semanas en el informe de la ecografía",
        "scanDaysLabel": "Días de más en el informe",
        "weeksUnit": "semanas",
        "weeks": "{count, plural, one {# semana} other {# semanas}}",
        "fewerWeeks": "Menos semanas",
        "moreWeeks": "Más semanas",
        "fewerDays": "Menos días",
        "moreDays": "Más días",
        "scanNote": "Se usan las semanas y los días de tu informe tal como aparecen. Si tu profesional sanitario te ha dado una fecha de parto, sigue la suya.",
        "faq2": {
            "q": "¿La fecha de la ecografía sustituye a esta?",
            "a": "Si un profesional sanitario te ha dado una fecha de parto según una ecografía, sigue la suya. También puedes elegir «Ecografía de datación» e introducir las semanas y los días de tu informe; la calculadora los toma tal cual y no los compara con tu regla.",
        },
    },
}

LEGEND = {
    "en": {"conception": "The day you conceived", "transfer": "Transfer day", "scan": "Scan day", "due": "Due date"},
    "ar": {"conception": "يوم الإخصاب", "transfer": "يوم النقل", "scan": "يوم السونار", "due": "موعد الولادة"},
    "fr": {"conception": "Le jour de la conception", "transfer": "Jour du transfert", "scan": "Jour de l'échographie", "due": "Date prévue"},
    "es": {"conception": "El día de la concepción", "transfer": "Día de la transferencia", "scan": "Día de la ecografía", "due": "Fecha de parto"},
}

LIST = {
    "en": {
        "dueDate": {"desc": "From your last period, conception, an IVF transfer or a scan."},
        "pregnancyCalendar": {"name": "Pregnancy calendar", "desc": "The dates of every pregnancy week, with each week's guide."},
        "weightGain": {"name": "Pregnancy weight gain", "desc": "The reference range for your BMI before pregnancy."},
        "contractionTimer": {"name": "Contraction timer", "desc": "Time contractions and read the numbers to your maternity unit."},
    },
    "ar": {
        "dueDate": {"desc": "من آخر دورة أو الإخصاب أو نقل الأجنة أو السونار."},
        "pregnancyCalendar": {"name": "تقويم الحمل", "desc": "تواريخ كل أسبوع من الحمل، مع دليل كل أسبوع."},
        "weightGain": {"name": "زيادة الوزن في الحمل", "desc": "النطاق المرجعي حسب مؤشر كتلة جسمكِ قبل الحمل."},
        "contractionTimer": {"name": "مؤقّت الانقباضات", "desc": "سجّلي أوقات الانقباضات واقرئي الأرقام لوحدة الولادة."},
    },
    "fr": {
        "dueDate": {"desc": "D'après vos dernières règles, la conception, un transfert de FIV ou une échographie."},
        "pregnancyCalendar": {"name": "Calendrier de grossesse", "desc": "Les dates de chaque semaine de grossesse, avec le guide de la semaine."},
        "weightGain": {"name": "Prise de poids pendant la grossesse", "desc": "La fourchette de référence selon votre IMC avant la grossesse."},
        "contractionTimer": {"name": "Minuteur de contractions", "desc": "Chronométrez vos contractions et lisez les chiffres à la maternité."},
    },
    "es": {
        "dueDate": {"desc": "Según tu última regla, la concepción, una transferencia de FIV o una ecografía."},
        "pregnancyCalendar": {"name": "Calendario del embarazo", "desc": "Las fechas de cada semana del embarazo, con la guía de cada semana."},
        "weightGain": {"name": "Aumento de peso en el embarazo", "desc": "El rango de referencia según tu IMC antes del embarazo."},
        "contractionTimer": {"name": "Temporizador de contracciones", "desc": "Cronometra las contracciones y lee las cifras a tu maternidad."},
    },
}

# ---------------------------------------------------------------------------------
# Pregnancy calendar (R13.2, MR-54)
# ---------------------------------------------------------------------------------
CAL = {
    "en": {
        "title": "Pregnancy calendar, week by week",
        "intro": "Tap your due date or the first day of your last period to see the dates of every pregnancy week, the trimesters, and each week's guide. Nothing is stored.",
        "metaTitle": "Pregnancy Calendar: Your Pregnancy Week by Week, with Dates",
        "methodLabel": "Which date do you know?",
        "method": {"edd": "Due date", "lmp": "Last period"},
        "promptEdd": "Tap your due date",
        "eyebrow": "Your pregnancy, week by week",
        "headline": "Due date around {date}",
        "trimesterLine": "Second trimester from {second}; third trimester from {third}.",
        "week": "Week {week}",
        "current": "This week",
        "readGuide": "Read the week {week} guide",
        "noGuide": "No separate guide for this week",
        "faq": [
            {"q": "How are pregnancy weeks counted?", "a": "From the first day of your last period, which is 280 days (40 weeks) before the due date. \"24 weeks\" means 24 completed weeks: from 24 weeks and 0 days to 24 weeks and 6 days."},
            {"q": "When do the trimesters change?", "a": "The second trimester starts at 14 weeks and the third at 28 weeks. The calendar shows the date each one starts for your due date."},
            {"q": "My scan gave a different date. Which should I use?", "a": "Use the due date your clinician gives you. Choose \"Due date\" and tap it, and every week follows that date."},
        ],
    },
    "ar": {
        "title": "تقويم الحمل أسبوعًا بأسبوع",
        "intro": "اضغطي على موعد ولادتكِ المتوقع أو على أول يوم من آخر دورة لتري تواريخ كل أسبوع من الحمل والأثلاث الثلاثة ودليل كل أسبوع، دون حفظ أي بيانات.",
        "metaTitle": "تقويم الحمل: حملكِ أسبوعًا بأسبوع مع التواريخ",
        "methodLabel": "أي تاريخ تعرفين؟",
        "method": {"edd": "موعد الولادة", "lmp": "آخر دورة"},
        "promptEdd": "اضغطي على موعد ولادتكِ المتوقع",
        "eyebrow": "حملكِ أسبوعًا بأسبوع",
        "headline": "موعد الولادة تقريبًا {date}",
        "trimesterLine": "الثلث الثاني من {second}، والثلث الثالث من {third}.",
        "week": "الأسبوع {week}",
        "current": "هذا الأسبوع",
        "readGuide": "اقرئي دليل الأسبوع {week}",
        "noGuide": "لا يوجد دليل منفصل لهذا الأسبوع",
        "faq": [
            {"q": "كيف تُحسب أسابيع الحمل؟", "a": "من أول يوم في آخر دورة، أي قبل موعد الولادة بـ 280 يومًا (40 أسبوعًا). و«الأسبوع 24» يعني 24 أسبوعًا مكتملًا: من 24 أسبوعًا و0 أيام إلى 24 أسبوعًا و6 أيام."},
            {"q": "متى يتغيّر الثلث؟", "a": "يبدأ الثلث الثاني عند الأسبوع 14، والثلث الثالث عند الأسبوع 28. ويعرض التقويم تاريخ بداية كل ثلث حسب موعد ولادتكِ."},
            {"q": "أعطاني السونار تاريخًا مختلفًا، أيهما أعتمد؟", "a": "اعتمدي موعد الولادة الذي تعطيكِ إياه طبيبتكِ. اختاري «موعد الولادة» واضغطي عليه، فتتبعه كل الأسابيع."},
        ],
    },
    "fr": {
        "title": "Calendrier de grossesse, semaine par semaine",
        "intro": "Touchez votre date prévue ou le premier jour de vos dernières règles pour voir les dates de chaque semaine de grossesse, les trimestres et le guide de chaque semaine. Rien n'est enregistré.",
        "metaTitle": "Calendrier de grossesse : votre grossesse semaine par semaine, avec les dates",
        "methodLabel": "Quelle date connaissez-vous ?",
        "method": {"edd": "Date prévue", "lmp": "Dernières règles"},
        "promptEdd": "Touchez votre date prévue",
        "eyebrow": "Votre grossesse, semaine par semaine",
        "headline": "Date prévue vers le {date}",
        "trimesterLine": "Deuxième trimestre à partir du {second} ; troisième trimestre à partir du {third}.",
        "week": "Semaine {week}",
        "current": "Cette semaine",
        "readGuide": "Lire le guide de la semaine {week}",
        "noGuide": "Pas de guide séparé pour cette semaine",
        "faq": [
            {"q": "Comment compte-t-on les semaines de grossesse ?", "a": "À partir du premier jour des dernières règles, soit 280 jours (40 semaines) avant la date prévue. « 24 semaines » signifie 24 semaines révolues : de 24 semaines et 0 jour à 24 semaines et 6 jours."},
            {"q": "Quand change-t-on de trimestre ?", "a": "Le deuxième trimestre commence à 14 semaines et le troisième à 28 semaines. Le calendrier montre la date de début de chacun pour votre date prévue."},
            {"q": "Mon échographie donne une autre date. Laquelle utiliser ?", "a": "Utilisez la date prévue que votre soignant vous donne. Choisissez « Date prévue » et touchez-la : toutes les semaines suivent cette date."},
        ],
    },
    "es": {
        "title": "Calendario del embarazo, semana a semana",
        "intro": "Toca tu fecha probable de parto o el primer día de tu última regla para ver las fechas de cada semana del embarazo, los trimestres y la guía de cada semana. No se guarda nada.",
        "metaTitle": "Calendario del embarazo: tu embarazo semana a semana, con fechas",
        "methodLabel": "¿Qué fecha conoces?",
        "method": {"edd": "Fecha de parto", "lmp": "Última regla"},
        "promptEdd": "Toca tu fecha probable de parto",
        "eyebrow": "Tu embarazo, semana a semana",
        "headline": "Fecha de parto hacia el {date}",
        "trimesterLine": "Segundo trimestre desde el {second}; tercer trimestre desde el {third}.",
        "week": "Semana {week}",
        "current": "Esta semana",
        "readGuide": "Leer la guía de la semana {week}",
        "noGuide": "No hay guía aparte para esta semana",
        "faq": [
            {"q": "¿Cómo se cuentan las semanas de embarazo?", "a": "Desde el primer día de la última regla, que es 280 días (40 semanas) antes de la fecha de parto. «24 semanas» significa 24 semanas cumplidas: de 24 semanas y 0 días a 24 semanas y 6 días."},
            {"q": "¿Cuándo cambian los trimestres?", "a": "El segundo trimestre empieza a las 14 semanas y el tercero a las 28. El calendario muestra la fecha de inicio de cada uno según tu fecha de parto."},
            {"q": "Mi ecografía dio otra fecha. ¿Cuál uso?", "a": "Usa la fecha de parto que te dé tu profesional sanitario. Elige «Fecha de parto» y tócala: todas las semanas siguen esa fecha."},
        ],
    },
}

# ---------------------------------------------------------------------------------
# Pregnancy weight gain (R13.3, MR-55)
# ---------------------------------------------------------------------------------
WG = {
    "en": {
        "title": "Pregnancy weight gain calculator",
        "intro": "Enter your weight before pregnancy and your height to see the reference range for total weight gain over the pregnancy, from the Institute of Medicine (2009). Nothing is stored.",
        "metaTitle": "Pregnancy Weight Gain Calculator: IOM Range by BMI",
        "weightMetric": "Weight before pregnancy (kg)",
        "weightImperial": "Weight before pregnancy (lb)",
        "babiesLabel": "How many babies?",
        "babies": {"one": "One", "two": "Twins", "more": "Three or more"},
        "bmiLine": "BMI before pregnancy: {value} ({band})",
        "eyebrow": "Reference range for total gain over the whole pregnancy",
        "rangeKg": "{low} to {high} kg",
        "rangeLb": "{low} to {high} lb",
        "otherUnit": "That is {range}.",
        "noRangeTwinsUnderweight": "The Institute of Medicine gives no range for twins when BMI before pregnancy is under 18.5. Your clinician will advise.",
        "noRangeMultiples": "The Institute of Medicine gives no range for three or more babies. Your clinician will advise.",
        "note": "This is a reference range for your BMI band before pregnancy, not a target or a judgement. Your clinician may suggest a different range for you.",
        "source": "Source: Institute of Medicine (2009), \"Weight Gain During Pregnancy\"; the same ranges are used by CDC and ACOG.",
        "outOfRange": "Enter a weight from {minW} to {maxW} kg and a height from {minH} to {maxH} cm.",
        "faq": [
            {"q": "How is the range chosen?", "a": "It depends on your BMI before pregnancy, using the ranges the US Institute of Medicine published in 2009. CDC and ACOG use the same ranges."},
            {"q": "What if I am expecting twins?", "a": "The Institute of Medicine gives provisional ranges for twins when BMI before pregnancy was 18.5 or more. For a lower BMI, or for three or more babies, it gives no range, and your clinician will advise."},
            {"q": "Can my clinician suggest a different range?", "a": "Yes. These are reference ranges for groups of women. Your clinician knows your health and may suggest a different range for you."},
        ],
    },
    "ar": {
        "title": "حاسبة زيادة الوزن في الحمل",
        "intro": "أدخلي وزنكِ قبل الحمل وطولكِ لتري النطاق المرجعي لإجمالي زيادة الوزن طوال الحمل، حسب معهد الطب الأمريكي (2009)، دون حفظ أي بيانات.",
        "metaTitle": "حاسبة زيادة الوزن في الحمل: نطاق معهد الطب حسب مؤشر كتلة الجسم",
        "weightMetric": "الوزن قبل الحمل (كغ)",
        "weightImperial": "الوزن قبل الحمل (رطل)",
        "babiesLabel": "كم عدد الأجنّة؟",
        "babies": {"one": "جنين واحد", "two": "توأمان", "more": "ثلاثة أو أكثر"},
        "bmiLine": "مؤشر كتلة الجسم قبل الحمل: {value} ({band})",
        "eyebrow": "النطاق المرجعي لإجمالي الزيادة طوال الحمل",
        "rangeKg": "من {low} إلى {high} كغ",
        "rangeLb": "من {low} إلى {high} رطل",
        "otherUnit": "أي {range}.",
        "noRangeTwinsUnderweight": "لا يحدّد معهد الطب الأمريكي نطاقًا للتوأم إذا كان مؤشر كتلة الجسم قبل الحمل أقل من 18.5. ستنصحكِ طبيبتكِ.",
        "noRangeMultiples": "لا يحدّد معهد الطب الأمريكي نطاقًا لثلاثة أجنّة أو أكثر. ستنصحكِ طبيبتكِ.",
        "note": "هذا نطاق مرجعي لفئة مؤشر كتلة جسمكِ قبل الحمل، وليس هدفًا ولا حكمًا. وقد تقترح طبيبتكِ نطاقًا مختلفًا لكِ.",
        "source": "المصدر: معهد الطب الأمريكي (2009)، «زيادة الوزن أثناء الحمل»؛ وتعتمد المراكز الأمريكية لمكافحة الأمراض (CDC) والكلية الأمريكية لأطباء النساء والتوليد (ACOG) النطاقات نفسها.",
        "outOfRange": "أدخلي وزنًا من {minW} إلى {maxW} كغ وطولًا من {minH} إلى {maxH} سم.",
        "faq": [
            {"q": "كيف يُحدَّد النطاق؟", "a": "يعتمد على مؤشر كتلة جسمكِ قبل الحمل، حسب النطاقات التي نشرها معهد الطب الأمريكي عام 2009. وتعتمد CDC وACOG النطاقات نفسها."},
            {"q": "ماذا لو كنتُ حاملًا بتوأم؟", "a": "يحدّد معهد الطب نطاقات مؤقتة للتوأم إذا كان مؤشر كتلة الجسم قبل الحمل 18.5 أو أكثر. أما إذا كان أقل، أو كان الحمل بثلاثة أجنّة أو أكثر، فلا يحدّد نطاقًا، وستنصحكِ طبيبتكِ."},
            {"q": "هل يمكن أن تقترح طبيبتي نطاقًا مختلفًا؟", "a": "نعم. هذه نطاقات مرجعية لمجموعات من النساء. طبيبتكِ تعرف صحتكِ وقد تقترح لكِ نطاقًا مختلفًا."},
        ],
    },
    "fr": {
        "title": "Calculateur de prise de poids pendant la grossesse",
        "intro": "Saisissez votre poids avant la grossesse et votre taille pour voir la fourchette de référence de prise de poids totale pendant la grossesse, selon l'Institute of Medicine (2009). Rien n'est enregistré.",
        "metaTitle": "Prise de poids pendant la grossesse : la fourchette de l'IOM selon l'IMC",
        "weightMetric": "Poids avant la grossesse (kg)",
        "weightImperial": "Poids avant la grossesse (lb)",
        "babiesLabel": "Combien de bébés ?",
        "babies": {"one": "Un", "two": "Des jumeaux", "more": "Trois ou plus"},
        "bmiLine": "IMC avant la grossesse : {value} ({band})",
        "eyebrow": "Fourchette de référence pour la prise totale sur toute la grossesse",
        "rangeKg": "De {low} à {high} kg",
        "rangeLb": "De {low} à {high} lb",
        "otherUnit": "Soit {range}.",
        "noRangeTwinsUnderweight": "L'Institute of Medicine ne donne pas de fourchette pour des jumeaux quand l'IMC avant la grossesse est inférieur à 18,5. Votre soignant vous conseillera.",
        "noRangeMultiples": "L'Institute of Medicine ne donne pas de fourchette pour trois bébés ou plus. Votre soignant vous conseillera.",
        "note": "C'est une fourchette de référence pour votre catégorie d'IMC avant la grossesse, pas un objectif ni un jugement. Votre soignant peut vous proposer une autre fourchette.",
        "source": "Source : Institute of Medicine (2009), « Weight Gain During Pregnancy » ; les CDC et l'ACOG utilisent les mêmes fourchettes.",
        "outOfRange": "Saisissez un poids de {minW} à {maxW} kg et une taille de {minH} à {maxH} cm.",
        "faq": [
            {"q": "Comment la fourchette est-elle choisie ?", "a": "Elle dépend de votre IMC avant la grossesse, selon les fourchettes publiées en 2009 par l'Institute of Medicine américain. Les CDC et l'ACOG utilisent les mêmes."},
            {"q": "Et si j'attends des jumeaux ?", "a": "L'Institute of Medicine donne des fourchettes provisoires pour des jumeaux quand l'IMC avant la grossesse était d'au moins 18,5. En dessous, ou pour trois bébés ou plus, il n'en donne pas, et votre soignant vous conseillera."},
            {"q": "Mon soignant peut-il proposer une autre fourchette ?", "a": "Oui. Ce sont des fourchettes de référence pour des groupes de femmes. Votre soignant connaît votre santé et peut vous proposer une autre fourchette."},
        ],
    },
    "es": {
        "title": "Calculadora de aumento de peso en el embarazo",
        "intro": "Introduce tu peso antes del embarazo y tu estatura para ver el rango de referencia del aumento de peso total durante el embarazo, según el Institute of Medicine (2009). No se guarda nada.",
        "metaTitle": "Aumento de peso en el embarazo: el rango del IOM según el IMC",
        "weightMetric": "Peso antes del embarazo (kg)",
        "weightImperial": "Peso antes del embarazo (lb)",
        "babiesLabel": "¿Cuántos bebés?",
        "babies": {"one": "Uno", "two": "Gemelos", "more": "Tres o más"},
        "bmiLine": "IMC antes del embarazo: {value} ({band})",
        "eyebrow": "Rango de referencia del aumento total durante todo el embarazo",
        "rangeKg": "De {low} a {high} kg",
        "rangeLb": "De {low} a {high} lb",
        "otherUnit": "Es decir, {range}.",
        "noRangeTwinsUnderweight": "El Institute of Medicine no da un rango para gemelos cuando el IMC antes del embarazo es inferior a 18,5. Tu profesional sanitario te orientará.",
        "noRangeMultiples": "El Institute of Medicine no da un rango para tres o más bebés. Tu profesional sanitario te orientará.",
        "note": "Es un rango de referencia para tu categoría de IMC antes del embarazo, no un objetivo ni un juicio. Tu profesional sanitario puede proponerte un rango distinto.",
        "source": "Fuente: Institute of Medicine (2009), «Weight Gain During Pregnancy»; los CDC y el ACOG usan los mismos rangos.",
        "outOfRange": "Introduce un peso de {minW} a {maxW} kg y una estatura de {minH} a {maxH} cm.",
        "faq": [
            {"q": "¿Cómo se elige el rango?", "a": "Depende de tu IMC antes del embarazo, según los rangos que publicó en 2009 el Institute of Medicine de EE. UU. Los CDC y el ACOG usan los mismos."},
            {"q": "¿Y si espero gemelos?", "a": "El Institute of Medicine da rangos provisionales para gemelos cuando el IMC antes del embarazo era de 18,5 o más. Si era menor, o para tres o más bebés, no da ninguno, y tu profesional sanitario te orientará."},
            {"q": "¿Puede mi profesional sanitario proponer otro rango?", "a": "Sí. Son rangos de referencia para grupos de mujeres. Tu profesional conoce tu salud y puede proponerte un rango distinto."},
        ],
    },
}

# ---------------------------------------------------------------------------------
# Contraction timer on the website (R13.4, MR-31); the reviewed timer strings live in
# the `contractions` namespace already and are reused.
# ---------------------------------------------------------------------------------
CT = {
    "en": {
        "title": "Contraction timer",
        "intro": "Press start when a contraction begins and stop when it eases. You get each one's length and the time between them, ready to read out when you call.",
        "metaTitle": "Contraction Timer: Time Contractions Free, No Sign-up",
        "sessionNote": "Nothing is saved: closing or refreshing this page clears the times.",
        "clear": "Clear these times",
        "listHeading": "Your times",
        "length": "Length",
        "apart": "Apart",
        "startedAt": "Started {time}",
        "faq": [
            {"q": "What does the timer measure?", "a": "How long each contraction lasts, and the time from the start of one to the start of the next, with averages over your last five."},
            {"q": "Does it tell me when to go to hospital?", "a": "No. It shows your times so you can read them to your maternity unit, who will tell you what to do. Call whenever you are worried; you do not need to reach a certain number first."},
            {"q": "Are my times saved?", "a": "No. They stay on this page only while it is open. The femio app keeps them on your phone."},
        ],
    },
    "ar": {
        "title": "مؤقّت الانقباضات",
        "intro": "اضغطي «ابدئي» عندما تبدأ الانقباضة و«خفّت» عندما تهدأ. تحصلين على مدة كل انقباضة والوقت بينها، جاهزة لتقرئيها عند الاتصال.",
        "metaTitle": "مؤقّت الانقباضات: سجّلي الانقباضات مجانًا ودون تسجيل",
        "sessionNote": "لا يُحفظ شيء: إغلاق هذه الصفحة أو تحديثها يمسح الأوقات.",
        "clear": "امسحي هذه الأوقات",
        "listHeading": "أوقاتكِ",
        "length": "المدة",
        "apart": "الفاصل",
        "startedAt": "بدأت {time}",
        "faq": [
            {"q": "ماذا يقيس المؤقّت؟", "a": "مدة كل انقباضة، والوقت من بداية انقباضة إلى بداية التي تليها، مع المتوسط لآخر خمس انقباضات."},
            {"q": "هل يخبرني متى أذهب إلى المستشفى؟", "a": "لا. يعرض أوقاتكِ لتقرئيها على وحدة الولادة، وهم من يخبرونكِ بما تفعلين. اتصلي متى شعرتِ بالقلق؛ لستِ مضطرة لبلوغ رقم معيّن أولًا."},
            {"q": "هل تُحفظ أوقاتي؟", "a": "لا. تبقى في هذه الصفحة فقط ما دامت مفتوحة. أما تطبيق femio فيحفظها على هاتفكِ."},
        ],
    },
    "fr": {
        "title": "Minuteur de contractions",
        "intro": "Appuyez sur démarrer quand une contraction commence et sur arrêter quand elle s'apaise. Vous obtenez la durée de chacune et le temps qui les sépare, prêts à lire quand vous appelez.",
        "metaTitle": "Minuteur de contractions : chronométrez gratuitement, sans inscription",
        "sessionNote": "Rien n'est enregistré : fermer ou actualiser cette page efface les temps.",
        "clear": "Effacer ces temps",
        "listHeading": "Vos temps",
        "length": "Durée",
        "apart": "Écart",
        "startedAt": "Début {time}",
        "faq": [
            {"q": "Que mesure le minuteur ?", "a": "La durée de chaque contraction et le temps entre le début de l'une et le début de la suivante, avec la moyenne de vos cinq dernières."},
            {"q": "Me dit-il quand partir à la maternité ?", "a": "Non. Il affiche vos temps pour que vous les lisiez à la maternité, qui vous dira quoi faire. Appelez dès que vous êtes inquiète ; vous n'avez pas à atteindre un chiffre d'abord."},
            {"q": "Mes temps sont-ils enregistrés ?", "a": "Non. Ils restent sur cette page tant qu'elle est ouverte. L'application femio les garde sur votre téléphone."},
        ],
    },
    "es": {
        "title": "Temporizador de contracciones",
        "intro": "Pulsa empezar cuando empiece una contracción y parar cuando ceda. Obtienes la duración de cada una y el tiempo entre ellas, listos para leer cuando llames.",
        "metaTitle": "Temporizador de contracciones: cronométralas gratis, sin registro",
        "sessionNote": "No se guarda nada: cerrar o recargar esta página borra los tiempos.",
        "clear": "Borrar estos tiempos",
        "listHeading": "Tus tiempos",
        "length": "Duración",
        "apart": "Intervalo",
        "startedAt": "Empezó {time}",
        "faq": [
            {"q": "¿Qué mide el temporizador?", "a": "Cuánto dura cada contracción y el tiempo desde el inicio de una hasta el inicio de la siguiente, con la media de las últimas cinco."},
            {"q": "¿Me dice cuándo ir al hospital?", "a": "No. Muestra tus tiempos para que se los leas a tu maternidad, que te dirá qué hacer. Llama siempre que estés preocupada; no hace falta llegar a ninguna cifra antes."},
            {"q": "¿Se guardan mis tiempos?", "a": "No. Se quedan en esta página solo mientras está abierta. La app femio los guarda en tu teléfono."},
        ],
    },
}


def main() -> None:
    for lang in ("en", "ar", "fr", "es"):
        path = MESSAGES / f"{lang}.json"
        catalog = json.loads(path.read_text(encoding="utf-8"))
        calc = catalog["calculators"]
        due = dict(DUE[lang])
        faq2 = due.pop("faq2")
        calc["dueDate"].update(due)
        calc["dueDate"]["faq"][2] = faq2
        calc["legend"].update(LEGEND[lang])
        for key, value in LIST[lang].items():
            calc["list"].setdefault(key, {}).update(value)
        calc["pregnancyCalendar"] = CAL[lang]
        calc["weightGain"] = WG[lang]
        calc["contractionTimer"] = CT[lang]
        path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
        print("updated", path.name)


if __name__ == "__main__":
    main()
