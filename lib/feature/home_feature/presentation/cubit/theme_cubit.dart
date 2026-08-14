import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/theme_preference.dart';
import '../../domain/use_cases/get_theme_preference_use_case.dart';
import '../../domain/use_cases/toggle_theme_preference_use_case.dart';

class ThemeCubit extends Cubit<ThemeMode?> {
  ThemeCubit({
    required final GetThemePreferenceUseCase getThemePreferenceUseCase,
    required final ToggleThemePreferenceUseCase toggleThemePreferenceUseCase,
  })  : _getThemePreferenceUseCase = getThemePreferenceUseCase,
        _toggleThemePreferenceUseCase = toggleThemePreferenceUseCase,
        super(null) {
    initTheme();
  }

  final GetThemePreferenceUseCase _getThemePreferenceUseCase;
  final ToggleThemePreferenceUseCase _toggleThemePreferenceUseCase;

  Future<void> toggleTheme() async {
    final ThemePreference next = await _toggleThemePreferenceUseCase(
      _preferenceFromThemeMode(state),
    );
    emit(_themeModeFromPreference(next));
  }

  Future<void> initTheme() async {
    emit(_themeModeFromPreference(await _getThemePreferenceUseCase()));
  }

  ThemeMode _themeModeFromPreference(final ThemePreference preference) {
    switch (preference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  ThemePreference _preferenceFromThemeMode(final ThemeMode? mode) {
    if (mode == ThemeMode.light) {
      return ThemePreference.light;
    }
    return ThemePreference.dark;
  }
}
