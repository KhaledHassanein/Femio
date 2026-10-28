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
  /// **'Your records stay on this phone. No account, and femio never sees them.'**
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
  /// **'femio\'s tracker is for women aged 18 and over in this first version. Every guide on femioapp.com is open to you, with no account.'**
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

  /// No description provided for @sectionOvulationTest.
  ///
  /// In en, this message translates to:
  /// **'Ovulation test'**
  String get sectionOvulationTest;

  /// No description provided for @sectionTemperature.
  ///
  /// In en, this message translates to:
  /// **'Waking temperature'**
  String get sectionTemperature;

  /// No description provided for @temperatureHint.
  ///
  /// In en, this message translates to:
  /// **'Taken before getting up, in °C or °F'**
  String get temperatureHint;

  /// No description provided for @temperatureSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get temperatureSave;

  /// No description provided for @temperatureClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get temperatureClear;

  /// No description provided for @testTimingTitle.
  ///
  /// In en, this message translates to:
  /// **'When to test'**
  String get testTimingTitle;

  /// No description provided for @testTimingBody.
  ///
  /// In en, this message translates to:
  /// **'If your period hasn\'t started by {date}, a home pregnancy test is reliable from that day.'**
  String testTimingBody(String date);

  /// No description provided for @opkNegative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get opkNegative;

  /// No description provided for @opkLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get opkLow;

  /// No description provided for @opkHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get opkHigh;

  /// No description provided for @opkPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get opkPeak;

  /// No description provided for @opkPositive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get opkPositive;

  /// No description provided for @bbtChartHeading.
  ///
  /// In en, this message translates to:
  /// **'Your temperatures'**
  String get bbtChartHeading;

  /// No description provided for @bbtChartNeedData.
  ///
  /// In en, this message translates to:
  /// **'Log three waking temperatures and your chart appears here. Fewer than that is a dot, not a pattern.'**
  String get bbtChartNeedData;

  /// No description provided for @bbtChartNote.
  ///
  /// In en, this message translates to:
  /// **'These are your readings, drawn as they are. Femio does not mark a shift or name a day — what a chart means is a conversation for you and your clinician.'**
  String get bbtChartNote;

  /// No description provided for @invalidBbt.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a thermometer reading. Check the number and try again.'**
  String get invalidBbt;

  /// No description provided for @testTimingGeneral.
  ///
  /// In en, this message translates to:
  /// **'Most home tests work from the first day of a missed period. Testing earlier can give a negative result even if you are pregnant.'**
  String get testTimingGeneral;

  /// No description provided for @testTimingSource.
  ///
  /// In en, this message translates to:
  /// **'Source: NHS, Doing a pregnancy test.'**
  String get testTimingSource;

  /// No description provided for @pregDaysToGo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {{days} day to go} other {{days} days to go}}'**
  String pregDaysToGo(int days);

  /// No description provided for @pregOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {{days} day past your due date} other {{days} days past your due date}}'**
  String pregOverdue(int days);

  /// No description provided for @pregTermFrom.
  ///
  /// In en, this message translates to:
  /// **'Full term from {date}'**
  String pregTermFrom(String date);

  /// No description provided for @pregEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'These dates are estimates based on the due date you entered. Your clinician may adjust it after a scan.'**
  String get pregEstimateNote;

  /// No description provided for @pregRedFlagsHeading.
  ///
  /// In en, this message translates to:
  /// **'Some symptoms need urgent care'**
  String get pregRedFlagsHeading;

  /// No description provided for @pregRedFlagsBody.
  ///
  /// In en, this message translates to:
  /// **'Bleeding, severe headache, vision changes, severe abdominal pain, or reduced movements need to be checked straight away. Contact your maternity unit or local emergency services — do not wait.'**
  String get pregRedFlagsBody;

  /// No description provided for @contractionsHeading.
  ///
  /// In en, this message translates to:
  /// **'Contraction timer'**
  String get contractionsHeading;

  /// No description provided for @contractionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Press start when one begins and stop when it eases. Femio keeps the times so you have them when you call.'**
  String get contractionsIntro;

  /// No description provided for @contractionsStart.
  ///
  /// In en, this message translates to:
  /// **'Start a contraction'**
  String get contractionsStart;

  /// No description provided for @contractionsStop.
  ///
  /// In en, this message translates to:
  /// **'It has eased'**
  String get contractionsStop;

  /// No description provided for @contractionsRunning.
  ///
  /// In en, this message translates to:
  /// **'Timing now'**
  String get contractionsRunning;

  /// No description provided for @contractionsContactHeading.
  ///
  /// In en, this message translates to:
  /// **'Call your maternity unit whenever you need to'**
  String get contractionsContactHeading;

  /// No description provided for @contractionsContactBody.
  ///
  /// In en, this message translates to:
  /// **'You do not need to reach a certain number first. Call if you are worried, if your waters break, if there is bleeding, or if the baby is moving less than usual.'**
  String get contractionsContactBody;

  /// No description provided for @contractionsSummaryHeading.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Your last contraction} other {Your last {count} contractions}}'**
  String contractionsSummaryHeading(int count);

  /// No description provided for @contractionsSummaryDuration.
  ///
  /// In en, this message translates to:
  /// **'Lasting about {value}'**
  String contractionsSummaryDuration(String value);

  /// No description provided for @contractionsSummaryInterval.
  ///
  /// In en, this message translates to:
  /// **'About {value} apart, start to start'**
  String contractionsSummaryInterval(String value);

  /// No description provided for @contractionsSummaryNote.
  ///
  /// In en, this message translates to:
  /// **'These are your times, as recorded. Femio does not decide what they mean — read them out to your midwife or maternity unit, who can.'**
  String get contractionsSummaryNote;

  /// No description provided for @movementsHeading.
  ///
  /// In en, this message translates to:
  /// **'Movement log'**
  String get movementsHeading;

  /// No description provided for @movementsIntro.
  ///
  /// In en, this message translates to:
  /// **'There is no normal number of movements. What matters is a change from your baby\'s usual pattern, so this records what you feel and shows you your own pattern over time.'**
  String get movementsIntro;

  /// No description provided for @movementsUrgentHeading.
  ///
  /// In en, this message translates to:
  /// **'If movements are less than usual'**
  String get movementsUrgentHeading;

  /// No description provided for @movementsUrgentBody.
  ///
  /// In en, this message translates to:
  /// **'Contact your maternity team now. Do not wait for this session to finish, and do not wait until tomorrow.'**
  String get movementsUrgentBody;

  /// No description provided for @movementsStart.
  ///
  /// In en, this message translates to:
  /// **'Start a session'**
  String get movementsStart;

  /// No description provided for @movementsStartBody.
  ///
  /// In en, this message translates to:
  /// **'Get comfortable, then start. Tap each time you feel a movement.'**
  String get movementsStartBody;

  /// No description provided for @movementsTap.
  ///
  /// In en, this message translates to:
  /// **'I felt a movement'**
  String get movementsTap;

  /// No description provided for @movementsCounted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} movement recorded} other {{count} movements recorded}}'**
  String movementsCounted(int count);

  /// No description provided for @movementsFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish and save'**
  String get movementsFinish;

  /// No description provided for @movementsFinishNote.
  ///
  /// In en, this message translates to:
  /// **'You can stop any time. The session saves either way.'**
  String get movementsFinishNote;

  /// No description provided for @movementsRecentHeading.
  ///
  /// In en, this message translates to:
  /// **'Your recent sessions'**
  String get movementsRecentHeading;

  /// No description provided for @movementsSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} movement} other {{count} movements}} · about {minutes} min apart'**
  String movementsSessionSummary(int count, String minutes);

  /// No description provided for @movementsUnfinished.
  ///
  /// In en, this message translates to:
  /// **'Not finished'**
  String get movementsUnfinished;

  /// No description provided for @movementsSlowerHeading.
  ///
  /// In en, this message translates to:
  /// **'Movements were further apart than usual for you'**
  String get movementsSlowerHeading;

  /// No description provided for @movementsSlowerBody.
  ///
  /// In en, this message translates to:
  /// **'This is a change from your own recent sessions. What it means is for your maternity team to say, so contact them and let someone check.'**
  String get movementsSlowerBody;

  /// No description provided for @movementsNeedMore.
  ///
  /// In en, this message translates to:
  /// **'After {count} sessions you will be able to compare with your own pattern.'**
  String movementsNeedMore(String count);

  /// No description provided for @pregnancyToolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy tools'**
  String get pregnancyToolsTitle;

  /// No description provided for @contractionsClear.
  ///
  /// In en, this message translates to:
  /// **'Clear these times'**
  String get contractionsClear;

  /// No description provided for @contractionsCleared.
  ///
  /// In en, this message translates to:
  /// **'Times cleared'**
  String get contractionsCleared;

  /// No description provided for @contractionLength.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get contractionLength;

  /// No description provided for @contractionApart.
  ///
  /// In en, this message translates to:
  /// **'Apart'**
  String get contractionApart;

  /// No description provided for @apptTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get apptTitle;

  /// No description provided for @apptAdd.
  ///
  /// In en, this message translates to:
  /// **'Add an appointment'**
  String get apptAdd;

  /// No description provided for @apptCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get apptCancel;

  /// No description provided for @apptSave.
  ///
  /// In en, this message translates to:
  /// **'Save appointment'**
  String get apptSave;

  /// No description provided for @apptUntitled.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get apptUntitled;

  /// No description provided for @apptNoDate.
  ///
  /// In en, this message translates to:
  /// **'No date yet'**
  String get apptNoDate;

  /// No description provided for @apptToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get apptToday;

  /// No description provided for @apptInDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one {Tomorrow} other {In {days} days}}'**
  String apptInDays(int days);

  /// No description provided for @apptPrepHeading.
  ///
  /// In en, this message translates to:
  /// **'What you wanted to ask'**
  String get apptPrepHeading;

  /// No description provided for @apptUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get apptUpcoming;

  /// No description provided for @apptPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get apptPast;

  /// No description provided for @apptNoResultsNote.
  ///
  /// In en, this message translates to:
  /// **'Femio keeps when it is, who it is with, and what you wanted to ask. It does not keep what was found — that belongs with your clinician, in your notes.'**
  String get apptNoResultsNote;

  /// No description provided for @apptEmptyHeading.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get apptEmptyHeading;

  /// No description provided for @apptEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add an appointment and Femio will hold the questions you meant to ask, which is the part people forget in the room.'**
  String get apptEmptyBody;

  /// No description provided for @apptAwaitingHeading.
  ///
  /// In en, this message translates to:
  /// **'Still waiting to hear?'**
  String get apptAwaitingHeading;

  /// No description provided for @apptAwaitingBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {You were expecting a result back by now for one of these.} other {You were expecting results back by now for {count} of these.}} It may be worth asking — results run late for all sorts of ordinary reasons.'**
  String apptAwaitingBody(int count);

  /// No description provided for @apptFormType.
  ///
  /// In en, this message translates to:
  /// **'What is it'**
  String get apptFormType;

  /// No description provided for @apptFormTypePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Scan, blood test, check-up…'**
  String get apptFormTypePlaceholder;

  /// No description provided for @apptFormClinician.
  ///
  /// In en, this message translates to:
  /// **'Who with'**
  String get apptFormClinician;

  /// No description provided for @apptFormWhen.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get apptFormWhen;

  /// No description provided for @apptFormResultsDue.
  ///
  /// In en, this message translates to:
  /// **'Told to expect results by'**
  String get apptFormResultsDue;

  /// No description provided for @apptFormResultsDueHint.
  ///
  /// In en, this message translates to:
  /// **'Optional. Femio will remind you to ask if the date passes — it never records what the result was.'**
  String get apptFormResultsDueHint;

  /// No description provided for @apptFormPrep.
  ///
  /// In en, this message translates to:
  /// **'Questions you want to ask'**
  String get apptFormPrep;

  /// No description provided for @apptFormPrepPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'One per line'**
  String get apptFormPrepPlaceholder;

  /// No description provided for @apptPrepCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} question saved} other {{count} questions saved}}'**
  String apptPrepCount(int count);

  /// No description provided for @weightHeading.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightHeading;

  /// No description provided for @weightIntro.
  ///
  /// In en, this message translates to:
  /// **'Add a reading whenever you like. Femio draws them and keeps the numbers for your notes.'**
  String get weightIntro;

  /// No description provided for @weightValue.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weightValue;

  /// No description provided for @weightSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get weightSave;

  /// No description provided for @weightInvalid.
  ///
  /// In en, this message translates to:
  /// **'That does not look like a scale reading. Check the number and try again.'**
  String get weightInvalid;

  /// No description provided for @weightNeedData.
  ///
  /// In en, this message translates to:
  /// **'Add a second reading and your chart appears here.'**
  String get weightNeedData;

  /// No description provided for @weightChange.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} since your first entry'**
  String weightChange(String value, String unit);

  /// No description provided for @weightNote.
  ///
  /// In en, this message translates to:
  /// **'Your readings, drawn as they are. Femio does not show a target range or say whether a change is expected — what a pattern means is for you and your midwife or doctor.'**
  String get weightNote;

  /// No description provided for @weightDate.
  ///
  /// In en, this message translates to:
  /// **'Measured on'**
  String get weightDate;

  /// No description provided for @weightUnitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get weightUnitKg;

  /// No description provided for @weightUnitLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get weightUnitLb;

  /// No description provided for @apptDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get apptDelete;

  /// No description provided for @apptEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get apptEdit;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsDates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get settingsDates;

  /// No description provided for @settingsHijri.
  ///
  /// In en, this message translates to:
  /// **'Show Hijri dates'**
  String get settingsHijri;

  /// No description provided for @settingsHijriNote.
  ///
  /// In en, this message translates to:
  /// **'Beside each Gregorian date. Umm al-Qura calendar; can differ by a day from local announcements.'**
  String get settingsHijriNote;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsLock;

  /// No description provided for @settingsLockNote.
  ///
  /// In en, this message translates to:
  /// **'Ask for a PIN when femio opens and after a minute away.'**
  String get settingsLockNote;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a PIN of 4 to 8 digits'**
  String get setPin;

  /// No description provided for @changePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get changePin;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get enterPin;

  /// No description provided for @enterPinAgain.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get enterPinAgain;

  /// No description provided for @enterCurrentPin.
  ///
  /// In en, this message translates to:
  /// **'Enter your current PIN'**
  String get enterCurrentPin;

  /// No description provided for @pinMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two PINs did not match. Try again.'**
  String get pinMismatch;

  /// No description provided for @wrongPin.
  ///
  /// In en, this message translates to:
  /// **'That PIN is not right.'**
  String get wrongPin;

  /// No description provided for @lockTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get lockTitle;

  /// No description provided for @lockHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your PIN to open your records.'**
  String get lockHint;

  /// No description provided for @forgotPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN? There is no way to recover it: femio has no account. Delete everything from this phone and start again, or restore a backup file.'**
  String get forgotPin;

  /// No description provided for @backupSection.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backupSection;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Save a backup file'**
  String get exportBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Restore from a backup file'**
  String get importBackup;

  /// No description provided for @backupPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get backupPassphrase;

  /// No description provided for @backupPassphraseAgain.
  ///
  /// In en, this message translates to:
  /// **'Passphrase again'**
  String get backupPassphraseAgain;

  /// No description provided for @backupPassphraseHint.
  ///
  /// In en, this message translates to:
  /// **'Choose a passphrase you will remember. The file opens only with it, and nobody can reset it.'**
  String get backupPassphraseHint;

  /// No description provided for @backupPassphraseShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least {count} characters.'**
  String backupPassphraseShort(int count);

  /// No description provided for @backupPassphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'The two passphrases did not match.'**
  String get backupPassphraseMismatch;

  /// No description provided for @backupSaved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved.'**
  String get backupSaved;

  /// No description provided for @backupImported.
  ///
  /// In en, this message translates to:
  /// **'Your records were restored.'**
  String get backupImported;

  /// No description provided for @backupWrongPassphrase.
  ///
  /// In en, this message translates to:
  /// **'That passphrase does not open this file.'**
  String get backupWrongPassphrase;

  /// No description provided for @backupNotFemio.
  ///
  /// In en, this message translates to:
  /// **'That is not a femio backup file.'**
  String get backupNotFemio;

  /// No description provided for @backupUnreadable.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer femio and cannot be read here. Update the app and try again.'**
  String get backupUnreadable;

  /// No description provided for @backupHonesty.
  ///
  /// In en, this message translates to:
  /// **'Your records live only on this phone. If you lose or reset the phone, they are gone unless you have saved a backup file. We cannot recover them for you.'**
  String get backupHonesty;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @wellnessDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'femio is a wellness and education tool for tracking your own health. It is not a medical device and does not replace your clinician.'**
  String get wellnessDisclaimer;

  /// No description provided for @predictionNote.
  ///
  /// In en, this message translates to:
  /// **'Predictions are estimates, not guarantees, and must not be relied on to avoid pregnancy.'**
  String get predictionNote;

  /// No description provided for @firstRunStorageNotice.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on this phone. femio has no account and no server, and cannot see what you enter.'**
  String get firstRunStorageNotice;

  /// No description provided for @firstRunStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get firstRunStorageTitle;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get dismiss;

  /// No description provided for @deleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything on this phone'**
  String get deleteEverything;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete everything on this phone?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'This removes all your records and settings from femio on this phone. It cannot be undone, and we cannot restore it. Backup files you saved elsewhere are not deleted.'**
  String get deleteConfirmBody;

  /// No description provided for @deleteConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get deleteConfirmAction;

  /// No description provided for @deleteConfirmCancel.
  ///
  /// In en, this message translates to:
  /// **'Keep my records'**
  String get deleteConfirmCancel;

  /// No description provided for @corruptTitle.
  ///
  /// In en, this message translates to:
  /// **'Your records could not be opened'**
  String get corruptTitle;

  /// No description provided for @corruptBody.
  ///
  /// In en, this message translates to:
  /// **'The file on this phone is damaged or was written by a different femio. It has been kept aside, not deleted. Restore a backup file if you have one, or start again.'**
  String get corruptBody;

  /// No description provided for @settingsReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsReminders;

  /// No description provided for @reminderLog.
  ///
  /// In en, this message translates to:
  /// **'Log reminder'**
  String get reminderLog;

  /// No description provided for @reminderLogNote.
  ///
  /// In en, this message translates to:
  /// **'A daily nudge at the time you choose. It skips a day you have already logged.'**
  String get reminderLogNote;

  /// No description provided for @reminderLogTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get reminderLogTime;

  /// No description provided for @reminderPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period expected'**
  String get reminderPeriod;

  /// No description provided for @reminderPeriodNote.
  ///
  /// In en, this message translates to:
  /// **'One notification the day before your expected window opens. Only when your cycles are regular enough to estimate.'**
  String get reminderPeriodNote;

  /// No description provided for @remindersPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'A reminder only says \"femio: Open the app\". Nothing about your health appears on your lock screen.'**
  String get remindersPrivacyNote;

  /// No description provided for @remindersTimingNote.
  ///
  /// In en, this message translates to:
  /// **'Reminders can arrive a few minutes late, and some phones hold them back to save battery.'**
  String get remindersTimingNote;

  /// No description provided for @reminderPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are turned off for femio. You can allow them in your phone\'s settings.'**
  String get reminderPermissionDenied;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'femio'**
  String get reminderTitle;

  /// No description provided for @reminderBody.
  ///
  /// In en, this message translates to:
  /// **'Open the app'**
  String get reminderBody;

  /// No description provided for @reminderChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminderChannelName;

  /// No description provided for @reminderChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Reminders you turned on in femio. They never mention your health.'**
  String get reminderChannelDescription;

  /// Accessible label of a calendar day when Hijri dates are shown: the Gregorian date, then the Hijri date.
  ///
  /// In en, this message translates to:
  /// **'{gregorian}, {hijri}'**
  String calendarDayLabel(String gregorian, String hijri);

  /// No description provided for @navLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get navLearn;

  /// No description provided for @learnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnTitle;

  /// No description provided for @learnSub.
  ///
  /// In en, this message translates to:
  /// **'Cited guides, in plain words. Trying to conceive and pregnancy first; everything stays here.'**
  String get learnSub;

  /// No description provided for @learnSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search the guides'**
  String get learnSearchHint;

  /// No description provided for @learnNoResults.
  ///
  /// In en, this message translates to:
  /// **'No guide matches that yet.'**
  String get learnNoResults;

  /// No description provided for @learnReviewedBy.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by {name}'**
  String learnReviewedBy(String name);

  /// No description provided for @learnReviewedOn.
  ///
  /// In en, this message translates to:
  /// **'Reviewed by {name} · {date}'**
  String learnReviewedOn(String name, String date);

  /// No description provided for @learnReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Editorially checked · clinician review pending'**
  String get learnReviewPending;

  /// No description provided for @learnEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'In English'**
  String get learnEnglishOnly;

  /// No description provided for @learnEnglishOnlyBody.
  ///
  /// In en, this message translates to:
  /// **'This guide is not translated yet, so it is shown in English.'**
  String get learnEnglishOnlyBody;

  /// No description provided for @learnSeekCareNow.
  ///
  /// In en, this message translates to:
  /// **'Seek care now'**
  String get learnSeekCareNow;

  /// No description provided for @learnSources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get learnSources;

  /// No description provided for @learnLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied. Paste it in your browser.'**
  String get learnLinkCopied;

  /// No description provided for @noConfidentWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'No confident window this cycle'**
  String get noConfidentWindowTitle;

  /// No description provided for @noConfidentWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Your cycles vary too much to name fertile days from one date. Logging your periods, ovulation tests and waking temperature is how to tell afterwards.'**
  String get noConfidentWindowBody;

  /// No description provided for @seeClinicianIrregular.
  ///
  /// In en, this message translates to:
  /// **'Because your cycles are irregular, it is reasonable to talk to a clinician now rather than wait a year.'**
  String get seeClinicianIrregular;

  /// No description provided for @helpNowLauncher.
  ///
  /// In en, this message translates to:
  /// **'Need help now?'**
  String get helpNowLauncher;

  /// No description provided for @helpNowDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Need help now?'**
  String get helpNowDialogTitle;

  /// No description provided for @helpNowImmediateHeading.
  ///
  /// In en, this message translates to:
  /// **'If you may be in danger'**
  String get helpNowImmediateHeading;

  /// No description provided for @helpNowImmediateLead.
  ///
  /// In en, this message translates to:
  /// **'If you may act on thoughts of harming yourself or someone else, or you are in immediate danger, contact the emergency services available where you are now or go to the nearest emergency department.'**
  String get helpNowImmediateLead;

  /// No description provided for @helpNowStayWithSomeone.
  ///
  /// In en, this message translates to:
  /// **'If you can, stay with someone you trust while you get help.'**
  String get helpNowStayWithSomeone;

  /// No description provided for @helpNowWorriedHeading.
  ///
  /// In en, this message translates to:
  /// **'If you are worried about someone else'**
  String get helpNowWorriedHeading;

  /// No description provided for @helpNowWorriedBody.
  ///
  /// In en, this message translates to:
  /// **'If you think the person is in immediate danger, do not leave them alone if it is safe for you to stay. Contact the emergency services available where they are, a crisis service, a health worker, or a trusted family member.'**
  String get helpNowWorriedBody;

  /// No description provided for @helpNowNumber_eg_ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance (Egyptian Ambulance Organization)'**
  String get helpNowNumber_eg_ambulance;

  /// No description provided for @helpNowNumber_eg_mental_health.
  ///
  /// In en, this message translates to:
  /// **'Mental health hotline (Ministry of Health, mental health secretariat)'**
  String get helpNowNumber_eg_mental_health;

  /// No description provided for @helpNowNumber_eg_ncw.
  ///
  /// In en, this message translates to:
  /// **'Women’s complaints office (National Council for Women)'**
  String get helpNowNumber_eg_ncw;

  /// No description provided for @helpNowNumber_sa_srca.
  ///
  /// In en, this message translates to:
  /// **'Ambulance (Saudi Red Crescent Authority)'**
  String get helpNowNumber_sa_srca;

  /// No description provided for @helpNowNumber_sa_moh.
  ///
  /// In en, this message translates to:
  /// **'Ministry of Health call centre'**
  String get helpNowNumber_sa_moh;

  /// No description provided for @helpNowNumber_sa_moh_mental.
  ///
  /// In en, this message translates to:
  /// **'Psychological consultations (Ministry of Health)'**
  String get helpNowNumber_sa_moh_mental;

  /// No description provided for @helpNowNumber_sa_hrsd.
  ///
  /// In en, this message translates to:
  /// **'Family-violence reports centre (Ministry of Human Resources and Social Development)'**
  String get helpNowNumber_sa_hrsd;

  /// No description provided for @helpNowCountryPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pick a country to see its numbers'**
  String get helpNowCountryPrompt;

  /// No description provided for @helpNowEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowEmergency;

  /// No description provided for @helpNowSupport.
  ///
  /// In en, this message translates to:
  /// **'Support lines'**
  String get helpNowSupport;

  /// No description provided for @helpNowSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get helpNowSource;

  /// No description provided for @helpNowCountryEG.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get helpNowCountryEG;

  /// No description provided for @helpNowCountrySA.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get helpNowCountrySA;

  /// No description provided for @helpNowCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get helpNowCall;
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
