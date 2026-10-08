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

  /// No description provided for @logHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get logHappy;

  /// No description provided for @logCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get logCalm;

  /// No description provided for @logAnxious.
  ///
  /// In en, this message translates to:
  /// **'Anxious'**
  String get logAnxious;

  /// No description provided for @logIrritable.
  ///
  /// In en, this message translates to:
  /// **'Irritable'**
  String get logIrritable;

  /// No description provided for @logSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get logSad;

  /// No description provided for @logMoodSwings.
  ///
  /// In en, this message translates to:
  /// **'Mood swings'**
  String get logMoodSwings;

  /// No description provided for @logLowMotivation.
  ///
  /// In en, this message translates to:
  /// **'Low motivation'**
  String get logLowMotivation;

  /// No description provided for @logTearfulness.
  ///
  /// In en, this message translates to:
  /// **'Tearfulness'**
  String get logTearfulness;

  /// No description provided for @logPanicFeelings.
  ///
  /// In en, this message translates to:
  /// **'Sudden panicky feelings'**
  String get logPanicFeelings;

  /// No description provided for @logCramps.
  ///
  /// In en, this message translates to:
  /// **'Cramps'**
  String get logCramps;

  /// No description provided for @logHeadache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get logHeadache;

  /// No description provided for @logBloating.
  ///
  /// In en, this message translates to:
  /// **'Bloating'**
  String get logBloating;

  /// No description provided for @logBreastTenderness.
  ///
  /// In en, this message translates to:
  /// **'Breast tenderness'**
  String get logBreastTenderness;

  /// No description provided for @logBackache.
  ///
  /// In en, this message translates to:
  /// **'Backache'**
  String get logBackache;

  /// No description provided for @logJointPain.
  ///
  /// In en, this message translates to:
  /// **'Joint pain'**
  String get logJointPain;

  /// No description provided for @logMusclePain.
  ///
  /// In en, this message translates to:
  /// **'Muscle aches'**
  String get logMusclePain;

  /// No description provided for @logNausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get logNausea;

  /// No description provided for @logConstipation.
  ///
  /// In en, this message translates to:
  /// **'Constipation'**
  String get logConstipation;

  /// No description provided for @logDiarrhea.
  ///
  /// In en, this message translates to:
  /// **'Diarrhoea'**
  String get logDiarrhea;

  /// No description provided for @logFatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get logFatigue;

  /// No description provided for @logAcne.
  ///
  /// In en, this message translates to:
  /// **'Acne'**
  String get logAcne;

  /// No description provided for @logHotFlashes.
  ///
  /// In en, this message translates to:
  /// **'Hot flushes'**
  String get logHotFlashes;

  /// No description provided for @logNightSweats.
  ///
  /// In en, this message translates to:
  /// **'Night sweats'**
  String get logNightSweats;

  /// No description provided for @logSpotting.
  ///
  /// In en, this message translates to:
  /// **'Spotting'**
  String get logSpotting;

  /// No description provided for @logHeartFlutters.
  ///
  /// In en, this message translates to:
  /// **'Heart fluttering or racing'**
  String get logHeartFlutters;

  /// No description provided for @logWeightChange.
  ///
  /// In en, this message translates to:
  /// **'A change in weight'**
  String get logWeightChange;

  /// No description provided for @logCravings.
  ///
  /// In en, this message translates to:
  /// **'Cravings'**
  String get logCravings;

  /// No description provided for @logInsomnia.
  ///
  /// In en, this message translates to:
  /// **'Trouble sleeping'**
  String get logInsomnia;

  /// No description provided for @logDizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get logDizziness;

  /// No description provided for @logBrainFog.
  ///
  /// In en, this message translates to:
  /// **'Brain fog'**
  String get logBrainFog;

  /// No description provided for @logLibidoUp.
  ///
  /// In en, this message translates to:
  /// **'Higher sex drive'**
  String get logLibidoUp;

  /// No description provided for @logLibidoDown.
  ///
  /// In en, this message translates to:
  /// **'Lower sex drive'**
  String get logLibidoDown;

  /// No description provided for @logVaginalDryness.
  ///
  /// In en, this message translates to:
  /// **'Vaginal dryness'**
  String get logVaginalDryness;

  /// No description provided for @logPainDuringSex.
  ///
  /// In en, this message translates to:
  /// **'Pain during sex'**
  String get logPainDuringSex;

  /// No description provided for @logBladderUrgency.
  ///
  /// In en, this message translates to:
  /// **'Needing to pee urgently or often'**
  String get logBladderUrgency;

  /// No description provided for @logBladderLeaks.
  ///
  /// In en, this message translates to:
  /// **'Leaking urine'**
  String get logBladderLeaks;

  /// No description provided for @logHairThinning.
  ///
  /// In en, this message translates to:
  /// **'Hair thinning'**
  String get logHairThinning;

  /// No description provided for @logDryItchySkin.
  ///
  /// In en, this message translates to:
  /// **'Dry or itchy skin'**
  String get logDryItchySkin;

  /// No description provided for @logBrittleNails.
  ///
  /// In en, this message translates to:
  /// **'Brittle nails'**
  String get logBrittleNails;

  /// No description provided for @logGumSoreness.
  ///
  /// In en, this message translates to:
  /// **'Sore or bleeding gums'**
  String get logGumSoreness;

  /// No description provided for @logBurningMouth.
  ///
  /// In en, this message translates to:
  /// **'Burning or tingling mouth'**
  String get logBurningMouth;

  /// No description provided for @logTingling.
  ///
  /// In en, this message translates to:
  /// **'Tingling in hands or feet'**
  String get logTingling;

  /// No description provided for @logElectricShocks.
  ///
  /// In en, this message translates to:
  /// **'Brief electric-shock sensations'**
  String get logElectricShocks;

  /// No description provided for @logBodyOdourChange.
  ///
  /// In en, this message translates to:
  /// **'A change in body odour'**
  String get logBodyOdourChange;

  /// No description provided for @logTinnitus.
  ///
  /// In en, this message translates to:
  /// **'Ringing in the ears'**
  String get logTinnitus;

  /// No description provided for @logDry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get logDry;

  /// No description provided for @logSticky.
  ///
  /// In en, this message translates to:
  /// **'Sticky'**
  String get logSticky;

  /// No description provided for @logCreamy.
  ///
  /// In en, this message translates to:
  /// **'Creamy'**
  String get logCreamy;

  /// No description provided for @logWatery.
  ///
  /// In en, this message translates to:
  /// **'Watery'**
  String get logWatery;

  /// No description provided for @logEggWhite.
  ///
  /// In en, this message translates to:
  /// **'Egg white'**
  String get logEggWhite;

  /// No description provided for @logIntercourse.
  ///
  /// In en, this message translates to:
  /// **'Intercourse'**
  String get logIntercourse;

  /// No description provided for @flowSpotting.
  ///
  /// In en, this message translates to:
  /// **'Spotting'**
  String get flowSpotting;

  /// No description provided for @flowLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get flowLight;

  /// No description provided for @flowMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get flowMedium;

  /// No description provided for @flowHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy'**
  String get flowHeavy;

  /// No description provided for @flowLabel.
  ///
  /// In en, this message translates to:
  /// **'Flow'**
  String get flowLabel;

  /// No description provided for @navToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get navToday;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get navCalendar;

  /// No description provided for @navLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get navLog;

  /// No description provided for @calendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendarTitle;

  /// No description provided for @legendPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get legendPeriod;

  /// No description provided for @legendSpotting.
  ///
  /// In en, this message translates to:
  /// **'Spotting'**
  String get legendSpotting;

  /// No description provided for @legendPredicted.
  ///
  /// In en, this message translates to:
  /// **'Period may start'**
  String get legendPredicted;

  /// No description provided for @legendFertile.
  ///
  /// In en, this message translates to:
  /// **'Fertile window'**
  String get legendFertile;

  /// No description provided for @legendOvulation.
  ///
  /// In en, this message translates to:
  /// **'Likely ovulation'**
  String get legendOvulation;

  /// No description provided for @legendLogged.
  ///
  /// In en, this message translates to:
  /// **'Something logged'**
  String get legendLogged;

  /// No description provided for @calendarHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to log it. Estimates are shown in outline; what you log is filled in.'**
  String get calendarHint;

  /// No description provided for @logTitle.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get logTitle;

  /// No description provided for @sectionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get sectionPeriod;

  /// No description provided for @flowNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get flowNone;

  /// No description provided for @sectionMood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get sectionMood;

  /// No description provided for @sectionSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Symptoms'**
  String get sectionSymptoms;

  /// No description provided for @sectionDischarge.
  ///
  /// In en, this message translates to:
  /// **'Discharge'**
  String get sectionDischarge;

  /// No description provided for @sectionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get sectionMore;

  /// No description provided for @previousDay.
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// No description provided for @nextDay.
  ///
  /// In en, this message translates to:
  /// **'Next day'**
  String get nextDay;

  /// No description provided for @logSavedNote.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone as you tap.'**
  String get logSavedNote;

  /// No description provided for @logSymptomsButton.
  ///
  /// In en, this message translates to:
  /// **'Log how you feel'**
  String get logSymptomsButton;

  /// No description provided for @loggedTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing logged today} =1{1 thing logged today} other{{count} things logged today}}'**
  String loggedTodayCount(int count);
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
