import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/service_locator.dart';
import 'package:portfolio/core/routes/go_router_routes.dart';
import 'package:portfolio/core/theme/colors.dart';
import 'package:portfolio/core/utils/locale_handler.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/primary_color_cubit.dart';
import 'package:portfolio/feature/home_feature/presentation/cubit/theme_cubit.dart';
import 'package:portfolio/i18n/strings.g.dart';
import 'package:portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await locator.reset();
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
    LocaleSettings.setLocaleSync(AppLocale.en);
    routes.go('/home');
  });

  Widget buildTestApp() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (final BuildContext context) => locator<ThemeCubit>(),
        ),
        BlocProvider(
          create: (final BuildContext context) => PrimaryColorCubit(),
        ),
      ],
      child: TranslationProvider(
        child: BlocBuilder<ThemeCubit, ThemeMode?>(
          builder: (
            final BuildContext context,
            final ThemeMode? themeState,
          ) {
            return BlocBuilder<PrimaryColorCubit, PrimaryColorState>(
              builder: (
                final BuildContext context,
                final PrimaryColorState state,
              ) {
                return MyApp(
                  themeMode: themeState,
                  primaryColor: state.primaryColor,
                  lightPrimaryColor: state.lightPrimaryColor,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> pumpPortfolio(final WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
  }

  testWidgets('root route opens home without splash', (
    final WidgetTester tester,
  ) async {
    routes.go('/');

    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    expect(find.text('Hiu Tung Chan'), findsWidgets);
  });

  testWidgets('portfolio app renders updated resume content', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await pumpPortfolio(tester);

    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(
      find.text('Senior Flutter products, shipped.'),
      findsOneWidget,
    );
    expect(find.textContaining('Flutter'), findsWidgets);
    expect(find.text('View case studies'), findsOneWidget);

    await tester.tap(find.text('About'));
    await pumpPortfolio(tester);

    expect(find.textContaining('6+ years'), findsWidgets);
    expect(find.text('Markham, ON, CA'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await pumpPortfolio(tester);

    expect(find.text('BoursePad'), findsOneWidget);
    expect(find.text('CORE COMPETENCIES'), findsOneWidget);
    expect(find.text('What I bring to a product team'), findsOneWidget);
    expect(find.text('KeelWorks Foundation'), findsOneWidget);
    expect(
      find.text('Computer And Technologies Holdings Limited'),
      findsOneWidget,
    );
  });

  testWidgets('section tags update the browser route', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    await tester.tap(find.text('About'));
    await pumpPortfolio(tester);

    expect(routes.routeInformationProvider.value.uri.path, '/about');

    await tester.tap(find.text('Resume'));
    await pumpPortfolio(tester);

    expect(routes.routeInformationProvider.value.uri.path, '/resume');
  });

  testWidgets('direct section routes open the matching tab', (
    final WidgetTester tester,
  ) async {
    routes.go('/skills');

    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    expect(
      find.text('Production-ready mobile skills'),
      findsOneWidget,
    );
  });

  testWidgets('mobile layout can navigate about and resume', (
    final WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    await tester.tap(find.text('About'));
    await pumpPortfolio(tester);

    expect(find.textContaining('6+ years'), findsWidgets);

    await tester.tap(find.text('Resume'));
    await pumpPortfolio(tester);

    expect(find.text('BoursePad'), findsWidgets);
    expect(find.text('KeelWorks Foundation'), findsOneWidget);
  });

  testWidgets('home layout does not overflow in tall desktop viewport', (
    final WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1180, 1054);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(find.text('Production Flutter projects'), findsOneWidget);
  });

  testWidgets('skills page presents resume-aligned technical categories', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    await tester.tap(find.text('Skills'));
    await pumpPortfolio(tester);

    expect(
      find.text('Production-ready mobile skills'),
      findsOneWidget,
    );
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Architecture'), findsWidgets);
    expect(find.text('Backend and cloud'), findsOneWidget);
    expect(find.text('APIs and data'), findsOneWidget);
    expect(find.text('CI/CD and release'), findsOneWidget);
    expect(find.text('Platform capabilities'), findsOneWidget);
    expect(find.text('Technical toolbox'), findsOneWidget);
    expect(find.text('Firebase Auth'), findsWidgets);
  });

  testWidgets('settings page can change theme and primary color', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    await tester.tap(find.text('Settings').first);
    await pumpPortfolio(tester);

    expect(find.text('Theme Mode'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    await tester.tap(find.byType(Switch));
    await pumpPortfolio(tester);

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.tap(find.byTooltip('Select color').last);
    await pumpPortfolio(tester);

    final context = tester.element(find.text('Theme Color'));
    expect(
      Theme.of(context).colorScheme.primary,
      ColorScheme.fromSeed(
        seedColor: Colors.red,
        brightness: Brightness.light,
        surface: AppColors.ivory,
      ).primary,
    );
  });

  testWidgets('settings page can open language sheet and keep English', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    await tester.tap(find.text('Settings').first);
    await pumpPortfolio(tester);

    await tester.tap(find.text('Language'));
    await pumpPortfolio(tester);

    expect(find.text('French'), findsWidgets);
    expect(find.text('English'), findsWidgets);

    await tester.tap(find.text('English').last);
    await pumpPortfolio(tester);

    expect(await LocaleHandler().getLocale(), AppLocale.en);
  });

  testWidgets('unknown route renders the not found screen', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    routes.go('/missing');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Page Not Found'), findsOneWidget);
  });
}
