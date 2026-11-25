// The day words behind "Say it, several days in one note" (ADR-078, R10.7).
//
// Why it exists: `say_it_days.dart` cuts a note into days; this file knows what counts as a
// day word. It holds the tables (today, yesterday, the day before yesterday, "2 days ago",
// weekday names, numeric dates) in English, Egyptian and Gulf Arabic, French and Spanish, and
// the one function that reads the day word starting at a given word. Pure Dart, no state;
// every date is an ISO `YYYY-MM-DD` string relative to a `today` it is given.

import '../dates.dart';
import 'text_normal.dart';

/// How many days before today a day word may reach.
const sayItMaxDaysBack = 7;

/// Why part of a note was left out.
enum SayItRefusal {
  /// The day word names a day after today.
  future,

  /// The day word names a day more than [sayItMaxDaysBack] days back.
  tooOld,
}


enum DayWordKind { day, ignored }

/// One day word found in the text: where it sits and what it names. [date] is set for a day
/// she may log, [refusal] for one that is left out, and [kind] is `ignored` for text that
/// looked like a date but is not a day word (so it is simply skipped).
class DayWordHit {
  const DayWordHit(this.start, this.end, {this.date, this.refusal, this.kind = DayWordKind.day});
  final int start;
  final int end;
  final String? date;
  final SayItRefusal? refusal;
  final DayWordKind kind;
}

/// What a numeric date in the text names.
class DateWord {
  const DateWord({this.date, this.refusal});
  final String? date;
  final SayItRefusal? refusal;
}

final _dateToken = RegExp(r'^xdate(\d+)$');

/// ISO dates, and day/month with an optional year, with `/`, `-` or `.` between the numbers.
final dayDatePattern = RegExp(
  r'(?<![\d])(\d{4})-(\d{1,2})-(\d{1,2})(?![\d])|(?<![\d.\-/])(\d{1,2})[/.\-](\d{1,2})(?:[/.\-](\d{2,4}))?(?![\d])',
);

const _arabicIndic = '٠١٢٣٤٥٦٧٨٩';
const _persianIndic = '۰۱۲۳۴۵۶۷۸۹';

String foldDigits(String s) {
  final b = StringBuffer();
  for (final r in s.runes) {
    final c = String.fromCharCode(r);
    final a = _arabicIndic.indexOf(c);
    final p = _persianIndic.indexOf(c);
    b.write(a >= 0 ? '$a' : (p >= 0 ? '$p' : c));
  }
  return b.toString();
}

/// Reads one numeric date match; null when it is not a real date or not a day word (see the
/// file header for why a yearless date outside the last 7 days is skipped).
DateWord? dateWordOf(Match m, String today) {
  int? n(int g) => m.group(g) == null ? null : int.tryParse(m.group(g)!);
  String? iso(int y, int mo, int d) {
    if (mo < 1 || mo > 12 || d < 1 || d > 31) return null;
    final s = '${y.toString().padLeft(4, '0')}-${mo.toString().padLeft(2, '0')}-${d.toString().padLeft(2, '0')}';
    return isValidISODate(s) ? s : null;
  }

  DateWord named(String s) {
    final back = diffDays(s, today);
    if (back < 0) return const DateWord(refusal: SayItRefusal.future);
    if (back > sayItMaxDaysBack) return const DateWord(refusal: SayItRefusal.tooOld);
    return DateWord(date: s);
  }

  if (m.group(1) != null) {
    final s = iso(n(1)!, n(2)!, n(3)!);
    return s == null ? null : named(s);
  }
  final a = n(4)!;
  final b = n(5)!;
  final yearText = m.group(6);
  if (yearText != null) {
    var y = int.parse(yearText);
    if (yearText.length <= 2) y += 2000;
    if (yearText.length == 3) return null;
    final s = iso(y, b, a) ?? iso(y, a, b);
    return s == null ? null : named(s);
  }
  // No year: day first, else month first; the year is the one that puts it nearest today.
  final todayYear = fromISO(today).year;
  for (final (mo, d) in [(b, a), (a, b)]) {
    for (final y in [todayYear, todayYear - 1, todayYear + 1]) {
      final s = iso(y, mo, d);
      if (s == null) continue;
      final back = diffDays(s, today);
      if (back < 0 && back >= -sayItMaxDaysBack) return const DateWord(refusal: SayItRefusal.future);
      if (back >= 0 && back <= sayItMaxDaysBack) return DateWord(date: s);
    }
  }
  return null;
}

/// Words that carry no symptom and no day: they do not make a piece "about" something.
const dayConnectors = <String>{
  'and', 'on', 'at', 'in', 'the', 'a', 'an', 'since', 'then', 'also', 'so', 'but', 'plus', 'i', 'had', 'have',
  'was', 'felt', 'feel', 'me', 'my', 'last', 'of', 'y', 'e', 'et', 'el', 'la', 'le', 'les', 'j', 'ai',
  'eu', 'tuve', 'tenia', 'pasado', 'dernier', 'و', 'في', 'ثم', 'يوم', 'بعدين', 'وبعدين', 'عندي', 'كان',
  'كنت', 'انا', 'فيه', 'من',
};

/// Day words as natural spellings; normalised when the table is built. Longest first.
const _dayWords = <(String, int)>[
  // Today
  ('today', 0), ('tonight', 0), ('this morning', 0), ('this afternoon', 0), ('this evening', 0),
  ("aujourd'hui", 0), ('ce matin', 0), ('ce soir', 0), ('hoy', 0), ('esta mañana', 0), ('esta noche', 0),
  ('esta tarde', 0), ('اليوم', 0), ('النهارده', 0), ('النهاردة', 0), ('انهارده', 0), ('الليلة', 0),
  // Yesterday
  ('yesterday', -1), ('last night', -1), ('hier', -1), ('hier soir', -1), ('ayer', -1), ('anoche', -1),
  ('امبارح', -1), ('مبارح', -1), ('أمس', -1), ('امس', -1), ('البارحة', -1),
  // The day before yesterday
  ('day before yesterday', -2), ('avant-hier', -2), ('anteayer', -2), ('antier', -2), ('antes de ayer', -2),
  ('أول امبارح', -2), ('اول مبارح', -2), ('أول أمس', -2), ('قبل البارحة', -2), ('قبل يومين', -2),
  // Not yet happened: refused, never logged
  ('tomorrow', 1), ('demain', 1), ('بكره', 1), ('بكرة', 1), ('بكرا', 1), ('غدا', 1), ('الغد', 1),
  ('day after tomorrow', 2), ('après-demain', 2), ('pasado mañana', 2), ('بعد بكره', 2), ('بعد بكرة', 2), ('بعد غد', 2),
];

/// Weekday names to `DateTime.weekday` (Monday 1 ... Sunday 7).
const _weekdays = <(String, int)>[
  ('monday', 1), ('tuesday', 2), ('wednesday', 3), ('thursday', 4), ('friday', 5), ('saturday', 6), ('sunday', 7),
  ('lundi', 1), ('mardi', 2), ('mercredi', 3), ('jeudi', 4), ('vendredi', 5), ('samedi', 6), ('dimanche', 7),
  ('lunes', 1), ('martes', 2), ('miércoles', 3), ('jueves', 4), ('viernes', 5), ('sábado', 6), ('domingo', 7),
  ('الاثنين', 1), ('الاتنين', 1), ('الثلاثاء', 2), ('الثلاثا', 2), ('التلات', 2), ('الاربعاء', 3), ('الاربعا', 3),
  ('الخميس', 4), ('الجمعة', 5), ('السبت', 6), ('الأحد', 7), ('الحد', 7),
];

const _numberWords = <String, int>{
  'one': 1, 'two': 2, 'three': 3, 'four': 4, 'five': 5, 'six': 6, 'seven': 7, 'eight': 8, 'nine': 9, 'ten': 10,
  'un': 1, 'une': 1, 'deux': 2, 'trois': 3, 'quatre': 4, 'cinq': 5, 'sept': 7, 'huit': 8, 'neuf': 9, 'dix': 10,
  'uno': 1, 'dos': 2, 'tres': 3, 'cuatro': 4, 'cinco': 5, 'seis': 6, 'siete': 7, 'ocho': 8, 'nueve': 9, 'diez': 10,
  'ثلاث': 3, 'ثلاثه': 3, 'اربع': 4, 'اربعه': 4, 'خمس': 5, 'خمسه': 5, 'ست': 6, 'سته': 6, 'سبع': 7, 'سبعه': 7,
  'ثمان': 8, 'ثمانيه': 8, 'تسع': 9, 'تسعه': 9, 'عشر': 10, 'عشره': 10,
};

final List<(List<String>, int)> _dayTable = () {
  final t = [for (final (p, o) in _dayWords) (words(p), o)];
  t.sort((a, b) => b.$1.length.compareTo(a.$1.length));
  return t;
}();

final List<(List<String>, int)> _weekdayTable = [for (final (p, d) in _weekdays) (words(p), d)];

/// Words that, before "mañana", make it mean "morning" and not "tomorrow".
const _morningCues = {'la', 'esta', 'de', 'por', 'en', 'cada', 'toda', 'una', 'ma'};

/// A word equals [target], or [target] with Arabic "and" (و) or "so" (ف) glued on the front.
bool _eq(String word, String target) =>
    word == target || (word.length > target.length && (word[0] == 'و' || word[0] == 'ف') && word.substring(1) == target);

bool _phraseAt(List<String> flat, int i, List<String> phrase) {
  if (i + phrase.length > flat.length) return false;
  for (var j = 0; j < phrase.length; j++) {
    final ok = j == 0 ? _eq(flat[i], phrase[j]) : flat[i + j] == phrase[j];
    if (!ok) return false;
  }
  return true;
}

int? _count(String w) => int.tryParse(w) ?? _numberWords[w];

DayWordHit _back(int start, int end, int days, String today) {
  if (days > sayItMaxDaysBack) return DayWordHit(start, end, refusal: SayItRefusal.tooOld);
  return DayWordHit(start, end, date: addDays(today, -days));
}

/// The day word starting at [flat] index [i], or null. Numbered phrases come first, then
/// the plain day words (longest first), then weekdays.
DayWordHit? dayWordAt(List<String> flat, int i, String today, List<DateWord> dates) {
  final w = flat[i];
  final dateMatch = _dateToken.firstMatch(w);
  if (dateMatch != null) {
    final d = dates[int.parse(dateMatch.group(1)!)];
    if (d.date == null && d.refusal == null) return DayWordHit(i, i + 1, kind: DayWordKind.ignored);
    return DayWordHit(i, i + 1, date: d.date, refusal: d.refusal);
  }
  String? at(int k) => i + k < flat.length ? flat[i + k] : null;

  // "2 days ago", "a day ago"
  final n0 = w == 'a' ? 1 : _count(w);
  if (n0 != null && (at(1) == 'day' || at(1) == 'days') && at(2) == 'ago') return _back(i, i + 3, n0, today);
  // "il y a 2 jours"
  if (w == 'il' && at(1) == 'y' && at(2) == 'a') {
    final n = at(3) == null ? null : _count(at(3)!);
    if (n != null && (at(4) == 'jour' || at(4) == 'jours')) return _back(i, i + 5, n, today);
  }
  // "hace 2 dias"
  if (w == 'hace') {
    final n = at(1) == null ? null : _count(at(1)!);
    if (n != null && (at(2) == 'dia' || at(2) == 'dias')) return _back(i, i + 3, n, today);
  }
  // "قبل 3 ايام", "قبل يوم"
  if (_eq(w, 'قبل')) {
    final n = at(1) == null ? null : _count(at(1)!);
    if (n != null && (at(2) == 'ايام' || at(2) == 'يوم')) return _back(i, i + 3, n, today);
    if (at(1) == 'يوم') return _back(i, i + 2, 1, today);
  }

  // "mañana" alone is tomorrow; after "la", "esta", "de"... it is the morning.
  if (w == 'manana' && (i == 0 || !_morningCues.contains(flat[i - 1]))) {
    return DayWordHit(i, i + 1, refusal: SayItRefusal.future);
  }
  for (final (phrase, offset) in _dayTable) {
    if (!_phraseAt(flat, i, phrase)) continue;
    final end = i + phrase.length;
    if (offset > 0) return DayWordHit(i, end, refusal: SayItRefusal.future);
    return DayWordHit(i, end, date: addDays(today, offset));
  }
  for (final (phrase, weekday) in _weekdayTable) {
    if (!_phraseAt(flat, i, phrase)) continue;
    final back = (fromISO(today).weekday - weekday + 7) % 7;
    return DayWordHit(i, i + phrase.length, date: addDays(today, -back));
  }
  return null;
}
