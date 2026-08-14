import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<String?> getTheme();

  Future<void> setTheme(final String theme);

  Future<String?> getLanguageLocale();

  Future<void> setLanguageLocale(final String locale);
}

class SharedPreferencesSettingsLocalDataSource
    implements SettingsLocalDataSource {
  SharedPreferencesSettingsLocalDataSource(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<String?> getTheme() async {
    return _preferences.getString('theme');
  }

  @override
  Future<void> setTheme(final String theme) async {
    await _preferences.setString('theme', theme);
  }

  @override
  Future<String?> getLanguageLocale() async {
    return _preferences.getString('language');
  }

  @override
  Future<void> setLanguageLocale(final String locale) async {
    await _preferences.setString('language', locale);
  }
}
