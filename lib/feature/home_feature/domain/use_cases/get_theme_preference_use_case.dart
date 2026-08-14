import '../entities/theme_preference.dart';
import '../repositories/settings_repository.dart';

class GetThemePreferenceUseCase {
  const GetThemePreferenceUseCase(this._repository);

  final SettingsRepository _repository;

  Future<ThemePreference> call() {
    return _repository.getThemePreference();
  }
}
