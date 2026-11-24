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
      'Vos données restent sur ce téléphone. Pas de compte, et femio ne les voit jamais.';

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
      'Les cycles changent avec l\'âge : cela aide femio à savoir à quoi s\'attendre. L\'année seulement.';

  @override
  String get under18Title =>
      'Le suivi est réservé aux adultes, pour l\'instant';

  @override
  String get under18Body =>
      'Le suivi femio est réservé aux femmes de 18 ans et plus dans cette première version. Tous les guides sur femioapp.com vous sont ouverts, sans compte.';

  @override
  String get eighteenTitle => 'Avez-vous déjà fêté vos 18 ans ?';

  @override
  String get eighteenSub =>
      'Une seule vérification rapide : le suivi est réservé aux femmes de 18 ans et plus. Rien n\'est enregistré ici.';

  @override
  String get yesLabel => 'Oui';

  @override
  String get noNotYetLabel => 'Non, pas encore';

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
      'Vos cycles varient : femio affiche une fourchette plus large et ne compte jamais de jours de retard.';

  @override
  String get noPredictionTitle => 'Notez vos prochaines règles';

  @override
  String get noPredictionBody =>
      'Quand vos règles commencent, notez-les et femio prévoira les suivantes.';

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
      'Notez les saignements ou symptômes : femio garde le suivi pour votre soignant.';

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
      'Ce sont vos mesures, telles quelles. femio ne signale aucun décalage et ne désigne aucun jour — ce que dit une courbe se discute avec votre clinicien·ne.';

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
      'Consultez sans attendre en cas de maux de tête sévères, de troubles de la vision, de douleur en haut de l\'abdomen, de gonflement du visage ou des mains, de difficulté à respirer, de saignements vaginaux, ou si les mouvements de votre bébé ont ralenti, cessé ou changé. Contactez votre maternité ou les services d\'urgence locaux. Si vous ne les joignez pas, rendez-vous aux urgences les plus proches.';

  @override
  String get pregRedFlagsMore => 'Voir la liste complète et ses sources';

  @override
  String get redFlagsListHeading =>
      'Consultez sans attendre pour l\'un de ces signes';

  @override
  String get redFlagHeadache => 'Des maux de tête sévères';

  @override
  String get redFlagVision => 'Des troubles de la vision';

  @override
  String get redFlagUpperAbdomen => 'Une douleur en haut de l\'abdomen';

  @override
  String get redFlagSwelling => 'Un gonflement du visage ou des mains';

  @override
  String get redFlagBreathing => 'Une difficulté à respirer';

  @override
  String get redFlagBleeding => 'Des saignements vaginaux';

  @override
  String get redFlagMovements =>
      'Un ralentissement, un arrêt ou un changement des mouvements de votre bébé';

  @override
  String get contractionsHeading => 'Minuteur de contractions';

  @override
  String get contractionsIntro =>
      'Appuyez sur démarrer quand une contraction commence et sur arrêter quand elle passe. femio garde les temps pour que vous les ayez au téléphone.';

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
      'Ce sont vos temps, tels qu’enregistrés. femio ne décide pas de ce qu’ils veulent dire — lisez-les à votre sage-femme ou à la maternité, qui le peut.';

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

  @override
  String get apptTitle => 'Rendez-vous';

  @override
  String get apptAdd => 'Ajouter un rendez-vous';

  @override
  String get apptCancel => 'Annuler';

  @override
  String get apptSave => 'Enregistrer le rendez-vous';

  @override
  String get apptUntitled => 'Rendez-vous';

  @override
  String get apptNoDate => 'Pas encore de date';

  @override
  String get apptToday => 'Aujourd’hui';

  @override
  String apptInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Dans $days jours',
      one: 'Demain',
    );
    return '$_temp0';
  }

  @override
  String get apptPrepHeading => 'Ce que vous vouliez demander';

  @override
  String get apptUpcoming => 'À venir';

  @override
  String get apptPast => 'Passés';

  @override
  String get apptNoResultsNote =>
      'femio retient la date, la personne et ce que vous vouliez demander. Il ne retient pas ce qui a été trouvé — cela appartient à votre dossier et à votre clinicien·ne.';

  @override
  String get apptEmptyHeading => 'Rien pour l’instant';

  @override
  String get apptEmptyBody =>
      'Ajoutez un rendez-vous et femio gardera les questions que vous vouliez poser — la partie que tout le monde oublie une fois dans la pièce.';

  @override
  String get apptAwaitingHeading => 'Toujours sans nouvelles ?';

  @override
  String apptAwaitingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous attendiez un résultat pour $count d’entre eux.',
      one: 'Vous attendiez un résultat pour l’un d’entre eux.',
    );
    return '$_temp0 Cela vaut peut-être la peine de relancer — un résultat peut tarder pour des raisons tout à fait ordinaires.';
  }

  @override
  String get apptFormType => 'De quoi s’agit-il';

  @override
  String get apptFormTypePlaceholder => 'Échographie, prise de sang, contrôle…';

  @override
  String get apptFormClinician => 'Avec qui';

  @override
  String get apptFormWhen => 'Quand';

  @override
  String get apptFormResultsDue => 'Résultats annoncés pour le';

  @override
  String get apptFormResultsDueHint =>
      'Facultatif. femio vous rappellera de relancer si la date passe ; il n’enregistre jamais le résultat lui-même.';

  @override
  String get apptFormPrep => 'Questions à poser';

  @override
  String get apptFormPrepPlaceholder => 'Une par ligne';

  @override
  String apptPrepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions enregistrées',
      one: '$count question enregistrée',
    );
    return '$_temp0';
  }

  @override
  String get weightHeading => 'Poids';

  @override
  String get weightIntro =>
      'Ajoutez une mesure quand vous voulez. femio les trace et garde les chiffres pour votre dossier.';

  @override
  String get weightValue => 'Poids';

  @override
  String get weightSave => 'Enregistrer';

  @override
  String get weightInvalid =>
      'Cela ne ressemble pas à une mesure de balance. Vérifiez le nombre et réessayez.';

  @override
  String get weightNeedData =>
      'Ajoutez une deuxième mesure et votre courbe apparaîtra ici.';

  @override
  String weightChange(String value, String unit) {
    return '$value $unit depuis votre première saisie';
  }

  @override
  String get weightNote =>
      'Vos mesures, telles quelles. femio n’affiche aucune fourchette cible et ne dit pas si une évolution est attendue — ce que signifie une courbe se discute avec votre sage-femme ou votre médecin.';

  @override
  String get weightDate => 'Mesuré le';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get weightUnitLb => 'lb';

  @override
  String get apptDelete => 'Supprimer';

  @override
  String get apptEdit => 'Modifier';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsDates => 'Dates';

  @override
  String get settingsHijri => 'Afficher les dates hégiriennes';

  @override
  String get settingsHijriNote =>
      'À côté de chaque date grégorienne. Calendrier Umm al-Qura ; peut différer d\'un jour des annonces locales.';

  @override
  String get settingsPrivacy => 'Confidentialité';

  @override
  String get settingsLock => 'Verrouillage de l\'application';

  @override
  String get settingsLockNote =>
      'Demander un code PIN à l\'ouverture de femio et après une minute d\'absence.';

  @override
  String get setPin => 'Choisissez un code PIN de 4 à 8 chiffres';

  @override
  String get changePin => 'Changer le code PIN';

  @override
  String get enterPin => 'Code PIN';

  @override
  String get enterPinAgain => 'Saisissez le code PIN à nouveau';

  @override
  String get enterCurrentPin => 'Saisissez votre code PIN actuel';

  @override
  String get pinMismatch => 'Les deux codes ne correspondent pas. Réessayez.';

  @override
  String get wrongPin => 'Ce code PIN est incorrect.';

  @override
  String get lockTitle => 'Bon retour';

  @override
  String get lockHint => 'Saisissez votre code PIN pour ouvrir vos données.';

  @override
  String get forgotPin =>
      'Code PIN oublié ? Il ne peut pas être récupéré : femio n\'a pas de compte. Supprimez tout de ce téléphone et recommencez, ou restaurez un fichier de sauvegarde.';

  @override
  String get backupSection => 'Sauvegarde';

  @override
  String get exportBackup => 'Enregistrer un fichier de sauvegarde';

  @override
  String get importBackup => 'Restaurer depuis un fichier de sauvegarde';

  @override
  String get backupPassphrase => 'Phrase secrète';

  @override
  String get backupPassphraseAgain => 'Phrase secrète à nouveau';

  @override
  String get backupPassphraseHint =>
      'Choisissez une phrase secrète dont vous vous souviendrez. Le fichier ne s\'ouvre qu\'avec elle, et personne ne peut la réinitialiser.';

  @override
  String backupPassphraseShort(int count) {
    return 'Utilisez au moins $count caractères.';
  }

  @override
  String get backupPassphraseMismatch =>
      'Les deux phrases secrètes ne correspondent pas.';

  @override
  String get backupSaved => 'Sauvegarde enregistrée.';

  @override
  String get backupImported => 'Vos données ont été restaurées.';

  @override
  String get backupWrongPassphrase =>
      'Cette phrase secrète n\'ouvre pas ce fichier.';

  @override
  String get backupNotFemio => 'Ce n\'est pas un fichier de sauvegarde femio.';

  @override
  String get backupUnreadable =>
      'Cette sauvegarde a été faite par un femio plus récent et ne peut pas être lue ici. Mettez l\'application à jour et réessayez.';

  @override
  String get backupHonesty =>
      'Vos données ne sont que sur ce téléphone. Si vous le perdez ou le réinitialisez, elles disparaissent, sauf si vous avez enregistré un fichier de sauvegarde. Nous ne pouvons pas les récupérer pour vous.';

  @override
  String get aboutSection => 'À propos';

  @override
  String get wellnessDisclaimer =>
      'femio est un outil de bien-être et d\'information pour suivre votre propre santé. Ce n\'est pas un dispositif médical et il ne remplace pas votre professionnel de santé.';

  @override
  String get predictionNote =>
      'Les prédictions sont des estimations, pas des garanties, et ne doivent pas servir à éviter une grossesse.';

  @override
  String get firstRunStorageNotice =>
      'Vos données restent sur ce téléphone. femio n\'a ni compte ni serveur, et ne peut pas voir ce que vous saisissez.';

  @override
  String get firstRunStorageTitle => 'Privé par conception';

  @override
  String get dismiss => 'Compris';

  @override
  String get deleteEverything => 'Tout supprimer de ce téléphone';

  @override
  String get deleteConfirmTitle => 'Tout supprimer de ce téléphone ?';

  @override
  String get deleteConfirmBody =>
      'Cela supprime toutes vos données et vos réglages de femio sur ce téléphone. C\'est irréversible et nous ne pouvons pas les restaurer. Les fichiers de sauvegarde enregistrés ailleurs ne sont pas supprimés.';

  @override
  String get deleteConfirmAction => 'Tout supprimer';

  @override
  String get deleteConfirmCancel => 'Garder mes données';

  @override
  String get corruptTitle => 'Vos données n\'ont pas pu être ouvertes';

  @override
  String get corruptBody =>
      'Le fichier sur ce téléphone est endommagé ou a été écrit par un autre femio. Il a été mis de côté, pas supprimé. Restaurez un fichier de sauvegarde si vous en avez un, ou recommencez.';

  @override
  String get settingsReminders => 'Rappels';

  @override
  String get reminderLog => 'Rappel de saisie';

  @override
  String get reminderLogNote =>
      'Un rappel quotidien à l\'heure de votre choix. Il saute un jour déjà saisi.';

  @override
  String get reminderLogTime => 'Heure du rappel';

  @override
  String get reminderPeriod => 'Règles attendues';

  @override
  String get reminderPeriodNote =>
      'Une notification la veille de l\'ouverture de votre fenêtre estimée. Seulement si vos cycles sont assez réguliers pour une estimation.';

  @override
  String get remindersPrivacyNote =>
      'Un rappel dit seulement « femio : Ouvrez l\'application ». Rien sur votre santé n\'apparaît sur l\'écran verrouillé.';

  @override
  String get remindersTimingNote =>
      'Un rappel peut arriver avec quelques minutes de retard, et certains téléphones le retiennent pour économiser la batterie.';

  @override
  String get reminderPermissionDenied =>
      'Les notifications sont désactivées pour femio. Vous pouvez les autoriser dans les réglages de votre téléphone.';

  @override
  String get reminderTitle => 'femio';

  @override
  String get reminderBody => 'Ouvrez l\'application';

  @override
  String get reminderChannelName => 'Rappels';

  @override
  String get reminderChannelDescription =>
      'Les rappels que vous avez activés dans femio. Ils ne mentionnent jamais votre santé.';

  @override
  String calendarDayLabel(String gregorian, String hijri) {
    return '$gregorian, $hijri';
  }

  @override
  String get navLearn => 'Apprendre';

  @override
  String get learnTitle => 'Apprendre';

  @override
  String get learnSub =>
      'Des guides sourcés, en mots simples. La conception et la grossesse d\'abord ; tout reste ici.';

  @override
  String get learnSearchHint => 'Rechercher dans les guides';

  @override
  String get learnNoResults => 'Aucun guide ne correspond pour l\'instant.';

  @override
  String learnReviewedBy(String name) {
    return 'Relu par $name';
  }

  @override
  String learnReviewedOn(String name, String date) {
    return 'Relu par $name · $date';
  }

  @override
  String get learnReviewPending =>
      'Vérifié par la rédaction · relecture clinique en attente';

  @override
  String get learnEnglishOnly => 'En anglais';

  @override
  String get learnEnglishOnlyBody =>
      'Ce guide n\'est pas encore traduit ; il est affiché en anglais.';

  @override
  String get learnSeekCareNow => 'Consultez sans attendre';

  @override
  String get learnSources => 'Sources';

  @override
  String get learnLinkCopied => 'Lien copié. Collez-le dans votre navigateur.';

  @override
  String get noConfidentWindowTitle => 'Pas de fenêtre fiable ce cycle';

  @override
  String get noConfidentWindowBody =>
      'Vos cycles varient trop pour nommer des jours fertiles à partir d\'une date. Noter vos règles, vos tests d\'ovulation et votre température au réveil permet de le savoir après coup.';

  @override
  String get seeClinicianIrregular =>
      'Comme vos cycles sont irréguliers, il est raisonnable d\'en parler à un professionnel de santé maintenant plutôt que d\'attendre un an.';

  @override
  String get helpNowLauncher => 'Besoin d\'aide maintenant ?';

  @override
  String get helpNowDialogTitle => 'Besoin d\'aide maintenant ?';

  @override
  String get helpNowImmediateHeading => 'Si vous êtes peut-être en danger';

  @override
  String get helpNowImmediateLead =>
      'Si vous risquez de passer à l\'acte contre vous-même ou contre quelqu\'un d\'autre, ou si vous êtes en danger immédiat, contactez les services d\'urgence disponibles là où vous vous trouvez maintenant, ou rendez-vous au service des urgences le plus proche.';

  @override
  String get helpNowStayWithSomeone =>
      'Si vous le pouvez, restez avec une personne de confiance le temps d\'obtenir de l\'aide.';

  @override
  String get helpNowWorriedHeading =>
      'Si vous vous inquiétez pour quelqu\'un d\'autre';

  @override
  String get helpNowWorriedBody =>
      'Si vous pensez que la personne est en danger immédiat, ne la laissez pas seule tant qu\'il est sans danger pour vous de rester. Contactez les services d\'urgence disponibles là où elle se trouve, un service de crise, un professionnel de santé ou un proche de confiance.';

  @override
  String get helpNowCountry_egypt => 'Égypte';

  @override
  String get helpNowCountry_saudi => 'Arabie saoudite';

  @override
  String get helpNowCountry_uae => 'Émirats arabes unis';

  @override
  String get helpNowCountry_qatar => 'Qatar';

  @override
  String get helpNowCountry_kuwait => 'Koweït';

  @override
  String get helpNowCountry_bahrain => 'Bahreïn';

  @override
  String get helpNowCountry_oman => 'Oman';

  @override
  String get helpNowCountry_jordan => 'Jordanie';

  @override
  String get helpNowCountry_lebanon => 'Liban';

  @override
  String get helpNowCountry_morocco => 'Maroc';

  @override
  String get helpNowCountry_uk => 'Royaume-Uni';

  @override
  String get helpNowCountry_france => 'France';

  @override
  String get helpNowCountry_spain => 'Espagne';

  @override
  String get helpNowCountry_usa => 'États-Unis';

  @override
  String get helpNowCountry_canada => 'Canada';

  @override
  String get helpNowCountry_mexico => 'Mexique';

  @override
  String get helpNowNumber_eg_ambulance =>
      'Ambulances (Organisation égyptienne des ambulances)';

  @override
  String get helpNowNumber_eg_mental_health =>
      'Ligne de santé mentale (ministère de la Santé, secrétariat de la santé mentale)';

  @override
  String get helpNowNumber_eg_ncw =>
      'Bureau des plaintes des femmes (Conseil national de la femme)';

  @override
  String get helpNowNumber_sa_srca =>
      'Ambulances (Autorité du Croissant-Rouge saoudien)';

  @override
  String get helpNowNumber_sa_moh => 'Centre d’appel du ministère de la Santé';

  @override
  String get helpNowNumber_sa_moh_mental =>
      'Consultations psychologiques (ministère de la Santé)';

  @override
  String get helpNowNumber_sa_hrsd =>
      'Centre de signalement des violences familiales (ministère des Ressources humaines et du Développement social)';

  @override
  String get helpNowNumber_ae_ambulance => 'Ambulances';

  @override
  String get helpNowNumber_qa_emergency =>
      'Services d’urgence (ambulances, police, défense civile)';

  @override
  String get helpNowNumber_qa_mental =>
      'Ligne nationale de santé mentale, option 4 (Hamad Medical Corporation)';

  @override
  String get helpNowNumber_kw_emergency =>
      'Services d’urgence (ministère de l’Intérieur)';

  @override
  String get helpNowNumber_bh_emergency => 'Services d’urgence';

  @override
  String get helpNowNumber_om_emergency =>
      'Services d’urgence (Police royale d’Oman)';

  @override
  String get helpNowNumber_om_dv =>
      'Ligne violences domestiques (répertoriée par le gouvernement d’Oman)';

  @override
  String get helpNowNumber_jo_emergency =>
      'Services d’urgence (Direction de la sécurité publique)';

  @override
  String get helpNowNumber_jo_ambulance => 'Ambulances (Défense civile)';

  @override
  String get helpNowNumber_jo_family =>
      'Département de la protection de la famille et des mineurs';

  @override
  String get helpNowNumber_lb_redcross => 'Ambulances (Croix-Rouge libanaise)';

  @override
  String get helpNowNumber_lb_lifeline =>
      'Ligne d’écoute et de soutien (répertoriée par le ministère de la Santé publique)';

  @override
  String get helpNowNumber_ma_samu =>
      'Urgences médicales, SAMU (ministère de la Santé)';

  @override
  String get helpNowNumber_ma_police => 'Police';

  @override
  String get helpNowNumber_gb_999 => 'Services d’urgence';

  @override
  String get helpNowNumber_gb_111 => 'NHS 111, option santé mentale';

  @override
  String get helpNowNumber_gb_refuge =>
      'Ligne nationale violences domestiques (Refuge)';

  @override
  String get helpNowNumber_fr_samu => 'Urgences médicales, SAMU';

  @override
  String get helpNowNumber_fr_3114 =>
      'Numéro national de prévention du suicide';

  @override
  String get helpNowNumber_fr_3919 => 'Violences Femmes Info';

  @override
  String get helpNowNumber_es_112 => 'Services d’urgence';

  @override
  String get helpNowNumber_es_024 =>
      'Ligne d’aide face aux conduites suicidaires (ministère de la Santé)';

  @override
  String get helpNowNumber_es_016 =>
      'Ligne d’information violences de genre, 016 (ministère de l’Égalité)';

  @override
  String get helpNowNumber_us_911 => 'Services d’urgence';

  @override
  String get helpNowNumber_us_988 =>
      'Suicide and Crisis Lifeline (ligne de crise)';

  @override
  String get helpNowNumber_us_ndvh =>
      'National Domestic Violence Hotline (violences domestiques)';

  @override
  String get helpNowNumber_ca_911 => 'Services d’urgence';

  @override
  String get helpNowNumber_ca_988 => 'Ligne d’aide en cas de crise suicidaire';

  @override
  String get helpNowNumber_mx_911 => 'Services d’urgence';

  @override
  String get helpNowNumber_mx_vida =>
      'Línea de la Vida (Commission nationale de santé mentale)';

  @override
  String get helpNowCountryPrompt => 'Choisissez un pays pour voir ses numéros';

  @override
  String get helpNowEmergency => 'Services d\'urgence';

  @override
  String get helpNowSupport => 'Lignes d\'écoute';

  @override
  String get helpNowSource => 'Source';

  @override
  String get helpNowCall => 'Appeler';

  @override
  String get redFlagsReadGuide => 'Lire les signes d\'alerte de la grossesse';

  @override
  String get plusProbeTitle =>
      'femio Plus · vérification de la facturation (versions de test seulement)';

  @override
  String get plusProbeSubtitle =>
      'Touchez pour demander à Google Play si la facturation est joignable sur ce téléphone. Rien n’est acheté.';

  @override
  String get plusProbeRunning => 'Demande à Google Play…';

  @override
  String get plusProbeAvailable => 'Facturation Play joignable : oui';

  @override
  String get plusProbeUnavailable =>
      'Facturation Play joignable : non (pas de Play Store sur cet appareil, ou pas connecté)';

  @override
  String get plusProbeProductFound =>
      'Produit femio_plus trouvé dans la Play Console';

  @override
  String get plusProbeProductMissing =>
      'Produit femio_plus introuvable pour l’instant (normal tant qu’il n’est pas créé dans la Play Console)';

  @override
  String get adLabel => 'Publicité';

  @override
  String get adsNotice =>
      'Les publicités n’apparaissent que sur les écrans des guides. Elles ne voient jamais vos données, et femio Plus les supprimera.';

  @override
  String get assistantPrivateNote =>
      'Cela se passe sur votre téléphone. Vos mots ne sont ni enregistrés ni envoyés.';

  @override
  String get assistantModelNote =>
      'Gemini Nano, l’IA de votre téléphone, a aidé.';

  @override
  String get sayItButton => 'Dites-le avec vos mots';

  @override
  String get sayItTitle => 'Comment vous sentez-vous ?';

  @override
  String get sayItHint =>
      'Par exemple : grosses crampes, saignement léger, très fatiguée';

  @override
  String get sayItAction => 'Transformer en notes du jour';

  @override
  String get sayItNothing =>
      'femio n’a rien trouvé à noter. Essayez d’autres mots ou touchez les choix de l’écran Journal.';

  @override
  String get sayItFound => 'femio a trouvé ceci. Décochez ce qui est faux.';

  @override
  String get sayItAdd => 'Ajouter au journal de ce jour';

  @override
  String get sayItAdded => 'Ajouté à votre journal.';

  @override
  String get safetyCrisisHeading => 'Vous n’avez pas à traverser cela seule';

  @override
  String get safetyCrisisBody =>
      'Si vous pensez à vous faire du mal, demandez de l’aide maintenant. La page d’aide donne les lignes d’écoute de votre pays.';

  @override
  String get safetyUrgentHeading => 'Cela peut nécessiter des soins urgents';

  @override
  String get safetyUrgentBody =>
      'Une douleur thoracique, une difficulté à respirer, un malaise ou une convulsion demandent une aide médicale immédiate. Appelez le numéro d’urgence local.';

  @override
  String get safetyBirthControl =>
      'femio n’est pas une méthode de contraception et ne conseille pas sur la façon d’éviter une grossesse. Un médecin, un pharmacien ou un centre de planification peut vous aider à choisir.';

  @override
  String get askTitle => 'Demander à femio';

  @override
  String get askIntro =>
      'Posez une question de santé. femio cherche la réponse dans des sources fiables comme l’OMS, le NHS et les CDC, et vous montre d’où elle vient.';

  @override
  String get askHint =>
      'Par exemple : qu’est-ce qui soulage les crampes de règles ?';

  @override
  String get askAction => 'Demander';

  @override
  String get askPersonalRewritten =>
      'Votre question parle de vous : seule une version générale, sans détail personnel, peut quitter votre téléphone. Vérifiez-la ci-dessous.';

  @override
  String get askPersonalSelf =>
      'Votre question parle de vous. Réécrivez-la ci-dessous de façon générale, sans « je », « mon » ni détail personnel, et femio la cherchera.';

  @override
  String get askWillSend =>
      'Voici exactement ce qui sera envoyé à Google pour chercher dans des sources fiables :';

  @override
  String get askSend => 'Chercher dans les sources fiables';

  @override
  String get askStillPersonal =>
      'Cela parle encore de vous. Retirez les mots comme « je » ou « mon » et tout détail personnel.';

  @override
  String get askCloudPrivacy =>
      'Seule la question affichée est envoyée. Rien de votre journal.';

  @override
  String get askSearching => 'Recherche dans les sources fiables…';

  @override
  String get askFailed =>
      'femio n’a pas pu joindre les sources pour le moment. Réessayez plus tard.';

  @override
  String get askNotSetUp =>
      'La recherche dans les sources fiables n’est pas activée dans cette version. Voici les guides de femio sur le sujet.';

  @override
  String get askNoTrusted =>
      'femio n’a trouvé aucune réponse d’une source de santé fiable, il n’en affiche donc pas. Reformulez ou parlez-en à votre médecin.';

  @override
  String get askAnswerLabel => 'Issu de sources fiables, trouvé avec Google';

  @override
  String get askSourcesTitle => 'Sources';

  @override
  String get askTrustedBadge => 'Source fiable';

  @override
  String get askOtherSource => 'Hors de la liste fiable de femio';

  @override
  String get askClinicianLine =>
      'Ceci est une information générale, pas un conseil pour vous. Pour votre situation, parlez à votre médecin ou à votre sage-femme.';

  @override
  String get askRelatedGuides => 'Guides femio sur ce sujet';

  @override
  String get askSearchAgain => 'Poser une autre question';

  @override
  String get visitButton => 'Résumé pour la consultation';

  @override
  String get visitTitle => 'Résumé pour la consultation';

  @override
  String get visitIntro =>
      'Une page à montrer à votre médecin, faite à partir de votre journal. Elle reste sur votre téléphone, sauf si vous la copiez.';

  @override
  String visitCycles(int count, int longest, int shortest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cycles notés : de $shortest à $longest jours',
      one: '1 cycle noté : $shortest jours',
      zero: 'Aucun cycle complet noté pour l’instant',
    );
    return '$_temp0';
  }

  @override
  String visitLastPeriod(String date) {
    return 'Dernières règles commencées le $date';
  }

  @override
  String get visitIrregular => 'Cycles décrits comme irréguliers';

  @override
  String get visitTopTerms => 'Le plus noté ces 90 derniers jours';

  @override
  String visitDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get visitHeavyDays => 'Jours de flux abondant';

  @override
  String get visitOpkPositive => 'Tests d’ovulation positifs';

  @override
  String get visitTemperatureDays => 'Jours avec une température au réveil';

  @override
  String get visitTryingFor => 'Essai de grossesse';

  @override
  String get visitQuestionsTitle => 'Questions à poser';

  @override
  String get visitCopy => 'Copier en texte';

  @override
  String get visitCopied => 'Copié. Collez-le dans un message ou vos notes.';

  @override
  String get visitQ_cycleSpread =>
      'La durée de mes cycles varie. Faut-il s’y intéresser ?';

  @override
  String get visitQ_ttcTests =>
      'Vu le temps depuis lequel nous essayons, quels examens proposeriez-vous ?';

  @override
  String get visitQ_ovulation => 'Comment savoir si j’ovule ?';

  @override
  String get visitQ_folicAcid =>
      'Devrais-je prendre de l’acide folique maintenant ?';

  @override
  String get visitQ_painfulPeriods =>
      'Mes douleurs de règles gênent mes journées. Qu’est-ce qui peut aider ?';

  @override
  String get visitQ_heavyPeriods =>
      'Mes règles sont abondantes. Une prise de sang serait-elle utile ?';

  @override
  String get visitQ_moodCycle =>
      'Mon humeur change beaucoup autour des règles. Pouvons-nous en parler ?';

  @override
  String get visitQ_skinHair =>
      'J’ai des changements de peau ou de cheveux avec des cycles irréguliers. Faut-il les examiner ensemble ?';

  @override
  String get visitQ_tiredness =>
      'Je suis souvent fatiguée. Y a-t-il quelque chose à vérifier ?';

  @override
  String get visitQ_menopause =>
      'Mes symptômes pourraient-ils être liés à la périménopause, et quelles sont mes options ?';

  @override
  String get visitQ_pregnancyNext =>
      'À quoi dois-je faire attention avant notre prochain rendez-vous ?';

  @override
  String get visitQ_pregnancyMovements =>
      'Quand dois-je commencer à surveiller les mouvements du bébé ?';

  @override
  String get visitQ_anythingElse =>
      'Y a-t-il quelque chose dans mon journal que vous aimeriez regarder de plus près ?';

  @override
  String get assistantSettingsTitle => 'Assistant';

  @override
  String get assistantSettingsSub =>
      'IA sur votre téléphone et réponses de sources fiables';

  @override
  String get assistantOnDeviceTitle => 'IA sur votre téléphone (Gemini Nano)';

  @override
  String get assistantOnDeviceAvailable =>
      'Prête. Elle lit vos notes sur le téléphone ; rien n’est envoyé.';

  @override
  String get assistantOnDeviceDownloadable =>
      'Peut être téléchargée sur ce téléphone.';

  @override
  String get assistantOnDeviceDownloading => 'Téléchargement…';

  @override
  String get assistantOnDeviceUnavailable =>
      'Indisponible sur ce téléphone. femio utilise sa propre liste de mots, elle aussi sur le téléphone.';

  @override
  String get assistantDownload => 'Télécharger';

  @override
  String get assistantCloudTitle => 'Réponses de sources fiables';

  @override
  String get assistantCloudOn =>
      'Activé. Seules les questions générales que vous validez sont envoyées à Google, jamais votre journal.';

  @override
  String get assistantCloudOff => 'Non activé dans cette version.';

  @override
  String get assistantHowItWorks =>
      'Tout ce qui vous concerne reste sur votre téléphone. Vos notes et votre journal sont lus par les règles de femio et, si votre téléphone l’a, par Gemini Nano sur le téléphone. Les règles de sécurité passent toujours en premier : un signe de danger ouvre la page d’aide, et femio ne conseille jamais sur la contraception. Une question générale que vous validez peut être envoyée à Google pour trouver une réponse dans des sources de santé fiables ; femio affiche ces sources avec chaque réponse.';
}
