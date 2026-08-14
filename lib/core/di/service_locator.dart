import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/home_feature/data/data_sources/local/settings_local_data_source.dart';
import '../../feature/home_feature/data/repositories/persistent_settings_repository.dart';
import '../../feature/home_feature/data/repositories/static_portfolio_repository.dart';
import '../../feature/home_feature/domain/repositories/portfolio_repository.dart';
import '../../feature/home_feature/domain/repositories/settings_repository.dart';
import '../../feature/home_feature/domain/use_cases/get_home_content_use_case.dart';
import '../../feature/home_feature/domain/use_cases/get_language_locale_use_case.dart';
import '../../feature/home_feature/domain/use_cases/get_theme_preference_use_case.dart';
import '../../feature/home_feature/domain/use_cases/set_language_locale_use_case.dart';
import '../../feature/home_feature/domain/use_cases/toggle_theme_preference_use_case.dart';
import '../../feature/home_feature/presentation/cubit/home_content_cubit.dart';
import '../../feature/home_feature/presentation/cubit/home_navigation_cubit.dart';
import '../../feature/home_feature/presentation/cubit/theme_cubit.dart';

final GetIt locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  if (locator.isRegistered<PortfolioRepository>()) {
    return;
  }

  final SharedPreferences preferences = await SharedPreferences.getInstance();

  locator.registerLazySingleton<SettingsLocalDataSource>(
    () => SharedPreferencesSettingsLocalDataSource(preferences),
  );
  locator.registerLazySingleton<SettingsRepository>(
    () => PersistentSettingsRepository(locator<SettingsLocalDataSource>()),
  );
  locator.registerLazySingleton<GetThemePreferenceUseCase>(
    () => GetThemePreferenceUseCase(locator<SettingsRepository>()),
  );
  locator.registerLazySingleton<ToggleThemePreferenceUseCase>(
    () => ToggleThemePreferenceUseCase(locator<SettingsRepository>()),
  );
  locator.registerLazySingleton<GetLanguageLocaleUseCase>(
    () => GetLanguageLocaleUseCase(locator<SettingsRepository>()),
  );
  locator.registerLazySingleton<SetLanguageLocaleUseCase>(
    () => SetLanguageLocaleUseCase(locator<SettingsRepository>()),
  );
  locator.registerFactory<ThemeCubit>(
    () => ThemeCubit(
      getThemePreferenceUseCase: locator<GetThemePreferenceUseCase>(),
      toggleThemePreferenceUseCase: locator<ToggleThemePreferenceUseCase>(),
    ),
  );

  locator.registerLazySingleton<PortfolioRepository>(
    () => const StaticPortfolioRepository(),
  );
  locator.registerLazySingleton<GetHomeContentUseCase>(
    () => GetHomeContentUseCase(locator<PortfolioRepository>()),
  );
  locator.registerFactory<HomeContentCubit>(
    () => HomeContentCubit(locator<GetHomeContentUseCase>()),
  );
  locator.registerFactoryParam<HomeNavigationCubit, HomeSection, void>(
    (final section, _) => HomeNavigationCubit(section),
  );
}
