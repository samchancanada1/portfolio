import '../repositories/settings_repository.dart';

class GetLanguageLocaleUseCase {
  const GetLanguageLocaleUseCase(this._repository);

  final SettingsRepository _repository;

  Future<String?> call() {
    return _repository.getLanguageLocale();
  }
}
