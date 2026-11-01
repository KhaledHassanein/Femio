// The data layer's promises, each tested the way it can fail: the envelope refuses
// a changed byte and a wrong key; a backup opens on another "phone" with only the
// passphrase; the store migrates the v0.4 plaintext file, quarantines a damaged
// record instead of replacing it, and never interleaves two saves; the PIN hash
// verifies without storing the PIN; an old schema is carried forward.

import 'dart:convert';
import 'dart:io';

import 'package:femio/data/app_lock.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/crypto/envelope.dart' as envelope;
import 'package:femio/data/key_vault.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/store.dart';
import 'package:flutter_test/flutter_test.dart';

Profile _sample() => Profile(
  goal: Goal.ttc,
  locale: 'ar',
  birthYear: 1996,
  periodStarts: const ['2026-09-01', '2026-09-29'],
  periodLength: 5,
  cycleLength: 28,
  logs: const {
    '2026-09-29': DayLog(flow: 'medium', terms: ['cramps']),
  },
  settings: const AppSettings(showHijri: true, storageNoticeSeen: true),
);

void main() {
  group('envelope', () {
    test('seals and opens under the same key; a changed byte or another key is refused', () async {
      final key = base64Decode(envelope.newRecordKey());
      final sealed = await envelope.seal(key, utf8.encode('her record'));
      expect(utf8.decode(await envelope.open(key, sealed)), 'her record');

      final tampered = [...sealed];
      tampered[tampered.length - 20] ^= 1;
      expect(() => envelope.open(key, tampered), throwsA(isA<envelope.EnvelopeError>()));

      final other = base64Decode(envelope.newRecordKey());
      expect(() => envelope.open(other, sealed), throwsA(isA<envelope.EnvelopeError>()));
      expect(() => envelope.open(key, utf8.encode('not ours at all')), throwsA(isA<envelope.EnvelopeError>()));
    });

    test('two seals of the same bytes differ (fresh nonce each time)', () async {
      final key = base64Decode(envelope.newRecordKey());
      final a = await envelope.seal(key, [1, 2, 3]);
      final b = await envelope.seal(key, [1, 2, 3]);
      expect(a, isNot(equals(b)));
    });
  });

  group('backup', () {
    test('round-trips with the passphrase and refuses a wrong one', () async {
      final bytes = await encodeBackup(_sample(), 'ward al nil');
      final restored = await decodeBackup(bytes, 'ward al nil');
      expect(restored.toJson(), _sample().toJson());
      expect(
        () => decodeBackup(bytes, 'wrong one'),
        throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.wrongPassphrase)),
      );
      expect(
        () => decodeBackup(utf8.encode('{}'), 'ward al nil'),
        throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.notAFemioFile)),
      );
    });

    test('refuses a short passphrase and names the file without personal detail', () {
      expect(() => encodeBackup(_sample(), 'abc'), throwsArgumentError);
      expect(backupFileName(DateTime(2026, 11, 3)), 'femio-backup-2026-11-03.femio');
    });
  });

  group('EncryptedFileStore', () {
    late Directory dir;
    late MemoryKeyVault vault;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('femio-store-');
      vault = MemoryKeyVault();
    });
    tearDown(() => dir.delete(recursive: true));

    test('saves sealed bytes and loads them back; the file is not plaintext', () async {
      final store = EncryptedFileStore(vault: vault, directory: dir);
      await store.save(_sample());
      final raw = await File('${dir.path}/$recordFileName').readAsBytes();
      expect(utf8.decode(raw, allowMalformed: true), isNot(contains('cramps')));
      final outcome = await store.load();
      expect(outcome, isA<Loaded>());
      expect((outcome as Loaded).profile.toJson(), _sample().toJson());
    });

    test('is Empty before anything is saved', () async {
      expect(await EncryptedFileStore(vault: vault, directory: dir).load(), isA<Empty>());
    });

    test('migrates the v0.4 plaintext file, then deletes it', () async {
      final legacy = File('${dir.path}/$legacyFileName');
      final old = {..._sample().toJson()}..['v'] = 1;
      old.remove('settings');
      await legacy.writeAsString(jsonEncode(old));
      final store = EncryptedFileStore(vault: vault, directory: dir);
      final outcome = await store.load();
      expect(outcome, isA<Loaded>());
      expect((outcome as Loaded).profile.goal, Goal.ttc);
      expect(await legacy.exists(), isFalse);
      expect(await File('${dir.path}/$recordFileName').exists(), isTrue);
      expect((await store.load() as Loaded).profile.settings.showHijri, isFalse);
    });

    test('quarantines a damaged record instead of overwriting it', () async {
      final store = EncryptedFileStore(vault: vault, directory: dir, clock: () => DateTime(2026, 11, 3, 9, 30));
      await store.save(_sample());
      final file = File('${dir.path}/$recordFileName');
      final bytes = await file.readAsBytes();
      bytes[bytes.length - 5] ^= 0xff;
      await file.writeAsBytes(bytes);

      final outcome = await store.load();
      expect(outcome, isA<Corrupt>());
      final kept = File((outcome as Corrupt).quarantinedPath);
      expect(await kept.exists(), isTrue);
      expect(await file.exists(), isFalse);
      expect(await store.load(), isA<Empty>());
    });

    test('a record sealed under another key is treated as damaged, not as empty', () async {
      await EncryptedFileStore(vault: vault, directory: dir).save(_sample());
      final other = MemoryKeyVault();
      await other.write(recordKeyName, envelope.newRecordKey());
      final outcome = await EncryptedFileStore(vault: other, directory: dir).load();
      expect(outcome, isA<Corrupt>());
    });

    test('a record whose key is gone is left in place as unavailable, not quarantined', () async {
      await EncryptedFileStore(vault: vault, directory: dir).save(_sample());
      final outcome = await EncryptedFileStore(vault: MemoryKeyVault(), directory: dir).load();
      expect(outcome, isA<Unavailable>());
      expect(File('${dir.path}/$recordFileName').existsSync(), isTrue);
    });

    test('serialises saves: the last call wins and nothing interleaves', () async {
      final store = EncryptedFileStore(vault: vault, directory: dir);
      final futures = [
        for (var i = 0; i < 5; i += 1) store.save(_sample().copyWith(periodStarts: ['2026-01-0${i + 1}'])),
      ];
      await Future.wait(futures);
      final loaded = await store.load() as Loaded;
      expect(loaded.profile.periodStarts, ['2026-01-05']);
    });

    test('clear removes the record and the key', () async {
      final store = EncryptedFileStore(vault: vault, directory: dir);
      await store.save(_sample());
      await store.clear();
      expect(await store.load(), isA<Empty>());
      expect(await vault.read(recordKeyName), isNull);
    });
  });

  group('AppLock', () {
    test('verifies the PIN from a salted hash and never stores the PIN itself', () async {
      final vault = MemoryKeyVault();
      final lock = AppLock(vault);
      expect(await lock.isEnabled, isFalse);
      expect(await lock.verify('1234'), isFalse);
      await lock.setPin('2468');
      expect(await lock.isEnabled, isTrue);
      expect(await lock.verify('2468'), isTrue);
      expect(await lock.verify('2469'), isFalse);
      expect(await vault.read('lock-hash-v1'), isNot(contains('2468')));
      await lock.clear();
      expect(await lock.isEnabled, isFalse);
    });

    test('accepts only 4 to 8 digits', () {
      expect(AppLock.isValidPin('123'), isFalse);
      expect(AppLock.isValidPin('1234'), isTrue);
      expect(AppLock.isValidPin('12345678'), isTrue);
      expect(AppLock.isValidPin('123456789'), isFalse);
      expect(AppLock.isValidPin('12a4'), isFalse);
      expect(() => AppLock(MemoryKeyVault()).setPin('12'), throwsArgumentError);
    });
  });

  group('schema', () {
    test('a v1 record is carried forward to v2 with default settings', () {
      final v1 = {..._sample().toJson()}..['v'] = 1;
      v1.remove('settings');
      final migrated = migrateRecord(v1);
      expect(migrated['v'], schemaVersion);
      final profile = Profile.fromJson(migrated);
      expect(profile.settings.showHijri, isFalse);
      expect(profile.toJson()['v'], schemaVersion);
    });
  });
}
