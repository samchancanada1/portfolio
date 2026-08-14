import '../entities/theme_preference.dart';

abstract class SettingsRepository {
  Future<ThemePreference> getThemePreference();

  Future<ThemePreference> toggleThemePreference(final ThemePreference current);

  Future<String?> getLanguageLocale();

  Future<void> setLanguageLocale(final String locale);
}
