import 'package:flutter/cupertino.dart';
import '../../feature/home_feature/data/data_sources/local/home_storage.dart';
import '../../i18n/strings.g.dart';

class LocaleHandler {
  Future<AppLocale> getLocale() async {
    final String storedLocale = await HomeStorage().getLanguageLocale() ?? '';
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

  void setFaLocale(final BuildContext context) {
    LocaleSettings.setLocale(AppLocale.fr);
    HomeStorage().setLanguageLocale('fr');
  }

  void setEnLocale(final BuildContext context) {
    LocaleSettings.setLocale(AppLocale.en);
    HomeStorage().setLanguageLocale('en');
  }
}

void changeLocale(final BuildContext context) {
  if (checkEnState(context)) {
    LocaleSettings.setLocale(AppLocale.fr);
    HomeStorage().setLanguageLocale('fr');
  } else {
    LocaleSettings.setLocale(AppLocale.en);
    HomeStorage().setLanguageLocale('en');
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
