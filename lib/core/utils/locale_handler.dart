import 'package:flutter/cupertino.dart';
import '../di/service_locator.dart';
import '../../feature/home_feature/domain/use_cases/get_language_locale_use_case.dart';
import '../../feature/home_feature/domain/use_cases/set_language_locale_use_case.dart';
import '../../i18n/strings.g.dart';

class LocaleHandler {
  Future<AppLocale> getLocale() async {
    final String storedLocale =
        await locator<GetLanguageLocaleUseCase>()() ?? '';
    if (storedLocale == '') {
      return AppLocale.en;
    }
    if (storedLocale == 'fr') {
      return AppLocale.fr;
    } else {
      return AppLocale.en;
    }
  }

  String getLocaleTitle(final BuildContext context) {
    if (checkEnState(context)) {
      return t.locales['en']!;
    } else {
      return t.locales['fr']!;
    }
  }

  Future<void> setFaLocale(final BuildContext context) async {
    await LocaleSettings.setLocale(AppLocale.fr);
    await locator<SetLanguageLocaleUseCase>()('fr');
  }

  Future<void> setEnLocale(final BuildContext context) async {
    await LocaleSettings.setLocale(AppLocale.en);
    await locator<SetLanguageLocaleUseCase>()('en');
  }
}

Future<void> changeLocale(final BuildContext context) async {
  if (checkEnState(context)) {
    await LocaleSettings.setLocale(AppLocale.fr);
    await locator<SetLanguageLocaleUseCase>()('fr');
  } else {
    await LocaleSettings.setLocale(AppLocale.en);
    await locator<SetLanguageLocaleUseCase>()('en');
  }
}

bool checkEnState(final BuildContext context) {
  try {
    if (TranslationProvider.of(context).flutterLocale == const Locale('en')) {
      return true;
    }
    return false;
  } catch (e) {
    return false;
  }
}
