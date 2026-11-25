// Loads the bundled trusted-source registry once (ADR-079).
//
// Why it exists: the registry is a file inside the app, read from the asset bundle, never from
// the network. Parsing it is the one moment its licence rule is checked
// (`SourceRegistry.fromJson`); a broken file gives an empty registry, so "Ask femio" says
// "not covered" instead of crashing, and the registry test fails before any release.

import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/assistant/source_registry.dart';

/// Where the registry lives in the app bundle (declared in pubspec.yaml).
const registryAsset = 'assets/trusted_sources/registry.json';

SourceRegistry? _cached;

/// The registry, read from [bundle] (defaults to the app's own) on first use and kept after.
/// Returns [SourceRegistry.empty] when the file cannot be read or parsed.
Future<SourceRegistry> loadTrustedRegistry([AssetBundle? bundle]) async {
  final cached = _cached;
  if (cached != null) return cached;
  try {
    final raw = await (bundle ?? rootBundle).loadString(registryAsset);
    return _cached = SourceRegistry.fromJson(jsonDecode(raw) as Map<String, Object?>);
  } on Object {
    return SourceRegistry.empty;
  }
}
