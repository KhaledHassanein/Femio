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
      'A reminder only says \"femio: Open the app\". Nothing about your health appears on your lock screen.';

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
      'A page to show your clinician, made from what you logged. It stays on your phone unless you copy it.';

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
      'A backup goes only where you choose to save it, sealed with your passphrase.';

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
}
