import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/feature/home_feature/data/data_sources/local/settings_local_data_source.dart';
import 'package:portfolio/feature/home_feature/data/repositories/persistent_settings_repository.dart';
import 'package:portfolio/feature/home_feature/domain/entities/theme_preference.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/get_theme_preference_use_case.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/toggle_theme_preference_use_case.dart';
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
}
