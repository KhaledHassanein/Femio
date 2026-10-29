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
      'Know when it\'s coming, and what\'s usual for you.';

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
      'Cycles change with age, so this shapes what Femio expects. Only the year.';

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
      'Your cycles vary, so Femio shows a wider range and never counts days late.';

  @override
  String get noPredictionTitle => 'Log your next period';

  @override
  String get noPredictionBody =>
      'When your period starts, log it and Femio will predict the next one.';

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
      'Log any bleeding or symptoms and Femio keeps the record for your clinician.';

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
    return 'If your period hasn\'t started by $date, a home pregnancy test is reliable from that day.';
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
      'These are your readings, drawn as they are. Femio does not mark a shift or name a day — what a chart means is a conversation for you and your clinician.';

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
    return 'Full term from $date';
  }

  @override
  String get pregEstimateNote =>
      'These dates are estimates based on the due date you entered. Your clinician may adjust it after a scan.';

  @override
  String get pregRedFlagsHeading => 'Some symptoms need urgent care';

  @override
  String get pregRedFlagsBody =>
      'Seek care now if you have a severe headache, changes in your vision, pain in the upper abdomen, swelling of the face or hands, or difficulty breathing. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department.';

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
  String get contractionsHeading => 'Contraction timer';

  @override
  String get contractionsIntro =>
      'Press start when one begins and stop when it eases. Femio keeps the times so you have them when you call.';

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
      'These are your times, as recorded. Femio does not decide what they mean — read them out to your midwife or maternity unit, who can.';

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
      'Femio keeps when it is, who it is with, and what you wanted to ask. It does not keep what was found — that belongs with your clinician, in your notes.';

  @override
  String get apptEmptyHeading => 'Nothing here yet';

  @override
  String get apptEmptyBody =>
      'Add an appointment and Femio will hold the questions you meant to ask, which is the part people forget in the room.';

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
  String get apptFormType => 'What is it';

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
      'Optional. Femio will remind you to ask if the date passes — it never records what the result was.';

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
      'Add a reading whenever you like. Femio draws them and keeps the numbers for your notes.';

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
      'Your readings, drawn as they are. Femio does not show a target range or say whether a change is expected — what a pattern means is for you and your midwife or doctor.';

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
      'Cited guides, in plain words. Trying to conceive and pregnancy first; everything stays here.';

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
      'Your cycles vary too much to name fertile days from one date. Logging your periods, ovulation tests and waking temperature is how to tell afterwards.';

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
  String get helpNowCountryPrompt => 'Pick a country to see its numbers';

  @override
  String get helpNowEmergency => 'Emergency services';

  @override
  String get helpNowSupport => 'Support lines';

  @override
  String get helpNowSource => 'Source';

  @override
  String get helpNowCountryEG => 'Egypt';

  @override
  String get helpNowCountrySA => 'Saudi Arabia';

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
}
