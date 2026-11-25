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
  /// **'A range for when it\'s coming, and what\'s usual for you.'**
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
  /// **'Cycles change with age, so this shapes what femio expects. Only the year.'**
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

  /// No description provided for @eighteenTitle.
  ///
  /// In en, this message translates to:
  /// **'Has your 18th birthday passed?'**
  String get eighteenTitle;

  /// No description provided for @eighteenSub.
  ///
  /// In en, this message translates to:
  /// **'One quick check: the tracker is for women aged 18 and over. Nothing here is saved.'**
  String get eighteenSub;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noNotYetLabel.
  ///
  /// In en, this message translates to:
  /// **'No, not yet'**
  String get noNotYetLabel;

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
  /// **'Your cycles vary, so femio shows a wider range and never counts days late.'**
  String get irregularNote;

  /// No description provided for @noPredictionTitle.
  ///
  /// In en, this message translates to:
  /// **'Log your next period'**
  String get noPredictionTitle;

  /// No description provided for @noPredictionBody.
  ///
  /// In en, this message translates to:
  /// **'When your period starts, log it and femio will predict the next one.'**
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
  /// **'Log any bleeding or symptoms and femio keeps the record for your clinician.'**
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
  /// **'If your period hasn\'t started by {date}, a home pregnancy test is most reliable from that day.'**
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
  /// **'These are your readings, drawn as they are. femio does not mark a shift or name a day — what a chart means is a conversation for you and your clinician.'**
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
  /// **'Term from {date}'**
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
  /// **'Seek care now if you have a severe headache, changes in your vision, pain in the upper abdomen, swelling of the face or hands, difficulty breathing, vaginal bleeding, or if your baby\'s movements have slowed down, stopped or changed. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department.'**
  String get pregRedFlagsBody;

  /// No description provided for @pregRedFlagsMore.
  ///
  /// In en, this message translates to:
  /// **'See the full list and its sources'**
  String get pregRedFlagsMore;

  /// No description provided for @redFlagsListHeading.
  ///
  /// In en, this message translates to:
  /// **'Seek care now for any of these'**
  String get redFlagsListHeading;

  /// No description provided for @redFlagHeadache.
  ///
  /// In en, this message translates to:
  /// **'A severe headache'**
  String get redFlagHeadache;

  /// No description provided for @redFlagVision.
  ///
  /// In en, this message translates to:
  /// **'Changes in your vision'**
  String get redFlagVision;

  /// No description provided for @redFlagUpperAbdomen.
  ///
  /// In en, this message translates to:
  /// **'Pain in the upper abdomen'**
  String get redFlagUpperAbdomen;

  /// No description provided for @redFlagSwelling.
  ///
  /// In en, this message translates to:
  /// **'Swelling of the face or hands'**
  String get redFlagSwelling;

  /// No description provided for @redFlagBreathing.
  ///
  /// In en, this message translates to:
  /// **'Difficulty breathing'**
  String get redFlagBreathing;

  /// No description provided for @redFlagBleeding.
  ///
  /// In en, this message translates to:
  /// **'Vaginal bleeding'**
  String get redFlagBleeding;

  /// No description provided for @redFlagMovements.
  ///
  /// In en, this message translates to:
  /// **'Your baby\'s movements slowing down, stopping or changing'**
  String get redFlagMovements;

  /// No description provided for @contractionsHeading.
  ///
  /// In en, this message translates to:
  /// **'Contraction timer'**
  String get contractionsHeading;

  /// No description provided for @contractionsIntro.
  ///
  /// In en, this message translates to:
  /// **'Press start when one begins and stop when it eases. femio keeps the times so you have them when you call.'**
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
  /// **'These are your times, as recorded. femio does not decide what they mean — read them out to your midwife or maternity unit, who can.'**
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
  /// **'femio keeps when it is, who it is with, and what you wanted to ask. It does not keep what was found — that belongs with your clinician, in your notes.'**
  String get apptNoResultsNote;

  /// No description provided for @apptEmptyHeading.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get apptEmptyHeading;

  /// No description provided for @apptEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add an appointment and femio will hold the questions you meant to ask, which is the part people forget in the room.'**
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
  /// **'Type of appointment'**
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
  /// **'Optional. femio will remind you to ask if the date passes — it never records what the result was.'**
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
  /// **'Add a reading whenever you like. femio draws them and keeps the numbers for your notes.'**
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
  /// **'Your readings, drawn as they are. femio does not show a target range or say whether a change is expected — what a pattern means is for you and your midwife or doctor.'**
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
  /// **'Cited guides, in plain words. Trying to conceive and pregnancy first.'**
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
  /// **'Your cycles vary too much to name fertile days from one date. Logging your periods, ovulation tests and waking temperature helps you tell afterwards whether you ovulated.'**
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

  /// No description provided for @helpNowCountry_egypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get helpNowCountry_egypt;

  /// No description provided for @helpNowCountry_saudi.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get helpNowCountry_saudi;

  /// No description provided for @helpNowCountry_uae.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get helpNowCountry_uae;

  /// No description provided for @helpNowCountry_qatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get helpNowCountry_qatar;

  /// No description provided for @helpNowCountry_kuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get helpNowCountry_kuwait;

  /// No description provided for @helpNowCountry_bahrain.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get helpNowCountry_bahrain;

  /// No description provided for @helpNowCountry_oman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get helpNowCountry_oman;

  /// No description provided for @helpNowCountry_jordan.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get helpNowCountry_jordan;

  /// No description provided for @helpNowCountry_lebanon.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get helpNowCountry_lebanon;

  /// No description provided for @helpNowCountry_morocco.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get helpNowCountry_morocco;

  /// No description provided for @helpNowCountry_uk.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get helpNowCountry_uk;

  /// No description provided for @helpNowCountry_france.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get helpNowCountry_france;

  /// No description provided for @helpNowCountry_spain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get helpNowCountry_spain;

  /// No description provided for @helpNowCountry_usa.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get helpNowCountry_usa;

  /// No description provided for @helpNowCountry_canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get helpNowCountry_canada;

  /// No description provided for @helpNowCountry_mexico.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get helpNowCountry_mexico;

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

  /// No description provided for @helpNowNumber_ae_ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance'**
  String get helpNowNumber_ae_ambulance;

  /// No description provided for @helpNowNumber_qa_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services (ambulance, police, civil defence)'**
  String get helpNowNumber_qa_emergency;

  /// No description provided for @helpNowNumber_qa_mental.
  ///
  /// In en, this message translates to:
  /// **'National mental health helpline, option 4 (Hamad Medical Corporation)'**
  String get helpNowNumber_qa_mental;

  /// No description provided for @helpNowNumber_kw_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services (Ministry of Interior)'**
  String get helpNowNumber_kw_emergency;

  /// No description provided for @helpNowNumber_bh_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_bh_emergency;

  /// No description provided for @helpNowNumber_om_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services (Royal Oman Police)'**
  String get helpNowNumber_om_emergency;

  /// No description provided for @helpNowNumber_om_dv.
  ///
  /// In en, this message translates to:
  /// **'Domestic violence line (listed by the Government of Oman)'**
  String get helpNowNumber_om_dv;

  /// No description provided for @helpNowNumber_jo_emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency services (Public Security Directorate)'**
  String get helpNowNumber_jo_emergency;

  /// No description provided for @helpNowNumber_jo_ambulance.
  ///
  /// In en, this message translates to:
  /// **'Ambulance (Civil Defence)'**
  String get helpNowNumber_jo_ambulance;

  /// No description provided for @helpNowNumber_jo_family.
  ///
  /// In en, this message translates to:
  /// **'Family Protection and Juvenile Department'**
  String get helpNowNumber_jo_family;

  /// No description provided for @helpNowNumber_lb_redcross.
  ///
  /// In en, this message translates to:
  /// **'Ambulance (Lebanese Red Cross)'**
  String get helpNowNumber_lb_redcross;

  /// No description provided for @helpNowNumber_lb_lifeline.
  ///
  /// In en, this message translates to:
  /// **'Emotional support lifeline (listed by the Ministry of Public Health)'**
  String get helpNowNumber_lb_lifeline;

  /// No description provided for @helpNowNumber_ma_samu.
  ///
  /// In en, this message translates to:
  /// **'Medical emergencies, SAMU (Ministry of Health)'**
  String get helpNowNumber_ma_samu;

  /// No description provided for @helpNowNumber_ma_police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get helpNowNumber_ma_police;

  /// No description provided for @helpNowNumber_gb_999.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_gb_999;

  /// No description provided for @helpNowNumber_gb_111.
  ///
  /// In en, this message translates to:
  /// **'NHS 111, mental health option'**
  String get helpNowNumber_gb_111;

  /// No description provided for @helpNowNumber_gb_refuge.
  ///
  /// In en, this message translates to:
  /// **'National domestic abuse helpline (Refuge)'**
  String get helpNowNumber_gb_refuge;

  /// No description provided for @helpNowNumber_fr_samu.
  ///
  /// In en, this message translates to:
  /// **'Medical emergencies, SAMU'**
  String get helpNowNumber_fr_samu;

  /// No description provided for @helpNowNumber_fr_3114.
  ///
  /// In en, this message translates to:
  /// **'National suicide prevention number'**
  String get helpNowNumber_fr_3114;

  /// No description provided for @helpNowNumber_fr_3919.
  ///
  /// In en, this message translates to:
  /// **'Violences Femmes Info'**
  String get helpNowNumber_fr_3919;

  /// No description provided for @helpNowNumber_es_112.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_es_112;

  /// No description provided for @helpNowNumber_es_024.
  ///
  /// In en, this message translates to:
  /// **'Suicidal behaviour helpline (Ministry of Health)'**
  String get helpNowNumber_es_024;

  /// No description provided for @helpNowNumber_es_016.
  ///
  /// In en, this message translates to:
  /// **'Gender violence information line, 016 (Ministry of Equality)'**
  String get helpNowNumber_es_016;

  /// No description provided for @helpNowNumber_us_911.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_us_911;

  /// No description provided for @helpNowNumber_us_988.
  ///
  /// In en, this message translates to:
  /// **'Suicide and Crisis Lifeline'**
  String get helpNowNumber_us_988;

  /// No description provided for @helpNowNumber_us_ndvh.
  ///
  /// In en, this message translates to:
  /// **'National Domestic Violence Hotline'**
  String get helpNowNumber_us_ndvh;

  /// No description provided for @helpNowNumber_ca_911.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_ca_911;

  /// No description provided for @helpNowNumber_ca_988.
  ///
  /// In en, this message translates to:
  /// **'Suicide Crisis Helpline'**
  String get helpNowNumber_ca_988;

  /// No description provided for @helpNowNumber_mx_911.
  ///
  /// In en, this message translates to:
  /// **'Emergency services'**
  String get helpNowNumber_mx_911;

  /// No description provided for @helpNowNumber_mx_vida.
  ///
  /// In en, this message translates to:
  /// **'Línea de la Vida (National Mental Health Commission)'**
  String get helpNowNumber_mx_vida;

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

  /// No description provided for @helpNowCall.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get helpNowCall;

  /// No description provided for @redFlagsReadGuide.
  ///
  /// In en, this message translates to:
  /// **'Read the pregnancy warning signs'**
  String get redFlagsReadGuide;

  /// No description provided for @plusProbeTitle.
  ///
  /// In en, this message translates to:
  /// **'femio Plus · billing check (test builds only)'**
  String get plusProbeTitle;

  /// No description provided for @plusProbeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap to ask Google Play whether billing is reachable on this phone. Nothing is bought.'**
  String get plusProbeSubtitle;

  /// No description provided for @plusProbeRunning.
  ///
  /// In en, this message translates to:
  /// **'Asking Google Play…'**
  String get plusProbeRunning;

  /// No description provided for @plusProbeAvailable.
  ///
  /// In en, this message translates to:
  /// **'Play Billing reachable: yes'**
  String get plusProbeAvailable;

  /// No description provided for @plusProbeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Play Billing reachable: no (no Play Store on this device, or not signed in)'**
  String get plusProbeUnavailable;

  /// No description provided for @plusProbeProductFound.
  ///
  /// In en, this message translates to:
  /// **'Product femio_plus found in Play Console'**
  String get plusProbeProductFound;

  /// No description provided for @plusProbeProductMissing.
  ///
  /// In en, this message translates to:
  /// **'Product femio_plus not found yet (expected until it is created in Play Console)'**
  String get plusProbeProductMissing;

  /// No description provided for @assistantPrivateNote.
  ///
  /// In en, this message translates to:
  /// **'This runs on your phone. Your words are not saved or sent anywhere.'**
  String get assistantPrivateNote;

  /// No description provided for @assistantModelNote.
  ///
  /// In en, this message translates to:
  /// **'Gemini Nano, the AI on your phone, helped with this.'**
  String get assistantModelNote;

  /// No description provided for @sayItButton.
  ///
  /// In en, this message translates to:
  /// **'Say it in your words'**
  String get sayItButton;

  /// No description provided for @sayItTitle.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get sayItTitle;

  /// No description provided for @sayItHint.
  ///
  /// In en, this message translates to:
  /// **'For example: bad cramps, light bleeding and so tired'**
  String get sayItHint;

  /// No description provided for @sayItAction.
  ///
  /// In en, this message translates to:
  /// **'Turn into log entries'**
  String get sayItAction;

  /// No description provided for @sayItNothing.
  ///
  /// In en, this message translates to:
  /// **'femio found nothing to log in that. Try other words, or tap the symptoms on the Log screen.'**
  String get sayItNothing;

  /// No description provided for @sayItFound.
  ///
  /// In en, this message translates to:
  /// **'femio found these. Untick anything that is wrong.'**
  String get sayItFound;

  /// No description provided for @sayItAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to this day\'s log'**
  String get sayItAdd;

  /// No description provided for @sayItAdded.
  ///
  /// In en, this message translates to:
  /// **'Added to your log.'**
  String get sayItAdded;

  /// No description provided for @safetyCrisisHeading.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to face this alone'**
  String get safetyCrisisHeading;

  /// No description provided for @safetyCrisisBody.
  ///
  /// In en, this message translates to:
  /// **'If you are thinking about harming yourself, please reach out now. The help page lists crisis lines for your country.'**
  String get safetyCrisisBody;

  /// No description provided for @safetyUrgentHeading.
  ///
  /// In en, this message translates to:
  /// **'This may need urgent care'**
  String get safetyUrgentHeading;

  /// No description provided for @safetyUrgentBody.
  ///
  /// In en, this message translates to:
  /// **'Chest pain, trouble breathing, fainting or a seizure need medical help now. Call your local emergency number.'**
  String get safetyUrgentBody;

  /// No description provided for @safetyBirthControl.
  ///
  /// In en, this message translates to:
  /// **'femio is not a way to avoid pregnancy and can\'t advise on it. A doctor, pharmacist or family-planning clinic can help you choose a method.'**
  String get safetyBirthControl;

  /// No description provided for @askDiagnosisHeading.
  ///
  /// In en, this message translates to:
  /// **'Only a clinician can tell'**
  String get askDiagnosisHeading;

  /// No description provided for @askDiagnosisBody.
  ///
  /// In en, this message translates to:
  /// **'femio can\'t tell whether you have a condition. A doctor can, after talking with you and, if needed, an examination or tests. Here is what trusted sources say about it.'**
  String get askDiagnosisBody;

  /// No description provided for @safetyHeavyBleedingHeading.
  ///
  /// In en, this message translates to:
  /// **'Heavy bleeding with dizziness'**
  String get safetyHeavyBleedingHeading;

  /// No description provided for @safetyHeavyBleedingBody.
  ///
  /// In en, this message translates to:
  /// **'ACOG says: “If you are changing pads or tampons every hour for more than 2 hours in a row, and you also have chest pain, have shortness of breath, and are lightheaded or dizzy, seek emergency medical care right away.” If that is you, call your local emergency number now. If heavy bleeding worries you, talk to your doctor.'**
  String get safetyHeavyBleedingBody;

  /// No description provided for @safetyPostpartumHeading.
  ///
  /// In en, this message translates to:
  /// **'A warning sign after birth'**
  String get safetyPostpartumHeading;

  /// No description provided for @safetyPostpartumBody.
  ///
  /// In en, this message translates to:
  /// **'In the year after birth, CDC\'s Hear Her campaign says to get medical care immediately for an urgent warning sign, such as heavy bleeding, a fever, a headache that won\'t go away or a swollen leg. Call your doctor or midwife now, or your local emergency number.'**
  String get safetyPostpartumBody;

  /// No description provided for @askTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask femio'**
  String get askTitle;

  /// No description provided for @askIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask a health question. femio answers only from trusted health sources it carries on your phone, such as CDC, MedlinePlus and the Office on Women\'s Health, and shows where every sentence came from.'**
  String get askIntro;

  /// No description provided for @askHint.
  ///
  /// In en, this message translates to:
  /// **'For example: what helps with period cramps?'**
  String get askHint;

  /// No description provided for @askAction.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get askAction;

  /// No description provided for @askWillSend.
  ///
  /// In en, this message translates to:
  /// **'This is exactly the question that will be sent, with the public sources:'**
  String get askWillSend;

  /// No description provided for @askSend.
  ///
  /// In en, this message translates to:
  /// **'Summarise with Cloud boost'**
  String get askSend;

  /// No description provided for @askStillPersonal.
  ///
  /// In en, this message translates to:
  /// **'This still mentions you. Remove words like “I” or “my” and any personal details.'**
  String get askStillPersonal;

  /// No description provided for @askCloudPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only this question and the public sources are sent. Nothing from your log is.'**
  String get askCloudPrivacy;

  /// No description provided for @askSearching.
  ///
  /// In en, this message translates to:
  /// **'Reading trusted sources…'**
  String get askSearching;

  /// No description provided for @askSourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get askSourcesTitle;

  /// No description provided for @askClinicianLine.
  ///
  /// In en, this message translates to:
  /// **'This is general information, not advice for you. For your own situation, talk to your clinician.'**
  String get askClinicianLine;

  /// No description provided for @askRelatedGuides.
  ///
  /// In en, this message translates to:
  /// **'femio guides on this'**
  String get askRelatedGuides;

  /// No description provided for @askSearchAgain.
  ///
  /// In en, this message translates to:
  /// **'Ask another question'**
  String get askSearchAgain;

  /// No description provided for @askAboutYouStays.
  ///
  /// In en, this message translates to:
  /// **'Your question is about you, so it stays on this phone. Here are the sources word for word.'**
  String get askAboutYouStays;

  /// No description provided for @askModelFellBack.
  ///
  /// In en, this message translates to:
  /// **'The AI could not write an answer that cites its sources, so here they are word for word.'**
  String get askModelFellBack;

  /// No description provided for @askBoostHeading.
  ///
  /// In en, this message translates to:
  /// **'Cloud boost'**
  String get askBoostHeading;

  /// No description provided for @askBoostConfirm.
  ///
  /// In en, this message translates to:
  /// **'This phone has no on-phone AI. With Cloud boost, Google\'s cloud AI can summarise these public sources for you. Check the question first.'**
  String get askBoostConfirm;

  /// No description provided for @askReadSourcesInstead.
  ///
  /// In en, this message translates to:
  /// **'Read the sources instead'**
  String get askReadSourcesInstead;

  /// No description provided for @askNotCoveredHeading.
  ///
  /// In en, this message translates to:
  /// **'Not covered yet'**
  String get askNotCoveredHeading;

  /// No description provided for @askNotCovered.
  ///
  /// In en, this message translates to:
  /// **'femio\'s trusted sources don\'t answer this, so femio won\'t guess. Try other words, read the links below, or ask your clinician.'**
  String get askNotCovered;

  /// No description provided for @askRegistryVersion.
  ///
  /// In en, this message translates to:
  /// **'Trusted sources library {version}'**
  String askRegistryVersion(String version);

  /// No description provided for @askAnswerOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Summarised on your phone by Gemini Nano, from the sources below'**
  String get askAnswerOnPhone;

  /// No description provided for @askAnswerCloud.
  ///
  /// In en, this message translates to:
  /// **'Summarised by Google\'s cloud AI (Cloud boost), from the sources below'**
  String get askAnswerCloud;

  /// No description provided for @askVerbatimLabel.
  ///
  /// In en, this message translates to:
  /// **'Word for word from trusted sources'**
  String get askVerbatimLabel;

  /// No description provided for @askEnglishNote.
  ///
  /// In en, this message translates to:
  /// **'These sources are in English. femio shows them word for word so nothing is lost in translation.'**
  String get askEnglishNote;

  /// No description provided for @askReadMore.
  ///
  /// In en, this message translates to:
  /// **'Read more from trusted organisations'**
  String get askReadMore;

  /// No description provided for @askSourceCopied.
  ///
  /// In en, this message translates to:
  /// **'{publisher} · copied {date}'**
  String askSourceCopied(String publisher, String date);

  /// No description provided for @askSourceReviewed.
  ///
  /// In en, this message translates to:
  /// **'{publisher} · reviewed {date}'**
  String askSourceReviewed(String publisher, String date);

  /// No description provided for @visitButton.
  ///
  /// In en, this message translates to:
  /// **'Visit summary'**
  String get visitButton;

  /// No description provided for @visitTitle.
  ///
  /// In en, this message translates to:
  /// **'Visit summary'**
  String get visitTitle;

  /// No description provided for @visitIntro.
  ///
  /// In en, this message translates to:
  /// **'A page to show your clinician, made from what you logged. It stays on your phone unless you copy it.'**
  String get visitIntro;

  /// No description provided for @visitCycles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No complete cycle logged yet} =1{1 cycle logged: {shortest} days} other{{count} cycles logged: {shortest} to {longest} days}}'**
  String visitCycles(int count, int longest, int shortest);

  /// No description provided for @visitLastPeriod.
  ///
  /// In en, this message translates to:
  /// **'Last period started {date}'**
  String visitLastPeriod(String date);

  /// No description provided for @visitIrregular.
  ///
  /// In en, this message translates to:
  /// **'Cycles described as irregular'**
  String get visitIrregular;

  /// No description provided for @visitTopTerms.
  ///
  /// In en, this message translates to:
  /// **'Logged most in the last 90 days'**
  String get visitTopTerms;

  /// No description provided for @visitDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day} other{{days} days}}'**
  String visitDays(int days);

  /// No description provided for @visitHeavyDays.
  ///
  /// In en, this message translates to:
  /// **'Days with heavy flow'**
  String get visitHeavyDays;

  /// No description provided for @visitOpkPositive.
  ///
  /// In en, this message translates to:
  /// **'Positive ovulation tests'**
  String get visitOpkPositive;

  /// No description provided for @visitTemperatureDays.
  ///
  /// In en, this message translates to:
  /// **'Days with a waking temperature'**
  String get visitTemperatureDays;

  /// No description provided for @visitTryingFor.
  ///
  /// In en, this message translates to:
  /// **'Trying to conceive'**
  String get visitTryingFor;

  /// No description provided for @visitQuestionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Questions you could ask'**
  String get visitQuestionsTitle;

  /// No description provided for @visitCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy as text'**
  String get visitCopy;

  /// No description provided for @visitCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied. Paste it into a message or your notes.'**
  String get visitCopied;

  /// No description provided for @visitQ_cycleSpread.
  ///
  /// In en, this message translates to:
  /// **'My cycle lengths vary. Is that worth looking into?'**
  String get visitQ_cycleSpread;

  /// No description provided for @visitQ_ttcTests.
  ///
  /// In en, this message translates to:
  /// **'Given how long I have been trying, which checks would you suggest?'**
  String get visitQ_ttcTests;

  /// No description provided for @visitQ_ovulation.
  ///
  /// In en, this message translates to:
  /// **'How can I find out whether I am ovulating?'**
  String get visitQ_ovulation;

  /// No description provided for @visitQ_folicAcid.
  ///
  /// In en, this message translates to:
  /// **'Should I be taking folic acid now?'**
  String get visitQ_folicAcid;

  /// No description provided for @visitQ_painfulPeriods.
  ///
  /// In en, this message translates to:
  /// **'My period pain affects my days. What can help?'**
  String get visitQ_painfulPeriods;

  /// No description provided for @visitQ_heavyPeriods.
  ///
  /// In en, this message translates to:
  /// **'My periods are heavy. Is a blood test worth doing?'**
  String get visitQ_heavyPeriods;

  /// No description provided for @visitQ_moodCycle.
  ///
  /// In en, this message translates to:
  /// **'My mood changes a lot around my period. Can we talk about it?'**
  String get visitQ_moodCycle;

  /// No description provided for @visitQ_skinHair.
  ///
  /// In en, this message translates to:
  /// **'I have skin or hair changes along with irregular cycles. Should these be checked together?'**
  String get visitQ_skinHair;

  /// No description provided for @visitQ_tiredness.
  ///
  /// In en, this message translates to:
  /// **'I often feel tired. Is anything worth checking?'**
  String get visitQ_tiredness;

  /// No description provided for @visitQ_menopause.
  ///
  /// In en, this message translates to:
  /// **'Could my symptoms be linked to perimenopause, and what are my options?'**
  String get visitQ_menopause;

  /// No description provided for @visitQ_pregnancyNext.
  ///
  /// In en, this message translates to:
  /// **'What should I look out for before our next visit?'**
  String get visitQ_pregnancyNext;

  /// No description provided for @visitQ_pregnancyMovements.
  ///
  /// In en, this message translates to:
  /// **'When should I start paying attention to the baby\'s movements?'**
  String get visitQ_pregnancyMovements;

  /// No description provided for @visitQ_anythingElse.
  ///
  /// In en, this message translates to:
  /// **'Is there anything in my log you would like to look at more closely?'**
  String get visitQ_anythingElse;

  /// No description provided for @assistantSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistantSettingsTitle;

  /// No description provided for @assistantSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'AI on your phone, trusted sources and Cloud boost'**
  String get assistantSettingsSub;

  /// No description provided for @assistantOnDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'AI on your phone (Gemini Nano)'**
  String get assistantOnDeviceTitle;

  /// No description provided for @assistantOnDeviceAvailable.
  ///
  /// In en, this message translates to:
  /// **'Ready. It reads your notes on the phone; nothing is sent.'**
  String get assistantOnDeviceAvailable;

  /// No description provided for @assistantOnDeviceDownloadable.
  ///
  /// In en, this message translates to:
  /// **'Can be downloaded to this phone.'**
  String get assistantOnDeviceDownloadable;

  /// No description provided for @assistantOnDeviceDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get assistantOnDeviceDownloading;

  /// No description provided for @assistantOnDeviceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available on this phone. femio uses its own word list on the phone instead.'**
  String get assistantOnDeviceUnavailable;

  /// No description provided for @assistantDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get assistantDownload;

  /// No description provided for @assistantCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud boost'**
  String get assistantCloudTitle;

  /// No description provided for @assistantCloudOn.
  ///
  /// In en, this message translates to:
  /// **'On. Used only when this phone has no on-phone AI.'**
  String get assistantCloudOn;

  /// No description provided for @assistantCloudOff.
  ///
  /// In en, this message translates to:
  /// **'Off. Everything is done on this phone.'**
  String get assistantCloudOff;

  /// No description provided for @assistantHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'Your log stays on your phone. Your notes and your log are read by femio\'s rules and, where your phone has it, by Gemini Nano on the phone. Safety rules always come first: signs of danger open the help page, and femio never advises on avoiding pregnancy. Ask femio answers only from trusted health sources carried in the app and shows them with every answer. Cloud boost is off unless you agree to it; then only what its screen lists is sent to Google.'**
  String get assistantHowItWorks;

  /// No description provided for @assistantCloudNotBuilt.
  ///
  /// In en, this message translates to:
  /// **'Not available in this version of the app.'**
  String get assistantCloudNotBuilt;

  /// No description provided for @boostTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud boost'**
  String get boostTitle;

  /// No description provided for @boostIntro.
  ///
  /// In en, this message translates to:
  /// **'Some phones have no on-phone AI. On those phones, Cloud boost lets Google\'s cloud AI summarise trusted sources for a question you approve, or put your tips in order. It is optional and stays off unless you agree below. Everything else in femio works without it.'**
  String get boostIntro;

  /// No description provided for @boostSendsHeading.
  ///
  /// In en, this message translates to:
  /// **'What may be sent'**
  String get boostSendsHeading;

  /// No description provided for @boostStageLabel.
  ///
  /// In en, this message translates to:
  /// **'Life stage'**
  String get boostStageLabel;

  /// No description provided for @boostStage.
  ///
  /// In en, this message translates to:
  /// **'{value, select, period{Tracking periods} ttc{Trying to conceive} pregnant{Pregnant} postpartum{After birth} menopause{Menopause} other{Not set}}'**
  String boostStage(String value);

  /// No description provided for @boostRegularityLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle regularity'**
  String get boostRegularityLabel;

  /// No description provided for @boostRegularity.
  ///
  /// In en, this message translates to:
  /// **'{value, select, regular{Regular} variable{Varies} unknown{Not known yet} notApplicable{Not tracked now} other{Not known yet}}'**
  String boostRegularity(String value);

  /// No description provided for @boostCategoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Kinds of symptom logged in the last month'**
  String get boostCategoriesLabel;

  /// No description provided for @boostCategory.
  ///
  /// In en, this message translates to:
  /// **'{value, select, pain{Pain} mood{Mood} digestion{Digestion} sleepAndEnergy{Sleep and energy} skinAndHair{Skin and hair} hotFlashes{Hot flushes} bladder{Bladder} other{Other}}'**
  String boostCategory(String value);

  /// No description provided for @boostNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get boostNone;

  /// No description provided for @boostStreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Logging streak'**
  String get boostStreakLabel;

  /// No description provided for @boostStreak.
  ///
  /// In en, this message translates to:
  /// **'{value, select, none{None} underAWeek{Under a week} weeks{A few weeks} overAMonth{Over a month} other{None}}'**
  String boostStreak(String value);

  /// No description provided for @boostNeverHeading.
  ///
  /// In en, this message translates to:
  /// **'What is never sent'**
  String get boostNeverHeading;

  /// No description provided for @boostNever.
  ///
  /// In en, this message translates to:
  /// **'Your notes, dates, log entries, cycle lengths, name, email, contacts or advertising ID.'**
  String get boostNever;

  /// No description provided for @boostTurnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn off Cloud boost'**
  String get boostTurnOff;

  /// No description provided for @boostNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get boostNotNow;

  /// No description provided for @boostAgreeQuestions.
  ///
  /// In en, this message translates to:
  /// **'I agree that femio may send a general question I approve, one at a time, with the public sources it found, so Google\'s cloud AI can summarise them. femio removes numbers, dates, names and contacts first, and I see the exact text before it goes.'**
  String get boostAgreeQuestions;

  /// No description provided for @boostAgreeTips.
  ///
  /// In en, this message translates to:
  /// **'I agree that femio may send these four broad facts about my health, exactly as shown, so Google\'s cloud AI can put my tips in order. This happens in the background while Cloud boost is on.'**
  String get boostAgreeTips;

  /// No description provided for @boostPurposeQuestions.
  ///
  /// In en, this message translates to:
  /// **'General questions'**
  String get boostPurposeQuestions;

  /// No description provided for @boostPurposeTips.
  ///
  /// In en, this message translates to:
  /// **'Tips from four broad facts'**
  String get boostPurposeTips;

  /// No description provided for @boostWhoHeading.
  ///
  /// In en, this message translates to:
  /// **'Who receives it, and where'**
  String get boostWhoHeading;

  /// No description provided for @boostWho.
  ///
  /// In en, this message translates to:
  /// **'Google processes it for femio through Firebase AI Logic (the Gemini Developer API, paid tier). Google may process it in the United States or other countries where it has servers, under its data processing terms. femio (KM Digital Labs, Cairo, Egypt) decides what is sent and is responsible for it.'**
  String get boostWho;

  /// No description provided for @boostKeptHeading.
  ///
  /// In en, this message translates to:
  /// **'How long it is kept'**
  String get boostKeptHeading;

  /// No description provided for @boostKept.
  ///
  /// In en, this message translates to:
  /// **'femio has no server and keeps none of it. Under the paid terms femio uses, Google does not use it to improve its products. Google keeps it for up to 55 days to detect misuse, and people at Google may review content that its systems flag as misuse.'**
  String get boostKept;

  /// No description provided for @boostAlsoSeen.
  ///
  /// In en, this message translates to:
  /// **'Like any internet connection, Google also sees your phone\'s internet address, and a check from Google Play that the request comes from the real femio app.'**
  String get boostAlsoSeen;

  /// No description provided for @boostChoiceHeading.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get boostChoiceHeading;

  /// No description provided for @boostChoice.
  ///
  /// In en, this message translates to:
  /// **'Agreeing is optional, and you can agree to one use and not the other. You can turn Cloud boost off at any time, here or in Settings › Assistant, as easily as you turned it on. Each phone asks again: a restored backup does not carry your agreement.'**
  String get boostChoice;

  /// No description provided for @boostReadNotice.
  ///
  /// In en, this message translates to:
  /// **'Read the privacy notice'**
  String get boostReadNotice;

  /// No description provided for @boostExplicit.
  ///
  /// In en, this message translates to:
  /// **'These facts and questions are about your health. By ticking a box and pressing I agree, you give your explicit consent to that use only. femio keeps a dated record of your choice on this phone, which you can see here.'**
  String get boostExplicit;

  /// No description provided for @boostAgree.
  ///
  /// In en, this message translates to:
  /// **'I agree'**
  String get boostAgree;

  /// No description provided for @boostReceiptHeading.
  ///
  /// In en, this message translates to:
  /// **'Your agreement'**
  String get boostReceiptHeading;

  /// No description provided for @boostReceipt.
  ///
  /// In en, this message translates to:
  /// **'You agreed on {date} to: {purposes}.'**
  String boostReceipt(String date, String purposes);

  /// No description provided for @boostWithdrawEffect.
  ///
  /// In en, this message translates to:
  /// **'Turning it off stops anything new being sent. It cannot recall what was already sent.'**
  String get boostWithdrawEffect;

  /// No description provided for @tip_trackDatesHelps.
  ///
  /// In en, this message translates to:
  /// **'Noting your period dates in the app helps you see your own pattern and gives a clinician clear facts.'**
  String get tip_trackDatesHelps;

  /// No description provided for @tip_periodLongerThanSeven.
  ///
  /// In en, this message translates to:
  /// **'A period that lasts longer than 7 days is worth mentioning to a clinician.'**
  String get tip_periodLongerThanSeven;

  /// No description provided for @tip_bleedingBetweenPeriods.
  ///
  /// In en, this message translates to:
  /// **'Bleeding between periods is worth mentioning to a clinician, so the cause can be looked into.'**
  String get tip_bleedingBetweenPeriods;

  /// No description provided for @tip_irregularCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Cycles shorter than 21 or longer than 35 days are called irregular. Mention this to a clinician, who can look at your dates with you.'**
  String get tip_irregularCheckIn;

  /// No description provided for @tip_stoppedThreeMonths.
  ///
  /// In en, this message translates to:
  /// **'A period that stops for more than three months without a clear reason is worth a clinician\'s check, whatever your age.'**
  String get tip_stoppedThreeMonths;

  /// No description provided for @tip_irregularWithOtherSigns.
  ///
  /// In en, this message translates to:
  /// **'Irregular periods together with other changes, such as weight gain, extra hair on your face, or dry or oily skin, are worth mentioning to a clinician.'**
  String get tip_irregularWithOtherSigns;

  /// No description provided for @tip_periodPainSeeClinician.
  ///
  /// In en, this message translates to:
  /// **'Period pain that stops you doing your usual daily activities is a reason to see a clinician.'**
  String get tip_periodPainSeeClinician;

  /// No description provided for @tip_severePainUrgent.
  ///
  /// In en, this message translates to:
  /// **'If pelvic or period pain is severe or worse than usual and painkillers have not helped, ask for urgent medical advice.'**
  String get tip_severePainUrgent;

  /// No description provided for @tip_symptomDiaryBeforeVisit.
  ///
  /// In en, this message translates to:
  /// **'Before a visit about period problems, a diary of your symptoms across the whole cycle gives your clinician a detailed picture of what happens and when.'**
  String get tip_symptomDiaryBeforeVisit;

  /// No description provided for @tip_heavyOrTired.
  ///
  /// In en, this message translates to:
  /// **'Periods that keep you from daily activities, or leave you tired or short of breath a lot, can be signs of heavy periods. A clinician can help.'**
  String get tip_heavyOrTired;

  /// No description provided for @tip_pmsDiary.
  ///
  /// In en, this message translates to:
  /// **'Keeping a diary of your symptoms for at least two cycles helps a clinician see whether they follow your period.'**
  String get tip_pmsDiary;

  /// No description provided for @tip_headachesAroundPeriod.
  ///
  /// In en, this message translates to:
  /// **'Migraines that come regularly before or during your period are worth mentioning to a clinician. A diary next to your period dates helps.'**
  String get tip_headachesAroundPeriod;

  /// No description provided for @tip_urineInfectionSeeClinician.
  ///
  /// In en, this message translates to:
  /// **'If you think you may have a urine infection, it is important to see a clinician. A urine test can tell.'**
  String get tip_urineInfectionSeeClinician;

  /// No description provided for @tip_leakingUrineTellClinician.
  ///
  /// In en, this message translates to:
  /// **'If you leak urine, it is worth telling a clinician, whatever the type or cause.'**
  String get tip_leakingUrineTellClinician;

  /// No description provided for @tip_cervicalScreeningTip.
  ///
  /// In en, this message translates to:
  /// **'WHO advises cervical screening every 5 to 10 years from age 30; local programmes vary. Ask your clinic whether you are due.'**
  String get tip_cervicalScreeningTip;

  /// No description provided for @tip_ttcOneYear.
  ///
  /// In en, this message translates to:
  /// **'If a year of trying has passed without a pregnancy, it is a good idea to see a clinician and have the common causes checked.'**
  String get tip_ttcOneYear;

  /// No description provided for @tip_ttcAgeSixMonths.
  ///
  /// In en, this message translates to:
  /// **'At 35 or older, it is advised to see a clinician after six months of trying, not twelve.'**
  String get tip_ttcAgeSixMonths;

  /// No description provided for @tip_ttcIrregularNoWait.
  ///
  /// In en, this message translates to:
  /// **'With irregular or no periods, it is worth talking to a clinician about trying to conceive without waiting a full year.'**
  String get tip_ttcIrregularNoWait;

  /// No description provided for @tip_regularSexTakesTime.
  ///
  /// In en, this message translates to:
  /// **'Most couples where the woman is under 40 conceive within a year of regular sex every 2 to 3 days. It can take time.'**
  String get tip_regularSexTakesTime;

  /// No description provided for @tip_testingTooEarly.
  ///
  /// In en, this message translates to:
  /// **'Testing very early can give a false negative. Follow the test\'s own instructions.'**
  String get tip_testingTooEarly;

  /// No description provided for @tip_folicAcidBeforePregnancy.
  ///
  /// In en, this message translates to:
  /// **'Folic acid, a B vitamin, is advised from at least a month before pregnancy. Ask a clinician how to get enough.'**
  String get tip_folicAcidBeforePregnancy;

  /// No description provided for @tip_talkBeforeTrying.
  ///
  /// In en, this message translates to:
  /// **'It is a good idea to talk to a clinician before trying to get pregnant. They can help you get your body ready.'**
  String get tip_talkBeforeTrying;

  /// No description provided for @tip_tryingIsStressful.
  ///
  /// In en, this message translates to:
  /// **'Trying to conceive can be stressful. Counselling and support groups may help you cope; you can ask a clinician about them.'**
  String get tip_tryingIsStressful;

  /// No description provided for @tip_movementsChangeCallNow.
  ///
  /// In en, this message translates to:
  /// **'If your baby moves less than usual or the usual pattern changes, call your midwife or maternity unit at once, even in the middle of the night.'**
  String get tip_movementsChangeCallNow;

  /// No description provided for @tip_firstMovementsBy24.
  ///
  /// In en, this message translates to:
  /// **'You should start to feel your baby move between 16 and 24 weeks. If there has been no movement by 24 weeks, tell your midwife.'**
  String get tip_firstMovementsBy24;

  /// No description provided for @tip_preeclampsiaSigns.
  ///
  /// In en, this message translates to:
  /// **'A severe headache that painkillers do not ease, vision problems, pain below the ribs or sudden swelling need checking at once. Call your maternity unit.'**
  String get tip_preeclampsiaSigns;

  /// No description provided for @tip_antenatalChecksMatter.
  ///
  /// In en, this message translates to:
  /// **'Blood pressure and urine checks at antenatal visits can find changes you cannot feel, so try to keep every appointment.'**
  String get tip_antenatalChecksMatter;

  /// No description provided for @tip_screeningVersusDiagnostic.
  ///
  /// In en, this message translates to:
  /// **'Two kinds of tests are offered to every pregnant woman: screening tests, which show a chance, and follow-up tests, which give a firmer answer. Ask which suit you.'**
  String get tip_screeningVersusDiagnostic;

  /// No description provided for @tip_glucoseScreening.
  ///
  /// In en, this message translates to:
  /// **'All pregnant women should be screened for gestational diabetes. Ask your midwife or doctor when yours is planned.'**
  String get tip_glucoseScreening;

  /// No description provided for @tip_rhBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'A simple blood test shows your blood type and Rh status, usually at your first antenatal visit. Ask what yours is and whether it matters for your care.'**
  String get tip_rhBloodGroup;

  /// No description provided for @tip_mainScanBetween18And21.
  ///
  /// In en, this message translates to:
  /// **'A detailed scan is usually done between 18 and 21 weeks. It checks your baby\'s growth and looks for certain conditions.'**
  String get tip_mainScanBetween18And21;

  /// No description provided for @tip_severeSicknessTellEarly.
  ///
  /// In en, this message translates to:
  /// **'If you are being sick often and cannot keep food down, tell your midwife or doctor as soon as you can, so they can help you keep fluids down.'**
  String get tip_severeSicknessTellEarly;

  /// No description provided for @tip_itchTellMidwife.
  ///
  /// In en, this message translates to:
  /// **'Itching is common in pregnancy, but it can be the first sign of a liver condition called ICP. Tell your midwife or doctor so it can be checked.'**
  String get tip_itchTellMidwife;

  /// No description provided for @tip_pretermLabourSigns.
  ///
  /// In en, this message translates to:
  /// **'Signs of early labour include contractions every 10 minutes or more often, leaking fluid or bleeding, pelvic pressure and a low, dull backache. Contact your midwife, doctor or maternity unit.'**
  String get tip_pretermLabourSigns;

  /// No description provided for @tip_tirednessInPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Tiredness in pregnancy has many causes, and anaemia is one of them. Mention ongoing tiredness to your midwife or doctor.'**
  String get tip_tirednessInPregnancy;

  /// No description provided for @tip_lowMoodPerinatal.
  ///
  /// In en, this message translates to:
  /// **'Feeling low is common in pregnancy and after birth, and support is available. Tell your midwife or doctor, even if you only have some of the signs.'**
  String get tip_lowMoodPerinatal;

  /// No description provided for @tip_anxietyInPregnancy.
  ///
  /// In en, this message translates to:
  /// **'Anxiety in pregnancy can often be helped with talking therapy. Tell your midwife or doctor how you really feel.'**
  String get tip_anxietyInPregnancy;

  /// No description provided for @tip_warningSignsPregnancyAndYear.
  ///
  /// In en, this message translates to:
  /// **'Some warning signs need care at once, in pregnancy and for a year after birth: a headache that will not go away, vision changes, fever, trouble breathing, severe belly pain.'**
  String get tip_warningSignsPregnancyAndYear;

  /// No description provided for @tip_postnatalCheckSixToEight.
  ///
  /// In en, this message translates to:
  /// **'A postnatal check around 6 to 8 weeks after birth makes sure you feel well and are recovering. Write down your questions to take along.'**
  String get tip_postnatalCheckSixToEight;

  /// No description provided for @tip_painfulFeedsGetHelp.
  ///
  /// In en, this message translates to:
  /// **'If you are putting off feeds because breastfeeding hurts, get help from a lactation consultant.'**
  String get tip_painfulFeedsGetHelp;

  /// No description provided for @tip_tirednessAfterBirthThyroid.
  ///
  /// In en, this message translates to:
  /// **'Tiredness after birth has many causes. Thyroid inflammation affects about 1 in 20 women in the first year after birth, so mention lasting tiredness to a clinician.'**
  String get tip_tirednessAfterBirthThyroid;

  /// No description provided for @tip_bleedingUpToSixWeeks.
  ///
  /// In en, this message translates to:
  /// **'Spotting or bleeding like a period, on and off, can last up to six weeks after birth. Tell a clinician if you are worried.'**
  String get tip_bleedingUpToSixWeeks;

  /// No description provided for @tip_babyBluesPassing.
  ///
  /// In en, this message translates to:
  /// **'Feeling down, anxious or irritable for a few days after birth is very common and usually passes within 2 weeks. If it lasts longer, tell a clinician.'**
  String get tip_babyBluesPassing;

  /// No description provided for @tip_periodChangesFirstSign.
  ///
  /// In en, this message translates to:
  /// **'A change in your periods is usually one of the first signs of perimenopause. They may come more or less often, and be heavier or lighter.'**
  String get tip_periodChangesFirstSign;

  /// No description provided for @tip_twelveMonthsMeansMenopause.
  ///
  /// In en, this message translates to:
  /// **'Menopause means 12 months without a period. In the years before, cycles often vary, with longer or shorter gaps.'**
  String get tip_twelveMonthsMeansMenopause;

  /// No description provided for @tip_bleedingAfterMenopause.
  ///
  /// In en, this message translates to:
  /// **'Bleeding after menopause, meaning 12 months with no period, is important to tell a clinician about, so the cause can be found.'**
  String get tip_bleedingAfterMenopause;

  /// No description provided for @tip_hotFlushesTalkOptions.
  ///
  /// In en, this message translates to:
  /// **'If lifestyle changes are not enough for hot flushes, contact a clinician. They will talk through your symptoms, history and preferences.'**
  String get tip_hotFlushesTalkOptions;

  /// No description provided for @tip_boneStrengthMenopause.
  ///
  /// In en, this message translates to:
  /// **'Loss of bone density is more likely around menopause. Ask a clinician about bone health and what suits you.'**
  String get tip_boneStrengthMenopause;

  /// No description provided for @tip_drynessManyTreatments.
  ///
  /// In en, this message translates to:
  /// **'There are many treatments for vaginal dryness. It is worth asking a clinician what could suit you.'**
  String get tip_drynessManyTreatments;

  /// No description provided for @tip_heartbeatAroundMenopause.
  ///
  /// In en, this message translates to:
  /// **'A faster or more noticeable heartbeat can be part of perimenopause and menopause. Note when it happens and tell a clinician.'**
  String get tip_heartbeatAroundMenopause;

  /// No description provided for @tip_lowMoodMenopause.
  ///
  /// In en, this message translates to:
  /// **'Low mood and anxiety can be part of the menopause transition. If they are hard to manage, talk to a clinician.'**
  String get tip_lowMoodMenopause;

  /// No description provided for @visitQ_periodsStoppedChecks.
  ///
  /// In en, this message translates to:
  /// **'My periods have become very infrequent or have stopped. Which checks could find out why?'**
  String get visitQ_periodsStoppedChecks;

  /// No description provided for @visitQ_irregularCauses.
  ///
  /// In en, this message translates to:
  /// **'What could explain my irregular cycles, and would any tests or scans help?'**
  String get visitQ_irregularCauses;

  /// No description provided for @visitQ_irregularAcneChecks.
  ///
  /// In en, this message translates to:
  /// **'I have irregular periods and acne. Which checks could look for a cause?'**
  String get visitQ_irregularAcneChecks;

  /// No description provided for @visitQ_painCauseChecks.
  ///
  /// In en, this message translates to:
  /// **'My period pain keeps getting in the way of my days. Which checks could find out why?'**
  String get visitQ_painCauseChecks;

  /// No description provided for @visitQ_heavyAndTiredBloodTest.
  ///
  /// In en, this message translates to:
  /// **'My periods may be heavy and I feel tired a lot. Should I have blood tests, for example for iron?'**
  String get visitQ_heavyAndTiredBloodTest;

  /// No description provided for @visitQ_diaryReviewCycle.
  ///
  /// In en, this message translates to:
  /// **'Can we go through my symptom diary to see whether my symptoms follow my cycle?'**
  String get visitQ_diaryReviewCycle;

  /// No description provided for @visitQ_headacheDiaryReview.
  ///
  /// In en, this message translates to:
  /// **'My migraines often come around my period. Can we look at my diary together?'**
  String get visitQ_headacheDiaryReview;

  /// No description provided for @visitQ_cervicalScreeningDue.
  ///
  /// In en, this message translates to:
  /// **'Am I up to date with cervical screening, and which test does your clinic use?'**
  String get visitQ_cervicalScreeningDue;

  /// No description provided for @visitQ_checksForCouple.
  ///
  /// In en, this message translates to:
  /// **'Which fertility checks do you suggest for me, and for a partner if I have one?'**
  String get visitQ_checksForCouple;

  /// No description provided for @visitQ_ttcOverThirtyFiveSooner.
  ///
  /// In en, this message translates to:
  /// **'I am 35 or older and have been trying for about six months or more. Should I start fertility checks now?'**
  String get visitQ_ttcOverThirtyFiveSooner;

  /// No description provided for @visitQ_irregularTryingNow.
  ///
  /// In en, this message translates to:
  /// **'My cycles are irregular and I am trying to conceive. Should we talk about help now rather than waiting a year?'**
  String get visitQ_irregularTryingNow;

  /// No description provided for @visitQ_preconceptionReview.
  ///
  /// In en, this message translates to:
  /// **'We are planning a pregnancy. Is there anything in my health or medicines to review first?'**
  String get visitQ_preconceptionReview;

  /// No description provided for @visitQ_ttcSupportOptions.
  ///
  /// In en, this message translates to:
  /// **'Trying to conceive is weighing on me. Where can I find counselling or support?'**
  String get visitQ_ttcSupportOptions;

  /// No description provided for @visitQ_pregnancyTestsOffered.
  ///
  /// In en, this message translates to:
  /// **'Which screening tests and follow-up tests are offered in my pregnancy, and what does each one tell me?'**
  String get visitQ_pregnancyTestsOffered;

  /// No description provided for @visitQ_glucoseTestWhen.
  ///
  /// In en, this message translates to:
  /// **'When will I be tested for gestational diabetes, and could it be earlier for me?'**
  String get visitQ_glucoseTestWhen;

  /// No description provided for @visitQ_movementsCallWho.
  ///
  /// In en, this message translates to:
  /// **'Who do I call if my baby\'s movements change, including at night?'**
  String get visitQ_movementsCallWho;

  /// No description provided for @visitQ_sameDayWarningSigns.
  ///
  /// In en, this message translates to:
  /// **'Which signs should make me call the maternity unit the same day?'**
  String get visitQ_sameDayWarningSigns;

  /// No description provided for @visitQ_rhFactorChecked.
  ///
  /// In en, this message translates to:
  /// **'Has my blood group and Rh factor been checked, and does it change anything in my care?'**
  String get visitQ_rhFactorChecked;

  /// No description provided for @visitQ_pregnancyLowMoodSupport.
  ///
  /// In en, this message translates to:
  /// **'I have felt low or very worried for a while. What support is available?'**
  String get visitQ_pregnancyLowMoodSupport;

  /// No description provided for @visitQ_severeSicknessHelp.
  ///
  /// In en, this message translates to:
  /// **'My sickness makes it hard to keep food and drink down. What help is available?'**
  String get visitQ_severeSicknessHelp;

  /// No description provided for @visitQ_itchBloodTests.
  ///
  /// In en, this message translates to:
  /// **'I have had itching in pregnancy. Should I have blood tests to check my liver?'**
  String get visitQ_itchBloodTests;

  /// No description provided for @visitQ_pretermSignsPlan.
  ///
  /// In en, this message translates to:
  /// **'Which signs of early labour should make me call or come in, and where do I go out of hours?'**
  String get visitQ_pretermSignsPlan;

  /// No description provided for @visitQ_postnatalCheckTalk.
  ///
  /// In en, this message translates to:
  /// **'Can we go through how I am recovering, including bleeding, pain, mood and bladder changes?'**
  String get visitQ_postnatalCheckTalk;

  /// No description provided for @visitQ_postnatalMoodHelp.
  ///
  /// In en, this message translates to:
  /// **'I have felt low or anxious since the birth. What help is there?'**
  String get visitQ_postnatalMoodHelp;

  /// No description provided for @visitQ_latchCheck.
  ///
  /// In en, this message translates to:
  /// **'Feeding hurts. Could someone watch a feed and check how my baby latches?'**
  String get visitQ_latchCheck;

  /// No description provided for @visitQ_warningSignsYearAfter.
  ///
  /// In en, this message translates to:
  /// **'Which symptoms in the year after birth should make me seek care at once?'**
  String get visitQ_warningSignsYearAfter;

  /// No description provided for @visitQ_thyroidAfterBirth.
  ///
  /// In en, this message translates to:
  /// **'I have felt very tired since the birth. Should my thyroid be checked with a blood test?'**
  String get visitQ_thyroidAfterBirth;

  /// No description provided for @visitQ_urineLeaksHelp.
  ///
  /// In en, this message translates to:
  /// **'I leak urine. What can help, and would pelvic floor exercises suit me?'**
  String get visitQ_urineLeaksHelp;

  /// No description provided for @visitQ_hotFlushOptions.
  ///
  /// In en, this message translates to:
  /// **'Hot flushes or night sweats are affecting my days. What options could we talk through?'**
  String get visitQ_hotFlushOptions;

  /// No description provided for @visitQ_changedBleedingChecks.
  ///
  /// In en, this message translates to:
  /// **'My bleeding pattern has changed. Which checks are worth doing?'**
  String get visitQ_changedBleedingChecks;

  /// No description provided for @visitQ_bleedingAfterMenopauseChecks.
  ///
  /// In en, this message translates to:
  /// **'I have had bleeding or spotting at this stage. What checks do I need, and how soon?'**
  String get visitQ_bleedingAfterMenopauseChecks;

  /// No description provided for @visitQ_boneAndHeartHealth.
  ///
  /// In en, this message translates to:
  /// **'What can I do to protect my bone and heart health at this stage?'**
  String get visitQ_boneAndHeartHealth;

  /// No description provided for @visitQ_drynessWhatHelps.
  ///
  /// In en, this message translates to:
  /// **'I have vaginal dryness or discomfort. What can help, and what needs checking?'**
  String get visitQ_drynessWhatHelps;

  /// No description provided for @visitQ_urineTestAgain.
  ///
  /// In en, this message translates to:
  /// **'My urine symptoms keep coming back. Should I have a urine test, and how can we find the cause?'**
  String get visitQ_urineTestAgain;

  /// No description provided for @visitQ_thyroidCheckIrregular.
  ///
  /// In en, this message translates to:
  /// **'My periods are irregular and my hair is thinning. Should my thyroid be checked with a blood test?'**
  String get visitQ_thyroidCheckIrregular;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get tipsTitle;

  /// No description provided for @tipsSource.
  ///
  /// In en, this message translates to:
  /// **'Source: {publisher}'**
  String tipsSource(String publisher);

  /// No description provided for @tipsChosenOnPhone.
  ///
  /// In en, this message translates to:
  /// **'Chosen on your phone from your log. Each tip is a reviewed sentence with its source.'**
  String get tipsChosenOnPhone;

  /// No description provided for @tipsOrderedCloud.
  ///
  /// In en, this message translates to:
  /// **'Put in order with Cloud boost, from broad facts only.'**
  String get tipsOrderedCloud;

  /// No description provided for @legendPossible.
  ///
  /// In en, this message translates to:
  /// **'Period possible (low confidence)'**
  String get legendPossible;

  /// No description provided for @confidenceLowShort.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get confidenceLowShort;

  /// No description provided for @upcomingPeriodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Next periods'**
  String get upcomingPeriodsTitle;

  /// No description provided for @upcomingPeriodsWider.
  ///
  /// In en, this message translates to:
  /// **'Each later period is a wider range: the further ahead, the less certain.'**
  String get upcomingPeriodsWider;

  /// No description provided for @upcomingPeriodsOnlyNext.
  ///
  /// In en, this message translates to:
  /// **'Only the next period is shown: your logged cycles vary too much, or there are too few yet, to reach further ahead.'**
  String get upcomingPeriodsOnlyNext;

  /// No description provided for @todayUrgentBody.
  ///
  /// In en, this message translates to:
  /// **'If something feels severe or sudden, get care now. The emergency numbers for your country are one tap away.'**
  String get todayUrgentBody;

  /// No description provided for @toolsTitle.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get toolsTitle;

  /// No description provided for @toolsSub.
  ///
  /// In en, this message translates to:
  /// **'These calculators give general estimates for learning and planning, not medical advice. Talk to your clinician about your health.'**
  String get toolsSub;

  /// No description provided for @toolDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Due date calculator'**
  String get toolDueTitle;

  /// No description provided for @toolDueDesc.
  ///
  /// In en, this message translates to:
  /// **'From your last period, conception, an IVF transfer or a scan.'**
  String get toolDueDesc;

  /// No description provided for @toolCalTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy calendar'**
  String get toolCalTitle;

  /// No description provided for @toolCalDesc.
  ///
  /// In en, this message translates to:
  /// **'The dates of every pregnancy week, with each week\'s guide.'**
  String get toolCalDesc;

  /// No description provided for @toolGainTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy weight gain'**
  String get toolGainTitle;

  /// No description provided for @toolGainDesc.
  ///
  /// In en, this message translates to:
  /// **'The reference range for your BMI before pregnancy.'**
  String get toolGainDesc;

  /// No description provided for @toolDueMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'How do you know the date?'**
  String get toolDueMethodLabel;

  /// No description provided for @toolDueMethodLmp.
  ///
  /// In en, this message translates to:
  /// **'Last period'**
  String get toolDueMethodLmp;

  /// No description provided for @toolDueMethodConception.
  ///
  /// In en, this message translates to:
  /// **'Conception'**
  String get toolDueMethodConception;

  /// No description provided for @toolDueMethodTransfer.
  ///
  /// In en, this message translates to:
  /// **'IVF transfer'**
  String get toolDueMethodTransfer;

  /// No description provided for @toolDueMethodScan.
  ///
  /// In en, this message translates to:
  /// **'Dating scan'**
  String get toolDueMethodScan;

  /// No description provided for @toolEmbryoLabel.
  ///
  /// In en, this message translates to:
  /// **'Embryo age at transfer'**
  String get toolEmbryoLabel;

  /// No description provided for @toolEmbryo3.
  ///
  /// In en, this message translates to:
  /// **'Day 3'**
  String get toolEmbryo3;

  /// No description provided for @toolEmbryo5.
  ///
  /// In en, this message translates to:
  /// **'Day 5'**
  String get toolEmbryo5;

  /// No description provided for @toolPromptLmp.
  ///
  /// In en, this message translates to:
  /// **'Tap the day your last period started'**
  String get toolPromptLmp;

  /// No description provided for @toolPromptConception.
  ///
  /// In en, this message translates to:
  /// **'Tap the day you conceived'**
  String get toolPromptConception;

  /// No description provided for @toolPromptTransfer.
  ///
  /// In en, this message translates to:
  /// **'Tap the day of the embryo transfer'**
  String get toolPromptTransfer;

  /// No description provided for @toolPromptScan.
  ///
  /// In en, this message translates to:
  /// **'Tap the day of your scan'**
  String get toolPromptScan;

  /// No description provided for @toolCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle length'**
  String get toolCycleLabel;

  /// No description provided for @toolDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} day} other {{count} days}}'**
  String toolDays(int count);

  /// No description provided for @toolScanWeeksLabel.
  ///
  /// In en, this message translates to:
  /// **'Weeks on the scan report'**
  String get toolScanWeeksLabel;

  /// No description provided for @toolScanDaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Extra days on the report'**
  String get toolScanDaysLabel;

  /// No description provided for @toolWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} week} other {{count} weeks}}'**
  String toolWeeks(int count);

  /// No description provided for @toolTermWindow.
  ///
  /// In en, this message translates to:
  /// **'Most babies arrive between {start} and {end}.'**
  String toolTermWindow(String start, String end);

  /// No description provided for @toolScanNote.
  ///
  /// In en, this message translates to:
  /// **'This uses the weeks and days on your scan report as written. If your clinician has given you a due date, follow theirs.'**
  String get toolScanNote;

  /// No description provided for @toolEstimateNote.
  ///
  /// In en, this message translates to:
  /// **'These dates are estimates based on the date you entered. Every body is different.'**
  String get toolEstimateNote;

  /// No description provided for @toolClinicianAdjust.
  ///
  /// In en, this message translates to:
  /// **'Your clinician may adjust the date after a scan.'**
  String get toolClinicianAdjust;

  /// No description provided for @toolCalMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Which date do you know?'**
  String get toolCalMethodLabel;

  /// No description provided for @toolCalMethodEdd.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get toolCalMethodEdd;

  /// No description provided for @toolCalMethodLmp.
  ///
  /// In en, this message translates to:
  /// **'Last period'**
  String get toolCalMethodLmp;

  /// No description provided for @toolCalPromptEdd.
  ///
  /// In en, this message translates to:
  /// **'Tap your due date'**
  String get toolCalPromptEdd;

  /// No description provided for @toolCalEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Your pregnancy, week by week'**
  String get toolCalEyebrow;

  /// No description provided for @toolCalTrimesterLine.
  ///
  /// In en, this message translates to:
  /// **'Second trimester from {second}; third trimester from {third}.'**
  String toolCalTrimesterLine(String second, String third);

  /// No description provided for @toolCalWeek.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String toolCalWeek(String week);

  /// No description provided for @toolCalCurrent.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get toolCalCurrent;

  /// No description provided for @toolCalReadGuide.
  ///
  /// In en, this message translates to:
  /// **'Read the week {week} guide'**
  String toolCalReadGuide(String week);

  /// No description provided for @toolGainIntro.
  ///
  /// In en, this message translates to:
  /// **'Enter your weight before pregnancy and your height to see the reference range for total weight gain over the pregnancy, from the Institute of Medicine (2009). Nothing is stored.'**
  String get toolGainIntro;

  /// No description provided for @toolGainWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight before pregnancy (kg)'**
  String get toolGainWeight;

  /// No description provided for @toolGainHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get toolGainHeight;

  /// No description provided for @toolGainBabiesLabel.
  ///
  /// In en, this message translates to:
  /// **'How many babies?'**
  String get toolGainBabiesLabel;

  /// No description provided for @toolGainBabiesOne.
  ///
  /// In en, this message translates to:
  /// **'One'**
  String get toolGainBabiesOne;

  /// No description provided for @toolGainBabiesTwo.
  ///
  /// In en, this message translates to:
  /// **'Twins'**
  String get toolGainBabiesTwo;

  /// No description provided for @toolGainBabiesMore.
  ///
  /// In en, this message translates to:
  /// **'Three or more'**
  String get toolGainBabiesMore;

  /// No description provided for @toolGainBmiLine.
  ///
  /// In en, this message translates to:
  /// **'BMI before pregnancy: {value} ({band})'**
  String toolGainBmiLine(String value, String band);

  /// No description provided for @toolBandUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Underweight'**
  String get toolBandUnderweight;

  /// No description provided for @toolBandNormal.
  ///
  /// In en, this message translates to:
  /// **'Healthy range'**
  String get toolBandNormal;

  /// No description provided for @toolBandOverweight.
  ///
  /// In en, this message translates to:
  /// **'Overweight'**
  String get toolBandOverweight;

  /// No description provided for @toolBandObese.
  ///
  /// In en, this message translates to:
  /// **'Obese'**
  String get toolBandObese;

  /// No description provided for @toolGainEyebrow.
  ///
  /// In en, this message translates to:
  /// **'Reference range for total gain over the whole pregnancy'**
  String get toolGainEyebrow;

  /// No description provided for @toolGainRangeKg.
  ///
  /// In en, this message translates to:
  /// **'{low} to {high} kg'**
  String toolGainRangeKg(String low, String high);

  /// No description provided for @toolGainRangeLb.
  ///
  /// In en, this message translates to:
  /// **'{low} to {high} lb'**
  String toolGainRangeLb(String low, String high);

  /// No description provided for @toolGainOtherUnit.
  ///
  /// In en, this message translates to:
  /// **'That is {range}.'**
  String toolGainOtherUnit(String range);

  /// No description provided for @toolGainNoRangeTwins.
  ///
  /// In en, this message translates to:
  /// **'The Institute of Medicine gives no range for twins when BMI before pregnancy is under 18.5. Your clinician will advise.'**
  String get toolGainNoRangeTwins;

  /// No description provided for @toolGainNoRangeMultiples.
  ///
  /// In en, this message translates to:
  /// **'The Institute of Medicine gives no range for three or more babies. Your clinician will advise.'**
  String get toolGainNoRangeMultiples;

  /// No description provided for @toolGainNote.
  ///
  /// In en, this message translates to:
  /// **'This is a reference range for your BMI band before pregnancy, not a target or a judgement. Your clinician may suggest a different range for you.'**
  String get toolGainNote;

  /// No description provided for @toolGainSource.
  ///
  /// In en, this message translates to:
  /// **'Source: Institute of Medicine (2009), \"Weight Gain During Pregnancy\"; the same ranges are used by CDC and ACOG.'**
  String get toolGainSource;

  /// No description provided for @toolGainOutOfRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a weight from {minW} to {maxW} kg and a height from {minH} to {maxH} cm.'**
  String toolGainOutOfRange(String minW, String maxW, String minH, String maxH);

  /// No description provided for @toolNothingSaved.
  ///
  /// In en, this message translates to:
  /// **'Nothing you enter here is saved.'**
  String get toolNothingSaved;

  /// Quiet card on the home screen when Google Play has a newer femio (R12.3).
  ///
  /// In en, this message translates to:
  /// **'A new version of femio is ready.'**
  String get updateBannerBody;

  /// Button on the update card; starts Google Play's update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateBannerAction;

  /// Settings › Privacy screen listing every network path (R8.21, rule 4).
  ///
  /// In en, this message translates to:
  /// **'What can leave this phone'**
  String get leaveTitle;

  /// No description provided for @leaveIntro.
  ///
  /// In en, this message translates to:
  /// **'Your records stay on this phone. These are the only times femio, or the Google services it relies on, use the internet.'**
  String get leaveIntro;

  /// No description provided for @leaveBoostOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get leaveBoostOff;

  /// Cloud boost status; purposes is a comma-separated list of the consented uses.
  ///
  /// In en, this message translates to:
  /// **'On for: {purposes}'**
  String leaveBoostOn(String purposes);

  /// No description provided for @leaveBoostBody.
  ///
  /// In en, this message translates to:
  /// **'Only if you agree: a general question you approve, or four broad facts, goes to Google\'s cloud AI. Google Play also confirms the request comes from the real femio app.'**
  String get leaveBoostBody;

  /// No description provided for @leaveModelHeading.
  ///
  /// In en, this message translates to:
  /// **'The on-phone AI model'**
  String get leaveModelHeading;

  /// No description provided for @leaveModelBody.
  ///
  /// In en, this message translates to:
  /// **'If you tap Download, Android\'s AI service (AICore, run by Google) downloads Gemini Nano and keeps it up to date. Google\'s AI software may also send Google technical information, such as errors and performance. femio adds none of your records to it.'**
  String get leaveModelBody;

  /// No description provided for @leavePlayHeading.
  ///
  /// In en, this message translates to:
  /// **'Google Play'**
  String get leavePlayHeading;

  /// No description provided for @leavePlayBody.
  ///
  /// In en, this message translates to:
  /// **'Google Play installs and updates femio, may show its rating request, and handles femio Plus payments. It tells us only totals, such as installs and crashes. femio sends Google Play nothing of yours.'**
  String get leavePlayBody;

  /// No description provided for @leaveBackupHeading.
  ///
  /// In en, this message translates to:
  /// **'Your backup'**
  String get leaveBackupHeading;

  /// No description provided for @leaveBackupBody.
  ///
  /// In en, this message translates to:
  /// **'A backup goes only where you choose to save it, sealed with your passphrase.'**
  String get leaveBackupBody;

  /// No description provided for @leaveLinksHeading.
  ///
  /// In en, this message translates to:
  /// **'Links you open'**
  String get leaveLinksHeading;

  /// No description provided for @leaveLinksBody.
  ///
  /// In en, this message translates to:
  /// **'Sources and pages you open go to your browser, which visits that website.'**
  String get leaveLinksBody;

  /// No description provided for @leaveNever.
  ///
  /// In en, this message translates to:
  /// **'Nothing else leaves. femio has no ads, no analytics, no tracking tools and no account.'**
  String get leaveNever;

  /// No description provided for @leaveSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Every way anything reaches the internet'**
  String get leaveSettingsSub;

  /// Settings › Assistant master switch for every AI use (ADR-081 kill switch 3).
  ///
  /// In en, this message translates to:
  /// **'Use the assistant'**
  String get assistantMasterTitle;

  /// No description provided for @assistantMasterOff.
  ///
  /// In en, this message translates to:
  /// **'Off: femio answers from its rules and guides only. No AI runs, on the phone or in the cloud.'**
  String get assistantMasterOff;

  /// No description provided for @assistantMasterOn.
  ///
  /// In en, this message translates to:
  /// **'On: the AI adds explanations beside femio\'s own answers. Everything works without it.'**
  String get assistantMasterOn;

  /// Settings › Assistant screen generated from usePolicies (R10.3, ADR-081).
  ///
  /// In en, this message translates to:
  /// **'What the AI can see'**
  String get aiSeesTitle;

  /// No description provided for @aiSeesSub.
  ///
  /// In en, this message translates to:
  /// **'Each AI feature, where it runs and what it receives'**
  String get aiSeesSub;

  /// No description provided for @aiSeesIntro.
  ///
  /// In en, this message translates to:
  /// **'The AI never sees your whole record. Each feature receives only the items listed under it, and femio\'s own safety rules always answer first.'**
  String get aiSeesIntro;

  /// No description provided for @aiSeesOff.
  ///
  /// In en, this message translates to:
  /// **'The assistant is off, so none of these run.'**
  String get aiSeesOff;

  /// No description provided for @aiUseAskInCloud.
  ///
  /// In en, this message translates to:
  /// **'Ask femio with Cloud boost'**
  String get aiUseAskInCloud;

  /// No description provided for @aiUseTips.
  ///
  /// In en, this message translates to:
  /// **'Tips for you'**
  String get aiUseTips;

  /// No description provided for @aiWherePhone.
  ///
  /// In en, this message translates to:
  /// **'Runs on this phone only'**
  String get aiWherePhone;

  /// No description provided for @aiWhereHybrid.
  ///
  /// In en, this message translates to:
  /// **'On this phone, or in Google\'s cloud only if you agreed to Cloud boost'**
  String get aiWhereHybrid;

  /// No description provided for @aiWriteNone.
  ///
  /// In en, this message translates to:
  /// **'Never changes your record'**
  String get aiWriteNone;

  /// No description provided for @aiWriteDraft.
  ///
  /// In en, this message translates to:
  /// **'Suggests a draft; nothing is saved until you check it and tap Save'**
  String get aiWriteDraft;

  /// No description provided for @aiSeesLabel.
  ///
  /// In en, this message translates to:
  /// **'What it receives'**
  String get aiSeesLabel;

  /// No description provided for @aiSeesHerQuestion.
  ///
  /// In en, this message translates to:
  /// **'The question you typed'**
  String get aiSeesHerQuestion;

  /// No description provided for @aiSeesPassages.
  ///
  /// In en, this message translates to:
  /// **'Passages from femio\'s trusted sources (public text, not yours)'**
  String get aiSeesPassages;

  /// No description provided for @aiSeesNote.
  ///
  /// In en, this message translates to:
  /// **'The note you typed'**
  String get aiSeesNote;

  /// No description provided for @aiSeesBands.
  ///
  /// In en, this message translates to:
  /// **'Four broad facts: life stage, cycle regularity, kinds of symptom, logging streak'**
  String get aiSeesBands;

  /// No description provided for @aiSeesIds.
  ///
  /// In en, this message translates to:
  /// **'femio\'s own reviewed tips or questions, to put in order'**
  String get aiSeesIds;

  /// No description provided for @aiSeesVisitFacts.
  ///
  /// In en, this message translates to:
  /// **'Your visit summary: goal, cycles counted, shortest and longest cycle, last period date, regularity'**
  String get aiSeesVisitFacts;

  /// No description provided for @aiSeesApprovedQuestion.
  ///
  /// In en, this message translates to:
  /// **'Your question; in the cloud, only the version you approved, with numbers, dates and names removed'**
  String get aiSeesApprovedQuestion;

  /// R8.3 first-use sheet before the assistant's doors (ADR-079/080).
  ///
  /// In en, this message translates to:
  /// **'Meet femio\'s assistant'**
  String get assistIntroTitle;

  /// No description provided for @assistIntroPhone.
  ///
  /// In en, this message translates to:
  /// **'It works on this phone. It answers from femio\'s trusted sources, turns a sentence into log entries, and suggests questions for your visits. Your records stay here.'**
  String get assistIntroPhone;

  /// No description provided for @assistIntroRules.
  ///
  /// In en, this message translates to:
  /// **'It never diagnoses. femio\'s safety rules always answer first, and nothing is saved until you confirm it.'**
  String get assistIntroRules;

  /// No description provided for @assistIntroCloudTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud boost, only if you choose it'**
  String get assistIntroCloudTitle;

  /// No description provided for @assistIntroCloudBody.
  ///
  /// In en, this message translates to:
  /// **'If this phone cannot run the AI itself, you can let a general question you approve, or four broad facts, go to Google\'s cloud AI. It stays off unless you turn it on.'**
  String get assistIntroCloudBody;

  /// No description provided for @assistIntroCloudAction.
  ///
  /// In en, this message translates to:
  /// **'Choose Cloud boost'**
  String get assistIntroCloudAction;

  /// No description provided for @assistIntroContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue on this phone'**
  String get assistIntroContinue;

  /// No description provided for @assistIntroSettings.
  ///
  /// In en, this message translates to:
  /// **'You can change this, or turn the assistant off, in Settings › Assistant.'**
  String get assistIntroSettings;

  /// No description provided for @assistDoorAsk.
  ///
  /// In en, this message translates to:
  /// **'Ask a question'**
  String get assistDoorAsk;

  /// No description provided for @assistDoorAskSub.
  ///
  /// In en, this message translates to:
  /// **'Answers from trusted sources, with links'**
  String get assistDoorAskSub;

  /// No description provided for @assistDoorSayIt.
  ///
  /// In en, this message translates to:
  /// **'Say how today went'**
  String get assistDoorSayIt;

  /// No description provided for @assistDoorSayItSub.
  ///
  /// In en, this message translates to:
  /// **'One sentence becomes today\'s log; you check it first'**
  String get assistDoorSayItSub;

  /// No description provided for @assistDoorVisitSub.
  ///
  /// In en, this message translates to:
  /// **'A summary of your log and questions to take along'**
  String get assistDoorVisitSub;

  /// R8.6 Today card title; week is completed weeks (the guide's number).
  ///
  /// In en, this message translates to:
  /// **'This week: week {week}'**
  String thisWeekTitle(int week);

  /// No description provided for @weekGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Week {week}'**
  String weekGuideTitle(int week);

  /// No description provided for @weekSecBaby.
  ///
  /// In en, this message translates to:
  /// **'Baby'**
  String get weekSecBaby;

  /// No description provided for @weekSecBody.
  ///
  /// In en, this message translates to:
  /// **'Your body'**
  String get weekSecBody;

  /// No description provided for @weekSecNotice.
  ///
  /// In en, this message translates to:
  /// **'What you may notice'**
  String get weekSecNotice;

  /// No description provided for @weekSecCare.
  ///
  /// In en, this message translates to:
  /// **'Care around now'**
  String get weekSecCare;

  /// No description provided for @weekSecTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get weekSecTip;

  /// No description provided for @weekReadFull.
  ///
  /// In en, this message translates to:
  /// **'Read the week {week} guide'**
  String weekReadFull(int week);

  /// No description provided for @pregWeeksTitle.
  ///
  /// In en, this message translates to:
  /// **'Your pregnancy by week'**
  String get pregWeeksTitle;

  /// No description provided for @pregWeeksHint.
  ///
  /// In en, this message translates to:
  /// **'Counted from your due date. Tap a week to read its guide.'**
  String get pregWeeksHint;

  /// No description provided for @pregWeekCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Week {week}, your week now'**
  String pregWeekCurrentLabel(int week);

  /// No description provided for @sectionBleedingPregnant.
  ///
  /// In en, this message translates to:
  /// **'Bleeding or spotting'**
  String get sectionBleedingPregnant;

  /// R8.7, MR-29: NHS 'Vaginal bleeding in pregnancy' (read 2026-10-30). Arabic wording is the owner's to confirm (D-10).
  ///
  /// In en, this message translates to:
  /// **'Bleeding in pregnancy is common, but it can be a sign of something serious. Tell your midwife or doctor about any bleeding.'**
  String get bleedingPregnantNote;

  /// No description provided for @logAllItems.
  ///
  /// In en, this message translates to:
  /// **'All log items'**
  String get logAllItems;

  /// No description provided for @logAllItemsSub.
  ///
  /// In en, this message translates to:
  /// **'Ovulation test and temperature, hidden in pregnancy'**
  String get logAllItemsSub;

  /// R8.4: Say it example for trying to conceive. Every phrase must be one the Say it rules can log (stage_hints_test).
  ///
  /// In en, this message translates to:
  /// **'For example: positive ovulation test, mild cramps and bloating'**
  String get sayItHintTtc;

  /// No description provided for @sayItHintPregnant.
  ///
  /// In en, this message translates to:
  /// **'For example: morning sickness, backache and so tired'**
  String get sayItHintPregnant;

  /// No description provided for @sayItHintPostpartum.
  ///
  /// In en, this message translates to:
  /// **'For example: poor sleep, back pain and feeling low'**
  String get sayItHintPostpartum;

  /// No description provided for @sayItHintMenopause.
  ///
  /// In en, this message translates to:
  /// **'For example: hot flushes, night sweats and poor sleep'**
  String get sayItHintMenopause;

  /// R8.4: Ask femio example for trying to conceive. Must find a passage in the registry and trip no safety rule (stage_hints_test).
  ///
  /// In en, this message translates to:
  /// **'For example: when is my fertile window?'**
  String get askHintTtc;

  /// No description provided for @askHintPregnant.
  ///
  /// In en, this message translates to:
  /// **'For example: what helps with heartburn in pregnancy?'**
  String get askHintPregnant;

  /// No description provided for @askHintPostpartum.
  ///
  /// In en, this message translates to:
  /// **'For example: what helps with sore nipples when breastfeeding?'**
  String get askHintPostpartum;

  /// No description provided for @askHintMenopause.
  ///
  /// In en, this message translates to:
  /// **'For example: what helps with hot flushes?'**
  String get askHintMenopause;

  /// R8.4: Calendar hint in pregnancy and menopause, where the calendar shows no estimates.
  ///
  /// In en, this message translates to:
  /// **'Tap a day to log it. Days you logged are filled in.'**
  String get calendarHintNoEstimates;

  /// R9.6: opens the sheet that explains the next-period range from her own log.
  ///
  /// In en, this message translates to:
  /// **'Why this range?'**
  String get whyRangeAction;

  /// No description provided for @whyRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this range'**
  String get whyRangeTitle;

  /// No description provided for @whyRangeStated.
  ///
  /// In en, this message translates to:
  /// **'femio cannot measure a cycle from your log yet, so it starts from the cycle length you gave: {length}. The range is {margin} either side.'**
  String whyRangeStated(String length, String margin);

  /// No description provided for @whyRangeCycles.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{femio measured 1 cycle from the periods you logged.} other{femio measured {count} cycles from the periods you logged.}}'**
  String whyRangeCycles(int count);

  /// No description provided for @whyRangeAverage.
  ///
  /// In en, this message translates to:
  /// **'Your recent cycles average {length}, so the middle of the range is {length} after your last period started.'**
  String whyRangeAverage(String length);

  /// No description provided for @whyRangeSpread.
  ///
  /// In en, this message translates to:
  /// **'Your shortest and longest cycles are {spread} apart, so the range is {margin} either side of the middle.'**
  String whyRangeSpread(String spread, String margin);

  /// No description provided for @whyRangeSpreadNone.
  ///
  /// In en, this message translates to:
  /// **'Your cycles have all been the same length, so the range is the narrowest femio shows: {margin} either side.'**
  String whyRangeSpreadNone(String margin);

  /// No description provided for @whyRangeIrregular.
  ///
  /// In en, this message translates to:
  /// **'Your cycles differ by more than {limit}, so femio shows only the next period, as a wider range, and never counts days late.'**
  String whyRangeIrregular(String limit);

  /// No description provided for @whyRangeNextMedium.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One more logged cycle that stays as steady would raise this to medium confidence.} other{{count} more logged cycles that stay as steady would raise this to medium confidence.}}'**
  String whyRangeNextMedium(int count);

  /// No description provided for @whyRangeNextHigh.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{One more logged cycle that stays as steady would raise this to high confidence.} other{{count} more logged cycles that stay as steady would raise this to high confidence.}}'**
  String whyRangeNextHigh(int count);

  /// No description provided for @whyRangeHighNeedsSteady.
  ///
  /// In en, this message translates to:
  /// **'High confidence needs cycles that vary by {limit} or less.'**
  String whyRangeHighNeedsSteady(String limit);

  /// No description provided for @whyRangeWindowShown.
  ///
  /// In en, this message translates to:
  /// **'The fertile window is counted back from the middle of this range, so it moves when the range moves.'**
  String get whyRangeWindowShown;

  /// No description provided for @whyRangeWindowIrregular.
  ///
  /// In en, this message translates to:
  /// **'No fertile window is named because your cycles vary too much to count back from one date.'**
  String get whyRangeWindowIrregular;

  /// No description provided for @whyRangeWindowLearning.
  ///
  /// In en, this message translates to:
  /// **'No fertile window is named yet: femio needs at least two cycles from your log to count back from.'**
  String get whyRangeWindowLearning;

  /// MR-08: min and max are fertility.dart regularCycleMin/Max.
  ///
  /// In en, this message translates to:
  /// **'No fertile window is named because your cycle length is outside {min} to {max} days, where counting back from one date is not reliable.'**
  String whyRangeWindowOutside(int min, int max);

  /// R10.13: opens the day explainer (long-press a day, or tap a future day).
  ///
  /// In en, this message translates to:
  /// **'Explain this day'**
  String get dayExplainLink;

  /// No description provided for @dayFactBleed.
  ///
  /// In en, this message translates to:
  /// **'You logged bleeding on this day.'**
  String get dayFactBleed;

  /// No description provided for @dayFactSpotting.
  ///
  /// In en, this message translates to:
  /// **'You logged spotting on this day.'**
  String get dayFactSpotting;

  /// No description provided for @dayFactLogged.
  ///
  /// In en, this message translates to:
  /// **'You logged symptoms or mood on this day.'**
  String get dayFactLogged;

  /// No description provided for @dayFactNextPeriod.
  ///
  /// In en, this message translates to:
  /// **'This day is inside the range when your next period may start: {range}.'**
  String dayFactNextPeriod(String range);

  /// No description provided for @dayFactLaterPeriod.
  ///
  /// In en, this message translates to:
  /// **'This day is inside the range for a later period: {range}. The further ahead, the less certain.'**
  String dayFactLaterPeriod(String range);

  /// No description provided for @dayFactFertile.
  ///
  /// In en, this message translates to:
  /// **'This day is inside your estimated fertile window: {range}.'**
  String dayFactFertile(String range);

  /// MR-07 estimate; the second sentence mirrors noConfidentWindowBody.
  ///
  /// In en, this message translates to:
  /// **'femio estimates ovulation around this day, counted back from your next period. Ovulation tests and waking temperature can help you tell whether you ovulated.'**
  String get dayFactOvulation;

  /// No description provided for @dayFactNothingFuture.
  ///
  /// In en, this message translates to:
  /// **'Nothing is estimated for this day.'**
  String get dayFactNothingFuture;

  /// No description provided for @dayFactNothingPast.
  ///
  /// In en, this message translates to:
  /// **'Nothing is logged for this day. femio does not draw estimates on days already past.'**
  String get dayFactNothingPast;

  /// No description provided for @dayLogAction.
  ///
  /// In en, this message translates to:
  /// **'Log this day'**
  String get dayLogAction;

  /// R10.13 / U17: shown after a logged period moves the estimate. Ranges only.
  ///
  /// In en, this message translates to:
  /// **'Next period now around {after}. It was {before}.'**
  String predictionMoved(String after, String before);

  /// No description provided for @predictionNew.
  ///
  /// In en, this message translates to:
  /// **'Next period around {after}.'**
  String predictionNew(String after);

  /// No description provided for @predictionWhy.
  ///
  /// In en, this message translates to:
  /// **'Why?'**
  String get predictionWhy;
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
