import 'package:femio/domain/dates.dart';
import 'package:flutter_test/flutter_test.dart';

/// `toISO` names the calendar day a DateTime carries. Date pickers hand back local
/// midnight; reading that through UTC shifted every picked date a day earlier east of
/// UTC (found 2026-10-27 on a UTC+3 machine). These hold in any time zone.
void main() {
  test('a picked local date keeps its day', () {
    expect(toISO(DateTime(2026, 10, 1)), '2026-10-01');
    expect(toISO(DateTime(2026, 10, 1, 23, 59)), '2026-10-01');
  });

  test('a UTC date keeps its day', () {
    expect(toISO(DateTime.utc(2026, 10, 1)), '2026-10-01');
    expect(addDays('2026-12-31', 1), '2027-01-01');
  });

  test('today is the device calendar day', () {
    expect(todayISO(DateTime(2026, 10, 27, 0, 30)), '2026-10-27');
  });
}
