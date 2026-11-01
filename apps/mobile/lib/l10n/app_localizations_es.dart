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
    return 'Si para el $date tu regla aún no ha empezado, la mayoría de las pruebas de embarazo caseras pueden dar un resultado preciso desde ese día.';
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
  String get apptFormType => 'Qué es';

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
  String get recoveryTitle => 'femio no puede abrir tus registros ahora';

  @override
  String get recoveryBody =>
      'Tus registros están guardados en este teléfono y no se ha borrado ni cambiado nada. Puede ocurrir tras una actualización del teléfono, un cambio en el bloqueo de pantalla o una restauración. Volver a intentarlo suele funcionar.';

  @override
  String get recoveryTryAgain => 'Intentar de nuevo';

  @override
  String get recoveryStillClosed =>
      'Sigue sin poder abrirse. No se ha cambiado nada en tu teléfono.';

  @override
  String get recoveryRestoreNote =>
      '¿Tienes un archivo de copia de seguridad guardado antes? Puedes restaurarlo aquí.';

  @override
  String get recoveryActionFailed =>
      'No funcionó, y no se ha cambiado nada en tu teléfono. Inténtalo de nuevo.';

  @override
  String get recoveryStartFresh => 'Empezar con femio vacío';

  @override
  String get recoveryFreshTitle => '¿Empezar con femio vacío?';

  @override
  String get recoveryFreshBody =>
      'femio se abrirá sin registros. Tu archivo anterior no se borra: se queda en este teléfono, apartado. Puedes restaurar un archivo de copia de seguridad más tarde desde Ajustes.';

  @override
  String get recoveryFreshConfirm => 'Empezar vacío';

  @override
  String get recoveryFreshCancel => 'Ahora no';

  @override
  String get saveFailedBanner =>
      'femio no pudo guardar tu último cambio en este teléfono. Tus registros anteriores están a salvo. Inténtalo de nuevo y guarda un archivo de copia de seguridad en cuanto puedas.';

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
      'Guías con fuentes, en palabras sencillas. Primero concebir y el embarazo; todo se queda aquí.';

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
      'Tus ciclos varían demasiado para nombrar días fértiles a partir de una fecha. Registrar tus reglas, tus tests de ovulación y tu temperatura al despertar es cómo saberlo después.';

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
  String calendarDayStates(String date, String states) {
    return '$date, $states';
  }

  @override
  String get calendarStateToday => 'hoy';

  @override
  String get calendarStatePeriod => 'día de regla';

  @override
  String get calendarStateSpotting => 'manchado';

  @override
  String get calendarStatePredicted => 'la regla puede empezar (estimación)';

  @override
  String get calendarStateFertile => 'ventana fértil (estimación)';

  @override
  String get calendarStateOvulation => 'ovulación probable (estimación)';

  @override
  String get calendarStateLogged => 'algo registrado';

  @override
  String get a11yListSeparator => ', ';

  @override
  String get onboardingProgress => 'Progreso';

  @override
  String get adLabel => 'Publicidad';

  @override
  String get adsNotice =>
      'Los anuncios aparecen solo en las pantallas de las guías y los sirve Google. Google recibe tu identificador publicitario, tu dirección de internet y cómo usas el anuncio, nunca tus registros. femio Plus los eliminará.';

  @override
  String pregTermWindow(String due, String start, String end) {
    return 'Fecha probable de parto alrededor del $due · la mayoría de los bebés nacen entre el $start y el $end';
  }

  @override
  String get pregPastTerm =>
      'Según esta fecha prevista, llevas más de 42 semanas. Habla de tus fechas con tu matrona o tu médica.';

  @override
  String get settingsMyDetails => 'Mis datos';

  @override
  String get settingsGoal => 'Tu objetivo';

  @override
  String get settingsGoalNote =>
      'Cambiar tu objetivo cambia lo que muestra femio. Tus registros se quedan exactamente como están.';

  @override
  String get settingsDueDate => 'Fecha probable de parto';

  @override
  String get saveLabel => 'Guardar';

  @override
  String get undoAction => 'Deshacer';

  @override
  String get privacyPolicyTitle => 'Política de privacidad';

  @override
  String get privacyPolicySubtitle =>
      'Cómo trata femio tu información. Abre femioapp.com en tu navegador.';

  @override
  String get privacyPolicyOpenFailed =>
      'femio no pudo abrir tu navegador. Copia esta dirección y ábrela en tu navegador.';

  @override
  String get copyLabel => 'Copiar';

  @override
  String get closeLabel => 'Cerrar';
}
