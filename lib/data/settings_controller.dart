import 'package:flutter/material.dart';

import '../domain/models.dart';
import 'local_store.dart';

/// App-wide preferences: language, theme and premium state.
class SettingsController extends ChangeNotifier {
  SettingsController(this._store) {
    final raw = _store.readMap(_key);
    if (raw != null) {
      _settings = AppSettings.fromJson(raw);
    }
  }

  final LocalStore _store;
  static const _key = 'settings';

  AppSettings _settings = const AppSettings();

  AppSettings get value => _settings;

  Locale get locale => Locale(_settings.languageCode);

  ThemeMode get themeMode => switch (_settings.themeMode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };

  bool get premiumUnlocked => _settings.premiumUnlocked;

  String get youtubeApiKey => _settings.youtubeApiKey;

  Future<void> setYoutubeApiKey(String apiKey) async {
    if (_settings.youtubeApiKey == apiKey) return;
    _settings = _settings.copyWith(youtubeApiKey: apiKey);
    notifyListeners();
    await _persist();
  }

  Future<void> setLanguage(String languageCode) async {
    if (_settings.languageCode == languageCode) return;
    _settings = _settings.copyWith(languageCode: languageCode);
    notifyListeners();
    await _persist();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    if (_settings.themeMode == value) return;
    _settings = _settings.copyWith(themeMode: value);
    notifyListeners();
    await _persist();
  }

  Future<void> setPremiumUnlocked(bool unlocked) async {
    if (_settings.premiumUnlocked == unlocked) return;
    _settings = _settings.copyWith(premiumUnlocked: unlocked);
    notifyListeners();
    await _persist();
  }

  Future<void> resetPreferences() async {
    _settings = const AppSettings();
    notifyListeners();
    await _store.remove(_key);
  }

  Future<void> _persist() => _store.writeMap(_key, _settings.toJson());
}
