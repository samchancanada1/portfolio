import '../entities/theme_preference.dart';
import '../repositories/settings_repository.dart';

class ToggleThemePreferenceUseCase {
  const ToggleThemePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  Future<ThemePreference> call(final ThemePreference current) {
    return _repository.toggleThemePreference(current);
  }
}
