// R14.13 security hardening (SEC-1, SEC-2, SEC-4, SEC-11; ADR-085), each tested the way it
// can fail:
// - the fast PBKDF2 must give exactly the bytes of the `cryptography` package and of the
//   published test vectors, or every existing PIN and backup would stop opening;
// - a new backup records 600,000 rounds, an old file opens at the count it recorded, and a
//   hostile count or size is refused before any key work;
// - a backup with a bad document id is refused before the caller clears her documents;
// - wrong PINs earn a growing wait that survives a restart and cannot be stretched by a
//   clock change; the lock screen says how long;
// - screen protection follows the PIN.

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart' as pkg;
import 'package:femio/app.dart';
import 'package:femio/data/app_lock.dart';
import 'package:femio/data/backup.dart';
import 'package:femio/data/crypto/envelope.dart' as envelope;
import 'package:femio/data/crypto/pbkdf2.dart';
import 'package:femio/data/key_vault.dart';
import 'package:femio/data/profile.dart';
import 'package:femio/data/secure_screen.dart';
import 'package:femio/data/store.dart';
import 'package:femio/domain/record_attachment.dart';
import 'package:femio/features/lock/pin_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

String _hex(List<int> bytes) => bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();

Future<List<int>> _packagePbkdf2(String password, List<int> salt, int iterations, int length) async {
  final kdf = pkg.Pbkdf2(macAlgorithm: pkg.Hmac.sha256(), iterations: iterations, bits: length * 8);
  final key = await kdf.deriveKeyFromPassword(password: password, nonce: salt);
  return key.extractBytes();
}

Profile _profile({List<RecordAttachment> attachments = const []}) => Profile(
      goal: Goal.ttc,
      locale: 'en',
      birthYear: 1994,
      periodStarts: const ['2026-09-10'],
      cycleLength: 28,
      attachments: attachments,
    );

/// A backup file written the way femio did before ADR-085: the package's PBKDF2 at
/// [iterations], so the test proves old files still open under the new code.
Future<Uint8List> _oldStyleBackup(String passphrase, Map<String, Object?> body, int iterations) async {
  final salt = envelope.randomBytes(envelope.saltLength);
  final key = await _packagePbkdf2(passphrase, salt, iterations, envelope.keyLength);
  final sealed = await envelope.seal(key, utf8.encode(jsonEncode(body)), magic: envelope.backupMagic);
  final count = ByteData(4)..setUint32(0, iterations);
  return Uint8List.fromList([...ascii.encode(envelope.backupMagic), ...salt, ...count.buffer.asUint8List(), ...sealed]);
}

Map<String, Object?> _body(Profile p, {Map<String, String>? documents}) => {
      'kind': 'femio-backup',
      'exportedAt': '2026-11-27T10:00:00Z',
      'record': p.toJson(),
      'documents': ?documents,
    };

class _RecordingScreen implements SecureScreen {
  final calls = <bool>[];

  @override
  Future<void> protect(bool on) async => calls.add(on);
}

void main() {
  group('fast PBKDF2-HMAC-SHA256', () {
    test('matches published test vectors', () {
      // Widely published PBKDF2-HMAC-SHA256 vectors ("password"/"salt") and RFC 7914 §11.
      expect(_hex(pbkdf2HmacSha256('password', utf8.encode('salt'), iterations: 1)),
          '120fb6cffcf8b32c43e7225256c4f837a86548c92ccc35480805987cb70be17b');
      expect(_hex(pbkdf2HmacSha256('password', utf8.encode('salt'), iterations: 2)),
          'ae4d0c95af6b46d32d0adff928f06dd02a303f8ef3c251dfd6e2d85a95474c43');
      expect(_hex(pbkdf2HmacSha256('password', utf8.encode('salt'), iterations: 4096)),
          'c5e478d59288c841aa530db6845c4c8d962893a001ce4e11a4963873aa98134a');
      expect(_hex(pbkdf2HmacSha256('passwd', utf8.encode('salt'), iterations: 1, length: 64)),
          '55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc'
          '49ca9cccf179b645991664b39d77ef317c71b845b1e30bd509112041d3a19783');
    });

    test('gives byte-for-byte the package output for any password, salt and length', () async {
      final random = Random(20261127);
      final passwords = ['', 'ward al nil', 'كلمة سر طويلة جدا', 'é' * 40, 'x' * 100, '2468'];
      for (var i = 0; i < 24; i += 1) {
        final password = passwords[i % passwords.length];
        final salt = List<int>.generate(random.nextInt(40), (_) => random.nextInt(256));
        final iterations = 1 + random.nextInt(60);
        // The package refuses under 8 bytes; 8 to 80 covers one, two and three blocks.
        final length = 8 + random.nextInt(73);
        expect(pbkdf2HmacSha256(password, salt, iterations: iterations, length: length),
            await _packagePbkdf2(password, salt, iterations, length),
            reason: 'case $i: ${password.length} chars, salt ${salt.length}, $iterations rounds, $length bytes');
      }
    });

    test('envelope.deriveKey (background isolate) equals the package at the PIN count', () async {
      final salt = envelope.randomBytes(envelope.saltLength);
      expect(await envelope.deriveKey('2468', salt, iterations: pinIterations), await _packagePbkdf2('2468', salt, pinIterations, 32));
      expect(() => pbkdf2HmacSha256('a', const [], iterations: 0), throwsArgumentError);
    });
  });

  group('backup key derivation and import order', () {
    test('a new backup records 600,000 rounds and opens again', () async {
      final bytes = await encodeBackup(_profile(), 'a long enough passphrase');
      final count = ByteData.sublistView(bytes, 4 + envelope.saltLength, 8 + envelope.saltLength).getUint32(0);
      expect(count, envelope.backupIterations);
      expect(envelope.backupIterations, 600000);
      expect((await decodeBackup(bytes, 'a long enough passphrase')).goal, Goal.ttc);
    });

    test('an old 120,000-round file with a 6-character passphrase still opens at its own count', () async {
      final old = await _oldStyleBackup('nile26', _body(_profile()), 120000);
      expect((await decodeBackup(old, 'nile26')).birthYear, 1994);
    });

    test('a new passphrase needs 10 characters; opening keeps the old 6-character floor', () {
      expect(minNewPassphraseLength, 10);
      expect(minPassphraseLength, 6);
      expect(() => encodeBackup(_profile(), 'ninechars'), throwsArgumentError);
    });

    test('a hostile round count is refused at once, without deriving a key', () async {
      final file = await _oldStyleBackup('nile26', _body(_profile()), 1000);
      ByteData.sublistView(file, 4 + envelope.saltLength, 8 + envelope.saltLength).setUint32(0, envelope.maxBackupIterations + 1);
      final watch = Stopwatch()..start();
      await expectLater(decodeBackup(file, 'nile26'),
          throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.notAFemioFile)));
      expect(watch.elapsedMilliseconds, lessThan(500));
    });

    test('a file bigger than any femio backup is refused before it is opened', () async {
      final huge = Uint8List(maxBackupFileBytes + 1);
      await expectLater(decodeBackup(huge, 'nile26'),
          throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.notAFemioFile)));
    });

    test('a document id that could leave the folder is refused before anything is restored', () async {
      final bad = await _oldStyleBackup('nile26', _body(_profile(), documents: {'../../record': base64Encode([1, 2, 3])}), 1000);
      await expectLater(decodeBackupWithDocuments(bad, 'nile26'),
          throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.unreadableRecord)));
    });

    test('an oversized document is refused; one the record does not describe is left out', () async {
      final big = base64Encode(Uint8List(maxAttachmentBytes + 1));
      final tooBig = await _oldStyleBackup('nile26', _body(_profile(), documents: {'abcdefgh12': big}), 1000);
      await expectLater(decodeBackupWithDocuments(tooBig, 'nile26'),
          throwsA(predicate((e) => e is BackupError && e.failure == BackupFailure.unreadableRecord)));

      const kept = RecordAttachment(id: 'abcdefgh12', name: 'Lab.pdf', mime: 'application/pdf', sizeBytes: 3, addedOn: '2026-11-26T10:00:00');
      final mixed = await _oldStyleBackup(
        'nile26',
        _body(_profile(attachments: [kept]), documents: {'abcdefgh12': base64Encode([1, 2, 3]), 'strayfile99': base64Encode([9])}),
        1000,
      );
      final restored = await decodeBackupWithDocuments(mixed, 'nile26');
      expect(restored.documents.keys, ['abcdefgh12']);
    });
  });

  group('PIN wait (SEC-2)', () {
    late MemoryKeyVault vault;
    late DateTime now;
    AppLock lock() => AppLock(vault, clock: () => now);

    setUp(() async {
      vault = MemoryKeyVault();
      now = DateTime(2026, 11, 27, 9);
      await lock().setPin('2468');
    });

    test('the schedule: four free misses, then 30 s doubling to a 30-minute ceiling', () {
      expect([for (var f = 0; f <= 12; f += 1) pinWaitAfter(f).inSeconds],
          [0, 0, 0, 0, 0, 30, 60, 120, 240, 480, 960, 1800, 1800]);
      expect(pinWaitAfter(400), maxPinWait);
    });

    test('the fifth miss starts a wait; the right PIN is refused during it and accepted after', () async {
      final l = lock();
      for (var i = 0; i < 4; i += 1) {
        expect(await l.verify('0000'), isFalse);
        expect(await l.retryAfter(), Duration.zero);
      }
      expect(await l.verify('0000'), isFalse);
      expect(await l.retryAfter(), const Duration(seconds: 30));
      expect(AppLock.waitUntil.value, now.add(const Duration(seconds: 30)));
      expect(await l.verify('2468'), isFalse, reason: 'no check at all during a wait');

      now = now.add(const Duration(seconds: 31));
      expect(await l.verify('2468'), isTrue);
      expect(AppLock.waitUntil.value, isNull);
      // The count was cleared: four more free misses.
      for (var i = 0; i < 4; i += 1) {
        await l.verify('1111');
      }
      expect(await l.retryAfter(), Duration.zero);
    });

    test('the wait survives a restart and grows with each further miss', () async {
      for (var i = 0; i < 5; i += 1) {
        await lock().verify('0000');
      }
      // A new AppLock over the same vault is the app after a restart.
      expect(await lock().retryAfter(), const Duration(seconds: 30));
      now = now.add(const Duration(seconds: 30));
      await lock().verify('0000');
      expect(await lock().retryAfter(), const Duration(seconds: 60));
    });

    test('setting the clock back cannot stretch a wait past the ceiling', () async {
      for (var i = 0; i < 5; i += 1) {
        await lock().verify('0000');
      }
      now = now.subtract(const Duration(days: 30));
      expect(await lock().retryAfter(), maxPinWait);
    });
  });

  group('screen protection follows the PIN (SEC-1)', () {
    test('on when a PIN is set, off when removed, synced at start', () async {
      final screen = _RecordingScreen();
      final vault = MemoryKeyVault();
      final l = AppLock(vault, screen: screen);
      expect(await l.isEnabled, isFalse);
      await l.setPin('2468');
      expect(await AppLock(vault, screen: screen).isEnabled, isTrue);
      await l.clear();
      expect(screen.calls, [false, true, true, false]);
    });

    test('a test vault never reaches the platform channel', () async {
      // MemoryKeyVault picks NoSecureScreen, so no MethodChannel is touched in unit tests.
      await AppLock(MemoryKeyVault()).setPin('1357');
    });
  });

  testWidgets('the lock screen says how long to wait and rests the PIN field', (tester) async {
    final c = FemioController(MemoryStore(_profile()));
    await c.load();
    c.locked = true;
    AppLock.waitUntil.value = DateTime.now().add(const Duration(seconds: 150));
    await tester.pumpWidget(FemioApp(controller: c, today: '2026-11-27'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Too many tries. Try again in 3 minutes.'), findsOneWidget);
    final field = tester.widget<TextField>(find.descendant(of: find.byType(PinField), matching: find.byType(TextField)));
    expect(field.enabled, isFalse);

    AppLock.waitUntil.value = DateTime.now().add(const Duration(seconds: 20));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('Try again in'), findsOneWidget);
    expect(find.textContaining('seconds'), findsOneWidget);

    AppLock.waitUntil.value = null;
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.textContaining('Too many tries'), findsNothing);
  });
}
