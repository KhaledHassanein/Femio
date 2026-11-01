// Where her record lives on the phone.
//
// Why it exists: v1 keeps one record, sealed with a key from the Android Keystore, in
// the app's private directory (ADR-070: records never leave the phone). This file
// owns the things a private-records app must get right: the record is encrypted,
// saves never interleave or half-write, and a file that cannot be read is kept, never
// silently replaced. Loading never throws: a failure becomes an [Unavailable] or
// [Corrupt] outcome that the recovery screens explain. Cloud sync, if it ever comes, is
// another implementation of [FemioStore]; no screen would change.

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

/// Why a record could not be opened right now.
enum UnavailableReason {
  /// The key vault (Android Keystore) threw: the record file may be perfectly fine.
  vault,

  /// A record file exists but the vault has no key for it (Keystore reset, lock-screen
  /// change on some phones). The file cannot be opened, but it is kept as it is.
  keyMissing,

  /// The phone's storage failed (directory missing, read error, cannot move the file).
  storage,
}

/// A record file may exist, but it could not be opened right now. Unlike [Corrupt],
/// nothing is judged about the file: it is left exactly where it is, so "try again" can
/// still work. The recovery screen offers retry, restore, or start empty.
class Unavailable extends LoadOutcome {
  const Unavailable(this.reason);
  final UnavailableReason reason;
}

/// Where her record lives. An interface so the app, the tests and a future sync
/// implementation share the same contract.
abstract class FemioStore {
  /// Reads the record. Never throws: every failure is an [Unavailable] or [Corrupt].
  Future<LoadOutcome> load();
  Future<void> save(Profile profile);
  Future<void> clear();

  /// Moves a record file that cannot be opened out of the way, WITHOUT deleting it, so
  /// the next save cannot bury it. Returns where it went, or null when there was none.
  /// Throws when the file cannot be moved (then nothing has changed).
  Future<String?> setAside();
}

/// The vault key under which the record's encryption key is kept.
const recordKeyName = 'record-key-v1';

/// The sealed record file and the plaintext file it replaces.
const recordFileName = 'femio-record.v2';
const legacyFileName = 'femio-record.json';

/// A sealed record file in the app's private support directory.
///
/// The key is created on first save and kept in the [KeyVault]. Saves are chained so
/// two taps in a row cannot interleave their writes, and each write goes to a
/// temporary file that is renamed into place, so a crash mid-write leaves the last
/// good record. A v1 plaintext file is migrated on first load and then deleted.
///
/// A load never creates a key and never deletes a file. A record it cannot open is
/// either moved aside ([Corrupt]: the key is there but the bytes are wrong) or left in
/// place ([Unavailable]: the key or the storage failed, so a retry may still work).
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

  /// The record key (base64) once it has been read or created, so a vault that fails
  /// later in the session cannot stop a save.
  String? _cachedKey;

  /// True after a load found a record file it could not open. The next save, or an
  /// explicit [setAside], moves that file aside first so it is never overwritten.
  bool _unreadableOnDisk = false;

  Future<Directory> _dir() async => _directory ?? await getApplicationSupportDirectory();

  Future<File> _file() async => File('${(await _dir()).path}/$recordFileName');

  /// The key to seal a save with: the cached or stored one, else a new one. A vault that
  /// throws on read is treated as empty here, so a broken Keystore entry can be replaced.
  /// Only saves come here; a load never creates a key (see [_load]).
  Future<List<int>> _keyForWrite() async {
    var text = _cachedKey;
    if (text == null) {
      try {
        text = await _vault.read(recordKeyName);
      } catch (_) {
        text = null;
      }
      if (text == null) {
        text = envelope.newRecordKey();
        await _vault.write(recordKeyName, text);
      }
      _cachedKey = text;
    }
    return base64Decode(text);
  }

  /// Moves [file] to `<name>.<label>-<time>` and returns the new path.
  Future<String> _moveAside(File file, String label) async {
    final stamp = _clock().toIso8601String().replaceAll(':', '-');
    final target = '${file.path}.$label-$stamp';
    await file.rename(target);
    return target;
  }

  @override
  Future<LoadOutcome> load() async {
    try {
      return await _load();
    } catch (_) {
      // Anything unforeseen is "not now", never a crash and never a verdict on her file.
      return const Unavailable(UnavailableReason.storage);
    }
  }

  Future<LoadOutcome> _load() async {
    final File file;
    try {
      file = await _file();
      if (!await file.exists()) {
        final migrated = await _migrateLegacy();
        return migrated == null ? const Empty() : Loaded(migrated);
      }
    } catch (_) {
      return const Unavailable(UnavailableReason.storage);
    }

    // A record exists. Read the key WITHOUT creating one: a fresh key could not open this
    // file, and writing it would overwrite the old key that a retry might still find.
    final String? keyText;
    try {
      keyText = await _vault.read(recordKeyName);
    } catch (_) {
      _unreadableOnDisk = true;
      return const Unavailable(UnavailableReason.vault);
    }
    if (keyText == null) {
      _unreadableOnDisk = true;
      return const Unavailable(UnavailableReason.keyMissing);
    }

    final List<int> sealed;
    try {
      sealed = await file.readAsBytes();
    } catch (_) {
      _unreadableOnDisk = true;
      return const Unavailable(UnavailableReason.storage);
    }
    try {
      final clear = await envelope.open(base64Decode(keyText), sealed);
      final json = jsonDecode(utf8.decode(clear)) as Map<String, Object?>;
      final profile = Profile.fromJson(migrateRecord(json));
      _cachedKey = keyText;
      _unreadableOnDisk = false;
      return Loaded(profile);
    } catch (_) {
      // Unreadable under the key we hold: truncated, tampered, written by another build,
      // or a schema this build cannot parse. Keep the bytes under another name; never let
      // the next save bury them. If even the move fails, say "not now" and touch nothing.
      try {
        return Corrupt(await _moveAside(file, 'corrupt'));
      } catch (_) {
        _unreadableOnDisk = true;
        return const Unavailable(UnavailableReason.storage);
      }
    }
  }

  /// Reads a v0.4 plaintext record, seals it, deletes the plaintext. Returns the
  /// record, or null when there is none. An unreadable legacy file is left alone.
  Future<Profile?> _migrateLegacy() async {
    final legacy = File('${(await _dir()).path}/$legacyFileName');
    if (!await legacy.exists()) return null;
    final Profile profile;
    try {
      final json = jsonDecode(await legacy.readAsString()) as Map<String, Object?>;
      profile = Profile.fromJson(migrateRecord(json));
    } catch (_) {
      return null;
    }
    await save(profile);
    await legacy.delete();
    return profile;
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
    if (_unreadableOnDisk) {
      // A record we could not open is still there: set it aside before writing, so the
      // rename below cannot replace it. This is the only way a save follows a failed load.
      if (await file.exists()) await _moveAside(file, 'set-aside');
      _unreadableOnDisk = false;
    }
    final sealed = await envelope.seal(await _keyForWrite(), utf8.encode(jsonEncode(profile.toJson())));
    final tmp = File('${file.path}.tmp');
    await tmp.writeAsBytes(sealed, flush: true);
    await tmp.rename(file.path);
  }

  @override
  Future<String?> setAside() async {
    await _chain.catchError((_) {});
    final file = await _file();
    if (!await file.exists()) {
      _unreadableOnDisk = false;
      return null;
    }
    final moved = await _moveAside(file, 'set-aside');
    _unreadableOnDisk = false;
    return moved;
  }

  @override
  Future<void> clear() async {
    await _chain.catchError((_) {});
    final file = await _file();
    if (await file.exists()) await file.delete();
    final legacy = File('${(await _dir()).path}/$legacyFileName');
    if (await legacy.exists()) await legacy.delete();
    await _vault.delete(recordKeyName);
    _cachedKey = null;
    _unreadableOnDisk = false;
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

  @override
  Future<String?> setAside() async {
    _profile = null;
    return null;
  }
}
