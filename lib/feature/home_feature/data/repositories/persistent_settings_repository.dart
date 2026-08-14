import '../../domain/entities/theme_preference.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/local/settings_local_data_source.dart';

class PersistentSettingsRepository implements SettingsRepository {
  const PersistentSettingsRepository(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<ThemePreference> getThemePreference() async {
    return themePreferenceFromStorage(await _localDataSource.getTheme());
  }

  @override
  Future<ThemePreference> toggleThemePreference(
    final ThemePreference current,
  ) async {
    final ThemePreference next = current == ThemePreference.light
        ? ThemePreference.dark
        : ThemePreference.light;
    await _localDataSource.setTheme(next.storageValue);
    return next;
  }

  @override
  Future<String?> getLanguageLocale() {
    return _localDataSource.getLanguageLocale();
  }

  @override
  Future<void> setLanguageLocale(final String locale) {
    return _localDataSource.setLanguageLocale(locale);
  }
}
