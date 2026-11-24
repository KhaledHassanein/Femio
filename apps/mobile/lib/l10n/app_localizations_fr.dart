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
  String get safetyHeavyBleedingHeading => 'Saignement abondant avec vertiges';

  @override
  String get safetyHeavyBleedingBody =>
      'L’ACOG (collège américain des gynécologues-obstétriciens) dit : « Si vous changez de serviette ou de tampon toutes les heures pendant plus de 2 heures d’affilée, et que vous avez aussi une douleur thoracique, un essoufflement et une sensation de tête légère ou de vertige, consultez les urgences tout de suite. » (Traduction femio.) Si c’est votre cas, appelez le numéro d’urgence local maintenant. Si un saignement abondant vous inquiète, parlez-en à votre médecin.';

  @override
  String get safetyPostpartumHeading =>
      'Un signe d’alerte après l’accouchement';

  @override
  String get safetyPostpartumBody =>
      'Dans l’année qui suit l’accouchement, la campagne Hear Her des CDC dit de consulter immédiatement en cas de signe d’alerte urgent, comme un saignement abondant, de la fièvre, un mal de tête qui ne passe pas ou une jambe gonflée. Appelez votre médecin ou votre sage-femme maintenant, ou le numéro d’urgence local.';

  @override
  String get askTitle => 'Demander à femio';

  @override
  String get askIntro =>
      'Posez une question de santé. femio répond uniquement à partir de sources de santé fiables qu’il garde sur votre téléphone, comme les CDC, MedlinePlus et l’Office on Women’s Health, et montre d’où vient chaque phrase.';

  @override
  String get askHint =>
      'Par exemple : qu’est-ce qui soulage les crampes de règles ?';

  @override
  String get askAction => 'Demander';

  @override
  String get askWillSend =>
      'Voici exactement la question qui sera envoyée, avec les sources publiques :';

  @override
  String get askSend => 'Résumer avec Cloud boost';

  @override
  String get askStillPersonal =>
      'Cela parle encore de vous. Retirez les mots comme « je » ou « mon » et tout détail personnel.';

  @override
  String get askCloudPrivacy =>
      'Seules cette question et les sources publiques sont envoyées. Rien de votre journal.';

  @override
  String get askSearching => 'Lecture des sources fiables…';

  @override
  String get askSourcesTitle => 'Sources';

  @override
  String get askClinicianLine =>
      'Ceci est une information générale, pas un conseil pour vous. Pour votre situation, parlez à votre médecin ou à votre sage-femme.';

  @override
  String get askRelatedGuides => 'Guides femio sur ce sujet';

  @override
  String get askSearchAgain => 'Poser une autre question';

  @override
  String get askAboutYouStays =>
      'Votre question parle de vous, elle reste donc sur ce téléphone. Voici les sources mot pour mot.';

  @override
  String get askModelFellBack =>
      'L’IA n’a pas pu écrire une réponse qui cite ses sources ; les voici mot pour mot.';

  @override
  String get askBoostHeading => 'Cloud boost';

  @override
  String get askBoostConfirm =>
      'Ce téléphone n’a pas d’IA intégrée. Avec Cloud boost, l’IA cloud de Google peut résumer ces sources publiques pour vous. Vérifiez d’abord la question.';

  @override
  String get askReadSourcesInstead => 'Lire plutôt les sources';

  @override
  String get askNotCoveredHeading => 'Pas encore couvert';

  @override
  String get askNotCovered =>
      'Les sources fiables de femio ne répondent pas à cela, donc femio ne devine pas. Essayez d’autres mots, lisez les liens ci-dessous ou demandez à votre médecin.';

  @override
  String askRegistryVersion(String version) {
    return 'Bibliothèque de sources fiables $version';
  }

  @override
  String get askAnswerOnPhone =>
      'Résumé sur votre téléphone par Gemini Nano, à partir des sources ci-dessous';

  @override
  String get askAnswerCloud =>
      'Résumé par l’IA cloud de Google (Cloud boost), à partir des sources ci-dessous';

  @override
  String get askVerbatimLabel => 'Mot pour mot, depuis des sources fiables';

  @override
  String get askEnglishNote =>
      'Ces sources sont en anglais. femio les montre mot pour mot pour que rien ne se perde à la traduction.';

  @override
  String get askReadMore => 'En savoir plus auprès d’organismes fiables';

  @override
  String askSourceCopied(String publisher, String date) {
    return '$publisher · copié le $date';
  }

  @override
  String askSourceReviewed(String publisher, String date) {
    return '$publisher · revu le $date';
  }

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
      'IA sur votre téléphone, sources fiables et Cloud boost';

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
  String get assistantCloudTitle => 'Cloud boost';

  @override
  String get assistantCloudOn =>
      'Activé. Utilisé seulement si ce téléphone n’a pas d’IA intégrée.';

  @override
  String get assistantCloudOff => 'Désactivé. Tout se fait sur ce téléphone.';

  @override
  String get assistantHowItWorks =>
      'Votre journal reste sur votre téléphone. Vos notes et votre journal sont lus par les règles de femio et, si votre téléphone l’a, par Gemini Nano sur le téléphone. Les règles de sécurité passent toujours en premier : un signe de danger ouvre la page d’aide, et femio ne conseille jamais sur la façon d’éviter une grossesse. Demander à femio répond uniquement à partir de sources de santé fiables intégrées à l’application et les montre avec chaque réponse. Cloud boost reste désactivé sauf si vous l’acceptez ; alors seul ce que son écran énumère est envoyé à Google.';

  @override
  String get assistantCloudNotBuilt =>
      'Non disponible dans cette version de l’application.';

  @override
  String get boostTitle => 'Cloud boost';

  @override
  String get boostIntro =>
      'Certains téléphones n’ont pas d’IA intégrée. Sur ces téléphones, Cloud boost permet à l’IA cloud de Google de résumer des sources fiables pour une question que vous approuvez, ou d’ordonner vos conseils. C’est facultatif et cela reste désactivé tant que vous n’acceptez pas ci-dessous. Tout le reste de femio fonctionne sans.';

  @override
  String get boostSendsHeading => 'Ce qui peut être envoyé';

  @override
  String get boostStageLabel => 'Étape de vie';

  @override
  String boostStage(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'period': 'Suivi des règles',
      'ttc': 'Essai de conception',
      'pregnant': 'Enceinte',
      'postpartum': 'Après l’accouchement',
      'menopause': 'Ménopause',
      'other': 'Non défini',
    });
    return '$_temp0';
  }

  @override
  String get boostRegularityLabel => 'Régularité du cycle';

  @override
  String boostRegularity(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'regular': 'Régulier',
      'variable': 'Variable',
      'unknown': 'Pas encore connu',
      'notApplicable': 'Non suivi pour l’instant',
      'other': 'Pas encore connu',
    });
    return '$_temp0';
  }

  @override
  String get boostCategoriesLabel => 'Types de symptômes notés le mois dernier';

  @override
  String boostCategory(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'pain': 'Douleur',
      'mood': 'Humeur',
      'digestion': 'Digestion',
      'sleepAndEnergy': 'Sommeil et énergie',
      'skinAndHair': 'Peau et cheveux',
      'hotFlashes': 'Bouffées de chaleur',
      'bladder': 'Vessie',
      'other': 'Autre',
    });
    return '$_temp0';
  }

  @override
  String get boostNone => 'Aucun';

  @override
  String get boostStreakLabel => 'Suivi continu';

  @override
  String boostStreak(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'none': 'Aucun',
      'underAWeek': 'Moins d’une semaine',
      'weeks': 'Quelques semaines',
      'overAMonth': 'Plus d’un mois',
      'other': 'Aucun',
    });
    return '$_temp0';
  }

  @override
  String get boostNeverHeading => 'Ce qui n’est jamais envoyé';

  @override
  String get boostNever =>
      'Vos notes, dates, entrées du journal, durées de cycle, votre nom, votre e-mail, vos contacts ou votre identifiant publicitaire.';

  @override
  String get boostTurnOff => 'Désactiver Cloud boost';

  @override
  String get boostNotNow => 'Pas maintenant';

  @override
  String get boostAgreeQuestions =>
      'J’accepte que femio envoie une question générale que j’approuve, une à la fois, avec les sources publiques trouvées, pour que l’IA cloud de Google les résume. femio retire d’abord les nombres, les dates, les noms et les coordonnées, et je vois le texte exact avant son envoi.';

  @override
  String get boostAgreeTips =>
      'J’accepte que femio envoie ces quatre informations générales sur ma santé, exactement comme affichées, pour que l’IA cloud de Google ordonne mes conseils. Cela se fait en arrière-plan tant que Cloud boost est activé.';

  @override
  String get boostPurposeQuestions => 'Questions générales';

  @override
  String get boostPurposeTips =>
      'Conseils à partir de quatre informations générales';

  @override
  String get boostWhoHeading => 'Qui les reçoit, et où';

  @override
  String get boostWho =>
      'Google les traite pour femio via Firebase AI Logic (la Gemini Developer API, offre payante). Google peut les traiter aux États-Unis ou dans d’autres pays où il a des serveurs, selon ses conditions de traitement des données. femio (KM Digital Labs, Le Caire, Égypte) décide de ce qui est envoyé et en est responsable.';

  @override
  String get boostKeptHeading => 'Durée de conservation';

  @override
  String get boostKept =>
      'femio n’a pas de serveur et n’en garde rien. Selon les conditions payantes utilisées par femio, Google ne s’en sert pas pour améliorer ses produits. Google les conserve jusqu’à 55 jours pour détecter les abus, et des personnes chez Google peuvent examiner un contenu que ses systèmes signalent comme abusif.';

  @override
  String get boostAlsoSeen =>
      'Comme pour toute connexion à Internet, Google voit aussi l’adresse Internet de votre téléphone, et une vérification de Google Play confirmant que la demande vient de la vraie application femio.';

  @override
  String get boostChoiceHeading => 'Votre choix';

  @override
  String get boostChoice =>
      'Accepter est facultatif, et vous pouvez accepter un usage sans l’autre. Vous pouvez désactiver Cloud boost à tout moment, ici ou dans Réglages › Assistant, aussi facilement que vous l’avez activé. Chaque téléphone redemande : une sauvegarde restaurée ne transporte pas votre accord.';

  @override
  String get boostReadNotice => 'Lire l’avis de confidentialité';

  @override
  String get boostExplicit =>
      'Ces informations et questions concernent votre santé. En cochant une case et en appuyant sur J’accepte, vous donnez votre consentement explicite à cet usage seulement. femio garde sur ce téléphone une trace datée de votre choix, que vous pouvez voir ici.';

  @override
  String get boostAgree => 'J’accepte';

  @override
  String get boostReceiptHeading => 'Votre accord';

  @override
  String boostReceipt(String date, String purposes) {
    return 'Vous avez accepté le $date : $purposes.';
  }

  @override
  String get boostWithdrawEffect =>
      'La désactiver arrête tout nouvel envoi. Cela ne peut pas rappeler ce qui a déjà été envoyé.';

  @override
  String get tip_trackDatesHelps =>
      'Noter les dates de vos règles dans l\'application vous aide à voir votre propre rythme et donne des repères clairs à un professionnel de santé.';

  @override
  String get tip_periodLongerThanSeven =>
      'Des règles qui durent plus de 7 jours méritent d\'être signalées à un professionnel de santé.';

  @override
  String get tip_bleedingBetweenPeriods =>
      'Les saignements entre les règles méritent d\'être signalés à un professionnel de santé, afin d\'en chercher la cause.';

  @override
  String get tip_irregularCheckIn =>
      'Les cycles de moins de 21 jours ou de plus de 35 jours sont dits irréguliers. Parlez-en à un professionnel de santé, qui pourra examiner vos dates avec vous.';

  @override
  String get tip_stoppedThreeMonths =>
      'Des règles qui s\'arrêtent plus de trois mois sans raison claire méritent l\'avis d\'un professionnel de santé, quel que soit votre âge.';

  @override
  String get tip_irregularWithOtherSigns =>
      'Des règles irrégulières associées à d\'autres changements, comme l\'acné ou une pilosité accrue, méritent d\'être signalées à un professionnel de santé.';

  @override
  String get tip_periodPainSeeClinician =>
      'Des douleurs de règles qui vous empêchent de faire vos activités habituelles sont une raison de consulter un professionnel de santé.';

  @override
  String get tip_severePainUrgent =>
      'Si la douleur pelvienne ou des règles est forte ou pire que d\'habitude et que les antalgiques n\'ont pas aidé, demandez un avis médical urgent.';

  @override
  String get tip_symptomDiaryBeforeVisit =>
      'Avant une consultation pour des problèmes de règles, un journal de vos symptômes sur tout le cycle donne à un professionnel de santé une image détaillée de ce qui se passe et quand.';

  @override
  String get tip_heavyOrTired =>
      'Des règles qui vous empêchent de mener vos activités, ou vous laissent souvent fatiguée ou essoufflée, peuvent être le signe de règles abondantes. Un professionnel de santé peut vous aider.';

  @override
  String get tip_pmsDiary =>
      'Tenir un journal de vos symptômes pendant au moins deux cycles aide un professionnel de santé à voir s\'ils suivent vos règles.';

  @override
  String get tip_headachesAroundPeriod =>
      'Les maux de tête qui reviennent avant ou pendant vos règles méritent d\'être signalés à un professionnel de santé. Un journal des maux de tête à côté de vos dates de règles aide.';

  @override
  String get tip_urineInfectionSeeClinician =>
      'Si vous pensez avoir une infection urinaire, il est important de consulter un professionnel de santé. Un test d\'urine peut le confirmer.';

  @override
  String get tip_leakingUrineTellClinician =>
      'Si vous avez des fuites urinaires, il vaut la peine d\'en parler à un professionnel de santé, quel qu\'en soit le type ou la cause.';

  @override
  String get tip_cervicalScreeningTip =>
      'Le dépistage du col de l’utérus recherche des changements précoces dans les cellules du col. Demandez à votre cabinet si c’est le moment pour vous.';

  @override
  String get tip_ttcOneYear =>
      'Si cela fait un an que vous essayez sans grossesse, il est conseillé de consulter un professionnel de santé pour vérifier les causes fréquentes.';

  @override
  String get tip_ttcAgeSixMonths =>
      'À partir de 35 ans, il est conseillé de consulter un professionnel de santé après six mois d\'essais, et non douze.';

  @override
  String get tip_ttcIrregularNoWait =>
      'Avec des règles irrégulières ou absentes, il vaut la peine d\'en parler à un professionnel de santé sans attendre une année entière.';

  @override
  String get tip_regularSexTakesTime =>
      'La plupart des couples dont la femme a moins de 40 ans conçoivent en moins d\'un an avec des rapports réguliers tous les 2 à 3 jours. Cela peut prendre du temps.';

  @override
  String get tip_testingTooEarly =>
      'Un test très précoce peut donner un faux négatif, car l\'hormone de grossesse peut ne pas encore être assez présente. Suivez les instructions du test.';

  @override
  String get tip_folicAcidBeforePregnancy =>
      'L\'acide folique, une vitamine B, est recommandé au moins un mois avant la grossesse. Demandez à un professionnel de santé comment en avoir assez.';

  @override
  String get tip_talkBeforeTrying =>
      'Il est conseillé d\'en parler à un professionnel de santé avant d\'essayer de concevoir. Il peut vous aider à préparer votre corps.';

  @override
  String get tip_tryingIsStressful =>
      'Essayer de concevoir peut être source de stress. Un accompagnement psychologique et des groupes de soutien peuvent aider ; demandez à un professionnel de santé.';

  @override
  String get tip_movementsChangeCallNow =>
      'Si votre bébé bouge moins que d\'habitude ou si son rythme habituel change, appelez tout de suite votre sage-femme ou la maternité, même au milieu de la nuit.';

  @override
  String get tip_firstMovementsBy24 =>
      'Vous devriez commencer à sentir bouger votre bébé entre 16 et 24 semaines. Si vous n\'avez rien senti à 24 semaines, prévenez votre sage-femme.';

  @override
  String get tip_preeclampsiaSigns =>
      'Un mal de tête sévère que les antalgiques ne soulagent pas, des troubles de la vue, une douleur sous les côtes ou un gonflement soudain doivent être vérifiés tout de suite. Appelez la maternité.';

  @override
  String get tip_antenatalChecksMatter =>
      'Les contrôles de tension et d\'urine lors des visites prénatales repèrent des changements que vous ne sentez pas : essayez de ne manquer aucun rendez-vous.';

  @override
  String get tip_screeningVersusDiagnostic =>
      'Deux types de tests sont proposés à toutes les femmes enceintes : des tests de dépistage, qui donnent une probabilité, et des tests de suivi, qui donnent une réponse plus nette. Demandez lesquels vous conviennent.';

  @override
  String get tip_glucoseScreening =>
      'Toutes les femmes enceintes devraient être dépistées pour le diabète gestationnel. Demandez à votre sage-femme ou médecin quand le vôtre est prévu.';

  @override
  String get tip_rhBloodGroup =>
      'Une simple prise de sang indique votre groupe sanguin et votre statut Rhésus, en général à la première visite prénatale. Demandez le vôtre et s\'il compte pour vos soins.';

  @override
  String get tip_mainScanBetween18And21 =>
      'Une échographie détaillée est généralement faite entre 18 et 21 semaines. Elle vérifie la croissance du bébé et recherche certaines anomalies.';

  @override
  String get tip_severeSicknessTellEarly =>
      'Si vous vomissez souvent et ne gardez pas la nourriture, prévenez votre sage-femme ou votre médecin dès que possible, pour qu’ils vous aident à garder les liquides.';

  @override
  String get tip_itchTellMidwife =>
      'Les démangeaisons sont fréquentes pendant la grossesse et rarement graves. Signalez-les quand même à votre sage-femme ou médecin pour les faire vérifier.';

  @override
  String get tip_pretermLabourSigns =>
      'Les signes d\'un travail prématuré comprennent des contractions toutes les 10 minutes ou plus rapprochées, une perte de liquide ou des saignements, une pression pelvienne et un mal de dos bas et sourd. Contactez votre soignant.';

  @override
  String get tip_tirednessInPregnancy =>
      'La fatigue pendant la grossesse a de nombreuses causes, dont l’anémie. Signalez une fatigue persistante à votre sage-femme ou à votre médecin.';

  @override
  String get tip_lowMoodPerinatal =>
      'Se sentir déprimée est fréquent pendant la grossesse et après la naissance, et du soutien existe. Parlez-en à votre sage-femme, médecin ou puéricultrice, même si vous n\'avez que quelques signes.';

  @override
  String get tip_anxietyInPregnancy =>
      'L\'anxiété pendant la grossesse peut souvent être soulagée par une thérapie par la parole. Dites à votre sage-femme ou médecin ce que vous ressentez vraiment.';

  @override
  String get tip_warningSignsPregnancyAndYear =>
      'Certains signes d\'alerte exigent des soins immédiats, pendant la grossesse et un an après la naissance : mal de tête persistant, troubles de la vue, fièvre, difficulté à respirer ou douleur abdominale sévère.';

  @override
  String get tip_postnatalCheckSixToEight =>
      'Un bilan postnatal environ 6 à 8 semaines après la naissance vérifie que vous allez bien et récupérez bien. Notez vos questions pour les emporter.';

  @override
  String get tip_painfulFeedsGetHelp =>
      'Si vous repoussez les tétées parce que l\'allaitement fait mal, demandez l\'aide d\'une consultante en lactation.';

  @override
  String get tip_tirednessAfterBirthThyroid =>
      'La fatigue après la naissance a de nombreuses causes. L\'inflammation de la thyroïde touche environ 1 femme sur 20 la première année ; signalez une fatigue persistante à un professionnel de santé.';

  @override
  String get tip_bleedingUpToSixWeeks =>
      'Des pertes ou des saignements comme des règles, par intermittence, peuvent durer jusqu\'à six semaines après la naissance. Parlez-en à un professionnel de santé si vous êtes inquiète.';

  @override
  String get tip_babyBluesPassing =>
      'Se sentir abattue, anxieuse ou irritable quelques jours après la naissance est très fréquent et passe en général en 2 semaines. Si cela dure plus longtemps, parlez-en à un professionnel de santé.';

  @override
  String get tip_periodChangesFirstSign =>
      'Un changement des règles est en général l\'un des premiers signes de la périménopause. Elles peuvent venir plus ou moins souvent, être plus abondantes ou plus légères.';

  @override
  String get tip_twelveMonthsMeansMenopause =>
      'La ménopause correspond à 12 mois sans règles. Dans les années qui précèdent, les cycles varient souvent, avec des intervalles plus longs ou plus courts.';

  @override
  String get tip_bleedingAfterMenopause =>
      'Un saignement après la ménopause, c\'est-à-dire après 12 mois sans règles, est important à signaler à un professionnel de santé afin d\'en trouver la cause.';

  @override
  String get tip_hotFlushesTalkOptions =>
      'Si les changements de mode de vie ne suffisent pas pour les bouffées de chaleur, contactez un professionnel de santé. Il discutera de vos symptômes, de vos antécédents et de vos préférences.';

  @override
  String get tip_boneStrengthMenopause =>
      'La perte de densité osseuse est plus probable autour de la ménopause. Interrogez un professionnel de santé sur la santé des os et ce qui vous convient.';

  @override
  String get tip_drynessManyTreatments =>
      'Il existe de nombreux traitements contre la sécheresse vaginale. Il vaut la peine de demander à un professionnel de santé ce qui peut vous convenir.';

  @override
  String get tip_heartbeatAroundMenopause =>
      'Un cœur qui bat plus vite ou plus fort peut faire partie de la périménopause et de la ménopause. Notez quand cela arrive et parlez-en à un professionnel de santé.';

  @override
  String get tip_lowMoodMenopause =>
      'La baisse de moral et l\'anxiété peuvent faire partie de la transition vers la ménopause. Si elles sont difficiles à gérer, parlez-en à un professionnel de santé.';

  @override
  String get visitQ_periodsStoppedChecks =>
      'Mes règles sont devenues très espacées ou se sont arrêtées. Quels examens pourraient en trouver la raison ?';

  @override
  String get visitQ_irregularCauses =>
      'Qu\'est-ce qui pourrait expliquer mes cycles irréguliers, et des examens ou une échographie seraient-ils utiles ?';

  @override
  String get visitQ_irregularAcneChecks =>
      'J\'ai des règles irrégulières et de l\'acné. Quels examens pourraient en chercher la cause ?';

  @override
  String get visitQ_painCauseChecks =>
      'Mes douleurs de règles perturbent sans cesse mes journées. Quels examens pourraient en trouver la raison ?';

  @override
  String get visitQ_heavyAndTiredBloodTest =>
      'Mes règles sont peut-être abondantes et je suis souvent fatiguée. Dois-je faire des analyses de sang, par exemple pour le fer ?';

  @override
  String get visitQ_diaryReviewCycle =>
      'Pouvons-nous parcourir mon journal de symptômes pour voir s\'ils suivent mon cycle ?';

  @override
  String get visitQ_headacheDiaryReview =>
      'Mes maux de tête reviennent souvent autour de mes règles. Pouvons-nous regarder mon journal ensemble ?';

  @override
  String get visitQ_cervicalScreeningDue =>
      'Suis-je à jour pour le dépistage du col de l\'utérus, et quel test utilise votre clinique ?';

  @override
  String get visitQ_checksForCouple =>
      'Quels examens de fertilité me conseillez-vous, et pour un partenaire si j\'en ai un ?';

  @override
  String get visitQ_ttcOverThirtyFiveSooner =>
      'J\'ai 35 ans ou plus et nous essayons depuis environ six mois ou plus. Devons-nous commencer les examens de fertilité maintenant ?';

  @override
  String get visitQ_irregularTryingNow =>
      'Mes cycles sont irréguliers et nous essayons de concevoir. Devrions-nous parler d\'aide dès maintenant plutôt que d\'attendre un an ?';

  @override
  String get visitQ_preconceptionReview =>
      'Nous prévoyons une grossesse. Y a-t-il quelque chose à revoir d\'abord dans ma santé ou mes médicaments ?';

  @override
  String get visitQ_ttcSupportOptions =>
      'Essayer de concevoir me pèse. Où puis-je trouver un accompagnement psychologique ou du soutien ?';

  @override
  String get visitQ_pregnancyTestsOffered =>
      'Quels tests de dépistage et de suivi me sont proposés pendant ma grossesse, et que m’apprend chacun ?';

  @override
  String get visitQ_glucoseTestWhen =>
      'Quand serai-je testée pour le diabète gestationnel, et cela pourrait-il être plus tôt pour moi ?';

  @override
  String get visitQ_movementsCallWho =>
      'Qui dois-je appeler si les mouvements de mon bébé changent, y compris la nuit ?';

  @override
  String get visitQ_sameDayWarningSigns =>
      'Quels signes doivent me faire appeler la maternité le jour même ?';

  @override
  String get visitQ_rhFactorChecked =>
      'Mon groupe sanguin et mon facteur Rhésus ont-ils été vérifiés, et cela change-t-il quelque chose à mes soins ?';

  @override
  String get visitQ_pregnancyLowMoodSupport =>
      'Je me sens déprimée ou très inquiète depuis un moment. Quel soutien existe ?';

  @override
  String get visitQ_severeSicknessHelp =>
      'Mes nausées et vomissements m\'empêchent de garder aliments et boissons. Quelle aide existe ?';

  @override
  String get visitQ_itchBloodTests =>
      'J\'ai des démangeaisons pendant ma grossesse. Dois-je faire des analyses de sang pour vérifier mon foie ?';

  @override
  String get visitQ_pretermSignsPlan =>
      'Quels signes de travail prématuré doivent me faire appeler ou venir, et où aller en dehors des heures d\'ouverture ?';

  @override
  String get visitQ_postnatalCheckTalk =>
      'Pouvons-nous faire le point sur ma récupération, y compris saignements, douleurs, moral et changements de vessie ?';

  @override
  String get visitQ_postnatalMoodHelp =>
      'Je me sens déprimée ou anxieuse depuis la naissance. Quelle aide existe ?';

  @override
  String get visitQ_latchCheck =>
      'Les tétées font mal. Quelqu\'un pourrait-il observer une tétée et vérifier la prise du sein ?';

  @override
  String get visitQ_warningSignsYearAfter =>
      'Quels symptômes, dans l\'année suivant la naissance, doivent me faire consulter tout de suite ?';

  @override
  String get visitQ_thyroidAfterBirth =>
      'Je suis très fatiguée depuis la naissance. Ma thyroïde devrait-elle être vérifiée par une prise de sang ?';

  @override
  String get visitQ_urineLeaksHelp =>
      'J\'ai des fuites urinaires. Qu\'est-ce qui peut aider, et des exercices du plancher pelvien me conviendraient-ils ?';

  @override
  String get visitQ_hotFlushOptions =>
      'Les bouffées de chaleur ou sueurs nocturnes perturbent mes journées. De quelles options pourrions-nous parler ?';

  @override
  String get visitQ_changedBleedingChecks =>
      'Mon schéma de saignements a changé. Quels examens valent la peine d\'être faits ?';

  @override
  String get visitQ_bleedingAfterMenopauseChecks =>
      'J\'ai eu des saignements ou des pertes à ce stade. De quels examens ai-je besoin, et dans quel délai ?';

  @override
  String get visitQ_boneAndHeartHealth =>
      'Que puis-je faire pour protéger la santé de mes os et de mon cœur à ce stade ?';

  @override
  String get visitQ_drynessWhatHelps =>
      'J\'ai une sécheresse ou une gêne vaginale. Qu\'est-ce qui peut aider, et que faut-il vérifier ?';

  @override
  String get visitQ_urineTestAgain =>
      'Mes symptômes urinaires reviennent sans cesse. Dois-je faire un test d\'urine, et comment en trouver la cause ?';

  @override
  String get visitQ_thyroidCheckIrregular =>
      'Mes règles sont irrégulières et mes cheveux s\'éclaircissent. Ma thyroïde devrait-elle être vérifiée par une prise de sang ?';

  @override
  String get tipsTitle => 'Pour vous';

  @override
  String tipsSource(String publisher) {
    return 'Source : $publisher';
  }

  @override
  String get tipsChosenOnPhone =>
      'Choisis sur votre téléphone à partir de votre journal. Chaque conseil est une phrase relue, avec sa source.';

  @override
  String get tipsOrderedCloud =>
      'Mis en ordre avec Cloud boost, à partir d’informations générales seulement.';

  @override
  String get legendPossible => 'Règles possibles (confiance faible)';

  @override
  String get confidenceLowShort => 'Confiance faible';

  @override
  String get upcomingPeriodsTitle => 'Prochaines règles';

  @override
  String get upcomingPeriodsWider =>
      'Chaque période suivante a une fourchette plus large : plus c\'est loin, moins c\'est sûr.';

  @override
  String get upcomingPeriodsOnlyNext =>
      'Seules les prochaines règles sont affichées : vos cycles notés varient trop, ou sont encore trop peu nombreux, pour aller plus loin.';

  @override
  String get todayUrgentBody =>
      'Si quelque chose vous semble grave ou soudain, consultez maintenant. Les numéros d\'urgence de votre pays sont à portée d\'un geste.';

  @override
  String get toolsTitle => 'Calculateurs';

  @override
  String get toolsSub =>
      'Ces calculateurs donnent des estimations générales pour vous informer et planifier, pas un avis médical. Parlez de votre santé avec votre clinicienne.';

  @override
  String get toolDueTitle => 'Calculateur de date d\'accouchement';

  @override
  String get toolDueDesc =>
      'D\'après vos dernières règles, la conception, un transfert de FIV ou une échographie.';

  @override
  String get toolCalTitle => 'Calendrier de grossesse';

  @override
  String get toolCalDesc =>
      'Les dates de chaque semaine de grossesse, avec le guide de la semaine.';

  @override
  String get toolGainTitle => 'Prise de poids pendant la grossesse';

  @override
  String get toolGainDesc =>
      'La fourchette de référence selon votre IMC avant la grossesse.';

  @override
  String get toolDueMethodLabel => 'D\'où vient votre date ?';

  @override
  String get toolDueMethodLmp => 'Dernières règles';

  @override
  String get toolDueMethodConception => 'Conception';

  @override
  String get toolDueMethodTransfer => 'Transfert FIV';

  @override
  String get toolDueMethodScan => 'Échographie de datation';

  @override
  String get toolEmbryoLabel => 'Âge de l\'embryon au transfert';

  @override
  String get toolEmbryo3 => 'Jour 3';

  @override
  String get toolEmbryo5 => 'Jour 5';

  @override
  String get toolPromptLmp => 'Touchez le premier jour de vos dernières règles';

  @override
  String get toolPromptConception => 'Touchez le jour de la conception';

  @override
  String get toolPromptTransfer => 'Touchez le jour du transfert d\'embryon';

  @override
  String get toolPromptScan => 'Touchez le jour de votre échographie';

  @override
  String get toolCycleLabel => 'Durée du cycle';

  @override
  String toolDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '$count jour',
    );
    return '$_temp0';
  }

  @override
  String get toolScanWeeksLabel => 'Semaines sur le compte rendu';

  @override
  String get toolScanDaysLabel => 'Jours en plus sur le compte rendu';

  @override
  String toolWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semaines',
      one: '$count semaine',
    );
    return '$_temp0';
  }

  @override
  String toolTermWindow(String start, String end) {
    return 'La plupart des bébés arrivent entre le $start et le $end.';
  }

  @override
  String get toolScanNote =>
      'Le calcul reprend les semaines et les jours de votre compte rendu tels quels. Si votre soignant vous a donné une date prévue, suivez la sienne.';

  @override
  String get toolEstimateNote =>
      'Ces dates sont des estimations fondées sur la date saisie. Chaque corps est différent.';

  @override
  String get toolClinicianAdjust =>
      'Votre professionnel de santé pourra ajuster la date après une échographie.';

  @override
  String get toolCalMethodLabel => 'Quelle date connaissez-vous ?';

  @override
  String get toolCalMethodEdd => 'Date prévue';

  @override
  String get toolCalMethodLmp => 'Dernières règles';

  @override
  String get toolCalPromptEdd => 'Touchez votre date prévue';

  @override
  String get toolCalEyebrow => 'Votre grossesse, semaine par semaine';

  @override
  String toolCalTrimesterLine(String second, String third) {
    return 'Deuxième trimestre à partir du $second ; troisième trimestre à partir du $third.';
  }

  @override
  String toolCalWeek(String week) {
    return 'Semaine $week';
  }

  @override
  String get toolCalCurrent => 'Cette semaine';

  @override
  String toolCalReadGuide(String week) {
    return 'Lire le guide de la semaine $week';
  }

  @override
  String get toolGainIntro =>
      'Saisissez votre poids avant la grossesse et votre taille pour voir la fourchette de référence de prise de poids totale pendant la grossesse, selon l\'Institute of Medicine (2009). Rien n\'est enregistré.';

  @override
  String get toolGainWeight => 'Poids avant la grossesse (kg)';

  @override
  String get toolGainHeight => 'Taille (cm)';

  @override
  String get toolGainBabiesLabel => 'Combien de bébés ?';

  @override
  String get toolGainBabiesOne => 'Un';

  @override
  String get toolGainBabiesTwo => 'Des jumeaux';

  @override
  String get toolGainBabiesMore => 'Trois ou plus';

  @override
  String toolGainBmiLine(String value, String band) {
    return 'IMC avant la grossesse : $value ($band)';
  }

  @override
  String get toolBandUnderweight => 'Insuffisance pondérale';

  @override
  String get toolBandNormal => 'Plage saine';

  @override
  String get toolBandOverweight => 'Surpoids';

  @override
  String get toolBandObese => 'Obésité';

  @override
  String get toolGainEyebrow =>
      'Fourchette de référence pour la prise totale sur toute la grossesse';

  @override
  String toolGainRangeKg(String low, String high) {
    return 'De $low à $high kg';
  }

  @override
  String toolGainRangeLb(String low, String high) {
    return 'De $low à $high lb';
  }

  @override
  String toolGainOtherUnit(String range) {
    return 'Soit $range.';
  }

  @override
  String get toolGainNoRangeTwins =>
      'L\'Institute of Medicine ne donne pas de fourchette pour des jumeaux quand l\'IMC avant la grossesse est inférieur à 18,5. Votre soignant vous conseillera.';

  @override
  String get toolGainNoRangeMultiples =>
      'L\'Institute of Medicine ne donne pas de fourchette pour trois bébés ou plus. Votre soignant vous conseillera.';

  @override
  String get toolGainNote =>
      'C\'est une fourchette de référence pour votre catégorie d\'IMC avant la grossesse, pas un objectif ni un jugement. Votre soignant peut vous proposer une autre fourchette.';

  @override
  String get toolGainSource =>
      'Source : Institute of Medicine (2009), « Weight Gain During Pregnancy » ; les CDC et l\'ACOG utilisent les mêmes fourchettes.';

  @override
  String toolGainOutOfRange(
    String minW,
    String maxW,
    String minH,
    String maxH,
  ) {
    return 'Saisissez un poids de $minW à $maxW kg et une taille de $minH à $maxH cm.';
  }

  @override
  String get toolNothingSaved =>
      'Rien de ce que vous saisissez ici n\'est enregistré.';
}
