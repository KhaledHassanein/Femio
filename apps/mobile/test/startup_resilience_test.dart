// The start-up guard: every way the phone can fail on launch must end on a screen, never
// in a crash or a white page, and must never touch her record file.
//
// Why it exists: release build 0.5.0+5 died before Flutter drew a frame, and a debug
// build cannot show that. R8 problems are caught by building a release (see
// scripts/mobile/release-smoke.mjs); THIS file covers the Dart side with fakes that
// throw: Keystore missing or failing, a corrupt or half-written record, storage that
// refuses a write, notifications and ads that fail. All fixtures are synthetic.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:femio/app.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/crypto/envelope.dart' as envelope;
import 'package:femio/data/key_vault.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/reminder_scheduler.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/reminders.dart';
import 'package:femio/domain/ads_policy.dart';
import 'package:femio/features/ads/ad_banner.dart';
import 'package:femio/features/ads/ads_runtime.dart';
import 'package:femio/features/home/home_shell.dart';
import 'package:femio/features/onboarding/onboarding_flow.dart';
import 'package:femio/features/recovery/recovery_screen.dart';
import 'package:femio/features/settings/corrupt_record_screen.dart';
import 'package:femio/l10n/app_localizations.dart';
import 'package:femio/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _today = '2026-10-08';
final _en = lookupL10n(const Locale('en'));

Profile _sample() => Profile(
  goal: Goal.ttc,
  locale: 'en',
  birthYear: 1994,
  periodStarts: const ['2026-09-10'],
  cycleLength: 28,
  settings: const AppSettings(storageNoticeSeen: true),
);

/// A vault that can be told to fail, then healed. Wraps a memory vault.
class _FlakyVault implements KeyVault {
  final inner = MemoryKeyVault();
  bool failRead = false;
  bool failWrite = false;
  int writes = 0;

  @override
  Future<String?> read(String key) async {
    if (failRead) throw StateError('Keystore key invalidated');
    return inner.read(key);
  }

  @override
  Future<void> write(String key, String value) async {
    if (failWrite) throw StateError('Keystore refused the write');
    writes += 1;
    return inner.write(key, value);
  }

  @override
  Future<void> delete(String key) async {
    if (failWrite) throw StateError('Keystore refused the delete');
    return inner.delete(key);
  }
}

/// A store that scripts what load and save do. No files involved.
class _ScriptedStore implements FemioStore {
  _ScriptedStore({this.outcome = const Unavailable(UnavailableReason.vault)});
  LoadOutcome outcome;
  bool throwOnLoad = false;
  bool throwOnSave = false;
  bool throwOnSetAside = false;
  int loads = 0;
  int setAsides = 0;
  Profile? saved;

  @override
  Future<LoadOutcome> load() async {
    loads += 1;
    if (throwOnLoad) throw StateError('store exploded');
    return outcome;
  }

  @override
  Future<void> save(Profile profile) async {
    if (throwOnSave) throw const FileSystemException('disk full');
    saved = profile;
    outcome = Loaded(profile);
  }

  @override
  Future<void> clear() async {}

  @override
  Future<String?> setAside() async {
    if (throwOnSetAside) throw const FileSystemException('cannot rename');
    setAsides += 1;
    outcome = const Empty();
    return '/old/file';
  }
}

/// Notifications that fail in every way the plugin can.
class _BrokenReminders implements ReminderScheduler {
  @override
  Future<bool> requestPermission() async => throw StateError('plugin not initialised');
  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) async =>
      throw StateError('timezone database missing');
  @override
  Future<void> cancelAll() async => throw StateError('plugin not initialised');
}

/// Notifications that never answer (a stuck platform channel).
class _HangingReminders implements ReminderScheduler {
  @override
  Future<bool> requestPermission() => Completer<bool>().future;
  @override
  Future<void> replaceAll(List<PlannedReminder> plan, ReminderTexts texts) => Completer<void>().future;
  @override
  Future<void> cancelAll() => Completer<void>().future;
}

/// An ads SDK that fails at every call.
class _BrokenAds extends AdsRuntime {
  @override
  bool get showsAds => true;
  @override
  Future<void> initialize() async => throw StateError('ads SDK failed to start');
  @override
  Future<LoadedBanner?> loadBanner({required String adUnitId, required int width}) async => throw StateError('no ads');
}

Future<void> _pump(WidgetTester tester, FemioController c, {AdsRuntime ads = const NoAdsRuntime()}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(FemioApp(controller: c, today: _today, adsRuntime: ads));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(configureFormatting);

  group('EncryptedFileStore: the record file is never lost to a failure', () {
    late Directory dir;
    late _FlakyVault vault;
    late File file;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('femio-resilience-');
      vault = _FlakyVault();
      file = File('${dir.path}/$recordFileName');
    });
    tearDown(() => dir.delete(recursive: true));

    EncryptedFileStore store() =>
        EncryptedFileStore(vault: vault, directory: dir, clock: () => DateTime(2026, 11, 1, 9, 30));

    test('Keystore throws on read: Unavailable, file untouched, and a retry opens it', () async {
      await store().save(_sample());
      final before = await file.readAsBytes();

      final s = store();
      vault.failRead = true;
      final outcome = await s.load();
      expect(outcome, isA<Unavailable>());
      expect((outcome as Unavailable).reason, UnavailableReason.vault);
      expect(await file.readAsBytes(), before);
      expect(Directory(dir.path).listSync().length, 1, reason: 'nothing renamed, nothing added');

      vault.failRead = false;
      expect(await s.load(), isA<Loaded>());
    });

    test('Keystore key missing: Unavailable, file untouched, NO new key is written', () async {
      await store().save(_sample());
      final before = await file.readAsBytes();
      await vault.inner.delete(recordKeyName); // e.g. the Keystore was reset
      final writesBefore = vault.writes;

      final outcome = await store().load();
      expect(outcome, isA<Unavailable>());
      expect((outcome as Unavailable).reason, UnavailableReason.keyMissing);
      expect(await file.readAsBytes(), before);
      expect(vault.writes, writesBefore);
      expect(await vault.inner.read(recordKeyName), isNull);
    });

    test('a save after an unopened record sets the old file aside instead of replacing it', () async {
      await store().save(_sample());
      final old = await file.readAsBytes();
      await vault.inner.delete(recordKeyName);

      final s = store();
      expect(await s.load(), isA<Unavailable>());
      await s.save(_sample().copyWith(periodStarts: const ['2026-09-10', '2026-10-08']));

      final aside = dir.listSync().whereType<File>().where((f) => f.path.contains('.set-aside-')).toList();
      expect(aside, hasLength(1));
      expect(await aside.single.readAsBytes(), old);
      expect((await store().load() as Loaded).profile.periodStarts.length, 2);
    });

    test('a Keystore that throws on read can still be replaced by a save', () async {
      await store().save(_sample());
      vault.failRead = true;
      final s = store();
      expect(await s.load(), isA<Unavailable>());
      expect(await s.setAside(), isNotNull);
      await s.save(_sample()); // read fails -> treated as empty -> a new key is written
      vault.failRead = false;
      expect(await store().load(), isA<Loaded>());
    });

    test('setAside moves the file, keeps its bytes, and reports null when there is none', () async {
      expect(await store().setAside(), isNull);
      await store().save(_sample());
      final bytes = await file.readAsBytes();
      final moved = await store().setAside();
      expect(moved, isNotNull);
      expect(await file.exists(), isFalse);
      expect(await File(moved!).readAsBytes(), bytes);
    });

    test('a half-written (truncated) record is quarantined with its bytes, not deleted', () async {
      await store().save(_sample());
      final full = await file.readAsBytes();
      await file.writeAsBytes(full.sublist(0, full.length ~/ 2));

      final outcome = await store().load();
      expect(outcome, isA<Corrupt>());
      final kept = File((outcome as Corrupt).quarantinedPath);
      expect(await kept.readAsBytes(), full.sublist(0, full.length ~/ 2));
      expect(await file.exists(), isFalse);
    });

    test('an empty file, random bytes and a sealed non-record all end as Corrupt', () async {
      for (final bytes in [<int>[], List<int>.generate(200, (i) => i), utf8.encode('{"not":"sealed"}')]) {
        await store().save(_sample());
        await file.writeAsBytes(bytes);
        expect(await store().load(), isA<Corrupt>(), reason: 'for ${bytes.length} bytes');
        for (final f in dir.listSync()) {
          await f.delete();
        }
        await vault.inner.delete(recordKeyName);
      }
    });

    test('a validly sealed record of the wrong shape (a future schema) is kept, not lost', () async {
      await store().save(_sample());
      final key = base64Decode((await vault.inner.read(recordKeyName))!);
      await file.writeAsBytes(await envelope.seal(key, utf8.encode('[1,2,3]')));
      expect(await store().load(), isA<Corrupt>());
      expect(dir.listSync().where((f) => f.path.contains('.corrupt-')), hasLength(1));
    });

    test('a damaged v0.4 plaintext file is left alone and does not crash the load', () async {
      final legacy = File('${dir.path}/$legacyFileName');
      await legacy.writeAsString('{ this is not json');
      expect(await store().load(), isA<Empty>());
      expect(await legacy.readAsString(), '{ this is not json');
      await legacy.writeAsString('[1]'); // valid JSON, wrong shape: used to throw a TypeError
      expect(await store().load(), isA<Empty>());
    });

    test('a failing first save leaves no file and reports the failure', () async {
      vault.failWrite = true;
      await expectLater(store().save(_sample()), throwsA(isA<StateError>()));
      expect(await file.exists(), isFalse);
      expect(await File('${file.path}.tmp').exists(), isFalse);
    });

    test('storage that cannot be written fails the save but the next save still works', () async {
      final s = store();
      await Directory(file.path).create(); // a directory where the file should go
      await expectLater(s.save(_sample()), throwsA(isA<FileSystemException>()));
      await Directory(file.path).delete();
      await s.save(_sample());
      expect(await store().load(), isA<Loaded>());
    });
  });

  group('FemioController start-up never throws and always lands on a screen', () {
    testWidgets('the key vault throws while reading the lock: recovery screen', (tester) async {
      final vault = _FlakyVault()..failRead = true;
      final c = FemioController(MemoryStore(_sample()), vault: vault);
      await tester.runAsync(c.load);
      expect(c.state, RecordState.unavailable);
      await _pump(tester, c);
      expect(find.byType(RecoveryScreen), findsOneWidget);
      expect(find.text(_en.recoveryTitle), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the store itself throws from load: recovery screen', (tester) async {
      final c = FemioController(_ScriptedStore()..throwOnLoad = true);
      await c.load();
      await _pump(tester, c);
      expect(find.byType(RecoveryScreen), findsOneWidget);
    });

    testWidgets('the real store with a missing key and a real file: recovery, file untouched', (tester) async {
      final dir = Directory.systemTemp.createTempSync('femio-ui-');
      addTearDown(() => dir.deleteSync(recursive: true));
      final vault = _FlakyVault();
      late FemioController c;
      late List<int> before;
      await tester.runAsync(() async {
        await EncryptedFileStore(vault: vault, directory: dir).save(_sample());
        await vault.inner.delete(recordKeyName);
        before = await File('${dir.path}/$recordFileName').readAsBytes();
        c = FemioController(
          EncryptedFileStore(vault: vault, directory: dir),
          vault: vault,
        );
        await c.load();
      });
      await _pump(tester, c);
      expect(find.byType(RecoveryScreen), findsOneWidget);
      expect(await tester.runAsync(() => File('${dir.path}/$recordFileName').readAsBytes()), before);
    });

    testWidgets('a corrupt record reaches the corrupt-record screen', (tester) async {
      final c = FemioController(_ScriptedStore(outcome: const Corrupt('/old/femio-record.v2.corrupt-x')));
      await c.load();
      await _pump(tester, c);
      expect(find.byType(CorruptRecordScreen), findsOneWidget);
    });

    testWidgets('Try again: still failing says so; once the phone recovers the app opens', (tester) async {
      final store = _ScriptedStore();
      final c = FemioController(store);
      await c.load();
      await _pump(tester, c);

      await tester.tap(find.text(_en.recoveryTryAgain));
      await tester.pumpAndSettle();
      expect(find.text(_en.recoveryStillClosed), findsOneWidget);
      expect(store.loads, 2);

      store.outcome = Loaded(_sample());
      await tester.tap(find.text(_en.recoveryTryAgain));
      await tester.pumpAndSettle();
      expect(find.byType(RecoveryScreen), findsNothing);
      expect(find.byType(HomeShell), findsOneWidget);
    });

    testWidgets('Start empty asks first, says the old file stays, and only then moves it aside', (tester) async {
      final store = _ScriptedStore();
      final c = FemioController(store);
      await c.load();
      await _pump(tester, c);

      await tester.tap(find.text(_en.recoveryStartFresh));
      await tester.pumpAndSettle();
      expect(find.text(_en.recoveryFreshBody), findsOneWidget);
      expect(_en.recoveryFreshBody, contains('not deleted'));
      expect(_en.recoveryFreshBody, contains('stays on this phone'));

      await tester.tap(find.text(_en.recoveryFreshCancel));
      await tester.pumpAndSettle();
      expect(store.setAsides, 0);
      expect(find.byType(RecoveryScreen), findsOneWidget);

      await tester.tap(find.text(_en.recoveryStartFresh));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_en.recoveryFreshConfirm));
      await tester.pumpAndSettle();
      expect(store.setAsides, 1);
      expect(find.byType(OnboardingFlow), findsOneWidget);
    });

    testWidgets('Start empty that cannot move the file changes nothing and says so', (tester) async {
      final store = _ScriptedStore()..throwOnSetAside = true;
      final c = FemioController(store);
      await c.load();
      await _pump(tester, c);
      await tester.tap(find.text(_en.recoveryStartFresh));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_en.recoveryFreshConfirm));
      await tester.pumpAndSettle();
      expect(find.byType(RecoveryScreen), findsOneWidget);
      expect(find.text(_en.recoveryActionFailed), findsOneWidget);
      expect(c.state, RecordState.unavailable);
    });

    test('restoring a backup while unavailable opens the app only after the write succeeds', () async {
      final bytes = await encodeBackup(_sample(), 'ward al nil');
      final store = _ScriptedStore()..throwOnSave = true;
      final c = FemioController(store);
      await c.load();

      await expectLater(c.importBackup(bytes, 'ward al nil'), throwsA(isA<FileSystemException>()));
      expect(c.state, RecordState.unavailable);
      expect(c.profile, isNull);

      store.throwOnSave = false;
      await c.importBackup(bytes, 'ward al nil');
      expect(c.state, RecordState.ready);
      expect(c.profile, isNotNull);
    });

    test('a retry does not lock her again after she has unlocked', () async {
      final vault = _FlakyVault();
      final store = _ScriptedStore();
      final c = FemioController(store, vault: vault);
      await c.setPin('1234');
      await c.load();
      expect(c.locked, isTrue);
      expect(await c.unlock('1234'), isTrue);
      await c.load();
      expect(c.locked, isFalse);
    });

    test('a vault that throws while checking the PIN means "wrong PIN", not a crash', () async {
      final vault = _FlakyVault();
      final c = FemioController(MemoryStore(_sample()), vault: vault);
      await c.setPin('1234');
      vault.failRead = true;
      expect(await c.unlock('1234'), isFalse);
      expect(await c.verifyPin('1234'), isFalse);
    });
  });

  group('a save that fails is reported, never swallowed', () {
    testWidgets('the banner appears, keeps her work in memory, and clears on the next good save', (tester) async {
      final store = _ScriptedStore(outcome: Loaded(_sample()))..throwOnSave = true;
      final c = FemioController(store);
      await c.load();
      await _pump(tester, c);
      expect(find.text(_en.saveFailedBanner), findsNothing);

      await expectLater(
        c.setSettings(c.profile!.settings.copyWith(showHijri: true)),
        throwsA(isA<FileSystemException>()),
      );
      await tester.pumpAndSettle();
      expect(c.saveFailed, isTrue);
      expect(c.profile!.settings.showHijri, isTrue);
      expect(find.text(_en.saveFailedBanner), findsOneWidget);

      store.throwOnSave = false;
      await c.setSettings(c.profile!.settings.copyWith(showHijri: false));
      await tester.pumpAndSettle();
      expect(find.text(_en.saveFailedBanner), findsNothing);
    });

    testWidgets('dismissing the banner hides it', (tester) async {
      final store = _ScriptedStore(outcome: Loaded(_sample()))..throwOnSave = true;
      final c = FemioController(store);
      await c.load();
      await _pump(tester, c);
      await expectLater(c.setSettings(c.profile!.settings), throwsA(isA<FileSystemException>()));
      await tester.pumpAndSettle();
      await tester.tap(find.text(_en.dismiss));
      await tester.pumpAndSettle();
      expect(find.text(_en.saveFailedBanner), findsNothing);
    });
  });

  group('reminders and ads can fail without costing her the app', () {
    testWidgets('notifications that throw everywhere: the app still opens on her record', (tester) async {
      final c = FemioController(MemoryStore(_sample()), reminders: _BrokenReminders());
      await c.load();
      await _pump(tester, c);
      expect(find.byType(HomeShell), findsOneWidget);
    });

    test('turning a reminder on with a broken notification system returns false and changes nothing', () async {
      final c = FemioController(MemoryStore(_sample()), reminders: _BrokenReminders());
      await c.load();
      expect(await c.updateReminders(log: true), isFalse);
      expect(c.profile!.settings.logReminder, isFalse);
    });

    testWidgets('a notification plugin that never answers cannot hold the first frame', (tester) async {
      var done = false;
      FemioController(MemoryStore(_sample()), reminders: _HangingReminders()).load().then((_) => done = true);
      await tester.pump();
      expect(done, isFalse);
      await tester.pump(reminderStartupTimeout + const Duration(seconds: 1));
      expect(done, isTrue);
    });

    testWidgets('an ads runtime that throws on every call leaves a banner slot empty, not broken', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: Scaffold(
            bottomNavigationBar: AdBanner(surface: AdSurface.article, adUnitId: 'test', runtime: _BrokenAds()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(_en.adLabel), findsNothing);
    });
  });

  group('buildFemioApp (what main() runs) never throws', () {
    testWidgets('a Keystore that throws on every call ends on the recovery screen', (tester) async {
      final vault = _FlakyVault()..failRead = true;
      final dir = Directory.systemTemp.createTempSync('femio-main-');
      addTearDown(() => dir.deleteSync(recursive: true));
      late FemioApp app;
      await tester.runAsync(() async {
        await EncryptedFileStore(vault: _FlakyVault(), directory: dir).save(_sample());
        app = await buildFemioApp(
          vault: vault,
          store: EncryptedFileStore(vault: vault, directory: dir),
          reminders: const NoReminderScheduler(),
          adsRuntime: () => const NoAdsRuntime(),
        );
      });
      tester.view.physicalSize = const Size(780, 1688);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(app);
      await tester.pumpAndSettle();
      expect(find.byType(RecoveryScreen), findsOneWidget);
    });

    testWidgets('an ads runtime that cannot even be created is replaced by none', (tester) async {
      late FemioApp app;
      await tester.runAsync(() async {
        app = await buildFemioApp(
          vault: MemoryKeyVault(),
          store: MemoryStore(),
          reminders: const NoReminderScheduler(),
          adsRuntime: () => throw StateError('no SDK'),
        );
      });
      expect(app.adsRuntime, isA<NoAdsRuntime>());
      await _pump(tester, app.controller);
      expect(find.byType(OnboardingFlow), findsOneWidget);
    });
  });
}
