// Tests for the rating and update prompts (R12.2, R12.3): when femio may ask Google Play
// for a rating, how an update is offered, and that the build constant matches pubspec.

import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/play_store.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/safety_session.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/store_prompts.dart';
import 'package:flutter_test/flutter_test.dart';

class _Play implements PlayStore {
  int reviews = 0;
  @override
  Future<void> requestReview() async => reviews++;
  @override
  Future<UpdatePrompt> checkUpdate() async => UpdatePrompt.none;
  @override
  Future<bool> startUpdate(UpdatePrompt mode) async => false;
}

void main() {
  setUp(SafetySession.resetForTest);

  test('appBuild matches the build number in pubspec.yaml', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final build = RegExp(r'^version: \S+\+(\d+)$', multiLine: true).firstMatch(pubspec)!.group(1);
    expect(appBuild, int.parse(build!));
  });

  test('a day counts once however often she opens femio', () {
    var c = countUsageDay(0, null, '2026-11-01');
    expect(c.days, 1);
    c = countUsageDay(c.days, c.lastDay, '2026-11-01');
    expect(c.days, 1);
    c = countUsageDay(c.days, c.lastDay, '2026-11-03');
    expect((c.days, c.lastDay), (2, '2026-11-03'));
  });

  test('the rating request waits for six days, once per build, never after a safety screen', () {
    bool ask(int days, int? asked, bool safety) =>
        shouldAskForReview(usageDays: days, askedForBuild: asked, safetyShownThisSession: safety, build: 7);
    expect(ask(5, null, false), isFalse);
    expect(ask(6, null, false), isTrue);
    expect(ask(6, 7, false), isFalse);
    expect(ask(6, 6, false), isTrue);
    expect(ask(9, null, true), isFalse);
  });

  test('updates: high priority goes full screen, anything else is the quiet card', () {
    UpdatePrompt f(bool a, int p, bool i, bool fl) =>
        updatePromptFor(available: a, priority: p, immediateAllowed: i, flexibleAllowed: fl);
    expect(f(false, 5, true, true), UpdatePrompt.none);
    expect(f(true, 5, true, true), UpdatePrompt.immediate);
    expect(f(true, 4, false, true), UpdatePrompt.banner);
    expect(f(true, 1, true, true), UpdatePrompt.banner);
    expect(f(true, 1, false, false), UpdatePrompt.none);
  });

  group('controller', () {
    Future<(FemioController, _Play)> make(int days, String today) async {
      final play = _Play();
      final store = MemoryStore();
      final s = const AppSettings().copyWith(usageDays: days, lastUsageDay: '2026-10-01');
      await store.save(Profile(goal: Goal.ttc, locale: 'en', settings: s));
      final c = FemioController(store, playStore: play, clock: () => DateTime.parse('${today}T09:00:00'));
      await c.load();
      return (c, play);
    }

    test('opening on a new day counts it and survives a reload', () async {
      final (c, _) = await make(2, '2026-11-25');
      expect(c.profile!.settings.usageDays, 3);
      expect(c.profile!.settings.lastUsageDay, '2026-11-25');
    });

    test('the sixth day asks once after a saved log, then never again this build', () async {
      final (c, play) = await make(5, '2026-11-25');
      await c.setDayLog('2026-11-25', const DayLog(terms: ['cramps']));
      expect(play.reviews, 1);
      expect(c.profile!.settings.reviewAskedBuild, appBuild);
      await c.setDayLog('2026-11-25', const DayLog(terms: ['bloating']));
      expect(play.reviews, 1);
    });

    test('no request in a session that showed a safety screen', () async {
      final (c, play) = await make(9, '2026-11-25');
      SafetySession.mark();
      await c.setDayLog('2026-11-25', const DayLog(terms: ['cramps']));
      expect(play.reviews, 0);
      expect(c.profile!.settings.reviewAskedBuild, isNull);
    });
  });

  test('the new settings fields round-trip and default safely', () {
    final s = const AppSettings().copyWith(usageDays: 4, lastUsageDay: '2026-11-02', reviewAskedBuild: 3);
    final back = AppSettings.fromJson(s.toJson());
    expect((back.usageDays, back.lastUsageDay, back.reviewAskedBuild), (4, '2026-11-02', 3));
    final old = AppSettings.fromJson(const {'showHijri': true});
    expect((old.usageDays, old.lastUsageDay, old.reviewAskedBuild), (0, null, null));
  });
}
