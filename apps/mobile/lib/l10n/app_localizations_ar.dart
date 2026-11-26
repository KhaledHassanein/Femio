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
  String get welcomeTagline => 'صحة المرأة وعافيتها بمساعدة الذكاء الاصطناعي';

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
  String get goalPeriodDesc => 'نطاق لموعد قدومها، وما المعتاد بالنسبة لكِ.';

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
    return 'إذا لم تبدأ دورتكِ بحلول $date، يكون اختبار الحمل المنزلي أكثر موثوقية ابتداءً من ذلك اليوم.';
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
    return 'الحمل مكتمل المدة اعتبارًا من $date';
  }

  @override
  String get pregEstimateNote =>
      'هذه التواريخ تقديرات مبنية على موعد الولادة المتوقّع الذي أدخلتِه. قد يعدّله طبيبكِ بعد فحص السونار.';

  @override
  String get pregRedFlagsHeading => 'بعض الأعراض تحتاج رعاية عاجلة';

  @override
  String get pregRedFlagsBody =>
      'اطلبي الرعاية فورًا إذا كان لديكِ صداع شديد، أو تغيّر في الرؤية، أو ألم في أعلى البطن، أو تورّم في الوجه أو اليدين، أو صعوبة في التنفس، أو نزيف مهبلي، أو إذا قلّت حركة جنينكِ أو توقفت أو تغيّرت. تواصلي مع وحدة الولادة أو خدمات الطوارئ المحلية. وإذا تعذّر الوصول إليهم، توجّهي إلى أقرب قسم طوارئ.';

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
  String get redFlagBleeding => 'نزيف مهبلي';

  @override
  String get redFlagMovements => 'قلة حركة جنينكِ أو توقفها أو تغيّرها';

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
  String get apptFormType => 'نوع الموعد';

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
  String get reminderAppointment => 'تذكير بالموعد';

  @override
  String get reminderAppointmentNote =>
      'إشعار واحد في اليوم السابق لموعد حفظتِه مع تاريخه.';

  @override
  String get notifConsentTitle => 'الإشعارات، فقط إذا أردتِ';

  @override
  String get notifConsentIntro =>
      'يمكن لـ femio أن يرسل لكِ تنبيهات على هذا الهاتف. اختاري ما تودّين تلقّيه. لا يُفعَّل شيء حتى تسمحي بذلك.';

  @override
  String get notifConsentNeutral =>
      'كل إشعار يقول فقط «femio» و«افتحي التطبيق». ولا تظهر أي كلمة عن صحتكِ على شاشة القفل.';

  @override
  String get notifConsentLocal =>
      'تُجدوَل الإشعارات على هاتفكِ نفسه. ولا يُرسَل شيء إلى أي مكان، وليس لدى femio حساب أو خادم ترسلها منه.';

  @override
  String get notifKindMedicine => 'تذكير بالدواء';

  @override
  String get notifKindDigest => 'الملخص الأسبوعي';

  @override
  String get notifComingSoon => 'قريبًا في تحديث';

  @override
  String get notifConsentAllow => 'السماح بالإشعارات';

  @override
  String get notifConsentNotNow => 'ليس الآن';

  @override
  String get notifConsentPickOne => 'فعّلي نوعًا واحدًا على الأقل للمتابعة.';

  @override
  String get notifConsentDeniedTitle => 'الإشعارات متوقفة على هذا الهاتف';

  @override
  String get notifConsentDeniedBody =>
      'لم يسمح هاتفكِ بالإشعارات، لذلك لم يجدول femio أي شيء. لتغيير ذلك، افتحي إعدادات الهاتف ثم التطبيقات ثم femio ثم الإشعارات واسمحي بها. بعدها عودي إلى التذكيرات في إعدادات femio.';

  @override
  String calendarDayLabel(String gregorian, String hijri) {
    return '$gregorian، $hijri';
  }

  @override
  String get navLearn => 'تعلّمي';

  @override
  String get learnTitle => 'تعلّمي';

  @override
  String get learnSub => 'أدلة موثّقة بكلمات بسيطة. محاولة الحمل والحمل أولًا.';

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
      'دوراتكِ متفاوتة أكثر من أن تُحدَّد أيام الخصوبة من تاريخ واحد. تسجيل دوراتكِ واختبارات التبويض وحرارة جسمكِ عند الاستيقاظ يساعدكِ على معرفة هل حدث التبويض لاحقًا.';

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
  String get assistantPrivateNote =>
      'يتم هذا على هاتفك. كلماتك لا تُحفظ ولا تُرسل إلى أي مكان.';

  @override
  String get assistantModelNote =>
      'ساعد في ذلك Gemini Nano، الذكاء الاصطناعي الموجود على هاتفك.';

  @override
  String get sayItButton => 'قوليها بكلماتك';

  @override
  String get sayItTitle => 'بماذا تشعرين؟';

  @override
  String get sayItHint => 'مثلاً: مغص جامد ونزول خفيف وتعبانة جداً';

  @override
  String get sayItAction => 'حوّليها إلى تسجيل';

  @override
  String get sayItNothing =>
      'لم يجد femio شيئًا لتسجيله. جرّبي كلمات أخرى، أو اختاري الأعراض من شاشة التسجيل.';

  @override
  String get sayItFound => 'وجد femio هذه. ألغي اختيار أي شيء غير صحيح.';

  @override
  String get sayItAdd => 'أضيفي إلى تسجيل هذا اليوم';

  @override
  String get sayItAdded => 'تمت الإضافة إلى تسجيلك.';

  @override
  String get sayItDictationHint =>
      'نصيحة: اضغطي على الميكروفون في لوحة المفاتيح لتتحدثي بدل الكتابة.';

  @override
  String get sayItFoundDays =>
      'وجد femio هذه الأيام. ألغي اختيار أي شيء غير صحيح، أو أزيلي يومًا كاملًا. لا يُحفظ شيء حتى تضغطي على الزر أدناه.';

  @override
  String get sayItRemoveDay => 'إزالة هذا اليوم';

  @override
  String sayItSaveCount(int entries, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      entries,
      locale: localeName,
      other: '$entries إدخال',
      many: '$entries إدخالًا',
      few: '$entries إدخالات',
      two: 'إدخالين',
      one: 'إدخالًا واحدًا',
      zero: 'لا إدخالات',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومين',
      one: 'يوم واحد',
      zero: 'لا أيام',
    );
    return 'احفظي $_temp0 في $_temp1';
  }

  @override
  String get sayItFuture =>
      'لا يستطيع femio تسجيل يوم لم يأتِ بعد، لذلك تُرك هذا الجزء من ملاحظتك.';

  @override
  String sayItTooOld(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يومًا',
      few: '$days أيام',
      two: 'يومين',
      one: 'يوم واحد',
      zero: '$days يوم',
    );
    return 'يستطيع femio تسجيل ما حدث خلال آخر $_temp0 فقط، لذلك تُركت الأيام الأقدم في ملاحظتك.';
  }

  @override
  String get safetyCrisisHeading => 'لستِ وحدكِ في هذا';

  @override
  String get safetyCrisisBody =>
      'إذا كنتِ تفكرين في إيذاء نفسكِ، تواصلي مع أحد الآن. صفحة المساعدة فيها أرقام الدعم في بلدكِ.';

  @override
  String get safetyUrgentHeading => 'قد يحتاج هذا إلى رعاية عاجلة';

  @override
  String get safetyUrgentBody =>
      'ألم الصدر أو صعوبة التنفس أو الإغماء أو التشنج تحتاج إلى مساعدة طبية الآن. اتصلي برقم الطوارئ في بلدكِ.';

  @override
  String get safetyBirthControl =>
      'femio ليس وسيلة لمنع الحمل ولا يقدّم نصائح لتجنّب الحمل. يمكن للطبيب أو الصيدلي أو عيادة تنظيم الأسرة مساعدتكِ في اختيار وسيلة.';

  @override
  String get askDiagnosisHeading => 'الطبيب وحده يستطيع أن يحدّد';

  @override
  String get askDiagnosisBody =>
      'femio لا يستطيع أن يحدّد إن كانت لديكِ حالة صحية. الطبيب يستطيع ذلك بعد الحديث معكِ، وبالفحص أو التحاليل إن لزم. هذا ما تقوله المصادر الموثوقة عنها.';

  @override
  String get safetyHeavyBleedingHeading => 'نزيف شديد مع دوخة';

  @override
  String get safetyHeavyBleedingBody =>
      'تقول الكلية الأمريكية لأطباء النساء والتوليد (ACOG): «إذا كنتِ تغيّرين الفوط أو السدادات كل ساعة لأكثر من ساعتين متتاليتين، وتشعرين أيضاً بألم في الصدر وضيق في التنفس ودوار أو دوخة، فاطلبي رعاية طبية طارئة فوراً». (ترجمة femio.) إن كان هذا حالكِ فاتصلي برقم الطوارئ الآن. وإن كان النزيف الشديد يقلقكِ فتحدّثي مع طبيبكِ.';

  @override
  String get safetyPostpartumHeading => 'علامة تحذير بعد الولادة';

  @override
  String get safetyPostpartumBody =>
      'في السنة التي تلي الولادة، تقول حملة Hear Her التابعة لـ CDC: اطلبي رعاية طبية فوراً عند أي علامة تحذير عاجلة، مثل النزيف الشديد أو الحمّى أو صداع لا يزول أو تورّم الساق. اتصلي بطبيبكِ أو قابلتكِ الآن، أو برقم الطوارئ.';

  @override
  String get askTitle => 'اسألي femio';

  @override
  String get askIntro =>
      'اسألي سؤالاً صحياً. يجيب femio فقط من مصادر صحية موثوقة يحملها على هاتفكِ، مثل CDC وMedlinePlus ومكتب صحة المرأة الأمريكي، ويُريكِ مصدر كل جملة.';

  @override
  String get askHint => 'مثلاً: ما الذي يخفف مغص الدورة؟';

  @override
  String get askAction => 'اسألي';

  @override
  String get askWillSend =>
      'هذا هو السؤال الذي سيُرسل بالضبط، مع المصادر العامة:';

  @override
  String get askSend => 'لخّصي بـ Cloud boost';

  @override
  String get askStillPersonal =>
      'ما زال هذا يتحدث عنكِ. احذفي كلمات مثل «أنا» أو «عندي» وأي تفاصيل شخصية.';

  @override
  String get askCloudPrivacy =>
      'يُرسل هذا السؤال والمصادر العامة فقط. لا شيء من تسجيلاتكِ.';

  @override
  String get askSearching => 'يقرأ المصادر الموثوقة…';

  @override
  String get askSourcesTitle => 'المصادر';

  @override
  String get askClinicianLine =>
      'هذه معلومات عامة وليست نصيحة خاصة بكِ. لحالتكِ أنتِ، تحدّثي مع مقدّم الرعاية الصحية لكِ.';

  @override
  String get askRelatedGuides => 'أدلة femio عن هذا';

  @override
  String get askSearchAgain => 'اسألي سؤالاً آخر';

  @override
  String get askAboutYouStays =>
      'سؤالكِ عنكِ، لذلك يبقى على هذا الهاتف. إليكِ المصادر كما هي.';

  @override
  String get askModelFellBack =>
      'لم يستطع الذكاء الاصطناعي كتابة إجابة تذكر مصادرها، فإليكِ المصادر كما هي.';

  @override
  String get askBoostHeading => 'Cloud boost';

  @override
  String get askBoostConfirm =>
      'لا يوجد ذكاء اصطناعي على هذا الهاتف. مع Cloud boost يمكن لذكاء Google السحابي تلخيص هذه المصادر العامة لكِ. راجعي السؤال أولاً.';

  @override
  String get askReadSourcesInstead => 'اقرئي المصادر بدلاً من ذلك';

  @override
  String get askNotCoveredHeading => 'غير مشمول بعد';

  @override
  String get askNotCovered =>
      'مصادر femio الموثوقة لا تجيب عن هذا، لذلك لن يُخمّن femio. جرّبي كلمات أخرى، أو اقرئي الروابط أدناه، أو اسألي مقدّم الرعاية الصحية لكِ.';

  @override
  String askRegistryVersion(String version) {
    return 'مكتبة المصادر الموثوقة $version';
  }

  @override
  String get askAnswerOnPhone =>
      'لخّصه Gemini Nano على هاتفكِ، من المصادر أدناه';

  @override
  String get askAnswerCloud =>
      'لخّصه ذكاء Google السحابي (Cloud boost)، من المصادر أدناه';

  @override
  String get askVerbatimLabel => 'كما هو من المصادر الموثوقة';

  @override
  String get askEnglishNote =>
      'هذه المصادر باللغة الإنجليزية. يعرضها femio كما هي حتى لا يضيع شيء في الترجمة.';

  @override
  String get askReadMore => 'اقرئي المزيد من منظمات موثوقة';

  @override
  String askSourceCopied(String publisher, String date) {
    return '$publisher · نُسخ في $date';
  }

  @override
  String askSourceReviewed(String publisher, String date) {
    return '$publisher · رُوجع في $date';
  }

  @override
  String get visitButton => 'ملخص للزيارة';

  @override
  String get visitTitle => 'ملخص للزيارة';

  @override
  String get visitIntro =>
      'صفحة تعرضينها على مقدّم الرعاية الصحية لكِ، من تسجيلاتكِ أنتِ. تبقى على هاتفكِ إلا إذا شاركتِها أو نسختِها.';

  @override
  String visitCycles(int count, int longest, int shortest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count دورة مسجّلة: من $shortest إلى $longest يوماً',
      many: '$count دورة مسجّلة: من $shortest إلى $longest يوماً',
      few: '$count دورات مسجّلة: من $shortest إلى $longest يوماً',
      two: 'دورتان مسجّلتان: من $shortest إلى $longest يوماً',
      one: 'دورة واحدة مسجّلة: $shortest يوماً',
      zero: 'لا توجد دورة كاملة مسجّلة بعد',
    );
    return '$_temp0';
  }

  @override
  String visitLastPeriod(String date) {
    return 'بدأت آخر دورة في $date';
  }

  @override
  String get visitIrregular => 'الدورات موصوفة بأنها غير منتظمة';

  @override
  String get visitTopTerms => 'الأكثر تسجيلاً في آخر 90 يوماً';

  @override
  String visitDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم',
      many: '$days يوماً',
      few: '$days أيام',
      two: 'يومان',
      one: 'يوم واحد',
    );
    return '$_temp0';
  }

  @override
  String get visitHeavyDays => 'أيام النزول الغزير';

  @override
  String get visitOpkPositive => 'اختبارات تبويض إيجابية';

  @override
  String get visitTemperatureDays => 'أيام مسجّل فيها حرارة الاستيقاظ';

  @override
  String get visitTryingFor => 'محاولة الحمل';

  @override
  String get visitQuestionsTitle => 'أسئلة يمكنكِ طرحها';

  @override
  String get visitCopy => 'انسخي كنص';

  @override
  String get visitCopied => 'تم النسخ. الصقيه في رسالة أو في ملاحظاتكِ.';

  @override
  String get visitQ_cycleSpread => 'أطوال دوراتي تتغير. هل يستحق ذلك الفحص؟';

  @override
  String get visitQ_ttcTests =>
      'بالنظر إلى مدة محاولتي، ما الفحوصات التي تقترحها؟';

  @override
  String get visitQ_ovulation => 'كيف أعرف إن كانت الإباضة تحدث عندي؟';

  @override
  String get visitQ_folicAcid => 'هل يجب أن آخذ حمض الفوليك الآن؟';

  @override
  String get visitQ_painfulPeriods =>
      'ألم الدورة يؤثر على يومي. ما الذي يمكن أن يساعد؟';

  @override
  String get visitQ_heavyPeriods => 'دورتي غزيرة. هل يستحق الأمر تحليل دم؟';

  @override
  String get visitQ_moodCycle =>
      'مزاجي يتغير كثيراً حول موعد الدورة. هل يمكن أن نتحدث عن ذلك؟';

  @override
  String get visitQ_skinHair =>
      'عندي تغيّرات في البشرة أو الشعر مع دورات غير منتظمة. هل يجب فحصها معاً؟';

  @override
  String get visitQ_tiredness => 'أشعر بالتعب كثيراً. هل هناك ما يستحق الفحص؟';

  @override
  String get visitQ_menopause =>
      'هل يمكن أن تكون أعراضي مرتبطة بما قبل انقطاع الطمث، وما خياراتي؟';

  @override
  String get visitQ_pregnancyNext =>
      'ما الذي يجب أن أنتبه له قبل زيارتنا القادمة؟';

  @override
  String get visitQ_pregnancyMovements => 'متى أبدأ في الانتباه لحركات الجنين؟';

  @override
  String get visitQ_anythingElse =>
      'هل في تسجيلاتي شيء تودّ النظر إليه عن قرب؟';

  @override
  String get assistantSettingsTitle => 'المساعد';

  @override
  String get assistantSettingsSub =>
      'الذكاء الاصطناعي على هاتفكِ والمصادر الموثوقة وCloud boost';

  @override
  String get assistantOnDeviceTitle =>
      'الذكاء الاصطناعي على هاتفكِ (Gemini Nano)';

  @override
  String get assistantOnDeviceAvailable =>
      'جاهز. يقرأ ملاحظاتكِ على الهاتف، ولا يُرسل شيئاً.';

  @override
  String get assistantOnDeviceDownloadable => 'يمكن تنزيله على هذا الهاتف.';

  @override
  String get assistantOnDeviceDownloading => 'جارٍ التنزيل…';

  @override
  String get assistantOnDeviceUnavailable =>
      'غير متاح على هذا الهاتف. يستخدم femio قائمة كلماته الخاصة على الهاتف بدلًا منه.';

  @override
  String get assistantDownload => 'تنزيل';

  @override
  String get assistantCloudTitle => 'Cloud boost';

  @override
  String get assistantCloudOn =>
      'مُفعّل. يُستخدم فقط إن لم يكن على الهاتف ذكاء اصطناعي.';

  @override
  String get assistantCloudOff => 'متوقف. كل شيء يتم على هذا الهاتف.';

  @override
  String get assistantHowItWorks =>
      'تبقى تسجيلاتكِ على هاتفكِ. تقرأ قواعد femio ملاحظاتكِ وتسجيلاتكِ، ويساعد Gemini Nano على الهاتف إن كان متاحاً. قواعد السلامة تأتي أولاً دائماً: علامات الخطر تفتح صفحة المساعدة، ولا يقدّم femio نصائح عن تجنّب الحمل. يجيب «اسألي femio» فقط من مصادر صحية موثوقة يحملها التطبيق، ويعرضها مع كل إجابة. Cloud boost متوقف ما لم توافقي عليه؛ وعندها لا يُرسَل إلى Google إلا ما تذكره شاشته.';

  @override
  String get assistantCloudNotBuilt => 'غير متاح في هذه النسخة من التطبيق.';

  @override
  String get boostTitle => 'Cloud boost';

  @override
  String get boostIntro =>
      'بعض الهواتف ليس عليها ذكاء اصطناعي. على هذه الهواتف، يسمح Cloud boost لذكاء Google السحابي بتلخيص المصادر الموثوقة لسؤال توافقين عليه، أو بترتيب نصائحكِ. هو اختياري، ويبقى متوقفاً ما لم توافقي أدناه. وكل ما عداه في femio يعمل من دونه.';

  @override
  String get boostSendsHeading => 'ما قد يُرسل';

  @override
  String get boostStageLabel => 'المرحلة';

  @override
  String boostStage(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'period': 'متابعة الدورة',
      'ttc': 'محاولة الحمل',
      'pregnant': 'حامل',
      'postpartum': 'بعد الولادة',
      'menopause': 'انقطاع الطمث',
      'other': 'غير محدد',
    });
    return '$_temp0';
  }

  @override
  String get boostRegularityLabel => 'انتظام الدورة';

  @override
  String boostRegularity(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'regular': 'منتظمة',
      'variable': 'متغيّرة',
      'unknown': 'غير معروف بعد',
      'notApplicable': 'لا تُتابع الآن',
      'other': 'غير معروف بعد',
    });
    return '$_temp0';
  }

  @override
  String get boostCategoriesLabel => 'أنواع الأعراض المسجّلة في الشهر الماضي';

  @override
  String boostCategory(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'pain': 'ألم',
      'mood': 'مزاج',
      'digestion': 'هضم',
      'sleepAndEnergy': 'نوم وطاقة',
      'skinAndHair': 'بشرة وشعر',
      'hotFlashes': 'هبّات ساخنة',
      'bladder': 'مثانة',
      'other': 'أخرى',
    });
    return '$_temp0';
  }

  @override
  String get boostNone => 'لا شيء';

  @override
  String get boostStreakLabel => 'مدة التسجيل المتواصل';

  @override
  String boostStreak(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'none': 'لا شيء',
      'underAWeek': 'أقل من أسبوع',
      'weeks': 'بضعة أسابيع',
      'overAMonth': 'أكثر من شهر',
      'other': 'لا شيء',
    });
    return '$_temp0';
  }

  @override
  String get boostNeverHeading => 'ما لا يُرسل أبداً';

  @override
  String get boostNever =>
      'ملاحظاتكِ، والتواريخ، والتسجيلات، وأطوال الدورات، واسمكِ، وبريدكِ الإلكتروني، وجهات اتصالكِ، ومعرّف الإعلانات.';

  @override
  String get boostTurnOff => 'أوقفي Cloud boost';

  @override
  String get boostNotNow => 'ليس الآن';

  @override
  String get boostAgreeQuestions =>
      'أوافق على أن يرسل femio سؤالاً عاماً أوافق عليه، سؤالاً واحداً في كل مرة، مع المصادر العامة التي وجدها، ليلخّصها ذكاء Google السحابي. يحذف femio الأرقام والتواريخ والأسماء وبيانات الاتصال أولاً، وأرى النص كما هو قبل إرساله.';

  @override
  String get boostAgreeTips =>
      'أوافق على أن يرسل femio هذه الحقائق العامة الأربع عن صحتي، كما تظهر هنا تماماً، ليرتّب ذكاء Google السحابي نصائحي. يحدث ذلك في الخلفية ما دام Cloud boost مفعّلاً.';

  @override
  String get boostPurposeQuestions => 'الأسئلة العامة';

  @override
  String get boostPurposeTips => 'النصائح من أربع حقائق عامة';

  @override
  String get boostWhoHeading => 'من يستلمها، وأين';

  @override
  String get boostWho =>
      'تعالجها Google لصالح femio عبر Firebase AI Logic (واجهة Gemini Developer API، الفئة المدفوعة). وقد تعالجها Google في الولايات المتحدة أو في دول أخرى لديها فيها خوادم، وفق شروطها لمعالجة البيانات. ويحدّد femio (KM Digital Labs، القاهرة، مصر) ما يُرسَل، وهو المسؤول عنه.';

  @override
  String get boostKeptHeading => 'كم تُحفظ';

  @override
  String get boostKept =>
      'ليس لدى femio خادم، ولا يحتفظ بشيء منها. وبموجب الشروط المدفوعة التي يستخدمها femio، لا تستخدمها Google لتحسين منتجاتها. وتحتفظ بها Google مدة أقصاها 55 يوماً لكشف إساءة الاستخدام، وقد يراجع موظفون في Google المحتوى الذي تعلّمه أنظمتها على أنه إساءة استخدام.';

  @override
  String get boostAlsoSeen =>
      'وكأي اتصال بالإنترنت، ترى Google أيضاً عنوان الإنترنت لهاتفكِ، وفحصاً من Google Play يؤكد أن الطلب صادر من تطبيق femio الحقيقي.';

  @override
  String get boostChoiceHeading => 'اختياركِ';

  @override
  String get boostChoice =>
      'الموافقة اختيارية، ويمكنكِ الموافقة على استخدام واحد دون الآخر. ويمكنكِ إيقاف Cloud boost في أي وقت، هنا أو في الإعدادات › المساعد، بالسهولة نفسها التي فعّلتِه بها. ويسألكِ كل هاتف من جديد: النسخة الاحتياطية المستعادة لا تنقل موافقتكِ.';

  @override
  String get boostReadNotice => 'اقرئي إشعار الخصوصية';

  @override
  String get boostExplicit =>
      'هذه الحقائق والأسئلة تخص صحتكِ. بوضع علامة في خانة والضغط على «أوافق»، تمنحين موافقتكِ الصريحة على ذلك الاستخدام وحده. ويحتفظ femio على هذا الهاتف بسجل مؤرّخ لاختياركِ، يمكنكِ رؤيته هنا.';

  @override
  String get boostAgree => 'أوافق';

  @override
  String get boostReceiptHeading => 'موافقتكِ';

  @override
  String boostReceipt(String date, String purposes) {
    return 'وافقتِ في $date على: $purposes.';
  }

  @override
  String get boostWithdrawEffect =>
      'إيقافه يمنع إرسال أي شيء جديد، لكنه لا يستعيد ما أُرسل من قبل.';

  @override
  String get tip_trackDatesHelps =>
      'تسجيل مواعيد دورتك الشهرية في التطبيق يساعدك على رؤية نمطك الخاص، ويمنح الطبيب أو الطبيبة معلومات واضحة.';

  @override
  String get tip_periodLongerThanSeven =>
      'الدورة الشهرية التي تستمر أكثر من 7 أيام تستحق أن تخبري بها الطبيب أو الطبيبة.';

  @override
  String get tip_bleedingBetweenPeriods =>
      'النزف بين الدورات الشهرية يستحق أن تخبري به الطبيب أو الطبيبة ليُبحث عن سببه.';

  @override
  String get tip_irregularCheckIn =>
      'تُسمّى الدورات التي تقل عن 21 يومًا أو تزيد على 35 يومًا دورات غير منتظمة. أخبري الطبيب أو الطبيبة بذلك ليراجع مواعيدك معك.';

  @override
  String get tip_stoppedThreeMonths =>
      'انقطاع الدورة الشهرية أكثر من ثلاثة أشهر دون سبب واضح يستحق فحص الطبيب أو الطبيبة، مهما كان عمرك.';

  @override
  String get tip_irregularWithOtherSigns =>
      'الدورة غير المنتظمة مع تغيّرات أخرى، مثل زيادة الوزن، أو نمو شعر زائد على الوجه، أو جفاف الجلد أو دهنيته، تستحق أن تخبري بها الطبيب أو الطبيبة.';

  @override
  String get tip_periodPainSeeClinician =>
      'ألم الدورة الشهرية الذي يمنعك من ممارسة أنشطتك اليومية المعتادة سبب لمراجعة الطبيب أو الطبيبة.';

  @override
  String get tip_severePainUrgent =>
      'إذا كان ألم الحوض أو الدورة شديدًا أو أسوأ من المعتاد ولم تُخفّفه المسكّنات، فاطلبي مشورة طبية عاجلة.';

  @override
  String get tip_symptomDiaryBeforeVisit =>
      'قبل زيارة بسبب مشكلات الدورة الشهرية، يمنح سجلّ أعراضك على مدار الدورة كلها الطبيبَ أو الطبيبة صورة مفصّلة عمّا يحدث ومتى.';

  @override
  String get tip_heavyOrTired =>
      'الدورات التي تعيقك عن أنشطتك اليومية أو تتركك متعبة أو ضيقة النَّفَس كثيرًا قد تكون علامة على غزارة الطمث. يستطيع الطبيب أو الطبيبة مساعدتك.';

  @override
  String get tip_pmsDiary =>
      'تسجيل أعراضك يوميًا لدورتين على الأقل يساعد الطبيب أو الطبيبة على معرفة ما إذا كانت ترتبط بدورتك الشهرية.';

  @override
  String get tip_headachesAroundPeriod =>
      'الصداع النصفي الذي يتكرر قبل الدورة الشهرية أو خلالها يستحق أن تخبري به الطبيب أو الطبيبة. ويساعد تسجيله بجانب مواعيد دورتكِ.';

  @override
  String get tip_urineInfectionSeeClinician =>
      'إذا ظننتِ أنك مصابة بالتهاب في المسالك البولية فمن المهم مراجعة الطبيب أو الطبيبة. يمكن لفحص البول أن يوضّح ذلك.';

  @override
  String get tip_leakingUrineTellClinician =>
      'إذا كنتِ تعانين من تسرّب البول فمن المفيد إخبار الطبيب أو الطبيبة، أيًّا كان نوعه أو سببه.';

  @override
  String get tip_cervicalScreeningTip =>
      'توصي منظمة الصحة العالمية بفحص عنق الرحم كل 5 إلى 10 سنوات ابتداءً من سن 30، وتختلف البرامج من بلد لآخر. اسألي عيادتكِ إن كان موعد فحصكِ قد حان.';

  @override
  String get tip_ttcOneYear =>
      'إذا مرّت سنة وأنتما تحاولان دون حدوث حمل، فمن الأفضل مراجعة الطبيب أو الطبيبة لفحص الأسباب الشائعة.';

  @override
  String get tip_ttcAgeSixMonths =>
      'في سن 35 فما فوق يُنصح بمراجعة الطبيب أو الطبيبة بعد ستة أشهر من المحاولة، لا بعد اثني عشر شهرًا.';

  @override
  String get tip_ttcIrregularNoWait =>
      'مع الدورات غير المنتظمة أو غيابها، من المفيد التحدث إلى الطبيب أو الطبيبة بشأن محاولة الحمل دون انتظار سنة كاملة.';

  @override
  String get tip_regularSexTakesTime =>
      'تحمل أغلب الأزواج الذين تقل عمر الزوجة لديهم عن 40 سنة خلال سنة من الجماع المنتظم كل 2 إلى 3 أيام. وقد يستغرق الأمر وقتًا.';

  @override
  String get tip_testingTooEarly =>
      'قد يعطي الفحص المبكر جدًا نتيجة سلبية كاذبة. اتبعي تعليمات الاختبار نفسه.';

  @override
  String get tip_folicAcidBeforePregnancy =>
      'حمض الفوليك، وهو أحد فيتامينات ب، يُنصح به قبل الحمل بشهر على الأقل. اسألي الطبيب أو الطبيبة عن أفضل طريقة للحصول على ما يكفيك.';

  @override
  String get tip_talkBeforeTrying =>
      'من الجيد التحدث إلى الطبيب أو الطبيبة قبل محاولة الحمل، فيمكنه مساعدتك على تهيئة جسمك.';

  @override
  String get tip_tryingIsStressful =>
      'قد تكون محاولة الحمل مُجهِدة. قد تساعدك الاستشارة النفسية ومجموعات الدعم على التأقلم، ويمكنك سؤال الطبيب أو الطبيبة عنها.';

  @override
  String get tip_movementsChangeCallNow =>
      'إذا قلّت حركة طفلك عن المعتاد أو تغيّر نمطها المعتاد، فاتصلي بالقابلة أو وحدة الولادة فورًا، حتى في منتصف الليل.';

  @override
  String get tip_firstMovementsBy24 =>
      'يُفترض أن تشعري بحركة طفلك بين الأسبوع 16 والأسبوع 24. إذا لم تشعري بأي حركة بحلول الأسبوع 24 فأخبري القابلة.';

  @override
  String get tip_preeclampsiaSigns =>
      'الصداع الشديد الذي لا تُخفّفه المسكّنات، أو مشكلات الرؤية، أو الألم تحت الأضلاع، أو التورّم المفاجئ تحتاج إلى فحص فوري. اتصلي بوحدة الولادة.';

  @override
  String get tip_antenatalChecksMatter =>
      'تكشف فحوص ضغط الدم والبول في زيارات متابعة الحمل تغيّرات لا تشعرين بها، لذا حاولي ألا تفوّتي أي موعد.';

  @override
  String get tip_screeningVersusDiagnostic =>
      'يُعرض على كل امرأة حامل نوعان من الفحوص: فحوص مسح تُظهر الاحتمال، وفحوص متابعة تعطي إجابة أوضح. اسألي أيها يناسبكِ.';

  @override
  String get tip_glucoseScreening =>
      'ينبغي إجراء فحص الكشف عن سكري الحمل لكل امرأة حامل. اسألي القابلة أو الطبيب عن موعد فحصك.';

  @override
  String get tip_rhBloodGroup =>
      'يُظهر فحص دم بسيط فصيلة دمك والعامل الريصي، وغالبًا في أول زيارة لمتابعة الحمل. اسألي عن نتيجتك وهل تؤثر في رعايتك.';

  @override
  String get tip_mainScanBetween18And21 =>
      'يُجرى عادةً فحص تفصيلي بالموجات فوق الصوتية بين الأسبوع 18 والأسبوع 21. يتحقق من نمو طفلك ويبحث عن حالات معيّنة.';

  @override
  String get tip_severeSicknessTellEarly =>
      'إذا كنتِ تتقيئين كثيراً ولا تستطيعين الاحتفاظ بالطعام، أخبري القابلة أو الطبيب في أسرع وقت، ليساعدوكِ على الاحتفاظ بالسوائل.';

  @override
  String get tip_itchTellMidwife =>
      'الحكّة شائعة في الحمل، لكنها قد تكون أول علامة على حالة في الكبد تُسمّى الركود الصفراوي الحملي. أخبري القابلة أو الطبيب بها ليجري فحصها.';

  @override
  String get tip_pretermLabourSigns =>
      'من علامات الولادة المبكرة انقباضات كل 10 دقائق أو أكثر تقاربًا، أو تسرّب سائل أو نزف، أو ضغط في الحوض، أو ألم ظهر خفيف في أسفله. اتصلي بالقابلة أو الطبيب أو وحدة الولادة.';

  @override
  String get tip_tirednessInPregnancy =>
      'للتعب في الحمل أسباب كثيرة، منها فقر الدم. أخبري القابلة أو الطبيب إذا استمر التعب.';

  @override
  String get tip_lowMoodPerinatal =>
      'الشعور بالحزن شائع أثناء الحمل وبعد الولادة، والدعم متاح. أخبري القابلة أو الطبيب حتى لو كانت لديكِ بعض العلامات فقط.';

  @override
  String get tip_anxietyInPregnancy =>
      'يمكن في كثير من الأحيان تخفيف القلق أثناء الحمل بالعلاج الحواري. أخبري القابلة أو الطبيب بما تشعرين به فعلًا.';

  @override
  String get tip_warningSignsPregnancyAndYear =>
      'بعض علامات الخطر تستدعي رعاية فورية أثناء الحمل وخلال سنة بعد الولادة: صداع لا يزول، أو تغيّر في الرؤية، أو حمّى، أو صعوبة في التنفس، أو ألم شديد في البطن.';

  @override
  String get tip_postnatalCheckSixToEight =>
      'يهدف فحص ما بعد الولادة بعد نحو 6 إلى 8 أسابيع إلى التأكد من أنك بخير وتتعافين جيدًا. دوّني أسئلتك لتأخذيها معك.';

  @override
  String get tip_painfulFeedsGetHelp =>
      'إذا كنتِ تؤجّلين الرضعات لأن الرضاعة مؤلمة، فاطلبي مساعدة استشارية رضاعة.';

  @override
  String get tip_tirednessAfterBirthThyroid =>
      'للتعب بعد الولادة أسباب كثيرة. يصيب التهاب الغدة الدرقية نحو امرأة من كل 20 في السنة الأولى بعد الولادة، لذا أخبري الطبيب أو الطبيبة إن استمر التعب.';

  @override
  String get tip_bleedingUpToSixWeeks =>
      'قد يستمر التبقّع أو النزف الشبيه بالدورة الشهرية، بشكل متقطع، حتى ستة أسابيع بعد الولادة. أخبري الطبيب أو الطبيبة إذا كنتِ قلقة.';

  @override
  String get tip_babyBluesPassing =>
      'الشعور بالحزن أو القلق أو التوتر لبضعة أيام بعد الولادة شائع جدًا وعادةً يزول خلال أسبوعين. إذا استمر أطول فأخبري الطبيب أو الطبيبة.';

  @override
  String get tip_periodChangesFirstSign =>
      'تغيّر الدورة الشهرية عادةً من أولى علامات مرحلة ما قبل انقطاع الطمث. قد تأتي أكثر أو أقل تكرارًا، وقد تصبح أغزر أو أخف.';

  @override
  String get tip_twelveMonthsMeansMenopause =>
      'يُقصد بانقطاع الطمث مرور 12 شهرًا بلا دورة. وفي السنوات التي تسبقه كثيرًا ما تتفاوت الدورات بفواصل أطول أو أقصر.';

  @override
  String get tip_bleedingAfterMenopause =>
      'النزف بعد انقطاع الطمث، أي بعد 12 شهرًا بلا دورة، من المهم إخبار الطبيب أو الطبيبة به ليُعرف سببه.';

  @override
  String get tip_hotFlushesTalkOptions =>
      'إذا لم تكفِ تغييرات نمط الحياة لتخفيف الهبّات الساخنة، فتواصلي مع الطبيب أو الطبيبة. سيناقش معك أعراضك وتاريخك الصحي وتفضيلاتك.';

  @override
  String get tip_boneStrengthMenopause =>
      'فقدان كثافة العظام أكثر احتمالًا في فترة انقطاع الطمث. اسألي الطبيب أو الطبيبة عن صحة العظام وما يناسبك.';

  @override
  String get tip_drynessManyTreatments =>
      'هناك علاجات كثيرة لجفاف المهبل. من المفيد سؤال الطبيب أو الطبيبة عمّا قد يناسبك.';

  @override
  String get tip_heartbeatAroundMenopause =>
      'قد يكون تسارع نبضات القلب أو الإحساس بها جزءًا من مرحلة ما قبل انقطاع الطمث وانقطاعه. دوّني متى يحدث وأخبري الطبيب أو الطبيبة.';

  @override
  String get tip_lowMoodMenopause =>
      'قد يكون انخفاض المزاج والقلق جزءًا من مرحلة انقطاع الطمث. إذا صعُب التعامل معهما فتحدثي إلى الطبيب أو الطبيبة.';

  @override
  String get visitQ_periodsStoppedChecks =>
      'أصبحت دورتي الشهرية متباعدة جدًا أو توقفت. ما الفحوصات التي يمكن أن تكشف السبب؟';

  @override
  String get visitQ_irregularCauses =>
      'ما الذي قد يفسّر عدم انتظام دوراتي، وهل ستفيد بعض الفحوصات أو الأشعة؟';

  @override
  String get visitQ_irregularAcneChecks =>
      'دورتي غير منتظمة ولديّ حب شباب. ما الفحوصات التي يمكن أن تبحث عن السبب؟';

  @override
  String get visitQ_painCauseChecks =>
      'ألم دورتي الشهرية يعطّل أيامي باستمرار. ما الفحوصات التي يمكن أن تكشف السبب؟';

  @override
  String get visitQ_heavyAndTiredBloodTest =>
      'قد تكون دورتي غزيرة وأشعر بالتعب كثيرًا. هل أحتاج إلى فحوصات دم، مثل فحص الحديد؟';

  @override
  String get visitQ_diaryReviewCycle =>
      'هل يمكننا مراجعة سجلّ أعراضي لنرى إن كانت ترتبط بدورتي الشهرية؟';

  @override
  String get visitQ_headacheDiaryReview =>
      'يأتيني الصداع النصفي كثيرًا حول موعد دورتي. هل يمكننا النظر في سجلّي معًا؟';

  @override
  String get visitQ_cervicalScreeningDue =>
      'هل فحص عنق الرحم الدوري لديّ محدّث، وأي اختبار تستخدمه عيادتكم؟';

  @override
  String get visitQ_checksForCouple =>
      'ما فحوصات الخصوبة التي تقترحونها لي، ولشريك إن كان لديّ؟';

  @override
  String get visitQ_ttcOverThirtyFiveSooner =>
      'عمري 35 سنة فأكثر وأحاول منذ نحو ستة أشهر أو أكثر. هل أبدأ فحوصات الخصوبة الآن؟';

  @override
  String get visitQ_irregularTryingNow =>
      'دوراتي غير منتظمة وأحاول الحمل. هل نتحدّث عن المساعدة الآن بدل انتظار سنة؟';

  @override
  String get visitQ_preconceptionReview =>
      'نخطط لحمل. هل هناك شيء في صحتي أو أدويتي يجب مراجعته أولًا؟';

  @override
  String get visitQ_ttcSupportOptions =>
      'محاولة الحمل تثقل عليّ. أين أجد استشارة نفسية أو دعمًا؟';

  @override
  String get visitQ_pregnancyTestsOffered =>
      'ما فحوص المسح وفحوص المتابعة المعروضة في حملي، وماذا يخبرني كل منها؟';

  @override
  String get visitQ_glucoseTestWhen =>
      'متى سيُجرى لي فحص سكري الحمل، وهل يمكن أن يكون أبكر في حالتي؟';

  @override
  String get visitQ_movementsCallWho =>
      'بمن أتصل إذا تغيّرت حركة طفلي، بما في ذلك ليلًا؟';

  @override
  String get visitQ_sameDayWarningSigns =>
      'ما العلامات التي تستدعي أن أتصل بوحدة الولادة في اليوم نفسه؟';

  @override
  String get visitQ_rhFactorChecked =>
      'هل فُحصت فصيلة دمي والعامل الريصي، وهل يغيّر ذلك شيئًا في رعايتي؟';

  @override
  String get visitQ_pregnancyLowMoodSupport =>
      'أشعر بالحزن أو القلق الشديد منذ مدة. ما الدعم المتاح لي؟';

  @override
  String get visitQ_severeSicknessHelp =>
      'الغثيان والقيء يصعّبان عليّ الاحتفاظ بالطعام والشراب. ما المساعدة المتاحة؟';

  @override
  String get visitQ_itchBloodTests =>
      'أعاني من حكّة في الحمل. هل أحتاج إلى فحوصات دم لفحص الكبد؟';

  @override
  String get visitQ_pretermSignsPlan =>
      'ما علامات الولادة المبكرة التي تستدعي أن أتصل أو أحضر، وإلى أين أذهب خارج ساعات العمل؟';

  @override
  String get visitQ_postnatalCheckTalk =>
      'هل يمكننا مراجعة كيف أتعافى، بما في ذلك النزف والألم والمزاج وتغيّرات المثانة؟';

  @override
  String get visitQ_postnatalMoodHelp =>
      'أشعر بالحزن أو القلق منذ الولادة. ما المساعدة المتاحة؟';

  @override
  String get visitQ_latchCheck =>
      'الرضاعة مؤلمة. هل يمكن لأحد أن يراقب رضعة ويتحقق من كيفية التقام طفلي للثدي؟';

  @override
  String get visitQ_warningSignsYearAfter =>
      'ما الأعراض في السنة التي تلي الولادة التي تستدعي طلب الرعاية فورًا؟';

  @override
  String get visitQ_thyroidAfterBirth =>
      'أشعر بتعب شديد منذ الولادة. هل يُفحص أداء الغدة الدرقية بتحليل دم؟';

  @override
  String get visitQ_urineLeaksHelp =>
      'يتسرّب مني البول. ما الذي يمكن أن يساعد، وهل تناسبني تمارين قاع الحوض؟';

  @override
  String get visitQ_hotFlushOptions =>
      'الهبّات الساخنة أو التعرّق الليلي تؤثر في أيامي. ما الخيارات التي يمكن أن نناقشها؟';

  @override
  String get visitQ_changedBleedingChecks =>
      'تغيّر نمط نزفي. ما الفحوصات التي تستحق الإجراء؟';

  @override
  String get visitQ_bleedingAfterMenopauseChecks =>
      'حدث لديّ نزف أو تبقّع في هذه المرحلة. ما الفحوصات التي أحتاجها، وخلال كم من الوقت؟';

  @override
  String get visitQ_boneAndHeartHealth =>
      'ماذا يمكنني أن أفعل لحماية صحة عظامي وقلبي في هذه المرحلة؟';

  @override
  String get visitQ_drynessWhatHelps =>
      'أعاني من جفاف أو انزعاج في المهبل. ما الذي يمكن أن يساعد، وما الذي يحتاج إلى فحص؟';

  @override
  String get visitQ_urineTestAgain =>
      'أعراض البول تعود إليّ باستمرار. هل أحتاج إلى فحص بول، وكيف نجد السبب؟';

  @override
  String get visitQ_thyroidCheckIrregular =>
      'دورتي غير منتظمة وشعري يتساقط. هل يجب فحص الغدة الدرقية بتحليل دم؟';

  @override
  String get tipsTitle => 'لكِ';

  @override
  String tipsSource(String publisher) {
    return 'المصدر: $publisher';
  }

  @override
  String get tipsChosenOnPhone =>
      'اختيرت على هاتفكِ من تسجيلاتكِ. كل نصيحة جملة مُراجعة مع مصدرها.';

  @override
  String get tipsOrderedCloud => 'رُتّبت بـ Cloud boost، من معلومات عامة فقط.';

  @override
  String get legendPossible => 'دورة محتملة (ثقة منخفضة)';

  @override
  String get confidenceLowShort => 'ثقة منخفضة';

  @override
  String get upcomingPeriodsTitle => 'الدورات القادمة';

  @override
  String get upcomingPeriodsWider =>
      'كل دورة لاحقة نطاقها أوسع: كلما ابتعد الموعد قلّ اليقين.';

  @override
  String get upcomingPeriodsOnlyNext =>
      'تظهر الدورة القادمة فقط: دوراتك المسجّلة تتفاوت كثيرًا، أو ما زالت قليلة، فلا يمكن التقدير لأبعد من ذلك.';

  @override
  String get todayUrgentBody =>
      'إذا شعرتِ بشيء شديد أو مفاجئ، اطلبي الرعاية الآن. أرقام الطوارئ في بلدك على بُعد لمسة واحدة.';

  @override
  String get toolsTitle => 'الحاسبات';

  @override
  String get toolsSub =>
      'تقدّم هذه الحاسبات تقديرات عامة للتعلّم والتخطيط، وليست نصيحة طبية. تحدّثي مع طبيبتكِ حول صحتكِ.';

  @override
  String get toolDueTitle => 'حاسبة موعد الولادة';

  @override
  String get toolDueDesc => 'من آخر دورة أو الإخصاب أو نقل الأجنة أو السونار.';

  @override
  String get toolCalTitle => 'تقويم الحمل';

  @override
  String get toolCalDesc => 'تواريخ كل أسبوع من الحمل، مع دليل كل أسبوع.';

  @override
  String get toolGainTitle => 'زيادة الوزن في الحمل';

  @override
  String get toolGainDesc => 'النطاق المرجعي حسب مؤشر كتلة جسمكِ قبل الحمل.';

  @override
  String get toolDueMethodLabel => 'كيف تعرفين التاريخ؟';

  @override
  String get toolDueMethodLmp => 'آخر دورة';

  @override
  String get toolDueMethodConception => 'الإخصاب';

  @override
  String get toolDueMethodTransfer => 'نقل الأجنة';

  @override
  String get toolDueMethodScan => 'سونار تحديد العمر';

  @override
  String get toolEmbryoLabel => 'عمر الجنين عند النقل';

  @override
  String get toolEmbryo3 => 'اليوم الثالث';

  @override
  String get toolEmbryo5 => 'اليوم الخامس';

  @override
  String get toolPromptLmp => 'اضغطي على أول يوم في آخر دورة لكِ';

  @override
  String get toolPromptConception => 'اضغطي على يوم الإخصاب';

  @override
  String get toolPromptTransfer => 'اضغطي على يوم نقل الأجنة';

  @override
  String get toolPromptScan => 'اضغطي على يوم السونار';

  @override
  String get toolCycleLabel => 'طول الدورة';

  @override
  String toolDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم',
      many: '$count يومًا',
      few: '$count أيام',
      two: 'يومان',
      one: 'يوم واحد',
      zero: '$count يوم',
    );
    return '$_temp0';
  }

  @override
  String get toolScanWeeksLabel => 'الأسابيع في تقرير السونار';

  @override
  String get toolScanDaysLabel => 'الأيام الزائدة في التقرير';

  @override
  String toolWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أسبوع',
      many: '$count أسبوعًا',
      few: '$count أسابيع',
      two: 'أسبوعان',
      one: 'أسبوع واحد',
      zero: '$count أسبوع',
    );
    return '$_temp0';
  }

  @override
  String toolTermWindow(String start, String end) {
    return 'يصل معظم المواليد بين $start و$end.';
  }

  @override
  String get toolScanNote =>
      'تُستخدم الأسابيع والأيام كما وردت في تقرير السونار. إذا أعطتكِ طبيبتكِ موعدًا للولادة فاعتمدي موعدها.';

  @override
  String get toolEstimateNote =>
      'هذه التواريخ تقديرات مبنية على التاريخ الذي أدخلتِه. كل جسم مختلف.';

  @override
  String get toolClinicianAdjust => 'قد تعدّل طبيبتكِ الموعد بعد السونار.';

  @override
  String get toolCalMethodLabel => 'أي تاريخ تعرفين؟';

  @override
  String get toolCalMethodEdd => 'موعد الولادة';

  @override
  String get toolCalMethodLmp => 'آخر دورة';

  @override
  String get toolCalPromptEdd => 'اضغطي على موعد ولادتكِ المتوقع';

  @override
  String get toolCalEyebrow => 'حملكِ أسبوعًا بأسبوع';

  @override
  String toolCalTrimesterLine(String second, String third) {
    return 'الثلث الثاني من $second، والثلث الثالث من $third.';
  }

  @override
  String toolCalWeek(String week) {
    return 'الأسبوع $week';
  }

  @override
  String get toolCalCurrent => 'هذا الأسبوع';

  @override
  String toolCalReadGuide(String week) {
    return 'اقرئي دليل الأسبوع $week';
  }

  @override
  String get toolGainIntro =>
      'أدخلي وزنكِ قبل الحمل وطولكِ لتري النطاق المرجعي لإجمالي زيادة الوزن طوال الحمل، حسب معهد الطب الأمريكي (2009)، دون حفظ أي بيانات.';

  @override
  String get toolGainWeight => 'الوزن قبل الحمل (كغ)';

  @override
  String get toolGainHeight => 'الطول (سم)';

  @override
  String get toolGainBabiesLabel => 'كم عدد الأجنّة؟';

  @override
  String get toolGainBabiesOne => 'جنين واحد';

  @override
  String get toolGainBabiesTwo => 'توأمان';

  @override
  String get toolGainBabiesMore => 'ثلاثة أو أكثر';

  @override
  String toolGainBmiLine(String value, String band) {
    return 'مؤشر كتلة الجسم قبل الحمل: $value ($band)';
  }

  @override
  String get toolBandUnderweight => 'نقص الوزن';

  @override
  String get toolBandNormal => 'النطاق الصحي';

  @override
  String get toolBandOverweight => 'زيادة الوزن';

  @override
  String get toolBandObese => 'السمنة';

  @override
  String get toolGainEyebrow => 'النطاق المرجعي لإجمالي الزيادة طوال الحمل';

  @override
  String toolGainRangeKg(String low, String high) {
    return 'من $low إلى $high كغ';
  }

  @override
  String toolGainRangeLb(String low, String high) {
    return 'من $low إلى $high رطل';
  }

  @override
  String toolGainOtherUnit(String range) {
    return 'أي $range.';
  }

  @override
  String get toolGainNoRangeTwins =>
      'لا يحدّد معهد الطب الأمريكي نطاقًا للتوأم إذا كان مؤشر كتلة الجسم قبل الحمل أقل من 18.5. ستنصحكِ طبيبتكِ.';

  @override
  String get toolGainNoRangeMultiples =>
      'لا يحدّد معهد الطب الأمريكي نطاقًا لثلاثة أجنّة أو أكثر. ستنصحكِ طبيبتكِ.';

  @override
  String get toolGainNote =>
      'هذا نطاق مرجعي لفئة مؤشر كتلة جسمكِ قبل الحمل، وليس هدفًا ولا حكمًا. وقد تقترح طبيبتكِ نطاقًا مختلفًا لكِ.';

  @override
  String get toolGainSource =>
      'المصدر: معهد الطب الأمريكي (2009)، «زيادة الوزن أثناء الحمل»؛ وتعتمد المراكز الأمريكية لمكافحة الأمراض (CDC) والكلية الأمريكية لأطباء النساء والتوليد (ACOG) النطاقات نفسها.';

  @override
  String toolGainOutOfRange(
    String minW,
    String maxW,
    String minH,
    String maxH,
  ) {
    return 'أدخلي وزنًا من $minW إلى $maxW كغ وطولًا من $minH إلى $maxH سم.';
  }

  @override
  String get toolNothingSaved => 'لا يُحفظ شيء مما تُدخلينه هنا.';

  @override
  String get updateBannerBody => 'إصدار جديد من femio جاهز.';

  @override
  String get updateBannerAction => 'تحديث';

  @override
  String get leaveTitle => 'ما الذي قد يغادر هذا الهاتف';

  @override
  String get leaveIntro =>
      'تبقى سجلاتكِ على هذا الهاتف. هذه هي المرات الوحيدة التي يستخدم فيها femio، أو خدمات Google التي يعتمد عليها، الإنترنت.';

  @override
  String get leaveBoostOff => 'متوقّف';

  @override
  String leaveBoostOn(String purposes) {
    return 'مفعّل لـ: $purposes';
  }

  @override
  String get leaveBoostBody =>
      'فقط إن وافقتِ: يُرسَل سؤال عام توافقين عليه، أو أربع معلومات عامة، إلى ذكاء Google الاصطناعي السحابي. ويتحقق Google Play أيضًا من أن الطلب صادر عن تطبيق femio الحقيقي.';

  @override
  String get leaveModelHeading => 'نموذج الذكاء الاصطناعي على الهاتف';

  @override
  String get leaveModelBody =>
      'إذا ضغطتِ على تنزيل، تنزّل خدمة الذكاء الاصطناعي في Android (‏AICore، تديرها Google) نموذج Gemini Nano وتحدّثه. وقد يرسل برنامج Google للذكاء الاصطناعي أيضًا معلومات تقنية إلى Google، مثل الأخطاء والأداء. لا يضيف femio إليها أيًّا من سجلاتكِ.';

  @override
  String get leavePlayHeading => 'Google Play';

  @override
  String get leavePlayBody =>
      'يثبّت Google Play تطبيق femio ويحدّثه، وقد يعرض طلب التقييم الخاص به، ويتولى مدفوعات femio Plus. ولا يُطلعنا إلا على إجماليات، مثل عدد مرات التثبيت والأعطال. لا يرسل femio إلى Google Play شيئًا من بياناتكِ.';

  @override
  String get leaveBackupHeading => 'نسختكِ الاحتياطية';

  @override
  String get leaveBackupBody =>
      'لا تذهب النسخة الاحتياطية إلا إلى حيث تختارين حفظها، مقفلة بعبارة المرور الخاصة بكِ.';

  @override
  String get leaveLinksHeading => 'الروابط التي تفتحينها';

  @override
  String get leaveLinksBody =>
      'تُفتح المصادر والصفحات التي تختارينها في متصفحكِ، الذي يزور ذلك الموقع.';

  @override
  String get leaveNever =>
      'لا يغادر أي شيء آخر. لا إعلانات في femio، ولا تحليلات، ولا أدوات تتبّع، ولا حساب.';

  @override
  String get leaveSettingsSub => 'كل طريقة يصل بها أي شيء إلى الإنترنت';

  @override
  String get assistantMasterTitle => 'استخدام المساعد';

  @override
  String get assistantMasterOff =>
      'متوقّف: يجيب femio من قواعده وأدلته فقط. لا يعمل أي ذكاء اصطناعي، لا على الهاتف ولا في السحابة.';

  @override
  String get assistantMasterOn =>
      'مفعّل: يضيف الذكاء الاصطناعي شروحًا بجانب إجابات femio نفسها. وكل شيء يعمل بدونه.';

  @override
  String get aiSeesTitle => 'ما الذي يراه الذكاء الاصطناعي';

  @override
  String get aiSeesSub => 'كل ميزة ذكاء اصطناعي، وأين تعمل، وما الذي تتلقاه';

  @override
  String get aiSeesIntro =>
      'لا يرى الذكاء الاصطناعي سجلكِ كاملًا أبدًا. تتلقى كل ميزة العناصر المذكورة تحتها فقط، وتجيب قواعد السلامة في femio أولًا دائمًا.';

  @override
  String get aiSeesOff => 'المساعد متوقّف، لذا لا تعمل أيٌّ من هذه الميزات.';

  @override
  String get aiUseAskInCloud => 'اسألي femio مع Cloud boost';

  @override
  String get aiUseTips => 'نصائح لكِ';

  @override
  String get aiWherePhone => 'يعمل على هذا الهاتف فقط';

  @override
  String get aiWhereHybrid =>
      'على هذا الهاتف، أو في سحابة Google فقط إن وافقتِ على Cloud boost';

  @override
  String get aiWriteNone => 'لا يغيّر سجلكِ أبدًا';

  @override
  String get aiWriteDraft =>
      'يقترح مسودة؛ لا يُحفظ شيء حتى تراجعيها وتضغطي على حفظ';

  @override
  String get aiSeesLabel => 'ما الذي يتلقاه';

  @override
  String get aiSeesHerQuestion => 'السؤال الذي كتبتِه';

  @override
  String get aiSeesPassages =>
      'مقاطع من مصادر femio الموثوقة (نص عام، وليس من بياناتكِ)';

  @override
  String get aiSeesNote => 'الملاحظة التي كتبتِها';

  @override
  String get aiSeesBands =>
      'أربع معلومات عامة: المرحلة الحياتية، وانتظام الدورة، وأنواع الأعراض، ومدة التسجيل المتواصل';

  @override
  String get aiSeesIds => 'نصائح femio أو أسئلته المراجَعة، لترتيبها';

  @override
  String get aiSeesVisitFacts =>
      'ملخص زيارتكِ: الهدف، وعدد الدورات، وأقصر دورة وأطولها، وتاريخ آخر دورة، والانتظام';

  @override
  String get aiSeesApprovedQuestion =>
      'سؤالكِ؛ وفي السحابة، النسخة التي وافقتِ عليها فقط، بعد حذف الأرقام والتواريخ والأسماء';

  @override
  String get assistIntroTitle => 'تعرّفي على مساعد femio';

  @override
  String get assistIntroPhone =>
      'يعمل على هذا الهاتف. يجيب من مصادر femio الموثوقة، ويحوّل جملة إلى عناصر في سجلكِ، ويقترح أسئلة لزياراتكِ. تبقى سجلاتكِ هنا.';

  @override
  String get assistIntroRules =>
      'لا يخبركِ أبدًا بما لديكِ من حالة. تجيب قواعد السلامة في femio أولًا دائمًا، ولا يُحفظ شيء حتى تؤكديه.';

  @override
  String get assistIntroCloudTitle => 'Cloud boost، فقط إن اخترتِه';

  @override
  String get assistIntroCloudBody =>
      'إذا لم يستطع هذا الهاتف تشغيل الذكاء الاصطناعي بنفسه، يمكنكِ السماح بإرسال سؤال عام توافقين عليه، أو أربع معلومات عامة، إلى ذكاء Google الاصطناعي السحابي. يبقى متوقّفًا ما لم تشغّليه.';

  @override
  String get assistIntroCloudAction => 'اختيار Cloud boost';

  @override
  String get assistIntroContinue => 'المتابعة على هذا الهاتف';

  @override
  String get assistIntroSettings =>
      'يمكنكِ تغيير ذلك، أو إيقاف المساعد، من الإعدادات › المساعد.';

  @override
  String get assistDoorAsk => 'اطرحي سؤالًا';

  @override
  String get assistDoorAskSub => 'إجابات من مصادر موثوقة، مع الروابط';

  @override
  String get assistDoorSayIt => 'قولي كيف كان يومكِ';

  @override
  String get assistDoorSayItSub =>
      'تتحول جملة واحدة إلى سجل اليوم؛ وتراجعينه أولًا';

  @override
  String get assistDoorVisitSub => 'ملخص لسجلكِ وأسئلة تأخذينها معكِ';

  @override
  String thisWeekTitle(int week) {
    return 'هذا الأسبوع: الأسبوع $week';
  }

  @override
  String weekGuideTitle(int week) {
    return 'الأسبوع $week';
  }

  @override
  String get weekSecBaby => 'الجنين';

  @override
  String get weekSecBody => 'جسمكِ';

  @override
  String get weekSecNotice => 'ما قد تلاحظينه';

  @override
  String get weekSecCare => 'الرعاية في هذه الفترة';

  @override
  String get weekSecTip => 'نصيحة';

  @override
  String weekReadFull(int week) {
    return 'اقرئي دليل الأسبوع $week';
  }

  @override
  String get pregWeeksTitle => 'حملكِ أسبوعًا بأسبوع';

  @override
  String get pregWeeksHint =>
      'محسوبة من موعد ولادتكِ المتوقع. اضغطي على أسبوع لقراءة دليله.';

  @override
  String pregWeekCurrentLabel(int week) {
    return 'الأسبوع $week، أسبوعكِ الحالي';
  }

  @override
  String get sectionBleedingPregnant => 'نزيف أو تبقّع';

  @override
  String get bleedingPregnantNote =>
      'النزيف أثناء الحمل شائع، لكنه قد يكون علامة على أمر خطير. أخبري القابلة أو الطبيب عن أي نزيف.';

  @override
  String get logAllItems => 'كل عناصر السجل';

  @override
  String get logAllItemsSub =>
      'اختبار التبويض ودرجة الحرارة، مخفيّان أثناء الحمل';

  @override
  String get sayItHintTtc =>
      'مثلًا: اختبار التبويض إيجابي، تقلصات خفيفة وانتفاخ';

  @override
  String get sayItHintPregnant => 'مثلًا: غثيان الصباح، ألم الظهر وتعب شديد';

  @override
  String get sayItHintPostpartum => 'مثلًا: أرق، ألم الظهر ومزاج حزين';

  @override
  String get sayItHintMenopause => 'مثلًا: هبات ساخنة، تعرق ليلي وأرق';

  @override
  String get askHintTtc => 'مثلًا: متى تكون فترة الخصوبة؟';

  @override
  String get askHintPregnant => 'مثلًا: ما الذي يخفف حرقة المعدة أثناء الحمل؟';

  @override
  String get askHintPostpartum =>
      'مثلًا: ما الذي يخفف ألم الحلمات أثناء الرضاعة؟';

  @override
  String get askHintMenopause => 'مثلًا: ما الذي يخفف الهبات الساخنة؟';

  @override
  String get calendarHintNoEstimates =>
      'اضغطي على أي يوم لتسجيله. الأيام التي سجّلتِها تظهر ممتلئة.';

  @override
  String get whyRangeAction => 'لماذا هذا النطاق؟';

  @override
  String get whyRangeTitle => 'لماذا هذا النطاق';

  @override
  String whyRangeStated(String length, String margin) {
    return 'لا يستطيع femio قياس دورة من سجلّكِ بعد، لذلك يبدأ من طول الدورة الذي أدخلتِه: $length. والنطاق $margin قبل الموعد وبعده.';
  }

  @override
  String whyRangeCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'قاس femio $count دورة من الدورات التي سجّلتِها.',
      few: 'قاس femio $count دورات من الدورات التي سجّلتِها.',
      two: 'قاس femio دورتين من الدورات التي سجّلتِها.',
      one: 'قاس femio دورة واحدة من الدورات التي سجّلتِها.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeAverage(String length) {
    return 'متوسط دوراتكِ الأخيرة $length، لذلك يقع منتصف النطاق بعد $length من بداية آخر دورة.';
  }

  @override
  String whyRangeSpread(String spread, String margin) {
    return 'الفرق بين أقصر دوراتكِ وأطولها $spread، لذلك يمتد النطاق $margin قبل المنتصف وبعده.';
  }

  @override
  String whyRangeSpreadNone(String margin) {
    return 'كانت دوراتكِ كلها بالطول نفسه، لذلك هذا أضيق نطاق يعرضه femio: $margin قبل المنتصف وبعده.';
  }

  @override
  String whyRangeIrregular(String limit) {
    return 'تختلف دوراتكِ بأكثر من $limit، لذلك يعرض femio الدورة التالية فقط بنطاق أوسع، ولا يعدّ أيام تأخير أبدًا.';
  }

  @override
  String whyRangeNextMedium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count دورة إضافية تسجّلينها بالانتظام نفسه ترفع الثقة إلى متوسطة.',
      few:
          '$count دورات إضافية تسجّلينها بالانتظام نفسه ترفع الثقة إلى متوسطة.',
      two: 'دورتان إضافيتان تسجّلينهما بالانتظام نفسه ترفعان الثقة إلى متوسطة.',
      one: 'دورة إضافية واحدة تسجّلينها بالانتظام نفسه ترفع الثقة إلى متوسطة.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeNextHigh(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count دورة إضافية تسجّلينها بالانتظام نفسه ترفع الثقة إلى عالية.',
      few: '$count دورات إضافية تسجّلينها بالانتظام نفسه ترفع الثقة إلى عالية.',
      two: 'دورتان إضافيتان تسجّلينهما بالانتظام نفسه ترفعان الثقة إلى عالية.',
      one: 'دورة إضافية واحدة تسجّلينها بالانتظام نفسه ترفع الثقة إلى عالية.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeHighNeedsSteady(String limit) {
    return 'الثقة العالية تحتاج إلى دورات لا يزيد اختلافها عن $limit.';
  }

  @override
  String get whyRangeWindowShown =>
      'تُحسب نافذة الخصوبة بالرجوع من منتصف هذا النطاق، لذلك تتحرك عندما يتحرك النطاق.';

  @override
  String get whyRangeWindowIrregular =>
      'لا تُحدَّد نافذة خصوبة لأن دوراتكِ تختلف كثيرًا بحيث لا يمكن الحساب بالرجوع من تاريخ واحد.';

  @override
  String get whyRangeWindowLearning =>
      'لا تُحدَّد نافذة خصوبة بعد: يحتاج femio إلى دورتين على الأقل من سجلّكِ ليحسب بالرجوع منهما.';

  @override
  String whyRangeWindowOutside(int min, int max) {
    return 'لا تُحدَّد نافذة خصوبة لأن طول دورتكِ خارج $min إلى $max يومًا، وفيه لا يُعتمد على الحساب بالرجوع من تاريخ واحد.';
  }

  @override
  String get dayExplainLink => 'اشرحي هذا اليوم';

  @override
  String get dayFactBleed => 'سجّلتِ نزيفًا في هذا اليوم.';

  @override
  String get dayFactSpotting => 'سجّلتِ تبقّعًا في هذا اليوم.';

  @override
  String get dayFactLogged => 'سجّلتِ أعراضًا أو مزاجًا في هذا اليوم.';

  @override
  String dayFactNextPeriod(String range) {
    return 'هذا اليوم داخل النطاق الذي قد تبدأ فيه دورتكِ التالية: $range.';
  }

  @override
  String dayFactLaterPeriod(String range) {
    return 'هذا اليوم داخل نطاق دورة لاحقة: $range. كلما ابتعد الموعد قلّ اليقين.';
  }

  @override
  String dayFactFertile(String range) {
    return 'هذا اليوم داخل نافذة الخصوبة المقدَّرة: $range.';
  }

  @override
  String get dayFactOvulation =>
      'يقدّر femio الإباضة في هذا اليوم تقريبًا، بالحساب رجوعًا من دورتكِ التالية. اختبارات التبويض ودرجة الحرارة عند الاستيقاظ تساعدكِ على معرفة ما إذا حدثت الإباضة.';

  @override
  String get dayFactNothingFuture => 'لا يوجد تقدير لهذا اليوم.';

  @override
  String get dayFactNothingPast =>
      'لم يُسجَّل شيء لهذا اليوم. لا يرسم femio تقديرات على أيام مضت.';

  @override
  String get dayLogAction => 'سجّلي هذا اليوم';

  @override
  String predictionMoved(String after, String before) {
    return 'الدورة التالية الآن نحو $after. كانت $before.';
  }

  @override
  String predictionNew(String after) {
    return 'الدورة التالية نحو $after.';
  }

  @override
  String get predictionWhy => 'لماذا؟';

  @override
  String get visitWorryTitle => 'ما الذي تريدين طرحه في هذه الزيارة؟';

  @override
  String get visitWorryHint => 'بكلماتكِ، مثلًا: مغص الدورة صار أقوى';

  @override
  String get visitWorryFind => 'ابحثي عن أسئلة';

  @override
  String get visitWorrySuggested => 'أسئلة تناسب ما كتبتِه';

  @override
  String get visitWorryNone =>
      'لا يوجد سؤال في قائمة femio يناسب هذا بعد. ستُضاف كلماتكِ كما كتبتِها.';

  @override
  String get visitWorryOwnWords => 'أضيفي كلماتكِ أيضًا';

  @override
  String get visitWorryAdd => 'أضيفيها إلى زيارتكِ';

  @override
  String visitWorryAddedTo(String date) {
    return 'أُضيفت إلى أسئلتكِ لموعد $date.';
  }

  @override
  String get visitWorryAddedNext => 'أُضيفت إلى أسئلتكِ لزيارتكِ القادمة.';

  @override
  String get visitYourQuestions => 'أسئلتكِ';

  @override
  String visitInMyWords(String text) {
    return 'بكلماتي: $text';
  }

  @override
  String get visitRemoveQuestion => 'احذفي هذا السؤال';

  @override
  String get visitSecondLanguage => 'أضيفي الصفحة بلغة ثانية للعيادة';

  @override
  String get visitNoSecondLanguage => 'بدون';

  @override
  String get visitShare => 'مشاركة';

  @override
  String visitMadeOn(String date) {
    return 'أُعدّت في $date مما سجّلته في femio. هي سجلّي الخاص، لنناقشه معًا.';
  }

  @override
  String get askVisitPack => 'جهّزي ملف الزيارة';

  @override
  String get tipWhyAction => 'لماذا أرى هذا؟';

  @override
  String get tipWhyTitle => 'لماذا هذه النصيحة';

  @override
  String tipWhyStage(String stage) {
    String _temp0 = intl.Intl.selectLogic(stage, {
      'period': 'أنتِ تتابعين دورتكِ الشهرية.',
      'ttc': 'أنتِ تحاولين الحمل.',
      'pregnant': 'أنتِ حامل.',
      'postpartum': 'سجّلتِ ولادة طفلكِ.',
      'menopause': 'أنتِ تتابعين ما حول انقطاع الطمث أو انقطاعه.',
      'other': 'اخترتِ هذه المرحلة.',
    });
    return '$_temp0';
  }

  @override
  String tipWhyTerm(String term, String days, String window) {
    return 'سجّلتِ «$term» في $days خلال آخر $window.';
  }

  @override
  String tipWhyPregnancyWeek(int week) {
    return 'أنتِ في الأسبوع $week من الحمل، محسوبًا من موعد الولادة المتوقع.';
  }

  @override
  String tipWhyPostpartumWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'وُلد طفلكِ منذ $count أسبوع.',
      many: 'وُلد طفلكِ منذ $count أسبوعًا.',
      few: 'وُلد طفلكِ منذ $count أسابيع.',
      two: 'وُلد طفلكِ منذ أسبوعين.',
      one: 'وُلد طفلكِ منذ أسبوع واحد.',
      zero: 'وُلد طفلكِ منذ أقل من أسبوع.',
    );
    return '$_temp0';
  }

  @override
  String tipWhyTryingFor(String label) {
    return 'مدة محاولتكِ للحمل: $label.';
  }

  @override
  String get tipWhyIrregular => 'دوراتكِ مسجّلة على أنها غير منتظمة.';

  @override
  String get tipWhyRegular => 'دوراتكِ غير مسجّلة على أنها غير منتظمة.';

  @override
  String tipWhyAge(int age) {
    return 'عمركِ $age عامًا أو أكثر هذا العام.';
  }

  @override
  String get tipWhyFootnote =>
      'قُرئت هذه المعلومات على هاتفكِ، من سجلّكِ أنتِ. وهي الأسباب الوحيدة لاختيار هذه النصيحة.';

  @override
  String get aiLedgerTitle => 'ما الذي فعله الذكاء الاصطناعي';

  @override
  String get aiLedgerSub =>
      'كل مرة استخدم فيها femio نموذجًا، محفوظة على هذا الهاتف';

  @override
  String get aiLedgerIntro =>
      'كل مرة استخدم فيها femio نموذجًا تظهر هنا، الأحدث أولًا. وفي التعزيز السحابي يُحفظ النص الذي أُرسل كما هو، كإيصال لكِ. تبقى هذه القائمة على هذا الهاتف: ليست في نسختكِ الاحتياطية، ويحذفها «حذف كل شيء».';

  @override
  String get aiLedgerEmpty => 'لم يستخدم femio أي نموذج بعد.';

  @override
  String get aiLedgerOnPhone => 'على هذا الهاتف (Gemini Nano)';

  @override
  String get aiLedgerInCloud => 'أُرسل بالتعزيز السحابي';

  @override
  String get aiLedgerNoReply =>
      'لم تصل إجابة في الوقت المحدد، فاستخدم femio قواعده.';

  @override
  String get aiLedgerSent => 'ما أُرسل بالضبط';

  @override
  String get aiLedgerClear => 'امسحي هذه القائمة';

  @override
  String get aiLedgerClearConfirm => 'هل تمسحين هذه القائمة؟ لن يتغيّر سجلّكِ.';

  @override
  String get signsTitle => 'العلامات التي سجّلتِها في هذه الدورة';

  @override
  String signsValueOn(String value, String date) {
    return '$value، $date';
  }

  @override
  String signsTempCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count قياس في هذه الدورة',
      many: '$count قياسًا في هذه الدورة',
      few: '$count قياسات في هذه الدورة',
      two: 'قياسان في هذه الدورة',
      one: 'قياس واحد في هذه الدورة',
      zero: 'لا قياسات في هذه الدورة',
    );
    return '$_temp0';
  }

  @override
  String get signsStripLine =>
      'شريط اختبار التبويض يُظهر ارتفاع هرمون، لا دليلًا على حدوث التبويض. ارتفاع حرارة جسمكِ عند الاستيقاظ بعد ذلك علامة أفضل.';

  @override
  String get signsNote =>
      'تظهر كل علامة كما سجّلتِها. لا يقول femio هل حدث التبويض أو متى؛ فهذا حديثٌ بينكِ وبين طبيبكِ.';

  @override
  String sayItChipWithSection(String section, String value) {
    return '$section: $value';
  }

  @override
  String get navAdd => 'إضافة';

  @override
  String get addSheetTitle => 'أضيفي ليومكِ';

  @override
  String get addSayItPrompt => 'اكتبي لـ femio أي شيء، مثل «مغص من الصبح»';

  @override
  String get addMoreToLog => 'الأعراض والإفرازات والاختبارات والمزيد';

  @override
  String get addAsk => 'اسألي femio';

  @override
  String get addVisit => 'لزيارة الطبيب';

  @override
  String get recTitle => 'سجلّي الصحي';

  @override
  String get recIntro =>
      'ملفكِ الصحي الخاص، محفوظ على هذا الهاتف. يظهر كل إدخال بتاريخ حدوثه وتاريخ إضافتكِ له، كما كتبتِه تمامًا.';

  @override
  String get recAll => 'الكل';

  @override
  String get recKindVisit => 'زيارة';

  @override
  String get recKindLab => 'نتيجة تحليل';

  @override
  String get recKindImaging => 'أشعة أو سونار';

  @override
  String get recKindMedicine => 'دواء';

  @override
  String get recKindCondition => 'حالة أو تاريخ مرضي';

  @override
  String get recKindAllergy => 'حساسية';

  @override
  String get recKindProcedure => 'إجراء طبي';

  @override
  String get recKindPregnancy => 'حمل';

  @override
  String get recKindDocument => 'مستند';

  @override
  String get recKindNote => 'ملاحظة';

  @override
  String get recEmptyHeading => 'لا شيء هنا بعد';

  @override
  String get recEmptyBody =>
      'أضيفي زيارة أو نتيجة تحليل أو دواءً أو أي شيء تريدين الاحتفاظ به. تبقى الإدخالات على هذا الهاتف وتُحفظ في ملف النسخة الاحتياطية الذي تحفظينه.';

  @override
  String get recAdd => 'إضافة إدخال';

  @override
  String get recEdit => 'تعديل الإدخال';

  @override
  String get recSave => 'حفظ في سجلّي';

  @override
  String get recCancel => 'إلغاء';

  @override
  String get recDelete => 'حذف';

  @override
  String get recDeleteTitle => 'حذف هذا الإدخال؟';

  @override
  String get recDeleteBody =>
      'سيُحذف من هذا الهاتف. يبقى موجودًا في أي نسخة احتياطية حفظتِها من قبل.';

  @override
  String get recFormKind => 'النوع';

  @override
  String get recFormTitle => 'العنوان';

  @override
  String get recFormTitleHint => 'بكلماتكِ، مثل «TSH» أو «سونار الأسبوع 12»';

  @override
  String get recFormHappened => 'تاريخ الحدوث';

  @override
  String get recFormHappenedHint =>
      'التاريخ المطبوع على التقرير، أو يوم الزيارة.';

  @override
  String get recNeedTitle => 'أضيفي عنوانًا';

  @override
  String get recNeedDate => 'اختاري تاريخ الحدوث';

  @override
  String get recFieldValue => 'النتيجة';

  @override
  String get recFieldUnit => 'الوحدة';

  @override
  String get recFieldPrintedRange => 'المعدل المطبوع على التقرير';

  @override
  String get recFieldDose => 'الجرعة كما كُتبت';

  @override
  String get recFieldFrequency => 'كم مرة';

  @override
  String get recFieldStartedOn => 'تاريخ البدء';

  @override
  String get recFieldEndedOn => 'تاريخ التوقف';

  @override
  String get recFieldPrescriber => 'وصفه';

  @override
  String get recFieldPlace => 'المكان';

  @override
  String get recFieldDetails => 'تفاصيل';

  @override
  String recRowAdded(String date) {
    return 'أُضيف $date';
  }

  @override
  String get recEdited => 'معدَّل';

  @override
  String get recSourceTyped => 'مكتوب';

  @override
  String get recSourceScanned => 'ممسوح ضوئيًا';

  @override
  String get recSourceAsk => 'من اسألي femio';

  @override
  String get recSourceSayIt => 'من وصفكِ ليومكِ';

  @override
  String get recSourceImported => 'مستورد';

  @override
  String get recNoVerdictNote =>
      'يحفظ femio إدخالاتكِ ويعرضها كما كتبتِها. لا يقول أبدًا إن كانت النتيجة طبيعية أم لا: هذا حديث بينكِ وبين طبيبكِ.';

  @override
  String get addRecord => 'سجلّي الصحي';

  @override
  String get addRecordSub => 'الزيارات والنتائج والأدوية والمستندات';

  @override
  String get logNoteSection => 'ملاحظة';

  @override
  String get logNoteHint => 'أي شيء تودّين تذكّره عن هذا اليوم';

  @override
  String get logNoteSaved => 'تُحفظ على هذا الهاتف مع بقية سجلّكِ.';

  @override
  String get csvColumnDate => 'التاريخ';

  @override
  String get csvColumnOther => 'أخرى';

  @override
  String get exportCsv => 'تصدير كجدول بيانات (CSV)';

  @override
  String get csvNotEncrypted =>
      'على عكس النسخة الاحتياطية، هذا الملف غير مشفَّر، فاحفظيه في مكان خاص.';

  @override
  String get csvSaved => 'تم حفظ جدول البيانات.';

  @override
  String get csvNothingToExport => 'لم تسجّلي شيئاً بعد، فلا يوجد ما يُصدَّر.';
}
