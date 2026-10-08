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
      'Tus datos se quedan en este teléfono. Sin cuenta, y Femio nunca los ve.';

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
  String get goalPeriodDesc => 'Saber cuándo llega y qué es normal para ti.';

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
      'Los ciclos cambian con la edad, así Femio sabe qué esperar. Solo el año.';

  @override
  String get under18Title => 'El seguimiento es para adultas, por ahora';

  @override
  String get under18Body =>
      'En esta primera versión, el seguimiento de Femio es para mujeres de 18 años o más. Todas las guías de femioapp.com están abiertas para ti, sin cuenta.';

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
    return 'Ovulación probable: $date';
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
      'Tus ciclos varían, así que Femio muestra un rango más amplio y nunca cuenta días de retraso.';

  @override
  String get noPredictionTitle => 'Registra tu próxima regla';

  @override
  String get noPredictionBody =>
      'Cuando empiece tu regla, regístrala y Femio predecirá la siguiente.';

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
      'Registra cualquier sangrado o síntoma y Femio guarda el registro para tu profesional sanitario.';

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
      'Toca un día para registrarlo. Las estimaciones van con contorno; lo que registras aparece relleno.';

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
    return 'Si para el $date tu regla aún no ha empezado, una prueba de embarazo casera es fiable desde ese día.';
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
      'Son tus mediciones, tal cual. Femio no marca ningún cambio ni señala ningún día — lo que significa una gráfica se habla contigo y tu profesional.';

  @override
  String get invalidBbt =>
      'Eso no parece una lectura de termómetro. Revisa el número e inténtalo de nuevo.';

  @override
  String get testTimingGeneral =>
      'La mayoría de las pruebas caseras funcionan desde el primer día de retraso de la regla. Hacerla antes puede dar negativo aunque estés embarazada.';

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
      'El sangrado, el dolor de cabeza intenso, los cambios en la visión, el dolor abdominal fuerte o los movimientos reducidos deben revisarse de inmediato. Contacta con tu unidad de maternidad o con los servicios de emergencia locales — no esperes.';

  @override
  String get contractionsHeading => 'Cronómetro de contracciones';

  @override
  String get contractionsIntro =>
      'Pulsa empezar cuando comience una y parar cuando afloje. Femio guarda los tiempos para que los tengas cuando llames.';

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
      'Son tus tiempos, tal como se registraron. Femio no decide qué significan — léeselos a tu matrona o a la maternidad, que sí pueden.';

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
}
