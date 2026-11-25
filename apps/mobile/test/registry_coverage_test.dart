// Coverage of the trusted-source registry against a synthetic question set (2026-11-24).
//
// Why it exists: the owner reported that many questions to "Ask femio" get "Not covered yet".
// This test runs every question in `test/fixtures/registry_questions.json` through the same
// path the Ask screen uses (safety rules first, then `searchRegistry`) and grades each answer:
// - strong: a returned passage contains one of the question's expected English stems;
// - weak: passages came back, but none of them carries an expected stem;
// - none: no passage ("Not covered yet");
// - rule: the safety rules stopped the question before any lookup.
// It writes the per-question results to `build/registry_coverage.json` (read by
// `scripts/registry-coverage-report.py`) and fails when coverage drops below the floors below,
// or when a birth-control question reaches the registry. The questions are synthetic, written
// from the persona specs; the numbers are not from real use.

import 'dart:convert';
import 'dart:io';

import 'package:femio/domain/assistant/safety.dart';
import 'package:femio/domain/assistant/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';

/// Share of answerable questions, all languages together, that must get a strong answer.
const _minStrongShare = 0.85;

/// Share that may end with no passage at all.
const _maxNoneShare = 0.08;

/// Languages a question may be written in, in report order.
const _langs = ['en', 'ar', 'fr', 'es'];

/// Grades one question in one language. [expect] items are lower-case stems; an item "a+b"
/// needs every part in the same passage.
String _grade(String q, List<String> expect, String group, SourceRegistry registry) {
  final signal = safetySignal(q, pregnant: group == 'pregnancy', postpartum: group == 'postpartum');
  if (signal != SafetySignal.none) return 'rule:${signal.name}';
  final found = searchRegistry(q, registry);
  if (found.notCovered) return 'none';
  bool matches(SourceEntry e) {
    final hay = '${e.title} ${e.text}'.toLowerCase();
    return expect.any((item) => item.split('+').every(hay.contains));
  }

  return found.passages.any(matches) ? 'strong' : 'weak';
}

void main() {
  late SourceRegistry registry;
  late List<Map<String, Object?>> questions;

  setUpAll(() {
    registry = SourceRegistry.fromJson(
      jsonDecode(File('assets/trusted_sources/registry.json').readAsStringSync()) as Map<String, Object?>,
    );
    final set = jsonDecode(File('test/fixtures/registry_questions.json').readAsStringSync()) as Map<String, Object?>;
    questions = [for (final q in set['questions']! as List) q as Map<String, Object?>];
  });

  test('the registry answers the synthetic question set, and the rules still come first', () {
    final rows = <Map<String, Object?>>[];
    for (final q in questions) {
      final group = q['group']! as String;
      final expect = [for (final e in (q['expect'] as List?) ?? const []) '$e'.toLowerCase()];
      for (final lang in _langs) {
        final text = q[lang];
        if (text is! String) continue;
        final found = searchRegistry(text, registry);
        rows.add({
          'id': q['id'],
          'group': group,
          'persona': q['persona'],
          'lang': lang,
          'question': text,
          'rule': q['rule'],
          'grade': _grade(text, expect, group, registry),
          'passages': [for (final p in found.passages) p.id],
          'links': [for (final l in found.links) l.id],
        });
      }
    }
    Directory('build').createSync(recursive: true);
    File('build/registry_coverage.json').writeAsStringSync(
      const JsonEncoder.withIndent(' ').convert({'registry': registry.version, 'rows': rows}),
    );

    // Birth-control questions never reach the registry (product rule 1).
    for (final r in rows.where((r) => r['rule'] == 'birthControl')) {
      expect(r['grade'], 'rule:birthControl', reason: '${r['id']} ${r['lang']}: ${r['question']}');
    }

    final answerable = rows.where((r) => r['group'] != 'rules').toList();
    final strong = answerable.where((r) => r['grade'] == 'strong').length;
    final none = answerable.where((r) => r['grade'] == 'none').length;
    // ignore: avoid_print
    print('registry ${registry.version}: ${answerable.length} asked, $strong strong, $none none');
    expect(strong / answerable.length, greaterThanOrEqualTo(_minStrongShare));
    expect(none / answerable.length, lessThanOrEqualTo(_maxNoneShare));
  });
}
