// The topic table: health topics in four languages (ADR-078 §3, ADR-079; extended by the
// registry coverage pass of 2026-11-24).
//
// Why it exists: `topic_lexicon.dart` matches her question and each registry passage against
// this table. It is data, kept apart from the matching code so the table can grow without the
// logic growing with it. Add a phrase here when a real question misses its passage; check the
// coverage test (`test/registry_coverage_test.dart`) before and after.

import 'topic_lexicon.dart' show Topic;

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
    'period late', 'period is late', 'periods late', 'period stopped', 'period stop', 'stop my period', 'periods stop', 'not had a period', 'no period yet', 'الدوره وقفت', 'توقف الدوره', 'مجتليش الدوره', 'regles en retard', 'pas encore eu mes regles', 'se me retrasa', 'se me fue la regla',
    'irregular periods', 'periods change', 'مش منتظمه', 'عدم انتظام', 'عدم انتظام الدوره', 'irregulieres',
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
  Topic('thyroid', [
    'thyroiditis', 'التهاب الغده الدرقيه', 'thyroidite', 'tiroiditis','thyroid', 'hypothyroidism', 'hyperthyroidism', 'الغده الدرقيه', 'الدرقيه', 'thyroide', 'tiroides']),
  Topic('fertility', [
    'infertile', 'fertilidad', 'tomber enceinte',
    'fertility', 'conceive', 'conceiving', 'trying to conceive', 'ttc', 'get pregnant', 'getting pregnant',
    'infertility', 'infertile', 'trying for a baby',
    'خصوبه', 'احمل', 'تاخر الحمل', 'عقم', 'تاخر الانجاب', 'الانجاب', 'نحاول نحمل', 'ابغى احمل', 'عايزه احمل',
    'fertilite', 'concevoir', 'tomber enceinte', 'infertilite',
    'fertilidad', 'concebir', 'quedar embarazada', 'infertilidad', 'embarazarme',
  ]),
  Topic('ovulation', [
    'ovulation test', 'ovulation kit', 'ovulation predictor', 'lh surge', 'signs of ovulation', 'اختبار التبويض', 'اختبارات التبويض', 'شرايط التبويض', 'test d ovulation', 'prueba de ovulacion',
    'ovulation', 'ovulate', 'fertile window', 'fertile days', 'تبويض', 'التبويض', 'ايام التبويض',
    'periode fertile', 'ovulacion', 'dias fertiles',
  ]),
  Topic('ivf', [
    'insemination', 'intrauterine insemination',
    'ivf', 'in vitro', 'assisted reproduction', 'iui', 'fertility treatment',
    'اطفال انابيب', 'حقن مجهري', 'الحقن المجهري', 'تلقيح صناعي',
    'fiv', 'fecondation in vitro', 'fecundacion in vitro', 'reproduccion asistida',
  ]),
  Topic('maleFactor', [
    'sperm health', 'sperm count', 'خصوبه الراجل', 'خصوبه الرجل', 'الحيوانات المنويه', 'calidad del esperma',
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
    'fruits and vegetables', 'vegetables', 'healthy eating',
    'healthy diet', 'الاكل الصحي', 'alimentation saine', 'alimentacion saludable',
    'diet', 'food', 'eat', 'eating', 'nutrition', 'caffeine', 'coffee',
    'اكل', 'غذاء', 'تغذيه', 'قهوه', 'كافيين', 'alimentation', 'manger', 'cafeine',
    'alimentacion', 'comer', 'cafeina', 'dieta',
  ]),
  Topic('exercise', [
    'excessive exercise', 'too much exercise', 'training hard', 'الرياضه الكتير', 'اتمرن جامد',
    'training', 'train', 'athlete', 'athletes', 'اتمرن', 'تمرين', 'entrainement', 'entrenar', 'entrenamiento',
    'exercise', 'physical activity', 'workout', 'رياضه', 'تمارين', 'نشاط بدني',
    'exercice', 'activite physique', 'ejercicio', 'actividad fisica',
  ]),
  Topic('weight', [
    'losing weight', 'lose weight', 'body mass index', 'خساره الوزن', 'مؤشر كتله الجسم', 'كيلو', 'perdre du poids', 'bajar de peso','weight', 'weight gain', 'bmi', 'وزن', 'زياده الوزن', 'سمنه', 'poids', 'prise de poids', 'peso']),
  Topic('diabetes', [
    'insulin', 'insulin resistance', 'انسولين', 'مقاومه الانسولين', 'سكر الحمل', 'تحليل السكر', 'insuline', 'insulina',
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
    'miscarriages', 'chemical pregnancy', 'recurrent miscarriage', 'حمل كيميائي', 'اجهاض متكرر', 'aborto',
    'miscarriage', 'pregnancy loss', 'stillbirth', 'ectopic', 'اجهاض', 'سقط', 'حمل خارج الرحم',
    'fausse couche', 'grossesse extra uterine', 'aborto espontaneo', 'perdida del embarazo', 'embarazo ectopico',
  ]),
  Topic('postpartum', [
    'after giving birth', 'after the birth', 'giving birth', 'بعد ما ولدت', 'apres la naissance',
    'postpartum', 'after birth', 'after delivery', 'after giving birth', 'post partum', 'lochia',
    'بعد الولاده', 'النفاس', 'نفاس', 'post partum', 'apres l accouchement', 'posparto', 'despues del parto',
  ]),
  Topic('breastfeeding', [
    'breastfeed', 'breast milk', 'برضع', 'ارضع', 'يرضع', 'الرضاعه', 'lait maternel', 'leche materna',
    'breastfeeding', 'breast feeding', 'nursing', 'milk supply', 'lactation', 'breast milk',
    'رضاعه', 'الرضاعه الطبيعيه', 'لبن الام', 'حليب الام', 'allaitement', 'allaiter', 'lactancia', 'amamantar',
  ]),
  Topic('mood', [
    'depressed', 'مزاجي', 'deprimee',
    'depression', 'anxiety', 'low mood', 'mood', 'postpartum depression', 'mental health',
    'اكتئاب', 'قلق', 'مزاج', 'الصحه النفسيه', 'depression', 'anxiete', 'humeur', 'sante mentale',
    'depresion', 'ansiedad', 'animo', 'salud mental',
  ]),
  Topic('menopause', [
    'early menopause', 'premature menopause', 'انقطاع الطمث المبكر',
    'menopause', 'perimenopause', 'postmenopause', 'menopausal', 'سن الياس', 'انقطاع الطمث', 'سن انقطاع الطمث',
    'menopause', 'perimenopause', 'menopausia', 'perimenopausia',
  ]),
  Topic('hotFlashes', [
    'hot flashes', 'hot flushes', 'hot flash', 'night sweats', 'هبات ساخنه', 'الهبات', 'عرق بالليل', 'تعرق ليلي',
    'bouffees de chaleur', 'sueurs nocturnes', 'sofocos', 'sudores nocturnos',
  ]),
  Topic('vaginalHealth', [
    'bacterial vaginosis', 'التهاب المهبل', 'المهبل', 'الافرازات المهبليه', 'pertes', 'vaginal',
    'vaginal', 'discharge', 'yeast infection', 'thrush', 'bacterial vaginosis', 'vaginal dryness', 'itching',
    'افرازات', 'فطريات', 'التهاب مهبلي', 'جفاف المهبل', 'حكه', 'pertes vaginales', 'mycose', 'secheresse vaginale',
    'flujo vaginal', 'hongos', 'sequedad vaginal', 'picazon',
  ]),
  Topic('screening', [
    'hpv', 'breast self exam', 'check my breasts', 'breast changes', 'breast lump', 'الورم الحليمي', 'فيروس الورم الحليمي', 'اكشف على صدري', 'citologia',
    'pap', 'pap test', 'smear', 'cervical screening', 'cervical cancer', 'hpv', 'mammogram', 'breast cancer',
    'مسحه عنق الرحم', 'سرطان عنق الرحم', 'ماموجرام', 'سرطان الثدي', 'فحص الثدي',
    'frottis', 'depistage', 'mammographie', 'cancer du sein', 'papanicolau', 'citologia', 'mamografia', 'cancer de mama',
  ]),
  Topic('anemia', [
    'iron deficiency', 'نقص الحديد', 'manque de fer',
    'anemia', 'anaemia', 'iron', 'low iron', 'انيميا', 'فقر الدم', 'حديد', 'anemie', 'fer', 'anemia', 'hierro',
  ]),
  Topic('fatigue', ['tired', 'fatigue', 'exhausted', 'تعب', 'ارهاق', 'تعبانه', 'fatigue', 'cansancio', 'agotada']),
  Topic('sleep', [
    'sleeping', 'انام', 'ينام', 'النوم', 'dormir', 'dormir mejor','sleep', 'insomnia', 'نوم', 'ارق', 'sommeil', 'insomnie', 'sueno', 'insomnio']),
  Topic('headache', [
    'migraine', 'headache', 'صداع', 'صداع نصفي', 'شقيقه', 'migraine', 'mal de tete', 'migrana', 'dolor de cabeza',
  ]),
  Topic('puberty', [
    'puberty', 'girls', 'teens', 'teenagers', 'teenager', 'first periods', 'مراهقه', 'المراهقات', 'سن المراهقه', 'البنات', 'ado', 'adolescentes', 'ninas', 'primera regla',
    'puberty', 'first period', 'teen', 'adolescent', 'girls', 'بلوغ', 'اول دوره', 'البلوغ',
    'puberte', 'premieres regles', 'adolescente', 'pubertad', 'primera regla',
  ]),
  Topic('bones', [
    'vitamin d', 'فيتامين د', 'هشاشه العظام', 'vitamine d', 'vitamina d',
    'osteoporosis', 'bone health', 'bones', 'calcium', 'vitamin d', 'هشاشه العظام', 'العظام', 'كالسيوم',
    'osteoporose', 'calcium', 'osteoporosis', 'huesos', 'calcio',
  ]),
  Topic('urinary', [
    'urinary tract infection', 'urinary', 'bladder leaks', 'التهاب المسالك البوليه', 'المسالك البوليه', 'سلس البول', 'infection urinaire',
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

  Topic('babyBlues', ['baby blues', 'البيبي بلوز', 'كابه ما بعد الولاده', 'baby blues', 'tristeza posparto']),
  Topic('trimester', [
    'trimester', 'first trimester', 'second trimester', 'third trimester',
    'الثلث الاول', 'الثلث التاني', 'الثلث الثاني', 'الثلث الاخير', 'الثلث الثالث',
    'premier trimestre', 'deuxieme trimestre', 'troisieme trimestre', 'trimestre',
    'primer trimestre', 'segundo trimestre', 'tercer trimestre',
  ]),
  Topic('fetalGrowth', [
    'fetal development', 'baby developing', 'baby development', 'week by week', 'fetus', 'how big is the baby',
    'نمو الجنين', 'البيبي بيكبر', 'حجم الجنين', 'حجم البيبي', 'الجنين بيكبر',
    'developpement du bebe', 'developpement foetal', 'desarrollo fetal', 'desarrollo del bebe',
  ]),
  Topic('fetalMovement', [
    'baby move', 'baby moving', 'baby moves', 'baby kicks', 'kick count', 'kick counts', 'fetal movement',
    'fetal movements', 'quickening', 'feel the baby',
    'حركه البيبي', 'حركه الجنين', 'عد الركلات', 'ركلات الجنين',
    'bebe bouger', 'mouvements du bebe', 'mouvements foetaux', 'bebe se mueve', 'movimientos del bebe', 'patadas',
  ]),
  Topic('dueDate', [
    'due date', 'estimated due date', 'delivery date',
    'ميعاد الولاده', 'موعد الولاده', 'تاريخ الولاده', 'ميعاد الولاده المتوقع',
    'date prevue d accouchement', 'date d accouchement', 'fecha probable de parto', 'fecha de parto',
  ]),
  Topic('prenatalTests', [
    'prenatal test', 'prenatal tests', 'prenatal testing', 'prenatal screening', 'tests during pregnancy',
    'tests are done during pregnancy', 'ultrasound', 'anatomy scan', 'sonogram', 'glucose test', 'glucose challenge',
    'سونار', 'السونار التفصيلي', 'موجات صوتيه', 'تحاليل الحمل', 'التحاليل اللي بتتعمل في الحمل',
    'echographie', 'examens prenatals', 'depistage prenatal', 'ecografia', 'pruebas prenatales', 'pruebas durante el embarazo',
  ]),
  Topic('labor', [
    'labor', 'labour', 'contractions', 'braxton hicks', 'signs of labor', 'childbirth', 'water breaking',
    'الطلق', 'انقباضات', 'براكستون', 'علامات الولاده', 'بدايه الولاده',
    'travail', 'contractions', 'signes du travail', 'trabajo de parto', 'contracciones', 'senales del parto',
  ]),
  Topic('preterm', [
    'preterm', 'premature birth', 'preterm labor', 'preterm birth', 'early labor',
    'ولاده مبكره', 'الولاده المبكره', 'ولاده مبتسره', 'accouchement premature', 'parto prematuro', 'prematuro',
  ]),
  Topic('cesarean', [
    'c section', 'cesarean', 'caesarean', 'cesarean section', 'vbac', 'vaginal birth after',
    'قيصريه', 'ولاده قيصريه', 'جرح القيصريه', 'cesarienne', 'cesarea',
  ]),
  Topic('vaccines', [
    'vaccine', 'vaccines', 'vaccination', 'vaccinations', 'immunization', 'flu shot', 'tdap', 'whooping cough',
    'تطعيم', 'تطعيمات', 'لقاح', 'vaccin', 'vaccins', 'vaccination', 'vacuna', 'vacunas', 'vacunacion',
  ]),
  Topic('foodSafety', [
    'foods to avoid', 'food safety', 'listeria', 'unpasteurized', 'raw fish', 'mercury', 'fish', 'seafood', 'deli meat',
    'ابعد عنه', 'سمك', 'اسماك', 'الزيبق', 'ليستيريا', 'غير مبستر',
    'aliments a eviter', 'aliments eviter', 'listeria', 'poisson', 'mercure', 'non pasteurise',
    'alimentos debo evitar', 'alimentos evitar', 'pescado', 'mercurio', 'sin pasteurizar',
  ]),
  Topic('heartburn', [
    'heartburn', 'indigestion', 'acid reflux', 'حموضه', 'حرقان', 'brulures d estomac', 'acidez', 'ardor de estomago',
  ]),
  Topic('backPain', [
    'back pain', 'backache', 'الم الضهر', 'الم الظهر', 'وجع الضهر', 'mal de dos', 'dolor de espalda',
  ]),
  Topic('rh', ['rh', 'rh negative', 'rh factor', 'rhesus', 'فصيله الدم سالب', 'عامل ريسس', 'factor rh']),
  Topic('cholestasis', [
    'cholestasis', 'itching in pregnancy', 'الركود الصفراوي', 'ركود صفراوي', 'cholestase', 'colestasis',
  ]),
  Topic('travel', [
    'travel', 'traveling', 'flying', 'plane', 'flight', 'سفر', 'اسافر', 'طياره', 'بالطياره',
    'voyage', 'voyager', 'avion', 'viajar', 'viaje', 'avion',
  ]),
  Topic('medicines', [
    'medicine', 'medicines', 'medication', 'medications', 'ادويه', 'دواء', 'دوا',
    'medicament', 'medicaments', 'medicamento', 'medicamentos',
  ]),
  Topic('multiples', [
    'twin', 'twins', 'triplets', 'multiple pregnancy', 'multiples', 'توام', 'توايم',
    'jumeaux', 'grossesse multiple', 'gemelos', 'embarazo multiple',
  ]),
  Topic('intercourse', [
    'intercourse', 'have sex', 'sexual intercourse', 'العلاقه الزوجيه', 'الجماع', 'rapports', 'rapport sexuel',
    'relaciones sexuales',
  ]),
  Topic('cervicalMucus', [
    'cervical mucus', 'mucus', 'افرازات عنق الرحم', 'مخاط عنق الرحم', 'glaire cervicale', 'glaire', 'moco cervical',
  ]),
  Topic('bodyTemperature', [
    'basal body temperature', 'body temperature', 'temperature', 'درجه الحراره', 'حراره الجسم', 'درجه حراره الجسم',
    'temperature basale', 'temperatura basal',
  ]),
  Topic('pregnancyTest', [
    'pregnancy test', 'home pregnancy test', 'hcg', 'اختبار حمل', 'اختبار الحمل', 'تحليل حمل', 'تحليل الحمل',
    'test de grossesse', 'prueba de embarazo',
  ]),
  Topic('stress', ['stress', 'stressed', 'stressful', 'توتر', 'التوتر', 'ضغط نفسي', 'stress', 'estres']),
  Topic('poi', [
    'primary ovarian insufficiency', 'ovarian insufficiency', 'premature ovarian failure', 'poi',
    'قصور المبيض', 'قصور المبايض', 'فشل المبيض المبكر', 'insuffisance ovarienne', 'insuficiencia ovarica',
  ]),
  Topic('breastIssues', [
    'nipple', 'nipples', 'sore nipples', 'cracked nipples', 'mastitis', 'engorgement', 'engorged', 'clogged duct',
    'blocked duct', 'الحلمات', 'حلمه', 'تشقق الحلمات', 'التهاب الثدي', 'احتقان الثدي',
    'mamelon', 'mamelons', 'mastite', 'engorgement', 'pezon', 'pezones', 'mastitis', 'congestion mamaria',
  ]),
  Topic('milkSupply', [
    'milk supply', 'more milk', 'enough milk', 'enough breast milk', 'getting enough', 'pump', 'pumped', 'pumping',
    'breast pump', 'store breast milk', 'storing breast milk',
    'ازود اللبن', 'ازود لبن', 'كفايته من اللبن', 'كفايته من لبن', 'شفط', 'احفظ لبن',
    'tire lait', 'lait tire', 'conserver le lait', 'leche extraida', 'guardo la leche', 'suficiente leche',
  ]),
  Topic('infantSleep', [
    'safe sleep', 'sids', 'sudden infant death', 'newborn sleep', 'baby sleep', 'sleep safely', 'on their back',
    'نوم المولود', 'نوم الرضيع', 'ينام بامان', 'coucher mon nouveau ne', 'mort subite du nourrisson', 'muerte subita',
    'dormir seguro',
  ]),
  Topic('jaundice', ['jaundice', 'yellow skin', 'الصفرا', 'صفرا', 'اليرقان', 'jaunisse', 'ictere', 'ictericia']),
  Topic('hairLoss', [
    'hair loss', 'losing hair', 'hair falling out', 'تساقط الشعر', 'chute de cheveux', 'caida del cabello',
  ]),
  Topic('pelvicFloor', [
    'pelvic floor', 'kegel', 'kegels', 'kegel exercises', 'قاع الحوض', 'عضلات الحوض', 'تمارين كيجل',
    'plancher pelvien', 'perinee', 'suelo pelvico',
  ]),
  Topic('grief', [
    'grief', 'grieve', 'grieving', 'cope', 'coping', 'الحزن', 'حزن', 'اتعامل مع الحزن',
    'deuil', 'chagrin', 'duelo', 'afrontar',
  ]),
  Topic('cycleLength', [
    'menstruation time', 'bleeding lasts', 'period lasts',
    'cycle length', 'length of the cycle', 'cycle lasts', 'menstrual cycle length', 'normal cycle',
    'how many days', 'period last', 'periods last',
    'طول الدوره', 'مده الدوره', 'كام يوم', 'بتقعد كام يوم',
    'duree du cycle', 'duree normale', 'duracion del ciclo', 'cuanto dura',
  ]),
  Topic('bleeding', [
    'bleeding', 'spotting', 'bleed', 'between periods', 'نزيف', 'تنقيط', 'نزول دم', 'بين الدورتين',
    'saignement', 'saignements', 'saigner', 'spotting', 'sangrado', 'manchado', 'sangrar',
  ]),
  Topic('adenomyosis', ['adenomyosis', 'العضال الغدي', 'adenomyose', 'adenomiosis']),
  Topic('toxicShock', ['toxic shock', 'toxic shock syndrome', 'tss', 'الصدمه التسمميه', 'choc toxique', 'shock toxico']),
  Topic('menstrualProducts', [
    'pad', 'pads', 'tampon', 'tampons', 'menstrual cup', 'sanitary pad',
    'الفوطه', 'فوطه', 'الفوط', 'الفوطه الصحيه', 'التامبون', 'تامبون',
    'serviette hygienique', 'serviettes hygieniques', 'coupe menstruelle', 'toalla sanitaria', 'tampones', 'copa menstrual',
  ]),
  Topic('acne', ['acne', 'pimples', 'حب الشباب', 'حبوب', 'بثور', 'boutons', 'granos']),
  Topic('breast', [
    'breast', 'breasts', 'breast development', 'breasts start', 'الصدر', 'الثدي', 'صدري', 'seins', 'poitrine', 'senos', 'pechos',
  ]),
  Topic('hormoneTherapy', [
    'hormone therapy', 'hormone replacement', 'hrt', 'menopausal hormone therapy', 'estrogen therapy',
    'العلاج الهرموني', 'علاج هرموني', 'الهرمونات التعويضيه',
    'traitement hormonal', 'hormonotherapie', 'terapia hormonal', 'terapia de reemplazo hormonal',
  ]),
  Topic('heart', [
    'heart', 'heart disease', 'heart attack', 'heart health', 'cardiovascular',
    'القلب', 'الازمه القلبيه', 'ازمه قلبيه', 'امراض القلب', 'coeur', 'crise cardiaque', 'corazon', 'ataque cardiaco', 'infarto',
  ]),
  Topic('surgery', [
    'surgery', 'surgical', 'hysterectomy', 'oophorectomy', 'ovaries removed', 'remove the ovaries',
    'استيصال', 'استيصال المبايض', 'استيصال الرحم', 'chirurgie', 'hysterectomie', 'cirugia', 'histerectomia',
  ]),
  Topic('water', [
    'drink water', 'water', 'fluids', 'hydration', 'مياه', 'ميه', 'مية', 'اشرب', 'سوايل', 'eau', 'boire', 'agua', 'beber',
  ]),
  Topic('smoking', [
    'smoking', 'smoke', 'tobacco', 'cigarettes', 'vaping', 'التدخين', 'تدخين', 'سجاير', 'شيشه',
    'tabac', 'fumer', 'tabagisme', 'fumar', 'tabaco',
  ]),
  Topic('age', [
    'age', 'ages', 'older', 'over 35', 'after 35', 'age 35', 'advanced maternal age',
    'سن', 'السن', 'العمر', 'age', 'edad', 'mayor',
  ], broad: true),
  Topic('testing', ['test', 'tests', 'testing', 'تحليل', 'تحاليل', 'فحص', 'examen', 'analyse', 'prueba', 'analisis'], broad: true),
  Topic('parenting', [
    'my daughter', 'daughter', 'parent', 'parents', 'talk to', 'بنتي', 'اكلم', 'ma fille', 'parler', 'mi hija', 'hablar',
  ], broad: true),
];
