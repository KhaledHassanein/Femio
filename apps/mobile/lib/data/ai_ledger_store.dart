// Where the AI ledger is kept: a sealed file of its own, beside her record (R10.3).
//
// Why it exists: the ledger is about the AI, not her health, so it stays out of her record and
// therefore out of every backup. It is sealed like the record, with its own key, and cleared by
// "delete everything". An unreadable file is dropped, never shown half-read: the ledger is a
// convenience, while her record is the thing that must never be lost.

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../domain/assistant/ai_ledger.dart';
import 'crypto/envelope.dart' as envelope;
import 'key_vault.dart';

/// The ledger file and the vault key that seals it.
const ledgerFileName = 'femio-ai-ledger.v1';
const ledgerKeyName = 'ledger-key-v1';

/// Loads, saves and clears the ledger.
abstract class AiLedgerStore {
  Future<List<LedgerEntry>> load();
  Future<void> save(List<LedgerEntry> entries);
  Future<void> clear();
}

/// The sealed file in the app's private support directory.
class EncryptedLedgerStore implements AiLedgerStore {
  EncryptedLedgerStore({required KeyVault vault, Directory? directory})
      : _vault = vault,
        _directory = directory;

  // Named parameters cannot be private, so these are assigned in the initializer list.
  // ignore_for_file: prefer_initializing_formals
  final KeyVault _vault;
  final Directory? _directory;
  Future<void> _chain = Future.value();

  Future<File> _file() async => File('${(_directory ?? await getApplicationSupportDirectory()).path}/$ledgerFileName');

  Future<List<int>> _key() async {
    var stored = await _vault.read(ledgerKeyName);
    if (stored == null) {
      stored = envelope.newRecordKey();
      await _vault.write(ledgerKeyName, stored);
    }
    return base64Decode(stored);
  }

  @override
  Future<List<LedgerEntry>> load() async {
    final file = await _file();
    if (!await file.exists()) return const [];
    try {
      final clear = await envelope.open(await _key(), await file.readAsBytes());
      final list = jsonDecode(utf8.decode(clear)) as List;
      return [for (final j in list) ?LedgerEntry.fromJson(j)];
    } catch (_) {
      await file.delete();
      return const [];
    }
  }

  @override
  Future<void> save(List<LedgerEntry> entries) {
    final next = _chain.catchError((_) {}).then((_) async {
      final file = await _file();
      final sealed = await envelope.seal(await _key(), utf8.encode(jsonEncode([for (final e in entries) e.toJson()])));
      final tmp = File('${file.path}.tmp');
      await tmp.writeAsBytes(sealed, flush: true);
      await tmp.rename(file.path);
    });
    _chain = next;
    return next;
  }

  @override
  Future<void> clear() async {
    await _chain.catchError((_) {});
    final file = await _file();
    if (await file.exists()) await file.delete();
    await _vault.delete(ledgerKeyName);
  }
}

/// For tests and screenshots.
class MemoryLedgerStore implements AiLedgerStore {
  MemoryLedgerStore([List<LedgerEntry> entries = const []]) : _entries = entries;
  List<LedgerEntry> _entries;

  @override
  Future<List<LedgerEntry>> load() async => _entries;

  @override
  Future<void> save(List<LedgerEntry> entries) async => _entries = entries;

  @override
  Future<void> clear() async => _entries = const [];
}
