import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:church_song_app/data/local_store.dart';
import 'package:church_song_app/data/settings_controller.dart';

Future<LocalStore> _freshStore() async {
  SharedPreferences.setMockInitialValues({});
  return LocalStore.open();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('starts with Italian, system theme and premium locked', () async {
    final settings = SettingsController(await _freshStore());

    expect(settings.value.languageCode, 'it');
    expect(settings.locale, const Locale('it'));
    expect(settings.themeMode, ThemeMode.system);
    expect(settings.premiumUnlocked, isFalse);
  });

  test('persists language, theme and premium state', () async {
    final store = await _freshStore();
    final settings = SettingsController(store);

    await settings.setLanguage('en');
    await settings.setThemeMode(ThemeMode.dark);
    await settings.setPremiumUnlocked(true);

    final reopened = SettingsController(store);
    expect(reopened.value.languageCode, 'en');
    expect(reopened.locale, const Locale('en'));
    expect(reopened.themeMode, ThemeMode.dark);
    expect(reopened.premiumUnlocked, isTrue);
  });

  test('ignores no-op updates without notifying', () async {
    final settings = SettingsController(await _freshStore());
    var notifications = 0;
    settings.addListener(() => notifications++);

    await settings.setLanguage('it');
    await settings.setThemeMode(ThemeMode.system);
    await settings.setPremiumUnlocked(false);

    expect(notifications, 0);
  });

  test('resetPreferences restores defaults', () async {
    final store = await _freshStore();
    final settings = SettingsController(store);
    await settings.setLanguage('en');
    await settings.setThemeMode(ThemeMode.light);
    await settings.setPremiumUnlocked(true);

    await settings.resetPreferences();

    expect(settings.value.languageCode, 'it');
    expect(settings.themeMode, ThemeMode.system);
    expect(settings.premiumUnlocked, isFalse);

    final reopened = SettingsController(store);
    expect(reopened.value.languageCode, 'it');
  });
}
