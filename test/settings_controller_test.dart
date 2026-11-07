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

  test('starts with Italian and the system theme', () async {
    final settings = SettingsController(await _freshStore());

    expect(settings.value.languageCode, 'it');
    expect(settings.locale, const Locale('it'));
    expect(settings.themeMode, ThemeMode.system);
  });

  test('persists language and theme', () async {
    final store = await _freshStore();
    final settings = SettingsController(store);

    await settings.setLanguage('en');
    await settings.setThemeMode(ThemeMode.dark);

    final reopened = SettingsController(store);
    expect(reopened.value.languageCode, 'en');
    expect(reopened.locale, const Locale('en'));
    expect(reopened.themeMode, ThemeMode.dark);
  });

  test('ignores no-op updates without notifying', () async {
    final settings = SettingsController(await _freshStore());
    var notifications = 0;
    settings.addListener(() => notifications++);

    await settings.setLanguage('it');
    await settings.setThemeMode(ThemeMode.system);

    expect(notifications, 0);
  });

  test('resetPreferences restores defaults', () async {
    final store = await _freshStore();
    final settings = SettingsController(store);
    await settings.setLanguage('en');
    await settings.setThemeMode(ThemeMode.light);

    await settings.resetPreferences();

    expect(settings.value.languageCode, 'it');
    expect(settings.themeMode, ThemeMode.system);

    final reopened = SettingsController(store);
    expect(reopened.value.languageCode, 'it');
  });
}
