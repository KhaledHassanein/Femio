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
      'Los ciclos cambian con la edad, así femio sabe qué esperar. Solo el año.';

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
      'Busca atención ahora si tienes dolor de cabeza intenso, cambios en la visión, dolor en la parte alta del abdomen, hinchazón de la cara o las manos, dificultad para respirar, sangrado vaginal, o si los movimientos de tu bebé han disminuido, se han detenido o han cambiado. Contacta con tu unidad de maternidad o los servicios de emergencia locales. Si no puedes contactarlos, acude al servicio de urgencias más cercano.';

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
      'Tus registros se quedan en este teléfono. femio no tiene cuenta ni servidor, y no puede ver lo que introduces.';

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
      'Un recordatorio solo dice «femio: Abre la app». Nada sobre tu salud aparece en la pantalla de bloqueo.';

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
      'Recordatorios que activaste en femio. Nunca mencionan tu salud.';

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
      'Esto ocurre en tu teléfono. Tus palabras no se guardan ni se envían.';

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
      'En el año después del parto, la campaña Hear Her de los CDC dice que busques atención médica de inmediato ante una señal de alerta urgente, como sangrado abundante, fiebre, un dolor de cabeza que no se quita o una pierna hinchada. Llama ahora a tu médico o matrona, o al número de emergencias.';

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
      'Solo se envían esta pregunta y las fuentes públicas. Nada de tu registro.';

  @override
  String get askSearching => 'Leyendo fuentes fiables…';

  @override
  String get askSourcesTitle => 'Fuentes';

  @override
  String get askClinicianLine =>
      'Esto es información general, no un consejo para ti. Para tu situación, habla con tu profesional sanitario.';

  @override
  String get askRelatedGuides => 'Guías de femio sobre esto';

  @override
  String get askSearchAgain => 'Hacer otra pregunta';

  @override
  String get askAboutYouStays =>
      'Tu pregunta habla de ti, así que se queda en este teléfono. Aquí tienes las fuentes palabra por palabra.';

  @override
  String get askModelFellBack =>
      'La IA no pudo escribir una respuesta que cite sus fuentes, así que aquí están palabra por palabra.';

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
      'Una página para mostrar a tu profesional sanitario, hecha con lo que registraste. Se queda en tu teléfono salvo que la copies.';

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
      'Lista. Lee tus notas en el teléfono; no se envía nada.';

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
      'Tus notas, fechas, registros, duración de ciclos, tu nombre, tu correo, tus contactos ni tu ID de publicidad.';

  @override
  String get boostTurnOff => 'Desactivar Cloud boost';

  @override
  String get boostNotNow => 'Ahora no';

  @override
  String get boostAgreeQuestions =>
      'Acepto que femio envíe una pregunta general que yo apruebe, una cada vez, con las fuentes públicas que encontró, para que la IA en la nube de Google las resuma. femio quita antes los números, las fechas, los nombres y los contactos, y veo el texto exacto antes de que se envíe.';

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
  String get toolBandUnderweight => 'Bajo peso';

  @override
  String get toolBandNormal => 'Rango saludable';

  @override
  String get toolBandOverweight => 'Sobrepeso';

  @override
  String get toolBandObese => 'Obesidad';

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
      'Tus registros se quedan en este teléfono. Estas son las únicas veces que femio, o los servicios de Google de los que depende, usan internet.';

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
      'Si tocas Descargar, el servicio de IA de Android (AICore, gestionado por Google) descarga Gemini Nano y lo mantiene actualizado. El software de IA de Google también puede enviar a Google información técnica, como errores y rendimiento. femio no añade ninguno de tus registros.';

  @override
  String get leavePlayHeading => 'Google Play';

  @override
  String get leavePlayBody =>
      'Google Play instala y actualiza femio, puede mostrar su solicitud de valoración y gestiona los pagos de femio Plus. Solo nos da totales, como instalaciones y fallos. femio no envía a Google Play nada tuyo.';

  @override
  String get leaveBackupHeading => 'Tu copia de seguridad';

  @override
  String get leaveBackupBody =>
      'Una copia de seguridad va solo donde eliges guardarla, sellada con tu frase de contraseña.';

  @override
  String get leaveLinksHeading => 'Los enlaces que abres';

  @override
  String get leaveLinksBody =>
      'Las fuentes y páginas que abres van a tu navegador, que visita ese sitio web.';

  @override
  String get leaveNever =>
      'No sale nada más. femio no tiene anuncios, ni analíticas, ni herramientas de seguimiento, ni cuenta.';

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
}
