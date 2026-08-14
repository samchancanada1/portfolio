import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/service_locator.dart';
import 'package:portfolio/core/routes/go_routes_path.dart';
import 'package:portfolio/core/theme/colors.dart';
import 'package:portfolio/core/theme/dimens.dart';
import 'package:portfolio/core/theme/theme.dart';
import 'package:portfolio/core/utils/check_theme_status.dart';
import 'package:portfolio/core/utils/locale_handler.dart';
import 'package:portfolio/feature/home_feature/domain/use_cases/set_language_locale_use_case.dart';
import 'package:portfolio/i18n/strings.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await locator.reset();
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  test('route paths expose the public home locations', () {
    expect(GoRoutesPath.splash, '/');
    expect(GoRoutesPath.home, '/home');
    expect(GoRoutesPath.about, '/about');
    expect(GoRoutesPath.resume, '/resume');
    expect(GoRoutesPath.skills, '/skills');
    expect(GoRoutesPath.settings, '/settings');
  });

  test('dimension constants derive from the shared base unit', () {
    expect(Dimens.padding, Dimens.base);
    expect(Dimens.largePadding, Dimens.base * 2);
    expect(Dimens.extraLargePadding, Dimens.base * 4);
    expect(Dimens.mediumDeviceBreakPoint, 768.0);
  });

  test('app color palette exposes all named colors', () {
    expect(AppColors.primaryColor, const Color(0xff00A896));
    expect(AppColors.lightPrimaryColor, const Color(0xff35D0BA));
    expect(AppColors.secondColor, const Color(0xffE76F51));
    expect(AppColors.colorAttention, const Color(0xffE85D75));
    expect(AppColors.ink, const Color(0xff061316));
    expect(AppColors.ivory, const Color(0xffF8F6EF));
    expect(AppColors.mist, const Color(0xffEDF6F5));
    expect(AppColors.disableColor, const Color(0xff757575));
    expect(AppColors.lightGray, const Color(0xffD5D5D5));
    expect(AppColors.gray, const Color(0xffE0E0E0));
    expect(AppColors.green, const Color(0xff4CAF50));
    expect(AppColors.white, const Color(0xffffffff));
    expect(AppColors.black, const Color(0xff000000));
    expect(AppColors.gray70, const Color(0xff707070));
    expect(AppColors.red, const Color(0xffEA2027));
    expect(AppColors.orange, const Color(0xffFF9800));
    expect(AppColors.confirmPendingBg, const Color(0xffFFF3E0));
    expect(AppColors.rejectBg, const Color(0xffFFE4E2));
    expect(AppColors.lightRed, const Color(0xffF44336));
    expect(AppColors.gray30, const Color(0xffDCDCDC));
    expect(AppColors.gray40, const Color(0xffBFBFBF));
  });

  testWidgets('theme helpers identify light and dark themes', (
    final WidgetTester tester,
  ) async {
    late BuildContext lightContext;
    late BuildContext darkContext;

    await tester.pumpWidget(
      Theme(
        data: ThemeData.light(),
        child: Builder(
          builder: (final context) {
            lightContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(checkLightMode(lightContext), isTrue);
    expect(checkDarkMode(lightContext), isFalse);

    await tester.pumpWidget(
      Theme(
        data: ThemeData.dark(),
        child: Builder(
          builder: (final context) {
            darkContext = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(checkDarkMode(darkContext), isTrue);
    expect(checkLightMode(darkContext), isFalse);
  });

  testWidgets('app theme applies configured colors for light and dark modes', (
    final WidgetTester tester,
  ) async {
    late BuildContext context;

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Builder(
            builder: (final builderContext) {
              context = builderContext;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );

    final theme = AppTheme(
      context,
      AppColors.primaryColor,
      AppColors.lightPrimaryColor,
    );
    final expectedLightScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      surface: AppColors.ivory,
    );
    final expectedDarkScheme = ColorScheme.fromSeed(
      seedColor: AppColors.lightPrimaryColor,
      brightness: Brightness.dark,
      surface: const Color(0xff11181A),
    );

    expect(theme.lightTheme.colorScheme.primary, expectedLightScheme.primary);
    expect(theme.darkTheme.colorScheme.primary, expectedDarkScheme.primary);
    expect(theme.lightTheme.scaffoldBackgroundColor, AppColors.ivory);
    expect(theme.darkTheme.scaffoldBackgroundColor, AppColors.ink);
    expect(theme.lightTheme.filledButtonTheme.style, isNotNull);
    expect(theme.darkTheme.navigationBarTheme.iconTheme, isNotNull);
  });

  testWidgets('locale handler reads, writes, and titles locales', (
    final WidgetTester tester,
  ) async {
    late BuildContext context;

    await tester.pumpWidget(
      TranslationProvider(
        child: Builder(
          builder: (final builderContext) {
            context = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(await LocaleHandler().getLocale(), AppLocale.en);
    expect(LocaleHandler().getLocaleTitle(context), 'English');

    await locator<SetLanguageLocaleUseCase>()('fr');

    expect(await LocaleHandler().getLocale(), AppLocale.fr);

    await locator<SetLanguageLocaleUseCase>()('unknown');

    expect(await LocaleHandler().getLocale(), AppLocale.en);

    await LocaleHandler().setEnLocale(context);
    await tester.pump();

    expect(await LocaleHandler().getLocale(), AppLocale.en);
    expect(checkEnState(context), isTrue);

    expect(LocaleHandler().getLocaleTitle(context), 'English');
  });

  testWidgets('checkEnState reads English provider state', (
    final WidgetTester tester,
  ) async {
    late BuildContext englishContext;

    LocaleSettings.setLocaleSync(AppLocale.en);
    await tester.pumpWidget(
      TranslationProvider(
        child: Builder(
          builder: (final builderContext) {
            englishContext = builderContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(checkEnState(englishContext), isTrue);
  });

  testWidgets('checkEnState safely handles missing translation provider', (
    final WidgetTester tester,
  ) async {
    late BuildContext context;

    await tester.pumpWidget(
      Builder(
        builder: (final builderContext) {
          context = builderContext;
          return const SizedBox.shrink();
        },
      ),
    );

    expect(checkEnState(context), isFalse);

    await changeLocale(context);

    expect(await LocaleHandler().getLocale(), AppLocale.en);
  });
}
