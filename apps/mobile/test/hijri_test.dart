// Hijri display dates: the cases the golden fixture cannot express (edges, bad input,
// the other languages). The fixture (golden_fixtures_test.dart, hijri.json) proves the
// app and the website print the same day; these prove the function fails quietly.

import 'package:femio/domain/hijri.dart';
import 'package:femio/domain/hijri_months.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a known day: 27 Oct 2026 is in Jumada I 1448 AH', () {
    final h = hijriDate('2026-10-27')!;
    expect((h.month, h.year), (5, 1448));
    expect(hijriDay('2026-10-27'), h.day.toString());
  });

  test('the day is plain Western digits with no padding', () {
    expect(hijriDay('2024-01-01'), '19');
    expect(hijriDay('2024-01-20'), '8');
  });

  test('anything unusable gives an empty label, never an exception', () {
    expect(hijriDay('not-a-date'), '');
    expect(hijriDay('2026-02-30'), '');
    expect(hijriDay('1900-01-01'), ''); // before the table
    expect(hijriDay('2078-01-01'), ''); // after the table
    expect(hijriMonthLine('2026-10-01', 'nope', 'ar'), '');
  });

  test('the table is well formed: months of 29 or 30 days, in order', () {
    for (var i = 1; i < hijriMonthStarts.length; i++) {
      final length = hijriMonthStarts[i] - hijriMonthStarts[i - 1];
      expect(length, inInclusiveRange(29, 30), reason: 'month index ${i - 1}');
    }
    expect(hijriMonthStarts.length, (1501 - hijriFirstYear) * 12 + 1);
  });

  test('every day of a long run advances by one, or restarts the month at 1', () {
    var day = '2026-01-01';
    var previous = hijriDate(day)!;
    for (var i = 0; i < 800; i++) {
      day = _next(day);
      final h = hijriDate(day)!;
      if (h.day == 1) {
        expect(previous.day, inInclusiveRange(29, 30));
      } else {
        expect(h.day, previous.day + 1);
      }
      previous = h;
    }
  });

  group('month line', () {
    test('Arabic, two months', () {
      expect(hijriMonthLine('2026-10-01', '2026-10-31', 'ar'), 'ربيع الآخر – جمادى الأولى 1448 هـ');
    });

    test('a locale tag resolves to its language', () {
      expect(hijriMonthLine('2026-10-01', '2026-10-31', 'ar-u-nu-latn'), hijriMonthLine('2026-10-01', '2026-10-31', 'ar'));
    });

    test('English, French and Spanish use their own names and AH', () {
      expect(hijriMonthLine('2026-10-01', '2026-10-31', 'en'), 'Rabiʻ II – Jumada I 1448 AH');
      expect(hijriMonthLine('2026-10-01', '2026-10-31', 'fr'), 'Rabia ath-thani – Joumada al oula 1448 AH');
      expect(hijriMonthLine('2026-10-01', '2026-10-31', 'es'), 'Rabiʻ II – Jumada I 1448 AH');
    });

    test('one Hijri month shows once; an unknown language falls back to English', () {
      expect(hijriMonthLine('2026-10-27', '2026-10-28', 'en'), 'Jumada I 1448 AH');
      expect(hijriMonthLine('2026-10-27', '2026-10-28', 'xx'), 'Jumada I 1448 AH');
    });
  });
}

String _next(String iso) {
  final d = DateTime.parse('${iso}T00:00:00Z').add(const Duration(days: 1));
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d.year}-${two(d.month)}-${two(d.day)}';
}
