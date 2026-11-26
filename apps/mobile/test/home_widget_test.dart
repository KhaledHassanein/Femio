// The home-screen widget's words (R9.11): the pure function that picks them, the setting
// that gates them, and the controller's promises (push on start and on every save, write the
// neutral strings back the moment the switch goes off, and when everything is deleted).
// The native widget itself needs a phone; the bridge here is a recording fake, and that gap
// is listed in the R9.11 ledger line.

import 'package:femio/app.dart';
import 'package:femio/data/home_widget_bridge.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/home_widget.dart';
import 'package:femio/features/settings/settings_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart' show configureFormatting;
import 'package:femio/theme/femio_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

const _today = '2026-10-28';
final _now = DateTime(2026, 10, 28, 10, 0);

/// Five regular 28-day cycles: the next period is predicted for 2026-11-18, window 11-16 to 11-20.
Profile _regular({AppSettings settings = const AppSettings(), Goal goal = Goal.period, bool irregular = false, String locale = 'en'}) => Profile(
      goal: goal,
      locale: locale,
      periodStarts: const ['2026-07-01', '2026-07-29', '2026-08-26', '2026-09-23', '2026-10-21'],
      cycleLength: 28,
      irregular: irregular,
      settings: settings,
    );

/// Due 2027-02-01: on 2026-10-28 she is 26w2d (280 - 96 days to go = day 184).
Profile _pregnant({AppSettings settings = const AppSettings(), String? birthDate, String? edd = '2027-02-01'}) =>
    Profile(goal: Goal.pregnant, locale: 'en', edd: edd, birthDate: birthDate, settings: settings);

const _on = AppSettings(widgetDetails: true);

const _texts = HomeWidgetTexts(
  neutralLine: 'Open femio',
  week: _week,
  nextPeriod: _next,
  range: _range,
);
String _week(int w) => 'Week $w';
String _next(String r) => 'Next period $r';
String _range(String a, String b) => '$a to $b';

HomeWidgetContent _content(Profile? p, {bool on = true}) => homeWidgetContent(p, _today, _texts, showDetails: on);

class _Recorder implements HomeWidgetBridge {
  final sent = <HomeWidgetContent>[];
  @override
  Future<void> update(HomeWidgetContent content) async => sent.add(content);
}

class _Failing implements HomeWidgetBridge {
  @override
  Future<void> update(HomeWidgetContent content) async => throw StateError('no widget');
}

const _neutral = HomeWidgetContent(title: 'femio', line: 'Open femio');

void main() {
  setUpAll(() async {
    configureFormatting();
    await initializeDateFormatting();
  });

  group('homeWidgetContent', () {
    test('neutral by default: the wordmark and "Open femio", whatever the record holds', () {
      for (final p in [
        _regular(),
        _pregnant(),
        _regular(goal: Goal.ttc),
        null,
      ]) {
        expect(_content(p, on: false), _neutral);
      }
    });

    test('the neutral words carry no health word', () {
      final line = _content(_regular(), on: false).line.toLowerCase();
      for (final word in ['period', 'pregnan', 'week', 'fertile', 'cycle', 'ovulat', 'trimester']) {
        expect(line.contains(word), isFalse, reason: word);
      }
    });

    test('pregnancy with details on: the completed week, from the pregnancy rule', () {
      expect(_content(_pregnant(settings: _on)).line, 'Week 26');
    });

    test('pregnancy: no due date, a date out of range, or a birth already recorded stay neutral', () {
      expect(_content(_pregnant(settings: _on, edd: null)), _neutral);
      expect(_content(_pregnant(settings: _on, edd: '2028-01-01')), _neutral);
      expect(_content(_pregnant(settings: _on, birthDate: '2026-10-01')), _neutral);
    });

    test('period and trying to conceive: the next period as a range, never one date', () {
      final line = _content(_regular(settings: _on)).line;
      expect(line, 'Next period 2026-11-16 to 2026-11-20');
      expect(_content(_regular(settings: _on, goal: Goal.ttc)).line, line);
    });

    test('a range that has already ended goes neutral, never reads as late', () {
      final p = _regular(settings: _on);
      expect(homeWidgetContent(p, '2026-11-20', _texts, showDetails: true).line, 'Next period 2026-11-16 to 2026-11-20');
      expect(homeWidgetContent(p, '2026-11-21', _texts, showDetails: true), _neutral);
    });

    test('irregular cycles, no history or menopause: neutral, no guess', () {
      expect(_content(_regular(settings: _on, irregular: true)), _neutral);
      expect(_content(const Profile(goal: Goal.period, locale: 'en', settings: _on)), _neutral);
      expect(_content(const Profile(goal: Goal.menopause, locale: 'en', periodStarts: ['2026-05-02'], settings: _on)), _neutral);
    });

    test('the title is always the Latin wordmark', () {
      expect(_content(_pregnant(settings: _on)).title, 'femio');
      expect(_content(null).title, 'femio');
    });
  });

  group('the setting', () {
    test('absent from an older file reads as off; it survives a round trip', () {
      expect(AppSettings.fromJson(const {'showHijri': true}).widgetDetails, isFalse);
      expect(AppSettings.fromJson(null).widgetDetails, isFalse);
      final back = AppSettings.fromJson(_on.toJson());
      expect(back.widgetDetails, isTrue);
      expect(const AppSettings().copyWith(widgetDetails: true).widgetDetails, isTrue);
    });
  });

  group('the controller feeds the widget', () {
    test('app start pushes the neutral strings while the switch is off', () async {
      final rec = _Recorder();
      final c = FemioController(MemoryStore(_regular()), homeWidget: rec, clock: () => _now);
      await c.load();
      expect(rec.sent, [_neutral]);
    });

    test('app start with details on pushes the range in her language, Western digits in Arabic', () async {
      final en = _Recorder();
      await FemioController(MemoryStore(_regular(settings: _on)), homeWidget: en, clock: () => _now).load();
      expect(en.sent.single.line, 'Next period Nov 16 – Nov 20');

      final ar = _Recorder();
      await FemioController(MemoryStore(_regular(settings: _on, locale: 'ar')), homeWidget: ar, clock: () => _now).load();
      final line = ar.sent.single.line;
      expect(line, contains('16'));
      expect(line, contains('20'));
      expect(line, startsWith('الدورة القادمة'));
      expect(RegExp(r'[٠-٩]').hasMatch(line), isFalse);
      expect(ar.sent.single.title, 'femio');
    });

    test('turning the switch on shows the week; turning it off writes the neutral strings back at once', () async {
      final rec = _Recorder();
      final c = FemioController(MemoryStore(_pregnant()), homeWidget: rec, clock: () => _now);
      await c.load();
      await c.setSettings(c.profile!.settings.copyWith(widgetDetails: true));
      expect(rec.sent.last.line, 'Week 26');
      await c.setSettings(c.profile!.settings.copyWith(widgetDetails: false));
      expect(rec.sent.last, _neutral);
    });

    test('an unchanged text is not sent twice', () async {
      final rec = _Recorder();
      final c = FemioController(MemoryStore(_pregnant(settings: _on)), homeWidget: rec, clock: () => _now);
      await c.load();
      await c.save(c.profile!);
      expect(rec.sent.length, 1);
    });

    test('a changed record updates the widget: a new due date moves the week', () async {
      final rec = _Recorder();
      final c = FemioController(MemoryStore(_pregnant(settings: _on)), homeWidget: rec, clock: () => _now);
      await c.load();
      await c.save(_pregnant(settings: _on, edd: '2027-03-01'));
      expect(rec.sent.last.line, 'Week 22');
    });

    test('delete everything takes the details off the home screen', () async {
      final rec = _Recorder();
      final c = FemioController(MemoryStore(_pregnant(settings: _on)), homeWidget: rec, clock: () => _now);
      await c.load();
      expect(rec.sent.last.line, 'Week 26');
      await c.deleteEverything();
      expect(rec.sent.last, _neutral);
    });

    test('a widget that fails never costs her a saved record', () async {
      final store = MemoryStore(_pregnant());
      final c = FemioController(store, homeWidget: _Failing(), clock: () => _now);
      await c.load();
      await c.setSettings(c.profile!.settings.copyWith(widgetDetails: true));
      final loaded = await store.load();
      expect((loaded as Loaded).profile.settings.widgetDetails, isTrue);
    });
  });

  group('settings switch', () {
    for (final lang in ['en', 'ar']) {
      testWidgets('off by default, one honest sentence, flips the setting ($lang)', (tester) async {
        tester.view.physicalSize = const Size(780, 1688);
        tester.view.devicePixelRatio = 2;
        addTearDown(tester.view.reset);
        final rec = _Recorder();
        final c = FemioController(MemoryStore(_pregnant()), homeWidget: rec, clock: () => _now);
        await c.load();
        c.setLanguage(lang);
        await tester.pumpWidget(MaterialApp(
          theme: FemioTheme.light(),
          locale: Locale(lang),
          supportedLocales: [for (final code in supportedLanguages) Locale(code)],
          localizationsDelegates: const [
            L10n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SettingsScreen(controller: c),
        ));
        await tester.pumpAndSettle();
        final l = lookupL10n(Locale(lang));
        await tester.scrollUntilVisible(find.text(l.settingsWidgetDetails), 200, scrollable: find.byType(Scrollable).first);
        await tester.ensureVisible(find.text(l.settingsWidgetDetails));
        await tester.pumpAndSettle();
        expect(find.text(l.settingsWidgetDetailsNote), findsOneWidget);
        expect(c.profile!.settings.widgetDetails, isFalse);
        await tester.tap(find.text(l.settingsWidgetDetails));
        await tester.pumpAndSettle();
        expect(c.profile!.settings.widgetDetails, isTrue);
        expect(rec.sent.last.line, contains('26'));
        await tester.tap(find.text(l.settingsWidgetDetails));
        await tester.pumpAndSettle();
        expect(c.profile!.settings.widgetDetails, isFalse);
        expect(rec.sent.last.line, lookupL10n(Locale(lang)).widgetNeutralLine);
      });
    }
  });
}
