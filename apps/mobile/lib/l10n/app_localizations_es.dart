// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'femio';

  @override
  String get welcomeTitle => 'Tu ciclo, tus planes, tu embarazo.';

  @override
  String get welcomeBody =>
      'Tus registros se quedan en este teléfono. Sin cuenta, y femio nunca los ve.';

  @override
  String get welcomeTagline => 'Salud y bienestar de la mujer, con ayuda de IA';

  @override
  String get language => 'Idioma';

  @override
  String get getStarted => 'Empezar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get back => 'Atrás';

  @override
  String get notSure => 'No estoy segura';

  @override
  String get goalTitle => '¿Qué te trae a femio?';

  @override
  String get goalSub => 'Puedes cambiarlo cuando quieras.';

  @override
  String get goalPeriod => 'Seguir mi regla';

  @override
  String get goalPeriodDesc =>
      'Un rango para cuándo llega y qué es normal para ti.';

  @override
  String get goalTtc => 'Quedarme embarazada';

  @override
  String get goalTtcDesc => 'Tu ventana fértil y la ovulación probable.';

  @override
  String get goalPregnant => 'Estoy embarazada';

  @override
  String get goalPregnantDesc => 'Semana a semana, y tu fecha de parto.';

  @override
  String get goalMenopause => 'Perimenopausia y menopausia';

  @override
  String get goalMenopauseDesc => 'Ciclos que cambian y síntomas.';

  @override
  String get birthYearTitle => '¿En qué año naciste?';

  @override
  String get birthYearSub =>
      'Los ciclos cambian con la edad, así femio sabe qué esperar. También ayuda a comprobar que tienes 18 años o más. Solo el año.';

  @override
  String get under18Title => 'El seguimiento es para adultas, por ahora';

  @override
  String get under18Body =>
      'El seguimiento de femio es para mujeres de 18 años o más en esta primera versión. Todas las guías de femioapp.com están abiertas para ti, sin cuenta.';

  @override
  String get eighteenTitle => '¿Ya has cumplido 18 años?';

  @override
  String get eighteenSub =>
      'Una comprobación rápida: el seguimiento es para mujeres de 18 años o más. Aquí no se guarda nada.';

  @override
  String get yesLabel => 'Sí';

  @override
  String get noNotYetLabel => 'No, todavía no';

  @override
  String get lastPeriodTitle => '¿Cuándo empezó tu última regla?';

  @override
  String get lastPeriodSub => 'El primer día de sangrado.';

  @override
  String get dontRemember => 'No lo recuerdo';

  @override
  String get periodLengthTitle => '¿Cuántos días suele durar tu regla?';

  @override
  String get cycleLengthTitle => '¿Cuánto suele durar tu ciclo?';

  @override
  String get cycleLengthSub =>
      'Del primer día de una regla al primer día de la siguiente.';

  @override
  String get irregular => 'Mis ciclos son irregulares';

  @override
  String daysValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get tryingTitle => '¿Cuánto tiempo llevas intentándolo?';

  @override
  String get tryingJustStarted => 'Acabo de empezar';

  @override
  String get tryingUnder6 => 'Menos de 6 meses';

  @override
  String get trying6to12 => 'De 6 a 12 meses';

  @override
  String get tryingOver12 => 'Más de un año';

  @override
  String get dueMethodTitle => '¿Cómo calculamos tu fecha probable de parto?';

  @override
  String get dueMethodKnown => 'Sé mi fecha de parto';

  @override
  String get dueMethodLmp => 'Primer día de mi última regla';

  @override
  String get dueMethodConception => 'Fecha de concepción';

  @override
  String get dueMethodIvf3 => 'Transferencia de FIV (embrión de día 3)';

  @override
  String get dueMethodIvf5 => 'Transferencia de FIV (embrión de día 5)';

  @override
  String get dueMethodBorn => 'Ya tuve a mi bebé';

  @override
  String get dueDateTitle => '¿Cuál es tu fecha probable de parto?';

  @override
  String get conceptionTitle => '¿Cuándo fue la concepción?';

  @override
  String get transferTitle => '¿Cuándo fue la transferencia de embriones?';

  @override
  String get birthDateTitle => '¿Cuándo nació tu bebé?';

  @override
  String get implausibleDue =>
      'Esa fecha no parece de un embarazo en curso. Revísala, por favor.';

  @override
  String get menoLastTitle => '¿Cuándo fue tu última regla?';

  @override
  String get menoOverYear => 'Hace más de un año';

  @override
  String get predictionPeriodTitle => 'Tu próxima regla';

  @override
  String get predictionFertileTitle => 'Tu ventana fértil';

  @override
  String predictionOvulation(String date) {
    return 'Ovulación probable alrededor del $date';
  }

  @override
  String predictionNextPeriod(String range) {
    return 'Próxima regla alrededor de $range';
  }

  @override
  String rangeValue(String start, String end) {
    return '$start – $end';
  }

  @override
  String get confidenceLow =>
      'Confianza baja: mejora a medida que registras tus reglas';

  @override
  String get confidenceMedium => 'Confianza media';

  @override
  String get confidenceHigh => 'Confianza alta';

  @override
  String get basisStated => 'Según la duración del ciclo que nos indicaste';

  @override
  String get irregularNote =>
      'Tus ciclos varían, así que femio muestra un rango más amplio y nunca cuenta días de retraso.';

  @override
  String get noPredictionTitle => 'Registra tu próxima regla';

  @override
  String get noPredictionBody =>
      'Cuando empiece tu regla, regístrala y femio predecirá la siguiente.';

  @override
  String pregnancyWeek(int weeks, int days) {
    return 'Semana $weeks, día $days';
  }

  @override
  String trimesterLabel(int n) {
    return 'Trimestre $n';
  }

  @override
  String dueDateLabel(String date) {
    return 'Fecha probable de parto: alrededor del $date';
  }

  @override
  String postpartumWeeks(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks semanas desde el nacimiento',
      one: '1 semana desde el nacimiento',
      zero: 'Tu bebé tiene menos de una semana',
    );
    return '$_temp0';
  }

  @override
  String menoMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months meses desde tu última regla',
      one: '1 mes desde tu última regla',
      zero: 'Tu última regla fue hace menos de un mes',
    );
    return '$_temp0';
  }

  @override
  String get menoUnknown =>
      'Registra cualquier sangrado o síntoma y femio guarda el registro para tu profesional sanitario.';

  @override
  String get menoNoDate => 'Aún no hay fecha de tu última regla';

  @override
  String get awarenessNote =>
      'Estimaciones para informarte y planificar, no una forma de evitar el embarazo.';

  @override
  String get seeClinicianTtc =>
      'Llevar más de un año intentándolo (o seis meses si tienes 35 o más) es un buen momento para hablar con un profesional.';

  @override
  String get privacyLine => 'Guardado solo en este teléfono.';

  @override
  String get logPeriodToday => 'Mi regla empezó hoy';

  @override
  String get loggedToday => 'Registrado. Tu predicción está actualizada.';

  @override
  String get startOver => 'Empezar de nuevo';

  @override
  String get todayTitle => 'Hoy';

  @override
  String get logHappy => 'Feliz';

  @override
  String get logCalm => 'Tranquila';

  @override
  String get logAnxious => 'Ansiosa';

  @override
  String get logIrritable => 'Irritable';

  @override
  String get logSad => 'Triste';

  @override
  String get logMoodSwings => 'Cambios de humor';

  @override
  String get logLowMotivation => 'Poca motivación';

  @override
  String get logTearfulness => 'Ganas de llorar';

  @override
  String get logPanicFeelings => 'Sensación repentina de pánico';

  @override
  String get logCramps => 'Cólicos';

  @override
  String get logHeadache => 'Dolor de cabeza';

  @override
  String get logBloating => 'Hinchazón';

  @override
  String get logBreastTenderness => 'Sensibilidad en los senos';

  @override
  String get logBackache => 'Dolor de espalda';

  @override
  String get logJointPain => 'Dolor articular';

  @override
  String get logMusclePain => 'Dolores musculares';

  @override
  String get logNausea => 'Náuseas';

  @override
  String get logConstipation => 'Estreñimiento';

  @override
  String get logDiarrhea => 'Diarrea';

  @override
  String get logFatigue => 'Fatiga';

  @override
  String get logAcne => 'Acné';

  @override
  String get logHotFlashes => 'Sofocos';

  @override
  String get logNightSweats => 'Sudores nocturnos';

  @override
  String get logSpotting => 'Manchado';

  @override
  String get logHeartFlutters => 'Palpitaciones';

  @override
  String get logWeightChange => 'Cambio de peso';

  @override
  String get logCravings => 'Antojos';

  @override
  String get logInsomnia => 'Dificultad para dormir';

  @override
  String get logDizziness => 'Mareos';

  @override
  String get logBrainFog => 'Niebla mental';

  @override
  String get logLibidoUp => 'Mayor deseo sexual';

  @override
  String get logLibidoDown => 'Menor deseo sexual';

  @override
  String get logVaginalDryness => 'Sequedad vaginal';

  @override
  String get logPainDuringSex => 'Dolor en las relaciones';

  @override
  String get logBladderUrgency => 'Ganas urgentes o frecuentes de orinar';

  @override
  String get logBladderLeaks => 'Escapes de orina';

  @override
  String get logHairThinning => 'Pelo más fino';

  @override
  String get logDryItchySkin => 'Piel seca o con picor';

  @override
  String get logBrittleNails => 'Uñas quebradizas';

  @override
  String get logGumSoreness => 'Encías doloridas o que sangran';

  @override
  String get logBurningMouth => 'Ardor u hormigueo en la boca';

  @override
  String get logTingling => 'Hormigueo en manos o pies';

  @override
  String get logElectricShocks => 'Sensaciones breves de calambre';

  @override
  String get logBodyOdourChange => 'Cambio en el olor corporal';

  @override
  String get logTinnitus => 'Zumbido en los oídos';

  @override
  String get logDry => 'Seco';

  @override
  String get logSticky => 'Pegajoso';

  @override
  String get logCreamy => 'Cremoso';

  @override
  String get logWatery => 'Acuoso';

  @override
  String get logEggWhite => 'Clara de huevo';

  @override
  String get logIntercourse => 'Relación sexual';

  @override
  String get flowSpotting => 'Manchado';

  @override
  String get flowLight => 'Ligero';

  @override
  String get flowMedium => 'Medio';

  @override
  String get flowHeavy => 'Abundante';

  @override
  String get flowLabel => 'Flujo';

  @override
  String get navToday => 'Hoy';

  @override
  String get navCalendar => 'Calendario';

  @override
  String get navLog => 'Registro';

  @override
  String get calendarTitle => 'Calendario';

  @override
  String get legendPeriod => 'Regla';

  @override
  String get legendSpotting => 'Manchado';

  @override
  String get legendPredicted => 'La regla puede empezar';

  @override
  String get legendFertile => 'Ventana fértil';

  @override
  String get legendOvulation => 'Ovulación probable';

  @override
  String get legendLogged => 'Algo registrado';

  @override
  String get calendarHint =>
      'Toca un día para registrarlo. Tus días de regla aparecen rellenos, incluidos los de tu duración habitual; las reglas previstas aparecen con contorno y la ventana fértil, sombreada.';

  @override
  String get logTitle => 'Registro';

  @override
  String get sectionPeriod => 'Regla';

  @override
  String get flowNone => 'Ninguno';

  @override
  String get sectionMood => 'Estado de ánimo';

  @override
  String get sectionSymptoms => 'Síntomas';

  @override
  String get sectionDischarge => 'Flujo vaginal';

  @override
  String get sectionMore => 'Otros';

  @override
  String get previousDay => 'Día anterior';

  @override
  String get nextDay => 'Día siguiente';

  @override
  String get logSavedNote => 'Se guarda en este teléfono al tocar.';

  @override
  String get logSymptomsButton => 'Registrar cómo te sientes';

  @override
  String loggedTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cosas registradas hoy',
      one: '1 cosa registrada hoy',
      zero: 'Nada registrado hoy',
    );
    return '$_temp0';
  }

  @override
  String get sectionOvulationTest => 'Prueba de ovulación';

  @override
  String get sectionTemperature => 'Temperatura al despertar';

  @override
  String get temperatureHint => 'Tomada antes de levantarte, en °C o °F';

  @override
  String get temperatureSave => 'Guardar';

  @override
  String get temperatureClear => 'Borrar';

  @override
  String get testTimingTitle => 'Cuándo hacer la prueba';

  @override
  String testTimingBody(String date) {
    return 'Si para el $date tu regla aún no ha empezado, una prueba de embarazo casera es más fiable desde ese día.';
  }

  @override
  String get opkNegative => 'Negativo';

  @override
  String get opkLow => 'Bajo';

  @override
  String get opkHigh => 'Alto';

  @override
  String get opkPeak => 'Pico';

  @override
  String get opkPositive => 'Positivo';

  @override
  String get bbtChartHeading => 'Tus temperaturas';

  @override
  String get bbtChartNeedData =>
      'Registra tres temperaturas al despertar y tu gráfica aparecerá aquí. Menos que eso es un punto, no un patrón.';

  @override
  String get bbtChartNote =>
      'Son tus mediciones, tal cual. femio no marca ningún cambio ni señala ningún día — lo que significa una gráfica se habla contigo y tu profesional.';

  @override
  String get invalidBbt =>
      'Eso no parece una lectura de termómetro. Revisa el número e inténtalo de nuevo.';

  @override
  String get testTimingGeneral =>
      'La mayoría de las pruebas caseras funcionan desde el primer día de retraso de la regla. Hacerla antes puede dar negativo aunque estés embarazada.';

  @override
  String get testTimingUnknown =>
      'Si no sabes cuándo te toca la regla, haz la prueba al menos 21 días después de tu última relación sin protección.';

  @override
  String get testTimingSource => 'Fuente: NHS, hacer una prueba de embarazo.';

  @override
  String pregDaysToGo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Quedan $days días',
      one: 'Queda $days día',
    );
    return '$_temp0';
  }

  @override
  String pregOverdue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días después de la fecha prevista',
      one: '$days día después de la fecha prevista',
    );
    return '$_temp0';
  }

  @override
  String pregTermFrom(String date) {
    return 'A término desde el $date';
  }

  @override
  String get pregEstimateNote =>
      'Estas fechas son estimaciones basadas en la fecha prevista que introdujiste. Tu profesional sanitario puede ajustarla tras una ecografía.';

  @override
  String get pregRedFlagsHeading =>
      'Algunos síntomas necesitan atención urgente';

  @override
  String get pregRedFlagsBody =>
      'Busca atención ahora si tienes dolor de cabeza intenso, cambios en la visión, mareo o desmayo, fiebre de 38 °C o más, hinchazón de la cara o las manos, dificultad para respirar, dolor en el pecho o el corazón acelerado, náuseas y vómitos intensos, dolor en la parte alta del abdomen o dolor intenso de barriga que no se quita, sangrado vaginal o pérdida de líquido, hinchazón, enrojecimiento o dolor en una pierna o un brazo, un cansancio abrumador, pensamientos de hacerte daño o de hacerle daño a tu bebé, o si los movimientos de tu bebé han disminuido, se han detenido o han cambiado. Contacta con tu unidad de maternidad o los servicios de emergencia locales. Si no puedes contactarlos, acude al servicio de urgencias más cercano.';

  @override
  String get pregRedFlagsMore => 'Ver la lista completa y sus fuentes';

  @override
  String get redFlagsListHeading =>
      'Busca atención ahora ante cualquiera de estos síntomas';

  @override
  String get redFlagHeadache => 'Dolor de cabeza intenso';

  @override
  String get redFlagVision => 'Cambios en la visión';

  @override
  String get redFlagUpperAbdomen => 'Dolor en la parte alta del abdomen';

  @override
  String get redFlagSwelling => 'Hinchazón de la cara o las manos';

  @override
  String get redFlagBreathing => 'Dificultad para respirar';

  @override
  String get redFlagBleeding => 'Sangrado vaginal';

  @override
  String get redFlagMovements =>
      'Movimientos de tu bebé que disminuyen, se detienen o cambian';

  @override
  String get redFlagDizziness => 'Mareo o desmayo';

  @override
  String get redFlagFever => 'Fiebre de 38 °C o más';

  @override
  String get redFlagChestPain => 'Dolor en el pecho o el corazón acelerado';

  @override
  String get redFlagNausea => 'Náuseas y vómitos intensos';

  @override
  String get redFlagBellyPain => 'Dolor intenso de barriga que no se quita';

  @override
  String get redFlagFluid => 'Pérdida de líquido por la vagina';

  @override
  String get redFlagLimb =>
      'Hinchazón, enrojecimiento o dolor en una pierna o un brazo';

  @override
  String get redFlagTiredness => 'Un cansancio abrumador';

  @override
  String get redFlagHarmThoughts =>
      'Pensamientos de hacerte daño o de hacerle daño a tu bebé';

  @override
  String get contractionsHeading => 'Cronómetro de contracciones';

  @override
  String get contractionsIntro =>
      'Pulsa empezar cuando comience una y parar cuando afloje. femio guarda los tiempos para que los tengas cuando llames.';

  @override
  String get contractionsStart => 'Empezar una contracción';

  @override
  String get contractionsStop => 'Ya aflojó';

  @override
  String get contractionsRunning => 'Cronometrando';

  @override
  String get contractionsContactHeading =>
      'Llama a tu unidad de maternidad cuando lo necesites';

  @override
  String get contractionsContactBody =>
      'No hace falta llegar a ninguna cifra antes. Llama si estás preocupada, si rompes aguas, si hay sangrado o si el bebé se mueve menos de lo habitual.';

  @override
  String contractionsSummaryHeading(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tus últimas $count contracciones',
      one: 'Tu última contracción',
    );
    return '$_temp0';
  }

  @override
  String contractionsSummaryDuration(String value) {
    return 'Duran unos $value';
  }

  @override
  String contractionsSummaryInterval(String value) {
    return 'Cada $value aproximadamente, de inicio a inicio';
  }

  @override
  String get contractionsSummaryNote =>
      'Son tus tiempos, tal como se registraron. femio no decide qué significan — léeselos a tu matrona o a la maternidad, que sí pueden.';

  @override
  String get movementsHeading => 'Registro de movimientos';

  @override
  String get movementsIntro =>
      'No existe un número normal de movimientos. Lo que importa es un cambio respecto al patrón habitual de tu bebé: por eso esto registra lo que sientes y te muestra tu propio patrón con el tiempo.';

  @override
  String get movementsUrgentHeading =>
      'Si los movimientos son menos de lo habitual';

  @override
  String get movementsUrgentBody =>
      'Contacta ahora con tu equipo de maternidad. No esperes a terminar esta sesión ni esperes a mañana.';

  @override
  String get movementsStart => 'Iniciar una sesión';

  @override
  String get movementsStartBody =>
      'Ponte cómoda y empieza. Toca cada vez que sientas un movimiento.';

  @override
  String get movementsTap => 'Sentí un movimiento';

  @override
  String movementsCounted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movimientos registrados',
      one: '$count movimiento registrado',
    );
    return '$_temp0';
  }

  @override
  String get movementsFinish => 'Terminar y guardar';

  @override
  String get movementsFinishNote =>
      'Puedes parar cuando quieras. La sesión se guarda igualmente.';

  @override
  String get movementsRecentHeading => 'Tus sesiones recientes';

  @override
  String movementsSessionSummary(int count, String minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count movimientos',
      one: '$count movimiento',
    );
    return '$_temp0 · unos $minutes min de diferencia';
  }

  @override
  String get movementsUnfinished => 'Sin terminar';

  @override
  String get movementsSlowerHeading =>
      'Los movimientos estuvieron más separados de lo habitual para ti';

  @override
  String get movementsSlowerBody =>
      'Es un cambio respecto a tus sesiones recientes. Lo que significa lo dice tu equipo de maternidad: contacta con ellos para que lo revisen.';

  @override
  String movementsNeedMore(String count) {
    return 'Después de $count sesiones podrás comparar con tu propio patrón.';
  }

  @override
  String get pregnancyToolsTitle => 'Herramientas de embarazo';

  @override
  String get contractionsClear => 'Borrar estos tiempos';

  @override
  String get contractionsCleared => 'Tiempos borrados';

  @override
  String get contractionLength => 'Duración';

  @override
  String get contractionApart => 'Intervalo';

  @override
  String get apptTitle => 'Citas';

  @override
  String get apptAdd => 'Añadir una cita';

  @override
  String get apptCancel => 'Cancelar';

  @override
  String get apptSave => 'Guardar la cita';

  @override
  String get apptUntitled => 'Cita';

  @override
  String get apptNoDate => 'Sin fecha todavía';

  @override
  String get apptToday => 'Hoy';

  @override
  String apptInDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'En $days días',
      one: 'Mañana',
    );
    return '$_temp0';
  }

  @override
  String get apptPrepHeading => 'Lo que querías preguntar';

  @override
  String get apptUpcoming => 'Próximas';

  @override
  String get apptPast => 'Pasadas';

  @override
  String get apptNoResultsNote =>
      'femio guarda cuándo es, con quién y qué querías preguntar. No guarda lo que se encontró — eso pertenece a tu historia clínica y a tu profesional.';

  @override
  String get apptEmptyHeading => 'Aquí no hay nada aún';

  @override
  String get apptEmptyBody =>
      'Añade una cita y femio guardará las preguntas que querías hacer, que es la parte que se olvida al entrar en la consulta.';

  @override
  String get apptAwaitingHeading => '¿Sigues sin noticias?';

  @override
  String apptAwaitingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Esperabas un resultado en $count de ellas.',
      one: 'Esperabas un resultado en una de ellas.',
    );
    return '$_temp0 Quizá merezca la pena preguntar — los resultados se retrasan por muchos motivos corrientes.';
  }

  @override
  String get apptFormType => 'Tipo de cita';

  @override
  String get apptFormTypePlaceholder => 'Ecografía, análisis, revisión…';

  @override
  String get apptFormClinician => 'Con quién';

  @override
  String get apptFormWhen => 'Cuándo';

  @override
  String get apptFormResultsDue => 'Te dijeron que habría resultados antes del';

  @override
  String get apptFormResultsDueHint =>
      'Opcional. femio te recordará que preguntes si pasa la fecha; nunca registra cuál fue el resultado.';

  @override
  String get apptFormPrep => 'Preguntas que quieres hacer';

  @override
  String get apptFormPrepPlaceholder => 'Una por línea';

  @override
  String apptPrepCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count preguntas guardadas',
      one: '$count pregunta guardada',
    );
    return '$_temp0';
  }

  @override
  String get weightHeading => 'Peso';

  @override
  String get weightIntro =>
      'Añade una medición cuando quieras. femio las dibuja y guarda las cifras para tu historial.';

  @override
  String get weightValue => 'Peso';

  @override
  String get weightSave => 'Guardar';

  @override
  String get weightInvalid =>
      'Eso no parece una lectura de báscula. Revisa el número e inténtalo de nuevo.';

  @override
  String get weightNeedData =>
      'Añade una segunda medición y tu gráfica aparecerá aquí.';

  @override
  String weightChange(String value, String unit) {
    return '$value $unit desde tu primera anotación';
  }

  @override
  String get weightNote =>
      'Tus mediciones, tal cual. femio no muestra un rango objetivo ni dice si un cambio es esperable — lo que significa un patrón es cosa tuya y de tu matrona o médico.';

  @override
  String get weightDate => 'Medido el';

  @override
  String get weightUnitKg => 'kg';

  @override
  String get weightUnitLb => 'lb';

  @override
  String get apptDelete => 'Eliminar';

  @override
  String get apptEdit => 'Editar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsDates => 'Fechas';

  @override
  String get settingsHijri => 'Mostrar fechas hégira';

  @override
  String get settingsHijriNote =>
      'Junto a cada fecha gregoriana. Calendario Umm al-Qura; puede diferir un día de los anuncios locales.';

  @override
  String get settingsPrivacy => 'Privacidad';

  @override
  String get settingsLock => 'Bloqueo de la app';

  @override
  String get settingsLockNote =>
      'Pedir un PIN al abrir femio y tras un minuto fuera.';

  @override
  String get setPin => 'Elige un PIN de 4 a 8 dígitos';

  @override
  String get changePin => 'Cambiar el PIN';

  @override
  String get enterPin => 'PIN';

  @override
  String get enterPinAgain => 'Introduce el PIN otra vez';

  @override
  String get enterCurrentPin => 'Introduce tu PIN actual';

  @override
  String get pinMismatch => 'Los dos PIN no coinciden. Inténtalo de nuevo.';

  @override
  String get wrongPin => 'Ese PIN no es correcto.';

  @override
  String pinWaitSeconds(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Demasiados intentos. Vuelve a intentarlo en $count segundos.',
      one: 'Demasiados intentos. Vuelve a intentarlo en $count segundo.',
    );
    return '$_temp0';
  }

  @override
  String pinWaitMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Demasiados intentos. Vuelve a intentarlo en $count minutos.',
      one: 'Demasiados intentos. Vuelve a intentarlo en $count minuto.',
    );
    return '$_temp0';
  }

  @override
  String get lockTitle => 'Bienvenida de nuevo';

  @override
  String get lockHint => 'Introduce tu PIN para abrir tus registros.';

  @override
  String get forgotPin =>
      '¿Olvidaste el PIN? No se puede recuperar: femio no tiene cuenta. Borra todo de este teléfono y empieza de nuevo, o restaura un archivo de copia de seguridad.';

  @override
  String get backupSection => 'Copia de seguridad';

  @override
  String get exportBackup => 'Guardar un archivo de copia de seguridad';

  @override
  String get importBackup => 'Restaurar desde un archivo de copia de seguridad';

  @override
  String get backupPassphrase => 'Frase de contraseña';

  @override
  String get backupPassphraseAgain => 'Frase de contraseña otra vez';

  @override
  String get backupPassphraseHint =>
      'Elige una frase que recuerdes. El archivo solo se abre con ella, y nadie puede restablecerla.';

  @override
  String backupPassphraseShort(int count) {
    return 'Usa al menos $count caracteres.';
  }

  @override
  String get backupPassphraseMismatch => 'Las dos frases no coinciden.';

  @override
  String get backupWorking =>
      'Preparando el archivo de copia de seguridad. Puede tardar unos segundos.';

  @override
  String get backupSaved => 'Copia de seguridad guardada.';

  @override
  String get backupImported => 'Tus registros se han restaurado.';

  @override
  String get backupWrongPassphrase => 'Esa frase no abre este archivo.';

  @override
  String get backupNotFemio =>
      'Eso no es un archivo de copia de seguridad de femio.';

  @override
  String get backupUnreadable =>
      'Esta copia la hizo un femio más reciente y no se puede leer aquí. Actualiza la app e inténtalo de nuevo.';

  @override
  String get backupHonesty =>
      'Tus registros están solo en este teléfono. Si lo pierdes o lo restableces, desaparecen, salvo que hayas guardado un archivo de copia de seguridad. No podemos recuperarlos por ti.';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get wellnessDisclaimer =>
      'femio es una herramienta de bienestar e información para seguir tu propia salud. No es un producto sanitario y no sustituye a tu profesional de salud.';

  @override
  String get predictionNote =>
      'Las predicciones son estimaciones, no garantías, y no deben usarse para evitar un embarazo.';

  @override
  String get firstRunStorageNotice =>
      'Tus registros se quedan en este teléfono. femio no tiene cuenta ni servidor, y no puede ver lo que introduces. Su IA funciona en este teléfono; la nube solo se usa si activas Cloud boost.';

  @override
  String get firstRunStorageTitle => 'Privada por diseño';

  @override
  String get dismiss => 'Entendido';

  @override
  String get deleteEverything => 'Borrar todo de este teléfono';

  @override
  String get deleteConfirmTitle => '¿Borrar todo de este teléfono?';

  @override
  String get deleteConfirmBody =>
      'Esto elimina todos tus registros y ajustes de femio en este teléfono. No se puede deshacer y no podemos restaurarlo. Los archivos de copia de seguridad guardados en otro sitio no se borran.';

  @override
  String get deleteConfirmAction => 'Borrar todo';

  @override
  String get deleteConfirmCancel => 'Conservar mis registros';

  @override
  String get corruptTitle => 'No se pudieron abrir tus registros';

  @override
  String get corruptBody =>
      'El archivo de este teléfono está dañado o lo escribió otro femio. Se ha apartado, no borrado. Restaura un archivo de copia de seguridad si lo tienes, o empieza de nuevo.';

  @override
  String get settingsReminders => 'Recordatorios';

  @override
  String get reminderLog => 'Recordatorio de registro';

  @override
  String get reminderLogNote =>
      'Un aviso diario a la hora que elijas. Se salta un día en el que ya registraste.';

  @override
  String get reminderLogTime => 'Hora del recordatorio';

  @override
  String get reminderPeriod => 'Regla esperada';

  @override
  String get reminderPeriodNote =>
      'Un aviso el día antes de que se abra tu ventana estimada. Solo si tus ciclos son lo bastante regulares para estimar.';

  @override
  String get remindersPrivacyNote =>
      'Un recordatorio solo dice «femio: Abre la app», salvo que escribas tus propias palabras para un recordatorio de medicamento. Nada más sobre tu salud aparece en la pantalla de bloqueo.';

  @override
  String get remindersTimingNote =>
      'Un recordatorio puede llegar con unos minutos de retraso, y algunos teléfonos lo retienen para ahorrar batería.';

  @override
  String get reminderPermissionDenied =>
      'Las notificaciones están desactivadas para femio. Puedes permitirlas en los ajustes de tu teléfono.';

  @override
  String get reminderTitle => 'femio';

  @override
  String get reminderBody => 'Abre la app';

  @override
  String get reminderChannelName => 'Recordatorios';

  @override
  String get reminderChannelDescription =>
      'Recordatorios que activaste en femio. Solo dicen «Abre la app», salvo que escribieras tus propias palabras para un recordatorio de medicamento.';

  @override
  String get reminderAppointment => 'Recordatorio de cita';

  @override
  String get reminderAppointmentNote =>
      'Una notificación el día antes de una cita que guardaste con fecha.';

  @override
  String get notifConsentTitle => 'Notificaciones, solo si tú quieres';

  @override
  String get notifConsentIntro =>
      'femio puede enviarte avisos en este teléfono. Elige lo que quieres recibir. No se activa nada hasta que lo permitas.';

  @override
  String get notifConsentNeutral =>
      'Cada notificación dice solo «femio» y «Abre la app», salvo que escribas tus propias palabras para un recordatorio de medicamento. Ninguna otra palabra sobre tu salud aparece en la pantalla de bloqueo.';

  @override
  String get notifConsentLocal =>
      'Las notificaciones se programan en tu propio teléfono. No se envía nada a ninguna parte, y femio no tiene cuenta ni servidor desde donde enviarlas.';

  @override
  String get notifKindMedicine => 'Recordatorio de medicina';

  @override
  String get notifKindDigest => 'Resumen semanal';

  @override
  String get notifComingSoon => 'Próximamente en una actualización';

  @override
  String get notifConsentAllow => 'Permitir notificaciones';

  @override
  String get notifConsentNotNow => 'Ahora no';

  @override
  String get notifConsentPickOne => 'Activa al menos un tipo para continuar.';

  @override
  String get notifConsentDeniedTitle =>
      'Las notificaciones están desactivadas en este teléfono';

  @override
  String get notifConsentDeniedBody =>
      'Tu teléfono no permitió las notificaciones, así que femio no ha programado nada. Para cambiarlo, abre los Ajustes del teléfono, luego Aplicaciones, femio, Notificaciones, y permítelas. Después vuelve a Recordatorios en los ajustes de femio.';

  @override
  String calendarDayLabel(String gregorian, String hijri) {
    return '$gregorian, $hijri';
  }

  @override
  String get navLearn => 'Aprender';

  @override
  String get learnTitle => 'Aprender';

  @override
  String get learnSub =>
      'Guías con fuentes, en palabras sencillas. Primero, la búsqueda del embarazo y el embarazo.';

  @override
  String get learnSearchHint => 'Buscar en las guías';

  @override
  String get learnNoResults => 'Ninguna guía coincide todavía.';

  @override
  String learnReviewedBy(String name) {
    return 'Revisada por $name';
  }

  @override
  String learnReviewedOn(String name, String date) {
    return 'Revisada por $name · $date';
  }

  @override
  String get learnReviewPending =>
      'Revisión editorial hecha · revisión clínica pendiente';

  @override
  String get learnEnglishOnly => 'En inglés';

  @override
  String get learnEnglishOnlyBody =>
      'Esta guía aún no está traducida; se muestra en inglés.';

  @override
  String get learnSeekCareNow => 'Busca atención ahora';

  @override
  String get learnSources => 'Fuentes';

  @override
  String get learnLinkCopied => 'Enlace copiado. Pégalo en tu navegador.';

  @override
  String get noConfidentWindowTitle =>
      'No hay una ventana fiable en este ciclo';

  @override
  String get noConfidentWindowBody =>
      'Tus ciclos varían demasiado para nombrar días fértiles a partir de una fecha. Registrar tus reglas, tus pruebas de ovulación y tu temperatura al despertar te ayuda a saber después si ovulaste.';

  @override
  String get seeClinicianIrregular =>
      'Como tus ciclos son irregulares, es razonable hablar con una profesional de salud ahora en lugar de esperar un año.';

  @override
  String get helpNowLauncher => '¿Necesitas ayuda ahora?';

  @override
  String get helpNowDialogTitle => '¿Necesitas ayuda ahora?';

  @override
  String get helpNowImmediateHeading => 'Si puedes estar en peligro';

  @override
  String get helpNowImmediateLead =>
      'Si puedes llegar a hacerte daño a ti misma o a otra persona, o estás en peligro inmediato, contacta con los servicios de emergencia disponibles donde te encuentras ahora o acude al servicio de urgencias más cercano.';

  @override
  String get helpNowStayWithSomeone =>
      'Si puedes, quédate con alguien de confianza mientras consigues ayuda.';

  @override
  String get helpNowWorriedHeading => 'Si te preocupa otra persona';

  @override
  String get helpNowWorriedBody =>
      'Si crees que la persona está en peligro inmediato, no la dejes sola siempre que sea seguro para ti quedarte. Contacta con los servicios de emergencia disponibles donde esté, con un servicio de crisis, con un profesional sanitario o con un familiar de confianza.';

  @override
  String get helpNowCountry_egypt => 'Egipto';

  @override
  String get helpNowCountry_saudi => 'Arabia Saudí';

  @override
  String get helpNowCountry_uae => 'Emiratos Árabes Unidos';

  @override
  String get helpNowCountry_qatar => 'Catar';

  @override
  String get helpNowCountry_kuwait => 'Kuwait';

  @override
  String get helpNowCountry_bahrain => 'Baréin';

  @override
  String get helpNowCountry_oman => 'Omán';

  @override
  String get helpNowCountry_jordan => 'Jordania';

  @override
  String get helpNowCountry_lebanon => 'Líbano';

  @override
  String get helpNowCountry_morocco => 'Marruecos';

  @override
  String get helpNowCountry_uk => 'Reino Unido';

  @override
  String get helpNowCountry_france => 'Francia';

  @override
  String get helpNowCountry_spain => 'España';

  @override
  String get helpNowCountry_usa => 'Estados Unidos';

  @override
  String get helpNowCountry_canada => 'Canadá';

  @override
  String get helpNowCountry_mexico => 'México';

  @override
  String get helpNowNumber_eg_ambulance =>
      'Ambulancia (Organización Egipcia de Ambulancias)';

  @override
  String get helpNowNumber_eg_mental_health =>
      'Línea de salud mental (Ministerio de Salud, secretaría de salud mental)';

  @override
  String get helpNowNumber_eg_ncw =>
      'Oficina de quejas de la mujer (Consejo Nacional de la Mujer)';

  @override
  String get helpNowNumber_sa_srca =>
      'Ambulancia (Autoridad de la Media Luna Roja Saudí)';

  @override
  String get helpNowNumber_sa_moh =>
      'Centro de llamadas del Ministerio de Salud';

  @override
  String get helpNowNumber_sa_moh_mental =>
      'Consultas psicológicas (Ministerio de Salud)';

  @override
  String get helpNowNumber_sa_hrsd =>
      'Centro de denuncias de violencia familiar (Ministerio de Recursos Humanos y Desarrollo Social)';

  @override
  String get helpNowNumber_ae_ambulance => 'Ambulancia';

  @override
  String get helpNowNumber_qa_emergency =>
      'Servicios de emergencia (ambulancia, policía, defensa civil)';

  @override
  String get helpNowNumber_qa_mental =>
      'Línea nacional de salud mental, opción 4 (Hamad Medical Corporation)';

  @override
  String get helpNowNumber_kw_emergency =>
      'Servicios de emergencia (Ministerio del Interior)';

  @override
  String get helpNowNumber_bh_emergency => 'Servicios de emergencia';

  @override
  String get helpNowNumber_om_emergency =>
      'Servicios de emergencia (Policía Real de Omán)';

  @override
  String get helpNowNumber_om_dv =>
      'Línea de violencia doméstica (listada por el Gobierno de Omán)';

  @override
  String get helpNowNumber_jo_emergency =>
      'Servicios de emergencia (Dirección de Seguridad Pública)';

  @override
  String get helpNowNumber_jo_ambulance => 'Ambulancia (Defensa Civil)';

  @override
  String get helpNowNumber_jo_family =>
      'Departamento de Protección Familiar y de Menores';

  @override
  String get helpNowNumber_lb_redcross => 'Ambulancia (Cruz Roja Libanesa)';

  @override
  String get helpNowNumber_lb_lifeline =>
      'Línea de apoyo emocional (listada por el Ministerio de Salud Pública)';

  @override
  String get helpNowNumber_ma_samu =>
      'Emergencias médicas, SAMU (Ministerio de Salud)';

  @override
  String get helpNowNumber_ma_police => 'Policía';

  @override
  String get helpNowNumber_gb_999 => 'Servicios de emergencia';

  @override
  String get helpNowNumber_gb_111 => 'NHS 111, opción de salud mental';

  @override
  String get helpNowNumber_gb_refuge =>
      'Línea nacional de violencia doméstica (Refuge)';

  @override
  String get helpNowNumber_fr_samu => 'Emergencias médicas, SAMU';

  @override
  String get helpNowNumber_fr_3114 =>
      'Número nacional de prevención del suicidio';

  @override
  String get helpNowNumber_fr_3919 =>
      'Violences Femmes Info (violencia contra las mujeres)';

  @override
  String get helpNowNumber_es_112 => 'Servicios de emergencia';

  @override
  String get helpNowNumber_es_024 =>
      'Línea de atención a la conducta suicida (Ministerio de Sanidad)';

  @override
  String get helpNowNumber_es_016 =>
      'Línea de información sobre violencia de género, 016 (Ministerio de Igualdad)';

  @override
  String get helpNowNumber_us_911 => 'Servicios de emergencia';

  @override
  String get helpNowNumber_us_988 =>
      'Suicide and Crisis Lifeline (línea de crisis)';

  @override
  String get helpNowNumber_us_ndvh =>
      'National Domestic Violence Hotline (violencia doméstica)';

  @override
  String get helpNowNumber_ca_911 => 'Servicios de emergencia';

  @override
  String get helpNowNumber_ca_988 => 'Línea de ayuda en crisis suicida';

  @override
  String get helpNowNumber_mx_911 => 'Servicios de emergencia';

  @override
  String get helpNowNumber_mx_vida =>
      'Línea de la Vida (Comisión Nacional de Salud Mental)';

  @override
  String get helpNowCountryPrompt => 'Elige un país para ver sus números';

  @override
  String get helpNowEmergency => 'Servicios de emergencia';

  @override
  String get helpNowSupport => 'Líneas de apoyo';

  @override
  String get helpNowSource => 'Fuente';

  @override
  String get helpNowCall => 'Llamar';

  @override
  String get redFlagsReadGuide => 'Lee las señales de alarma del embarazo';

  @override
  String get plusProbeTitle =>
      'femio Plus · comprobación de facturación (solo versiones de prueba)';

  @override
  String get plusProbeSubtitle =>
      'Toca para preguntar a Google Play si la facturación está disponible en este teléfono. No se compra nada.';

  @override
  String get plusProbeRunning => 'Preguntando a Google Play…';

  @override
  String get plusProbeAvailable => 'Facturación de Play disponible: sí';

  @override
  String get plusProbeUnavailable =>
      'Facturación de Play disponible: no (no hay Play Store en este dispositivo o no has iniciado sesión)';

  @override
  String get plusProbeProductFound =>
      'Producto femio_plus encontrado en Play Console';

  @override
  String get plusProbeProductMissing =>
      'Producto femio_plus aún no encontrado (normal hasta que se cree en Play Console)';

  @override
  String get assistantPrivateNote =>
      'Esto ocurre en tu teléfono. femio no envía tus palabras a ningún sitio.';

  @override
  String get assistantModelNote =>
      'Gemini Nano, la IA de tu teléfono, ayudó con esto.';

  @override
  String get sayItButton => 'Dilo con tus palabras';

  @override
  String get sayItTitle => '¿Cómo te sientes?';

  @override
  String get sayItHint =>
      'Por ejemplo: cólicos fuertes, sangrado leve y muy cansada';

  @override
  String get sayItAction => 'Convertir en registro';

  @override
  String get sayItNothing =>
      'femio no encontró nada que registrar. Prueba otras palabras o toca los síntomas de la pantalla Registro.';

  @override
  String get sayItFound =>
      'femio encontró esto. Desmarca lo que no sea correcto.';

  @override
  String get sayItAdd => 'Añadir al registro de este día';

  @override
  String get sayItAdded => 'Añadido a tu registro.';

  @override
  String get sayItDictationHint =>
      'Consejo: toca el micrófono de tu teclado para dictar en lugar de escribir.';

  @override
  String get sayItFoundDays =>
      'femio encontró estos días. Desmarca lo que no sea correcto o quita un día entero. No se guarda nada hasta que toques el botón de abajo.';

  @override
  String get sayItRemoveDay => 'Quitar este día';

  @override
  String sayItSaveCount(int entries, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      entries,
      locale: localeName,
      other: '$entries entradas',
      one: '1 entrada',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return 'Guardar $_temp0 en $_temp1';
  }

  @override
  String get sayItFuture =>
      'femio no puede registrar un día que aún no ha pasado, así que esa parte de tu nota se dejó fuera.';

  @override
  String sayItTooOld(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return 'femio registra hasta $_temp0 atrás, así que se dejaron fuera los días más antiguos de tu nota.';
  }

  @override
  String get safetyCrisisHeading => 'No tienes que pasar por esto sola';

  @override
  String get safetyCrisisBody =>
      'Si piensas en hacerte daño, busca ayuda ahora. La página de ayuda muestra las líneas de crisis de tu país.';

  @override
  String get safetyUrgentHeading => 'Esto puede necesitar atención urgente';

  @override
  String get safetyUrgentBody =>
      'El dolor en el pecho, la dificultad para respirar, un desmayo o una convulsión necesitan ayuda médica ya. Llama al número de emergencias.';

  @override
  String get safetyBirthControl =>
      'femio no es un método anticonceptivo y no aconseja sobre cómo evitar un embarazo. Un médico, farmacéutico o centro de planificación familiar puede ayudarte a elegir.';

  @override
  String get askDiagnosisHeading =>
      'Solo un profesional sanitario puede saberlo';

  @override
  String get askDiagnosisBody =>
      'femio no puede decir si tienes una enfermedad. Un médico sí puede, después de hablar contigo y, si hace falta, de una exploración o unas pruebas. Esto es lo que dicen fuentes fiables al respecto.';

  @override
  String get safetyHeavyBleedingHeading => 'Sangrado abundante con mareo';

  @override
  String get safetyHeavyBleedingBody =>
      'El ACOG (colegio estadounidense de ginecólogos y obstetras) dice: «Si cambias de compresa o tampón cada hora durante más de 2 horas seguidas, y además tienes dolor en el pecho, falta de aire y te sientes aturdida o mareada, busca atención médica de urgencia de inmediato». (Traducción de femio.) Si es tu caso, llama ahora al número de emergencias. Si un sangrado abundante te preocupa, habla con tu médico.';

  @override
  String get safetyPostpartumHeading => 'Una señal de alerta después del parto';

  @override
  String get safetyPostpartumBody =>
      'En el año después del parto, la campaña Hear Her de los CDC dice que busques atención médica de inmediato ante una señal de alerta urgente, como sangrado abundante, fiebre, un dolor de cabeza que no se quita, una pierna hinchada o pensamientos de hacerte daño o de hacerle daño a tu bebé. Llama ahora a tu médico o matrona, o al número de emergencias.';

  @override
  String get askTitle => 'Pregunta a femio';

  @override
  String get askIntro =>
      'Haz una pregunta de salud. femio responde solo con fuentes de salud fiables que lleva en tu teléfono, como los CDC, MedlinePlus y la Office on Women’s Health, y muestra de dónde viene cada frase.';

  @override
  String get askHint => 'Por ejemplo: ¿qué ayuda con los cólicos menstruales?';

  @override
  String get askAction => 'Preguntar';

  @override
  String get askWillSend =>
      'Esta es exactamente la pregunta que se enviará, con las fuentes públicas:';

  @override
  String get askSend => 'Resumir con Cloud boost';

  @override
  String get askStillPersonal =>
      'Esto todavía habla de ti. Quita palabras como «yo» o «mi» y cualquier dato personal.';

  @override
  String get askCloudPrivacy =>
      'Solo se envían esta pregunta, las fuentes públicas y el idioma de la respuesta. Nada de tu registro.';

  @override
  String get askSearching => 'Leyendo fuentes fiables…';

  @override
  String get askSourcesTitle => 'Fuentes';

  @override
  String get askClinicianLine =>
      'Esto es información general, no un consejo para ti. Para tu situación, habla con tu profesional sanitario.';

  @override
  String get reportAnswer => 'Reportar esta respuesta';

  @override
  String get reportTitle => 'Reportar esta respuesta';

  @override
  String reportBody(String email) {
    return 'Dile a femio qué estaba mal. El informe contiene esta respuesta y dónde se generó. femio no añade nada más, ni tu pregunta ni tus registros, aunque la respuesta puede repetir palabras que usaste. El menú para compartir del teléfono lo envía a $email.';
  }

  @override
  String get reportWrong => 'Errónea o desactualizada';

  @override
  String get reportUnsafe => 'Insegura o dañina';

  @override
  String get reportOffensive => 'Ofensiva';

  @override
  String get reportOther => 'Otro motivo';

  @override
  String get reportSend => 'Enviar informe';

  @override
  String get reportSubject => 'Informe sobre una respuesta de femio';

  @override
  String get reportThanks =>
      'Gracias. Tu informe ayuda a que las respuestas de femio sean más seguras.';

  @override
  String reportCopied(String email) {
    return 'Informe copiado. Pégalo en un correo a $email.';
  }

  @override
  String reportText(String reason, String origin, String answer) {
    return 'Motivo: $reason\nGenerada por: $origin\n\nRespuesta:\n$answer';
  }

  @override
  String get askRelatedGuides => 'Guías de femio sobre esto';

  @override
  String get askSearchAgain => 'Hacer otra pregunta';

  @override
  String get askAboutYouStays =>
      'Tu pregunta habla de ti, así que se queda en este teléfono. Aquí tienes las fuentes palabra por palabra.';

  @override
  String get askModelFellBack =>
      'Esta vez no hubo resumen en el teléfono ni con Cloud boost, así que aquí están los pasajes de confianza palabra por palabra.';

  @override
  String get askBoostHeading => 'Cloud boost';

  @override
  String get askBoostConfirm =>
      'Este teléfono no tiene IA integrada. Con Cloud boost, la IA en la nube de Google puede resumirte estas fuentes públicas. Revisa primero la pregunta.';

  @override
  String get askReadSourcesInstead => 'Leer las fuentes en su lugar';

  @override
  String get askNotCoveredHeading => 'Aún no cubierto';

  @override
  String get askNotCovered =>
      'Las fuentes fiables de femio no responden a esto, así que femio no adivina. Prueba con otras palabras, lee los enlaces de abajo o pregunta a tu profesional sanitario.';

  @override
  String askRegistryVersion(String version) {
    return 'Biblioteca de fuentes fiables $version';
  }

  @override
  String get askAnswerOnPhone =>
      'Resumido en tu teléfono por Gemini Nano, con las fuentes de abajo';

  @override
  String get askAnswerCloud =>
      'Resumido por la IA en la nube de Google (Cloud boost), con las fuentes de abajo';

  @override
  String get askVerbatimLabel => 'Palabra por palabra, de fuentes fiables';

  @override
  String get askEnglishNote =>
      'Estas fuentes están en inglés. femio las muestra palabra por palabra para que nada se pierda en la traducción.';

  @override
  String get askReadMore => 'Lee más de organizaciones fiables';

  @override
  String askSourceCopied(String publisher, String date) {
    return '$publisher · copiado el $date';
  }

  @override
  String askSourceReviewed(String publisher, String date) {
    return '$publisher · revisado el $date';
  }

  @override
  String get visitButton => 'Resumen para la consulta';

  @override
  String get visitTitle => 'Resumen para la consulta';

  @override
  String get visitIntro =>
      'Una página para mostrar a tu profesional sanitario, hecha con lo que registraste. Se queda en tu teléfono salvo que la compartas o la copies.';

  @override
  String visitCycles(int count, int longest, int shortest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ciclos registrados: de $shortest a $longest días',
      one: '1 ciclo registrado: $shortest días',
      zero: 'Aún no hay ningún ciclo completo registrado',
    );
    return '$_temp0';
  }

  @override
  String visitLastPeriod(String date) {
    return 'La última regla empezó el $date';
  }

  @override
  String get visitIrregular => 'Ciclos descritos como irregulares';

  @override
  String get visitTopTerms => 'Lo más registrado en los últimos 90 días';

  @override
  String visitDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get visitHeavyDays => 'Días de flujo abundante';

  @override
  String get visitOpkPositive => 'Tests de ovulación positivos';

  @override
  String get visitTemperatureDays => 'Días con temperatura al despertar';

  @override
  String get visitTryingFor => 'Buscando embarazo';

  @override
  String get visitQuestionsTitle => 'Preguntas que podrías hacer';

  @override
  String get visitCopy => 'Copiar como texto';

  @override
  String get visitCopied => 'Copiado. Pégalo en un mensaje o en tus notas.';

  @override
  String get visitQ_cycleSpread =>
      'La duración de mis ciclos varía. ¿Vale la pena revisarlo?';

  @override
  String get visitQ_ttcTests =>
      'Por el tiempo que llevo intentándolo, ¿qué pruebas sugerirías?';

  @override
  String get visitQ_ovulation => '¿Cómo puedo saber si estoy ovulando?';

  @override
  String get visitQ_folicAcid => '¿Debería tomar ácido fólico ahora?';

  @override
  String get visitQ_painfulPeriods =>
      'El dolor de la regla afecta mis días. ¿Qué puede ayudar?';

  @override
  String get visitQ_heavyPeriods =>
      'Mis reglas son abundantes. ¿Vale la pena un análisis de sangre?';

  @override
  String get visitQ_moodCycle =>
      'Mi ánimo cambia mucho alrededor de la regla. ¿Podemos hablarlo?';

  @override
  String get visitQ_skinHair =>
      'Tengo cambios en la piel o el cabello junto con ciclos irregulares. ¿Deberían revisarse juntos?';

  @override
  String get visitQ_tiredness =>
      'Me siento cansada a menudo. ¿Hay algo que valga la pena revisar?';

  @override
  String get visitQ_menopause =>
      '¿Podrían mis síntomas estar ligados a la perimenopausia, y qué opciones tengo?';

  @override
  String get visitQ_pregnancyNext =>
      '¿A qué debo estar atenta antes de nuestra próxima visita?';

  @override
  String get visitQ_pregnancyMovements =>
      '¿Cuándo debo empezar a prestar atención a los movimientos del bebé?';

  @override
  String get visitQ_anythingElse =>
      '¿Hay algo en mi registro que quieras mirar con más detalle?';

  @override
  String get assistantSettingsTitle => 'Asistente';

  @override
  String get assistantSettingsSub =>
      'IA en tu teléfono, fuentes fiables y Cloud boost';

  @override
  String get assistantOnDeviceTitle => 'IA en tu teléfono (Gemini Nano)';

  @override
  String get assistantOnDeviceAvailable =>
      'Lista. Lee tus notas en el teléfono; tus palabras no se envían.';

  @override
  String get assistantOnDeviceDownloadable =>
      'Se puede descargar en este teléfono.';

  @override
  String get assistantOnDeviceDownloading => 'Descargando…';

  @override
  String get assistantOnDeviceUnavailable =>
      'No disponible en este teléfono. femio usa en su lugar su propia lista de palabras, también en el teléfono.';

  @override
  String get assistantDownload => 'Descargar';

  @override
  String get assistantCloudTitle => 'Cloud boost';

  @override
  String get assistantCloudOn =>
      'Activado. Solo se usa si este teléfono no tiene IA integrada.';

  @override
  String get assistantCloudOff => 'Desactivado. Todo se hace en este teléfono.';

  @override
  String get assistantHowItWorks =>
      'Tu registro se queda en tu teléfono. Las reglas de femio y, si tu teléfono lo tiene, Gemini Nano en el teléfono leen tus notas y tu registro. Las reglas de seguridad van siempre primero: las señales de peligro abren la página de ayuda, y femio nunca aconseja sobre cómo evitar un embarazo. Pregúntale a femio responde solo con fuentes de salud fiables incluidas en la app y las muestra con cada respuesta. Cloud boost está desactivado salvo que lo aceptes; entonces solo se envía a Google lo que su pantalla enumera.';

  @override
  String get assistantCloudNotBuilt =>
      'No disponible en esta versión de la app.';

  @override
  String get boostTitle => 'Cloud boost';

  @override
  String get boostIntro =>
      'Algunos teléfonos no tienen IA integrada. En esos teléfonos, Cloud boost permite que la IA en la nube de Google resuma fuentes fiables para una pregunta que apruebes, u ordene tus consejos. Es opcional y sigue desactivado salvo que aceptes abajo. Todo lo demás de femio funciona sin él.';

  @override
  String get boostSendsHeading => 'Qué se puede enviar';

  @override
  String get boostStageLabel => 'Etapa de vida';

  @override
  String boostStage(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'period': 'Seguimiento de la regla',
      'ttc': 'Buscando embarazo',
      'pregnant': 'Embarazada',
      'postpartum': 'Después del parto',
      'menopause': 'Menopausia',
      'other': 'Sin definir',
    });
    return '$_temp0';
  }

  @override
  String get boostRegularityLabel => 'Regularidad del ciclo';

  @override
  String boostRegularity(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'regular': 'Regular',
      'variable': 'Variable',
      'unknown': 'Aún no se sabe',
      'notApplicable': 'Sin seguimiento ahora',
      'other': 'Aún no se sabe',
    });
    return '$_temp0';
  }

  @override
  String get boostCategoriesLabel =>
      'Tipos de síntomas registrados el último mes';

  @override
  String boostCategory(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'pain': 'Dolor',
      'mood': 'Ánimo',
      'digestion': 'Digestión',
      'sleepAndEnergy': 'Sueño y energía',
      'skinAndHair': 'Piel y cabello',
      'hotFlashes': 'Sofocos',
      'bladder': 'Vejiga',
      'other': 'Otros',
    });
    return '$_temp0';
  }

  @override
  String get boostNone => 'Ninguno';

  @override
  String get boostStreakLabel => 'Registro continuo';

  @override
  String boostStreak(String value) {
    String _temp0 = intl.Intl.selectLogic(value, {
      'none': 'Ninguno',
      'underAWeek': 'Menos de una semana',
      'weeks': 'Unas semanas',
      'overAMonth': 'Más de un mes',
      'other': 'Ninguno',
    });
    return '$_temp0';
  }

  @override
  String get boostNeverHeading => 'Qué no se envía nunca';

  @override
  String get boostNever =>
      'Nada más de tu historial: ni tus registros, notas, fechas, duración de ciclos, medicamentos, resultados de análisis, consultas, documentos, fotos o año de nacimiento. Nunca tus contactos ni tu ID de publicidad.';

  @override
  String get boostTurnOff => 'Desactivar Cloud boost';

  @override
  String get boostNotNow => 'Ahora no';

  @override
  String get boostAgreeQuestions =>
      'Acepto que femio envíe una pregunta general que yo apruebe, una cada vez, con las fuentes públicas que encontró y el idioma de la respuesta, para que la IA en la nube de Google las resuma. femio quita antes los números, las direcciones de correo y los enlaces, y veo y puedo editar el texto exacto antes de que se envíe nada.';

  @override
  String get boostAgreeTips =>
      'Acepto que femio envíe estos cuatro datos generales sobre mi salud, tal como se muestran, para que la IA en la nube de Google ordene mis consejos. Esto ocurre en segundo plano mientras Cloud boost está activado.';

  @override
  String get boostPurposeQuestions => 'Preguntas generales';

  @override
  String get boostPurposeTips => 'Consejos a partir de cuatro datos generales';

  @override
  String get boostWhoHeading => 'Quién lo recibe y dónde';

  @override
  String get boostWho =>
      'Google lo trata para femio mediante Firebase AI Logic (la Gemini Developer API, nivel de pago). Google puede tratarlo en Estados Unidos o en otros países donde tenga servidores, según sus condiciones de tratamiento de datos. femio (KM Digital Labs, El Cairo, Egipto) decide qué se envía y es responsable de ello.';

  @override
  String get boostKeptHeading => 'Cuánto tiempo se guarda';

  @override
  String get boostKept =>
      'femio no tiene servidor y no guarda nada. Según las condiciones de pago que usa femio, Google no lo usa para mejorar sus productos. Google lo guarda hasta 55 días para detectar abusos, y personas de Google pueden revisar contenido que sus sistemas marquen como abuso.';

  @override
  String get boostAlsoSeen =>
      'Como en cualquier conexión a internet, Google también ve la dirección de internet de tu teléfono y una comprobación de Google Play de que la solicitud viene de la app femio auténtica.';

  @override
  String get boostChoiceHeading => 'Tu elección';

  @override
  String get boostChoice =>
      'Aceptar es opcional, y puedes aceptar un uso y no el otro. Puedes desactivar Cloud boost cuando quieras, aquí o en Ajustes › Asistente, con la misma facilidad con que lo activaste. Cada teléfono vuelve a preguntar: una copia restaurada no traslada tu aceptación.';

  @override
  String get boostReadNotice => 'Leer el aviso de privacidad';

  @override
  String get boostExplicit =>
      'Estos datos y preguntas tratan sobre tu salud. Al marcar una casilla y pulsar Acepto, das tu consentimiento explícito solo para ese uso. femio guarda en este teléfono un registro fechado de tu elección, que puedes ver aquí.';

  @override
  String get boostAgree => 'Acepto';

  @override
  String get boostReceiptHeading => 'Tu aceptación';

  @override
  String boostReceipt(String date, String purposes) {
    return 'Aceptaste el $date: $purposes.';
  }

  @override
  String get boostWithdrawEffect =>
      'Desactivarlo impide nuevos envíos. No puede recuperar lo que ya se envió.';

  @override
  String get tip_trackDatesHelps =>
      'Anotar las fechas de tu regla en la aplicación te ayuda a ver tu propio patrón y da datos claros a un profesional de la salud.';

  @override
  String get tip_periodLongerThanSeven =>
      'Una regla que dura más de 7 días merece comentarse con un profesional de la salud.';

  @override
  String get tip_bleedingBetweenPeriods =>
      'El sangrado entre reglas merece comentarse con un profesional de la salud para buscar su causa.';

  @override
  String get tip_irregularCheckIn =>
      'Los ciclos de menos de 21 días o de más de 35 días se consideran irregulares. Coméntalo con un profesional de la salud, que podrá revisar tus fechas contigo.';

  @override
  String get tip_stoppedThreeMonths =>
      'Una regla que se interrumpe más de tres meses sin una razón clara merece la revisión de un profesional de la salud, sea cual sea tu edad.';

  @override
  String get tip_irregularWithOtherSigns =>
      'Las reglas irregulares junto con otros cambios, como aumento de peso, más vello en la cara o piel seca o grasa, merecen comentarse con un profesional de la salud.';

  @override
  String get tip_periodPainSeeClinician =>
      'El dolor de regla que te impide hacer tus actividades diarias habituales es un motivo para consultar a un profesional de la salud.';

  @override
  String get tip_severePainUrgent =>
      'Si el dolor pélvico o de la regla es intenso o peor de lo habitual y los analgésicos no han ayudado, pide atención médica urgente.';

  @override
  String get tip_symptomDiaryBeforeVisit =>
      'Antes de una consulta por problemas de regla, un diario de tus síntomas durante todo el ciclo da al profesional de la salud una imagen detallada de lo que ocurre y cuándo.';

  @override
  String get tip_heavyOrTired =>
      'Las reglas que te impiden hacer tus actividades, o te dejan muy cansada o sin aliento, pueden ser señal de reglas abundantes. Un profesional de la salud puede ayudarte.';

  @override
  String get tip_pmsDiary =>
      'Llevar un diario de tus síntomas durante al menos dos ciclos ayuda a un profesional de la salud a ver si siguen a tu regla.';

  @override
  String get tip_headachesAroundPeriod =>
      'Las migrañas que aparecen con regularidad antes o durante la regla merecen comentarse con un profesional de la salud. Un diario junto a las fechas de tu regla ayuda.';

  @override
  String get tip_urineInfectionSeeClinician =>
      'Si crees que puedes tener una infección de orina, es importante consultar a un profesional de la salud. Un análisis de orina puede confirmarlo.';

  @override
  String get tip_leakingUrineTellClinician =>
      'Si tienes pérdidas de orina, conviene contárselo a un profesional de la salud, sea cual sea el tipo o la causa.';

  @override
  String get tip_cervicalScreeningTip =>
      'La OMS recomienda hacer el cribado de cuello uterino cada 5 a 10 años a partir de los 30 años; los programas locales varían. Pregunta en tu centro si te toca.';

  @override
  String get tip_ttcOneYear =>
      'Si llevas un año intentándolo sin embarazo, es buena idea consultar a un profesional de la salud para revisar las causas más comunes.';

  @override
  String get tip_ttcAgeSixMonths =>
      'A partir de los 35 años se aconseja consultar a un profesional de la salud tras seis meses de intentos, no doce.';

  @override
  String get tip_ttcIrregularNoWait =>
      'Con reglas irregulares o ausentes, conviene hablar con un profesional de la salud sobre el deseo de embarazo sin esperar un año completo.';

  @override
  String get tip_regularSexTakesTime =>
      'La mayoría de las parejas en las que la mujer tiene menos de 40 años logra el embarazo en un año con relaciones regulares cada 2 o 3 días. Puede llevar tiempo.';

  @override
  String get tip_testingTooEarly =>
      'Hacer la prueba demasiado pronto puede dar un falso negativo. Sigue las instrucciones de la prueba.';

  @override
  String get tip_folicAcidBeforePregnancy =>
      'El ácido fólico, una vitamina B, se aconseja desde al menos un mes antes del embarazo. Pregunta a un profesional de la salud cómo obtener lo suficiente.';

  @override
  String get tip_talkBeforeTrying =>
      'Es buena idea hablar con un profesional de la salud antes de intentar el embarazo. Puede ayudarte a preparar tu cuerpo.';

  @override
  String get tip_tryingIsStressful =>
      'Intentar el embarazo puede ser estresante. El apoyo psicológico y los grupos de apoyo pueden ayudarte a sobrellevarlo; puedes preguntar a un profesional de la salud.';

  @override
  String get tip_movementsChangeCallNow =>
      'Si tu bebé se mueve menos de lo habitual o cambia su patrón, llama de inmediato a tu matrona o a la maternidad, incluso a mitad de la noche.';

  @override
  String get tip_firstMovementsBy24 =>
      'Deberías empezar a notar a tu bebé entre las semanas 16 y 24. Si a las 24 semanas aún no lo has notado, díselo a tu matrona.';

  @override
  String get tip_preeclampsiaSigns =>
      'Un dolor de cabeza intenso que los analgésicos no alivian, problemas de visión, dolor bajo las costillas o hinchazón repentina requieren revisión inmediata. Llama a la maternidad.';

  @override
  String get tip_antenatalChecksMatter =>
      'Los controles de tensión y de orina en las visitas prenatales detectan cambios que no notas, así que intenta no faltar a ninguna cita.';

  @override
  String get tip_screeningVersusDiagnostic =>
      'A todas las embarazadas se les ofrecen dos tipos de pruebas: las de cribado, que muestran una probabilidad, y las de seguimiento, que dan una respuesta más clara. Pregunta cuáles te convienen.';

  @override
  String get tip_glucoseScreening =>
      'Todas las embarazadas deben someterse al cribado de diabetes gestacional. Pregunta a tu matrona o médico cuándo está previsto el tuyo.';

  @override
  String get tip_rhBloodGroup =>
      'Un simple análisis de sangre muestra tu grupo sanguíneo y tu factor Rh, normalmente en la primera visita prenatal. Pregunta cuál es el tuyo y si influye en tu atención.';

  @override
  String get tip_mainScanBetween18And21 =>
      'Suele hacerse una ecografía detallada entre las semanas 18 y 21. Comprueba el crecimiento del bebé y busca ciertas afecciones.';

  @override
  String get tip_severeSicknessTellEarly =>
      'Si vomitas a menudo y no retienes la comida, díselo a tu matrona o médico cuanto antes, para que te ayuden a retener los líquidos.';

  @override
  String get tip_itchTellMidwife =>
      'El picor es frecuente en el embarazo, pero puede ser el primer signo de una afección del hígado llamada colestasis intrahepática del embarazo. Cuéntaselo a tu matrona o médico para que lo revisen.';

  @override
  String get tip_pretermLabourSigns =>
      'Los signos de parto prematuro incluyen contracciones cada 10 minutos o con más frecuencia, pérdida de líquido o sangrado, presión pélvica y un dolor sordo en la parte baja de la espalda. Contacta con tu matrona, tu médico o la unidad de maternidad.';

  @override
  String get tip_tirednessInPregnancy =>
      'El cansancio en el embarazo tiene muchas causas, y la anemia es una de ellas. Comenta el cansancio persistente a tu matrona o médico.';

  @override
  String get tip_lowMoodPerinatal =>
      'Sentirse decaída es frecuente en el embarazo y tras el parto, y hay apoyo disponible. Díselo a tu matrona o médico, aunque solo tengas algunos de los signos.';

  @override
  String get tip_anxietyInPregnancy =>
      'La ansiedad en el embarazo muchas veces mejora con terapia de conversación. Cuéntale a tu matrona o médico cómo te sientes de verdad.';

  @override
  String get tip_warningSignsPregnancyAndYear =>
      'Algunas señales de alarma requieren atención inmediata, durante el embarazo y un año después del parto: dolor de cabeza que no se va, cambios en la visión, fiebre, dificultad para respirar o dolor abdominal intenso.';

  @override
  String get tip_postnatalCheckSixToEight =>
      'Una revisión posparto hacia las 6 a 8 semanas comprueba que te encuentras bien y te recuperas. Apunta tus preguntas para llevarlas.';

  @override
  String get tip_painfulFeedsGetHelp =>
      'Si retrasas las tomas porque amamantar duele, pide ayuda a una asesora de lactancia.';

  @override
  String get tip_tirednessAfterBirthThyroid =>
      'El cansancio tras el parto tiene muchas causas. La inflamación de la tiroides afecta a cerca de 1 de cada 20 mujeres el primer año; comenta el cansancio persistente a un profesional de la salud.';

  @override
  String get tip_bleedingUpToSixWeeks =>
      'El manchado o sangrado parecido a una regla, de forma intermitente, puede durar hasta seis semanas tras el parto. Cuéntaselo a un profesional de la salud si te preocupa.';

  @override
  String get tip_babyBluesPassing =>
      'Sentirse decaída, ansiosa o irritable unos días tras el parto es muy frecuente y suele pasar en 2 semanas. Si dura más, díselo a un profesional de la salud.';

  @override
  String get tip_periodChangesFirstSign =>
      'Un cambio en la regla suele ser una de las primeras señales de la perimenopausia. Puede venir con más o menos frecuencia, y ser más abundante o más leve.';

  @override
  String get tip_twelveMonthsMeansMenopause =>
      'La menopausia significa 12 meses sin regla. En los años previos los ciclos suelen variar, con intervalos más largos o más cortos.';

  @override
  String get tip_bleedingAfterMenopause =>
      'El sangrado tras la menopausia, es decir, tras 12 meses sin regla, es importante comentarlo con un profesional de la salud para encontrar su causa.';

  @override
  String get tip_hotFlushesTalkOptions =>
      'Si los cambios de estilo de vida no bastan para los sofocos, contacta con un profesional de la salud. Hablará contigo de tus síntomas, tu historial y tus preferencias.';

  @override
  String get tip_boneStrengthMenopause =>
      'La pérdida de densidad ósea es más probable en torno a la menopausia. Pregunta a un profesional de la salud por la salud de tus huesos y qué te conviene.';

  @override
  String get tip_drynessManyTreatments =>
      'Hay muchos tratamientos para la sequedad vaginal. Conviene preguntar a un profesional de la salud cuál puede irte bien.';

  @override
  String get tip_heartbeatAroundMenopause =>
      'Un latido más rápido o más notorio puede formar parte de la perimenopausia y la menopausia. Anota cuándo ocurre y cuéntaselo a un profesional de la salud.';

  @override
  String get tip_lowMoodMenopause =>
      'El ánimo bajo y la ansiedad pueden formar parte de la transición a la menopausia. Si cuesta manejarlos, habla con un profesional de la salud.';

  @override
  String get visitQ_periodsStoppedChecks =>
      'Mi regla se ha vuelto muy espaciada o se ha detenido. ¿Qué pruebas podrían averiguar el motivo?';

  @override
  String get visitQ_irregularCauses =>
      '¿Qué podría explicar mis ciclos irregulares y ayudarían algunas pruebas o ecografías?';

  @override
  String get visitQ_irregularAcneChecks =>
      'Tengo reglas irregulares y acné. ¿Qué pruebas podrían buscar la causa?';

  @override
  String get visitQ_painCauseChecks =>
      'El dolor de mi regla me estorba en el día a día. ¿Qué pruebas podrían averiguar el motivo?';

  @override
  String get visitQ_heavyAndTiredBloodTest =>
      'Mis reglas pueden ser abundantes y me siento muy cansada. ¿Debería hacerme análisis de sangre, por ejemplo de hierro?';

  @override
  String get visitQ_diaryReviewCycle =>
      '¿Podemos repasar mi diario de síntomas para ver si siguen mi ciclo?';

  @override
  String get visitQ_headacheDiaryReview =>
      'Mis migrañas aparecen a menudo alrededor de mi regla. ¿Podemos mirar mi diario juntos?';

  @override
  String get visitQ_cervicalScreeningDue =>
      '¿Estoy al día con el cribado de cuello uterino y qué prueba usa su clínica?';

  @override
  String get visitQ_checksForCouple =>
      '¿Qué pruebas de fertilidad me sugiere, y para una pareja si la tengo?';

  @override
  String get visitQ_ttcOverThirtyFiveSooner =>
      'Tengo 35 años o más y llevo unos seis meses o más intentándolo. ¿Empiezo ya las pruebas de fertilidad?';

  @override
  String get visitQ_irregularTryingNow =>
      'Mis ciclos son irregulares y estoy intentando el embarazo. ¿Hablamos de ayuda ya, en lugar de esperar un año?';

  @override
  String get visitQ_preconceptionReview =>
      'Estamos planeando un embarazo. ¿Hay algo de mi salud o de mis medicamentos que convenga revisar antes?';

  @override
  String get visitQ_ttcSupportOptions =>
      'Intentar el embarazo me pesa. ¿Dónde puedo encontrar apoyo psicológico o grupos de apoyo?';

  @override
  String get visitQ_pregnancyTestsOffered =>
      '¿Qué pruebas de cribado y de seguimiento se ofrecen en mi embarazo, y qué me dice cada una?';

  @override
  String get visitQ_glucoseTestWhen =>
      '¿Cuándo me harán la prueba de diabetes gestacional y podría ser antes en mi caso?';

  @override
  String get visitQ_movementsCallWho =>
      '¿A quién llamo si cambian los movimientos de mi bebé, también por la noche?';

  @override
  String get visitQ_sameDayWarningSigns =>
      '¿Qué señales deben hacerme llamar a la maternidad el mismo día?';

  @override
  String get visitQ_rhFactorChecked =>
      '¿Se han comprobado mi grupo sanguíneo y mi factor Rh y cambia algo en mi atención?';

  @override
  String get visitQ_pregnancyLowMoodSupport =>
      'Llevo un tiempo decaída o muy preocupada. ¿Qué apoyo hay disponible?';

  @override
  String get visitQ_severeSicknessHelp =>
      'Las náuseas y vómitos me impiden retener comida y bebida. ¿Qué ayuda hay disponible?';

  @override
  String get visitQ_itchBloodTests =>
      'Tengo picor en el embarazo. ¿Debería hacerme análisis de sangre para revisar el hígado?';

  @override
  String get visitQ_pretermSignsPlan =>
      '¿Qué signos de parto prematuro deben hacerme llamar o acudir y adónde voy fuera de horario?';

  @override
  String get visitQ_postnatalCheckTalk =>
      '¿Podemos repasar cómo me estoy recuperando, incluyendo sangrado, dolor, ánimo y cambios en la vejiga?';

  @override
  String get visitQ_postnatalMoodHelp =>
      'Me siento decaída o ansiosa desde el parto. ¿Qué ayuda hay?';

  @override
  String get visitQ_latchCheck =>
      'Amamantar duele. ¿Podría alguien observar una toma y comprobar cómo se agarra mi bebé?';

  @override
  String get visitQ_warningSignsYearAfter =>
      '¿Qué síntomas en el año posterior al parto deben hacerme buscar atención de inmediato?';

  @override
  String get visitQ_thyroidAfterBirth =>
      'Me siento muy cansada desde el parto. ¿Deberían revisarme la tiroides con un análisis de sangre?';

  @override
  String get visitQ_urineLeaksHelp =>
      'Tengo pérdidas de orina. ¿Qué puede ayudar y me convendrían los ejercicios del suelo pélvico?';

  @override
  String get visitQ_hotFlushOptions =>
      'Los sofocos o sudores nocturnos afectan a mis días. ¿Qué opciones podemos hablar?';

  @override
  String get visitQ_changedBleedingChecks =>
      'Mi patrón de sangrado ha cambiado. ¿Qué pruebas merece la pena hacer?';

  @override
  String get visitQ_bleedingAfterMenopauseChecks =>
      'He tenido sangrado o manchado en esta etapa. ¿Qué pruebas necesito y con qué urgencia?';

  @override
  String get visitQ_boneAndHeartHealth =>
      '¿Qué puedo hacer para proteger la salud de mis huesos y de mi corazón en esta etapa?';

  @override
  String get visitQ_drynessWhatHelps =>
      'Tengo sequedad o molestias vaginales. ¿Qué puede ayudar y qué conviene revisar?';

  @override
  String get visitQ_urineTestAgain =>
      'Mis síntomas urinarios siguen volviendo. ¿Debería hacerme un análisis de orina y cómo podemos hallar la causa?';

  @override
  String get visitQ_thyroidCheckIrregular =>
      'Mis reglas son irregulares y se me adelgaza el pelo. ¿Deberían revisarme la tiroides con un análisis de sangre?';

  @override
  String get tipsTitle => 'Para ti';

  @override
  String tipsSource(String publisher) {
    return 'Fuente: $publisher';
  }

  @override
  String get tipsChosenOnPhone =>
      'Elegidos en tu teléfono a partir de tu registro. Cada consejo es una frase revisada, con su fuente.';

  @override
  String get tipsOrderedCloud =>
      'Ordenados con Cloud boost, solo a partir de datos generales.';

  @override
  String get legendPossible => 'Regla posible (confianza baja)';

  @override
  String get confidenceLowShort => 'Confianza baja';

  @override
  String get upcomingPeriodsTitle => 'Próximas reglas';

  @override
  String get upcomingPeriodsWider =>
      'Cada regla siguiente tiene un margen más amplio: cuanto más lejos, menos certeza.';

  @override
  String get upcomingPeriodsOnlyNext =>
      'Solo se muestra la próxima regla: tus ciclos registrados varían demasiado, o todavía son pocos, para llegar más lejos.';

  @override
  String get todayUrgentBody =>
      'Si algo te parece grave o repentino, busca atención ahora. Los números de emergencia de tu país están a un toque.';

  @override
  String get toolsTitle => 'Calculadoras';

  @override
  String get toolsSub =>
      'Estas calculadoras dan estimaciones generales para informarte y planificar, no consejo médico. Habla con tu profesional de salud sobre tu salud.';

  @override
  String get toolDueTitle => 'Calculadora de fecha de parto';

  @override
  String get toolDueDesc =>
      'Según tu última regla, la concepción, una transferencia de FIV o una ecografía.';

  @override
  String get toolCalTitle => 'Calendario del embarazo';

  @override
  String get toolCalDesc =>
      'Las fechas de cada semana del embarazo, con la guía de cada semana.';

  @override
  String get toolGainTitle => 'Aumento de peso en el embarazo';

  @override
  String get toolGainDesc =>
      'El rango de referencia según tu IMC antes del embarazo.';

  @override
  String get toolDueMethodLabel => '¿De dónde sale tu fecha?';

  @override
  String get toolDueMethodLmp => 'Última regla';

  @override
  String get toolDueMethodConception => 'Concepción';

  @override
  String get toolDueMethodTransfer => 'Transferencia FIV';

  @override
  String get toolDueMethodScan => 'Ecografía de datación';

  @override
  String get toolEmbryoLabel => 'Edad del embrión al transferirlo';

  @override
  String get toolEmbryo3 => 'Día 3';

  @override
  String get toolEmbryo5 => 'Día 5';

  @override
  String get toolPromptLmp => 'Toca el día en que empezó tu última regla';

  @override
  String get toolPromptConception => 'Toca el día de la concepción';

  @override
  String get toolPromptTransfer =>
      'Toca el día de la transferencia de embriones';

  @override
  String get toolPromptScan => 'Toca el día de tu ecografía';

  @override
  String get toolCycleLabel => 'Duración del ciclo';

  @override
  String toolDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '$count día',
    );
    return '$_temp0';
  }

  @override
  String get toolScanWeeksLabel => 'Semanas en el informe de la ecografía';

  @override
  String get toolScanDaysLabel => 'Días de más en el informe';

  @override
  String toolWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '$count semana',
    );
    return '$_temp0';
  }

  @override
  String toolTermWindow(String start, String end) {
    return 'La mayoría de los bebés llega entre el $start y el $end.';
  }

  @override
  String get toolScanNote =>
      'Se usan las semanas y los días de tu informe tal como aparecen. Si tu profesional sanitario te ha dado una fecha de parto, sigue la suya.';

  @override
  String get toolEstimateNote =>
      'Estas fechas son estimaciones basadas en la fecha que introdujiste. Cada cuerpo es distinto.';

  @override
  String get toolClinicianAdjust =>
      'Tu profesional de salud puede ajustar la fecha tras una ecografía.';

  @override
  String get toolCalMethodLabel => '¿Qué fecha conoces?';

  @override
  String get toolCalMethodEdd => 'Fecha de parto';

  @override
  String get toolCalMethodLmp => 'Última regla';

  @override
  String get toolCalPromptEdd => 'Toca tu fecha probable de parto';

  @override
  String get toolCalEyebrow => 'Tu embarazo, semana a semana';

  @override
  String toolCalTrimesterLine(String second, String third) {
    return 'Segundo trimestre desde el $second; tercer trimestre desde el $third.';
  }

  @override
  String toolCalWeek(String week) {
    return 'Semana $week';
  }

  @override
  String get toolCalCurrent => 'Esta semana';

  @override
  String toolCalReadGuide(String week) {
    return 'Leer la guía de la semana $week';
  }

  @override
  String get toolGainIntro =>
      'Introduce tu peso antes del embarazo y tu estatura para ver el rango de referencia del aumento de peso total durante el embarazo, según el Institute of Medicine (2009). No se guarda nada.';

  @override
  String get toolGainWeight => 'Peso antes del embarazo (kg)';

  @override
  String get toolGainHeight => 'Altura (cm)';

  @override
  String get toolGainBabiesLabel => '¿Cuántos bebés?';

  @override
  String get toolGainBabiesOne => 'Uno';

  @override
  String get toolGainBabiesTwo => 'Gemelos';

  @override
  String get toolGainBabiesMore => 'Tres o más';

  @override
  String toolGainBmiLine(String value, String band) {
    return 'IMC antes del embarazo: $value ($band)';
  }

  @override
  String toolBandUnder(String limit) {
    return 'menos de $limit';
  }

  @override
  String toolBandBetween(String low, String high) {
    return 'de $low a menos de $high';
  }

  @override
  String toolBandFrom(String limit) {
    return '$limit o más';
  }

  @override
  String get toolGainEyebrow =>
      'Rango de referencia del aumento total durante todo el embarazo';

  @override
  String toolGainRangeKg(String low, String high) {
    return 'De $low a $high kg';
  }

  @override
  String toolGainRangeLb(String low, String high) {
    return 'De $low a $high lb';
  }

  @override
  String toolGainOtherUnit(String range) {
    return 'Es decir, $range.';
  }

  @override
  String get toolGainNoRangeTwins =>
      'El Institute of Medicine no da un rango para gemelos cuando el IMC antes del embarazo es inferior a 18,5. Tu profesional sanitario te orientará.';

  @override
  String get toolGainNoRangeMultiples =>
      'El Institute of Medicine no da un rango para tres o más bebés. Tu profesional sanitario te orientará.';

  @override
  String get toolGainNote =>
      'Es un rango de referencia para tu categoría de IMC antes del embarazo, no un objetivo ni un juicio. Tu profesional sanitario puede proponerte un rango distinto.';

  @override
  String get toolGainSource =>
      'Fuente: Institute of Medicine (2009), «Weight Gain During Pregnancy»; los CDC y el ACOG usan los mismos rangos.';

  @override
  String toolGainOutOfRange(
    String minW,
    String maxW,
    String minH,
    String maxH,
  ) {
    return 'Introduce un peso de $minW a $maxW kg y una estatura de $minH a $maxH cm.';
  }

  @override
  String get toolNothingSaved => 'No se guarda nada de lo que introduces aquí.';

  @override
  String get updateBannerBody => 'Hay una nueva versión de femio lista.';

  @override
  String get updateBannerAction => 'Actualizar';

  @override
  String get leaveTitle => 'Qué puede salir de este teléfono';

  @override
  String get leaveIntro =>
      'Tus registros se quedan en este teléfono: tu registro del ciclo y del embarazo, notas, historial de salud (consultas, resultados de análisis, medicamentos y más), documentos y fotos, y tu año de nacimiento. femio pregunta tu año de nacimiento para comprobar que tienes 18 años o más y ajustar a tu edad lo que espera. Estas son todas las formas en que algo puede salir de este teléfono.';

  @override
  String get leaveBoostOff => 'Desactivado';

  @override
  String leaveBoostOn(String purposes) {
    return 'Activado para: $purposes';
  }

  @override
  String get leaveBoostBody =>
      'Solo si aceptas: una pregunta general que apruebas, o cuatro datos generales, se envía a la IA en la nube de Google. Google Play también comprueba que la solicitud viene de la app femio auténtica.';

  @override
  String get leaveModelHeading => 'El modelo de IA del teléfono';

  @override
  String get leaveModelBody =>
      'Si tocas Descargar, el servicio de IA de Android (AICore, gestionado por Google) descarga Gemini Nano y lo mantiene actualizado. Cada vez que funciona la IA del teléfono, el software de IA de Google puede enviar a Google información técnica de uso, como un identificador de esta instalación, datos del dispositivo y de la app, errores, velocidad y el tamaño de una solicitud. No incluye tus palabras, y femio no añade ninguno de tus registros.';

  @override
  String get leavePlayHeading => 'Google Play';

  @override
  String get leavePlayBody =>
      'Google Play instala y actualiza femio, puede mostrar su solicitud de valoración y gestiona los pagos de femio Plus. Solo nos da totales, como instalaciones y fallos. femio no envía a Google Play nada tuyo.';

  @override
  String get leaveBackupHeading => 'Tu copia de seguridad';

  @override
  String get leaveBackupBody =>
      'Una copia de seguridad, con los documentos y fotos que has añadido, solo va donde decides guardarla, cifrada con tu frase de contraseña.';

  @override
  String get leaveLinksHeading => 'Los enlaces que abres';

  @override
  String get leaveLinksBody =>
      'Las fuentes y páginas que abres van a tu navegador, que visita ese sitio web.';

  @override
  String get leaveNever =>
      'No sale nada más. femio no tiene anuncios, ni cuenta, ni herramientas de analítica o seguimiento propias. En el propio teléfono, las palabras que escribes para un recordatorio de medicamento se ven en la pantalla de bloqueo, y los detalles del widget que activas se ven en la pantalla de inicio; femio guarda ese texto corto sin cifrar para que Android pueda mostrarlo.';

  @override
  String get leaveSettingsSub =>
      'Todas las formas en que algo llega a internet';

  @override
  String get assistantMasterTitle => 'Usar el asistente';

  @override
  String get assistantMasterOff =>
      'Desactivado: femio responde solo con sus reglas y guías. No funciona ninguna IA, ni en el teléfono ni en la nube.';

  @override
  String get assistantMasterOn =>
      'Activado: la IA añade explicaciones junto a las respuestas de femio. Todo funciona sin ella.';

  @override
  String get aiSeesTitle => 'Qué puede ver la IA';

  @override
  String get aiSeesSub => 'Cada función de IA, dónde se ejecuta y qué recibe';

  @override
  String get aiSeesIntro =>
      'La IA nunca ve tu registro completo. Cada función recibe solo los elementos indicados debajo, y las reglas de seguridad de femio siempre responden primero.';

  @override
  String get aiSeesOff =>
      'El asistente está desactivado, así que ninguna de estas funciones se ejecuta.';

  @override
  String get aiUseAskInCloud => 'Pregunta a femio con Cloud boost';

  @override
  String get aiUseTips => 'Consejos para ti';

  @override
  String get aiWherePhone => 'Se ejecuta solo en este teléfono';

  @override
  String get aiWhereHybrid =>
      'En este teléfono, o en la nube de Google solo si aceptaste Cloud boost';

  @override
  String get aiWriteNone => 'Nunca cambia tu registro';

  @override
  String get aiWriteDraft =>
      'Sugiere un borrador; no se guarda nada hasta que lo revises y toques Guardar';

  @override
  String get aiSeesLabel => 'Qué recibe';

  @override
  String get aiSeesHerQuestion => 'La pregunta que escribiste';

  @override
  String get aiSeesPassages =>
      'Fragmentos de las fuentes de confianza de femio (texto público, no tuyo)';

  @override
  String get aiSeesNote => 'La nota que escribiste';

  @override
  String get aiSeesBands =>
      'Cuatro datos generales: etapa de vida, regularidad del ciclo, tipos de síntoma y racha de registro';

  @override
  String get aiSeesIds =>
      'Los consejos o preguntas revisados de femio, para ordenarlos';

  @override
  String get aiSeesVisitFacts =>
      'Tu resumen de consulta: objetivo, ciclos contados, ciclo más corto y más largo, fecha de la última regla, regularidad';

  @override
  String get aiSeesApprovedQuestion =>
      'Tu pregunta; en la nube, solo la versión que aprobaste, sin números, direcciones de correo ni enlaces';

  @override
  String get assistIntroTitle => 'Conoce el asistente de femio';

  @override
  String get assistIntroPhone =>
      'Funciona en este teléfono. Responde con las fuentes de confianza de femio, convierte una frase en registros y sugiere preguntas para tus consultas. Tus registros se quedan aquí.';

  @override
  String get assistIntroRules =>
      'Nunca te dice qué afección tienes. Las reglas de seguridad de femio siempre responden primero, y no se guarda nada hasta que lo confirmes.';

  @override
  String get assistIntroCloudTitle => 'Cloud boost, solo si lo eliges';

  @override
  String get assistIntroCloudBody =>
      'Si este teléfono no puede ejecutar la IA por sí mismo, puedes dejar que una pregunta general que apruebes, o cuatro datos generales, vayan a la IA en la nube de Google. Sigue desactivado salvo que lo actives.';

  @override
  String get assistIntroCloudAction => 'Elegir Cloud boost';

  @override
  String get assistIntroContinue => 'Continuar en este teléfono';

  @override
  String get assistIntroSettings =>
      'Puedes cambiarlo, o desactivar el asistente, en Ajustes › Asistente.';

  @override
  String get assistDoorAsk => 'Haz una pregunta';

  @override
  String get assistDoorAskSub =>
      'Respuestas de fuentes de confianza, con enlaces';

  @override
  String get assistDoorSayIt => 'Cuenta cómo fue hoy';

  @override
  String get assistDoorSayItSub =>
      'Una frase se convierte en el registro de hoy; lo revisas primero';

  @override
  String get assistDoorVisitSub =>
      'Un resumen de tu registro y preguntas para llevar';

  @override
  String thisWeekTitle(int week) {
    return 'Esta semana: semana $week';
  }

  @override
  String weekGuideTitle(int week) {
    return 'Semana $week';
  }

  @override
  String get weekSecBaby => 'Bebé';

  @override
  String get weekSecBody => 'Tu cuerpo';

  @override
  String get weekSecNotice => 'Lo que puedes notar';

  @override
  String get weekSecCare => 'La atención en esta etapa';

  @override
  String get weekSecTip => 'Consejo';

  @override
  String weekReadFull(int week) {
    return 'Leer la guía de la semana $week';
  }

  @override
  String get pregWeeksTitle => 'Tu embarazo semana a semana';

  @override
  String get pregWeeksHint =>
      'Contadas desde tu fecha probable de parto. Toca una semana para leer su guía.';

  @override
  String pregWeekCurrentLabel(int week) {
    return 'Semana $week, tu semana actual';
  }

  @override
  String get sectionBleedingPregnant => 'Sangrado o manchado';

  @override
  String get bleedingPregnantNote =>
      'El sangrado en el embarazo es frecuente, pero puede ser señal de algo grave. Cuéntale cualquier sangrado a tu matrona o a tu médico.';

  @override
  String get logAllItems => 'Todos los elementos del registro';

  @override
  String get logAllItemsSub =>
      'Test de ovulación y temperatura, ocultos en el embarazo';

  @override
  String get sayItHintTtc =>
      'Por ejemplo: test de ovulación positivo, cólicos leves e hinchazón';

  @override
  String get sayItHintPregnant =>
      'Por ejemplo: náuseas por la mañana, dolor de espalda y mucho cansancio';

  @override
  String get sayItHintPostpartum =>
      'Por ejemplo: insomnio, dolor de espalda y ánimo bajo';

  @override
  String get sayItHintMenopause =>
      'Por ejemplo: sofocos, sudores nocturnos e insomnio';

  @override
  String get askHintTtc => 'Por ejemplo: ¿cuáles son mis días fértiles?';

  @override
  String get askHintPregnant =>
      'Por ejemplo: ¿qué alivia la acidez en el embarazo?';

  @override
  String get askHintPostpartum =>
      'Por ejemplo: ¿qué alivia los pezones doloridos al dar el pecho?';

  @override
  String get askHintMenopause => 'Por ejemplo: ¿qué alivia los sofocos?';

  @override
  String get calendarHintNoEstimates =>
      'Toca un día para registrarlo. Los días registrados aparecen rellenos.';

  @override
  String get whyRangeAction => '¿Por qué este rango?';

  @override
  String get whyRangeTitle => 'Por qué este rango';

  @override
  String whyRangeStated(String length, String margin) {
    return 'femio todavía no puede medir un ciclo con tu registro, así que parte de la duración de ciclo que indicaste: $length. El rango es de $margin a cada lado.';
  }

  @override
  String whyRangeCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'femio midió $count ciclos con las reglas que registraste.',
      one: 'femio midió 1 ciclo con las reglas que registraste.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeAverage(String length) {
    return 'Tus últimos ciclos duran de media $length, así que el centro del rango cae $length después del inicio de tu última regla.';
  }

  @override
  String whyRangeSpread(String spread, String margin) {
    return 'Entre tu ciclo más corto y el más largo hay $spread de diferencia, así que el rango es de $margin a cada lado del centro.';
  }

  @override
  String whyRangeSpreadNone(String margin) {
    return 'Todos tus ciclos han durado lo mismo, así que es el rango más estrecho que muestra femio: $margin a cada lado.';
  }

  @override
  String whyRangeIrregular(String limit) {
    return 'Tus ciclos varían más de $limit, así que femio muestra solo la próxima regla, con un rango más amplio, y nunca cuenta días de retraso.';
  }

  @override
  String whyRangeNextMedium(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ciclos más registrados, igual de regulares, subirían la confianza a media.',
      one: 'Un ciclo más registrado, igual de regular, subiría la confianza a media.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeNextHigh(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count ciclos más registrados, igual de regulares, subirían la confianza a alta.',
      one: 'Un ciclo más registrado, igual de regular, subiría la confianza a alta.',
    );
    return '$_temp0';
  }

  @override
  String whyRangeHighNeedsSteady(String limit) {
    return 'La confianza alta necesita ciclos que varíen $limit o menos.';
  }

  @override
  String get whyRangeWindowShown =>
      'La ventana fértil se cuenta hacia atrás desde el centro de este rango, así que se mueve cuando el rango se mueve.';

  @override
  String get whyRangeWindowIrregular =>
      'No se indica ventana fértil porque tus ciclos varían demasiado para contar hacia atrás desde una sola fecha.';

  @override
  String get whyRangeWindowLearning =>
      'Todavía no hay ventana fértil: femio necesita al menos dos ciclos registrados para contar hacia atrás.';

  @override
  String whyRangeWindowOutside(int min, int max) {
    return 'No se indica ventana fértil porque la duración de tu ciclo está fuera de $min a $max días, donde contar hacia atrás desde una fecha no es fiable.';
  }

  @override
  String get dayExplainLink => 'Explicar este día';

  @override
  String get dayFactBleed => 'Registraste sangrado este día.';

  @override
  String get dayFactSpotting => 'Registraste manchado este día.';

  @override
  String get dayFactLogged =>
      'Registraste síntomas o estado de ánimo este día.';

  @override
  String dayFactNextPeriod(String range) {
    return 'Este día está dentro del rango en que puede empezar tu próxima regla: $range.';
  }

  @override
  String dayFactLaterPeriod(String range) {
    return 'Este día está dentro del rango de una regla posterior: $range. Cuanto más lejos, menos seguro.';
  }

  @override
  String dayFactFertile(String range) {
    return 'Este día está dentro de tu ventana fértil estimada: $range.';
  }

  @override
  String get dayFactOvulation =>
      'femio estima la ovulación alrededor de este día, contando hacia atrás desde tu próxima regla. Los test de ovulación y la temperatura al despertar pueden ayudarte a saber si ovulaste.';

  @override
  String get dayFactNothingFuture => 'No hay ninguna estimación para este día.';

  @override
  String get dayFactNothingPast =>
      'No hay nada registrado este día. femio no dibuja estimaciones en días ya pasados.';

  @override
  String get dayLogAction => 'Registrar este día';

  @override
  String predictionMoved(String after, String before) {
    return 'Próxima regla ahora hacia $after. Antes era $before.';
  }

  @override
  String predictionNew(String after) {
    return 'Próxima regla hacia $after.';
  }

  @override
  String get predictionWhy => '¿Por qué?';

  @override
  String get visitWorryTitle => '¿Qué quieres comentar en esta consulta?';

  @override
  String get visitWorryHint =>
      'Con tus palabras, por ejemplo: mi dolor de regla es más fuerte';

  @override
  String get visitWorryFind => 'Buscar preguntas';

  @override
  String get visitWorrySuggested =>
      'Preguntas que encajan con lo que escribiste';

  @override
  String get visitWorryNone =>
      'Ninguna pregunta de la lista de femio encaja todavía. Tus palabras se añadirán tal como las escribiste.';

  @override
  String get visitWorryOwnWords => 'Añadir también tus propias palabras';

  @override
  String get visitWorryAdd => 'Añadir a tu consulta';

  @override
  String visitWorryAddedTo(String date) {
    return 'Añadido a tus preguntas para el $date.';
  }

  @override
  String get visitWorryAddedNext =>
      'Añadido a tus preguntas para tu próxima consulta.';

  @override
  String get visitYourQuestions => 'Tus preguntas';

  @override
  String visitInMyWords(String text) {
    return 'Con mis palabras: $text';
  }

  @override
  String get visitRemoveQuestion => 'Quitar esta pregunta';

  @override
  String get visitSecondLanguage =>
      'Añadir la página en un segundo idioma para la consulta';

  @override
  String get visitNoSecondLanguage => 'Ninguno';

  @override
  String get visitShare => 'Compartir';

  @override
  String visitMadeOn(String date) {
    return 'Hecha el $date con lo que registré en femio. Es mi propio registro, para comentarlo juntos.';
  }

  @override
  String get askVisitPack => 'Preparar un resumen para la consulta';

  @override
  String get tipWhyAction => '¿Por qué veo esto?';

  @override
  String get tipWhyTitle => 'Por qué este consejo';

  @override
  String tipWhyStage(String stage) {
    String _temp0 = intl.Intl.selectLogic(stage, {
      'period': 'Estás siguiendo tus reglas.',
      'ttc': 'Estás intentando concebir.',
      'pregnant': 'Estás embarazada.',
      'postpartum': 'Registraste el nacimiento de tu bebé.',
      'menopause': 'Estás siguiendo la perimenopausia o la menopausia.',
      'other': 'Elegiste esta etapa.',
    });
    return '$_temp0';
  }

  @override
  String tipWhyTerm(String term, String days, String window) {
    return 'Registraste «$term» en $days durante los últimos $window.';
  }

  @override
  String tipWhyPregnancyWeek(int week) {
    return 'Estás de $week semanas, según tu fecha probable de parto.';
  }

  @override
  String tipWhyPostpartumWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tu bebé nació hace $count semanas.',
      one: 'Tu bebé nació hace 1 semana.',
      zero: 'Tu bebé nació hace menos de una semana.',
    );
    return '$_temp0';
  }

  @override
  String tipWhyTryingFor(String label) {
    return 'Cuánto tiempo llevas intentándolo: $label.';
  }

  @override
  String get tipWhyIrregular => 'Tus ciclos están marcados como irregulares.';

  @override
  String get tipWhyRegular => 'Tus ciclos no están marcados como irregulares.';

  @override
  String tipWhyAge(int age) {
    return 'Tienes $age años o más este año.';
  }

  @override
  String get tipWhyFootnote =>
      'Estos datos se leyeron en tu teléfono, de tu propio registro. Son las únicas razones por las que se eligió este consejo.';

  @override
  String get aiLedgerTitle => 'Lo que hizo la IA';

  @override
  String get aiLedgerSub =>
      'Cada vez que femio usó un modelo, guardado en este teléfono';

  @override
  String get aiLedgerIntro =>
      'Cada vez que femio usó un modelo aparece aquí, de la más reciente a la más antigua. Con Cloud boost se guarda el texto exacto que se envió, como tu recibo. Esta lista se queda en este teléfono: no está en tu copia de seguridad y «Borrar todo» la elimina.';

  @override
  String get aiLedgerEmpty => 'femio todavía no ha usado ningún modelo.';

  @override
  String get aiLedgerOnPhone => 'En este teléfono (Gemini Nano)';

  @override
  String get aiLedgerInCloud => 'Enviado con Cloud boost';

  @override
  String get aiLedgerNoReply =>
      'No llegó ninguna respuesta a tiempo, así que femio usó sus reglas.';

  @override
  String get aiLedgerSent => 'Exactamente lo que se envió';

  @override
  String get aiLedgerClear => 'Borrar esta lista';

  @override
  String get aiLedgerClearConfirm =>
      '¿Borrar esta lista? Tu registro no cambia.';

  @override
  String get signsTitle => 'Las señales que anotaste este ciclo';

  @override
  String signsValueOn(String value, String date) {
    return '$value, $date';
  }

  @override
  String signsTempCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mediciones este ciclo',
      one: '1 medición este ciclo',
    );
    return '$_temp0';
  }

  @override
  String get signsStripLine =>
      'Una tira de ovulación muestra una subida hormonal, no una prueba de que ovulaste. Una subida de tu temperatura al despertar después es una mejor señal.';

  @override
  String get signsNote =>
      'Cada señal aparece tal como la anotaste. femio no dice si ovulaste ni cuándo; eso se habla contigo y tu profesional.';

  @override
  String sayItChipWithSection(String section, String value) {
    return '$section: $value';
  }

  @override
  String get navAdd => 'Añadir';

  @override
  String get addSheetTitle => 'Añadir a hoy';

  @override
  String get addSayItPrompt =>
      'Cuéntale lo que sea a femio, como «cólicos desde esta mañana»';

  @override
  String get addMoreToLog => 'Síntomas, flujo, pruebas y más';

  @override
  String get addAsk => 'Pregunta a femio';

  @override
  String get addVisit => 'Para mi consulta';

  @override
  String get addLogWithFemio => 'Registra con femio';

  @override
  String get addAskSub =>
      'Haz una pregunta; la respuesta viene de fuentes fiables';

  @override
  String get addLogSub => 'Cuenta cómo te sientes, con tus palabras';

  @override
  String get askSaveTitle => '¿Guardar esto en tu historial?';

  @override
  String get askSaveIntro =>
      'No se guarda nada si no lo marcas y tocas Guardar.';

  @override
  String get askSaveTerms => 'Añadir lo que mencionaste al registro de hoy';

  @override
  String get askSaveNote =>
      'Guardar esta pregunta y su respuesta para mi próxima consulta';

  @override
  String get askSaveNoteSub =>
      'Pasa a tus preguntas de consulta, así que sale en tu hoja de consulta.';

  @override
  String get askSaveAction => 'Guardar';

  @override
  String get askSaveNotNow => 'Ahora no';

  @override
  String get askSaveDone => 'Guardado en tu historial.';

  @override
  String askSaveNoteLine(String question, String answer) {
    return 'Pregunté a femio: «$question» Respuesta: $answer';
  }

  @override
  String askSaveNoteLineNoAnswer(String question) {
    return 'Pregunté a femio: «$question» (aún sin respuesta con fuentes)';
  }

  @override
  String get recTitle => 'Mi historial de salud';

  @override
  String get recIntro =>
      'Tu propio historial de salud, guardado en este teléfono. Cada entrada muestra el día en que ocurrió y el día en que la añadiste, tal como la escribiste.';

  @override
  String get recAll => 'Todo';

  @override
  String get recKindVisit => 'Consulta';

  @override
  String get recKindLab => 'Resultado de laboratorio';

  @override
  String get recKindImaging => 'Ecografía o imagen';

  @override
  String get recKindMedicine => 'Medicamento';

  @override
  String get recKindCondition => 'Afección o antecedente';

  @override
  String get recKindAllergy => 'Alergia';

  @override
  String get recKindProcedure => 'Procedimiento';

  @override
  String get recKindPregnancy => 'Embarazo';

  @override
  String get recKindDocument => 'Documento';

  @override
  String get recKindNote => 'Nota';

  @override
  String get recEmptyHeading => 'Aún no hay nada';

  @override
  String get recEmptyBody =>
      'Añade una consulta, un resultado, un medicamento o lo que quieras guardar. Las entradas se quedan en este teléfono y van en el archivo de copia que guardes.';

  @override
  String get recAdd => 'Añadir una entrada';

  @override
  String get recEdit => 'Editar la entrada';

  @override
  String get recSave => 'Guardar en mi historial';

  @override
  String get recCancel => 'Cancelar';

  @override
  String get recDelete => 'Eliminar';

  @override
  String get recDeleteTitle => '¿Eliminar esta entrada?';

  @override
  String get recDeleteBody =>
      'Se quita de este teléfono. Una copia que guardaste antes todavía la tiene.';

  @override
  String get recFormKind => 'Tipo';

  @override
  String get recFormTitle => 'Título';

  @override
  String get recFormTitleHint =>
      'Con tus palabras, como «TSH» o «ecografía de la semana 12»';

  @override
  String get recFormHappened => 'Día en que ocurrió';

  @override
  String get recFormHappenedHint =>
      'La fecha impresa en el informe, o el día de la consulta.';

  @override
  String get recNeedTitle => 'Añade un título';

  @override
  String get recNeedDate => 'Elige el día en que ocurrió';

  @override
  String get recFieldValue => 'Resultado';

  @override
  String get recFieldUnit => 'Unidad';

  @override
  String get recFieldPrintedRange => 'Rango impreso en el informe';

  @override
  String get recFieldDose => 'Dosis tal como está escrita';

  @override
  String get recFieldFrequency => 'Con qué frecuencia';

  @override
  String get recFieldStartedOn => 'Inicio';

  @override
  String get recFieldEndedOn => 'Fin';

  @override
  String get recFieldPrescriber => 'Recetado por';

  @override
  String get recFieldPlace => 'Dónde';

  @override
  String get recFieldDetails => 'Detalles';

  @override
  String recRowAdded(String date) {
    return 'Añadido el $date';
  }

  @override
  String get recEdited => 'Editada';

  @override
  String get recSourceTyped => 'Escrita';

  @override
  String get recSourceScanned => 'Escaneada';

  @override
  String get recSourceAsk => 'Desde Pregunta a femio';

  @override
  String get recSourceSayIt => 'Desde lo que contaste';

  @override
  String get recSourceImported => 'Importada';

  @override
  String get recNoVerdictNote =>
      'femio guarda y muestra tus entradas tal como las escribiste. Nunca dice si un resultado es normal: eso lo ves con tu profesional de salud.';

  @override
  String get addRecord => 'Mi historial de salud';

  @override
  String get addRecordSub => 'Consultas, resultados, medicamentos y documentos';

  @override
  String get logNoteSection => 'Nota';

  @override
  String get logNoteHint => 'Lo que quieras recordar de este día';

  @override
  String get logNoteSaved =>
      'Se guarda en este teléfono junto con el resto de tus registros.';

  @override
  String get csvColumnDate => 'Fecha';

  @override
  String get csvColumnOther => 'Otros';

  @override
  String get exportCsv => 'Exportar como hoja de cálculo (CSV)';

  @override
  String get csvNotEncrypted =>
      'A diferencia de la copia de seguridad, este archivo no está cifrado, así que guárdalo en un lugar privado.';

  @override
  String get csvSaved => 'Hoja de cálculo guardada.';

  @override
  String get csvNothingToExport =>
      'Aún no hay nada registrado, así que no hay nada que exportar.';

  @override
  String get widgetNeutralLine => 'Abrir femio';

  @override
  String widgetWeek(int weeks) {
    return 'Semana $weeks';
  }

  @override
  String widgetNextPeriod(String range) {
    return 'Próxima regla $range';
  }

  @override
  String get settingsWidgetDetails =>
      'Mostrar detalles en el widget de la pantalla de inicio';

  @override
  String get settingsWidgetDetailsNote =>
      'Cualquiera que vea tu teléfono podrá verlos. Hasta que lo actives, el widget solo muestra femio.';

  @override
  String get recDocsHeading => 'Documentos y fotos';

  @override
  String get recDocsAddFile => 'Añadir un archivo';

  @override
  String get recDocsTakePhoto => 'Hacer una foto';

  @override
  String get recDocsFromMine => 'De mis documentos';

  @override
  String get recDocsNote =>
      'Un PDF o una foto, de hasta 10 MB cada uno. Se guarda cifrado en este teléfono con el resto de tu historial.';

  @override
  String get recDocsTooLarge =>
      'Este archivo supera los 10 MB. Prueba con una copia más pequeña o con una foto de la página.';

  @override
  String get recDocsUnsupported =>
      'femio puede guardar PDF y fotos (JPG, PNG o WebP).';

  @override
  String recDocsPhotoName(String date) {
    return 'Foto del $date';
  }

  @override
  String get recDocsLibrary => 'Mis documentos';

  @override
  String get recDocsLibraryEmpty =>
      'Todavía no hay documentos. Añade un PDF o una foto desde cualquier entrada de tu historial.';

  @override
  String get recDocsChoose => 'Elige un documento';

  @override
  String recDocsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documentos',
      one: '1 documento',
    );
    return '$_temp0';
  }

  @override
  String get recDocRename => 'Cambiar el nombre';

  @override
  String get recDocRenameLabel => 'Nombre';

  @override
  String get recDocShare => 'Compartir';

  @override
  String get recDocShareFailed => 'No se pudo abrir el menú para compartir.';

  @override
  String get recDocUnlink => 'Quitar de esta entrada';

  @override
  String get recDocDelete => 'Eliminar el documento';

  @override
  String get recDocDeleteTitle => '¿Eliminar este documento?';

  @override
  String get recDocDeleteBody =>
      'Se elimina de femio y de todas las entradas a las que está adjunto. No se puede deshacer, salvo desde una copia de seguridad guardada antes.';

  @override
  String get recDocUnreadable => 'No se pudo abrir este documento.';

  @override
  String get recDocPdfUnreadable =>
      'Este PDF no se puede mostrar aquí. Puede que esté protegido con contraseña. Puedes compartirlo para abrirlo en otra aplicación.';

  @override
  String recDocSizeMb(String size) {
    return '$size MB';
  }

  @override
  String get recDocPrivate =>
      'Los documentos y fotos que añades se quedan en tu teléfono, cifrados como el resto de tu historial, y solo viajan dentro del archivo de copia de seguridad que guardas.';

  @override
  String get backupTooLarge =>
      'Tus documentos superan los 100 MB, más de lo que cabe en una copia de seguridad. Elimina algunos grandes en Mis documentos y vuelve a guardar la copia.';

  @override
  String get leaveShareHeading => 'Lo que compartes o exportas';

  @override
  String get leaveShareBody =>
      'Cuando compartes un documento o tus notas de la consulta, solo van a la aplicación que eliges en el menú para compartir. Si copias tus notas de la consulta, las guarda el portapapeles del teléfono. Una hoja de cálculo (CSV) que exportas va donde elijas guardarla, que puede ser una nube, y no está cifrada. Un informe sobre una respuesta de la IA contiene esa respuesta y va a la aplicación que eliges.';

  @override
  String recDocSizeKb(String size) {
    return '$size KB';
  }

  @override
  String get medTitle => 'Mis medicamentos';

  @override
  String get medIntro =>
      'Tus medicamentos tal como los escribiste, las horas en que los tomas y lo que marcaste. femio no da consejos de dosis ni revisa interacciones: pregunta a tu farmacéutico o a tu médico.';

  @override
  String get medAdd => 'Añadir un medicamento';

  @override
  String get medEmptyHeading => 'Aún no hay medicamentos';

  @override
  String get medEmptyBody =>
      'Añade uno desde una receta o una caja. Tú eliges las horas; femio puede recordártelo.';

  @override
  String get medCurrent => 'Tomando ahora';

  @override
  String get medFinished => 'Terminados';

  @override
  String get medToday => 'Hoy';

  @override
  String get medAsNeeded => 'Cuando lo necesite';

  @override
  String get medLogDose => 'Tomé una';

  @override
  String medTakenAt(String time) {
    return 'Tomada a las $time';
  }

  @override
  String medTakenLater(String time) {
    return 'Tomada a las $time, más tarde de lo previsto';
  }

  @override
  String get medSkippedAt => 'No tomada';

  @override
  String get medNotMarked => 'Sin marcar';

  @override
  String get medMarkTaken => 'Tomada ahora';

  @override
  String get medMarkTakenAt => 'Tomada a otra hora';

  @override
  String get medMarkSkipped => 'No la tomé';

  @override
  String get medMarkClear => 'Borrar la marca';

  @override
  String medDoseTitle(String name, String time) {
    return '$name a las $time';
  }

  @override
  String get medTimes => 'Horas en que lo tomas';

  @override
  String get medTimesNone =>
      'Sin horas fijas. Igual puedes marcar una dosis cuando la tomes.';

  @override
  String get medAddTime => 'Añadir una hora';

  @override
  String medRemoveTime(String time) {
    return 'Quitar $time';
  }

  @override
  String get medRemind => 'Recordarme a estas horas';

  @override
  String get medRemindNote =>
      'Una notificación a cada hora, y una el día antes de reponerlo. Dice «Abre la app», salvo que escribas tus propias palabras abajo.';

  @override
  String get medLabel => 'Palabras del recordatorio (opcional)';

  @override
  String get medLabelNote =>
      'Estas palabras aparecen en la notificación. Mantenlas vagas si otras personas ven tu teléfono.';

  @override
  String get medRefill => 'Reponer antes del';

  @override
  String get medRefillNone => 'Sin fecha';

  @override
  String get medRefillClear => 'Borrar la fecha de reposición';

  @override
  String medRefillSoon(String date) {
    return 'Reponer antes del $date';
  }

  @override
  String get medHistory => 'Últimos 14 días';

  @override
  String get medHistoryEmpty => 'Aún no has marcado nada.';

  @override
  String get medEdit => 'Editar detalles';

  @override
  String get medBlocked =>
      'femio no es una forma de evitar el embarazo, así que no guarda horas, marcas ni recordatorios para este medicamento. Queda en tu historial tal como lo escribiste.';

  @override
  String medSince(String date) {
    return 'Desde el $date';
  }

  @override
  String medUntil(String date) {
    return 'Hasta el $date';
  }

  @override
  String medEnded(String date) {
    return 'Terminó el $date';
  }

  @override
  String get medNoAdviceNote =>
      'femio guarda lo que escribes. No da consejos de dosis, de recuperación ni de interacciones: pregunta a tu farmacéutico o a tu médico.';

  @override
  String medTodayCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dosis por marcar hoy',
      one: '1 dosis por marcar hoy',
      zero: 'Todo marcado por hoy',
    );
    return '$_temp0';
  }

  @override
  String get reminderMedicineNote =>
      'A las horas que fijaste para cada medicamento, y el día antes de reponerlo.';

  @override
  String get patTitle => 'Patrones';

  @override
  String get patOpen => 'Ver mis patrones';

  @override
  String get patIntro =>
      'Recuentos de lo que registraste. femio muestra con qué frecuencia, nunca qué significa.';

  @override
  String get patCycleLength => 'Duración del ciclo';

  @override
  String patNeedCycles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Las duraciones aparecen tras 2 ciclos completos. Por ahora hay $count completos.',
      one: 'Las duraciones aparecen tras 2 ciclos completos. Por ahora hay 1 completo.',
      zero: 'Las duraciones aparecen tras 2 ciclos completos. Aún no hay ninguno completo.',
    );
    return '$_temp0';
  }

  @override
  String patRange(int count, int shortest, int longest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tus últimos $count ciclos: de $shortest a $longest días',
    );
    return '$_temp0';
  }

  @override
  String patDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get patVaries =>
      'La duración de tus ciclos varía más de 9 días, o uno duró menos de 24 o más de 38 días. Puede valer la pena mencionarlo en tu próxima consulta.';

  @override
  String get patVariesSource => 'Límites habituales: FIGO 2018.';

  @override
  String get patNoticed => 'Lo que más registras';

  @override
  String get patNeedLogged =>
      'Los recuentos aparecen tras 3 ciclos completos en los que registraste algo.';

  @override
  String patSeen(String term, String phase, int seen, int cycles) {
    return '$term $phase: $seen de $cycles ciclos';
  }

  @override
  String get patPhasePeriod => 'durante la regla';

  @override
  String get patPhaseBefore => 'en los 5 días antes de la regla';

  @override
  String get patByPhase => 'Por fase';

  @override
  String get patPhasePeriodShort => 'Durante la regla';

  @override
  String get patPhaseBeforeShort => '5 días antes';

  @override
  String patOf(int seen, int cycles) {
    return '$seen de $cycles';
  }

  @override
  String get patEachCycle => 'Cada ciclo';

  @override
  String patCycleFrom(String date) {
    return 'Desde el $date';
  }

  @override
  String patDaysLogged(int count) {
    return 'Días registrados: $count';
  }

  @override
  String patOpkDays(int count) {
    return 'Prueba de ovulación alta o positiva: $count';
  }

  @override
  String patTemps(int count) {
    return 'Temperaturas: $count';
  }

  @override
  String get patRecent => 'Últimos 90 días';

  @override
  String get patEmpty =>
      'Aún no has registrado nada. Los patrones salen de tu registro.';

  @override
  String get patNoVerdict =>
      'Son recuentos de lo que registraste. No dicen la causa ni si algo va mal. Llévalos a tu profesional de salud si te sirven.';

  @override
  String get signsDaysTitle => 'Signos por día del ciclo';

  @override
  String get signsDaysOpen => 'Ver por día del ciclo';

  @override
  String signsDaysCurrent(String date) {
    return 'Este ciclo, desde el $date';
  }

  @override
  String signsDaysPast(String date, String days) {
    return 'Ciclo desde el $date, $days';
  }

  @override
  String get signsDaysEarlier => 'Ciclo anterior';

  @override
  String get signsDaysLater => 'Ciclo siguiente';

  @override
  String get signsDaysBleeding => 'Sangrado';

  @override
  String get signsDaysLogged => 'Registrado';

  @override
  String get signsDaysCycleDay => 'Día del ciclo';

  @override
  String signsDaysDay(int day, String date) {
    return 'Día $day del ciclo, $date';
  }

  @override
  String get signsDaysNothing => 'No registraste nada este día.';

  @override
  String get signsDaysHint => 'Toca un día para ver lo que registraste.';

  @override
  String get signsDaysEmpty =>
      'Aún no has registrado nada en este ciclo. Las temperaturas, pruebas de ovulación y flujo que registres aparecen aquí día a día.';

  @override
  String get signsDaysNoCycle =>
      'Registra el primer día de tu regla y tus signos se ordenarán aquí por día del ciclo.';

  @override
  String get signsDaysFill =>
      'Cuanto más llena la marca, más avanzada tu elección en la lista: de negativa a positiva en las pruebas, de seco a clara de huevo en el flujo.';

  @override
  String get listSeparator => ', ';

  @override
  String get ppGuideEyebrow => 'La guía de recuperación de esta semana';

  @override
  String get ppRead => 'Leer la guía';

  @override
  String get ppMoodTitle => '¿Cómo te sientes hoy?';

  @override
  String get ppMoodNote =>
      'Tener ganas de llorar las dos primeras semanas es frecuente y suele pasar. El ánimo bajo, la ansiedad o la sensación de vacío que dura más de dos semanas merece contárselo a tu profesional de salud, y puedes preguntar antes.';

  @override
  String get ppMoodCrisis =>
      'Si tienes pensamientos de hacerte daño o de hacerle daño a tu bebé, pide ayuda ahora.';

  @override
  String get ppMoodGuide => 'El ánimo después del parto';

  @override
  String get ppPeriodBack => '¿Te ha vuelto la regla?';

  @override
  String get ppPeriodBackBody =>
      'femio no adivina cuándo vuelve la regla. Cuando vuelva la tuya, indica a femio el primer día y tus rangos de ciclo empezarán de nuevo desde ahí.';

  @override
  String get ppPeriodBackAction => 'Me ha vuelto la regla';

  @override
  String get ppPeriodBackPick => 'Primer día de tu regla';

  @override
  String get ppNextGoal => '¿Con qué quieres que te ayude femio ahora?';

  @override
  String get ppBleedingSection => 'Sangrado después del parto';

  @override
  String get ppBleedingNote =>
      'Es el sangrado de recuperación después del parto, no una regla. femio lo deja fuera de tus rangos de ciclo. Un sangrado muy abundante o coágulos grandes necesitan atención de inmediato.';

  @override
  String get ppWarnMore => 'Ver todas las señales de alarma después del parto';

  @override
  String get ppHadBaby => 'Ya nació mi bebé';

  @override
  String get ppHadBabyNote =>
      'femio conserva tu registro del embarazo y pasa a la vista después del parto.';

  @override
  String menoNextRange(String range) {
    return 'Si llega otra regla, podría empezar hacia $range.';
  }

  @override
  String get menoRangeNote =>
      'Los ciclos suelen cambiar en los años antes de la menopausia, así que este rango es amplio. La menopausia se identifica tras 12 meses sin regla.';

  @override
  String get menoBleedHeading => 'Sangrado tras un año sin regla';

  @override
  String get menoBleedBody =>
      'Registraste un sangrado tras 12 meses o más sin regla. El sangrado después de la menopausia siempre debe revisarlo un médico, aunque ocurra una sola vez. Pide cita pronto.';

  @override
  String get menoBleedLogNote =>
      'Cualquier sangrado tras 12 meses sin regla siempre debe revisarlo un médico, aunque sea una vez.';

  @override
  String get menoBleedMore => 'El sangrado después de la menopausia';

  @override
  String get patMonthly => 'Días registrados cada mes';

  @override
  String get visitMedicines => 'Medicamentos que tomo ahora';

  @override
  String get gapNoPeriodBody =>
      'Cuando empiece tu regla, toca ese día en el calendario para registrarlo. Después, femio muestra cuándo podrían llegar las siguientes.';

  @override
  String get gapNeedLengthBody =>
      'Elegiste «No estoy segura» para la duración de tu ciclo, así que femio todavía no tiene desde dónde contar. Añade tu duración habitual o registra tu próxima regla y femio la aprenderá de tus fechas.';

  @override
  String get gapNeedAnotherBody =>
      'Dijiste que tus ciclos varían, o los intervalos que registraste son demasiado largos para ser ciclos. Cuando empiece tu próxima regla, regístrala y femio mostrará un rango a partir de tus propias fechas.';

  @override
  String get gapPassedTitle => 'El rango que mostró femio ya pasó';

  @override
  String get gapPassedBody =>
      'Si tu regla ya empezó, regístrala y femio mostrará las siguientes. Si no ha llegado y podrías estar embarazada, una prueba de embarazo te lo puede decir.';

  @override
  String get absentTitle => 'Hace tiempo que no te viene la regla';

  @override
  String get absentBody =>
      'Si puedes estar embarazada, una prueba de embarazo es el primer paso. Si llevas 3 meses sin regla, plantéate una revisión con un profesional sanitario. Si tus ciclos ya eran irregulares, las guías hablan de 6 meses. Consulta antes si algún síntoma te preocupa o no te encuentras bien.';

  @override
  String get absentSource =>
      'Fuente: ASRM, Current evaluation of amenorrhea (2024).';

  @override
  String get gapAddLength => 'Añadir la duración habitual de mi ciclo';

  @override
  String get gapSaveLength => 'Guardar';

  @override
  String get upcomingPeriodsOnlyNextStated =>
      'Solo se muestra la próxima regla porque dijiste que tus ciclos son irregulares.';

  @override
  String calendarNextPeriodLink(String range) {
    return 'Próxima regla: $range';
  }

  @override
  String get aiChipNano => 'Gemini Nano · en este teléfono';

  @override
  String get aiChipRules => 'En este teléfono · reglas de femio';

  @override
  String get aiChipOff => 'IA desactivada · reglas y guías activas';

  @override
  String get aiChipCloud => 'Cloud boost activado';

  @override
  String get aiChipHint =>
      'Cómo funciona la IA de femio. Abre los ajustes del asistente.';

  @override
  String get tipsOrderedNano =>
      'Ordenados por Gemini Nano en este teléfono, a partir de tu registro. Cada consejo es una frase revisada, con su fuente.';

  @override
  String get sayItCheckedNano =>
      'Gemini Nano, en este teléfono, también leyó tus palabras y no encontró nada más que añadir.';

  @override
  String get visitOrderedNano => 'Ordenadas por Gemini Nano en este teléfono.';

  @override
  String get settingsStageTitle => 'En qué te ayuda femio';

  @override
  String get settingsStageSub =>
      'Cambia tu etapa, tu fecha probable de parto o tus respuestas sobre el ciclo. Todo lo que registraste se conserva.';

  @override
  String get saveFailedTitle => 'No se guardó en este teléfono';

  @override
  String get saveFailedBody =>
      'No se pudo guardar tu último cambio. Tus registros anteriores están a salvo. Libera espacio en el teléfono y vuelve a intentarlo.';

  @override
  String get saveFailedRetry => 'Reintentar';
}
