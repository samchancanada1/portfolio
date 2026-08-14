import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/di/service_locator.dart';
import 'core/routes/go_router_routes.dart';
import 'core/theme/theme.dart';
import 'core/utils/locale_handler.dart';
import 'feature/home_feature/presentation/cubit/primary_color_cubit.dart';
import 'feature/home_feature/presentation/cubit/theme_cubit.dart';
import 'i18n/strings.g.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  /// Must include when main use async
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup all get_it locators
  await setupServiceLocator();

  /// Allow the imperative API affects browser URL bar.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  /// Remove # from end of URL
  setUrlStrategy(PathUrlStrategy());

  /// Get locale from device storage and set it
  await LocaleSettings.setLocale(await LocaleHandler().getLocale());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (final BuildContext context) => locator<ThemeCubit>()),
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
  ));
}

/// Global key used for show snackBar without context
final GlobalKey<ScaffoldMessengerState> globalScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.themeMode,
    required this.primaryColor,
    required this.lightPrimaryColor,
  });

  final ThemeMode? themeMode;
  final Color primaryColor;
  final Color lightPrimaryColor;

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerConfig: routes,
      title: 'portfolio',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: globalScaffoldMessengerKey,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: AppTheme(context, primaryColor, lightPrimaryColor).lightTheme,
      darkTheme: AppTheme(context, primaryColor, lightPrimaryColor).darkTheme,
      themeMode: themeMode,
    );
  }
}
