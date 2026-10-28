// The guide library and its renderer: the bundled JSON parses, Arabic fills from
// English with the fallback marked, the wedge leads, and a "seek care now" quote
// becomes the red-flag card in every language the website's matcher knows.

import 'dart:convert';
import 'dart:io';

import 'package:femio/data/library.dart';
import 'package:femio/theme/femio_theme.dart';
import 'package:femio/widgets/lexical_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<String> _fromDisk(String path) => File(path).readAsString();

void main() {
  group('Library', () {
    test('parses the bundled guides and fills Arabic gaps from English', () async {
      final lib = Library(load: _fromDisk);
      final en = await lib.articles('en');
      expect(en.length, greaterThanOrEqualTo(100));
      final ar = await lib.articles('ar');
      expect(ar.length, en.length);
      expect(ar.where((a) => a.locale == 'ar').length, greaterThanOrEqualTo(10));
      expect(ar.where((a) => a.locale == 'en').length, en.length - ar.where((a) => a.locale == 'ar').length);
    });

    test('leads with the wedge, in the website\'s topic order', () async {
      final ar = await Library(load: _fromDisk).articles('ar');
      expect(ar.first.slug, wedgeSlugs.first);
      expect(ar.map((a) => a.slug).take(3).toList(), wedgeSlugs.take(3).toList());
    });

    test('a missing file is no translations, not a crash', () async {
      final lib = Library(load: (_) async => throw const FileSystemException('missing'));
      expect(await lib.articles('fr'), isEmpty);
    });
  });

  group('LexicalView', () {
    Map<String, Object?> doc(String quote) => {
          'root': {
            'type': 'root',
            'children': [
              {
                'type': 'heading',
                'tag': 'h2',
                'children': [
                  {'type': 'text', 'text': 'Heading', 'format': 0},
                ],
              },
              {
                'type': 'paragraph',
                'children': [
                  {'type': 'text', 'text': 'Plain ', 'format': 0},
                  {'type': 'text', 'text': 'bold', 'format': 1},
                ],
              },
              {
                'type': 'quote',
                'children': [
                  {'type': 'text', 'text': quote, 'format': 0},
                ],
              },
            ],
          },
        };

    Future<void> pump(WidgetTester tester, Map<String, Object?> root) => tester.pumpWidget(MaterialApp(
          theme: FemioTheme.light(),
          home: Scaffold(body: SingleChildScrollView(child: LexicalView(root: root, redFlagHeading: 'Seek care now'))),
        ));

    testWidgets('renders headings, paragraphs and a plain quote', (tester) async {
      await pump(tester, doc('A thought.'));
      expect(find.text('Heading'), findsOneWidget);
      expect(find.textContaining('Plain'), findsOneWidget);
      expect(find.text('A thought.'), findsOneWidget);
      expect(find.text('Seek care now'), findsNothing);
    });

    for (final prefix in redFlagPrefixes) {
      testWidgets('a quote opening "$prefix:" becomes the red-flag card', (tester) async {
        await pump(tester, doc('$prefix: go to the nearest emergency department.'));
        expect(find.text('Seek care now'), findsOneWidget);
        expect(find.text('go to the nearest emergency department.'), findsOneWidget);
      });
    }

    testWidgets('the Arabic guides carry at least one red-flag box the renderer recognises', (tester) async {
      // Synchronous read: real file I/O never completes under the widget test's fake clock.
      final raw = jsonDecode(File('assets/content/ar.json').readAsStringSync()) as List;
      final warning = raw.cast<Map>().firstWhere((a) => a['slug'] == 'pregnancy-warning-signs');
      await pump(tester, Map<String, Object?>.from(warning['body'] as Map));
      expect(find.text('Seek care now'), findsWidgets);
    });
  });
}
