import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> navigateTo(WidgetTester tester, String label) async {
    final menuButton = find.byKey(const ValueKey('website-menu-button'));
    if (menuButton.evaluate().isNotEmpty &&
        find.byKey(const ValueKey('website-menu')).evaluate().isEmpty) {
      await tester.tap(menuButton);
      await pumpPortfolio(tester);
    }
    final desktopSettings = find.byKey(const ValueKey('website-settings'));
    final target = label == 'Settings' && desktopSettings.evaluate().isNotEmpty
        ? desktopSettings
        : find.descendant(
            of: find.byKey(const ValueKey('website-header')),
            matching: find.text(label));
    await tester.ensureVisible(target);
    await tester.tap(target);
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

    expect(find.byType(SelectionArea), findsOneWidget);
    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(
      find.text('Senior Flutter products, shipped.'),
      findsOneWidget,
    );
    expect(find.textContaining('Flutter'), findsWidgets);
    expect(find.text('View case studies'), findsOneWidget);

    await navigateTo(tester, 'About');
    await pumpPortfolio(tester);

    expect(find.textContaining('6+ years'), findsWidgets);
    expect(find.text('Markham, ON, CA'), findsOneWidget);

    await navigateTo(tester, 'Resume');
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

    await navigateTo(tester, 'About');
    await pumpPortfolio(tester);

    expect(routes.routeInformationProvider.value.uri.path, '/about');

    await navigateTo(tester, 'Resume');
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

    await navigateTo(tester, 'About');
    await pumpPortfolio(tester);

    expect(find.textContaining('6+ years'), findsWidgets);

    await navigateTo(tester, 'Resume');
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

    await navigateTo(tester, 'Skills');
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

    await navigateTo(tester, 'Settings');
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

    await navigateTo(tester, 'Settings');
    await pumpPortfolio(tester);

    await tester.tap(find.text('Language'));
    await pumpPortfolio(tester);

    expect(find.text('French'), findsWidgets);
    expect(find.text('English'), findsWidgets);

    await tester.tap(find.text('English').last);
    await pumpPortfolio(tester);

    expect(await LocaleHandler().getLocale(), AppLocale.en);
  });

  testWidgets(
      'desktop navigation uses a top header and leaves equal page margins',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byKey(const ValueKey('website-menu-button')), findsNothing);
    final header = tester.getRect(find.byKey(const ValueKey('website-header')));
    expect(header.top, 0);
    expect(header.width, 1440);
    final page = tester.getRect(find.byType(CustomScrollView).first);
    expect(page.top, greaterThanOrEqualTo(header.bottom));
    await navigateTo(tester, 'About');
    await pumpPortfolio(tester);
    expect(routes.routeInformationProvider.value.uri.path, '/about');
    await tester.tap(find.byKey(const ValueKey('website-brand')));
    await pumpPortfolio(tester);
    expect(routes.routeInformationProvider.value.uri.path, '/home');
    expect(tester.takeException(), isNull);
  });

  testWidgets('contact link scrolls Home and works again from other sections',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);

    Future<void> openContact() async {
      await tester.tap(find.byKey(const ValueKey('website-contact')));
      await pumpPortfolio(tester);
      await pumpPortfolio(tester);
      await pumpPortfolio(tester);
      expect(routes.routeInformationProvider.value.uri.toString(),
          '/home#contact');
      final contact = tester.getRect(find.text('CONTACT'));
      final header =
          tester.getRect(find.byKey(const ValueKey('website-header')));
      expect(contact.top, greaterThanOrEqualTo(header.bottom));
      expect(contact.bottom, lessThan(900));
      expect(find.text('CONTACT').hitTestable(), findsOneWidget);
    }

    await openContact();

    // The same URL must still scroll after the visitor manually returns upward.
    final scrollable = tester.state<ScrollableState>(find
        .descendant(
            of: find.byType(CustomScrollView).first,
            matching: find.byType(Scrollable))
        .first);
    scrollable.position.jumpTo(0);
    await pumpPortfolio(tester);
    await openContact();

    for (final section in ['About', 'Resume', 'Skills', 'Settings']) {
      await navigateTo(tester, section);
      await pumpPortfolio(tester);
      await openContact();
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile contact deep link and menu link reveal CONTACT',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    routes.go('/home#contact');
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);
    await pumpPortfolio(tester);
    await pumpPortfolio(tester);
    expect(find.text('CONTACT').hitTestable(), findsOneWidget);

    await navigateTo(tester, 'About');
    await pumpPortfolio(tester);
    await tester.tap(find.byKey(const ValueKey('website-menu-button')));
    await pumpPortfolio(tester);
    final contactButton = find.byKey(const ValueKey('website-contact'));
    await tester.ensureVisible(contactButton);
    await tester.tap(contactButton);
    await pumpPortfolio(tester);
    await pumpPortfolio(tester);
    await pumpPortfolio(tester);
    expect(
        routes.routeInformationProvider.value.uri.toString(), '/home#contact');
    expect(find.byKey(const ValueKey('website-menu')), findsNothing);
    expect(find.text('CONTACT').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile menu closes after navigation and Escape returns focus',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);
    expect(find.byType(NavigationBar), findsNothing);
    await navigateTo(tester, 'Skills');
    await pumpPortfolio(tester);
    expect(find.byKey(const ValueKey('website-menu')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('website-menu-button')));
    await pumpPortfolio(tester);
    expect(find.byKey(const ValueKey('website-menu')), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await pumpPortfolio(tester);
    expect(find.byKey(const ValueKey('website-menu')), findsNothing);
    final button = tester
        .widget<IconButton>(find.byKey(const ValueKey('website-menu-button')));
    expect(button.focusNode!.hasFocus, isTrue);
  });

  testWidgets('French header fits a short desktop viewport', (tester) async {
    tester.view.physicalSize = const Size(1100, 650);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    routes.go('/skills');
    await tester.pumpWidget(buildTestApp());
    await pumpPortfolio(tester);
    try {
      await tester.runAsync(() => LocaleSettings.setLocale(AppLocale.fr));
      await pumpPortfolio(tester);
      expect(find.byKey(const ValueKey('website-header')), findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      await tester.runAsync(() => LocaleSettings.setLocale(AppLocale.en));
      await pumpPortfolio(tester);
    }
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
