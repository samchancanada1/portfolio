import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/di/service_locator.dart';
import 'package:portfolio/core/theme/colors.dart';
import 'package:portfolio/i18n/strings.g.dart';
import 'package:portfolio/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await setupServiceLocator();
  });

  Widget buildTestApp() {
    return TranslationProvider(
      child: MyApp(
        primaryColor: AppColors.primaryColor,
        lightPrimaryColor: AppColors.lightPrimaryColor,
      ),
    );
  }

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
}
