// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'femio';

  @override
  String get welcomeTitle => 'Votre cycle, vos projets, votre grossesse.';

  @override
  String get welcomeBody =>
      'Vos données restent sur ce téléphone. Sans compte, et Femio ne les voit jamais.';

  @override
  String get language => 'Langue';

  @override
  String get getStarted => 'Commencer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get back => 'Retour';

  @override
  String get notSure => 'Je ne sais pas';

  @override
  String get goalTitle => 'Qu\'est-ce qui vous amène sur femio ?';

  @override
  String get goalSub => 'Vous pouvez changer à tout moment.';

  @override
  String get goalPeriod => 'Suivre mes règles';

  @override
  String get goalPeriodDesc =>
      'Savoir quand elles arrivent, et ce qui est habituel pour vous.';

  @override
  String get goalTtc => 'Tomber enceinte';

  @override
  String get goalTtcDesc =>
      'Votre fenêtre de fertilité et l\'ovulation probable.';

  @override
  String get goalPregnant => 'Je suis enceinte';

  @override
  String get goalPregnantDesc => 'Semaine après semaine, et votre date prévue.';

  @override
  String get goalMenopause => 'Périménopause et ménopause';

  @override
  String get goalMenopauseDesc => 'Cycles qui changent et symptômes.';

  @override
  String get birthYearTitle => 'En quelle année êtes-vous née ?';

  @override
  String get birthYearSub =>
      'Les cycles changent avec l\'âge : cela aide Femio à savoir à quoi s\'attendre. L\'année seulement.';

  @override
  String get under18Title =>
      'Le suivi est réservé aux adultes, pour l\'instant';

  @override
  String get under18Body =>
      'Dans cette première version, le suivi Femio est destiné aux femmes de 18 ans et plus. Tous les guides de femioapp.com vous sont ouverts, sans compte.';

  @override
  String get lastPeriodTitle =>
      'Quand vos dernières règles ont-elles commencé ?';

  @override
  String get lastPeriodSub => 'Le premier jour des saignements.';

  @override
  String get dontRemember => 'Je ne me souviens pas';

  @override
  String get periodLengthTitle =>
      'Combien de jours durent vos règles en général ?';

  @override
  String get cycleLengthTitle =>
      'Quelle est la durée habituelle de votre cycle ?';

  @override
  String get cycleLengthSub =>
      'Du premier jour des règles au premier jour des suivantes.';

  @override
  String get irregular => 'Mes cycles sont irréguliers';

  @override
  String daysValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get tryingTitle => 'Depuis combien de temps essayez-vous ?';

  @override
  String get tryingJustStarted => 'Je commence';

  @override
  String get tryingUnder6 => 'Moins de 6 mois';

  @override
  String get trying6to12 => '6 à 12 mois';

  @override
  String get tryingOver12 => 'Plus d\'un an';

  @override
  String get dueMethodTitle => 'Comment calculer votre date prévue ?';

  @override
  String get dueMethodKnown => 'Je connais ma date prévue';

  @override
  String get dueMethodLmp => 'Premier jour de mes dernières règles';

  @override
  String get dueMethodConception => 'Date de conception';

  @override
  String get dueMethodIvf3 => 'Transfert FIV (embryon de 3 jours)';

  @override
  String get dueMethodIvf5 => 'Transfert FIV (embryon de 5 jours)';

  @override
  String get dueMethodBorn => 'J\'ai accouché';

  @override
  String get dueDateTitle => 'Quelle est votre date prévue ?';

  @override
  String get conceptionTitle => 'Quand avez-vous conçu ?';

  @override
  String get transferTitle => 'Quand a eu lieu le transfert d\'embryon ?';

  @override
  String get birthDateTitle => 'Quand votre bébé est-il né ?';

  @override
  String get implausibleDue =>
      'Cette date ne correspond pas à une grossesse en cours. Vérifiez-la.';

  @override
  String get menoLastTitle => 'Quand avez-vous eu vos dernières règles ?';

  @override
  String get menoOverYear => 'Il y a plus d\'un an';

  @override
  String get predictionPeriodTitle => 'Vos prochaines règles';

  @override
  String get predictionFertileTitle => 'Votre fenêtre de fertilité';

  @override
  String predictionOvulation(String date) {
    return 'Ovulation probable : $date';
  }

  @override
  String predictionNextPeriod(String range) {
    return 'Prochaines règles vers $range';
  }

  @override
  String rangeValue(String start, String end) {
    return '$start – $end';
  }

  @override
  String get confidenceLow =>
      'Confiance faible : elle s\'affine à mesure que vous notez vos règles';

  @override
  String get confidenceMedium => 'Confiance moyenne';

  @override
  String get confidenceHigh => 'Confiance élevée';

  @override
  String get basisStated => 'D\'après la durée de cycle que vous avez indiquée';

  @override
  String get irregularNote =>
      'Vos cycles varient : Femio affiche une fourchette plus large et ne compte jamais de jours de retard.';

  @override
  String get noPredictionTitle => 'Notez vos prochaines règles';

  @override
  String get noPredictionBody =>
      'Quand vos règles commencent, notez-les et Femio prévoira les suivantes.';

  @override
  String pregnancyWeek(int weeks, int days) {
    return 'Semaine $weeks, jour $days';
  }

  @override
  String trimesterLabel(int n) {
    return 'Trimestre $n';
  }

  @override
  String dueDateLabel(String date) {
    return 'Date prévue vers le $date';
  }

  @override
  String postpartumWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semaines depuis la naissance',
      one: '1 semaine depuis la naissance',
      zero: 'Votre bébé a moins d\'une semaine',
    );
    return '$_temp0';
  }

  @override
  String menoMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months mois depuis vos dernières règles',
      one: '1 mois depuis vos dernières règles',
      zero: 'Vos dernières règles datent de moins d\'un mois',
    );
    return '$_temp0';
  }

  @override
  String get menoUnknown =>
      'Notez les saignements ou symptômes : Femio garde le suivi pour votre soignant.';

  @override
  String get awarenessNote =>
      'Des estimations pour s\'informer et planifier, pas un moyen d\'éviter une grossesse.';

  @override
  String get seeClinicianTtc =>
      'Essayer depuis plus d\'un an (ou six mois à partir de 35 ans) : c\'est le bon moment pour consulter.';

  @override
  String get privacyLine => 'Enregistré sur ce téléphone uniquement.';

  @override
  String get logPeriodToday => 'Mes règles ont commencé aujourd\'hui';

  @override
  String get loggedToday => 'C\'est noté. Votre prévision est à jour.';

  @override
  String get startOver => 'Recommencer';

  @override
  String get todayTitle => 'Aujourd\'hui';

  @override
  String get logHappy => 'Heureuse';

  @override
  String get logCalm => 'Calme';

  @override
  String get logAnxious => 'Anxieuse';

  @override
  String get logIrritable => 'Irritable';

  @override
  String get logSad => 'Triste';

  @override
  String get logMoodSwings => 'Sautes d’humeur';

  @override
  String get logLowMotivation => 'Manque de motivation';

  @override
  String get logTearfulness => 'Envie de pleurer';

  @override
  String get logPanicFeelings => 'Bouffées de panique soudaines';

  @override
  String get logCramps => 'Crampes';

  @override
  String get logHeadache => 'Mal de tête';

  @override
  String get logBloating => 'Ballonnements';

  @override
  String get logBreastTenderness => 'Seins sensibles';

  @override
  String get logBackache => 'Mal de dos';

  @override
  String get logJointPain => 'Douleurs articulaires';

  @override
  String get logMusclePain => 'Douleurs musculaires';

  @override
  String get logNausea => 'Nausées';

  @override
  String get logConstipation => 'Constipation';

  @override
  String get logDiarrhea => 'Diarrhée';

  @override
  String get logFatigue => 'Fatigue';

  @override
  String get logAcne => 'Acné';

  @override
  String get logHotFlashes => 'Bouffées de chaleur';

  @override
  String get logNightSweats => 'Sueurs nocturnes';

  @override
  String get logSpotting => 'Spotting';

  @override
  String get logHeartFlutters => 'Palpitations';

  @override
  String get logWeightChange => 'Changement de poids';

  @override
  String get logCravings => 'Fringales';

  @override
  String get logInsomnia => 'Sommeil difficile';

  @override
  String get logDizziness => 'Vertiges';

  @override
  String get logBrainFog => 'Brouillard mental';

  @override
  String get logLibidoUp => 'Libido élevée';

  @override
  String get logLibidoDown => 'Libido basse';

  @override
  String get logVaginalDryness => 'Sécheresse vaginale';

  @override
  String get logPainDuringSex => 'Douleurs pendant les rapports';

  @override
  String get logBladderUrgency => 'Envies d’uriner pressantes ou fréquentes';

  @override
  String get logBladderLeaks => 'Fuites urinaires';

  @override
  String get logHairThinning => 'Cheveux qui s’affinent';

  @override
  String get logDryItchySkin => 'Peau sèche ou qui démange';

  @override
  String get logBrittleNails => 'Ongles cassants';

  @override
  String get logGumSoreness => 'Gencives douloureuses ou qui saignent';

  @override
  String get logBurningMouth => 'Bouche qui brûle ou picote';

  @override
  String get logTingling => 'Fourmillements dans les mains ou les pieds';

  @override
  String get logElectricShocks => 'Brèves sensations de décharge électrique';

  @override
  String get logBodyOdourChange => 'Changement d’odeur corporelle';

  @override
  String get logTinnitus => 'Sifflements dans les oreilles';

  @override
  String get logDry => 'Sèche';

  @override
  String get logSticky => 'Collante';

  @override
  String get logCreamy => 'Crémeuse';

  @override
  String get logWatery => 'Aqueuse';

  @override
  String get logEggWhite => 'Blanc d’œuf';

  @override
  String get logIntercourse => 'Rapport sexuel';

  @override
  String get flowSpotting => 'Léger (spotting)';

  @override
  String get flowLight => 'Faible';

  @override
  String get flowMedium => 'Moyen';

  @override
  String get flowHeavy => 'Abondant';

  @override
  String get flowLabel => 'Flux';

  @override
  String get navToday => 'Aujourd\'hui';

  @override
  String get navCalendar => 'Calendrier';

  @override
  String get navLog => 'Journal';

  @override
  String get calendarTitle => 'Calendrier';

  @override
  String get legendPeriod => 'Règles';

  @override
  String get legendSpotting => 'Spotting';

  @override
  String get legendPredicted => 'Les règles peuvent commencer';

  @override
  String get legendFertile => 'Fenêtre de fertilité';

  @override
  String get legendOvulation => 'Ovulation probable';

  @override
  String get legendLogged => 'Quelque chose noté';

  @override
  String get calendarHint =>
      'Touchez un jour pour le noter. Les estimations sont en contour ; ce que vous notez est rempli.';

  @override
  String get logTitle => 'Journal';

  @override
  String get sectionPeriod => 'Règles';

  @override
  String get flowNone => 'Aucun';

  @override
  String get sectionMood => 'Humeur';

  @override
  String get sectionSymptoms => 'Symptômes';

  @override
  String get sectionDischarge => 'Pertes';

  @override
  String get sectionMore => 'Autres';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get nextDay => 'Jour suivant';

  @override
  String get logSavedNote => 'Enregistré sur ce téléphone à chaque touche.';

  @override
  String get logSymptomsButton => 'Noter ce que vous ressentez';

  @override
  String loggedTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments notés aujourd\'hui',
      one: '1 élément noté aujourd\'hui',
      zero: 'Rien de noté aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get sectionOvulationTest => 'Test d\'ovulation';

  @override
  String get sectionTemperature => 'Température au réveil';

  @override
  String get temperatureHint => 'Prise avant de vous lever, en °C ou °F';

  @override
  String get temperatureSave => 'Enregistrer';

  @override
  String get temperatureClear => 'Effacer';

  @override
  String get testTimingTitle => 'Quand faire le test';

  @override
  String testTimingBody(String date) {
    return 'Si vos règles ne sont pas arrivées d\'ici le $date, un test de grossesse à domicile est fiable à partir de ce jour.';
  }

  @override
  String get opkNegative => 'Négatif';

  @override
  String get opkLow => 'Faible';

  @override
  String get opkHigh => 'Élevé';

  @override
  String get opkPeak => 'Pic';

  @override
  String get opkPositive => 'Positif';

  @override
  String get bbtChartHeading => 'Vos températures';

  @override
  String get bbtChartNeedData =>
      'Notez trois températures au réveil et votre courbe apparaîtra ici. En dessous, c’est un point, pas une tendance.';

  @override
  String get bbtChartNote =>
      'Ce sont vos mesures, telles quelles. Femio ne signale aucun décalage et ne désigne aucun jour — ce que dit une courbe se discute avec votre clinicien·ne.';

  @override
  String get invalidBbt =>
      'Cela ne ressemble pas à une mesure de thermomètre. Vérifiez le nombre et réessayez.';

  @override
  String get testTimingGeneral =>
      'La plupart des tests à domicile fonctionnent dès le premier jour de retard des règles. Un test plus précoce peut être négatif même en cas de grossesse.';

  @override
  String get testTimingSource => 'Source : NHS, faire un test de grossesse.';

  @override
  String pregDaysToGo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Encore $days jours',
      one: 'Encore $days jour',
    );
    return '$_temp0';
  }

  @override
  String pregOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours après la date prévue',
      one: '$days jour après la date prévue',
    );
    return '$_temp0';
  }

  @override
  String pregTermFrom(String date) {
    return 'À terme à partir du $date';
  }

  @override
  String get pregEstimateNote =>
      'Ces dates sont des estimations fondées sur la date prévue que vous avez saisie. Votre professionnel de santé peut l\'ajuster après une échographie.';

  @override
  String get pregRedFlagsHeading =>
      'Certains symptômes nécessitent des soins urgents';

  @override
  String get pregRedFlagsBody =>
      'Saignements, maux de tête intenses, troubles de la vision, douleurs abdominales sévères ou mouvements réduits doivent être examinés immédiatement. Contactez votre maternité ou les services d\'urgence locaux — n\'attendez pas.';

  @override
  String get contractionsHeading => 'Minuteur de contractions';

  @override
  String get contractionsIntro =>
      'Appuyez sur démarrer quand une contraction commence et sur arrêter quand elle passe. Femio garde les temps pour que vous les ayez au téléphone.';

  @override
  String get contractionsStart => 'Démarrer une contraction';

  @override
  String get contractionsStop => 'Elle s’est calmée';

  @override
  String get contractionsRunning => 'Chronométrage en cours';

  @override
  String get contractionsContactHeading =>
      'Appelez la maternité dès que vous en avez besoin';

  @override
  String get contractionsContactBody =>
      'Vous n’avez pas à atteindre un chiffre d’abord. Appelez si vous êtes inquiète, si vous perdez les eaux, en cas de saignement, ou si le bébé bouge moins que d’habitude.';

  @override
  String contractionsSummaryHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vos $count dernières contractions',
      one: 'Votre dernière contraction',
    );
    return '$_temp0';
  }

  @override
  String contractionsSummaryDuration(String value) {
    return 'Durée d’environ $value';
  }

  @override
  String contractionsSummaryInterval(String value) {
    return 'Environ $value d’écart, début à début';
  }

  @override
  String get contractionsSummaryNote =>
      'Ce sont vos temps, tels qu’enregistrés. Femio ne décide pas de ce qu’ils veulent dire — lisez-les à votre sage-femme ou à la maternité, qui le peut.';

  @override
  String get movementsHeading => 'Journal des mouvements';

  @override
  String get movementsIntro =>
      'Il n\'existe pas de nombre normal de mouvements. Ce qui compte, c\'est un changement par rapport aux habitudes de votre bébé : ce journal enregistre ce que vous ressentez et vous montre votre propre rythme au fil du temps.';

  @override
  String get movementsUrgentHeading =>
      'Si les mouvements sont moins fréquents que d\'habitude';

  @override
  String get movementsUrgentBody =>
      'Contactez votre équipe de maternité maintenant. N’attendez pas la fin de cette séance, et n’attendez pas demain.';

  @override
  String get movementsStart => 'Commencer une séance';

  @override
  String get movementsStartBody =>
      'Installez-vous confortablement, puis commencez. Appuyez chaque fois que vous sentez un mouvement.';

  @override
  String get movementsTap => 'J\'ai senti un mouvement';

  @override
  String movementsCounted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mouvements enregistrés',
      one: '$count mouvement enregistré',
    );
    return '$_temp0';
  }

  @override
  String get movementsFinish => 'Terminer et enregistrer';

  @override
  String get movementsFinishNote =>
      'Vous pouvez arrêter à tout moment. La séance est enregistrée dans tous les cas.';

  @override
  String get movementsRecentHeading => 'Vos séances récentes';

  @override
  String movementsSessionSummary(int count, String minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mouvements',
      one: '$count mouvement',
    );
    return '$_temp0 · environ $minutes min d’intervalle';
  }

  @override
  String get movementsUnfinished => 'Non terminée';

  @override
  String get movementsSlowerHeading =>
      'Les mouvements étaient plus espacés que d\'habitude pour vous';

  @override
  String get movementsSlowerBody =>
      'C\'est un changement par rapport à vos séances récentes. Ce que cela signifie, c\'est à votre équipe de maternité de le dire : contactez-la pour qu\'on vérifie.';

  @override
  String movementsNeedMore(String count) {
    return 'Après $count séances, vous pourrez comparer avec votre propre rythme.';
  }

  @override
  String get pregnancyToolsTitle => 'Outils de grossesse';

  @override
  String get contractionsClear => 'Effacer ces temps';

  @override
  String get contractionsCleared => 'Temps effacés';

  @override
  String get contractionLength => 'Durée';

  @override
  String get contractionApart => 'Intervalle';
}
