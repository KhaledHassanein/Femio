import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'femio'**
  String get appTitle;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cycle, your plans, your pregnancy.'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on this phone. No account, and Femio never sees them.'**
  String get welcomeBody;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @notSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get notSure;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'What brings you to femio?'**
  String get goalTitle;

  /// No description provided for @goalSub.
  ///
  /// In en, this message translates to:
  /// **'You can change this any time.'**
  String get goalSub;

  /// No description provided for @goalPeriod.
  ///
  /// In en, this message translates to:
  /// **'Track my period'**
  String get goalPeriod;

  /// No description provided for @goalPeriodDesc.
  ///
  /// In en, this message translates to:
  /// **'Know when it\'s coming, and what\'s usual for you.'**
  String get goalPeriodDesc;

  /// No description provided for @goalTtc.
  ///
  /// In en, this message translates to:
  /// **'Get pregnant'**
  String get goalTtc;

  /// No description provided for @goalTtcDesc.
  ///
  /// In en, this message translates to:
  /// **'Your fertile window and likely ovulation.'**
  String get goalTtcDesc;

  /// No description provided for @goalPregnant.
  ///
  /// In en, this message translates to:
  /// **'I\'m pregnant'**
  String get goalPregnant;

  /// No description provided for @goalPregnantDesc.
  ///
  /// In en, this message translates to:
  /// **'Week by week, and your due date.'**
  String get goalPregnantDesc;

  /// No description provided for @goalMenopause.
  ///
  /// In en, this message translates to:
  /// **'Perimenopause & menopause'**
  String get goalMenopause;

  /// No description provided for @goalMenopauseDesc.
  ///
  /// In en, this message translates to:
  /// **'Changing cycles and symptoms.'**
  String get goalMenopauseDesc;

  /// No description provided for @birthYearTitle.
  ///
  /// In en, this message translates to:
  /// **'What year were you born?'**
  String get birthYearTitle;

  /// No description provided for @birthYearSub.
  ///
  /// In en, this message translates to:
  /// **'Cycles change with age, so this shapes what Femio expects. Only the year.'**
  String get birthYearSub;

  /// No description provided for @under18Title.
  ///
  /// In en, this message translates to:
  /// **'The tracker is for adults, for now'**
  String get under18Title;

  /// No description provided for @under18Body.
  ///
  /// In en, this message translates to:
  /// **'Femio\'s tracker is for women aged 18 and over in this first version. Every guide on femioapp.com is open to you, with no account.'**
  String get under18Body;

  /// No description provided for @lastPeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'When did your last period start?'**
  String get lastPeriodTitle;

  /// No description provided for @lastPeriodSub.
  ///
  /// In en, this message translates to:
  /// **'The first day of bleeding.'**
  String get lastPeriodSub;

  /// No description provided for @dontRemember.
  ///
  /// In en, this message translates to:
  /// **'I don\'t remember'**
  String get dontRemember;

  /// No description provided for @periodLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'How many days does your period usually last?'**
  String get periodLengthTitle;

  /// No description provided for @cycleLengthTitle.
  ///
  /// In en, this message translates to:
  /// **'How long is your cycle usually?'**
  String get cycleLengthTitle;

  /// No description provided for @cycleLengthSub.
  ///
  /// In en, this message translates to:
  /// **'From the first day of one period to the first day of the next.'**
  String get cycleLengthSub;

  /// No description provided for @irregular.
  ///
  /// In en, this message translates to:
  /// **'My cycles are irregular'**
  String get irregular;

  /// No description provided for @daysValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String daysValue(int count);

  /// No description provided for @tryingTitle.
  ///
  /// In en, this message translates to:
  /// **'How long have you been trying?'**
  String get tryingTitle;

  /// No description provided for @tryingJustStarted.
  ///
  /// In en, this message translates to:
  /// **'Just starting'**
  String get tryingJustStarted;

  /// No description provided for @tryingUnder6.
  ///
  /// In en, this message translates to:
  /// **'Under 6 months'**
  String get tryingUnder6;

  /// No description provided for @trying6to12.
  ///
  /// In en, this message translates to:
  /// **'6 to 12 months'**
  String get trying6to12;

  /// No description provided for @tryingOver12.
  ///
  /// In en, this message translates to:
  /// **'Over a year'**
  String get tryingOver12;

  /// No description provided for @dueMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'How should we work out your due date?'**
  String get dueMethodTitle;

  /// No description provided for @dueMethodKnown.
  ///
  /// In en, this message translates to:
  /// **'I know my due date'**
  String get dueMethodKnown;

  /// No description provided for @dueMethodLmp.
  ///
  /// In en, this message translates to:
  /// **'First day of my last period'**
  String get dueMethodLmp;

  /// No description provided for @dueMethodConception.
  ///
  /// In en, this message translates to:
  /// **'Conception date'**
  String get dueMethodConception;

  /// No description provided for @dueMethodIvf3.
  ///
  /// In en, this message translates to:
  /// **'IVF transfer (day-3 embryo)'**
  String get dueMethodIvf3;

  /// No description provided for @dueMethodIvf5.
  ///
  /// In en, this message translates to:
  /// **'IVF transfer (day-5 embryo)'**
  String get dueMethodIvf5;

  /// No description provided for @dueMethodBorn.
  ///
  /// In en, this message translates to:
  /// **'I\'ve had my baby'**
  String get dueMethodBorn;

  /// No description provided for @dueDateTitle.
  ///
  /// In en, this message translates to:
  /// **'What is your due date?'**
  String get dueDateTitle;

  /// No description provided for @conceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'When did you conceive?'**
  String get conceptionTitle;

  /// No description provided for @transferTitle.
  ///
  /// In en, this message translates to:
  /// **'When was your embryo transfer?'**
  String get transferTitle;

  /// No description provided for @birthDateTitle.
  ///
  /// In en, this message translates to:
  /// **'When was your baby born?'**
  String get birthDateTitle;

  /// No description provided for @implausibleDue.
  ///
  /// In en, this message translates to:
  /// **'That date doesn\'t look like a current pregnancy. Please check it.'**
  String get implausibleDue;

  /// No description provided for @menoLastTitle.
  ///
  /// In en, this message translates to:
  /// **'When was your last period?'**
  String get menoLastTitle;

  /// No description provided for @menoOverYear.
  ///
  /// In en, this message translates to:
  /// **'Over a year ago'**
  String get menoOverYear;

  /// No description provided for @predictionPeriodTitle.
  ///
  /// In en, this message translates to:
  /// **'Your next period'**
  String get predictionPeriodTitle;

  /// No description provided for @predictionFertileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your fertile window'**
  String get predictionFertileTitle;

  /// No description provided for @predictionOvulation.
  ///
  /// In en, this message translates to:
  /// **'Likely ovulation: {date}'**
  String predictionOvulation(String date);

  /// No description provided for @predictionNextPeriod.
  ///
  /// In en, this message translates to:
  /// **'Next period around {range}'**
  String predictionNextPeriod(String range);

  /// No description provided for @rangeValue.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String rangeValue(String start, String end);

  /// No description provided for @confidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low confidence: it sharpens as you log your periods'**
  String get confidenceLow;

  /// No description provided for @confidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium confidence'**
  String get confidenceMedium;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get confidenceHigh;

  /// No description provided for @basisStated.
  ///
  /// In en, this message translates to:
  /// **'Based on the cycle length you told us'**
  String get basisStated;

  /// No description provided for @irregularNote.
  ///
  /// In en, this message translates to:
  /// **'Your cycles vary, so Femio shows a wider range and never counts days late.'**
  String get irregularNote;

  /// No description provided for @noPredictionTitle.
  ///
  /// In en, this message translates to:
  /// **'Log your next period'**
  String get noPredictionTitle;

  /// No description provided for @noPredictionBody.
  ///
  /// In en, this message translates to:
  /// **'When your period starts, log it and Femio will predict the next one.'**
  String get noPredictionBody;

  /// No description provided for @pregnancyWeek.
  ///
  /// In en, this message translates to:
  /// **'Week {weeks}, day {days}'**
  String pregnancyWeek(int weeks, int days);

  /// No description provided for @trimesterLabel.
  ///
  /// In en, this message translates to:
  /// **'Trimester {n}'**
  String trimesterLabel(int n);

  /// No description provided for @dueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date around {date}'**
  String dueDateLabel(String date);

  /// No description provided for @postpartumWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks, plural, =0{Your baby is less than a week old} =1{1 week since your baby was born} other{{weeks} weeks since your baby was born}}'**
  String postpartumWeeks(int weeks);

  /// No description provided for @menoMonths.
  ///
  /// In en, this message translates to:
  /// **'{months, plural, =0{Your last period was less than a month ago} =1{1 month since your last period} other{{months} months since your last period}}'**
  String menoMonths(int months);

  /// No description provided for @menoUnknown.
  ///
  /// In en, this message translates to:
  /// **'Log any bleeding or symptoms and Femio keeps the record for your clinician.'**
  String get menoUnknown;

  /// No description provided for @awarenessNote.
  ///
  /// In en, this message translates to:
  /// **'Estimates for awareness and planning, not a way to avoid pregnancy.'**
  String get awarenessNote;

  /// No description provided for @seeClinicianTtc.
  ///
  /// In en, this message translates to:
  /// **'Trying for over a year (or six months if you are 35 or older) is a good time to talk to a clinician.'**
  String get seeClinicianTtc;

  /// No description provided for @privacyLine.
  ///
  /// In en, this message translates to:
  /// **'Stored on this phone only.'**
  String get privacyLine;

  /// No description provided for @logPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'My period started today'**
  String get logPeriodToday;

  /// No description provided for @loggedToday.
  ///
  /// In en, this message translates to:
  /// **'Logged. Your prediction is updated.'**
  String get loggedToday;

  /// No description provided for @startOver.
  ///
  /// In en, this message translates to:
  /// **'Start again'**
  String get startOver;

  /// No description provided for @todayTitle.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayTitle;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
    case 'fr':
      return L10nFr();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
