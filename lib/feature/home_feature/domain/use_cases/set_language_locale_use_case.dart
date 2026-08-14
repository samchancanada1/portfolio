import '../repositories/settings_repository.dart';

class SetLanguageLocaleUseCase {
  const SetLanguageLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(final String locale) {
    return _repository.setLanguageLocale(locale);
  }
}
