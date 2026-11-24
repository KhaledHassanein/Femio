// Tests for the trusted-source registry and its on-phone retrieval (ADR-079).
//
// The registry is read from the real bundled file, so a bad edit to it fails here. The demo
// questions in docs/hackathon/DEVPOST_SUBMISSION.md are pinned as tests.

import 'dart:convert';
import 'dart:io';

import 'package:femio/domain/assistant/source_registry.dart';
import 'package:femio/domain/assistant/topic_lexicon.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SourceRegistry registry;

  setUpAll(() {
    final raw = File('assets/trusted_sources/registry.json').readAsStringSync();
    registry = SourceRegistry.fromJson(jsonDecode(raw) as Map<String, Object?>);
  });

  group('registry file', () {
    test('parses, has a version, and holds passages and links', () {
      expect(registry.version, isNotEmpty);
      final passages = registry.entries.where((e) => e.kind == SourceKind.passage);
      final links = registry.entries.where((e) => e.kind == SourceKind.link);
      expect(passages.length, greaterThanOrEqualTo(40));
      expect(links.length, greaterThanOrEqualTo(10));
    });

    test('every passage is from a public-domain publisher and every link from a link-only one', () {
      for (final e in registry.entries) {
        final allowed = e.kind == SourceKind.passage ? publicDomainPublishers : linkOnlyPublishers;
        expect(allowed, contains(e.publisher), reason: e.id);
        expect(e.url, startsWith('https://'), reason: e.id);
        expect(e.topicIds, isNotEmpty, reason: '${e.id} would never be found');
      }
    });

    test('covers every life stage', () {
      for (final g in ['period', 'ttc', 'pregnant', 'menopause']) {
        expect(registry.entries.where((e) => e.goals.contains(g)), isNotEmpty, reason: g);
      }
    });
  });

  group('the licence rule', () {
    Map<String, Object?> entry(String kind, String publisher) => {
      'id': 'x',
      'kind': kind,
      'publisher': publisher,
      'title': 'T',
      'url': 'https://example.org',
      'retrieved': '2026-11-24',
      'text': 'Some text about periods.',
      'summaryEn': 'About periods.',
    };

    test('rejects a passage copied from a link-only publisher', () {
      expect(() => SourceEntry.fromJson(entry('passage', 'NHS')), throwsFormatException);
    });

    test('rejects an unknown publisher and a plain-http link', () {
      expect(() => SourceEntry.fromJson(entry('link', 'Some Blog')), throwsFormatException);
      expect(
        () => SourceEntry.fromJson({...entry('passage', 'CDC'), 'url': 'http://cdc.gov'}),
        throwsFormatException,
      );
    });

    test('accepts the NIH publishers added in 2026-11 and Saudi MOH as a link only', () {
      for (final p in ['NIA (NIH)', 'NIMH (NIH)', 'NHLBI (NIH)', 'NIH ODS', 'NIAMS (NIH)']) {
        expect(SourceEntry.fromJson(entry('passage', p)).publisher, p);
      }
      expect(SourceEntry.fromJson({...entry('link', 'Saudi MOH'), 'lang': 'ar'}).lang, 'ar');
      expect(() => SourceEntry.fromJson(entry('passage', 'Saudi MOH')), throwsFormatException);
    });

    test('a missing language means English; an unknown one is rejected', () {
      expect(SourceEntry.fromJson(entry('passage', 'CDC')).lang, 'en');
      expect(() => SourceEntry.fromJson({...entry('passage', 'CDC'), 'lang': 'de'}), throwsFormatException);
    });

    test('rejects a repeated id', () {
      final e = entry('passage', 'CDC');
      expect(
        () => SourceRegistry.fromJson({
          'version': '1',
          'entries': [e, e],
        }),
        throwsFormatException,
      );
    });
  });

  group('topicsOf', () {
    test('finds the same topics in four languages', () {
      expect(topicsOf('How long should we try to conceive?'), containsAll(['fertility', 'howLong']));
      expect(topicsOf('امتى اروح للدكتور لو في تاخر الحمل'), containsAll(['fertility', 'doctor']));
      expect(topicsOf('combien de temps pour tomber enceinte'), containsAll(['fertility', 'howLong']));
      expect(topicsOf('cuanto tiempo para quedar embarazada'), containsAll(['fertility', 'howLong']));
    });

    test('Arabic prefixes and spelling variants still match', () {
      expect(topicsOf('عن سن اليأس والهبات الساخنة'), containsAll(['menopause', 'hotFlashes']));
    });
  });

  group('searchRegistry', () {
    test('demo question 3 is answered from a passage, with no cloud', () {
      final a = searchRegistry('How long should we try to conceive before seeing a doctor?', registry);
      expect(a.notCovered, isFalse);
      expect(a.passages.map((e) => e.id), contains('owh-ttc-when-to-see-doctor'));
    });

    test('the same question in Arabic finds the same passage', () {
      final a = searchRegistry('امتى نروح للدكتور لو بنحاول نحمل ومفيش حمل؟', registry);
      expect(a.passages.map((e) => e.id), contains('owh-ttc-when-to-see-doctor'));
    });

    test('a question per life stage finds a passage', () {
      for (final q in [
        'What are the symptoms of PCOS?',
        'What is endometriosis?',
        'Is it normal to have heavy periods?',
        'What are the warning signs after giving birth?',
        'What helps with hot flashes in menopause?',
        'How much weight should I gain in pregnancy?',
        'What is postpartum depression?',
      ]) {
        expect(searchRegistry(q, registry).notCovered, isFalse, reason: q);
      }
    });

    test('an off-topic question is not covered, so femio says so instead of guessing', () {
      expect(searchRegistry('How do I change a car tyre?', registry).notCovered, isTrue);
      expect(searchRegistry('Which doctor is best?', registry).notCovered, isTrue);
    });

    test('never more passages or links than the answer may show', () {
      final a = searchRegistry('pregnancy warning signs bleeding headache', registry);
      expect(a.passages.length, lessThanOrEqualTo(maxAnswerPassages));
      expect(a.links.length, lessThanOrEqualTo(maxAnswerLinks));
    });
  });
}
