import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences].
///
/// Everything user-generated is stored as versioned JSON strings. Replacing
/// this class with a database (Drift, Isar, ...) does not affect the
/// repositories, and the same payloads can later be pushed to a cloud
/// backend.
class LocalStore {
  LocalStore._(this._prefs);

  static Future<LocalStore> open() async =>
      LocalStore._(await SharedPreferences.getInstance());

  final SharedPreferences _prefs;

  static const _prefix = 'churchsong.v1.';

  String _key(String key) => '$_prefix$key';

  String? readString(String key) => _prefs.getString(_key(key));

  Future<void> writeString(String key, String value) =>
      _prefs.setString(_key(key), value);

  Future<void> remove(String key) => _prefs.remove(_key(key));

  Future<void> clearAll() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_prefix));
    for (final key in keys.toList()) {
      await _prefs.remove(key);
    }
  }

  List<dynamic>? readList(String key) {
    final raw = readString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is List ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeList(String key, List<dynamic> value) =>
      writeString(key, jsonEncode(value));

  Map<String, dynamic>? readMap(String key) {
    final raw = readString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) =>
      writeString(key, jsonEncode(value));
}
