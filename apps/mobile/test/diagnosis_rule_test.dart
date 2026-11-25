// Tests for the "do I have X?" rule (R7.14): a question that asks femio for a verdict gets the
// fixed "only a clinician can tell" sentence before the passages, in all four languages.

import 'package:femio/domain/assistant/diagnosis.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('asking whether she has a condition is caught in four languages', () {
    for (final q in [
      'Do I have PCOS?',
      'Do I have endometriosis?',
      'Am I infertile?',
      'Am I in menopause?',
      'Do I have gestational diabetes?',
      'How do I know if I have a thyroid problem?',
      'هل عندي تكيس مبايض؟',
      'هل عندي بطانة رحم مهاجرة؟',
      'هل انا عندي عقم؟',
      'هل انا دخلت سن اليأس؟',
      'هل عندي سكر حمل؟',
      'ممكن يكون عندي انيميا؟',
      "Est-ce que j'ai un SOPK ?",
      'Suis-je ménopausée ?',
      '¿Tengo ovario poliquístico?',
      '¿Será que tengo endometriosis?',
    ]) {
      expect(asksForDiagnosis(q), isTrue, reason: q);
    }
  });

  test('ordinary questions are not caught', () {
    for (final q in [
      'What is PCOS?',
      'How is endometriosis treated?',
      'Do I have to fast before a glucose test?',
      'I have PCOS. Can I get pregnant?',
      'ايه هو تكيس المبايض؟',
      'Tengo SOP y quiero quedar embarazada',
      '',
    ]) {
      expect(asksForDiagnosis(q), isFalse, reason: q);
    }
  });
}
