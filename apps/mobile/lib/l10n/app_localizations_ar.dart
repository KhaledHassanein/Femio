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
  String get goalMenopause => 'ما حول انقطاع الطمث وانقطاعه';

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
  String get periodLengthTitle => 'كم يومًا يستمر نزيف الدورة عادةً؟';

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
  String get dueMethodTitle => 'كيف نحسب موعد ولادتك المتوقّع؟';

  @override
  String get dueMethodKnown => 'أعرف موعد ولادتي';

  @override
  String get dueMethodLmp => 'أول يوم في آخر دورة';

  @override
  String get dueMethodConception => 'تاريخ الإخصاب';

  @override
  String get dueMethodIvf3 => 'نقل جنين اليوم الثالث (أطفال الأنابيب IVF)';

  @override
  String get dueMethodIvf5 => 'نقل جنين اليوم الخامس (أطفال الأنابيب IVF)';

  @override
  String get dueMethodBorn => 'لقد أنجبت طفلي';

  @override
  String get dueDateTitle => 'ما موعد ولادتك المتوقع؟';

  @override
  String get conceptionTitle => 'متى حدث الإخصاب؟';

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
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'الثلث $n',
      few: 'الثلث الثالث',
      two: 'الثلث الثاني',
      one: 'الثلث الأول',
    );
    return '$_temp0';
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

  @override
  String get logHappy => 'سعيدة';

  @override
  String get logCalm => 'هادئة';

  @override
  String get logAnxious => 'قلقة';

  @override
  String get logIrritable => 'سريعة الانفعال';

  @override
  String get logSad => 'حزينة';

  @override
  String get logMoodSwings => 'تقلّب المزاج';

  @override
  String get logLowMotivation => 'قلة الدافع';

  @override
  String get logTearfulness => 'سرعة البكاء';

  @override
  String get logPanicFeelings => 'نوبات هلع مفاجئة';

  @override
  String get logCramps => 'تقلّصات';

  @override
  String get logHeadache => 'صداع';

  @override
  String get logBloating => 'انتفاخ';

  @override
  String get logBreastTenderness => 'ألم الثدي';

  @override
  String get logBackache => 'ألم الظهر';

  @override
  String get logJointPain => 'ألم المفاصل';

  @override
  String get logMusclePain => 'آلام عضلية';

  @override
  String get logNausea => 'غثيان';

  @override
  String get logConstipation => 'إمساك';

  @override
  String get logDiarrhea => 'إسهال';

  @override
  String get logFatigue => 'إرهاق';

  @override
  String get logAcne => 'حبّ الشباب';

  @override
  String get logHotFlashes => 'هبّات ساخنة';

  @override
  String get logNightSweats => 'تعرّق ليلي';

  @override
  String get logSpotting => 'تنقيط';

  @override
  String get logHeartFlutters => 'خفقان أو تسارع في القلب';

  @override
  String get logWeightChange => 'تغيّر في الوزن';

  @override
  String get logCravings => 'اشتهاء الطعام';

  @override
  String get logInsomnia => 'صعوبة النوم';

  @override
  String get logDizziness => 'دوخة';

  @override
  String get logBrainFog => 'تشوّش ذهني';

  @override
  String get logLibidoUp => 'ارتفاع الرغبة الجنسية';

  @override
  String get logLibidoDown => 'انخفاض الرغبة الجنسية';

  @override
  String get logVaginalDryness => 'جفاف المهبل';

  @override
  String get logPainDuringSex => 'ألم أثناء العلاقة';

  @override
  String get logBladderUrgency => 'إلحاح أو تكرار في التبوّل';

  @override
  String get logBladderLeaks => 'تسرّب البول';

  @override
  String get logHairThinning => 'خفّة الشعر';

  @override
  String get logDryItchySkin => 'جفاف الجلد أو حكّته';

  @override
  String get logBrittleNails => 'هشاشة الأظافر';

  @override
  String get logGumSoreness => 'التهاب اللثة أو نزفها';

  @override
  String get logBurningMouth => 'حرقان أو تنميل في الفم';

  @override
  String get logTingling => 'تنميل في اليدين أو القدمين';

  @override
  String get logElectricShocks => 'إحساس لحظي يشبه الصعقة';

  @override
  String get logBodyOdourChange => 'تغيّر في رائحة الجسم';

  @override
  String get logTinnitus => 'طنين في الأذن';

  @override
  String get logDry => 'جاف';

  @override
  String get logSticky => 'لزج';

  @override
  String get logCreamy => 'كريمي';

  @override
  String get logWatery => 'مائي';

  @override
  String get logEggWhite => 'شبيه ببياض البيض';

  @override
  String get logIntercourse => 'جماع';

  @override
  String get flowSpotting => 'تنقيط';

  @override
  String get flowLight => 'خفيف';

  @override
  String get flowMedium => 'متوسط';

  @override
  String get flowHeavy => 'غزير';

  @override
  String get flowLabel => 'الغزارة';

  @override
  String get navToday => 'اليوم';

  @override
  String get navCalendar => 'التقويم';

  @override
  String get navLog => 'السجل';

  @override
  String get calendarTitle => 'التقويم';

  @override
  String get legendPeriod => 'الدورة';

  @override
  String get legendSpotting => 'تنقيط';

  @override
  String get legendPredicted => 'قد تبدأ الدورة';

  @override
  String get legendFertile => 'أيام الخصوبة';

  @override
  String get legendOvulation => 'الإباضة المرجّحة';

  @override
  String get legendLogged => 'سجّلتِ شيئًا';

  @override
  String get calendarHint =>
      'اضغطي على أي يوم لتسجيله. التقديرات تظهر بإطار فقط، وما تسجّلينه يظهر ممتلئًا.';

  @override
  String get logTitle => 'السجل';

  @override
  String get sectionPeriod => 'الدورة';

  @override
  String get flowNone => 'لا يوجد';

  @override
  String get sectionMood => 'المزاج';

  @override
  String get sectionSymptoms => 'الأعراض';

  @override
  String get sectionDischarge => 'الإفرازات';

  @override
  String get sectionMore => 'أخرى';

  @override
  String get previousDay => 'اليوم السابق';

  @override
  String get nextDay => 'اليوم التالي';

  @override
  String get logSavedNote => 'يُحفظ على هذا الهاتف فور الضغط.';

  @override
  String get logSymptomsButton => 'سجّلي ما تشعرين به';

  @override
  String loggedTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سجّلتِ $count شيئًا اليوم',
      few: 'سجّلتِ $count أشياء اليوم',
      two: 'سجّلتِ شيئين اليوم',
      one: 'سجّلتِ شيئًا واحدًا اليوم',
      zero: 'لم تسجّلي شيئًا اليوم',
    );
    return '$_temp0';
  }

  @override
  String get sectionOvulationTest => 'اختبار الإباضة';

  @override
  String get sectionTemperature => 'حرارة الاستيقاظ';

  @override
  String get temperatureHint =>
      'تُقاس قبل النهوض من السرير، بالدرجة المئوية أو الفهرنهايت';

  @override
  String get temperatureSave => 'حفظ';

  @override
  String get temperatureClear => 'مسح';

  @override
  String get testTimingTitle => 'متى تُجرين الاختبار';

  @override
  String testTimingBody(String date) {
    return 'إذا لم تبدأ دورتك بحلول $date، يكون اختبار الحمل المنزلي موثوقًا ابتداءً من ذلك اليوم.';
  }

  @override
  String get opkNegative => 'سلبي';

  @override
  String get opkLow => 'منخفض';

  @override
  String get opkHigh => 'مرتفع';

  @override
  String get opkPeak => 'الذروة';

  @override
  String get opkPositive => 'إيجابي';

  @override
  String get bbtChartHeading => 'درجات حرارتكِ';

  @override
  String get bbtChartNeedData =>
      'سجّلي ثلاث قياسات لحرارة الاستيقاظ ليظهر رسمكِ هنا. ما دون ذلك نقطة، لا نمط.';

  @override
  String get bbtChartNote =>
      'هذه قياساتكِ كما هي. لا يضع فيميو علامة على تحوّل ولا يسمّي يومًا — فمعنى الرسم حديثٌ بينكِ وبين طبيبكِ.';

  @override
  String get invalidBbt =>
      'لا يبدو هذا قياسًا لميزان حرارة. راجعي الرقم وأعيدي المحاولة.';

  @override
  String get testTimingGeneral =>
      'تعمل معظم الاختبارات المنزلية ابتداءً من أول يوم لتأخر الدورة. قد يعطي الاختبار المبكر نتيجة سلبية حتى لو كنتِ حاملًا.';

  @override
  String get testTimingSource =>
      'المصدر: هيئة الخدمات الصحية البريطانية (NHS)، إجراء اختبار الحمل.';

  @override
  String pregDaysToGo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بقي $days يومًا',
      few: 'بقي $days أيام',
      two: 'بقي يومان',
      one: 'بقي يوم واحد',
      zero: 'اليوم موعد الولادة المتوقّع',
    );
    return '$_temp0';
  }

  @override
  String pregOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'مضى $days يومًا على موعد الولادة المتوقّع',
      few: 'مضت $days أيام على موعد الولادة المتوقّع',
      two: 'مضى يومان على موعد الولادة المتوقّع',
      one: 'مضى يوم واحد على موعد الولادة المتوقّع',
    );
    return '$_temp0';
  }

  @override
  String pregTermFrom(String date) {
    return 'الحمل تامّ المدة اعتبارًا من $date';
  }

  @override
  String get pregEstimateNote =>
      'هذه التواريخ تقديرات مبنية على موعد الولادة المتوقّع الذي أدخلتِه. قد يعدّله طبيبكِ بعد فحص السونار.';

  @override
  String get pregRedFlagsHeading => 'بعض الأعراض تحتاج رعاية عاجلة';

  @override
  String get pregRedFlagsBody =>
      'النزيف، أو الصداع الشديد، أو تغيّر الرؤية، أو ألم البطن الشديد، أو قلّة حركة الجنين — كلها تحتاج فحصًا فوريًا. اتّصلي بوحدة الولادة أو بخدمات الطوارئ المحلية، ولا تنتظري.';

  @override
  String get contractionsHeading => 'مؤقّت الانقباضات';

  @override
  String get contractionsIntro =>
      'اضغطي «ابدئي» عند بدء الانقباضة و«خفّت» عند انتهائها. يحتفظ فيميو بالأوقات لتكون بين يديكِ عند الاتصال.';

  @override
  String get contractionsStart => 'ابدئي انقباضة';

  @override
  String get contractionsStop => 'خفّت';

  @override
  String get contractionsRunning => 'يجري القياس';

  @override
  String get contractionsContactHeading =>
      'اتصلي بوحدة الولادة متى احتجتِ إلى ذلك';

  @override
  String get contractionsContactBody =>
      'لستِ مضطرة لبلوغ رقم معيّن أولًا. اتصلي إن كنتِ قلقة، أو إن نزل السائل الأمنيوسي (ماء الرأس)، أو حدث نزيف، أو قلّت حركة الجنين عن المعتاد.';

  @override
  String contractionsSummaryHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'آخر $count انقباضة',
      few: 'آخر $count انقباضات',
      two: 'آخر انقباضتين',
      one: 'آخر انقباضة',
    );
    return '$_temp0';
  }

  @override
  String contractionsSummaryDuration(String value) {
    return 'تستمر نحو $value';
  }

  @override
  String contractionsSummaryInterval(String value) {
    return 'بفاصل نحو $value من بداية إلى بداية';
  }

  @override
  String get contractionsSummaryNote =>
      'هذه أوقاتكِ كما سُجّلت. لا يقرّر فيميو معناها — اقرئيها على القابلة أو وحدة الولادة، فهم من يقرّر.';

  @override
  String get movementsHeading => 'سجل الحركة';

  @override
  String get movementsIntro =>
      'لا يوجد عدد طبيعي محدد للحركات. المهم هو التغيّر عن النمط المعتاد لطفلك، لذلك يسجّل هذا ما تشعرين به ويُظهر لك نمطك مع الوقت.';

  @override
  String get movementsUrgentHeading => 'إذا قلّت الحركات عن المعتاد';

  @override
  String get movementsUrgentBody =>
      'تواصلي مع فريق رعاية الحمل الآن. لا تنتظري انتهاء هذه الجلسة، ولا تنتظري حتى الغد.';

  @override
  String get movementsStart => 'ابدئي جلسة';

  @override
  String get movementsStartBody =>
      'استرخي ثم ابدئي. اضغطي في كل مرة تشعرين فيها بحركة.';

  @override
  String get movementsTap => 'شعرتُ بحركة';

  @override
  String movementsCounted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حركة مسجّلة',
      few: '$count حركات مسجّلة',
      two: 'حركتان مسجّلتان',
      one: 'حركة واحدة مسجّلة',
      zero: 'لا حركات مسجّلة بعد',
    );
    return '$_temp0';
  }

  @override
  String get movementsFinish => 'إنهاء وحفظ';

  @override
  String get movementsFinishNote =>
      'يمكنك التوقف في أي وقت. تُحفظ الجلسة في الحالتين.';

  @override
  String get movementsRecentHeading => 'جلساتك الأخيرة';

  @override
  String movementsSessionSummary(int count, String minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count حركة',
      few: '$count حركات',
      two: 'حركتان',
      one: 'حركة واحدة',
    );
    return '$_temp0 · نحو $minutes دقيقة بين كل حركة';
  }

  @override
  String get movementsUnfinished => 'غير مكتملة';

  @override
  String get movementsSlowerHeading =>
      'كانت الحركات متباعدة أكثر من المعتاد لديك';

  @override
  String get movementsSlowerBody =>
      'هذا تغيّر عن جلساتك الأخيرة. تفسير ذلك يعود إلى فريق رعاية الحمل، فتواصلي معهم ليطمئن أحدهم عليك.';

  @override
  String movementsNeedMore(String count) {
    return 'بعد $count جلسات ستتمكنين من المقارنة مع نمطك الخاص.';
  }

  @override
  String get pregnancyToolsTitle => 'أدوات الحمل';

  @override
  String get contractionsClear => 'امسحي هذه الأوقات';

  @override
  String get contractionsCleared => 'تم مسح الأوقات';

  @override
  String get contractionLength => 'المدة';

  @override
  String get contractionApart => 'الفاصل';
}
