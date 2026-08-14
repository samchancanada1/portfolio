import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/feature/home_feature/data/data_sources/local/settings_local_data_source.dart';
import 'package:portfolio/feature/home_feature/data/repositories/persistent_settings_repository.dart';
import 'package:portfolio/feature/home_feature/domain/entities/theme_preference.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/get_language_locale_use_case.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/get_theme_preference_use_case.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/set_language_locale_use_case.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/toggle_theme_preference_use_case.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/primary_color_cubit.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<PersistentSettingsRepository> buildRepository({
    final Map<String, Object> initialValues = const {},
  }) async {
    SharedPreferences.setMockInitialValues(initialValues);
    final preferences = await SharedPreferences.getInstance();
    return PersistentSettingsRepository(
      SharedPreferencesSettingsLocalDataSource(preferences),
    );
  }

  test('theme preference parser defaults unknown values to dark', () {
    expect(themePreferenceFromStorage('light'), ThemePreference.light);
    expect(themePreferenceFromStorage('dark'), ThemePreference.dark);
    expect(themePreferenceFromStorage(null), ThemePreference.dark);
    expect(themePreferenceFromStorage('unexpected'), ThemePreference.dark);
  });

  test('settings local data source reads and writes shared preferences',
      () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final dataSource = SharedPreferencesSettingsLocalDataSource(preferences);

    expect(await dataSource.getTheme(), isNull);
    expect(await dataSource.getLanguageLocale(), isNull);

    await dataSource.setTheme('light');
    await dataSource.setLanguageLocale('fr');

    expect(await dataSource.getTheme(), 'light');
    expect(await dataSource.getLanguageLocale(), 'fr');
  });

  test('settings repository persists theme and language preferences', () async {
    final repository = await buildRepository(
      initialValues: {'theme': 'light', 'language': 'fr'},
    );

    expect(await repository.getThemePreference(), ThemePreference.light);
    expect(await repository.getLanguageLocale(), 'fr');

    final nextTheme = await repository.toggleThemePreference(
      ThemePreference.light,
    );
    await repository.setLanguageLocale('en');

    expect(nextTheme, ThemePreference.dark);
    expect(await repository.getThemePreference(), ThemePreference.dark);
    expect(await repository.getLanguageLocale(), 'en');
  });

  test('settings use cases delegate to the repository', () async {
    final repository = await buildRepository();
    final getTheme = GetThemePreferenceUseCase(repository);
    final toggleTheme = ToggleThemePreferenceUseCase(repository);
    final getLanguage = GetLanguageLocaleUseCase(repository);
    final setLanguage = SetLanguageLocaleUseCase(repository);

    expect(await getTheme(), ThemePreference.dark);
    expect(await toggleTheme(ThemePreference.dark), ThemePreference.light);

    await setLanguage('fr');

    expect(await getLanguage(), 'fr');
  });

  test('theme cubit loads and toggles through use cases', () async {
    final repository = await buildRepository(
      initialValues: {'theme': 'dark'},
    );
    final cubit = ThemeCubit(
      getThemePreferenceUseCase: GetThemePreferenceUseCase(repository),
      toggleThemePreferenceUseCase: ToggleThemePreferenceUseCase(repository),
    );

    expect(await cubit.stream.first, ThemeMode.dark);

    await cubit.toggleTheme();

    expect(cubit.state, ThemeMode.light);

    await cubit.close();
  });

  test('theme cubit toggles from light back to dark', () async {
    final repository = await buildRepository(
      initialValues: {'theme': 'light'},
    );
    final cubit = ThemeCubit(
      getThemePreferenceUseCase: GetThemePreferenceUseCase(repository),
      toggleThemePreferenceUseCase: ToggleThemePreferenceUseCase(repository),
    );

    expect(await cubit.stream.first, ThemeMode.light);

    await cubit.toggleTheme();

    expect(cubit.state, ThemeMode.dark);

    await cubit.close();
  });

  test('primary color cubit emits each supported color preset', () {
    final cubit = PrimaryColorCubit();

    expect(cubit.state.primaryColor, isNot(Colors.red));

    cubit.setRedColor();
    expect(cubit.state.primaryColor, Colors.red);
    expect(cubit.state.lightPrimaryColor, Colors.red);

    cubit.setGreenColor();
    expect(cubit.state.primaryColor, Colors.green);

    cubit.setBlueColor();
    expect(cubit.state.primaryColor, Colors.blue);

    cubit.setPurpleColor();
    expect(cubit.state.primaryColor, isNot(Colors.blue));

    final copiedState = cubit.state.copyWith();
    expect(copiedState.primaryColor, cubit.state.primaryColor);
    expect(copiedState.lightPrimaryColor, cubit.state.lightPrimaryColor);

    cubit.close();
  });
}
