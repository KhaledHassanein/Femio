// Health topics in four languages, so a question in any of them finds English source passages
// (ADR-078 §3, trusted-source registry).
//
// Why it exists: the registry's passages are verbatim English text from US public-domain
// health pages, but she asks in English, Arabic (Egyptian, Gulf or standard), French or
// Spanish. Translating the question would need a model; this table does not. Both the
// question and each passage are reduced to topic ids, and retrieval compares ids. Phrases are
// matched after `normalise`, so spelling variants and Arabic prefixes need no extra entries.

import 'text_normal.dart';

/// A topic and how much a match on it counts. Broad topics ("doctor", "how long") help rank
/// but can never make a passage relevant on their own.
class Topic {
  const Topic(this.id, this.phrases, {this.broad = false});
  final String id;
  final List<String> phrases;
  final bool broad;
}

/// Every topic the registry knows. Add a phrase here when a real question misses its passage.
const topics = <Topic>[
  Topic('period', [
    'period', 'menstruation', 'menstrual', 'menses', 'menstrual cycle',
    'الدوره', 'الدوره الشهريه', 'حيض', 'العاده الشهريه', 'البريود', 'الطمث',
    'regles', 'menstruation', 'cycle menstruel', 'regla', 'menstruacion', 'periodo', 'ciclo menstrual',
  ]),
  Topic('heavyBleeding', [
    'heavy bleeding', 'heavy period', 'heavy menstrual bleeding', 'heavy flow', 'menorrhagia', 'soaking', 'clots',
    'نزيف', 'دوره غزيره', 'دم كتير', 'نزيف شديد', 'جلطات', 'نزيف حاد',
    'regles abondantes', 'saignement abondant', 'saignements abondants', 'caillots', 'hemorragie',
    'sangrado abundante', 'regla abundante', 'coagulos', 'hemorragia',
  ]),
  Topic('periodPain', [
    'cramps', 'period pain', 'painful periods', 'dysmenorrhea', 'pelvic pain', 'menstrual pain',
    'مغص', 'الم الدوره', 'وجع الدوره', 'تقلصات', 'الم الحوض', 'مغص الدوره',
    'douleurs de regles', 'crampes', 'dysmenorrhee', 'douleur pelvienne',
    'colicos', 'dolor menstrual', 'dolor de regla', 'calambres', 'dolor pelvico',
  ]),
  Topic('irregular', [
    'irregular', 'missed period', 'late period', 'no period', 'absent periods', 'amenorrhea',
    'غير منتظمه', 'متاخره', 'اتاخرت', 'انقطاع الدوره', 'مش منتظمه', 'ما جت', 'مجتش',
    'regles irregulieres', 'retard de regles', 'absence de regles', 'amenorrhee',
    'regla irregular', 'retraso', 'falta de regla', 'amenorrea',
  ]),
  Topic('pms', [
    'pms', 'pmdd', 'premenstrual', 'before my period',
    'متلازمه ما قبل الدوره', 'قبل الدوره', 'syndrome premenstruel', 'spm', 'sindrome premenstrual',
  ]),
  Topic('pcos', [
    'pcos', 'polycystic', 'polycystic ovary syndrome',
    'تكيس', 'تكيس المبايض', 'التكيس', 'متعدد الكيسات',
    'sopk', 'ovaires polykystiques', 'sop', 'ovario poliquistico', 'ovarios poliquisticos',
  ]),
  Topic('endometriosis', [
    'endometriosis', 'endometrioma', 'بطانه الرحم المهاجره', 'الانتباذ البطاني', 'اندومتريوزس',
    'endometriose', 'endometriosis',
  ]),
  Topic('fibroids', [
    'fibroid', 'fibroids', 'uterine fibroids', 'ليفي', 'ورم ليفي', 'الياف الرحم', 'لحميه',
    'fibrome', 'fibromes', 'mioma', 'miomas',
  ]),
  Topic('thyroid', ['thyroid', 'hypothyroidism', 'hyperthyroidism', 'الغده الدرقيه', 'الدرقيه', 'thyroide', 'tiroides']),
  Topic('fertility', [
    'fertility', 'conceive', 'conceiving', 'trying to conceive', 'ttc', 'get pregnant', 'getting pregnant',
    'infertility', 'infertile', 'trying for a baby',
    'خصوبه', 'احمل', 'تاخر الحمل', 'عقم', 'تاخر الانجاب', 'الانجاب', 'نحاول نحمل', 'ابغى احمل', 'عايزه احمل',
    'fertilite', 'concevoir', 'tomber enceinte', 'infertilite',
    'fertilidad', 'concebir', 'quedar embarazada', 'infertilidad', 'embarazarme',
  ]),
  Topic('ovulation', [
    'ovulation', 'ovulate', 'fertile window', 'fertile days', 'تبويض', 'التبويض', 'ايام التبويض',
    'periode fertile', 'ovulacion', 'dias fertiles',
  ]),
  Topic('ivf', [
    'ivf', 'in vitro', 'assisted reproduction', 'iui', 'fertility treatment',
    'اطفال انابيب', 'حقن مجهري', 'الحقن المجهري', 'تلقيح صناعي',
    'fiv', 'fecondation in vitro', 'fecundacion in vitro', 'reproduccion asistida',
  ]),
  Topic('maleFactor', [
    'sperm', 'semen', 'male infertility', 'الحيوانات المنويه', 'السائل المنوي', 'عقم الرجال',
    'sperme', 'infertilite masculine', 'esperma', 'infertilidad masculina',
  ]),
  Topic('pregnancy', [
    'pregnant', 'pregnancy', 'prenatal', 'antenatal', 'expecting',
    'حامل', 'حمل', 'الحوامل', 'enceinte', 'grossesse', 'embarazada', 'embarazo',
  ]),
  Topic('preconception', [
    'preconception', 'before pregnancy', 'folic acid', 'folate', 'prenatal vitamin',
    'قبل الحمل', 'حمض الفوليك', 'فوليك', 'acide folique', 'avant la grossesse', 'acido folico', 'antes del embarazo',
  ]),
  Topic('nutrition', [
    'diet', 'food', 'eat', 'eating', 'nutrition', 'caffeine', 'coffee',
    'اكل', 'غذاء', 'تغذيه', 'قهوه', 'كافيين', 'alimentation', 'manger', 'cafeine',
    'alimentacion', 'comer', 'cafeina', 'dieta',
  ]),
  Topic('exercise', [
    'exercise', 'physical activity', 'workout', 'رياضه', 'تمارين', 'نشاط بدني',
    'exercice', 'activite physique', 'ejercicio', 'actividad fisica',
  ]),
  Topic('weight', ['weight', 'weight gain', 'bmi', 'وزن', 'زياده الوزن', 'سمنه', 'poids', 'prise de poids', 'peso']),
  Topic('diabetes', [
    'gestational diabetes', 'diabetes', 'blood sugar', 'glucose', 'سكر الحمل', 'السكر', 'سكري',
    'diabete', 'diabete gestationnel', 'glycemie', 'diabetes gestacional', 'azucar en la sangre',
  ]),
  Topic('bloodPressure', [
    'blood pressure', 'hypertension', 'preeclampsia', 'pre eclampsia', 'ضغط الدم', 'الضغط', 'تسمم الحمل',
    'tension arterielle', 'hypertension', 'preeclampsie', 'presion arterial', 'hipertension', 'preeclampsia',
  ]),
  Topic('warningSigns', [
    'warning signs', 'danger signs', 'emergency', 'urgent', 'علامات الخطر', 'علامات خطر', 'طوارئ',
    'signes d alerte', 'urgence', 'senales de alarma', 'urgencia',
  ]),
  Topic('nausea', [
    'nausea', 'morning sickness', 'vomiting', 'hyperemesis', 'غثيان', 'ترجيع', 'قيء', 'وحم',
    'nausees', 'vomissements', 'nauseas', 'vomitos',
  ]),
  Topic('loss', [
    'miscarriage', 'pregnancy loss', 'stillbirth', 'ectopic', 'اجهاض', 'سقط', 'حمل خارج الرحم',
    'fausse couche', 'grossesse extra uterine', 'aborto espontaneo', 'perdida del embarazo', 'embarazo ectopico',
  ]),
  Topic('postpartum', [
    'postpartum', 'after birth', 'after delivery', 'after giving birth', 'post partum', 'lochia',
    'بعد الولاده', 'النفاس', 'نفاس', 'post partum', 'apres l accouchement', 'posparto', 'despues del parto',
  ]),
  Topic('breastfeeding', [
    'breastfeeding', 'breast feeding', 'nursing', 'milk supply', 'lactation', 'breast milk',
    'رضاعه', 'الرضاعه الطبيعيه', 'لبن الام', 'حليب الام', 'allaitement', 'allaiter', 'lactancia', 'amamantar',
  ]),
  Topic('mood', [
    'depression', 'anxiety', 'baby blues', 'low mood', 'mood', 'postpartum depression', 'mental health',
    'اكتئاب', 'قلق', 'مزاج', 'الصحه النفسيه', 'depression', 'anxiete', 'humeur', 'sante mentale',
    'depresion', 'ansiedad', 'animo', 'salud mental',
  ]),
  Topic('menopause', [
    'menopause', 'perimenopause', 'postmenopause', 'menopausal', 'سن الياس', 'انقطاع الطمث', 'سن انقطاع الطمث',
    'menopause', 'perimenopause', 'menopausia', 'perimenopausia',
  ]),
  Topic('hotFlashes', [
    'hot flashes', 'hot flushes', 'hot flash', 'night sweats', 'هبات ساخنه', 'الهبات', 'عرق بالليل', 'تعرق ليلي',
    'bouffees de chaleur', 'sueurs nocturnes', 'sofocos', 'sudores nocturnos',
  ]),
  Topic('vaginalHealth', [
    'vaginal', 'discharge', 'yeast infection', 'thrush', 'bacterial vaginosis', 'vaginal dryness', 'itching',
    'افرازات', 'فطريات', 'التهاب مهبلي', 'جفاف المهبل', 'حكه', 'pertes vaginales', 'mycose', 'secheresse vaginale',
    'flujo vaginal', 'hongos', 'sequedad vaginal', 'picazon',
  ]),
  Topic('screening', [
    'pap', 'pap test', 'smear', 'cervical screening', 'cervical cancer', 'hpv', 'mammogram', 'breast cancer',
    'مسحه عنق الرحم', 'سرطان عنق الرحم', 'ماموجرام', 'سرطان الثدي', 'فحص الثدي',
    'frottis', 'depistage', 'mammographie', 'cancer du sein', 'papanicolau', 'citologia', 'mamografia', 'cancer de mama',
  ]),
  Topic('anemia', [
    'anemia', 'anaemia', 'iron', 'low iron', 'انيميا', 'فقر الدم', 'حديد', 'anemie', 'fer', 'anemia', 'hierro',
  ]),
  Topic('fatigue', ['tired', 'fatigue', 'exhausted', 'تعب', 'ارهاق', 'تعبانه', 'fatigue', 'cansancio', 'agotada']),
  Topic('sleep', ['sleep', 'insomnia', 'نوم', 'ارق', 'sommeil', 'insomnie', 'sueno', 'insomnio']),
  Topic('headache', [
    'migraine', 'headache', 'صداع', 'صداع نصفي', 'شقيقه', 'migraine', 'mal de tete', 'migrana', 'dolor de cabeza',
  ]),
  Topic('puberty', [
    'puberty', 'first period', 'teen', 'adolescent', 'girls', 'بلوغ', 'اول دوره', 'البلوغ',
    'puberte', 'premieres regles', 'adolescente', 'pubertad', 'primera regla',
  ]),
  Topic('bones', [
    'osteoporosis', 'bone health', 'bones', 'calcium', 'vitamin d', 'هشاشه العظام', 'العظام', 'كالسيوم',
    'osteoporose', 'calcium', 'osteoporosis', 'huesos', 'calcio',
  ]),
  Topic('urinary', [
    'uti', 'urinary tract infection', 'bladder', 'leaking urine', 'incontinence', 'التهاب البول', 'المثانه', 'سلس البول',
    'infection urinaire', 'vessie', 'incontinence', 'infeccion urinaria', 'vejiga', 'incontinencia',
  ]),
  Topic('doctor', [
    'doctor', 'see a doctor', 'health care provider', 'healthcare provider', 'clinician', 'gp', 'specialist',
    'دكتور', 'الدكتور', 'طبيب', 'الطبيب', 'دكتوره', 'medecin', 'docteur', 'consulter', 'medico', 'doctora', 'consultar',
  ], broad: true),
  Topic('howLong', [
    'how long', 'how many months', 'months', 'one year', '12 months', '6 months', 'a year',
    'قد ايه', 'كام شهر', 'سنه', 'مده', 'شهور', 'combien de temps', 'mois', 'un an', 'cuanto tiempo', 'meses', 'un ano',
  ], broad: true),
];

final _normalisedTopics = [
  for (final t in topics) (t, [for (final p in t.phrases) words(p)]),
];

/// The topic ids found in [text] in any of the four languages. Empty for text with no topic.
Set<String> topicsOf(String text) {
  final w = words(text);
  if (w.isEmpty) return const {};
  return {
    for (final (topic, phrases) in _normalisedTopics)
      if (phrases.any((p) => findPhrase(w, p) >= 0)) topic.id,
  };
}

/// True for a topic that ranks but cannot make a passage relevant by itself.
bool isBroadTopic(String id) => topics.any((t) => t.id == id && t.broad);
