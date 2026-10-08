// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'femio';

  @override
  String get welcomeTitle => 'دورتك، خططك، حملك.';

  @override
  String get welcomeBody =>
      'سجلاتك تبقى على هذا الهاتف. بلا حساب، ولا تراها فيميو أبدًا.';

  @override
  String get language => 'اللغة';

  @override
  String get getStarted => 'ابدئي';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get back => 'رجوع';

  @override
  String get notSure => 'لست متأكدة';

  @override
  String get goalTitle => 'ما الذي جاء بكِ إلى femio؟';

  @override
  String get goalSub => 'يمكنك تغيير هذا في أي وقت.';

  @override
  String get goalPeriod => 'متابعة دورتي';

  @override
  String get goalPeriodDesc => 'اعرفي متى تأتي، وما المعتاد بالنسبة لكِ.';

  @override
  String get goalTtc => 'أريد الحمل';

  @override
  String get goalTtcDesc => 'أيام خصوبتك ويوم الإباضة المرجّح.';

  @override
  String get goalPregnant => 'أنا حامل';

  @override
  String get goalPregnantDesc => 'أسبوعًا بأسبوع، وموعد ولادتك.';

  @override
  String get goalMenopause => 'ما قبل انقطاع الطمث وانقطاعه';

  @override
  String get goalMenopauseDesc => 'دورات متغيّرة وأعراض.';

  @override
  String get birthYearTitle => 'في أي سنة وُلدتِ؟';

  @override
  String get birthYearSub =>
      'تتغيّر الدورات مع العمر، لذا يساعد هذا فيميو على فهم ما هو متوقّع. السنة فقط.';

  @override
  String get under18Title => 'المتابعة للبالغات حاليًا';

  @override
  String get under18Body =>
      'المتابعة في فيميو للنساء من عمر 18 عامًا فما فوق في هذا الإصدار الأول. وكل الأدلة على femioapp.com متاحة لكِ بلا حساب.';

  @override
  String get lastPeriodTitle => 'متى بدأت آخر دورة لكِ؟';

  @override
  String get lastPeriodSub => 'أول يوم للنزيف.';

  @override
  String get dontRemember => 'لا أتذكّر';

  @override
  String get periodLengthTitle => 'كم يومًا تستمر دورتك عادةً؟';

  @override
  String get cycleLengthTitle => 'كم يبلغ طول دورتك عادةً؟';

  @override
  String get cycleLengthSub =>
      'من أول يوم في دورة إلى أول يوم في الدورة التالية.';

  @override
  String get irregular => 'دوراتي غير منتظمة';

  @override
  String daysValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get tryingTitle => 'منذ متى تحاولين الحمل؟';

  @override
  String get tryingJustStarted => 'بدأت للتو';

  @override
  String get tryingUnder6 => 'أقل من 6 أشهر';

  @override
  String get trying6to12 => 'من 6 إلى 12 شهرًا';

  @override
  String get tryingOver12 => 'أكثر من سنة';

  @override
  String get dueMethodTitle => 'كيف نحسب موعد ولادتك؟';

  @override
  String get dueMethodKnown => 'أعرف موعد ولادتي';

  @override
  String get dueMethodLmp => 'أول يوم في آخر دورة';

  @override
  String get dueMethodConception => 'تاريخ الحمل (الإخصاب)';

  @override
  String get dueMethodIvf3 => 'نقل أجنة بالتلقيح الصناعي (جنين اليوم الثالث)';

  @override
  String get dueMethodIvf5 => 'نقل أجنة بالتلقيح الصناعي (جنين اليوم الخامس)';

  @override
  String get dueMethodBorn => 'لقد أنجبت طفلي';

  @override
  String get dueDateTitle => 'ما موعد ولادتك المتوقع؟';

  @override
  String get conceptionTitle => 'متى حدث الحمل؟';

  @override
  String get transferTitle => 'متى تمّ نقل الأجنة؟';

  @override
  String get birthDateTitle => 'متى وُلد طفلك؟';

  @override
  String get implausibleDue =>
      'لا يبدو هذا التاريخ مناسبًا لحمل حالي. يرجى التحقق منه.';

  @override
  String get menoLastTitle => 'متى كانت آخر دورة لكِ؟';

  @override
  String get menoOverYear => 'منذ أكثر من سنة';

  @override
  String get predictionPeriodTitle => 'دورتك القادمة';

  @override
  String get predictionFertileTitle => 'أيام خصوبتك';

  @override
  String predictionOvulation(String date) {
    return 'الإباضة المرجّحة: $date';
  }

  @override
  String predictionNextPeriod(String range) {
    return 'الدورة القادمة حوالي $range';
  }

  @override
  String rangeValue(String start, String end) {
    return '$start – $end';
  }

  @override
  String get confidenceLow => 'ثقة منخفضة: تتحسّن كلما سجّلتِ دوراتك';

  @override
  String get confidenceMedium => 'ثقة متوسطة';

  @override
  String get confidenceHigh => 'ثقة عالية';

  @override
  String get basisStated => 'بناءً على طول الدورة الذي أخبرتِنا به';

  @override
  String get irregularNote =>
      'دوراتك متغيّرة، لذا يعرض فيميو نطاقًا أوسع ولا يعدّ أيام التأخير أبدًا.';

  @override
  String get noPredictionTitle => 'سجّلي دورتك القادمة';

  @override
  String get noPredictionBody =>
      'عندما تبدأ دورتك، سجّليها وسيتوقّع فيميو الدورة التالية.';

  @override
  String pregnancyWeek(int weeks, int days) {
    return 'الأسبوع $weeks، اليوم $days';
  }

  @override
  String trimesterLabel(int n) {
    return 'الثلث $n';
  }

  @override
  String dueDateLabel(String date) {
    return 'موعد الولادة حوالي $date';
  }

  @override
  String postpartumWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks أسبوعًا منذ ولادة طفلك',
      few: '$weeks أسابيع منذ ولادة طفلك',
      two: 'أسبوعان منذ ولادة طفلك',
      one: 'أسبوع واحد منذ ولادة طفلك',
      zero: 'عمر طفلك أقل من أسبوع',
    );
    return '$_temp0';
  }

  @override
  String menoMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months شهرًا منذ آخر دورة',
      few: '$months أشهر منذ آخر دورة',
      two: 'شهران منذ آخر دورة',
      one: 'شهر واحد منذ آخر دورة',
      zero: 'آخر دورة كانت منذ أقل من شهر',
    );
    return '$_temp0';
  }

  @override
  String get menoUnknown =>
      'سجّلي أي نزيف أو أعراض، وسيحتفظ فيميو بالسجل لطبيبتك أو طبيبك.';

  @override
  String get awarenessNote =>
      'تقديرات للتوعية والتخطيط، وليست طريقة لتجنّب الحمل.';

  @override
  String get seeClinicianTtc =>
      'المحاولة لأكثر من سنة (أو ستة أشهر إذا كان عمرك 35 عامًا أو أكثر) وقت مناسب للتحدّث مع طبيبة أو طبيب.';

  @override
  String get privacyLine => 'محفوظ على هذا الهاتف فقط.';

  @override
  String get logPeriodToday => 'بدأت دورتي اليوم';

  @override
  String get loggedToday => 'تم التسجيل. تم تحديث التوقّع.';

  @override
  String get startOver => 'البدء من جديد';

  @override
  String get todayTitle => 'اليوم';
}
