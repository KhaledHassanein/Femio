// The assistant's safety rules, which run before any model and always win (ADR-078 §4).
//
// Why it exists: a model can miss a danger sign or answer a question Femio must never answer.
// These two checks are plain word rules over the four languages, so they behave the same on
// every phone, with or without Gemini Nano, and a test can prove each phrase.
//
// - A danger sign opens Help now (crisis numbers) or the pregnancy warning-signs screen. The
//   sign list follows the reviewed MR-29 sentence (`red_flags.dart`) plus the crisis and
//   collapse signs the Help now screen exists for. Femio does not decide whether it is an
//   emergency; it shows where to get help, the same way the red-flag card does.
// - A birth-control question gets the fixed sentence "femio is not a method of birth
//   control" and never reaches a model (product rule 1).

import 'text_normal.dart';

/// What the safety rules found in a note or a question.
enum SafetySignal {
  /// Nothing the rules act on.
  none,

  /// Thoughts of self-harm or suicide: Help now, before anything else.
  crisis,

  /// A sign that needs urgent care whoever she is (chest pain, trouble breathing, fainting).
  urgent,

  /// A pregnancy warning sign from the reviewed list; counted only while she is pregnant.
  pregnancyWarning,

  /// A question about avoiding pregnancy: the fixed answer, never a model.
  birthControl,
}

const _crisisPhrases = [
  'kill myself',
  'suicide',
  'suicidal',
  'end my life',
  'hurt myself',
  'harm myself',
  'want to die',
  'انتحر',
  'انتحار',
  'اموت نفسي',
  'عايزه اموت',
  'ابغى اموت',
  'اذي نفسي',
  'اوذي نفسي',
  'me suicider',
  'suicide',
  'me faire du mal',
  'envie de mourir',
  'suicidarme',
  'suicidio',
  'hacerme dano',
  'quiero morir',
];

const _urgentPhrases = [
  'chest pain',
  'cant breathe',
  'cannot breathe',
  'trouble breathing',
  'short of breath',
  'fainted',
  'passed out',
  'seizure',
  'الم في الصدر',
  'وجع في صدري',
  'صدري واجعني',
  'مش قادره اتنفس',
  'ضيق تنفس',
  'ضيق في التنفس',
  'اغمي عليا',
  'اغمى علي',
  'اغماء',
  'تشنجات',
  'تشنج',
  'douleur thoracique',
  'douleur a la poitrine',
  'je n arrive pas a respirer',
  'essoufflee',
  'evanouie',
  'convulsions',
  'dolor en el pecho',
  'no puedo respirar',
  'falta de aire',
  'me desmaye',
  'desmayo',
  'convulsiones',
];

/// The MR-29 signs (headache, vision, upper abdomen, swelling, breathing, bleeding, movements),
/// in the words she would use. Breathing is already in [_urgentPhrases].
const _pregnancyPhrases = [
  'severe headache',
  'bad headache',
  'blurred vision',
  'blurry vision',
  'seeing spots',
  'flashing lights',
  'vision changes',
  'pain under my ribs',
  'upper belly pain',
  'upper abdominal pain',
  'sudden swelling',
  'swollen face',
  'swollen hands',
  'bleeding',
  'blood',
  'leaking fluid',
  'waters broke',
  'water broke',
  'baby moving less',
  'baby not moving',
  'fewer movements',
  'reduced movements',
  'صداع شديد',
  'صداع جامد',
  'زغلله',
  'زغللة',
  'مش شايفه كويس',
  'نظري اتغير',
  'الم تحت الضلوع',
  'الم في اعلى البطن',
  'تورم مفاجئ',
  'وشي وارم',
  'ايدي وارمه',
  'نزيف',
  'دم',
  'نزول دم',
  'المايه نزلت',
  'نزول مايه',
  'سائل نازل',
  'البيبي مش بيتحرك',
  'حركه البيبي قلت',
  'حركه الجنين قلت',
  'الجنين مش بيتحرك',
  'الجنين ما يتحرك',
  'mal de tete intense',
  'vision floue',
  'troubles de la vue',
  'douleur sous les cotes',
  'gonflement soudain',
  'visage gonfle',
  'saignement',
  'saignements',
  'perte de liquide',
  'perte des eaux',
  'bebe bouge moins',
  'bebe ne bouge plus',
  'dolor de cabeza fuerte',
  'vision borrosa',
  'dolor bajo las costillas',
  'hinchazon repentina',
  'cara hinchada',
  'sangrado',
  'sangre',
  'perdida de liquido',
  'rompi aguas',
  'bebe se mueve menos',
  'bebe no se mueve',
];

const _birthControlPhrases = [
  'birth control',
  'contraception',
  'contraceptive',
  'avoid pregnancy',
  'avoid getting pregnant',
  'prevent pregnancy',
  'not get pregnant',
  'not to get pregnant',
  'safe days',
  'safe day',
  'morning after pill',
  'pull out method',
  'withdrawal method',
  'منع الحمل',
  'موانع الحمل',
  'مانع حمل',
  'حبوب منع',
  'الايام الامنه',
  'ايام الامان',
  'ايام امان',
  'عشان ما احملش',
  'مش عايزه احمل',
  'ما ابغى احمل',
  'تجنب الحمل',
  'العزل',
  'eviter une grossesse',
  'ne pas tomber enceinte',
  'jours sans risque',
  'pilule du lendemain',
  'moyen de contraception',
  'anticonceptivo',
  'anticonceptivos',
  'anticoncepcion',
  'evitar el embarazo',
  'evitar embarazo',
  'no quedar embarazada',
  'dias seguros',
  'pildora del dia despues',
];

/// Checks [text] against the safety rules. Crisis wins over urgent, urgent over a pregnancy
/// sign, any danger sign over a birth-control question. Pregnancy signs count only when
/// [pregnant] is true: outside pregnancy "bleeding" is usually her period.
SafetySignal safetySignal(String text, {required bool pregnant}) {
  final w = words(text);
  if (w.isEmpty) return SafetySignal.none;
  bool any(List<String> phrases) => phrases.any((p) => findPhrase(w, words(p)) >= 0);
  if (any(_crisisPhrases)) return SafetySignal.crisis;
  if (any(_urgentPhrases)) return SafetySignal.urgent;
  if (pregnant && any(_pregnancyPhrases)) return SafetySignal.pregnancyWarning;
  if (any(_birthControlPhrases)) return SafetySignal.birthControl;
  return SafetySignal.none;
}
