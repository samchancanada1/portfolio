import 'package:flutter/material.dart';
import '../utils/locale_handler.dart';
import '../theme/colors.dart';

class AppTheme {
  AppTheme(
    this.context,
    final Color primaryColor,
    final Color lightPrimaryColor,
  ) {
    final String fontFamily =
        checkEnState(context) ? 'IranYekanX' : 'IranYekanXFaNum';
    final TextTheme baseTextTheme = TextTheme(
      displayLarge: const TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
      displaySmall: const TextStyle(
        fontSize: 42,
        fontWeight: FontWeight.w900,
        letterSpacing: 0,
      ),
      headlineSmall: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      ),
      bodySmall: const TextStyle(height: 1.55, letterSpacing: 0),
      bodyMedium: const TextStyle(height: 1.55, letterSpacing: 0),
      bodyLarge: const TextStyle(height: 1.55, letterSpacing: 0),
      labelLarge: const TextStyle(letterSpacing: 0),
    ).apply(fontFamily: fontFamily);

    lightTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ivory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: AppColors.ivory,
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: const Color(0xff172022),
        displayColor: const Color(0xff172022),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((
          final Set<WidgetState> states,
        ) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((
          final Set<WidgetState> state,
        ) {
          if (state.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor);
          }
          return const IconThemeData(color: Color(0xff637073));
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: primaryColor),
      ),
      fontFamily: fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ivory,
        elevation: 0,
        toolbarTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
    );

    darkTheme = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.ink,
      colorScheme: ColorScheme.fromSeed(
        seedColor: lightPrimaryColor,
        brightness: Brightness.dark,
        surface: const Color(0xff11181A),
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: const Color(0xffEFF7F5),
        displayColor: const Color(0xffEFF7F5),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide.none,
      ),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(color: lightPrimaryColor),
      ),
      navigationBarTheme: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith((
          final Set<WidgetState> states,
        ) {
          return TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w600,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((
          final Set<WidgetState> state,
        ) {
          if (state.contains(WidgetState.selected)) {
            return IconThemeData(color: lightPrimaryColor);
          }
          return const IconThemeData(color: Color(0xffB7C6C3));
        }),
      ),
      fontFamily: fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.ink,
        elevation: 0,
        toolbarTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
    );
  }

  BuildContext context;
  late ThemeData lightTheme;
  late ThemeData darkTheme;
}
