// The Help now data (lib/domain/crisis_numbers.dart) obeys the register's rules on its own:
// sixteen countries, emergency lines first, digits only, an official https page for every
// number and never a social-media one, and a label for every id in every language.
// Parity with the website's list is the gate's job (scripts/crisis-compliance.mjs).

import 'package:femio/domain/crisis_numbers.dart';
import 'package:femio/features/help/help_now_labels.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/l10n/app_localizations_ar.dart';
import 'package:femio/l10n/app_localizations_en.dart';
import 'package:femio/l10n/app_localizations_es.dart';
import 'package:femio/l10n/app_localizations_fr.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sixteen countries, Arabic-speaking first, every one with numbers', () {
    expect(crisisCountries.length, 16);
    expect(crisisCountries.take(2).toList(), ['egypt', 'saudi']);
    expect(crisisNumbers.keys.toList(), crisisCountries);
    for (final c in crisisCountries) {
      expect(crisisNumbers[c], isNotEmpty, reason: c);
    }
  });

  test('every country opens with an emergency line and no emergency row follows a support row', () {
    for (final c in crisisCountries) {
      final kinds = crisisNumbers[c]!.map((n) => n.kind).toList();
      expect(kinds.first, NumberKind.emergency, reason: c);
      final firstSupport = kinds.indexOf(NumberKind.support);
      if (firstSupport >= 0) {
        expect(kinds.sublist(firstSupport).every((k) => k == NumberKind.support), isTrue, reason: c);
      }
    }
  });

  test('ids are unique, numbers are digits, sources are official https pages', () {
    final all = crisisNumbers.values.expand((l) => l).toList();
    expect(all.length, 37);
    expect(all.map((n) => n.id).toSet().length, all.length);
    for (final n in all) {
      expect(RegExp(r'^\d{2,11}$').hasMatch(n.number), isTrue, reason: n.id);
      expect(n.sourceUrl.startsWith('https://'), isTrue, reason: n.id);
      for (final social in ['facebook.', 'instagram.', 'twitter.', 'x.com', 'tiktok.']) {
        expect(n.sourceUrl.contains(social), isFalse, reason: '${n.id} cites $social');
      }
    }
    expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(crisisNumbersChecked), isTrue);
  });

  test('every country and number has a label in all four languages (no id falls through)', () {
    final locales = <L10n>[L10nEn(), L10nAr(), L10nFr(), L10nEs()];
    for (final l in locales) {
      for (final c in crisisCountries) {
        expect(helpNowCountryName(l, c), isNot(c), reason: '${l.localeName} $c');
      }
      for (final n in crisisNumbers.values.expand((x) => x)) {
        final label = helpNowNumberLabel(l, n.id);
        expect(label, isNot(n.id), reason: '${l.localeName} ${n.id}');
        expect(label.trim(), isNotEmpty);
      }
    }
  });
}
