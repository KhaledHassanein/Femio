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

  /// Positioning line on the welcome screen (ADR-078 section 8). Must match the website hero eyebrow word for word.
  ///
  /// In en, this message translates to:
  /// **'AI-assisted women\'s health & wellness'**
  String get welcomeTagline;

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
  /// **'Cycles change with age, so this shapes what femio expects. It also helps check that you are 18 or over. Only the year.'**
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
  /// **'Likely ovulation around {date}'**
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

  /// No description provided for @menoNoDate.
  ///
  /// In en, this message translates to:
  /// **'No last period recorded yet'**
  String get menoNoDate;

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
  /// **'Tap a day to log it. Your period days are filled in, including the days of your usual length; predicted periods are outlined and the fertile window is shaded.'**
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

  /// No description provided for @testTimingUnknown.
  ///
  /// In en, this message translates to:
  /// **'If you do not know when your period is due, test at least 21 days after you last had unprotected sex.'**
  String get testTimingUnknown;

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
  /// **'Seek care now if you have a severe headache, changes in your vision, dizziness or fainting, a fever of 38°C or higher, swelling of the face or hands, difficulty breathing, chest pain or a fast-beating heart, severe nausea and vomiting, pain in the upper abdomen or severe belly pain that doesn\'t go away, vaginal bleeding or fluid leaking, swelling, redness or pain in a leg or arm, overwhelming tiredness, thoughts of harming yourself or your baby, or if your baby\'s movements have slowed down, stopped or changed. Contact your maternity unit or local emergency services. If you cannot reach them, go to the nearest emergency department.'**
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

  /// No description provided for @redFlagDizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness or fainting'**
  String get redFlagDizziness;

  /// No description provided for @redFlagFever.
  ///
  /// In en, this message translates to:
  /// **'A fever of 38°C or higher'**
  String get redFlagFever;

  /// No description provided for @redFlagChestPain.
  ///
  /// In en, this message translates to:
  /// **'Chest pain or a fast-beating heart'**
  String get redFlagChestPain;

  /// No description provided for @redFlagNausea.
  ///
  /// In en, this message translates to:
  /// **'Severe nausea and vomiting'**
  String get redFlagNausea;

  /// No description provided for @redFlagBellyPain.
  ///
  /// In en, this message translates to:
  /// **'Severe belly pain that doesn\'t go away'**
  String get redFlagBellyPain;

  /// No description provided for @redFlagFluid.
  ///
  /// In en, this message translates to:
  /// **'Fluid leaking from your vagina'**
  String get redFlagFluid;

  /// No description provided for @redFlagLimb.
  ///
  /// In en, this message translates to:
  /// **'Swelling, redness or pain in a leg or arm'**
  String get redFlagLimb;

  /// No description provided for @redFlagTiredness.
  ///
  /// In en, this message translates to:
  /// **'Overwhelming tiredness'**
  String get redFlagTiredness;

  /// No description provided for @redFlagHarmThoughts.
  ///
  /// In en, this message translates to:
  /// **'Thoughts of harming yourself or your baby'**
  String get redFlagHarmThoughts;

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

  /// No description provided for @pinWaitSeconds.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Too many tries. Try again in {count} second.} other {Too many tries. Try again in {count} seconds.}}'**
  String pinWaitSeconds(int count);

  /// No description provided for @pinWaitMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Too many tries. Try again in {count} minute.} other {Too many tries. Try again in {count} minutes.}}'**
  String pinWaitMinutes(int count);

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

  /// No description provided for @backupWorking.
  ///
  /// In en, this message translates to:
  /// **'Working on your backup file. This can take a few seconds.'**
  String get backupWorking;

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
  /// **'Your records stay on this phone. femio has no account and no server, and cannot see what you enter. Its AI runs on this phone; the cloud is used only if you switch on Cloud boost.'**
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
  /// **'A reminder only says \"femio: Open the app\", unless you write your own words for a medicine reminder. Nothing else about your health appears on your lock screen.'**
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
  /// **'Reminders you turned on in femio. They say only \"Open the app\", unless you wrote your own words for a medicine reminder.'**
  String get reminderChannelDescription;

  /// No description provided for @reminderAppointment.
  ///
  /// In en, this message translates to:
  /// **'Appointment reminder'**
  String get reminderAppointment;

  /// No description provided for @reminderAppointmentNote.
  ///
  /// In en, this message translates to:
  /// **'One notification the day before an appointment you saved with a date.'**
  String get reminderAppointmentNote;

  /// No description provided for @notifConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications, only if you want them'**
  String get notifConsentTitle;

  /// No description provided for @notifConsentIntro.
  ///
  /// In en, this message translates to:
  /// **'femio can nudge you on this phone. Choose what you would like to receive. Nothing is switched on until you allow it.'**
  String get notifConsentIntro;

  /// No description provided for @notifConsentNeutral.
  ///
  /// In en, this message translates to:
  /// **'Every notification says only \"femio\" and \"Open the app\", unless you write your own words for a medicine reminder. No other health words appear on your lock screen.'**
  String get notifConsentNeutral;

  /// No description provided for @notifConsentLocal.
  ///
  /// In en, this message translates to:
  /// **'Notifications are scheduled on your phone itself. Nothing is sent anywhere, and femio has no account or server to send them from.'**
  String get notifConsentLocal;

  /// No description provided for @notifKindMedicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine reminder'**
  String get notifKindMedicine;

  /// No description provided for @notifKindDigest.
  ///
  /// In en, this message translates to:
  /// **'Weekly digest'**
  String get notifKindDigest;

  /// No description provided for @notifComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming in an update'**
  String get notifComingSoon;

  /// No description provided for @notifConsentAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get notifConsentAllow;

  /// No description provided for @notifConsentNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notifConsentNotNow;

  /// No description provided for @notifConsentPickOne.
  ///
  /// In en, this message translates to:
  /// **'Switch on at least one kind to continue.'**
  String get notifConsentPickOne;

  /// No description provided for @notifConsentDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off on this phone'**
  String get notifConsentDeniedTitle;

  /// No description provided for @notifConsentDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Your phone did not allow notifications, so femio has scheduled nothing. To change this, open your phone\'s Settings, then Apps, femio, Notifications, and allow them. Then come back to Reminders in femio\'s Settings.'**
  String get notifConsentDeniedBody;

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
  /// **'This runs on your phone. femio does not send your words anywhere.'**
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

  /// No description provided for @sayItDictationHint.
  ///
  /// In en, this message translates to:
  /// **'Tip: tap the microphone on your keyboard to speak instead of typing.'**
  String get sayItDictationHint;

  /// No description provided for @sayItFoundDays.
  ///
  /// In en, this message translates to:
  /// **'femio found these days. Untick anything that is wrong, or remove a whole day. Nothing is saved until you tap the button below.'**
  String get sayItFoundDays;

  /// No description provided for @sayItRemoveDay.
  ///
  /// In en, this message translates to:
  /// **'Remove this day'**
  String get sayItRemoveDay;

  /// No description provided for @sayItSaveCount.
  ///
  /// In en, this message translates to:
  /// **'Save {entries, plural, one{1 entry} other{{entries} entries}} on {days, plural, one{1 day} other{{days} days}}'**
  String sayItSaveCount(int entries, int days);

  /// No description provided for @sayItFuture.
  ///
  /// In en, this message translates to:
  /// **'femio can\'t log a day that hasn\'t happened yet, so that part of your note was left out.'**
  String get sayItFuture;

  /// No description provided for @sayItTooOld.
  ///
  /// In en, this message translates to:
  /// **'femio logs up to {days, plural, one{1 day} other{{days} days}} back, so older days in your note were left out.'**
  String sayItTooOld(int days);

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
  /// **'In the year after birth, CDC\'s Hear Her campaign says to get medical care immediately for an urgent warning sign, such as heavy bleeding, a fever, a headache that won\'t go away, a swollen leg or thoughts of harming yourself or your baby. Call your doctor or midwife now, or your local emergency number.'**
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
  /// **'Only this question, the public sources and the language to answer in are sent. Nothing from your log is.'**
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
  /// **'No on-phone or Cloud boost summary was available this time, so here are the trusted passages word for word.'**
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
  /// **'A page to show your clinician, made from what you logged. It stays on your phone unless you share or copy it.'**
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
  /// **'Ready. It reads your notes on the phone, and your words are not sent.'**
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
  /// **'Nothing else from your record: not your log, notes, dates, cycle lengths, medicines, lab results, visits, documents, photos or birth year. Never your contacts or advertising ID.'**
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
  /// **'I agree that femio may send a general question I approve, one at a time, with the public sources it found and the language to answer in, so Google\'s cloud AI can summarise them. femio removes numbers, e-mail addresses and links first, and I see and can edit the exact text before anything is sent.'**
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

  /// No description provided for @toolBandUnder.
  ///
  /// In en, this message translates to:
  /// **'under {limit}'**
  String toolBandUnder(String limit);

  /// No description provided for @toolBandBetween.
  ///
  /// In en, this message translates to:
  /// **'{low} to under {high}'**
  String toolBandBetween(String low, String high);

  /// No description provided for @toolBandFrom.
  ///
  /// In en, this message translates to:
  /// **'{limit} or more'**
  String toolBandFrom(String limit);

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
  /// **'Your records stay on this phone: your cycle and pregnancy log, notes, health record (visits, lab results, medicines and more), documents and photos, and your birth year. femio asks your birth year to check you are 18 or over and to fit what it expects to your age. Below is every way anything can leave this phone.'**
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
  /// **'If you tap Download, Android\'s AI service (AICore, run by Google) downloads Gemini Nano and keeps it up to date. Whenever the on-phone AI runs, Google\'s AI software may send Google technical usage information, such as an identifier for this installation, device and app details, errors, speed and the size of a request. It does not include your words, and femio adds none of your records to it.'**
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
  /// **'A backup, with the documents and photos you added, goes only where you choose to save it, sealed with your passphrase.'**
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
  /// **'Nothing else leaves. femio has no ads, no account, and no analytics or tracking tools of its own. On the phone itself, words you write for a medicine reminder show on your lock screen, and widget details you turn on show on your home screen; femio keeps that short text unencrypted so Android can show it.'**
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
  /// **'Your question; in the cloud, only the version you approved, with numbers, e-mail addresses and links removed'**
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
  /// **'It never tells you what condition you have. femio\'s safety rules always answer first, and nothing is saved until you confirm it.'**
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

  /// R10.2: she writes what she wants to raise; the rules suggest reviewed questions.
  ///
  /// In en, this message translates to:
  /// **'What do you want to raise at this visit?'**
  String get visitWorryTitle;

  /// No description provided for @visitWorryHint.
  ///
  /// In en, this message translates to:
  /// **'In your own words, for example: my period pain is getting worse'**
  String get visitWorryHint;

  /// No description provided for @visitWorryFind.
  ///
  /// In en, this message translates to:
  /// **'Find questions'**
  String get visitWorryFind;

  /// No description provided for @visitWorrySuggested.
  ///
  /// In en, this message translates to:
  /// **'Questions that fit what you wrote'**
  String get visitWorrySuggested;

  /// No description provided for @visitWorryNone.
  ///
  /// In en, this message translates to:
  /// **'No question in femio\'s list fits this yet. Your own words will be added as you wrote them.'**
  String get visitWorryNone;

  /// No description provided for @visitWorryOwnWords.
  ///
  /// In en, this message translates to:
  /// **'Add your own words as well'**
  String get visitWorryOwnWords;

  /// No description provided for @visitWorryAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to your visit'**
  String get visitWorryAdd;

  /// No description provided for @visitWorryAddedTo.
  ///
  /// In en, this message translates to:
  /// **'Added to your questions for {date}.'**
  String visitWorryAddedTo(String date);

  /// No description provided for @visitWorryAddedNext.
  ///
  /// In en, this message translates to:
  /// **'Added to your questions for your next visit.'**
  String get visitWorryAddedNext;

  /// No description provided for @visitYourQuestions.
  ///
  /// In en, this message translates to:
  /// **'Your questions'**
  String get visitYourQuestions;

  /// First person: the pack is the page she hands over.
  ///
  /// In en, this message translates to:
  /// **'In my words: {text}'**
  String visitInMyWords(String text);

  /// No description provided for @visitRemoveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Remove this question'**
  String get visitRemoveQuestion;

  /// No description provided for @visitSecondLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add the page in a second language for the clinic'**
  String get visitSecondLanguage;

  /// No description provided for @visitNoSecondLanguage.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get visitNoSecondLanguage;

  /// No description provided for @visitShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get visitShare;

  /// No description provided for @visitMadeOn.
  ///
  /// In en, this message translates to:
  /// **'Made on {date} from what I logged in femio. It is my own record, for us to discuss.'**
  String visitMadeOn(String date);

  /// R8.27: on the not-covered card, opens the visit summary with her question as the worry.
  ///
  /// In en, this message translates to:
  /// **'Prepare a visit pack'**
  String get askVisitPack;

  /// R10.3 / U12: opens the reasons a tip was chosen, read from her own record.
  ///
  /// In en, this message translates to:
  /// **'Why am I seeing this?'**
  String get tipWhyAction;

  /// No description provided for @tipWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this tip'**
  String get tipWhyTitle;

  /// No description provided for @tipWhyStage.
  ///
  /// In en, this message translates to:
  /// **'{stage, select, period{You are tracking your periods.} ttc{You are trying to conceive.} pregnant{You are pregnant.} postpartum{You have recorded your baby\'s birth.} menopause{You are tracking perimenopause or menopause.} other{You chose this stage.}}'**
  String tipWhyStage(String stage);

  /// term is the log label; days and window are daysValue phrases.
  ///
  /// In en, this message translates to:
  /// **'You logged \"{term}\" on {days} in the last {window}.'**
  String tipWhyTerm(String term, String days, String window);

  /// No description provided for @tipWhyPregnancyWeek.
  ///
  /// In en, this message translates to:
  /// **'You are {week} weeks pregnant, counted from your due date.'**
  String tipWhyPregnancyWeek(int week);

  /// No description provided for @tipWhyPostpartumWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Your baby was born less than a week ago.} =1{Your baby was born 1 week ago.} other{Your baby was born {count} weeks ago.}}'**
  String tipWhyPostpartumWeeks(int count);

  /// No description provided for @tipWhyTryingFor.
  ///
  /// In en, this message translates to:
  /// **'How long you have been trying: {label}.'**
  String tipWhyTryingFor(String label);

  /// No description provided for @tipWhyIrregular.
  ///
  /// In en, this message translates to:
  /// **'Your cycles are marked as irregular.'**
  String get tipWhyIrregular;

  /// No description provided for @tipWhyRegular.
  ///
  /// In en, this message translates to:
  /// **'Your cycles are not marked as irregular.'**
  String get tipWhyRegular;

  /// No description provided for @tipWhyAge.
  ///
  /// In en, this message translates to:
  /// **'You are {age} or older this year.'**
  String tipWhyAge(int age);

  /// No description provided for @tipWhyFootnote.
  ///
  /// In en, this message translates to:
  /// **'These facts were read on your phone, from your own record. They are the only reasons this tip was chosen.'**
  String get tipWhyFootnote;

  /// R10.3 / U34: the on-phone list of every model call.
  ///
  /// In en, this message translates to:
  /// **'What the AI did'**
  String get aiLedgerTitle;

  /// No description provided for @aiLedgerSub.
  ///
  /// In en, this message translates to:
  /// **'Each time femio used a model, kept on this phone'**
  String get aiLedgerSub;

  /// No description provided for @aiLedgerIntro.
  ///
  /// In en, this message translates to:
  /// **'Each time femio used a model, it is listed here, newest first. For Cloud boost, the exact text that was sent is kept as your receipt. This list stays on this phone: it is not in your backup, and \"Delete everything\" removes it.'**
  String get aiLedgerIntro;

  /// No description provided for @aiLedgerEmpty.
  ///
  /// In en, this message translates to:
  /// **'femio has not used a model yet.'**
  String get aiLedgerEmpty;

  /// No description provided for @aiLedgerOnPhone.
  ///
  /// In en, this message translates to:
  /// **'On this phone (Gemini Nano)'**
  String get aiLedgerOnPhone;

  /// No description provided for @aiLedgerInCloud.
  ///
  /// In en, this message translates to:
  /// **'Sent with Cloud boost'**
  String get aiLedgerInCloud;

  /// No description provided for @aiLedgerNoReply.
  ///
  /// In en, this message translates to:
  /// **'No answer came back in time, so femio used its rules.'**
  String get aiLedgerNoReply;

  /// No description provided for @aiLedgerSent.
  ///
  /// In en, this message translates to:
  /// **'Exactly what was sent'**
  String get aiLedgerSent;

  /// No description provided for @aiLedgerClear.
  ///
  /// In en, this message translates to:
  /// **'Clear this list'**
  String get aiLedgerClear;

  /// No description provided for @aiLedgerClearConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear this list? Your record is not changed.'**
  String get aiLedgerClearConfirm;

  /// No description provided for @signsTitle.
  ///
  /// In en, this message translates to:
  /// **'Signs you logged this cycle'**
  String get signsTitle;

  /// No description provided for @signsValueOn.
  ///
  /// In en, this message translates to:
  /// **'{value}, {date}'**
  String signsValueOn(String value, String date);

  /// No description provided for @signsTempCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reading this cycle} other{{count} readings this cycle}}'**
  String signsTempCount(int count);

  /// No description provided for @signsStripLine.
  ///
  /// In en, this message translates to:
  /// **'An ovulation test strip shows a hormone surge, not proof that you ovulated. A rise in your waking temperature afterwards is a better sign.'**
  String get signsStripLine;

  /// No description provided for @signsNote.
  ///
  /// In en, this message translates to:
  /// **'Each sign is shown as you logged it. femio does not say whether or when you ovulated; that is a conversation for you and your clinician.'**
  String get signsNote;

  /// A Say it chip for a period flow or a test result, so "Light" or "High" says what it is.
  ///
  /// In en, this message translates to:
  /// **'{section}: {value}'**
  String sayItChipWithSection(String section, String value);

  /// Short label under the + button in the middle of the bottom navigation bar.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get navAdd;

  /// Title of the sheet the + button opens: log anything or ask femio.
  ///
  /// In en, this message translates to:
  /// **'Add to today'**
  String get addSheetTitle;

  /// Tappable prompt that opens Say it (free-text logging) from the + sheet.
  ///
  /// In en, this message translates to:
  /// **'Tell femio anything, like “cramps since this morning”'**
  String get addSayItPrompt;

  /// Row in the + sheet that opens the full Log for today.
  ///
  /// In en, this message translates to:
  /// **'Symptoms, discharge, tests and more'**
  String get addMoreToLog;

  /// Short button in the + sheet that opens Ask femio (questions answered from trusted sources).
  ///
  /// In en, this message translates to:
  /// **'Ask femio'**
  String get addAsk;

  /// Short button in the + sheet that opens the questions-for-a-visit summary.
  ///
  /// In en, this message translates to:
  /// **'For my visit'**
  String get addVisit;

  /// Title of the screen that holds her own health file (visits, results, medicines, documents).
  ///
  /// In en, this message translates to:
  /// **'My health record'**
  String get recTitle;

  /// One-line explanation at the top of My health record.
  ///
  /// In en, this message translates to:
  /// **'Your own health file, kept on this phone. Each entry shows the day it happened and the day you added it, exactly as you wrote it.'**
  String get recIntro;

  /// Filter chip showing every kind of record entry.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get recAll;

  /// Kind of record entry: a clinic or doctor visit.
  ///
  /// In en, this message translates to:
  /// **'Visit'**
  String get recKindVisit;

  /// Kind of record entry: a laboratory test result.
  ///
  /// In en, this message translates to:
  /// **'Lab result'**
  String get recKindLab;

  /// Kind of record entry: ultrasound, X-ray, MRI and similar.
  ///
  /// In en, this message translates to:
  /// **'Scan or imaging'**
  String get recKindImaging;

  /// Kind of record entry: a medicine or prescription.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get recKindMedicine;

  /// Kind of record entry: a health condition or past history she wants to keep.
  ///
  /// In en, this message translates to:
  /// **'Condition or history'**
  String get recKindCondition;

  /// Kind of record entry: an allergy.
  ///
  /// In en, this message translates to:
  /// **'Allergy'**
  String get recKindAllergy;

  /// Kind of record entry: a surgery or procedure.
  ///
  /// In en, this message translates to:
  /// **'Procedure'**
  String get recKindProcedure;

  /// Kind of record entry: a past or current pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get recKindPregnancy;

  /// Kind of record entry: a report or other document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get recKindDocument;

  /// Kind of record entry: a free note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get recKindNote;

  /// Heading when the health record is empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get recEmptyHeading;

  /// Body when the health record is empty.
  ///
  /// In en, this message translates to:
  /// **'Add a visit, a lab result, a medicine or anything you want to keep. Entries stay on this phone and go into the backup file you save.'**
  String get recEmptyBody;

  /// Button and screen title for adding a record entry.
  ///
  /// In en, this message translates to:
  /// **'Add an entry'**
  String get recAdd;

  /// Screen title when editing a record entry.
  ///
  /// In en, this message translates to:
  /// **'Edit entry'**
  String get recEdit;

  /// Button that saves a record entry.
  ///
  /// In en, this message translates to:
  /// **'Save to my record'**
  String get recSave;

  /// Cancel button in the record editor and delete dialog.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get recCancel;

  /// Button that deletes a record entry.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get recDelete;

  /// Title of the confirm dialog before deleting a record entry.
  ///
  /// In en, this message translates to:
  /// **'Delete this entry?'**
  String get recDeleteTitle;

  /// Body of the delete confirm dialog.
  ///
  /// In en, this message translates to:
  /// **'It is removed from this phone. A backup file you saved earlier still has it.'**
  String get recDeleteBody;

  /// Label above the kind chips in the record editor.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get recFormKind;

  /// Label of the title field in the record editor.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get recFormTitle;

  /// Hint for the title field.
  ///
  /// In en, this message translates to:
  /// **'In your words, like “TSH” or “12-week scan”'**
  String get recFormTitleHint;

  /// Label of the date the entry happened (picked on a calendar).
  ///
  /// In en, this message translates to:
  /// **'Day it happened'**
  String get recFormHappened;

  /// Hint under the happened-on date.
  ///
  /// In en, this message translates to:
  /// **'The date printed on the report, or the day of the visit.'**
  String get recFormHappenedHint;

  /// Error when the record entry has no title.
  ///
  /// In en, this message translates to:
  /// **'Add a title'**
  String get recNeedTitle;

  /// Error when the record entry has no happened-on date.
  ///
  /// In en, this message translates to:
  /// **'Pick the day it happened'**
  String get recNeedDate;

  /// Record field: a lab value as written on the report.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get recFieldValue;

  /// Record field: the unit as written on the report.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get recFieldUnit;

  /// Record field: the reference range exactly as printed on her own report.
  ///
  /// In en, this message translates to:
  /// **'Range printed on the report'**
  String get recFieldPrintedRange;

  /// Record field: medicine dose as written on the prescription.
  ///
  /// In en, this message translates to:
  /// **'Dose as written'**
  String get recFieldDose;

  /// Record field: how often the medicine is taken, as written.
  ///
  /// In en, this message translates to:
  /// **'How often'**
  String get recFieldFrequency;

  /// Record field: the day a medicine was started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get recFieldStartedOn;

  /// Record field: the day a medicine was stopped.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get recFieldEndedOn;

  /// Record field: who prescribed the medicine.
  ///
  /// In en, this message translates to:
  /// **'Prescribed by'**
  String get recFieldPrescriber;

  /// Record field: clinic, hospital or doctor.
  ///
  /// In en, this message translates to:
  /// **'Where'**
  String get recFieldPlace;

  /// Record field: free details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get recFieldDetails;

  /// Line on a record row: the day the entry was added to femio.
  ///
  /// In en, this message translates to:
  /// **'Added {date}'**
  String recRowAdded(String date);

  /// Mark on a record row that was changed after it was added.
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get recEdited;

  /// Record entry source: typed by her.
  ///
  /// In en, this message translates to:
  /// **'Typed'**
  String get recSourceTyped;

  /// Record entry source: scanned from a document.
  ///
  /// In en, this message translates to:
  /// **'Scanned'**
  String get recSourceScanned;

  /// Record entry source: confirmed from an Ask femio draft.
  ///
  /// In en, this message translates to:
  /// **'From Ask femio'**
  String get recSourceAsk;

  /// Record entry source: confirmed from a Say it draft.
  ///
  /// In en, this message translates to:
  /// **'From Say it'**
  String get recSourceSayIt;

  /// Record entry source: imported from a file.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get recSourceImported;

  /// Note under the record list and editor (no interpretation, product rule 1).
  ///
  /// In en, this message translates to:
  /// **'femio keeps and shows your entries as written. It never says whether a result is normal: that is for you and your clinician.'**
  String get recNoVerdictNote;

  /// Row in the + sheet that opens My health record.
  ///
  /// In en, this message translates to:
  /// **'My health record'**
  String get addRecord;

  /// Subtitle of the My health record row in the + sheet.
  ///
  /// In en, this message translates to:
  /// **'Visits, results, medicines and documents'**
  String get addRecordSub;

  /// Heading of the free-text note section on the Log screen.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get logNoteSection;

  /// Placeholder inside the empty note field on the Log screen.
  ///
  /// In en, this message translates to:
  /// **'Anything you want to remember about this day'**
  String get logNoteHint;

  /// Reassurance under the note field: the note is stored on the phone only.
  ///
  /// In en, this message translates to:
  /// **'Saved on this phone with the rest of your record.'**
  String get logNoteSaved;

  /// First column header of the spreadsheet export: the day of the log.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get csvColumnDate;

  /// Spreadsheet column header for log terms that are not mood, symptom or discharge (for example intercourse).
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get csvColumnOther;

  /// Settings row that saves her logs as a spreadsheet (CSV) file.
  ///
  /// In en, this message translates to:
  /// **'Export as spreadsheet (CSV)'**
  String get exportCsv;

  /// One-sentence warning under the CSV export row: unlike the sealed backup the spreadsheet has no passphrase.
  ///
  /// In en, this message translates to:
  /// **'Unlike the backup, this file is not encrypted, so keep it somewhere private.'**
  String get csvNotEncrypted;

  /// Snackbar after the spreadsheet file was saved.
  ///
  /// In en, this message translates to:
  /// **'Spreadsheet saved.'**
  String get csvSaved;

  /// Snackbar when she taps the CSV export but has logged no day yet.
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet, so there is nothing to export.'**
  String get csvNothingToExport;

  /// The neutral line on the home-screen widget, shown until she turns details on. No health word. The wordmark femio stays Latin.
  ///
  /// In en, this message translates to:
  /// **'Open femio'**
  String get widgetNeutralLine;

  /// Home-screen widget line in pregnancy, when she turned details on. {weeks} is the completed weeks of pregnancy.
  ///
  /// In en, this message translates to:
  /// **'Week {weeks}'**
  String widgetWeek(int weeks);

  /// Home-screen widget line: the next period as a range (never one date). {range} is like "Nov 16 – Nov 20".
  ///
  /// In en, this message translates to:
  /// **'Next period {range}'**
  String widgetNextPeriod(String range);

  /// Settings switch title: the home-screen widget shows the pregnancy week or the next-period range instead of only the wordmark. Off by default.
  ///
  /// In en, this message translates to:
  /// **'Show details on the home-screen widget'**
  String get settingsWidgetDetails;

  /// One sentence under the widget switch: anyone who sees her phone will see the details. Says the widget is neutral until she turns it on.
  ///
  /// In en, this message translates to:
  /// **'Anyone who sees your phone will see them. Until you turn this on, the widget shows only femio.'**
  String get settingsWidgetDetailsNote;

  /// Heading of the documents part of a record entry's editor.
  ///
  /// In en, this message translates to:
  /// **'Documents and photos'**
  String get recDocsHeading;

  /// Button: pick a PDF or photo with the system file picker.
  ///
  /// In en, this message translates to:
  /// **'Add a file'**
  String get recDocsAddFile;

  /// Button: open the phone's camera app to photograph a report.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get recDocsTakePhoto;

  /// Button: attach a document she already added to another entry.
  ///
  /// In en, this message translates to:
  /// **'From my documents'**
  String get recDocsFromMine;

  /// Small print under the document buttons.
  ///
  /// In en, this message translates to:
  /// **'A PDF or a photo, up to 10 MB each. Kept sealed on this phone with the rest of your record.'**
  String get recDocsNote;

  /// Snackbar when a picked file is over 10 MB.
  ///
  /// In en, this message translates to:
  /// **'This file is over 10 MB. Try a smaller copy, or a photo of the page.'**
  String get recDocsTooLarge;

  /// Snackbar when the picked file is not a PDF or a photo.
  ///
  /// In en, this message translates to:
  /// **'femio can keep PDFs and photos (JPG, PNG or WebP).'**
  String get recDocsUnsupported;

  /// Default name of a camera photo; {date} is the date and time it was taken.
  ///
  /// In en, this message translates to:
  /// **'Photo {date}'**
  String recDocsPhotoName(String date);

  /// Title of the screen listing all her documents.
  ///
  /// In en, this message translates to:
  /// **'My documents'**
  String get recDocsLibrary;

  /// Empty state of My documents.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Add a PDF or a photo from any entry in your record.'**
  String get recDocsLibraryEmpty;

  /// Title when choosing one of her documents to attach.
  ///
  /// In en, this message translates to:
  /// **'Choose a document'**
  String get recDocsChoose;

  /// On a record row: how many documents are attached.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 document} other{{count} documents}}'**
  String recDocsCount(int count);

  /// Menu item and dialog title: rename a document.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get recDocRename;

  /// Label of the name field when renaming a document.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get recDocRenameLabel;

  /// Tooltip: share this document through the system share sheet.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get recDocShare;

  /// Snackbar when the system share sheet could not open.
  ///
  /// In en, this message translates to:
  /// **'The share sheet could not open.'**
  String get recDocShareFailed;

  /// Menu item: detach this document from the entry, keeping it in My documents.
  ///
  /// In en, this message translates to:
  /// **'Remove from this entry'**
  String get recDocUnlink;

  /// Menu item: delete the document from femio.
  ///
  /// In en, this message translates to:
  /// **'Delete document'**
  String get recDocDelete;

  /// Confirm dialog title before deleting a document.
  ///
  /// In en, this message translates to:
  /// **'Delete this document?'**
  String get recDocDeleteTitle;

  /// Confirm dialog body before deleting a document.
  ///
  /// In en, this message translates to:
  /// **'It is removed from femio and from every entry it is attached to. This cannot be undone, except from a backup you saved before.'**
  String get recDocDeleteBody;

  /// When a document's file cannot be opened.
  ///
  /// In en, this message translates to:
  /// **'This document could not be opened.'**
  String get recDocUnreadable;

  /// When a PDF cannot be drawn on the phone (damaged or password-protected).
  ///
  /// In en, this message translates to:
  /// **'This PDF cannot be shown here. It may be protected by a password. You can still share it to open it in another app.'**
  String get recDocPdfUnreadable;

  /// A document's size; {size} is a number such as 2.3.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String recDocSizeMb(String size);

  /// Privacy line under a document and in My documents (ADR-082 §6).
  ///
  /// In en, this message translates to:
  /// **'Documents and photos you add stay on your phone, sealed like the rest of your record, and travel only inside the backup file you save.'**
  String get recDocPrivate;

  /// Snackbar when her documents are over 100 MB together, too much for one backup.
  ///
  /// In en, this message translates to:
  /// **'Your documents come to more than 100 MB, more than one backup can carry. Delete some large ones in My documents, then save the backup again.'**
  String get backupTooLarge;

  /// What can leave this phone: heading for things she shares herself.
  ///
  /// In en, this message translates to:
  /// **'What you share or export'**
  String get leaveShareHeading;

  /// What can leave this phone: sharing a document or the visit pack.
  ///
  /// In en, this message translates to:
  /// **'When you share a document or your visit notes, they go only to the app you pick in the share sheet. If you copy your visit notes, your phone\'s clipboard holds them. A spreadsheet (CSV) you export goes where you choose to save it, which can be a cloud drive, and it is not encrypted.'**
  String get leaveShareBody;

  /// A small document's size; {size} is a whole number of kilobytes.
  ///
  /// In en, this message translates to:
  /// **'{size} KB'**
  String recDocSizeKb(String size);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'My medicines'**
  String get medTitle;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Your medicines as you wrote them, the times you take them, and what you marked. femio gives no dose advice and does not check interactions: ask your pharmacist or doctor.'**
  String get medIntro;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Add a medicine'**
  String get medAdd;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get medEmptyHeading;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Add one from a prescription or a box. You choose the times; femio can remind you.'**
  String get medEmptyBody;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Taking now'**
  String get medCurrent;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get medFinished;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get medToday;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'When needed'**
  String get medAsNeeded;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'I took one'**
  String get medLogDose;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Taken {time}'**
  String medTakenAt(String time);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Taken {time}, later than planned'**
  String medTakenLater(String time);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Not taken'**
  String get medSkippedAt;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Not marked'**
  String get medNotMarked;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Taken now'**
  String get medMarkTaken;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Taken at another time'**
  String get medMarkTakenAt;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Not taken'**
  String get medMarkSkipped;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Clear the mark'**
  String get medMarkClear;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'{name} at {time}'**
  String medDoseTitle(String name, String time);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Times you take it'**
  String get medTimes;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'No set times. You can still mark a dose when you take one.'**
  String get medTimesNone;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Add a time'**
  String get medAddTime;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Remove {time}'**
  String medRemoveTime(String time);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Remind me at these times'**
  String get medRemind;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'A notification at each time, and one the day before your refill day. It says \"Open the app\" unless you write your own words below.'**
  String get medRemindNote;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Words on the reminder (optional)'**
  String get medLabel;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'These words show on your notification. Keep them vague if others see your phone.'**
  String get medLabelNote;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Refill by'**
  String get medRefill;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get medRefillNone;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Clear the refill day'**
  String get medRefillClear;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Refill by {date}'**
  String medRefillSoon(String date);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Last 14 days'**
  String get medHistory;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Nothing marked yet.'**
  String get medHistoryEmpty;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get medEdit;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'femio is not a way to avoid pregnancy, so it keeps no times, marks or reminders for this medicine. It stays in your record as you wrote it.'**
  String get medBlocked;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Since {date}'**
  String medSince(String date);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Until {date}'**
  String medUntil(String date);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'Ended {date}'**
  String medEnded(String date);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'femio keeps what you write. It gives no dose, catch-up or interaction advice: ask your pharmacist or doctor.'**
  String get medNoAdviceNote;

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{All marked for today} =1{1 dose to mark today} other{{count} doses to mark today}}'**
  String medTodayCount(int count);

  /// Medicines (R11.6).
  ///
  /// In en, this message translates to:
  /// **'At the times you set on each medicine, and the day before a refill.'**
  String get reminderMedicineNote;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Patterns'**
  String get patTitle;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'See my patterns'**
  String get patOpen;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Counts from what you logged. femio shows how often, never what it means.'**
  String get patIntro;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Cycle length'**
  String get patCycleLength;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Cycle lengths appear after 2 full cycles. None is complete yet.} =1{Cycle lengths appear after 2 full cycles. 1 is complete so far.} other{Cycle lengths appear after 2 full cycles. {count} are complete so far.}}'**
  String patNeedCycles(int count);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{Your last {count} cycles: {shortest} to {longest} days}}'**
  String patRange(int count, int shortest, int longest);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String patDays(int count);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Your cycle lengths vary by more than 9 days, or one was shorter than 24 or longer than 38 days. That can be worth mentioning at your next visit.'**
  String get patVaries;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Usual limits: FIGO 2018.'**
  String get patVariesSource;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'What you logged most'**
  String get patNoticed;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Counts appear after 3 full cycles with something logged in them.'**
  String get patNeedLogged;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'{term} {phase}: {seen} of {cycles} cycles'**
  String patSeen(String term, String phase, int seen, int cycles);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'during your period'**
  String get patPhasePeriod;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'in the 5 days before your period'**
  String get patPhaseBefore;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'By phase'**
  String get patByPhase;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'During period'**
  String get patPhasePeriodShort;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'5 days before'**
  String get patPhaseBeforeShort;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'{seen} of {cycles}'**
  String patOf(int seen, int cycles);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Each cycle'**
  String get patEachCycle;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String patCycleFrom(String date);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Days logged: {count}'**
  String patDaysLogged(int count);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Ovulation test high or positive: {count}'**
  String patOpkDays(int count);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Temperatures: {count}'**
  String patTemps(int count);

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Last 90 days'**
  String get patRecent;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'Nothing logged yet. Patterns grow from your log.'**
  String get patEmpty;

  /// Patterns (R8.5, R10.4).
  ///
  /// In en, this message translates to:
  /// **'These are counts of what you logged. They don\'t say what causes anything or whether something is wrong. Bring them to your clinician if they help.'**
  String get patNoVerdict;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Signs by cycle day'**
  String get signsDaysTitle;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'See by cycle day'**
  String get signsDaysOpen;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'This cycle, from {date}'**
  String signsDaysCurrent(String date);

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Cycle from {date}, {days}'**
  String signsDaysPast(String date, String days);

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Earlier cycle'**
  String get signsDaysEarlier;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Later cycle'**
  String get signsDaysLater;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Bleeding'**
  String get signsDaysBleeding;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Logged'**
  String get signsDaysLogged;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Cycle day'**
  String get signsDaysCycleDay;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Cycle day {day}, {date}'**
  String signsDaysDay(int day, String date);

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Nothing logged this day.'**
  String get signsDaysNothing;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Tap a day to see what you logged.'**
  String get signsDaysHint;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Nothing logged in this cycle yet. Temperatures, ovulation tests and discharge you log show here day by day.'**
  String get signsDaysEmpty;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'Log the first day of a period and your signs line up here by cycle day.'**
  String get signsDaysNoCycle;

  /// Signs by cycle day (R8.8).
  ///
  /// In en, this message translates to:
  /// **'A fuller mark is further along the list you chose from: negative to positive for tests, dry to egg white for discharge.'**
  String get signsDaysFill;

  /// Between words in a short list she chose (Arabic uses its own comma).
  ///
  /// In en, this message translates to:
  /// **', '**
  String get listSeparator;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'This week\'s recovery guide'**
  String get ppGuideEyebrow;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'Read the guide'**
  String get ppRead;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get ppMoodTitle;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'Feeling weepy in the first two weeks is common and usually passes. Low mood, anxiety or numbness that lasts longer than two weeks is worth telling your clinician, and you can ask sooner.'**
  String get ppMoodNote;

  /// No description provided for @ppMoodCrisis.
  ///
  /// In en, this message translates to:
  /// **'If you have thoughts of harming yourself or your baby, get help now.'**
  String get ppMoodCrisis;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'About mood after birth'**
  String get ppMoodGuide;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'Has your period come back?'**
  String get ppPeriodBack;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'femio does not guess when periods return. When yours comes back, tell femio the first day and your cycle ranges start again from it.'**
  String get ppPeriodBackBody;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'My period came back'**
  String get ppPeriodBackAction;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'First day of your period'**
  String get ppPeriodBackPick;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'What should femio help with now?'**
  String get ppNextGoal;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'Bleeding after birth'**
  String get ppBleedingSection;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'This is the healing bleed after birth, not a period. femio keeps it out of your cycle ranges. Very heavy bleeding or large clots need care right away.'**
  String get ppBleedingNote;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'See all warning signs after birth'**
  String get ppWarnMore;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'I had my baby'**
  String get ppHadBaby;

  /// After birth (R8.19).
  ///
  /// In en, this message translates to:
  /// **'femio keeps your pregnancy record and moves to the after-birth view.'**
  String get ppHadBabyNote;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'If another period comes, it may start around {range}.'**
  String menoNextRange(String range);

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'Cycles often change in the years before menopause, so this range is wide. Menopause is identified after 12 months without a period.'**
  String get menoRangeNote;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'Bleeding after a year without periods'**
  String get menoBleedHeading;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'You logged bleeding after 12 months or more without a period. Bleeding after menopause should always be checked by a doctor, even if it happens once. Book an appointment soon.'**
  String get menoBleedBody;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'Bleeding after 12 months without a period should always be checked by a doctor, even once.'**
  String get menoBleedLogNote;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'About bleeding after menopause'**
  String get menoBleedMore;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'Days logged each month'**
  String get patMonthly;

  /// Perimenopause and menopause (R8.20).
  ///
  /// In en, this message translates to:
  /// **'Medicines I take now'**
  String get visitMedicines;

  /// Calendar/Today when no period start is logged (R14.7).
  ///
  /// In en, this message translates to:
  /// **'When your period starts, tap that day on the calendar to log it. femio then shows when the next ones may come.'**
  String get gapNoPeriodBody;

  /// No description provided for @gapNeedLengthBody.
  ///
  /// In en, this message translates to:
  /// **'You chose “Not sure” for your cycle length, so femio has nothing to count from yet. Add your usual length, or log your next period and femio will learn it from your dates.'**
  String get gapNeedLengthBody;

  /// No description provided for @gapNeedAnotherBody.
  ///
  /// In en, this message translates to:
  /// **'You said your cycles vary, or the gaps you logged are too long to count as cycles. When your next period starts, log it and femio will show a range from your own dates.'**
  String get gapNeedAnotherBody;

  /// No description provided for @gapPassedTitle.
  ///
  /// In en, this message translates to:
  /// **'The range femio showed has passed'**
  String get gapPassedTitle;

  /// Every predicted range has passed with no new start logged; MR-21 test line, never a count (R14.7).
  ///
  /// In en, this message translates to:
  /// **'If your period has started, log it and femio will show the next ones. If it has not come and you could be pregnant, a pregnancy test can tell you.'**
  String get gapPassedBody;

  /// No description provided for @absentTitle.
  ///
  /// In en, this message translates to:
  /// **'Your period hasn\'t come for a while'**
  String get absentTitle;

  /// No description provided for @absentBody.
  ///
  /// In en, this message translates to:
  /// **'If you could be pregnant, a pregnancy test is the first step. If you have gone 3 months without a period, consider a check with a clinician. If your cycles were already irregular, guidance gives 6 months. Seek advice sooner if symptoms worry you or you feel unwell.'**
  String get absentBody;

  /// No description provided for @absentSource.
  ///
  /// In en, this message translates to:
  /// **'Source: ASRM, Current evaluation of amenorrhea (2024).'**
  String get absentSource;

  /// No description provided for @gapAddLength.
  ///
  /// In en, this message translates to:
  /// **'Add my usual cycle length'**
  String get gapAddLength;

  /// No description provided for @gapSaveLength.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get gapSaveLength;

  /// No description provided for @upcomingPeriodsOnlyNextStated.
  ///
  /// In en, this message translates to:
  /// **'Only the next period is shown because you said your cycles are irregular.'**
  String get upcomingPeriodsOnlyNextStated;

  /// Link under the month grid to the month holding the next predicted period (R14.7).
  ///
  /// In en, this message translates to:
  /// **'Next period: {range}'**
  String calendarNextPeriodLink(String range);

  /// No description provided for @aiChipNano.
  ///
  /// In en, this message translates to:
  /// **'Gemini Nano · on this phone'**
  String get aiChipNano;

  /// No description provided for @aiChipRules.
  ///
  /// In en, this message translates to:
  /// **'On this phone · femio\'s rules'**
  String get aiChipRules;

  /// No description provided for @aiChipOff.
  ///
  /// In en, this message translates to:
  /// **'AI off · rules and guides still work'**
  String get aiChipOff;

  /// No description provided for @aiChipCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud boost on'**
  String get aiChipCloud;

  /// No description provided for @aiChipHint.
  ///
  /// In en, this message translates to:
  /// **'How femio\'s AI runs. Opens the assistant settings.'**
  String get aiChipHint;

  /// No description provided for @tipsOrderedNano.
  ///
  /// In en, this message translates to:
  /// **'Put in order by Gemini Nano on this phone, from your log. Each tip is a reviewed sentence with its source.'**
  String get tipsOrderedNano;

  /// No description provided for @sayItCheckedNano.
  ///
  /// In en, this message translates to:
  /// **'Gemini Nano on this phone read your words too and found nothing more to add.'**
  String get sayItCheckedNano;

  /// No description provided for @visitOrderedNano.
  ///
  /// In en, this message translates to:
  /// **'Put in order by Gemini Nano on this phone.'**
  String get visitOrderedNano;

  /// No description provided for @settingsStageTitle.
  ///
  /// In en, this message translates to:
  /// **'What femio helps with'**
  String get settingsStageTitle;

  /// No description provided for @settingsStageSub.
  ///
  /// In en, this message translates to:
  /// **'Change your stage, your due date or your cycle answers. Everything you logged stays.'**
  String get settingsStageSub;

  /// No description provided for @saveFailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Not saved on this phone'**
  String get saveFailedTitle;

  /// No description provided for @saveFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Your last change could not be saved. Your earlier records are safe. Free some space on the phone, then try again.'**
  String get saveFailedBody;

  /// No description provided for @saveFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get saveFailedRetry;
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
