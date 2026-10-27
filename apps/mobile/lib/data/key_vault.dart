// Where the small secrets live: the record's encryption key and the app-lock PIN hash.
//
// Why it exists: the record file is sealed with a key that must not sit beside it.
// On Android the key goes into the Keystore through flutter_secure_storage; tests
// use a memory vault so the data layer is exercised without a device. Nothing here
// touches the network.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// A tiny string-keyed secret store.
abstract class KeyVault {
  /// The value under [key], or null when none was written.
  Future<String?> read(String key);

  /// Writes [value] under [key], replacing any previous value.
  Future<void> write(String key, String value);

  /// Removes [key]; a missing key is not an error.
  Future<void> delete(String key);
}

/// The Android Keystore-backed vault (flutter_secure_storage's encrypted shared
/// preferences). Values are encrypted with a key the hardware holds, so a copied
/// data folder is useless without the phone.
class SecureKeyVault implements KeyVault {
  // flutter_secure_storage 10+ always uses Android's encrypted shared preferences
  // with a Keystore-held key; the defaults are the secure ones.
  SecureKeyVault() : _storage = const FlutterSecureStorage(aOptions: AndroidOptions());
  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// For tests: a vault that forgets everything when the process ends.
class MemoryKeyVault implements KeyVault {
  final Map<String, String> _values = {};

  @override
  Future<String?> read(String key) async => _values[key];

  @override
  Future<void> write(String key, String value) async => _values[key] = value;

  @override
  Future<void> delete(String key) async => _values.remove(key);
}
