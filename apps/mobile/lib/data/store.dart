// Where her record lives on the phone.
//
// Why it exists: v1 keeps one record, sealed with a key from the Android Keystore, in
// the app's private directory (ADR-070: records never leave the phone). This file
// owns the three things a private-records app must get right: the record is
// encrypted, saves never interleave or half-write, and a file that cannot be read is
// quarantined rather than silently replaced. Cloud sync, if it ever comes, is another
// implementation of [FemioStore]; no screen would change.

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'crypto/envelope.dart' as envelope;
import 'key_vault.dart';
import 'profile.dart';

/// What [FemioStore.load] found.
sealed class LoadOutcome {
  const LoadOutcome();
}

/// A record was read.
class Loaded extends LoadOutcome {
  const Loaded(this.profile);
  final Profile profile;
}

/// No record exists yet (first run, or after "delete everything").
class Empty extends LoadOutcome {
  const Empty();
}

/// A record file exists but could not be read. It has been moved aside to
/// [quarantinedPath] so nothing overwrites it; she can import a backup or start over.
class Corrupt extends LoadOutcome {
  const Corrupt(this.quarantinedPath);
  final String quarantinedPath;
}

/// Where her record lives. An interface so the app, the tests and a future sync
/// implementation share the same contract.
abstract class FemioStore {
  Future<LoadOutcome> load();
  Future<void> save(Profile profile);
  Future<void> clear();
}

/// The vault key under which the record's encryption key is kept.
const recordKeyName = 'record-key-v1';

/// The sealed record file and the plaintext file it replaces.
const recordFileName = 'femio-record.v2';
const legacyFileName = 'femio-record.json';

/// A sealed record file in the app's private support directory.
///
/// The key is created on first use and kept in the [KeyVault]. Saves are chained so
/// two taps in a row cannot interleave their writes, and each write goes to a
/// temporary file that is renamed into place, so a crash mid-write leaves the last
/// good record. A v1 plaintext file is migrated on first load and then deleted.
class EncryptedFileStore implements FemioStore {
  /// [directory] overrides the support directory (tests); [vault] holds the key.
  EncryptedFileStore({required KeyVault vault, Directory? directory, DateTime Function()? clock})
      : _vault = vault,
        _directory = directory,
        _clock = clock ?? DateTime.now;

  // ignore_for_file: prefer_initializing_formals
  final KeyVault _vault;
  final Directory? _directory;
  final DateTime Function() _clock;
  Future<void> _chain = Future.value();

  Future<Directory> _dir() async => _directory ?? await getApplicationSupportDirectory();

  Future<File> _file() async => File('${(await _dir()).path}/$recordFileName');

  Future<List<int>> _key() async {
    var stored = await _vault.read(recordKeyName);
    if (stored == null) {
      stored = envelope.newRecordKey();
      await _vault.write(recordKeyName, stored);
    }
    return base64Decode(stored);
  }

  @override
  Future<LoadOutcome> load() async {
    final file = await _file();
    if (!await file.exists()) {
      final migrated = await _migrateLegacy();
      if (migrated != null) return Loaded(migrated);
      return const Empty();
    }
    try {
      final clear = await envelope.open(await _key(), await file.readAsBytes());
      final json = jsonDecode(utf8.decode(clear)) as Map<String, Object?>;
      return Loaded(Profile.fromJson(migrateRecord(json)));
    } catch (_) {
      // Unreadable: wrong key, truncated, tampered, or a schema this build cannot
      // parse. Keep the bytes under another name; never let the next save bury them.
      final stamp = _clock().toIso8601String().replaceAll(':', '-');
      final quarantined = '${file.path}.corrupt-$stamp';
      await file.rename(quarantined);
      return Corrupt(quarantined);
    }
  }

  /// Reads a v0.4 plaintext record, seals it, deletes the plaintext. Returns the
  /// record, or null when there is none. An unreadable legacy file is left alone.
  Future<Profile?> _migrateLegacy() async {
    final legacy = File('${(await _dir()).path}/$legacyFileName');
    if (!await legacy.exists()) return null;
    try {
      final json = jsonDecode(await legacy.readAsString()) as Map<String, Object?>;
      final profile = Profile.fromJson(migrateRecord(json));
      await save(profile);
      await legacy.delete();
      return profile;
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(Profile profile) {
    // Serialise: each save waits for the previous one, whether it succeeded or not.
    final next = _chain.catchError((_) {}).then((_) => _write(profile));
    _chain = next;
    return next;
  }

  Future<void> _write(Profile profile) async {
    final file = await _file();
    final sealed = await envelope.seal(await _key(), utf8.encode(jsonEncode(profile.toJson())));
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(sealed, flush: true);
    await tmp.rename(file.path);
  }

  @override
  Future<void> clear() async {
    await _chain.catchError((_) {});
    final file = await _file();
    if (await file.exists()) await file.delete();
    final legacy = File('${(await _dir()).path}/$legacyFileName');
    if (await legacy.exists()) await legacy.delete();
    await _vault.delete(recordKeyName);
  }
}

/// For tests and screenshots.
class MemoryStore implements FemioStore {
  MemoryStore([this._profile]);
  Profile? _profile;

  @override
  Future<LoadOutcome> load() async => _profile == null ? const Empty() : Loaded(_profile!);

  @override
  Future<void> save(Profile profile) async => _profile = profile;

  @override
  Future<void> clear() async => _profile = null;
}
