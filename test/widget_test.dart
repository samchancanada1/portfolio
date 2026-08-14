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
    await LocaleSettings.setLocale(AppLocale.en);
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

  testWidgets('splash screen animates then opens home', (
    final WidgetTester tester,
  ) async {
    routes.go('/');

    await tester.pumpWidget(buildTestApp());

    expect(find.byType(Image), findsWidgets);
    expect(find.text('Hiu Tung Chan'), findsNothing);

    await tester.pump(const Duration(milliseconds: 2100));
    await tester.pumpAndSettle();

    expect(find.text('Hiu Tung Chan'), findsWidgets);
  });

  testWidgets('portfolio app renders updated resume content', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pumpAndSettle();

    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(
      find.textContaining('cross-platform iOS and Android apps'),
      findsOneWidget,
    );
    expect(find.text('Core stack'), findsOneWidget);
    expect(find.text('Clean Architecture'), findsWidgets);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.textContaining('6+ years'), findsWidgets);
    expect(find.text('Markham, ON, CA'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    expect(find.text('BoursePad'), findsOneWidget);
    expect(find.text('CORE COMPETENCIES'), findsOneWidget);
    expect(find.text('Core competencies from the resume'), findsOneWidget);
    expect(find.text('KeelWorks Foundation'), findsOneWidget);
    expect(find.text('Computer And Technologies Holdings'), findsOneWidget);
  });

  testWidgets('mobile layout can navigate about and resume', (
    final WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.textContaining('6+ years'), findsWidgets);

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(find.text('Currently shipping'), findsOneWidget);
  });

  testWidgets('skills page presents resume-aligned technical categories', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skills'));
    await tester.pumpAndSettle();

    expect(
        find.text('Technical skills from the updated resume'), findsOneWidget);
    expect(find.text('Mobile'), findsOneWidget);
    expect(find.text('Architecture'), findsWidgets);
    expect(find.text('Backend and APIs'), findsOneWidget);
    expect(find.text('CI/CD and release'), findsOneWidget);
    expect(find.text('Mobile features'), findsOneWidget);
    expect(find.text('Detailed toolbox'), findsOneWidget);
    expect(find.text('Firebase Auth'), findsWidgets);
  });

  testWidgets('settings page can change theme and primary color', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    expect(find.text('Theme Mode'), findsOneWidget);
    expect(tester.widget<Switch>(find.byType(Switch)).value, isTrue);

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

    await tester.tap(find.byTooltip('Select color').last);
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();

    expect(find.text('French'), findsWidgets);
    expect(find.text('English'), findsWidgets);

    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();

    expect(await LocaleHandler().getLocale(), AppLocale.en);
  });

  testWidgets('unknown route renders the not found screen', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    routes.go('/missing');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Page Not Found'), findsOneWidget);
  });
}
