import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/core/theme/colors.dart';
import 'package:portfolio/i18n/strings.g.dart';
import 'package:portfolio/main.dart';

void main() {
  Widget buildTestApp() {
    return TranslationProvider(
      child: MyApp(
        primaryColor: AppColors.primaryColor,
        lightPrimaryColor: AppColors.lightPrimaryColor,
        debugShowMaterialGrid: false,
        showPerformanceOverlay: false,
      ),
    );
  }

  testWidgets('portfolio app renders updated resume content', (
    final WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildTestApp());

    await tester.pumpAndSettle();

    expect(find.text('Hiu Tung Chan'), findsWidgets);
    expect(find.textContaining('production Flutter apps'), findsOneWidget);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.textContaining('6+ years'), findsWidgets);
    expect(find.text('Markham, ON, CA'), findsOneWidget);

    await tester.tap(find.text('Resume'));
    await tester.pumpAndSettle();

    expect(find.text('BoursePad'), findsOneWidget);
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

    expect(find.text('BoursePad'), findsOneWidget);
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
    expect(find.text('Production mobile apps'), findsOneWidget);
  });
}
