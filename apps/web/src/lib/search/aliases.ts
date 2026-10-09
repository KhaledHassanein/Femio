/**
 * What women type, mapped to the guides that answer it, in all four languages.
 *
 * The index holds titles, summaries and headings, which are written in clinical
 * register; the public audit (2026-10-09) searched "hot flashes", "no period",
 * "miscarriage" and «تأخر الدورة» and got nothing, though each has a guide. Only
 * slugs whose content genuinely answers the phrase belong here: a synonym gap is
 * fixed here, a content gap is not (`library.test.ts` checks every slug exists).
 */
export const SEARCH_ALIASES: Readonly<Record<string, readonly string[]>> = {
  "perimenopause-explained": ["hot flashes", "hot flushes", "night sweats", "الهبات الساخنة", "التعرق الليلي", "bouffées de chaleur", "sofocos"],
  "menopause-explained": ["hot flashes", "hot flushes", "سن اليأس", "انقطاع الطمث", "ménopause", "menopausia"],
  "track-perimenopause-symptoms": ["hot flashes", "night sweats", "الهبات الساخنة"],
  "menopause-care-options": ["HRT", "hormone therapy", "العلاج الهرموني", "THS", "terapia hormonal"],
  "is-my-period-normal": ["no period", "missed period", "late period", "period late", "تأخر الدورة", "تأخر الحيض", "انقطاع الدورة", "retard de règles", "retraso de la regla"],
  "irregular-cycles-and-timing": ["no period", "irregular periods", "late period", "الدورة غير المنتظمة", "تأخر الدورة", "cycles irréguliers", "regla irregular"],
  "when-to-take-pregnancy-test": ["late period", "missed period", "am I pregnant", "تأخر الدورة", "اختبار الحمل", "test de grossesse", "prueba de embarazo"],
  "pregnancy-warning-signs": ["miscarriage", "bleeding in pregnancy", "spotting", "ectopic", "إجهاض", "نزيف الحمل", "حمل خارج الرحم", "fausse couche", "aborto espontáneo"],
  "early-pregnancy-changes": ["spotting", "early pregnancy symptoms", "أعراض الحمل المبكرة", "تبقيع", "symptômes de grossesse", "síntomas de embarazo"],
  "fertile-window-explained": ["ovulation", "when do I ovulate", "التبويض", "الإباضة", "أيام الخصوبة", "ovulación"],
  "trying-to-conceive-guide": ["getting pregnant", "how to get pregnant", "محاولة الحمل", "تأخر الحمل", "tomber enceinte", "quedar embarazada"],
  "when-to-seek-fertility-help": ["IVF", "infertility", "أطفال الأنابيب", "العقم", "تأخر الإنجاب", "FIV", "infertilité", "infertilidad"],
  "pcos-signs": ["polycystic ovaries", "تكيس المبايض", "SOPK", "SOP", "síndrome de ovario poliquístico"],
  "pcos-and-fertility": ["PCOS pregnancy", "تكيس المبايض والحمل"],
  "endometriosis-signs": ["بطانة الرحم المهاجرة", "endométriose", "endometriosis"],
  "period-pain-care-options": ["cramps", "period cramps", "dysmenorrhea", "آلام الدورة", "مغص الدورة", "règles douloureuses", "dolor menstrual"],
  "heavy-periods-iron-deficiency-anaemia": ["heavy bleeding", "anemia", "نزيف الدورة", "فقر الدم", "anémie", "anemia"],
  "postpartum-warning-signs": ["after birth bleeding", "نزيف بعد الولادة", "النفاس"],
  "mood-after-birth": ["postpartum depression", "baby blues", "اكتئاب ما بعد الولادة", "dépression post-partum", "depresión posparto"],
  "pregnancy-basics": ["due date", "موعد الولادة", "date d'accouchement", "fecha de parto"],
};
