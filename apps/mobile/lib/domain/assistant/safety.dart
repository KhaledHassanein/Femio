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
// - Very heavy bleeding together with dizziness or light-headedness, for anyone, shows ACOG's
//   emergency sentence word for word and Help now (MR-49, owner 2026-11-24; NHS "Heavy
//   periods" has no urgent wording, ACOG "Abnormal Uterine Bleeding" does).
// - In the year after birth, CDC's Hear Her urgent maternal warning signs open Help now.
// - A birth-control question gets the fixed sentence "femio is not a way to avoid pregnancy"
//   and never reaches a model (product rule 1).

import '../../data/profile.dart';
import '../dates.dart';
import 'text_normal.dart';

/// What the safety rules found in a note or a question.
enum SafetySignal {
  /// Nothing the rules act on.
  none,

  /// Thoughts of self-harm or suicide: Help now, before anything else.
  crisis,

  /// A sign that needs urgent care whoever she is (chest pain, trouble breathing, fainting).
  urgent,

  /// Very heavy bleeding with dizziness or light-headedness: ACOG's emergency wording.
  heavyBleeding,

  /// A pregnancy warning sign from the reviewed list; counted only while she is pregnant.
  pregnancyWarning,

  /// A CDC Hear Her urgent maternal warning sign in the year after birth.
  postpartumWarning,

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
  // CDC Hear Her: thoughts about harming yourself or your baby.
  'harm my baby',
  'hurt my baby',
  'hurting my baby',
  'اذي البيبي',
  'اذي ابني',
  'اذي بنتي',
  'اوذي الطفل',
  'faire du mal a mon bebe',
  'hacerle dano a mi bebe',
];

/// Words for very heavy bleeding (ACOG: soaking pads or tampons every hour).
const _heavyBleedingPhrases = [
  'heavy bleeding',
  'bleeding heavily',
  'bleeding a lot',
  'a lot of blood',
  'soaking',
  'soaked through',
  'نزيف',
  'نزيف جامد',
  'نزيف شديد',
  'دم كتير',
  'بنزف',
  'saignement abondant',
  'saignements abondants',
  'je saigne beaucoup',
  'hemorragie',
  'sangrado abundante',
  'sangro mucho',
  'mucha sangre',
  'hemorragia',
];

/// Dizziness or light-headedness, which with heavy bleeding makes ACOG's emergency sentence
/// apply. Fainting, chest pain and breathlessness are already urgent on their own.
const _dizzyPhrases = [
  'dizzy',
  'dizziness',
  'lightheaded',
  'light headed',
  'feel faint',
  'feeling faint',
  'دايخه',
  'دوخه',
  'دوار',
  'حاسه بدوخه',
  'هيغمى عليا',
  'etourdie',
  'vertige',
  'vertiges',
  'tete qui tourne',
  'mareada',
  'mareo',
  'aturdida',
];

/// CDC Hear Her signs after birth, in her words. Ordinary bleeding after birth is expected, so
/// only heavy bleeding, large clots and the other listed signs count here.
const _postpartumPhrases = [
  'soaking a pad',
  'soaking pads',
  'big clots',
  'large clots',
  'clots bigger than an egg',
  'fever',
  'high temperature',
  'headache that won t go away',
  'severe headache',
  'blurred vision',
  'swollen leg',
  'leg swelling',
  'calf pain',
  'smells bad',
  'severe belly pain',
  'جلطات كبيره',
  'حراره',
  'سخونيه',
  'صداع شديد',
  'زغلله',
  'رجلي وارمه',
  'وجع في سمانه رجلي',
  'ريحه وحشه',
  'الم شديد في البطن',
  'gros caillots',
  'fievre',
  'mal de tete intense',
  'vision floue',
  'jambe gonflee',
  'mauvaise odeur',
  'coagulos grandes',
  'fiebre',
  'dolor de cabeza fuerte',
  'vision borrosa',
  'pierna hinchada',
  'mal olor',
];

/// Days after the birth during which Hear Her's signs apply ("in the year after delivery").
const postpartumWarningDays = 365;

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
  'اتجنب الحمل',
  'امنع الحمل',
  'منع حمل',
  'العزل',
  'eviter une grossesse',
  'ne pas tomber enceinte',
  'eviter de tomber enceinte',
  'jours sans risque',
  'pilule du lendemain',
  'moyen de contraception',
  'anticonceptivo',
  'anticonceptivos',
  'anticoncepcion',
  'evitar el embarazo',
  'evitar embarazo',
  'no quedar embarazada',
  'no embarazarme',
  'dias seguros',
  'pildora del dia despues',
];

/// Checks [text] against the safety rules. Crisis wins over urgent, urgent over heavy bleeding,
/// heavy bleeding over a pregnancy or after-birth sign, any danger sign over a birth-control
/// question. Pregnancy signs count only when [pregnant] is true (outside pregnancy "bleeding"
/// is usually her period); after-birth signs only when [postpartum] is true.
SafetySignal safetySignal(String text, {required bool pregnant, bool postpartum = false}) {
  final w = words(text);
  if (w.isEmpty) return SafetySignal.none;
  bool any(List<String> phrases) => phrases.any((p) => findPhrase(w, words(p)) >= 0);
  if (any(_crisisPhrases)) return SafetySignal.crisis;
  if (any(_urgentPhrases)) return SafetySignal.urgent;
  if (any(_heavyBleedingPhrases) && any(_dizzyPhrases)) return SafetySignal.heavyBleeding;
  if (pregnant && any(_pregnancyPhrases)) return SafetySignal.pregnancyWarning;
  if (postpartum && (any(_postpartumPhrases) || any(_heavyBleedingPhrases))) return SafetySignal.postpartumWarning;
  if (any(_birthControlPhrases)) return SafetySignal.birthControl;
  return SafetySignal.none;
}

/// [safetySignal] with the life stage read from her [profile] as of [today] (yyyy-mm-dd):
/// pregnant until the birth is recorded, then after-birth signs for [postpartumWarningDays].
SafetySignal safetySignalFor(String text, Profile profile, String today) {
  final birth = profile.birthDate;
  final pregnant = profile.goal == Goal.pregnant && birth == null;
  final postpartum = birth != null && isValidISODate(birth) && diffDays(birth, today) <= postpartumWarningDays;
  return safetySignal(text, pregnant: pregnant, postpartum: postpartum);
}
