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
  String get dueMethodTitle => '¿Cómo calculamos tu fecha de parto?';

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
    return 'Próxima regla hacia $range';
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
  String get basisStated => 'Según la duración de ciclo que nos indicaste';

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
    return 'Fecha de parto hacia el $date';
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
      'Llevar más de un año intentándolo (o seis meses si tienes 35 o más) es buen momento para hablar con un profesional.';

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
}
