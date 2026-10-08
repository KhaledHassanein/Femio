import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'profile.dart';

/// Where her record lives. An interface so cloud sync can be added later as another
/// implementation without any screen changing (04_ANDROID_APP_SPEC §5). v1 has only
/// local ones: nothing here makes a network request.
abstract class FemioStore {
  Future<Profile?> load();
  Future<void> save(Profile profile);
  Future<void> clear();
}

/// A JSON file in the app's private support directory. Android sandboxes it to this
/// app and encrypts it at rest with the device's file-based encryption; an app lock
/// and Keystore-backed encryption come with P3.8.
class FileStore implements FemioStore {
  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/femio-record.json');
  }

  @override
  Future<Profile?> load() async {
    final f = await _file();
    if (!await f.exists()) return null;
    try {
      return Profile.fromJson(jsonDecode(await f.readAsString()) as Map<String, Object?>);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(Profile profile) async {
    final f = await _file();
    // Write then rename, so a crash mid-write never leaves half a record.
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(jsonEncode(profile.toJson()), flush: true);
    await tmp.rename(f.path);
  }

  @override
  Future<void> clear() async {
    final f = await _file();
    if (await f.exists()) await f.delete();
  }
}

/// For tests and screenshots.
class MemoryStore implements FemioStore {
  MemoryStore([this._profile]);
  Profile? _profile;

  @override
  Future<Profile?> load() async => _profile;

  @override
  Future<void> save(Profile profile) async => _profile = profile;

  @override
  Future<void> clear() async => _profile = null;
}
