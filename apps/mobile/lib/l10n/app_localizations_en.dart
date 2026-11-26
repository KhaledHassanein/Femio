// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'femio';

  @override
  String get welcomeTitle => 'Your cycle, your plans, your pregnancy.';

  @override
  String get welcomeBody =>
      'Your records stay on this phone. No account, and femio never sees them.';

  @override
  String get welcomeTagline => 'AI-assisted women\'s health & wellness';

  @override
  String get language => 'Language';

  @override
  String get getStarted => 'Get started';

  @override
  String get continueLabel => 'Continue';

  @override
  String get back => 'Back';

  @override
  String get notSure => 'Not sure';

  @override
  String get goalTitle => 'What brings you to femio?';

  @override
  String get goalSub => 'You can change this any time.';

  @override
  String get goalPeriod => 'Track my period';

  @override
  String get goalPeriodDesc =>
      'A range for when it\'s coming, and what\'s usual for you.';

  @override
  String get goalTtc => 'Get pregnant';

  @override
  String get goalTtcDesc => 'Your fertile window and likely ovulation.';

  @override
  String get goalPregnant => 'I\'m pregnant';

  @override
  String get goalPregnantDesc => 'Week by week, and your due date.';

  @override
  String get goalMenopause => 'Perimenopause & menopause';

  @override
  String get goalMenopauseDesc => 'Changing cycles and symptoms.';

  @override
  String get birthYearTitle => 'What year were you born?';

  @override
  String get birthYearSub =>
      'Cycles change with age, so this shapes what femio expects. Only the year.';

  @override
  String get under18Title => 'The tracker is for adults, for now';

  @override
  String get under18Body =>
      'femio\'s tracker is for women aged 18 and over in this first version. Every guide on femioapp.com is open to you, with no account.';

  @override
  String get eighteenTitle => 'Has your 18th birthday passed?';

  @override
  String get eighteenSub =>
      'One quick check: the tracker is for women aged 18 and over. Nothing here is saved.';

  @override
  String get yesLabel => 'Yes';

  @override
  String get noNotYetLabel => 'No, not yet';

  @override
  String get lastPeriodTitle => 'When did your last period start?';

  @override
  String get lastPeriodSub => 'The first day of bleeding.';

  @override
  String get dontRemember => 'I don\'t remember';

  @override
  String get periodLengthTitle =>
      'How many days does your period usually last?';

  @override
  String get cycleLengthTitle => 'How long is your cycle usually?';

  @override
  String get cycleLengthSub =>
      'From the first day of one period to the first day of the next.';

  @override
  String get irregular => 'My cycles are irregular';

  @override
  String daysValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get tryingTitle => 'How long have you been trying?';

  @override
  String get tryingJustStarted => 'Just starting';

  @override
  String get tryingUnder6 => 'Under 6 months';

  @override
  String get trying6to12 => '6 to 12 months';

  @override
  String get tryingOver12 => 'Over a year';

  @override
  String get dueMethodTitle => 'How should we work out your due date?';

  @override
  String get dueMethodKnown => 'I know my due date';

  @override
  String get dueMethodLmp => 'First day of my last period';

  @override
  String get dueMethodConception => 'Conception date';

  @override
  String get dueMethodIvf3 => 'IVF transfer (day-3 embryo)';

  @override
  String get dueMethodIvf5 => 'IVF transfer (day-5 embryo)';

  @override
  String get dueMethodBorn => 'I\'ve had my baby';

  @override
  String get dueDateTitle => 'What is your due date?';

  @override
  String get conceptionTitle => 'When did you conceive?';

  @override
  String get transferTitle => 'When was your embryo transfer?';

  @override
  String get birthDateTitle => 'When was your baby born?';

  @override
  String get implausibleDue =>
      'That date doesn\'t look like a current pregnancy. Please check it.';

  @override
  String get menoLastTitle => 'When was your last period?';

  @override
  String get menoOverYear => 'Over a year ago';

  @override
  String get predictionPeriodTitle => 'Your next period';

  @override
  String get predictionFertileTitle => 'Your fertile window';

  @override
  String predictionOvulation(String date) {
    return 'Likely ovulation: $date';
  }

  @override
  String predictionNextPeriod(String range) {
    return 'Next period around $range';
  }

  @override
  String rangeValue(String start, String end) {
    return '$start – $end';
  }

  @override
  String get confidenceLow =>
      'Low confidence: it sharpens as you log your periods';

  @override
  String get confidenceMedium => 'Medium confidence';

  @override
  String get confidenceHigh => 'High confidence';

  @override
  String get basisStated => 'Based on the cycle length you told us';

  @override
  String get irregularNote =>
      'Your cycles vary, so femio shows a wider range and never counts days late.';

  @override
  String get noPredictionTitle => 'Log your next period';

  @override
  String get noPredictionBody =>
      'When your period starts, log it and femio will predict the next one.';

  @override
  String pregnancyWeek(int weeks, int days) {
    return 'Week $weeks, day $days';
  }

  @override
  String trimesterLabel(int n) {
    return 'Trimester $n';
  }

  @override
  String dueDateLabel(String date) {
    return 'Due date around $date';
  }

  @override
  String postpartumWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks weeks since your baby was born',
      one: '1 week since your baby was born',
      zero: 'Your baby is less than a week old',
    );
    return '$_temp0';
  }

  @override
  String menoMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months since your last period',
      one: '1 month since your last period',
      zero: 'Your last period was less than a month ago',
    );
    return '$_temp0';
  }

  @override
  String get menoUnknown =>
      'Log any bleeding or symptoms and femio keeps the record for your clinician.';

  @override
  String get awarenessNote =>
      'Estimates for awareness and planning, not a way to avoid pregnancy.';

  @override
  String get seeClinicianTtc =>
      'Trying for over a year (or six months if you are 35 or older) is a good time to talk to a clinician.';

  @override
  String get privacyLine => 'Stored on this phone only.';

  @override
  String get logPeriodToday => 'My period started today';

  @override
  String get loggedToday => 'Logged. Your prediction is updated.';

  @override
  String get startOver => 'Start again';

  @override
  String get todayTitle => 'Today';

  @override
  String get logHappy => 'Happy';

  @override
  String get logCalm => 'Calm';

  @override
  String get logAnxious => 'Anxious';

  @override
  String get logIrritable => 'Irritable';

  @override
  String get logSad => 'Sad';

  @override
  String get logMoodSwings => 'Mood swings';

  @override
  String get logLowMotivation => 'Low motivation';

  @override
  String get logTearfulness => 'Tearfulness';

  @override
  String get logPanicFeelings => 'Sudden panicky feelings';

  @override
  String get logCramps => 'Cramps';

  @override
  String get logHeadache => 'Headache';

  @override
  String get logBloating => 'Bloating';

  @override
  String get logBreastTenderness => 'Breast tenderness';

  @override
  String get logBackache => 'Backache';

  @override
  String get logJointPain => 'Joint pain';

  @override
  String get logMusclePain => 'Muscle aches';

  @override
  String get logNausea => 'Nausea';

  @override
  String get logConstipation => 'Constipation';

  @override
  String get logDiarrhea => 'Diarrhoea';

  @override
  String get logFatigue => 'Fatigue';

  @override
  String get logAcne => 'Acne';

  @override
  String get logHotFlashes => 'Hot flushes';

  @override
  String get logNightSweats => 'Night sweats';

  @override
  String get logSpotting => 'Spotting';

  @override
  String get logHeartFlutters => 'Heart fluttering or racing';

  @override
  String get logWeightChange => 'A change in weight';

  @override
  String get logCravings => 'Cravings';

  @override
  String get logInsomnia => 'Trouble sleeping';

  @override
  String get logDizziness => 'Dizziness';

  @override
  String get logBrainFog => 'Brain fog';

  @override
  String get logLibidoUp => 'Higher sex drive';

  @override
  String get logLibidoDown => 'Lower sex drive';

  @override
  String get logVaginalDryness => 'Vaginal dryness';

  @override
  String get logPainDuringSex => 'Pain during sex';

  @override
  String get logBladderUrgency => 'Needing to pee urgently or often';

  @override
  String get logBladderLeaks => 'Leaking urine';

  @override
  String get logHairThinning => 'Hair thinning';

  @override
  String get logDryItchySkin => 'Dry or itchy skin';

  @override
  String get logBrittleNails => 'Brittle nails';

  @override
  String get logGumSoreness => 'Sore or bleeding gums';

  @override
  String get logBurningMouth => 'Burning or tingling mouth';

  @override
  String get logTingling => 'Tingling in hands or feet';

  @override
  String get logElectricShocks => 'Brief electric-shock sensations';

  @override
  String get logBodyOdourChange => 'A change in body odour';

  @override
  String get logTinnitus => 'Ringing in the ears';

  @override
  String get logDry => 'Dry';

  @override
  String get logSticky => 'Sticky';

  @override
  String get logCreamy => 'Creamy';

  @override
  String get logWatery => 'Watery';

  @override
  String get logEggWhite => 'Egg white';

  @override
  String get logIntercourse => 'Intercourse';

  @override
  String get flowSpotting => 'Spotting';

  @override
  String get flowLight => 'Light';

  @override
  String get flowMedium => 'Medium';

  @override
  String get flowHeavy => 'Heavy';

  @override
  String get flowLabel => 'Flow';

  @override
  String get navToday => 'Today';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navLog => 'Log';

  @override
  String get calendarTitle => 'Calendar';

  @override
  String get legendPeriod => 'Period';

  @override
  String get legendSpotting => 'Spotting';

  @override
  String get legendPredicted => 'Period may start';

  @override
  String get legendFertile => 'Fertile window';

  @override
  String get legendOvulation => 'Likely ovulation';

  @override
  String get legendLogged => 'Something logged';

  @override
  String get calendarHint =>
      'Tap a day to log it. Estimates are shown in outline; what you log is filled in.';

  @override
  String get logTitle => 'Log';

  @override
  String get sectionPeriod => 'Period';

  @override
  String get flowNone => 'None';

  @override
  String get sectionMood => 'Mood';

  @override
  String get sectionSymptoms => 'Symptoms';

  @override
  String get sectionDischarge => 'Discharge';

  @override
  String get sectionMore => 'More';

  @override
  String get previousDay => 'Previous day';

  @override
  String get nextDay => 'Next day';

  @override
  String get logSavedNote => 'Saved on this phone as you tap.';

  @override
  String get logSymptomsButton => 'Log how you feel';

  @override
  String loggedTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things logged today',
      one: '1 thing logged today',
      zero: 'Nothing logged today',
    );
    return '$_temp0';
  }

  @override
  String get sectionOvulationTest => 'Ovulation test';

  @override
  String get sectionTemperature => 'Waking temperature';

  @override
  String get temperatureHint => 'Taken before getting up, in °C or °F';

  @override
  String get temperatureSave => 'Save';

  @override
  String get temperatureClear => 'Clear';

  @override
  String get testTimingTitle => 'When to test';

  @override
  String testTimingBody(String date) {
    return 'If your period hasn\'t started by $date, a home pregnancy test is most reliable from that day.';
  }

  @override
  String get opkNegative => 'Negative';

  @override
  String get opkLow => 'Low';

  @override
  String get opkHigh => 'High';

  @override
  String get opkPeak => 'Peak';

  @override
  String get opkPositive => 'Positive';

  @override
  String get bbtChartHeading => 'Your temperatures';

  @override
  String get bbtChartNeedData =>
      'Log three waking temperatures and your chart appears here. Fewer than that is a dot, not a pattern.';

  @override
  String get bbtChartNote =>
      'These are your readings, drawn as they are. femio does not mark a shift or name a day — what a chart means is a conversation for you and your clinician.';

  @override
  String get invalidBbt =>
      'That does not look like a thermometer reading. Check the number and try again.';

  @override
  String get testTimingGeneral =>
      'Most home tests work from the first day of a missed period. Testing earlier can give a negative result even if you are pregnant.';

  @override
  String get testTimingSource => 'Source: NHS, Doing a pregnancy test.';

  @override
  String pregDaysToGo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days to go',
      one: '$days day to go',
    );
    return '$_temp0';
  }

  @override
  String pregOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days past your due date',
      one: '$days day past your due date',
    );
    return '$_temp0';
  }

  @override
  String pregTermFrom(String date) {
    return 'Term from $date';
  }

  @override
  String get pregEstimateNote =>
      'These dates are estimates based on the due date you entered. Your clinician may adjust it after a scan.';

  @override
  String get pregRedFlagsHeading => 'Some symptoms need urgent care';

  @override
  String get pregRedFlagsBody =>
      'Seek care now if you have a severe headache, changes in your vision, pain in the upper abdomen, swelling of the face or hands, difficulty breathing, vaginal bleeding, or if your baby\'s movements have slowed down, stopped or changed. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department.';

  @override
  String get pregRedFlagsMore => 'See the full list and its sources';

  @override
  String get redFlagsListHeading => 'Seek care now for any of these';

  @override
  String get redFlagHeadache => 'A severe headache';

  @override
  String get redFlagVision => 'Changes in your vision';

  @override
  String get redFlagUpperAbdomen => 'Pain in the upper abdomen';

  @override
  String get redFlagSwelling => 'Swelling of the face or hands';

  @override
  String get redFlagBreathing => 'Difficulty breathing';

  @override
  String get redFlagBleeding => 'Vaginal bleeding';

  @override
  String get redFlagMovements =>
      'Your baby\'s movements slowing down, stopping or changing';

  @override
  String get contractionsHeading => 'Contraction timer';

  @override
  String get contractionsIntro =>
      'Press start when one begins and stop when it eases. femio keeps the times so you have them when you call.';

  @override
  String get contractionsStart => 'Start a contraction';

  @override
  String get contractionsStop => 'It has eased';

  @override
  String get contractionsRunning => 'Timing now';

  @override
  String get contractionsContactHeading =>
      'Call your maternity unit whenever you need to';

  @override
  String get contractionsContactBody =>
      'You do not need to reach a certain number first. Call if you are worried, if your waters break, if there is bleeding, or if the baby is moving less than usual.';

  @override
  String contractionsSummaryHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your last $count contractions',
      one: 'Your last contraction',
    );
    return '$_temp0';
  }

  @override
  String contractionsSummaryDuration(String value) {
    return 'Lasting about $value';
  }

  @override
  String contractionsSummaryInterval(String value) {
    return 'About $value apart, start to start';
  }

  @override
  String get contractionsSummaryNote =>
      'These are your times, as recorded. femio does not decide what they mean — read them out to your midwife or maternity unit, who can.';

  @override
  String get movementsHeading => 'Movement log';

  @override
  String get movementsIntro =>
      'There is no normal number of movements. What matters is a change from your baby\'s usual pattern, so this records what you feel and shows you your own pattern over time.';

  @override
  String get movementsUrgentHeading => 'If movements are less than usual';

  @override
  String get movementsUrgentBody =>
      'Contact your maternity team now. Do not wait for this session to finish, and do not wait until tomorrow.';

  @override
  String get movementsStart => 'Start a session';

  @override
  String get movementsStartBody =>
      'Get comfortable, then start. Tap each time you feel a movement.';

  @override
  String get movementsTap => 'I felt a movement';

  @override
  String movementsCounted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movements recorded',
      one: '$count movement recorded',
    );
    return '$_temp0';
  }

  @override
  String get movementsFinish => 'Finish and save';

  @override
  String get movementsFinishNote =>
      'You can stop any time. The session saves either way.';

  @override
  String get movementsRecentHeading => 'Your recent sessions';

  @override
  String movementsSessionSummary(int count, String minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movements',
      one: '$count movement',
    );
    return '$_temp0 · about $minutes min apart';
  }

  @override
  String get movementsUnfinished => 'Not finished';

  @override
  String get movementsSlowerHeading =>
      'Movements were further apart than usual for you';

  @override
  String get movementsSlowerBody =>
      'This is a change from your own recent sessions. What it means is for your maternity team to say, so contact them and let someone check.';

  @override
  String movementsNeedMore(String count) {
    return 'After $count sessions you will be able to compare with your own pattern.';
  }

  @override
  String get pregnancyToolsTitle => 'Pregnancy tools';

  @override
  String get contractionsClear => 'Clear these times';

  @override
  String get contractionsCleared => 'Times cleared';

  @override
  String get contractionLength => 'Length';

  @override
  String get contractionApart => 'Apart';

  @override
  String get apptTitle => 'Appointments';

  @override
  String get apptAdd => 'Add an appointment';

  @override
  String get apptCancel => 'Cancel';

  @override
  String get apptSave => 'Save appointment';

  @override
  String get apptUntitled => 'Appointment';

  @override
  String get apptNoDate => 'No date yet';

  @override
  String get apptToday => 'Today';

  @override
  String apptInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'In $days days',
      one: 'Tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get apptPrepHeading => 'What you wanted to ask';

  @override
  String get apptUpcoming => 'Coming up';

  @override
  String get apptPast => 'Past';

  @override
  String get apptNoResultsNote =>
      'femio keeps when it is, who it is with, and what you wanted to ask. It does not keep what was found — that belongs with your clinician, in your notes.';

  @override
  String get apptEmptyHeading => 'Nothing here yet';

  @override
  String get apptEmptyBody =>
      'Add an appointment and femio will hold the questions you meant to ask, which is the part people forget in the room.';

  @override
  String get apptAwaitingHeading => 'Still waiting to hear?';

  @override
  String apptAwaitingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You were expecting results back by now for $count of these.',
      one: 'You were expecting a result back by now for one of these.',
    );
    return '$_temp0 It may be worth asking — results run late for all sorts of ordinary reasons.';
  }

  @override
  String get apptFormType => 'Type of appointment';

  @override
  String get apptFormTypePlaceholder => 'Scan, blood test, check-up…';

  @override
  String get apptFormClinician => 'Who with';

  @override
  String get apptFormWhen => 'When';

  @override
  String get apptFormResultsDue => 'Told to expect results by';

  @override
  String get apptFormResultsDueHint =>
      'Optional. femio will remind you to ask if the date passes — it never records what the result was.';

  @override
  String get apptFormPrep => 'Questions you want to ask';

  @override
  String get apptFormPrepPlaceholder => 'One per line';

  @override
  String apptPrepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions saved',
      one: '$count question saved',
    );
    return '$_temp0';
  }

  @override
  String get weightHeading => 'Weight';

  @override
  String get weightIntro =>
      'Add a reading whenever you like. femio draws them and keeps the numbers for your notes.';

  @override
  String get weightValue => 'Weight';

  @override
  String get weightSave => 'Save';

  @override
  String get weightInvalid =>
      'That does not look like a scale reading. Check the number and try again.';

  @override
  String get weightNeedData =>
      'Add a second reading and your chart appears here.';

  @override
  String weightChange(String value, String unit) {
    return '$value $unit since your first entry';
  }

  @override
  String get weightNote =>
      'Your readings, drawn as they are. femio does not show a target range or say whether a change is expected — what a pattern means is for you and your midwife or doctor.';

  @override
  String get weightDate => 'Measured on';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get weightUnitLb => 'lb';

  @override
  String get apptDelete => 'Delete';

  @override
  String get apptEdit => 'Edit';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsDates => 'Dates';

  @override
  String get settingsHijri => 'Show Hijri dates';

  @override
  String get settingsHijriNote =>
      'Beside each Gregorian date. Umm al-Qura calendar; can differ by a day from local announcements.';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsLock => 'App lock';

  @override
  String get settingsLockNote =>
      'Ask for a PIN when femio opens and after a minute away.';

  @override
  String get setPin => 'Choose a PIN of 4 to 8 digits';

  @override
  String get changePin => 'Change PIN';

  @override
  String get enterPin => 'PIN';

  @override
  String get enterPinAgain => 'Enter the PIN again';

  @override
  String get enterCurrentPin => 'Enter your current PIN';

  @override
  String get pinMismatch => 'The two PINs did not match. Try again.';

  @override
  String get wrongPin => 'That PIN is not right.';

  @override
  String get lockTitle => 'Welcome back';

  @override
  String get lockHint => 'Enter your PIN to open your records.';

  @override
  String get forgotPin =>
      'Forgot your PIN? There is no way to recover it: femio has no account. Delete everything from this phone and start again, or restore a backup file.';

  @override
  String get backupSection => 'Backup';

  @override
  String get exportBackup => 'Save a backup file';

  @override
  String get importBackup => 'Restore from a backup file';

  @override
  String get backupPassphrase => 'Passphrase';

  @override
  String get backupPassphraseAgain => 'Passphrase again';

  @override
  String get backupPassphraseHint =>
      'Choose a passphrase you will remember. The file opens only with it, and nobody can reset it.';

  @override
  String backupPassphraseShort(int count) {
    return 'Use at least $count characters.';
  }

  @override
  String get backupPassphraseMismatch => 'The two passphrases did not match.';

  @override
  String get backupSaved => 'Backup saved.';

  @override
  String get backupImported => 'Your records were restored.';

  @override
  String get backupWrongPassphrase =>
      'That passphrase does not open this file.';

  @override
  String get backupNotFemio => 'That is not a femio backup file.';

  @override
  String get backupUnreadable =>
      'This backup was made by a newer femio and cannot be read here. Update the app and try again.';

  @override
  String get backupHonesty =>
      'Your records live only on this phone. If you lose or reset the phone, they are gone unless you have saved a backup file. We cannot recover them for you.';

  @override
  String get aboutSection => 'About';

  @override
  String get wellnessDisclaimer =>
      'femio is a wellness and education tool for tracking your own health. It is not a medical device and does not replace your clinician.';

  @override
  String get predictionNote =>
      'Predictions are estimates, not guarantees, and must not be relied on to avoid pregnancy.';

  @override
  String get firstRunStorageNotice =>
      'Your records stay on this phone. femio has no account and no server, and cannot see what you enter.';

  @override
  String get firstRunStorageTitle => 'Private by design';

  @override
  String get dismiss => 'Got it';

  @override
  String get deleteEverything => 'Delete everything on this phone';

  @override
  String get deleteConfirmTitle => 'Delete everything on this phone?';

  @override
  String get deleteConfirmBody =>
      'This removes all your records and settings from femio on this phone. It cannot be undone, and we cannot restore it. Backup files you saved elsewhere are not deleted.';

  @override
  String get deleteConfirmAction => 'Delete everything';

  @override
  String get deleteConfirmCancel => 'Keep my records';

  @override
  String get corruptTitle => 'Your records could not be opened';

  @override
  String get corruptBody =>
      'The file on this phone is damaged or was written by a different femio. It has been kept aside, not deleted. Restore a backup file if you have one, or start again.';

  @override
  String get settingsReminders => 'Reminders';

  @override
  String get reminderLog => 'Log reminder';

  @override
  String get reminderLogNote =>
      'A daily nudge at the time you choose. It skips a day you have already logged.';

  @override
  String get reminderLogTime => 'Reminder time';

  @override
  String get reminderPeriod => 'Period expected';

  @override
  String get reminderPeriodNote =>
      'One notification the day before your expected window opens. Only when your cycles are regular enough to estimate.';

  @override
  String get remindersPrivacyNote =>
      'A reminder only says \"femio: Open the app\", unless you write your own words for a medicine reminder. Nothing else about your health appears on your lock screen.';

  @override
  String get remindersTimingNote =>
      'Reminders can arrive a few minutes late, and some phones hold them back to save battery.';

  @override
  String get reminderPermissionDenied =>
      'Notifications are turned off for femio. You can allow them in your phone\'s settings.';

  @override
  String get reminderTitle => 'femio';

  @override
  String get reminderBody => 'Open the app';

  @override
  String get reminderChannelName => 'Reminders';

  @override
  String get reminderChannelDescription =>
      'Reminders you turned on in femio. They never mention your health.';

  @override
  String get reminderAppointment => 'Appointment reminder';

  @override
  String get reminderAppointmentNote =>
      'One notification the day before an appointment you saved with a date.';

  @override
  String get notifConsentTitle => 'Notifications, only if you want them';

  @override
  String get notifConsentIntro =>
      'femio can nudge you on this phone. Choose what you would like to receive. Nothing is switched on until you allow it.';

  @override
  String get notifConsentNeutral =>
      'Every notification says only \"femio\" and \"Open the app\", unless you write your own words for a medicine reminder. No other health words appear on your lock screen.';

  @override
  String get notifConsentLocal =>
      'Notifications are scheduled on your phone itself. Nothing is sent anywhere, and femio has no account or server to send them from.';

  @override
  String get notifKindMedicine => 'Medicine reminder';

  @override
  String get notifKindDigest => 'Weekly digest';

  @override
  String get notifComingSoon => 'Coming in an update';

  @override
  String get notifConsentAllow => 'Allow notifications';

  @override
  String get notifConsentNotNow => 'Not now';

  @override
  String get notifConsentPickOne => 'Switch on at least one kind to continue.';

  @override
  String get notifConsentDeniedTitle => 'Notifications are off on this phone';

  @override
  String get notifConsentDeniedBody =>
      'Your phone did not allow notifications, so femio has scheduled nothing. To change this, open your phone\'s Settings, then Apps, femio, Notifications, and allow them. Then come back to Reminders in femio\'s Settings.';

  @override
  String calendarDayLabel(String gregorian, String hijri) {
    return '$gregorian, $hijri';
  }

  @override
  String get navLearn => 'Learn';

  @override
  String get learnTitle => 'Learn';

  @override
  String get learnSub =>
      'Cited guides, in plain words. Trying to conceive and pregnancy first.';

  @override
  String get learnSearchHint => 'Search the guides';

  @override
  String get learnNoResults => 'No guide matches that yet.';

  @override
  String learnReviewedBy(String name) {
    return 'Reviewed by $name';
  }

  @override
  String learnReviewedOn(String name, String date) {
    return 'Reviewed by $name · $date';
  }

  @override
  String get learnReviewPending =>
      'Editorially checked · clinician review pending';

  @override
  String get learnEnglishOnly => 'In English';

  @override
  String get learnEnglishOnlyBody =>
      'This guide is not translated yet, so it is shown in English.';

  @override
  String get learnSeekCareNow => 'Seek care now';

  @override
  String get learnSources => 'Sources';

  @override
  String get learnLinkCopied => 'Link copied. Paste it in your browser.';

  @override
  String get noConfidentWindowTitle => 'No confident window this cycle';

  @override
  String get noConfidentWindowBody =>
      'Your cycles vary too much to name fertile days from one date. Logging your periods, ovulation tests and waking temperature helps you tell afterwards whether you ovulated.';

  @override
  String get seeClinicianIrregular =>
      'Because your cycles are irregular, it is reasonable to talk to a clinician now rather than wait a year.';

  @override
  String get helpNowLauncher => 'Need help now?';

  @override
  String get helpNowDialogTitle => 'Need help now?';

  @override
  String get helpNowImmediateHeading => 'If you may be in danger';

  @override
  String get helpNowImmediateLead =>
      'If you may act on thoughts of harming yourself or someone else, or you are in immediate danger, contact the emergency services available where you are now or go to the nearest emergency department.';

  @override
  String get helpNowStayWithSomeone =>
      'If you can, stay with someone you trust while you get help.';

  @override
  String get helpNowWorriedHeading => 'If you are worried about someone else';

  @override
  String get helpNowWorriedBody =>
      'If you think the person is in immediate danger, do not leave them alone if it is safe for you to stay. Contact the emergency services available where they are, a crisis service, a health worker, or a trusted family member.';

  @override
  String get helpNowCountry_egypt => 'Egypt';

  @override
  String get helpNowCountry_saudi => 'Saudi Arabia';

  @override
  String get helpNowCountry_uae => 'United Arab Emirates';

  @override
  String get helpNowCountry_qatar => 'Qatar';

  @override
  String get helpNowCountry_kuwait => 'Kuwait';

  @override
  String get helpNowCountry_bahrain => 'Bahrain';

  @override
  String get helpNowCountry_oman => 'Oman';

  @override
  String get helpNowCountry_jordan => 'Jordan';

  @override
  String get helpNowCountry_lebanon => 'Lebanon';

  @override
  String get helpNowCountry_morocco => 'Morocco';

  @override
  String get helpNowCountry_uk => 'United Kingdom';

  @override
  String get helpNowCountry_france => 'France';

  @override
  String get helpNowCountry_spain => 'Spain';

  @override
  String get helpNowCountry_usa => 'United States';

  @override
  String get helpNowCountry_canada => 'Canada';

  @override
  String get helpNowCountry_mexico => 'Mexico';

  @override
  String get helpNowNumber_eg_ambulance =>
      'Ambulance (Egyptian Ambulance Organization)';

  @override
  String get helpNowNumber_eg_mental_health =>
      'Mental health hotline (Ministry of Health, mental health secretariat)';

  @override
  String get helpNowNumber_eg_ncw =>
      'Women’s complaints office (National Council for Women)';

  @override
  String get helpNowNumber_sa_srca =>
      'Ambulance (Saudi Red Crescent Authority)';

  @override
  String get helpNowNumber_sa_moh => 'Ministry of Health call centre';

  @override
  String get helpNowNumber_sa_moh_mental =>
      'Psychological consultations (Ministry of Health)';

  @override
  String get helpNowNumber_sa_hrsd =>
      'Family-violence reports centre (Ministry of Human Resources and Social Development)';

  @override
  String get helpNowNumber_ae_ambulance => 'Ambulance';

  @override
  String get helpNowNumber_qa_emergency =>
      'Emergency services (ambulance, police, civil defence)';

  @override
  String get helpNowNumber_qa_mental =>
      'National mental health helpline, option 4 (Hamad Medical Corporation)';

  @override
  String get helpNowNumber_kw_emergency =>
      'Emergency services (Ministry of Interior)';

  @override
  String get helpNowNumber_bh_emergency => 'Emergency services';

  @override
  String get helpNowNumber_om_emergency =>
      'Emergency services (Royal Oman Police)';

  @override
  String get helpNowNumber_om_dv =>
      'Domestic violence line (listed by the Government of Oman)';

  @override
  String get helpNowNumber_jo_emergency =>
      'Emergency services (Public Security Directorate)';

  @override
  String get helpNowNumber_jo_ambulance => 'Ambulance (Civil Defence)';

  @override
  String get helpNowNumber_jo_family =>
      'Family Protection and Juvenile Department';

  @override
  String get helpNowNumber_lb_redcross => 'Ambulance (Lebanese Red Cross)';

  @override
  String get helpNowNumber_lb_lifeline =>
      'Emotional support lifeline (listed by the Ministry of Public Health)';

  @override
  String get helpNowNumber_ma_samu =>
      'Medical emergencies, SAMU (Ministry of Health)';

  @override
  String get helpNowNumber_ma_police => 'Police';

  @override
  String get helpNowNumber_gb_999 => 'Emergency services';

  @override
  String get helpNowNumber_gb_111 => 'NHS 111, mental health option';

  @override
  String get helpNowNumber_gb_refuge =>
      'National domestic abuse helpline (Refuge)';

  @override
  String get helpNowNumber_fr_samu => 'Medical emergencies, SAMU';

  @override
  String get helpNowNumber_fr_3114 => 'National suicide prevention number';

  @override
  String get helpNowNumber_fr_3919 => 'Violences Femmes Info';

  @override
  String get helpNowNumber_es_112 => 'Emergency services';

  @override
  String get helpNowNumber_es_024 =>
      'Suicidal behaviour helpline (Ministry of Health)';

  @override
  String get helpNowNumber_es_016 =>
      'Gender violence information line, 016 (Ministry of Equality)';

  @override
  String get helpNowNumber_us_911 => 'Emergency services';

  @override
  String get helpNowNumber_us_988 => 'Suicide and Crisis Lifeline';

  @override
  String get helpNowNumber_us_ndvh => 'National Domestic Violence Hotline';

  @override
  String get helpNowNumber_ca_911 => 'Emergency services';

  @override
  String get helpNowNumber_ca_988 => 'Suicide Crisis Helpline';

  @override
  String get helpNowNumber_mx_911 => 'Emergency services';

  @override
  String get helpNowNumber_mx_vida =>
      'Línea de la Vida (National Mental Health Commission)';

  @override
  String get helpNowCountryPrompt => 'Pick a country to see its numbers';

  @override
  String get helpNowEmergency => 'Emergency services';

  @override
  String get helpNowSupport => 'Support lines';

  @override
  String get helpNowSource => 'Source';

  @override
  String get helpNowCall => 'Call';

  @override
  String get redFlagsReadGuide => 'Read the pregnancy warning signs';

  @override
  String get plusProbeTitle => 'femio Plus · billing check (test builds only)';

  @override
  String get plusProbeSubtitle =>
      'Tap to ask Google Play whether billing is reachable on this phone. Nothing is bought.';

  @override
  String get plusProbeRunning => 'Asking Google Play…';

  @override
  String get plusProbeAvailable => 'Play Billing reachable: yes';

  @override
  String get plusProbeUnavailable =>
      'Play Billing reachable: no (no Play Store on this device, or not signed in)';

  @override
  String get plusProbeProductFound =>
      'Product femio_plus found in Play Console';

  @override
  String get plusProbeProductMissing =>
      'Product femio_plus not found yet (expected until it is created in Play Console)';

  @override
  String get assistantPrivateNote =>
      'This runs on your phone. Your words are not saved or sent anywhere.';

  @override
  String get assistantModelNote =>
      'Gemini Nano, the AI on your phone, helped with this.';

  @override
  String get sayItButton => 'Say it in your words';

  @override
  String get sayItTitle => 'How are you feeling?';

  @override
  String get sayItHint =>
      'For example: bad cramps, light bleeding and so tired';

  @override
  String get sayItAction => 'Turn into log entries';

  @override
  String get sayItNothing =>
      'femio found nothing to log in that. Try other words, or tap the symptoms on the Log screen.';

  @override
  String get sayItFound => 'femio found these. Untick anything that is wrong.';

  @override
  String get sayItAdd => 'Add to this day\'s log';

  @override
  String get sayItAdded => 'Added to your log.';

  @override
  String get sayItDictationHint =>
      'Tip: tap the microphone on your keyboard to speak instead of typing.';

  @override
  String get sayItFoundDays =>
      'femio found these days. Untick anything that is wrong, or remove a whole day. Nothing is saved until you tap the button below.';

  @override
  String get sayItRemoveDay => 'Remove this day';

  @override
  String sayItSaveCount(int entries, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      entries,
      locale: localeName,
      other: '$entries entries',
      one: '1 entry',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'Save $_temp0 on $_temp1';
  }

  @override
  String get sayItFuture =>
      'femio can\'t log a day that hasn\'t happened yet, so that part of your note was left out.';

  @override
  String sayItTooOld(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return 'femio logs up to $_temp0 back, so older days in your note were left out.';
  }

  @override
  String get safetyCrisisHeading => 'You don\'t have to face this alone';

  @override
  String get safetyCrisisBody =>
      'If you are thinking about harming yourself, please reach out now. The help page lists crisis lines for your country.';

  @override
  String get safetyUrgentHeading => 'This may need urgent care';

  @override
  String get safetyUrgentBody =>
      'Chest pain, trouble breathing, fainting or a seizure need medical help now. Call your local emergency number.';

  @override
  String get safetyBirthControl =>
      'femio is not a way to avoid pregnancy and can\'t advise on it. A doctor, pharmacist or family-planning clinic can help you choose a method.';

  @override
  String get askDiagnosisHeading => 'Only a clinician can tell';

  @override
  String get askDiagnosisBody =>
      'femio can\'t tell whether you have a condition. A doctor can, after talking with you and, if needed, an examination or tests. Here is what trusted sources say about it.';

  @override
  String get safetyHeavyBleedingHeading => 'Heavy bleeding with dizziness';

  @override
  String get safetyHeavyBleedingBody =>
      'ACOG says: “If you are changing pads or tampons every hour for more than 2 hours in a row, and you also have chest pain, have shortness of breath, and are lightheaded or dizzy, seek emergency medical care right away.” If that is you, call your local emergency number now. If heavy bleeding worries you, talk to your doctor.';

  @override
  String get safetyPostpartumHeading => 'A warning sign after birth';

  @override
  String get safetyPostpartumBody =>
      'In the year after birth, CDC\'s Hear Her campaign says to get medical care immediately for an urgent warning sign, such as heavy bleeding, a fever, a headache that won\'t go away or a swollen leg. Call your doctor or midwife now, or your local emergency number.';

  @override
  String get askTitle => 'Ask femio';

  @override
  String get askIntro =>
      'Ask a health question. femio answers only from trusted health sources it carries on your phone, such as CDC, MedlinePlus and the Office on Women\'s Health, and shows where every sentence came from.';

  @override
  String get askHint => 'For example: what helps with period cramps?';

  @override
  String get askAction => 'Ask';

  @override
  String get askWillSend =>
      'This is exactly the question that will be sent, with the public sources:';

  @override
  String get askSend => 'Summarise with Cloud boost';

  @override
  String get askStillPersonal =>
      'This still mentions you. Remove words like “I” or “my” and any personal details.';

  @override
  String get askCloudPrivacy =>
      'Only this question and the public sources are sent. Nothing from your log is.';

  @override
  String get askSearching => 'Reading trusted sources…';

  @override
  String get askSourcesTitle => 'Sources';

  @override
  String get askClinicianLine =>
      'This is general information, not advice for you. For your own situation, talk to your clinician.';

  @override
  String get askRelatedGuides => 'femio guides on this';

  @override
  String get askSearchAgain => 'Ask another question';

  @override
  String get askAboutYouStays =>
      'Your question is about you, so it stays on this phone. Here are the sources word for word.';

  @override
  String get askModelFellBack =>
      'The AI could not write an answer that cites its sources, so here they are word for word.';

  @override
  String get askBoostHeading => 'Cloud boost';

  @override
  String get askBoostConfirm =>
      'This phone has no on-phone AI. With Cloud boost, Google\'s cloud AI can summarise these public sources for you. Check the question first.';

  @override
  String get askReadSourcesInstead => 'Read the sources instead';

  @override
  String get askNotCoveredHeading => 'Not covered yet';

  @override
  String get askNotCovered =>
      'femio\'s trusted sources don\'t answer this, so femio won\'t guess. Try other words, read the links below, or ask your clinician.';

  @override
  String askRegistryVersion(String version) {
    return 'Trusted sources library $version';
  }

  @override
  String get askAnswerOnPhone =>
      'Summarised on your phone by Gemini Nano, from the sources below';

  @override
  String get askAnswerCloud =>
      'Summarised by Google\'s cloud AI (Cloud boost), from the sources below';

  @override
  String get askVerbatimLabel => 'Word for word from trusted sources';

  @override
  String get askEnglishNote =>
      'These sources are in English. femio shows them word for word so nothing is lost in translation.';

  @override
  String get askReadMore => 'Read more from trusted organisations';

  @override
  String askSourceCopied(String publisher, String date) {
    return '$publisher · copied $date';
  }

  @override
  String askSourceReviewed(String publisher, String date) {
    return '$publisher · reviewed $date';
  }

  @override
  String get visitButton => 'Visit summary';

  @override
  String get visitTitle => 'Visit summary';

  @override
  String get visitIntro =>
      'A page to show your clinician, made from what you logged. It stays on your phone unless you share or copy it.';

  @override
  String visitCycles(int count, int longest, int shortest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cycles logged: $shortest to $longest days',
      one: '1 cycle logged: $shortest days',
      zero: 'No complete cycle logged yet',
    );
    return '$_temp0';
  }

  @override
  String visitLastPeriod(String date) {
    return 'Last period started $date';
  }

  @override
  String get visitIrregular => 'Cycles described as irregular';

  @override
  String get visitTopTerms => 'Logged most in the last 90 days';

  @override
  String visitDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get visitHeavyDays => 'Days with heavy flow';

  @override
  String get visitOpkPositive => 'Positive ovulation tests';

  @override
  String get visitTemperatureDays => 'Days with a waking temperature';

  @override
  String get visitTryingFor => 'Trying to conceive';

  @override
  String get visitQuestionsTitle => 'Questions you could ask';

  @override
  String get visitCopy => 'Copy as text';

  @override
  String get visitCopied => 'Copied. Paste it into a message or your notes.';

  @override
  String get visitQ_cycleSpread =>
      'My cycle lengths vary. Is that worth looking into?';

  @override
  String get visitQ_ttcTests =>
      'Given how long I have been trying, which checks would you suggest?';

  @override
  String get visitQ_ovulation => 'How can I find out whether I am ovulating?';

  @override
  String get visitQ_folicAcid => 'Should I be taking folic acid now?';

  @override
  String get visitQ_painfulPeriods =>
      'My period pain affects my days. What can help?';

  @override
  String get visitQ_heavyPeriods =>
      'My periods are heavy. Is a blood test worth doing?';

  @override
  String get visitQ_moodCycle =>
      'My mood changes a lot around my period. Can we talk about it?';

  @override
  String get visitQ_skinHair =>
      'I have skin or hair changes along with irregular cycles. Should these be checked together?';

  @override
  String get visitQ_tiredness =>
      'I often feel tired. Is anything worth checking?';

  @override
  String get visitQ_menopause =>
      'Could my symptoms be linked to perimenopause, and what are my options?';

  @override
  String get visitQ_pregnancyNext =>
      'What should I look out for before our next visit?';

  @override
  String get visitQ_pregnancyMovements =>
      'When should I start paying attention to the baby\'s movements?';

  @override
  String get visitQ_anythingElse =>
      'Is there anything in my log you would like to look at more closely?';

  @override
  String get assistantSettingsTitle => 'Assistant';

  @override
  String get assistantSettingsSub =>
      'AI on your phone, trusted sources and Cloud boost';

  @override
  String get assistantOnDeviceTitle => 'AI on your phone (Gemini Nano)';

  @override
  String get assistantOnDeviceAvailable =>
      'Ready. It reads your notes on the phone; nothing is sent.';

  @override
  String get assistantOnDeviceDownloadable =>
      'Can be downloaded to this phone.';

  @override
  String get assistantOnDeviceDownloading => 'Downloading…';

  @override
  String get assistantOnDeviceUnavailable =>
      'Not available on this phone. femio uses its own word list on the phone instead.';

  @override
  String get assistantDownload => 'Download';

  @override
  String get assistantCloudTitle => 'Cloud boost';

  @override
  String get assistantCloudOn =>
      'On. Used only when this phone has no on-phone AI.';

  @override
  String get assistantCloudOff => 'Off. Everything is done on this phone.';

  @override
  String get assistantHowItWorks =>
      'Your log stays on your phone. Your notes and your log are read by femio\'s rules and, where your phone has it, by Gemini Nano on the phone. Safety rules always come first: signs of danger open the help page, and femio never advises on avoiding pregnancy. Ask femio answers only from trusted health sources carried in the app and shows them with every answer. Cloud boost is off unless you agree to it; then only what its screen lists is sent to Google.';

  @override
  String get assistantCloudNotBuilt =>
      'Not available in this version of the app.';

  @override
  String get boostTitle => 'Cloud boost';

  @override
  String get boostIntro =>
      'Some phones have no on-phone AI. On those phones, Cloud boost lets Google\'s cloud AI summarise trusted sources for a question you approve, or put your tips in order. It is optional and stays off unless you agree below. Everything else in femio works without it.';

  @override
  String get boostSendsHeading => 'What may be sent';

  @override
  String get boostStageLabel => 'Life stage';

  @override
  String boostStage(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'period': 'Tracking periods',
      'ttc': 'Trying to conceive',
      'pregnant': 'Pregnant',
      'postpartum': 'After birth',
      'menopause': 'Menopause',
      'other': 'Not set',
    });
    return '$_temp0';
  }

  @override
  String get boostRegularityLabel => 'Cycle regularity';

  @override
  String boostRegularity(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'regular': 'Regular',
      'variable': 'Varies',
      'unknown': 'Not known yet',
      'notApplicable': 'Not tracked now',
      'other': 'Not known yet',
    });
    return '$_temp0';
  }

  @override
  String get boostCategoriesLabel =>
      'Kinds of symptom logged in the last month';

  @override
  String boostCategory(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'pain': 'Pain',
      'mood': 'Mood',
      'digestion': 'Digestion',
      'sleepAndEnergy': 'Sleep and energy',
      'skinAndHair': 'Skin and hair',
      'hotFlashes': 'Hot flushes',
      'bladder': 'Bladder',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get boostNone => 'None';

  @override
  String get boostStreakLabel => 'Logging streak';

  @override
  String boostStreak(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'none': 'None',
      'underAWeek': 'Under a week',
      'weeks': 'A few weeks',
      'overAMonth': 'Over a month',
      'other': 'None',
    });
    return '$_temp0';
  }

  @override
  String get boostNeverHeading => 'What is never sent';

  @override
  String get boostNever =>
      'Your notes, dates, log entries, cycle lengths, name, email, contacts or advertising ID.';

  @override
  String get boostTurnOff => 'Turn off Cloud boost';

  @override
  String get boostNotNow => 'Not now';

  @override
  String get boostAgreeQuestions =>
      'I agree that femio may send a general question I approve, one at a time, with the public sources it found, so Google\'s cloud AI can summarise them. femio removes numbers, dates, names and contacts first, and I see the exact text before it goes.';

  @override
  String get boostAgreeTips =>
      'I agree that femio may send these four broad facts about my health, exactly as shown, so Google\'s cloud AI can put my tips in order. This happens in the background while Cloud boost is on.';

  @override
  String get boostPurposeQuestions => 'General questions';

  @override
  String get boostPurposeTips => 'Tips from four broad facts';

  @override
  String get boostWhoHeading => 'Who receives it, and where';

  @override
  String get boostWho =>
      'Google processes it for femio through Firebase AI Logic (the Gemini Developer API, paid tier). Google may process it in the United States or other countries where it has servers, under its data processing terms. femio (KM Digital Labs, Cairo, Egypt) decides what is sent and is responsible for it.';

  @override
  String get boostKeptHeading => 'How long it is kept';

  @override
  String get boostKept =>
      'femio has no server and keeps none of it. Under the paid terms femio uses, Google does not use it to improve its products. Google keeps it for up to 55 days to detect misuse, and people at Google may review content that its systems flag as misuse.';

  @override
  String get boostAlsoSeen =>
      'Like any internet connection, Google also sees your phone\'s internet address, and a check from Google Play that the request comes from the real femio app.';

  @override
  String get boostChoiceHeading => 'Your choice';

  @override
  String get boostChoice =>
      'Agreeing is optional, and you can agree to one use and not the other. You can turn Cloud boost off at any time, here or in Settings › Assistant, as easily as you turned it on. Each phone asks again: a restored backup does not carry your agreement.';

  @override
  String get boostReadNotice => 'Read the privacy notice';

  @override
  String get boostExplicit =>
      'These facts and questions are about your health. By ticking a box and pressing I agree, you give your explicit consent to that use only. femio keeps a dated record of your choice on this phone, which you can see here.';

  @override
  String get boostAgree => 'I agree';

  @override
  String get boostReceiptHeading => 'Your agreement';

  @override
  String boostReceipt(String date, String purposes) {
    return 'You agreed on $date to: $purposes.';
  }

  @override
  String get boostWithdrawEffect =>
      'Turning it off stops anything new being sent. It cannot recall what was already sent.';

  @override
  String get tip_trackDatesHelps =>
      'Noting your period dates in the app helps you see your own pattern and gives a clinician clear facts.';

  @override
  String get tip_periodLongerThanSeven =>
      'A period that lasts longer than 7 days is worth mentioning to a clinician.';

  @override
  String get tip_bleedingBetweenPeriods =>
      'Bleeding between periods is worth mentioning to a clinician, so the cause can be looked into.';

  @override
  String get tip_irregularCheckIn =>
      'Cycles shorter than 21 or longer than 35 days are called irregular. Mention this to a clinician, who can look at your dates with you.';

  @override
  String get tip_stoppedThreeMonths =>
      'A period that stops for more than three months without a clear reason is worth a clinician\'s check, whatever your age.';

  @override
  String get tip_irregularWithOtherSigns =>
      'Irregular periods together with other changes, such as weight gain, extra hair on your face, or dry or oily skin, are worth mentioning to a clinician.';

  @override
  String get tip_periodPainSeeClinician =>
      'Period pain that stops you doing your usual daily activities is a reason to see a clinician.';

  @override
  String get tip_severePainUrgent =>
      'If pelvic or period pain is severe or worse than usual and painkillers have not helped, ask for urgent medical advice.';

  @override
  String get tip_symptomDiaryBeforeVisit =>
      'Before a visit about period problems, a diary of your symptoms across the whole cycle gives your clinician a detailed picture of what happens and when.';

  @override
  String get tip_heavyOrTired =>
      'Periods that keep you from daily activities, or leave you tired or short of breath a lot, can be signs of heavy periods. A clinician can help.';

  @override
  String get tip_pmsDiary =>
      'Keeping a diary of your symptoms for at least two cycles helps a clinician see whether they follow your period.';

  @override
  String get tip_headachesAroundPeriod =>
      'Migraines that come regularly before or during your period are worth mentioning to a clinician. A diary next to your period dates helps.';

  @override
  String get tip_urineInfectionSeeClinician =>
      'If you think you may have a urine infection, it is important to see a clinician. A urine test can tell.';

  @override
  String get tip_leakingUrineTellClinician =>
      'If you leak urine, it is worth telling a clinician, whatever the type or cause.';

  @override
  String get tip_cervicalScreeningTip =>
      'WHO advises cervical screening every 5 to 10 years from age 30; local programmes vary. Ask your clinic whether you are due.';

  @override
  String get tip_ttcOneYear =>
      'If a year of trying has passed without a pregnancy, it is a good idea to see a clinician and have the common causes checked.';

  @override
  String get tip_ttcAgeSixMonths =>
      'At 35 or older, it is advised to see a clinician after six months of trying, not twelve.';

  @override
  String get tip_ttcIrregularNoWait =>
      'With irregular or no periods, it is worth talking to a clinician about trying to conceive without waiting a full year.';

  @override
  String get tip_regularSexTakesTime =>
      'Most couples where the woman is under 40 conceive within a year of regular sex every 2 to 3 days. It can take time.';

  @override
  String get tip_testingTooEarly =>
      'Testing very early can give a false negative. Follow the test\'s own instructions.';

  @override
  String get tip_folicAcidBeforePregnancy =>
      'Folic acid, a B vitamin, is advised from at least a month before pregnancy. Ask a clinician how to get enough.';

  @override
  String get tip_talkBeforeTrying =>
      'It is a good idea to talk to a clinician before trying to get pregnant. They can help you get your body ready.';

  @override
  String get tip_tryingIsStressful =>
      'Trying to conceive can be stressful. Counselling and support groups may help you cope; you can ask a clinician about them.';

  @override
  String get tip_movementsChangeCallNow =>
      'If your baby moves less than usual or the usual pattern changes, call your midwife or maternity unit at once, even in the middle of the night.';

  @override
  String get tip_firstMovementsBy24 =>
      'You should start to feel your baby move between 16 and 24 weeks. If there has been no movement by 24 weeks, tell your midwife.';

  @override
  String get tip_preeclampsiaSigns =>
      'A severe headache that painkillers do not ease, vision problems, pain below the ribs or sudden swelling need checking at once. Call your maternity unit.';

  @override
  String get tip_antenatalChecksMatter =>
      'Blood pressure and urine checks at antenatal visits can find changes you cannot feel, so try to keep every appointment.';

  @override
  String get tip_screeningVersusDiagnostic =>
      'Two kinds of tests are offered to every pregnant woman: screening tests, which show a chance, and follow-up tests, which give a firmer answer. Ask which suit you.';

  @override
  String get tip_glucoseScreening =>
      'All pregnant women should be screened for gestational diabetes. Ask your midwife or doctor when yours is planned.';

  @override
  String get tip_rhBloodGroup =>
      'A simple blood test shows your blood type and Rh status, usually at your first antenatal visit. Ask what yours is and whether it matters for your care.';

  @override
  String get tip_mainScanBetween18And21 =>
      'A detailed scan is usually done between 18 and 21 weeks. It checks your baby\'s growth and looks for certain conditions.';

  @override
  String get tip_severeSicknessTellEarly =>
      'If you are being sick often and cannot keep food down, tell your midwife or doctor as soon as you can, so they can help you keep fluids down.';

  @override
  String get tip_itchTellMidwife =>
      'Itching is common in pregnancy, but it can be the first sign of a liver condition called ICP. Tell your midwife or doctor so it can be checked.';

  @override
  String get tip_pretermLabourSigns =>
      'Signs of early labour include contractions every 10 minutes or more often, leaking fluid or bleeding, pelvic pressure and a low, dull backache. Contact your midwife, doctor or maternity unit.';

  @override
  String get tip_tirednessInPregnancy =>
      'Tiredness in pregnancy has many causes, and anaemia is one of them. Mention ongoing tiredness to your midwife or doctor.';

  @override
  String get tip_lowMoodPerinatal =>
      'Feeling low is common in pregnancy and after birth, and support is available. Tell your midwife or doctor, even if you only have some of the signs.';

  @override
  String get tip_anxietyInPregnancy =>
      'Anxiety in pregnancy can often be helped with talking therapy. Tell your midwife or doctor how you really feel.';

  @override
  String get tip_warningSignsPregnancyAndYear =>
      'Some warning signs need care at once, in pregnancy and for a year after birth: a headache that will not go away, vision changes, fever, trouble breathing, severe belly pain.';

  @override
  String get tip_postnatalCheckSixToEight =>
      'A postnatal check around 6 to 8 weeks after birth makes sure you feel well and are recovering. Write down your questions to take along.';

  @override
  String get tip_painfulFeedsGetHelp =>
      'If you are putting off feeds because breastfeeding hurts, get help from a lactation consultant.';

  @override
  String get tip_tirednessAfterBirthThyroid =>
      'Tiredness after birth has many causes. Thyroid inflammation affects about 1 in 20 women in the first year after birth, so mention lasting tiredness to a clinician.';

  @override
  String get tip_bleedingUpToSixWeeks =>
      'Spotting or bleeding like a period, on and off, can last up to six weeks after birth. Tell a clinician if you are worried.';

  @override
  String get tip_babyBluesPassing =>
      'Feeling down, anxious or irritable for a few days after birth is very common and usually passes within 2 weeks. If it lasts longer, tell a clinician.';

  @override
  String get tip_periodChangesFirstSign =>
      'A change in your periods is usually one of the first signs of perimenopause. They may come more or less often, and be heavier or lighter.';

  @override
  String get tip_twelveMonthsMeansMenopause =>
      'Menopause means 12 months without a period. In the years before, cycles often vary, with longer or shorter gaps.';

  @override
  String get tip_bleedingAfterMenopause =>
      'Bleeding after menopause, meaning 12 months with no period, is important to tell a clinician about, so the cause can be found.';

  @override
  String get tip_hotFlushesTalkOptions =>
      'If lifestyle changes are not enough for hot flushes, contact a clinician. They will talk through your symptoms, history and preferences.';

  @override
  String get tip_boneStrengthMenopause =>
      'Loss of bone density is more likely around menopause. Ask a clinician about bone health and what suits you.';

  @override
  String get tip_drynessManyTreatments =>
      'There are many treatments for vaginal dryness. It is worth asking a clinician what could suit you.';

  @override
  String get tip_heartbeatAroundMenopause =>
      'A faster or more noticeable heartbeat can be part of perimenopause and menopause. Note when it happens and tell a clinician.';

  @override
  String get tip_lowMoodMenopause =>
      'Low mood and anxiety can be part of the menopause transition. If they are hard to manage, talk to a clinician.';

  @override
  String get visitQ_periodsStoppedChecks =>
      'My periods have become very infrequent or have stopped. Which checks could find out why?';

  @override
  String get visitQ_irregularCauses =>
      'What could explain my irregular cycles, and would any tests or scans help?';

  @override
  String get visitQ_irregularAcneChecks =>
      'I have irregular periods and acne. Which checks could look for a cause?';

  @override
  String get visitQ_painCauseChecks =>
      'My period pain keeps getting in the way of my days. Which checks could find out why?';

  @override
  String get visitQ_heavyAndTiredBloodTest =>
      'My periods may be heavy and I feel tired a lot. Should I have blood tests, for example for iron?';

  @override
  String get visitQ_diaryReviewCycle =>
      'Can we go through my symptom diary to see whether my symptoms follow my cycle?';

  @override
  String get visitQ_headacheDiaryReview =>
      'My migraines often come around my period. Can we look at my diary together?';

  @override
  String get visitQ_cervicalScreeningDue =>
      'Am I up to date with cervical screening, and which test does your clinic use?';

  @override
  String get visitQ_checksForCouple =>
      'Which fertility checks do you suggest for me, and for a partner if I have one?';

  @override
  String get visitQ_ttcOverThirtyFiveSooner =>
      'I am 35 or older and have been trying for about six months or more. Should I start fertility checks now?';

  @override
  String get visitQ_irregularTryingNow =>
      'My cycles are irregular and I am trying to conceive. Should we talk about help now rather than waiting a year?';

  @override
  String get visitQ_preconceptionReview =>
      'We are planning a pregnancy. Is there anything in my health or medicines to review first?';

  @override
  String get visitQ_ttcSupportOptions =>
      'Trying to conceive is weighing on me. Where can I find counselling or support?';

  @override
  String get visitQ_pregnancyTestsOffered =>
      'Which screening tests and follow-up tests are offered in my pregnancy, and what does each one tell me?';

  @override
  String get visitQ_glucoseTestWhen =>
      'When will I be tested for gestational diabetes, and could it be earlier for me?';

  @override
  String get visitQ_movementsCallWho =>
      'Who do I call if my baby\'s movements change, including at night?';

  @override
  String get visitQ_sameDayWarningSigns =>
      'Which signs should make me call the maternity unit the same day?';

  @override
  String get visitQ_rhFactorChecked =>
      'Has my blood group and Rh factor been checked, and does it change anything in my care?';

  @override
  String get visitQ_pregnancyLowMoodSupport =>
      'I have felt low or very worried for a while. What support is available?';

  @override
  String get visitQ_severeSicknessHelp =>
      'My sickness makes it hard to keep food and drink down. What help is available?';

  @override
  String get visitQ_itchBloodTests =>
      'I have had itching in pregnancy. Should I have blood tests to check my liver?';

  @override
  String get visitQ_pretermSignsPlan =>
      'Which signs of early labour should make me call or come in, and where do I go out of hours?';

  @override
  String get visitQ_postnatalCheckTalk =>
      'Can we go through how I am recovering, including bleeding, pain, mood and bladder changes?';

  @override
  String get visitQ_postnatalMoodHelp =>
      'I have felt low or anxious since the birth. What help is there?';

  @override
  String get visitQ_latchCheck =>
      'Feeding hurts. Could someone watch a feed and check how my baby latches?';

  @override
  String get visitQ_warningSignsYearAfter =>
      'Which symptoms in the year after birth should make me seek care at once?';

  @override
  String get visitQ_thyroidAfterBirth =>
      'I have felt very tired since the birth. Should my thyroid be checked with a blood test?';

  @override
  String get visitQ_urineLeaksHelp =>
      'I leak urine. What can help, and would pelvic floor exercises suit me?';

  @override
  String get visitQ_hotFlushOptions =>
      'Hot flushes or night sweats are affecting my days. What options could we talk through?';

  @override
  String get visitQ_changedBleedingChecks =>
      'My bleeding pattern has changed. Which checks are worth doing?';

  @override
  String get visitQ_bleedingAfterMenopauseChecks =>
      'I have had bleeding or spotting at this stage. What checks do I need, and how soon?';

  @override
  String get visitQ_boneAndHeartHealth =>
      'What can I do to protect my bone and heart health at this stage?';

  @override
  String get visitQ_drynessWhatHelps =>
      'I have vaginal dryness or discomfort. What can help, and what needs checking?';

  @override
  String get visitQ_urineTestAgain =>
      'My urine symptoms keep coming back. Should I have a urine test, and how can we find the cause?';

  @override
  String get visitQ_thyroidCheckIrregular =>
      'My periods are irregular and my hair is thinning. Should my thyroid be checked with a blood test?';

  @override
  String get tipsTitle => 'For you';

  @override
  String tipsSource(String publisher) {
    return 'Source: $publisher';
  }

  @override
  String get tipsChosenOnPhone =>
      'Chosen on your phone from your log. Each tip is a reviewed sentence with its source.';

  @override
  String get tipsOrderedCloud =>
      'Put in order with Cloud boost, from broad facts only.';

  @override
  String get legendPossible => 'Period possible (low confidence)';

  @override
  String get confidenceLowShort => 'Low confidence';

  @override
  String get upcomingPeriodsTitle => 'Next periods';

  @override
  String get upcomingPeriodsWider =>
      'Each later period is a wider range: the further ahead, the less certain.';

  @override
  String get upcomingPeriodsOnlyNext =>
      'Only the next period is shown: your logged cycles vary too much, or there are too few yet, to reach further ahead.';

  @override
  String get todayUrgentBody =>
      'If something feels severe or sudden, get care now. The emergency numbers for your country are one tap away.';

  @override
  String get toolsTitle => 'Calculators';

  @override
  String get toolsSub =>
      'These calculators give general estimates for learning and planning, not medical advice. Talk to your clinician about your health.';

  @override
  String get toolDueTitle => 'Due date calculator';

  @override
  String get toolDueDesc =>
      'From your last period, conception, an IVF transfer or a scan.';

  @override
  String get toolCalTitle => 'Pregnancy calendar';

  @override
  String get toolCalDesc =>
      'The dates of every pregnancy week, with each week\'s guide.';

  @override
  String get toolGainTitle => 'Pregnancy weight gain';

  @override
  String get toolGainDesc =>
      'The reference range for your BMI before pregnancy.';

  @override
  String get toolDueMethodLabel => 'How do you know the date?';

  @override
  String get toolDueMethodLmp => 'Last period';

  @override
  String get toolDueMethodConception => 'Conception';

  @override
  String get toolDueMethodTransfer => 'IVF transfer';

  @override
  String get toolDueMethodScan => 'Dating scan';

  @override
  String get toolEmbryoLabel => 'Embryo age at transfer';

  @override
  String get toolEmbryo3 => 'Day 3';

  @override
  String get toolEmbryo5 => 'Day 5';

  @override
  String get toolPromptLmp => 'Tap the day your last period started';

  @override
  String get toolPromptConception => 'Tap the day you conceived';

  @override
  String get toolPromptTransfer => 'Tap the day of the embryo transfer';

  @override
  String get toolPromptScan => 'Tap the day of your scan';

  @override
  String get toolCycleLabel => 'Cycle length';

  @override
  String toolDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '$count day',
    );
    return '$_temp0';
  }

  @override
  String get toolScanWeeksLabel => 'Weeks on the scan report';

  @override
  String get toolScanDaysLabel => 'Extra days on the report';

  @override
  String toolWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '$count week',
    );
    return '$_temp0';
  }

  @override
  String toolTermWindow(String start, String end) {
    return 'Most babies arrive between $start and $end.';
  }

  @override
  String get toolScanNote =>
      'This uses the weeks and days on your scan report as written. If your clinician has given you a due date, follow theirs.';

  @override
  String get toolEstimateNote =>
      'These dates are estimates based on the date you entered. Every body is different.';

  @override
  String get toolClinicianAdjust =>
      'Your clinician may adjust the date after a scan.';

  @override
  String get toolCalMethodLabel => 'Which date do you know?';

  @override
  String get toolCalMethodEdd => 'Due date';

  @override
  String get toolCalMethodLmp => 'Last period';

  @override
  String get toolCalPromptEdd => 'Tap your due date';

  @override
  String get toolCalEyebrow => 'Your pregnancy, week by week';

  @override
  String toolCalTrimesterLine(String second, String third) {
    return 'Second trimester from $second; third trimester from $third.';
  }

  @override
  String toolCalWeek(String week) {
    return 'Week $week';
  }

  @override
  String get toolCalCurrent => 'This week';

  @override
  String toolCalReadGuide(String week) {
    return 'Read the week $week guide';
  }

  @override
  String get toolGainIntro =>
      'Enter your weight before pregnancy and your height to see the reference range for total weight gain over the pregnancy, from the Institute of Medicine (2009). Nothing is stored.';

  @override
  String get toolGainWeight => 'Weight before pregnancy (kg)';

  @override
  String get toolGainHeight => 'Height (cm)';

  @override
  String get toolGainBabiesLabel => 'How many babies?';

  @override
  String get toolGainBabiesOne => 'One';

  @override
  String get toolGainBabiesTwo => 'Twins';

  @override
  String get toolGainBabiesMore => 'Three or more';

  @override
  String toolGainBmiLine(String value, String band) {
    return 'BMI before pregnancy: $value ($band)';
  }

  @override
  String get toolBandUnderweight => 'Underweight';

  @override
  String get toolBandNormal => 'Healthy range';

  @override
  String get toolBandOverweight => 'Overweight';

  @override
  String get toolBandObese => 'Obese';

  @override
  String get toolGainEyebrow =>
      'Reference range for total gain over the whole pregnancy';

  @override
  String toolGainRangeKg(String low, String high) {
    return '$low to $high kg';
  }

  @override
  String toolGainRangeLb(String low, String high) {
    return '$low to $high lb';
  }

  @override
  String toolGainOtherUnit(String range) {
    return 'That is $range.';
  }

  @override
  String get toolGainNoRangeTwins =>
      'The Institute of Medicine gives no range for twins when BMI before pregnancy is under 18.5. Your clinician will advise.';

  @override
  String get toolGainNoRangeMultiples =>
      'The Institute of Medicine gives no range for three or more babies. Your clinician will advise.';

  @override
  String get toolGainNote =>
      'This is a reference range for your BMI band before pregnancy, not a target or a judgement. Your clinician may suggest a different range for you.';

  @override
  String get toolGainSource =>
      'Source: Institute of Medicine (2009), \"Weight Gain During Pregnancy\"; the same ranges are used by CDC and ACOG.';

  @override
  String toolGainOutOfRange(
    String minW,
    String maxW,
    String minH,
    String maxH,
  ) {
    return 'Enter a weight from $minW to $maxW kg and a height from $minH to $maxH cm.';
  }

  @override
  String get toolNothingSaved => 'Nothing you enter here is saved.';

  @override
  String get updateBannerBody => 'A new version of femio is ready.';

  @override
  String get updateBannerAction => 'Update';

  @override
  String get leaveTitle => 'What can leave this phone';

  @override
  String get leaveIntro =>
      'Your records stay on this phone. These are the only times femio, or the Google services it relies on, use the internet.';

  @override
  String get leaveBoostOff => 'Off';

  @override
  String leaveBoostOn(String purposes) {
    return 'On for: $purposes';
  }

  @override
  String get leaveBoostBody =>
      'Only if you agree: a general question you approve, or four broad facts, goes to Google\'s cloud AI. Google Play also confirms the request comes from the real femio app.';

  @override
  String get leaveModelHeading => 'The on-phone AI model';

  @override
  String get leaveModelBody =>
      'If you tap Download, Android\'s AI service (AICore, run by Google) downloads Gemini Nano and keeps it up to date. Google\'s AI software may also send Google technical information, such as errors and performance. femio adds none of your records to it.';

  @override
  String get leavePlayHeading => 'Google Play';

  @override
  String get leavePlayBody =>
      'Google Play installs and updates femio, may show its rating request, and handles femio Plus payments. It tells us only totals, such as installs and crashes. femio sends Google Play nothing of yours.';

  @override
  String get leaveBackupHeading => 'Your backup';

  @override
  String get leaveBackupBody =>
      'A backup, with the documents and photos you added, goes only where you choose to save it, sealed with your passphrase.';

  @override
  String get leaveLinksHeading => 'Links you open';

  @override
  String get leaveLinksBody =>
      'Sources and pages you open go to your browser, which visits that website.';

  @override
  String get leaveNever =>
      'Nothing else leaves. femio has no ads, no analytics, no tracking tools and no account.';

  @override
  String get leaveSettingsSub => 'Every way anything reaches the internet';

  @override
  String get assistantMasterTitle => 'Use the assistant';

  @override
  String get assistantMasterOff =>
      'Off: femio answers from its rules and guides only. No AI runs, on the phone or in the cloud.';

  @override
  String get assistantMasterOn =>
      'On: the AI adds explanations beside femio\'s own answers. Everything works without it.';

  @override
  String get aiSeesTitle => 'What the AI can see';

  @override
  String get aiSeesSub => 'Each AI feature, where it runs and what it receives';

  @override
  String get aiSeesIntro =>
      'The AI never sees your whole record. Each feature receives only the items listed under it, and femio\'s own safety rules always answer first.';

  @override
  String get aiSeesOff => 'The assistant is off, so none of these run.';

  @override
  String get aiUseAskInCloud => 'Ask femio with Cloud boost';

  @override
  String get aiUseTips => 'Tips for you';

  @override
  String get aiWherePhone => 'Runs on this phone only';

  @override
  String get aiWhereHybrid =>
      'On this phone, or in Google\'s cloud only if you agreed to Cloud boost';

  @override
  String get aiWriteNone => 'Never changes your record';

  @override
  String get aiWriteDraft =>
      'Suggests a draft; nothing is saved until you check it and tap Save';

  @override
  String get aiSeesLabel => 'What it receives';

  @override
  String get aiSeesHerQuestion => 'The question you typed';

  @override
  String get aiSeesPassages =>
      'Passages from femio\'s trusted sources (public text, not yours)';

  @override
  String get aiSeesNote => 'The note you typed';

  @override
  String get aiSeesBands =>
      'Four broad facts: life stage, cycle regularity, kinds of symptom, logging streak';

  @override
  String get aiSeesIds =>
      'femio\'s own reviewed tips or questions, to put in order';

  @override
  String get aiSeesVisitFacts =>
      'Your visit summary: goal, cycles counted, shortest and longest cycle, last period date, regularity';

  @override
  String get aiSeesApprovedQuestion =>
      'Your question; in the cloud, only the version you approved, with numbers, dates and names removed';

  @override
  String get assistIntroTitle => 'Meet femio\'s assistant';

  @override
  String get assistIntroPhone =>
      'It works on this phone. It answers from femio\'s trusted sources, turns a sentence into log entries, and suggests questions for your visits. Your records stay here.';

  @override
  String get assistIntroRules =>
      'It never tells you what condition you have. femio\'s safety rules always answer first, and nothing is saved until you confirm it.';

  @override
  String get assistIntroCloudTitle => 'Cloud boost, only if you choose it';

  @override
  String get assistIntroCloudBody =>
      'If this phone cannot run the AI itself, you can let a general question you approve, or four broad facts, go to Google\'s cloud AI. It stays off unless you turn it on.';

  @override
  String get assistIntroCloudAction => 'Choose Cloud boost';

  @override
  String get assistIntroContinue => 'Continue on this phone';

  @override
  String get assistIntroSettings =>
      'You can change this, or turn the assistant off, in Settings › Assistant.';

  @override
  String get assistDoorAsk => 'Ask a question';

  @override
  String get assistDoorAskSub => 'Answers from trusted sources, with links';

  @override
  String get assistDoorSayIt => 'Say how today went';

  @override
  String get assistDoorSayItSub =>
      'One sentence becomes today\'s log; you check it first';

  @override
  String get assistDoorVisitSub =>
      'A summary of your log and questions to take along';

  @override
  String thisWeekTitle(int week) {
    return 'This week: week $week';
  }

  @override
  String weekGuideTitle(int week) {
    return 'Week $week';
  }

  @override
  String get weekSecBaby => 'Baby';

  @override
  String get weekSecBody => 'Your body';

  @override
  String get weekSecNotice => 'What you may notice';

  @override
  String get weekSecCare => 'Care around now';

  @override
  String get weekSecTip => 'Tip';

  @override
  String weekReadFull(int week) {
    return 'Read the week $week guide';
  }

  @override
  String get pregWeeksTitle => 'Your pregnancy by week';

  @override
  String get pregWeeksHint =>
      'Counted from your due date. Tap a week to read its guide.';

  @override
  String pregWeekCurrentLabel(int week) {
    return 'Week $week, your week now';
  }

  @override
  String get sectionBleedingPregnant => 'Bleeding or spotting';

  @override
  String get bleedingPregnantNote =>
      'Bleeding in pregnancy is common, but it can be a sign of something serious. Tell your midwife or doctor about any bleeding.';

  @override
  String get logAllItems => 'All log items';

  @override
  String get logAllItemsSub =>
      'Ovulation test and temperature, hidden in pregnancy';

  @override
  String get sayItHintTtc =>
      'For example: positive ovulation test, mild cramps and bloating';

  @override
  String get sayItHintPregnant =>
      'For example: morning sickness, backache and so tired';

  @override
  String get sayItHintPostpartum =>
      'For example: poor sleep, back pain and feeling low';

  @override
  String get sayItHintMenopause =>
      'For example: hot flushes, night sweats and poor sleep';

  @override
  String get askHintTtc => 'For example: when is my fertile window?';

  @override
  String get askHintPregnant =>
      'For example: what helps with heartburn in pregnancy?';

  @override
  String get askHintPostpartum =>
      'For example: what helps with sore nipples when breastfeeding?';

  @override
  String get askHintMenopause => 'For example: what helps with hot flushes?';

  @override
  String get calendarHintNoEstimates =>
      'Tap a day to log it. Days you logged are filled in.';

  @override
  String get whyRangeAction => 'Why this range?';

  @override
  String get whyRangeTitle => 'Why this range';

  @override
  String whyRangeStated(String length, String margin) {
    return 'femio cannot measure a cycle from your log yet, so it starts from the cycle length you gave: $length. The range is $margin either side.';
  }

  @override
  String whyRangeCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'femio measured $count cycles from the periods you logged.',
      one: 'femio measured 1 cycle from the periods you logged.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeAverage(String length) {
    return 'Your recent cycles average $length, so the middle of the range is $length after your last period started.';
  }

  @override
  String whyRangeSpread(String spread, String margin) {
    return 'Your shortest and longest cycles are $spread apart, so the range is $margin either side of the middle.';
  }

  @override
  String whyRangeSpreadNone(String margin) {
    return 'Your cycles have all been the same length, so the range is the narrowest femio shows: $margin either side.';
  }

  @override
  String whyRangeIrregular(String limit) {
    return 'Your cycles differ by more than $limit, so femio shows only the next period, as a wider range, and never counts days late.';
  }

  @override
  String whyRangeNextMedium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count more logged cycles that stay as steady would raise this to medium confidence.',
      one: 'One more logged cycle that stays as steady would raise this to medium confidence.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeNextHigh(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count more logged cycles that stay as steady would raise this to high confidence.',
      one: 'One more logged cycle that stays as steady would raise this to high confidence.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeHighNeedsSteady(String limit) {
    return 'High confidence needs cycles that vary by $limit or less.';
  }

  @override
  String get whyRangeWindowShown =>
      'The fertile window is counted back from the middle of this range, so it moves when the range moves.';

  @override
  String get whyRangeWindowIrregular =>
      'No fertile window is named because your cycles vary too much to count back from one date.';

  @override
  String get whyRangeWindowLearning =>
      'No fertile window is named yet: femio needs at least two cycles from your log to count back from.';

  @override
  String whyRangeWindowOutside(int min, int max) {
    return 'No fertile window is named because your cycle length is outside $min to $max days, where counting back from one date is not reliable.';
  }

  @override
  String get dayExplainLink => 'Explain this day';

  @override
  String get dayFactBleed => 'You logged bleeding on this day.';

  @override
  String get dayFactSpotting => 'You logged spotting on this day.';

  @override
  String get dayFactLogged => 'You logged symptoms or mood on this day.';

  @override
  String dayFactNextPeriod(String range) {
    return 'This day is inside the range when your next period may start: $range.';
  }

  @override
  String dayFactLaterPeriod(String range) {
    return 'This day is inside the range for a later period: $range. The further ahead, the less certain.';
  }

  @override
  String dayFactFertile(String range) {
    return 'This day is inside your estimated fertile window: $range.';
  }

  @override
  String get dayFactOvulation =>
      'femio estimates ovulation around this day, counted back from your next period. Ovulation tests and waking temperature can help you tell whether you ovulated.';

  @override
  String get dayFactNothingFuture => 'Nothing is estimated for this day.';

  @override
  String get dayFactNothingPast =>
      'Nothing is logged for this day. femio does not draw estimates on days already past.';

  @override
  String get dayLogAction => 'Log this day';

  @override
  String predictionMoved(String after, String before) {
    return 'Next period now around $after. It was $before.';
  }

  @override
  String predictionNew(String after) {
    return 'Next period around $after.';
  }

  @override
  String get predictionWhy => 'Why?';

  @override
  String get visitWorryTitle => 'What do you want to raise at this visit?';

  @override
  String get visitWorryHint =>
      'In your own words, for example: my period pain is getting worse';

  @override
  String get visitWorryFind => 'Find questions';

  @override
  String get visitWorrySuggested => 'Questions that fit what you wrote';

  @override
  String get visitWorryNone =>
      'No question in femio\'s list fits this yet. Your own words will be added as you wrote them.';

  @override
  String get visitWorryOwnWords => 'Add your own words as well';

  @override
  String get visitWorryAdd => 'Add to your visit';

  @override
  String visitWorryAddedTo(String date) {
    return 'Added to your questions for $date.';
  }

  @override
  String get visitWorryAddedNext =>
      'Added to your questions for your next visit.';

  @override
  String get visitYourQuestions => 'Your questions';

  @override
  String visitInMyWords(String text) {
    return 'In my words: $text';
  }

  @override
  String get visitRemoveQuestion => 'Remove this question';

  @override
  String get visitSecondLanguage =>
      'Add the page in a second language for the clinic';

  @override
  String get visitNoSecondLanguage => 'None';

  @override
  String get visitShare => 'Share';

  @override
  String visitMadeOn(String date) {
    return 'Made on $date from what I logged in femio. It is my own record, for us to discuss.';
  }

  @override
  String get askVisitPack => 'Prepare a visit pack';

  @override
  String get tipWhyAction => 'Why am I seeing this?';

  @override
  String get tipWhyTitle => 'Why this tip';

  @override
  String tipWhyStage(String stage) {
    String _temp0 = intl.Intl.selectLogic(stage, {
      'period': 'You are tracking your periods.',
      'ttc': 'You are trying to conceive.',
      'pregnant': 'You are pregnant.',
      'postpartum': 'You have recorded your baby\'s birth.',
      'menopause': 'You are tracking perimenopause or menopause.',
      'other': 'You chose this stage.',
    });
    return '$_temp0';
  }

  @override
  String tipWhyTerm(String term, String days, String window) {
    return 'You logged \"$term\" on $days in the last $window.';
  }

  @override
  String tipWhyPregnancyWeek(int week) {
    return 'You are $week weeks pregnant, counted from your due date.';
  }

  @override
  String tipWhyPostpartumWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your baby was born $count weeks ago.',
      one: 'Your baby was born 1 week ago.',
      zero: 'Your baby was born less than a week ago.',
    );
    return '$_temp0';
  }

  @override
  String tipWhyTryingFor(String label) {
    return 'How long you have been trying: $label.';
  }

  @override
  String get tipWhyIrregular => 'Your cycles are marked as irregular.';

  @override
  String get tipWhyRegular => 'Your cycles are not marked as irregular.';

  @override
  String tipWhyAge(int age) {
    return 'You are $age or older this year.';
  }

  @override
  String get tipWhyFootnote =>
      'These facts were read on your phone, from your own record. They are the only reasons this tip was chosen.';

  @override
  String get aiLedgerTitle => 'What the AI did';

  @override
  String get aiLedgerSub => 'Each time femio used a model, kept on this phone';

  @override
  String get aiLedgerIntro =>
      'Each time femio used a model, it is listed here, newest first. For Cloud boost, the exact text that was sent is kept as your receipt. This list stays on this phone: it is not in your backup, and \"Delete everything\" removes it.';

  @override
  String get aiLedgerEmpty => 'femio has not used a model yet.';

  @override
  String get aiLedgerOnPhone => 'On this phone (Gemini Nano)';

  @override
  String get aiLedgerInCloud => 'Sent with Cloud boost';

  @override
  String get aiLedgerNoReply =>
      'No answer came back in time, so femio used its rules.';

  @override
  String get aiLedgerSent => 'Exactly what was sent';

  @override
  String get aiLedgerClear => 'Clear this list';

  @override
  String get aiLedgerClearConfirm =>
      'Clear this list? Your record is not changed.';

  @override
  String get signsTitle => 'Signs you logged this cycle';

  @override
  String signsValueOn(String value, String date) {
    return '$value, $date';
  }

  @override
  String signsTempCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count readings this cycle',
      one: '1 reading this cycle',
    );
    return '$_temp0';
  }

  @override
  String get signsStripLine =>
      'An ovulation test strip shows a hormone surge, not proof that you ovulated. A rise in your waking temperature afterwards is a better sign.';

  @override
  String get signsNote =>
      'Each sign is shown as you logged it. femio does not say whether or when you ovulated; that is a conversation for you and your clinician.';

  @override
  String sayItChipWithSection(String section, String value) {
    return '$section: $value';
  }

  @override
  String get navAdd => 'Add';

  @override
  String get addSheetTitle => 'Add to today';

  @override
  String get addSayItPrompt =>
      'Tell femio anything, like “cramps since this morning”';

  @override
  String get addMoreToLog => 'Symptoms, discharge, tests and more';

  @override
  String get addAsk => 'Ask femio';

  @override
  String get addVisit => 'For my visit';

  @override
  String get recTitle => 'My health record';

  @override
  String get recIntro =>
      'Your own health file, kept on this phone. Each entry shows the day it happened and the day you added it, exactly as you wrote it.';

  @override
  String get recAll => 'All';

  @override
  String get recKindVisit => 'Visit';

  @override
  String get recKindLab => 'Lab result';

  @override
  String get recKindImaging => 'Scan or imaging';

  @override
  String get recKindMedicine => 'Medicine';

  @override
  String get recKindCondition => 'Condition or history';

  @override
  String get recKindAllergy => 'Allergy';

  @override
  String get recKindProcedure => 'Procedure';

  @override
  String get recKindPregnancy => 'Pregnancy';

  @override
  String get recKindDocument => 'Document';

  @override
  String get recKindNote => 'Note';

  @override
  String get recEmptyHeading => 'Nothing here yet';

  @override
  String get recEmptyBody =>
      'Add a visit, a lab result, a medicine or anything you want to keep. Entries stay on this phone and go into the backup file you save.';

  @override
  String get recAdd => 'Add an entry';

  @override
  String get recEdit => 'Edit entry';

  @override
  String get recSave => 'Save to my record';

  @override
  String get recCancel => 'Cancel';

  @override
  String get recDelete => 'Delete';

  @override
  String get recDeleteTitle => 'Delete this entry?';

  @override
  String get recDeleteBody =>
      'It is removed from this phone. A backup file you saved earlier still has it.';

  @override
  String get recFormKind => 'Type';

  @override
  String get recFormTitle => 'Title';

  @override
  String get recFormTitleHint => 'In your words, like “TSH” or “12-week scan”';

  @override
  String get recFormHappened => 'Day it happened';

  @override
  String get recFormHappenedHint =>
      'The date printed on the report, or the day of the visit.';

  @override
  String get recNeedTitle => 'Add a title';

  @override
  String get recNeedDate => 'Pick the day it happened';

  @override
  String get recFieldValue => 'Result';

  @override
  String get recFieldUnit => 'Unit';

  @override
  String get recFieldPrintedRange => 'Range printed on the report';

  @override
  String get recFieldDose => 'Dose as written';

  @override
  String get recFieldFrequency => 'How often';

  @override
  String get recFieldStartedOn => 'Started';

  @override
  String get recFieldEndedOn => 'Ended';

  @override
  String get recFieldPrescriber => 'Prescribed by';

  @override
  String get recFieldPlace => 'Where';

  @override
  String get recFieldDetails => 'Details';

  @override
  String recRowAdded(String date) {
    return 'Added $date';
  }

  @override
  String get recEdited => 'Edited';

  @override
  String get recSourceTyped => 'Typed';

  @override
  String get recSourceScanned => 'Scanned';

  @override
  String get recSourceAsk => 'From Ask femio';

  @override
  String get recSourceSayIt => 'From Say it';

  @override
  String get recSourceImported => 'Imported';

  @override
  String get recNoVerdictNote =>
      'femio keeps and shows your entries as written. It never says whether a result is normal: that is for you and your clinician.';

  @override
  String get addRecord => 'My health record';

  @override
  String get addRecordSub => 'Visits, results, medicines and documents';

  @override
  String get logNoteSection => 'Note';

  @override
  String get logNoteHint => 'Anything you want to remember about this day';

  @override
  String get logNoteSaved =>
      'Saved on this phone with the rest of your record.';

  @override
  String get csvColumnDate => 'Date';

  @override
  String get csvColumnOther => 'Other';

  @override
  String get exportCsv => 'Export as spreadsheet (CSV)';

  @override
  String get csvNotEncrypted =>
      'Unlike the backup, this file is not encrypted, so keep it somewhere private.';

  @override
  String get csvSaved => 'Spreadsheet saved.';

  @override
  String get csvNothingToExport =>
      'Nothing logged yet, so there is nothing to export.';

  @override
  String get widgetNeutralLine => 'Open femio';

  @override
  String widgetWeek(int weeks) {
    return 'Week $weeks';
  }

  @override
  String widgetNextPeriod(String range) {
    return 'Next period $range';
  }

  @override
  String get settingsWidgetDetails => 'Show details on the home-screen widget';

  @override
  String get settingsWidgetDetailsNote =>
      'Anyone who sees your phone will see them. Until you turn this on, the widget shows only femio.';

  @override
  String get recDocsHeading => 'Documents and photos';

  @override
  String get recDocsAddFile => 'Add a file';

  @override
  String get recDocsTakePhoto => 'Take a photo';

  @override
  String get recDocsFromMine => 'From my documents';

  @override
  String get recDocsNote =>
      'A PDF or a photo, up to 10 MB each. Kept sealed on this phone with the rest of your record.';

  @override
  String get recDocsTooLarge =>
      'This file is over 10 MB. Try a smaller copy, or a photo of the page.';

  @override
  String get recDocsUnsupported =>
      'femio can keep PDFs and photos (JPG, PNG or WebP).';

  @override
  String recDocsPhotoName(String date) {
    return 'Photo $date';
  }

  @override
  String get recDocsLibrary => 'My documents';

  @override
  String get recDocsLibraryEmpty =>
      'No documents yet. Add a PDF or a photo from any entry in your record.';

  @override
  String get recDocsChoose => 'Choose a document';

  @override
  String recDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return '$_temp0';
  }

  @override
  String get recDocRename => 'Rename';

  @override
  String get recDocRenameLabel => 'Name';

  @override
  String get recDocShare => 'Share';

  @override
  String get recDocShareFailed => 'The share sheet could not open.';

  @override
  String get recDocUnlink => 'Remove from this entry';

  @override
  String get recDocDelete => 'Delete document';

  @override
  String get recDocDeleteTitle => 'Delete this document?';

  @override
  String get recDocDeleteBody =>
      'It is removed from femio and from every entry it is attached to. This cannot be undone, except from a backup you saved before.';

  @override
  String get recDocUnreadable => 'This document could not be opened.';

  @override
  String get recDocPdfUnreadable =>
      'This PDF cannot be shown here. It may be protected by a password. You can still share it to open it in another app.';

  @override
  String recDocSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get recDocPrivate =>
      'Documents and photos you add stay on your phone, sealed like the rest of your record, and travel only inside the backup file you save.';

  @override
  String get backupTooLarge =>
      'Your documents come to more than 100 MB, more than one backup can carry. Delete some large ones in My documents, then save the backup again.';

  @override
  String get leaveShareHeading => 'What you share';

  @override
  String get leaveShareBody =>
      'When you share a document or your visit notes, they go only to the app you pick in the share sheet.';

  @override
  String recDocSizeKb(String size) {
    return '$size KB';
  }

  @override
  String get medTitle => 'My medicines';

  @override
  String get medIntro =>
      'Your medicines as you wrote them, the times you take them, and what you marked. femio gives no dose advice and does not check interactions: ask your pharmacist or doctor.';

  @override
  String get medAdd => 'Add a medicine';

  @override
  String get medEmptyHeading => 'No medicines yet';

  @override
  String get medEmptyBody =>
      'Add one from a prescription or a box. You choose the times; femio can remind you.';

  @override
  String get medCurrent => 'Taking now';

  @override
  String get medFinished => 'Finished';

  @override
  String get medToday => 'Today';

  @override
  String get medAsNeeded => 'When needed';

  @override
  String get medLogDose => 'I took one';

  @override
  String medTakenAt(String time) {
    return 'Taken $time';
  }

  @override
  String medTakenLater(String time) {
    return 'Taken $time, later than planned';
  }

  @override
  String get medSkippedAt => 'Not taken';

  @override
  String get medNotMarked => 'Not marked';

  @override
  String get medMarkTaken => 'Taken now';

  @override
  String get medMarkTakenAt => 'Taken at another time';

  @override
  String get medMarkSkipped => 'Not taken';

  @override
  String get medMarkClear => 'Clear the mark';

  @override
  String medDoseTitle(String name, String time) {
    return '$name at $time';
  }

  @override
  String get medTimes => 'Times you take it';

  @override
  String get medTimesNone =>
      'No set times. You can still mark a dose when you take one.';

  @override
  String get medAddTime => 'Add a time';

  @override
  String medRemoveTime(String time) {
    return 'Remove $time';
  }

  @override
  String get medRemind => 'Remind me at these times';

  @override
  String get medRemindNote =>
      'A notification at each time, and one the day before your refill day. It says \"Open the app\" unless you write your own words below.';

  @override
  String get medLabel => 'Words on the reminder (optional)';

  @override
  String get medLabelNote =>
      'These words show on your notification. Keep them vague if others see your phone.';

  @override
  String get medRefill => 'Refill by';

  @override
  String get medRefillNone => 'Not set';

  @override
  String get medRefillClear => 'Clear the refill day';

  @override
  String medRefillSoon(String date) {
    return 'Refill by $date';
  }

  @override
  String get medHistory => 'Last 14 days';

  @override
  String get medHistoryEmpty => 'Nothing marked yet.';

  @override
  String get medEdit => 'Edit details';

  @override
  String get medBlocked =>
      'femio is not a way to avoid pregnancy, so it keeps no times, marks or reminders for this medicine. It stays in your record as you wrote it.';

  @override
  String medSince(String date) {
    return 'Since $date';
  }

  @override
  String medUntil(String date) {
    return 'Until $date';
  }

  @override
  String medEnded(String date) {
    return 'Ended $date';
  }

  @override
  String get medNoAdviceNote =>
      'femio keeps what you write. It gives no dose, catch-up or interaction advice: ask your pharmacist or doctor.';

  @override
  String medTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count doses to mark today',
      one: '1 dose to mark today',
      zero: 'All marked for today',
    );
    return '$_temp0';
  }

  @override
  String get reminderMedicineNote =>
      'At the times you set on each medicine, and the day before a refill.';

  @override
  String get patTitle => 'Patterns';

  @override
  String get patOpen => 'See my patterns';

  @override
  String get patIntro =>
      'Counts from what you logged. femio shows how often, never what it means.';

  @override
  String get patCycleLength => 'Cycle length';

  @override
  String patNeedCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Cycle lengths appear after 2 full cycles. $count are complete so far.',
      one: 'Cycle lengths appear after 2 full cycles. 1 is complete so far.',
      zero: 'Cycle lengths appear after 2 full cycles. None is complete yet.',
    );
    return '$_temp0';
  }

  @override
  String patRange(int count, int shortest, int longest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your last $count cycles: $shortest to $longest days',
    );
    return '$_temp0';
  }

  @override
  String patDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get patVaries =>
      'Your cycle lengths vary by more than 9 days, or one was shorter than 24 or longer than 38 days. That can be worth mentioning at your next visit.';

  @override
  String get patVariesSource => 'Usual limits: FIGO 2018.';

  @override
  String get patNoticed => 'What you logged most';

  @override
  String get patNeedLogged =>
      'Counts appear after 3 full cycles with something logged in them.';

  @override
  String patSeen(String term, String phase, int seen, int cycles) {
    return '$term $phase: $seen of $cycles cycles';
  }

  @override
  String get patPhasePeriod => 'during your period';

  @override
  String get patPhaseBefore => 'in the 5 days before your period';

  @override
  String get patByPhase => 'By phase';

  @override
  String get patPhasePeriodShort => 'During period';

  @override
  String get patPhaseBeforeShort => '5 days before';

  @override
  String patOf(int seen, int cycles) {
    return '$seen of $cycles';
  }

  @override
  String get patEachCycle => 'Each cycle';

  @override
  String patCycleFrom(String date) {
    return 'From $date';
  }

  @override
  String patDaysLogged(int count) {
    return 'Days logged: $count';
  }

  @override
  String patOpkDays(int count) {
    return 'Ovulation test high or positive: $count';
  }

  @override
  String patTemps(int count) {
    return 'Temperatures: $count';
  }

  @override
  String get patRecent => 'Last 90 days';

  @override
  String get patEmpty => 'Nothing logged yet. Patterns grow from your log.';

  @override
  String get patNoVerdict =>
      'These are counts of what you logged. They don\'t say what causes anything or whether something is wrong. Bring them to your clinician if they help.';

  @override
  String get signsDaysTitle => 'Signs by cycle day';

  @override
  String get signsDaysOpen => 'See by cycle day';

  @override
  String signsDaysCurrent(String date) {
    return 'This cycle, from $date';
  }

  @override
  String signsDaysPast(String date, String days) {
    return 'Cycle from $date, $days';
  }

  @override
  String get signsDaysEarlier => 'Earlier cycle';

  @override
  String get signsDaysLater => 'Later cycle';

  @override
  String get signsDaysBleeding => 'Bleeding';

  @override
  String get signsDaysLogged => 'Logged';

  @override
  String get signsDaysCycleDay => 'Cycle day';

  @override
  String signsDaysDay(int day, String date) {
    return 'Cycle day $day, $date';
  }

  @override
  String get signsDaysNothing => 'Nothing logged this day.';

  @override
  String get signsDaysHint => 'Tap a day to see what you logged.';

  @override
  String get signsDaysEmpty =>
      'Nothing logged in this cycle yet. Temperatures, ovulation tests and discharge you log show here day by day.';

  @override
  String get signsDaysNoCycle =>
      'Log the first day of a period and your signs line up here by cycle day.';

  @override
  String get signsDaysFill =>
      'A fuller mark is further along the list you chose from: negative to positive for tests, dry to egg white for discharge.';

  @override
  String get listSeparator => ', ';

  @override
  String get ppGuideEyebrow => 'This week\'s recovery guide';

  @override
  String get ppRead => 'Read the guide';

  @override
  String get ppMoodTitle => 'How are you feeling today?';

  @override
  String get ppMoodNote =>
      'Feeling weepy in the first two weeks is common and usually passes. Low mood, anxiety or numbness that lasts longer than two weeks is worth telling your clinician, and you can ask sooner.';

  @override
  String get ppMoodGuide => 'About mood after birth';

  @override
  String get ppPeriodBack => 'Has your period come back?';

  @override
  String get ppPeriodBackBody =>
      'femio does not guess when periods return. When yours comes back, tell femio the first day and your cycle ranges start again from it.';

  @override
  String get ppPeriodBackAction => 'My period came back';

  @override
  String get ppPeriodBackPick => 'First day of your period';

  @override
  String get ppNextGoal => 'What should femio help with now?';

  @override
  String get ppBleedingSection => 'Bleeding after birth';

  @override
  String get ppBleedingNote =>
      'This is the healing bleed after birth, not a period. femio keeps it out of your cycle ranges. Very heavy bleeding or large clots need care right away.';

  @override
  String get ppWarnMore => 'See all warning signs after birth';

  @override
  String get ppHadBaby => 'I had my baby';

  @override
  String get ppHadBabyNote =>
      'femio keeps your pregnancy record and moves to the after-birth view.';

  @override
  String menoNextRange(String range) {
    return 'If another period comes, it may start around $range.';
  }

  @override
  String get menoRangeNote =>
      'Cycles often change in the years before menopause, so this range is wide. Menopause is identified after 12 months without a period.';

  @override
  String get menoBleedHeading => 'Bleeding after a year without periods';

  @override
  String get menoBleedBody =>
      'You logged bleeding after 12 months or more without a period. Bleeding after menopause should always be checked by a doctor, even if it happens once. Book an appointment soon.';

  @override
  String get menoBleedLogNote =>
      'Bleeding after 12 months without a period should always be checked by a doctor, even once.';

  @override
  String get menoBleedMore => 'About bleeding after menopause';

  @override
  String get patMonthly => 'Days logged each month';

  @override
  String get visitMedicines => 'Medicines I take now';
}
