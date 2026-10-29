// Where banners may sit (ADR-076): the AdBanner widget is present on a guide and on the
// guide list, and absent from Today, Calendar, Log, Help now, Settings and onboarding.
// The default runtime is the do-nothing one, so no Google SDK loads in these tests.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/library.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/features/ads/ad_banner.dart';
import 'package:femio/features/help/help_now_screen.dart';
import 'package:femio/features/learn/article_screen.dart';
import 'package:femio/features/learn/learn_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-10-08';

Widget _wrap(Widget home) => MaterialApp(
      theme: FemioTheme.light(),
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      home: home,
    );

const _article = Article(
  slug: 'test-guide',
  title: 'A test guide',
  excerpt: 'Excerpt',
  body: {
    'root': {'type': 'root', 'children': <Object?>[]},
  },
  sources: [],
  reviewer: null,
  lastReviewed: null,
  disclaimerType: 'general',
  locale: 'en',
);

Future<FemioController> _readyController() async {
  final profile = Profile(goal: Goal.ttc, locale: 'en', birthYear: 1994, periodStarts: const ['2026-09-10'], cycleLength: 28);
  final controller = FemioController(MemoryStore(profile));
  await controller.load();
  return controller;
}

void main() {
  setUpAll(configureFormatting);

  testWidgets('a guide and the guide list carry the banner slot', (tester) async {
    await tester.pumpWidget(_wrap(const ArticleScreen(article: _article)));
    await tester.pumpAndSettle();
    expect(find.byType(AdBanner), findsOneWidget);

    // No guide files: the list is empty, which is all this test needs (the slot, not the content).
    final library = Library(load: (_) async => throw const FileSystemException('missing'));
    await tester.pumpWidget(_wrap(LearnScreen(library: library)));
    await tester.pumpAndSettle();
    expect(find.byType(AdBanner), findsOneWidget);
  });

  testWidgets('Today, Calendar, Log, Settings and Help now carry none', (tester) async {
    final controller = await _readyController();
    await tester.pumpWidget(FemioApp(controller: controller, today: _today));
    await tester.pumpAndSettle();
    // The shell builds Today, Calendar and Log together; Learn is not built until opened.
    expect(find.byType(AdBanner), findsNothing);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(AdBanner), findsNothing);
    await tester.scrollUntilVisible(find.textContaining('Ads appear on guide screens only'), 300);
    expect(find.textContaining('Ads appear on guide screens only'), findsOneWidget);

    await tester.pumpWidget(_wrap(const HelpNowScreen()));
    await tester.pumpAndSettle();
    expect(find.byType(AdBanner), findsNothing);
  });

  testWidgets('onboarding carries none', (tester) async {
    final controller = FemioController(MemoryStore());
    await controller.load();
    await tester.pumpWidget(FemioApp(controller: controller, today: _today));
    await tester.pumpAndSettle();
    expect(find.byType(AdBanner), findsNothing);
  });

  testWidgets('the Learn tab carries the banner', (tester) async {
    final controller = await _readyController();
    await tester.pumpWidget(FemioApp(controller: controller, today: _today));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    // Pump a frame, not settle: the guides load from the asset bundle, outside the fake clock.
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.byType(AdBanner), findsOneWidget);
  });
}
