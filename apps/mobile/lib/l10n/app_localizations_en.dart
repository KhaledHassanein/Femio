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
      'Your records stay on this phone. No account, and Femio never sees them.';

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
      'Femio\'s tracker is for women aged 18 and over in this first version. Every guide on femioapp.com is open to you, with no account.';

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
}
