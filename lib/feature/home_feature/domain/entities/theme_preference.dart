enum ThemePreference { light, dark }

extension ThemePreferenceStorageValue on ThemePreference {
  String get storageValue {
    switch (this) {
      case ThemePreference.light:
        return 'light';
      case ThemePreference.dark:
        return 'dark';
    }
  }
}

ThemePreference themePreferenceFromStorage(final String? value) {
  if (value == ThemePreference.light.storageValue) {
    return ThemePreference.light;
  }
  return ThemePreference.dark;
}
