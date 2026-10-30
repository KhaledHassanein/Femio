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
      'تبقى سجلاتكِ على هذا الهاتف. لا حساب، ولا يرى femio سجلاتكِ أبدًا.';

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
      'تتغيّر الدورات مع العمر، لذا يساعد هذا femio على فهم ما هو متوقّع. السنة فقط.';

  @override
  String get under18Title => 'المتابعة للبالغات حاليًا';

  @override
  String get under18Body =>
      'المتابعة في femio للنساء من عمر 18 عامًا فما فوق في هذا الإصدار الأول. وكل الأدلة على femioapp.com متاحة لكِ بلا حساب.';

  @override
  String get eighteenTitle => 'هل مرّ عيد ميلادكِ الثامن عشر؟';

  @override
  String get eighteenSub =>
      'سؤال سريع واحد: المتابعة للنساء من عمر 18 عامًا فما فوق. لا يُحفظ شيء هنا.';

  @override
  String get yesLabel => 'نعم';

  @override
  String get noNotYetLabel => 'لا، ليس بعد';

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
      'دوراتك متغيّرة، لذا يعرض femio نطاقًا أوسع ولا يعدّ أيام التأخير أبدًا.';

  @override
  String get noPredictionTitle => 'سجّلي دورتك القادمة';

  @override
  String get noPredictionBody =>
      'عندما تبدأ دورتك، سجّليها وسيتوقّع femio الدورة التالية.';

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
      'سجّلي أي نزيف أو أعراض، وسيحتفظ femio بالسجل لطبيبتك أو طبيبك.';

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
      'هذه قياساتكِ كما هي. لا يضع femio علامة على تحوّل ولا يسمّي يومًا — فمعنى الرسم حديثٌ بينكِ وبين طبيبكِ.';

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
      'اطلبي الرعاية فورًا إذا كان لديكِ صداع شديد، أو تغيّر في الرؤية، أو ألم في أعلى البطن، أو تورّم في الوجه أو اليدين، أو صعوبة في التنفس. تواصلي مع وحدة الولادة أو خدمات الطوارئ المحلية. وإذا تعذّر الوصول إليهم، توجّهي إلى أقرب قسم طوارئ.';

  @override
  String get pregRedFlagsMore => 'اعرضي القائمة الكاملة ومصادرها';

  @override
  String get redFlagsListHeading => 'اطلبي الرعاية فورًا عند أي من هذه الأعراض';

  @override
  String get redFlagHeadache => 'صداع شديد';

  @override
  String get redFlagVision => 'تغيّر في الرؤية';

  @override
  String get redFlagUpperAbdomen => 'ألم في أعلى البطن';

  @override
  String get redFlagSwelling => 'تورّم في الوجه أو اليدين';

  @override
  String get redFlagBreathing => 'صعوبة في التنفس';

  @override
  String get contractionsHeading => 'مؤقّت الانقباضات';

  @override
  String get contractionsIntro =>
      'اضغطي «ابدئي» عند بدء الانقباضة و«خفّت» عند انتهائها. يحتفظ femio بالأوقات لتكون بين يديكِ عند الاتصال.';

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
      'هذه أوقاتكِ كما سُجّلت. لا يقرّر femio معناها — اقرئيها على القابلة أو وحدة الولادة، فهم من يقرّر.';

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

  @override
  String get apptTitle => 'المواعيد';

  @override
  String get apptAdd => 'أضيفي موعدًا';

  @override
  String get apptCancel => 'إلغاء';

  @override
  String get apptSave => 'حفظ الموعد';

  @override
  String get apptUntitled => 'موعد';

  @override
  String get apptNoDate => 'بلا تاريخ بعد';

  @override
  String get apptToday => 'اليوم';

  @override
  String apptInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'بعد $days يومًا',
      few: 'بعد $days أيام',
      two: 'بعد يومين',
      one: 'غدًا',
    );
    return '$_temp0';
  }

  @override
  String get apptPrepHeading => 'ما أردتِ أن تسأليه';

  @override
  String get apptUpcoming => 'القادمة';

  @override
  String get apptPast => 'السابقة';

  @override
  String get apptNoResultsNote =>
      'يحتفظ femio بموعدكِ ومع من هو وبما أردتِ أن تسأليه. ولا يحتفظ بما تبيّن — فذلك يخصّ طبيبكِ وملفكِ الطبي.';

  @override
  String get apptEmptyHeading => 'لا شيء هنا بعد';

  @override
  String get apptEmptyBody =>
      'أضيفي موعدًا ليحفظ femio الأسئلة التي نويتِ طرحها، فهي الجزء الذي يُنسى داخل العيادة.';

  @override
  String get apptAwaitingHeading => 'ألم تصلكِ النتيجة بعد؟';

  @override
  String apptAwaitingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'كنتِ تتوقّعين نتائج $count موعدًا منها حتى الآن.',
      few: 'كنتِ تتوقّعين نتائج $count مواعيد منها حتى الآن.',
      two: 'كنتِ تتوقّعين نتيجتَي موعدين منها حتى الآن.',
      one: 'كنتِ تتوقّعين نتيجة أحد هذه المواعيد حتى الآن.',
    );
    return '$_temp0 قد يستحق الأمر السؤال — فتأخّر النتائج يحدث لأسباب اعتيادية كثيرة.';
  }

  @override
  String get apptFormType => 'ما هو';

  @override
  String get apptFormTypePlaceholder => 'أشعة، تحليل دم، متابعة…';

  @override
  String get apptFormClinician => 'مع من';

  @override
  String get apptFormWhen => 'متى';

  @override
  String get apptFormResultsDue => 'قيل لكِ إن النتيجة تصل بحلول';

  @override
  String get apptFormResultsDueHint =>
      'اختياري. سيذكّركِ femio بالسؤال إذا مرّ التاريخ، ولا يسجّل النتيجة نفسها أبدًا.';

  @override
  String get apptFormPrep => 'أسئلة تريدين طرحها';

  @override
  String get apptFormPrepPlaceholder => 'سؤال في كل سطر';

  @override
  String apptPrepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سؤالًا محفوظًا',
      few: '$count أسئلة محفوظة',
      two: 'سؤالان محفوظان',
      one: 'سؤال واحد محفوظ',
    );
    return '$_temp0';
  }

  @override
  String get weightHeading => 'الوزن';

  @override
  String get weightIntro =>
      'أضيفي قياسًا وقتما تشائين. يرسمها femio ويحتفظ بالأرقام لملفكِ.';

  @override
  String get weightValue => 'الوزن';

  @override
  String get weightSave => 'حفظ';

  @override
  String get weightInvalid =>
      'لا يبدو هذا قياسًا لميزان. راجعي الرقم وأعيدي المحاولة.';

  @override
  String get weightNeedData => 'أضيفي قياسًا ثانيًا ليظهر الرسم هنا.';

  @override
  String weightChange(String value, String unit) {
    return '$value $unit منذ أول قياس';
  }

  @override
  String get weightNote =>
      'قياساتكِ كما هي. لا يعرض femio نطاقًا مستهدفًا ولا يقول إن كان التغيّر متوقّعًا — فمعنى النمط بينكِ وبين قابلتكِ أو طبيبكِ.';

  @override
  String get weightDate => 'تاريخ القياس';

  @override
  String get weightUnitKg => 'كجم';

  @override
  String get weightUnitLb => 'رطل';

  @override
  String get apptDelete => 'حذف';

  @override
  String get apptEdit => 'تعديل';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsDates => 'التواريخ';

  @override
  String get settingsHijri => 'إظهار التاريخ الهجري';

  @override
  String get settingsHijriNote =>
      'إلى جانب كل تاريخ ميلادي. بحسب تقويم أم القرى، وقد يختلف يومًا عن الإعلان المحلي.';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsLock => 'قفل التطبيق';

  @override
  String get settingsLockNote =>
      'طلب رمز PIN عند فتح femio وبعد دقيقة من الغياب.';

  @override
  String get setPin => 'اختاري رمز PIN من 4 إلى 8 أرقام';

  @override
  String get changePin => 'تغيير رمز PIN';

  @override
  String get enterPin => 'رمز PIN';

  @override
  String get enterPinAgain => 'أدخلي رمز PIN مرة أخرى';

  @override
  String get enterCurrentPin => 'أدخلي رمز PIN الحالي';

  @override
  String get pinMismatch => 'الرمزان غير متطابقين. حاولي مرة أخرى.';

  @override
  String get wrongPin => 'هذا الرمز غير صحيح.';

  @override
  String get lockTitle => 'أهلًا بعودتكِ';

  @override
  String get lockHint => 'أدخلي رمز PIN لفتح سجلاتكِ.';

  @override
  String get forgotPin =>
      'نسيتِ الرمز؟ لا توجد طريقة لاستعادته، فليس في femio حساب. احذفي كل شيء من هذا الهاتف وابدئي من جديد، أو استعيدي ملف نسخة احتياطية.';

  @override
  String get backupSection => 'النسخ الاحتياطي';

  @override
  String get exportBackup => 'حفظ ملف نسخة احتياطية';

  @override
  String get importBackup => 'الاستعادة من ملف نسخة احتياطية';

  @override
  String get backupPassphrase => 'عبارة المرور';

  @override
  String get backupPassphraseAgain => 'عبارة المرور مرة أخرى';

  @override
  String get backupPassphraseHint =>
      'اختاري عبارة مرور تتذكرينها. لا يُفتح الملف إلا بها، ولا يستطيع أحد إعادة تعيينها.';

  @override
  String backupPassphraseShort(int count) {
    return 'استخدمي $count أحرف على الأقل.';
  }

  @override
  String get backupPassphraseMismatch => 'عبارتا المرور غير متطابقتين.';

  @override
  String get backupSaved => 'تم حفظ النسخة الاحتياطية.';

  @override
  String get backupImported => 'تمت استعادة سجلاتكِ.';

  @override
  String get backupWrongPassphrase => 'عبارة المرور هذه لا تفتح هذا الملف.';

  @override
  String get backupNotFemio => 'هذا ليس ملف نسخة احتياطية من femio.';

  @override
  String get backupUnreadable =>
      'أُنشئت هذه النسخة بإصدار أحدث من femio ولا يمكن قراءتها هنا. حدّثي التطبيق وحاولي مرة أخرى.';

  @override
  String get backupHonesty =>
      'سجلاتكِ محفوظة على هذا الهاتف فقط. إذا فُقد الهاتف أو أُعيد ضبطه فستضيع السجلات ما لم تكوني قد حفظتِ ملف نسخة احتياطية. ولا نستطيع استرجاعها لكِ.';

  @override
  String get aboutSection => 'حول التطبيق';

  @override
  String get wellnessDisclaimer =>
      'femio أداة للتوعية والمتابعة الصحية الشخصية، وليست جهازًا طبيًا ولا تغني عن استشارة الطبيبة أو الطبيب.';

  @override
  String get predictionNote =>
      'التوقعات تقديرات وليست ضمانات، ولا يجوز الاعتماد عليها لتجنّب الحمل.';

  @override
  String get firstRunStorageNotice =>
      'تبقى سجلاتكِ على هذا الهاتف. لا يوجد في femio حساب ولا خادم، ولا يستطيع أن يرى ما تُدخلينه.';

  @override
  String get firstRunStorageTitle => 'خصوصية بالتصميم';

  @override
  String get dismiss => 'فهمت';

  @override
  String get deleteEverything => 'حذف كل شيء من هذا الهاتف';

  @override
  String get deleteConfirmTitle => 'حذف كل شيء من هذا الهاتف؟';

  @override
  String get deleteConfirmBody =>
      'سيحذف femio جميع سجلاتكِ وإعداداتكِ من هذا الهاتف. لا يمكن التراجع عن ذلك ولا نستطيع استعادتها. ولن تُحذف ملفات النسخ الاحتياطي التي حفظتِها في مكان آخر.';

  @override
  String get deleteConfirmAction => 'احذفي كل شيء';

  @override
  String get deleteConfirmCancel => 'أبقي سجلاتي';

  @override
  String get corruptTitle => 'تعذّر فتح سجلاتكِ';

  @override
  String get corruptBody =>
      'الملف على هذا الهاتف تالف أو كُتب بإصدار مختلف من femio. تم الاحتفاظ به جانبًا ولم يُحذف. استعيدي ملف نسخة احتياطية إن كان لديكِ، أو ابدئي من جديد.';

  @override
  String get settingsReminders => 'التذكيرات';

  @override
  String get reminderLog => 'تذكير بالتسجيل';

  @override
  String get reminderLogNote =>
      'تذكير يومي في الوقت الذي تختارينه. ولا يصلكِ في يوم سجّلتِ فيه بالفعل.';

  @override
  String get reminderLogTime => 'وقت التذكير';

  @override
  String get reminderPeriod => 'توقّع الدورة';

  @override
  String get reminderPeriodNote =>
      'إشعار واحد قبل بدء النافذة المتوقعة بيوم. فقط حين تكون دوراتكِ منتظمة بما يكفي للتقدير.';

  @override
  String get remindersPrivacyNote =>
      'يقول التذكير فقط: «femio: افتحي التطبيق». ولا يظهر على شاشة القفل أي شيء عن صحتكِ.';

  @override
  String get remindersTimingNote =>
      'قد يصل التذكير متأخرًا بضع دقائق، وبعض الهواتف تؤخّره لتوفير البطارية.';

  @override
  String get reminderPermissionDenied =>
      'الإشعارات متوقفة لتطبيق femio. يمكنكِ السماح بها من إعدادات هاتفكِ.';

  @override
  String get reminderTitle => 'femio';

  @override
  String get reminderBody => 'افتحي التطبيق';

  @override
  String get reminderChannelName => 'التذكيرات';

  @override
  String get reminderChannelDescription =>
      'تذكيرات فعّلتِها في femio. ولا تذكر صحتكِ أبدًا.';

  @override
  String calendarDayLabel(String gregorian, String hijri) {
    return '$gregorian، $hijri';
  }

  @override
  String get navLearn => 'تعلّمي';

  @override
  String get learnTitle => 'تعلّمي';

  @override
  String get learnSub =>
      'أدلة موثّقة بكلمات بسيطة. محاولة الحمل والحمل أولًا، وكل شيء يبقى هنا.';

  @override
  String get learnSearchHint => 'ابحثي في الأدلة';

  @override
  String get learnNoResults => 'لا يوجد دليل يطابق ذلك بعد.';

  @override
  String learnReviewedBy(String name) {
    return 'راجعها $name';
  }

  @override
  String learnReviewedOn(String name, String date) {
    return 'راجعها $name · $date';
  }

  @override
  String get learnReviewPending =>
      'دُقّق تحريريًا · المراجعة الطبية قيد الانتظار';

  @override
  String get learnEnglishOnly => 'بالإنجليزية';

  @override
  String get learnEnglishOnlyBody =>
      'هذا الدليل غير مترجم بعد، لذلك يظهر باللغة الإنجليزية.';

  @override
  String get learnSeekCareNow => 'اطلبي الرعاية الآن';

  @override
  String get learnSources => 'المصادر';

  @override
  String get learnLinkCopied => 'تم نسخ الرابط. الصقيه في المتصفح.';

  @override
  String get noConfidentWindowTitle =>
      'لا توجد نافذة خصوبة موثوقة في هذه الدورة';

  @override
  String get noConfidentWindowBody =>
      'دوراتكِ متفاوتة أكثر من أن تُحدَّد أيام الخصوبة من تاريخ واحد. تسجيل دوراتكِ واختبارات التبويض وحرارة جسمكِ عند الاستيقاظ هو ما يكشف ذلك لاحقًا.';

  @override
  String get seeClinicianIrregular =>
      'لأن دوراتكِ غير منتظمة، من المعقول التحدّث مع طبيبتكِ الآن بدل الانتظار سنة.';

  @override
  String get helpNowLauncher => 'تحتاجين مساعدة الآن؟';

  @override
  String get helpNowDialogTitle => 'تحتاجين مساعدة الآن؟';

  @override
  String get helpNowImmediateHeading => 'إذا كنتِ قد تكونين في خطر';

  @override
  String get helpNowImmediateLead =>
      'إذا كنتِ قد تُقدِمين على إيذاء نفسكِ أو إيذاء شخصٍ آخر، أو كنتِ في خطر مباشر، فاتصلي بخدمات الطوارئ المتاحة في المكان الذي أنتِ فيه الآن، أو توجّهي إلى أقرب قسم طوارئ.';

  @override
  String get helpNowStayWithSomeone =>
      'إن استطعتِ، ابقي مع شخصٍ تثقين به إلى أن تحصلي على المساعدة.';

  @override
  String get helpNowWorriedHeading => 'إذا كنتِ قلقة على شخصٍ آخر';

  @override
  String get helpNowWorriedBody =>
      'إذا كنتِ ترين أن الشخص في خطر مباشر، فلا تتركيه وحده ما دام البقاء آمنًا لكِ. اتصلي بخدمات الطوارئ المتاحة في المكان الذي هو فيه، أو بخدمة أزمات، أو بعامل صحي، أو بأحد أفراد العائلة موضع الثقة.';

  @override
  String get helpNowCountry_egypt => 'مصر';

  @override
  String get helpNowCountry_saudi => 'المملكة العربية السعودية';

  @override
  String get helpNowCountry_uae => 'الإمارات العربية المتحدة';

  @override
  String get helpNowCountry_qatar => 'قطر';

  @override
  String get helpNowCountry_kuwait => 'الكويت';

  @override
  String get helpNowCountry_bahrain => 'البحرين';

  @override
  String get helpNowCountry_oman => 'عُمان';

  @override
  String get helpNowCountry_jordan => 'الأردن';

  @override
  String get helpNowCountry_lebanon => 'لبنان';

  @override
  String get helpNowCountry_morocco => 'المغرب';

  @override
  String get helpNowCountry_uk => 'المملكة المتحدة';

  @override
  String get helpNowCountry_france => 'فرنسا';

  @override
  String get helpNowCountry_spain => 'إسبانيا';

  @override
  String get helpNowCountry_usa => 'الولايات المتحدة';

  @override
  String get helpNowCountry_canada => 'كندا';

  @override
  String get helpNowCountry_mexico => 'المكسيك';

  @override
  String get helpNowNumber_eg_ambulance => 'الإسعاف (هيئة الإسعاف المصرية)';

  @override
  String get helpNowNumber_eg_mental_health =>
      'الخط الساخن للصحة النفسية (وزارة الصحة، الأمانة العامة للصحة النفسية)';

  @override
  String get helpNowNumber_eg_ncw => 'مكتب شكاوى المرأة (المجلس القومي للمرأة)';

  @override
  String get helpNowNumber_sa_srca => 'الإسعاف (هيئة الهلال الأحمر السعودي)';

  @override
  String get helpNowNumber_sa_moh => 'مركز اتصال وزارة الصحة';

  @override
  String get helpNowNumber_sa_moh_mental => 'الاستشارات النفسية (وزارة الصحة)';

  @override
  String get helpNowNumber_sa_hrsd =>
      'مركز بلاغات العنف الأسري (وزارة الموارد البشرية والتنمية الاجتماعية)';

  @override
  String get helpNowNumber_ae_ambulance => 'الإسعاف';

  @override
  String get helpNowNumber_qa_emergency =>
      'خدمات الطوارئ (الإسعاف، الشرطة، الدفاع المدني)';

  @override
  String get helpNowNumber_qa_mental =>
      'خط المساعدة الوطني للصحة النفسية، الخيار 4 (مؤسسة حمد الطبية)';

  @override
  String get helpNowNumber_kw_emergency => 'خدمات الطوارئ (وزارة الداخلية)';

  @override
  String get helpNowNumber_bh_emergency => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_om_emergency =>
      'خدمات الطوارئ (شرطة عُمان السلطانية)';

  @override
  String get helpNowNumber_om_dv =>
      'خط العنف الأسري (مدرج لدى حكومة سلطنة عُمان)';

  @override
  String get helpNowNumber_jo_emergency => 'خدمات الطوارئ (مديرية الأمن العام)';

  @override
  String get helpNowNumber_jo_ambulance => 'الإسعاف (الدفاع المدني)';

  @override
  String get helpNowNumber_jo_family => 'إدارة حماية الأسرة والأحداث';

  @override
  String get helpNowNumber_lb_redcross => 'الإسعاف (الصليب الأحمر اللبناني)';

  @override
  String get helpNowNumber_lb_lifeline =>
      'خط الدعم النفسي (مدرج لدى وزارة الصحة العامة)';

  @override
  String get helpNowNumber_ma_samu => 'الإنعاش الطبي، SAMU (وزارة الصحة)';

  @override
  String get helpNowNumber_ma_police => 'الشرطة';

  @override
  String get helpNowNumber_gb_999 => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_gb_111 => 'NHS 111، خيار الصحة النفسية';

  @override
  String get helpNowNumber_gb_refuge =>
      'خط المساعدة الوطني للعنف الأسري (Refuge)';

  @override
  String get helpNowNumber_fr_samu => 'الإنعاش الطبي، SAMU';

  @override
  String get helpNowNumber_fr_3114 => 'الرقم الوطني للوقاية من الانتحار';

  @override
  String get helpNowNumber_fr_3919 =>
      'Violences Femmes Info (خط العنف ضد النساء)';

  @override
  String get helpNowNumber_es_112 => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_es_024 =>
      'خط المساعدة للسلوك الانتحاري (وزارة الصحة)';

  @override
  String get helpNowNumber_es_016 =>
      'خط معلومات العنف القائم على النوع الاجتماعي 016 (وزارة المساواة)';

  @override
  String get helpNowNumber_us_911 => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_us_988 => 'خط الأزمات والوقاية من الانتحار (988)';

  @override
  String get helpNowNumber_us_ndvh => 'الخط الوطني للعنف الأسري';

  @override
  String get helpNowNumber_ca_911 => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_ca_988 => 'خط أزمات الانتحار (988)';

  @override
  String get helpNowNumber_mx_911 => 'خدمات الطوارئ';

  @override
  String get helpNowNumber_mx_vida =>
      'Línea de la Vida (اللجنة الوطنية للصحة النفسية)';

  @override
  String get helpNowCountryPrompt => 'اختاري بلدًا لعرض أرقامه';

  @override
  String get helpNowEmergency => 'خدمات الطوارئ';

  @override
  String get helpNowSupport => 'خطوط الدعم';

  @override
  String get helpNowSource => 'المصدر';

  @override
  String get helpNowCall => 'اتصال';

  @override
  String get redFlagsReadGuide => 'اقرئي علامات التحذير في الحمل';

  @override
  String get plusProbeTitle => 'femio Plus · فحص الفوترة (نسخ الاختبار فقط)';

  @override
  String get plusProbeSubtitle =>
      'اضغطي لتسألي Google Play إن كانت الفوترة متاحة على هذا الهاتف. لا يُشترى شيء.';

  @override
  String get plusProbeRunning => 'جارٍ سؤال Google Play…';

  @override
  String get plusProbeAvailable => 'فوترة Play متاحة: نعم';

  @override
  String get plusProbeUnavailable =>
      'فوترة Play متاحة: لا (لا يوجد متجر Play على هذا الجهاز، أو لم يُسجَّل الدخول)';

  @override
  String get plusProbeProductFound => 'المنتج femio_plus موجود في Play Console';

  @override
  String get plusProbeProductMissing =>
      'المنتج femio_plus غير موجود بعد (متوقع حتى يُنشأ في Play Console)';

  @override
  String get adLabel => 'إعلان';

  @override
  String get adsNotice =>
      'تظهر الإعلانات في شاشات الدلائل فقط. لا تطّلع أبدًا على سجلاتكِ، وسيزيلها femio Plus.';
}
