// "Say it in your words": everyday phrases → the shared log vocabulary (ADR-078, R7.1).
//
// Why it exists: she should be able to write "مغص من الصبح وتعبانة" or "cramps since this
// morning, so tired" and get the same chips she would have tapped. This file is the rule
// floor that works on every phone and in all four languages; on a phone with Gemini Nano the
// model's suggestions are merged on top (`mergeDrafts`), but only keys this vocabulary knows
// can ever reach her log. Nothing here decides anything medical: it maps words to the
// existing chips, and she confirms every one before it is saved.
//
// Intercourse is deliberately absent (OD-5, conservative register): it is only ever tapped.

import '../log_vocabulary.g.dart';
import 'text_normal.dart';

/// Ovulation-test results a phrase can set (a subset of the generated `opkResults`).
const phraseOpkResults = ['negative', 'positive'];

/// Words that turn the next few words into a denial ("no cramps", "مفيش مغص").
const _negations = [
  'no',
  'not',
  'without',
  'never',
  'didnt',
  'dont',
  'isnt',
  'havent',
  'none',
  'مفيش',
  'مافيش',
  'مش',
  'ما',
  'مو',
  'بدون',
  'ولا',
  'مافي',
  'ماكانش',
  'لا',
  'pas',
  'sans',
  'aucun',
  'aucune',
  'jamais',
  'sin',
  'ni',
  'nunca',
];

/// How many words before a phrase a negation still applies to.
const _negationReach = 3;

/// Phrases per vocabulary key. Each entry is matched as whole words after [normalise], so
/// spelling variants of one word need listing only when the letters differ after folding.
const Map<String, List<String>> termPhrases = {
  // Mood
  'happy': [
    'happy',
    'good mood',
    'mabsoota',
    'مبسوطه',
    'فرحانه',
    'سعيده',
    'مستانسه',
    'heureuse',
    'contente',
    'feliz',
    'contenta',
  ],
  'calm': ['calm', 'relaxed', 'هاديه', 'مرتاحه', 'رايقه', 'calme', 'detendue', 'tranquila', 'relajada'],
  'anxious': [
    'anxious',
    'worried',
    'stressed',
    'nervous',
    'قلقانه',
    'قلق',
    'متوتره',
    'توتر',
    'خايفه',
    'anxieuse',
    'stressee',
    'inquiete',
    'ansiosa',
    'estresada',
    'preocupada',
    'nerviosa',
  ],
  'irritable': [
    'irritable',
    'grumpy',
    'cranky',
    'short tempered',
    'متعصبه',
    'عصبيه',
    'نرفزه',
    'متنرفزه',
    'معصبه',
    'irritee',
    'enervee',
    'irritable',
  ],
  'sad': ['sad', 'feeling down', 'low mood', 'حزينه', 'زعلانه', 'مخنوقه', 'متضايقه', 'triste', 'deprimee', 'decaida'],
  'moodSwings': [
    'mood swings',
    'moody',
    'تقلبات مزاج',
    'مزاجي متقلب',
    'مزاجي متغير',
    'sautes d humeur',
    'cambios de humor',
  ],
  'lowMotivation': [
    'no motivation',
    'unmotivated',
    'no energy to do anything',
    'مليش نفس',
    'ماليش نفس',
    'ماليش مزاج',
    'مالي خلق',
    'pas motivee',
    'aucune motivation',
    'sin ganas',
    'desmotivada',
  ],
  'tearfulness': [
    'crying',
    'cried',
    'tearful',
    'teary',
    'بعيط',
    'عيطت',
    'بكيت',
    'ببكي',
    'اعيط',
    'je pleure',
    'pleure',
    'llorando',
    'llore',
    'lloro',
  ],
  'panicFeelings': [
    'panic',
    'panic attack',
    'هلع',
    'نوبه هلع',
    'panique',
    'crise de panique',
    'panico',
    'ataque de panico',
  ],
  // Symptoms
  'cramps': [
    'cramps',
    'cramp',
    'cramping',
    'period pain',
    'مغص',
    'تقلصات',
    'وجع بطن',
    'وجع في بطني',
    'الم الدوره',
    'crampes',
    'douleurs de regles',
    'colicos',
    'colico',
    'dolor menstrual',
    'calambres',
  ],
  'headache': [
    'headache',
    'migraine',
    'head hurts',
    'صداع',
    'وجع راس',
    'راسي بيوجعني',
    'راسي يعورني',
    'شقيقه',
    'mal de tete',
    'maux de tete',
    'migraine',
    'dolor de cabeza',
    'jaqueca',
    'migrana',
  ],
  'bloating': [
    'bloated',
    'bloating',
    'انتفاخ',
    'نفخه',
    'منفوخه',
    'ballonnements',
    'ballonnee',
    'gonflee',
    'hinchazon',
    'hinchada',
  ],
  'breastTenderness': [
    'sore breasts',
    'breast pain',
    'tender breasts',
    'breast tenderness',
    'الم الثدي',
    'الم في الثدي',
    'وجع الثدي',
    'حساسيه الثدي',
    'seins douloureux',
    'douleur aux seins',
    'pechos sensibles',
    'dolor de pechos',
    'senos sensibles',
  ],
  'backache': [
    'back pain',
    'backache',
    'lower back',
    'الم الظهر',
    'وجع ظهر',
    'ضهري بيوجعني',
    'ظهري يعورني',
    'mal de dos',
    'dolor de espalda',
  ],
  'jointPain': [
    'joint pain',
    'joints hurt',
    'الم المفاصل',
    'وجع مفاصل',
    'douleurs articulaires',
    'dolor articular',
    'dolor de articulaciones',
  ],
  'musclePain': [
    'muscle pain',
    'muscle aches',
    'sore muscles',
    'الم العضلات',
    'وجع عضلات',
    'douleurs musculaires',
    'dolor muscular',
  ],
  'nausea': [
    'nausea',
    'nauseous',
    'queasy',
    'feel sick',
    'غثيان',
    'لوعه',
    'عايزه ارجع',
    'نفسي غامه',
    'nausee',
    'nausees',
    'envie de vomir',
    'nauseas',
    'mareada del estomago',
  ],
  'constipation': ['constipated', 'constipation', 'امساك', 'constipee', 'constipation', 'estrenimiento', 'estrenida'],
  'diarrhea': ['diarrhea', 'diarrhoea', 'loose stools', 'اسهال', 'diarrhee', 'diarrea'],
  'fatigue': [
    'tired',
    'exhausted',
    'fatigue',
    'fatigued',
    'no energy',
    'drained',
    'تعبانه',
    'تعب',
    'ارهاق',
    'مرهقه',
    'مهدوده',
    'خلصانه',
    'fatiguee',
    'epuisee',
    'fatigue',
    'cansada',
    'cansancio',
    'agotada',
  ],
  'acne': [
    'acne',
    'pimples',
    'breakout',
    'breakouts',
    'حبوب',
    'حب الشباب',
    'بثور',
    'boutons',
    'acne',
    'granos',
    'espinillas',
  ],
  'hotFlashes': [
    'hot flash',
    'hot flashes',
    'hot flush',
    'hot flushes',
    'هبات ساخنه',
    'هبات حراره',
    'بوفان',
    'bouffees de chaleur',
    'bouffee de chaleur',
    'sofocos',
    'sofoco',
    'bochornos',
  ],
  'nightSweats': [
    'night sweats',
    'sweating at night',
    'تعرق ليلي',
    'عرق بالليل',
    'sueurs nocturnes',
    'sudores nocturnos',
  ],
  'spotting': [
    'spotting',
    'spotted',
    'تنقيط',
    'نقط دم',
    'نقطه دم',
    'saignements legers',
    'spotting',
    'manchado',
    'manchas de sangre',
  ],
  'heartFlutters': [
    'heart racing',
    'palpitations',
    'heart flutters',
    'خفقان',
    'قلبي بيدق بسرعه',
    'palpitations',
    'palpitaciones',
  ],
  'cravings': ['cravings', 'craving', 'اشتهاء', 'نفسي في حاجه حلوه', 'envies', 'fringales', 'antojos', 'antojo'],
  'insomnia': [
    'insomnia',
    'cant sleep',
    'couldnt sleep',
    'could not sleep',
    'poor sleep',
    'ارق',
    'مش عارفه انام',
    'ما نمت',
    'ماعرفتش انام',
    'insomnie',
    'pas dormi',
    'insomnio',
    'no pude dormir',
    'no puedo dormir',
  ],
  'dizziness': [
    'dizzy',
    'dizziness',
    'lightheaded',
    'light headed',
    'دوخه',
    'دايخه',
    'دوار',
    'vertiges',
    'etourdie',
    'mareo',
    'mareada',
    'mareos',
  ],
  'brainFog': [
    'brain fog',
    'foggy',
    'cant focus',
    'cant concentrate',
    'تشتت',
    'مش مركزه',
    'مش قادره اركز',
    'brouillard mental',
    'niebla mental',
    'no me concentro',
  ],
  'hairThinning': [
    'hair loss',
    'hair falling out',
    'thinning hair',
    'تساقط الشعر',
    'شعري بيقع',
    'chute de cheveux',
    'caida del pelo',
    'caida del cabello',
  ],
  'dryItchySkin': ['dry skin', 'itchy skin', 'جفاف الجلد', 'حكه', 'peau seche', 'piel seca', 'picor'],
  'bladderUrgency': [
    'peeing a lot',
    'need to pee',
    'urgency to pee',
    'كثره التبول',
    'بدخل الحمام كتير',
    'envie pressante',
    'ganas de orinar',
  ],
  'weightChange': [
    'weight gain',
    'gained weight',
    'lost weight',
    'زياده الوزن',
    'وزني زاد',
    'وزني نقص',
    'prise de poids',
    'aumento de peso',
  ],
  // Discharge
  'eggWhite': [
    'egg white',
    'stretchy',
    'clear and stretchy',
    'زي بياض البيض',
    'بياض البيض',
    'شفافه ومطاطيه',
    'مطاطيه',
    'blanc d oeuf',
    'filante',
    'clara de huevo',
    'elastico',
  ],
  'watery': ['watery discharge', 'watery', 'افرازات مائيه', 'افرازات زي المايه', 'pertes aqueuses', 'flujo acuoso'],
  'creamy': ['creamy discharge', 'creamy', 'افرازات كريميه', 'كريميه', 'pertes cremeuses', 'flujo cremoso'],
  'sticky': ['sticky discharge', 'sticky', 'افرازات لزجه', 'لزجه', 'pertes collantes', 'flujo pegajoso'],
};

/// Phrases that set the flow. Checked from the strongest level down, so "heavy period"
/// wins over "period".
const Map<String, List<String>> flowPhrases = {
  'heavy': [
    'heavy period',
    'heavy flow',
    'heavy bleeding',
    'very heavy',
    'دوره غزيره',
    'نزيف شديد',
    'نزول دم كتير',
    'دم كتير',
    'regles abondantes',
    'flux abondant',
    'regla abundante',
    'sangrado abundante',
  ],
  'light': [
    'light period',
    'light flow',
    'دوره خفيفه',
    'دم خفيف',
    'نزول خفيف',
    'regles legeres',
    'flux leger',
    'regla ligera',
    'sangrado leve',
  ],
  'medium': [
    'period started',
    'got my period',
    'my period came',
    'on my period',
    'period today',
    'الدوره نزلت',
    'نزلت الدوره',
    'جاتلي الدوره',
    'جاتني الدوره',
    'جت الدوره',
    'عندي الدوره',
    'j ai mes regles',
    'mes regles ont commence',
    'me bajo la regla',
    'me vino la regla',
    'tengo la regla',
  ],
  'spotting': ['spotting', 'spotted', 'تنقيط', 'نقط دم', 'saignements legers', 'manchado'],
};

/// Phrases for an ovulation-test result.
const Map<String, List<String>> opkPhrases = {
  'positive': [
    'positive ovulation test',
    'positive opk',
    'ovulation test positive',
    'lh surge',
    'opk positive',
    'اختبار التبويض ايجابي',
    'شريط التبويض ايجابي',
    'تحليل التبويض ايجابي',
    'test d ovulation positif',
    'test de ovulacion positivo',
  ],
  'negative': [
    'negative ovulation test',
    'negative opk',
    'ovulation test negative',
    'opk negative',
    'اختبار التبويض سلبي',
    'شريط التبويض سلبي',
    'test d ovulation negatif',
    'test de ovulacion negativo',
  ],
};

/// What one note turns into before she confirms it: chips to add, maybe a flow, maybe an
/// ovulation-test result. Every value is one the log screen already knows.
class LogDraft {
  const LogDraft({this.terms = const [], this.flow, this.opk});

  /// Vocabulary keys, in the order the vocabulary lists them, without duplicates.
  final List<String> terms;

  /// One of [flowLevels], or null.
  final String? flow;

  /// One of [phraseOpkResults], or null.
  final String? opk;

  bool get isEmpty => terms.isEmpty && flow == null && opk == null;
}

final Set<String> _knownTerms = {for (final t in logTerms) t.key};

/// Reads [note] with the phrase rules above and returns what it names. A phrase preceded
/// within three words by a negation ("no cramps", "مفيش صداع") is skipped.
LogDraft draftFromNote(String note) {
  final text = words(note);
  if (text.isEmpty) return const LogDraft();
  bool says(List<String> phrases) => phrases.any((p) => _affirmed(text, words(p)));

  final found = <String>{
    for (final entry in termPhrases.entries)
      if (_knownTerms.contains(entry.key) && says(entry.value)) entry.key,
  };
  String? flow;
  for (final level in ['heavy', 'light', 'medium', 'spotting']) {
    if (says(flowPhrases[level]!)) {
      flow = level;
      break;
    }
  }
  String? opk;
  for (final result in phraseOpkResults) {
    if (says(opkPhrases[result]!)) {
      opk = result;
      break;
    }
  }
  return LogDraft(terms: _inVocabularyOrder(found), flow: flow, opk: opk);
}

/// Combines the rule draft with a model's suggestion. Anything the model names that is not
/// in the vocabulary, the flow levels or the test results is dropped here, so a model can
/// never write a value the app does not know. The rules win when both name a flow.
LogDraft mergeDrafts(LogDraft rules, {Iterable<String> modelTerms = const [], String? modelFlow, String? modelOpk}) {
  final terms = {...rules.terms, ...modelTerms.where(_knownTerms.contains)};
  return LogDraft(
    terms: _inVocabularyOrder(terms),
    flow: rules.flow ?? (flowLevels.contains(modelFlow) ? modelFlow : null),
    opk: rules.opk ?? (phraseOpkResults.contains(modelOpk) ? modelOpk : null),
  );
}

List<String> _inVocabularyOrder(Set<String> keys) => [
  for (final t in logTerms)
    if (keys.contains(t.key)) t.key,
];

bool _affirmed(List<String> text, List<String> phrase) {
  var start = 0;
  while (start <= text.length - phrase.length) {
    final at = findPhrase(text.sublist(start), phrase);
    if (at < 0) return false;
    final index = start + at;
    final before = text.sublist((index - _negationReach).clamp(0, index), index);
    if (!before.any(_negations.contains)) return true;
    start = index + 1;
  }
  return false;
}
