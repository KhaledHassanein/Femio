// R12.1 proof screenshots: the notification consent screen at 390x844 (780x1688 at DPR 2),
// English and Arabic, light and dark, in its first state (the daily reminder pre-ticked) and
// after the phone refused permission. Written only with --update-goldens, to
// testing-results/2026-11-25-r12-notifications/. A plain run still builds every combination
// and checks what the screen must say. Synthetic profile.
import 'package:femio/app.dart';
import 'package:femio/data/notification_port.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/notification_kinds.dart';
import 'package:femio/domain/reminders.dart';
import 'package:femio/features/settings/notification_consent_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_fonts.dart';

const _out = '../../../testing-results/2026-11-25-r12-notifications';

class _Port implements NotificationPort {
  _Port(this.permission);
  final bool permission;
  int plans = 0;
  int settingsOpened = 0;
  @override
  Future<bool> requestPermission() async => permission;
  @override
  Future<void> openSettings() async => settingsOpened++;
  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async => plans++;
  @override
  Future<void> cancelAll() async {}
}

Future<(FemioController, _Port)> _open(WidgetTester tester, String lang, Brightness b, {required bool permission}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  final port = _Port(permission);
  final c = FemioController(
    MemoryStore(Profile(goal: Goal.ttc, locale: lang, periodStarts: const ['2026-09-05', '2026-10-04', '2026-11-01'])),
    reminders: port,
    initialLocale: lang,
    clock: () => DateTime(2026, 11, 25, 10),
  );
  await c.load();
  await tester.pumpWidget(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: b == Brightness.dark ? FemioTheme.dark() : FemioTheme.light(),
    locale: Locale(lang),
    supportedLocales: [for (final code in supportedLanguages) Locale(code)],
    localizationsDelegates: const [
      L10n.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: NotificationConsentScreen(controller: c, initial: NotificationKind.log),
  ));
  await tester.pumpAndSettle();
  return (c, port);
}

Future<void> _shoot(String name) async {
  if (autoUpdateGoldenFiles) await expectLater(find.byType(MaterialApp), matchesGoldenFile('$_out/$name.png'));
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    configureFormatting();
  });

  for (final b in Brightness.values) {
    for (final lang in ['en', 'ar']) {
      final tag = '${lang}_${b.name}';
      final l = lookupL10n(Locale(lang));

      testWidgets('consent screen, first state ($tag)', (tester) async {
        await _open(tester, lang, b, permission: true);
        // What she will receive, why it is neutral, where it runs.
        for (final text in [l.notifConsentTitle, l.notifConsentIntro, l.notifConsentNeutral, l.notifConsentLocal]) {
          expect(find.text(text), findsOneWidget);
        }
        // Four real switches (period shows for trying to conceive; medicine since R11.6) and one
        // honest "coming" row.
        expect(find.byType(Switch, skipOffstage: false), findsNWidgets(5));
        expect(find.text(l.notifComingSoon, skipOffstage: false), findsOneWidget);
        expect(find.text(l.notifKindMedicine, skipOffstage: false), findsOneWidget);
        expect(find.text(l.notifKindDigest, skipOffstage: false), findsOneWidget);
        expect(tester.widgetList<Switch>(find.byType(Switch, skipOffstage: false)).where((s) => s.onChanged == null).length, 1);
        await _shoot('${tag}_consent');
      });

      testWidgets('consent screen, phone refused ($tag)', (tester) async {
        final (c, port) = await _open(tester, lang, b, permission: false);
        await tester.tap(find.text(l.notifConsentAllow));
        await tester.pumpAndSettle();
        expect(find.text(l.notifConsentDeniedTitle), findsOneWidget);
        expect(find.text(l.notifConsentDeniedBody), findsOneWidget);
        expect(c.profile!.settings.hasNotificationConsent, isFalse);
        expect(port.plans, 0);
        await _shoot('${tag}_denied');
        // Android asks only once (and not at all before 13): one tap opens the settings.
        await tester.tap(find.text(l.notifOpenSettings));
        expect(port.settingsOpened, 1);
      });
    }
  }
}
