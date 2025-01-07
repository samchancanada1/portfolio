import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'core/routes/go_router_routes.dart';
import 'core/theme/theme.dart';
import 'feature/home_feature/presentation/bloc/counter_cubit.dart';
import 'feature/home_feature/presentation/bloc/show_material_grids_cubit.dart';
import 'feature/home_feature/presentation/bloc/show_performance_overlay_cubit.dart';
import 'feature/home_feature/presentation/bloc/theme_cubit.dart';
import 'i18n/strings.g.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
import 'feature/home_feature/presentation/bloc/primary_color_cubit.dart';

void main() async {
  /// Must include when main use async
  WidgetsFlutterBinding.ensureInitialized();

  /// Setup all get_it locators
  /// TODO:
  // setupAuthenticationLocators();

  /// Allow the imperative API affects browser URL bar.
  GoRouter.optionURLReflectsImperativeAPIs = true;

  /// Remove # from end of URL
  setUrlStrategy(PathUrlStrategy());

  /// Remove the native splash screen
  // FlutterNativeSplash.remove();

  /// Get locale from device storage and set it
  // LocaleSettings.setLocale(await LocaleHandler().getLocale());

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (final BuildContext context) => CounterCubit()),
      BlocProvider(
        create: (final BuildContext context) => ShowPerformanceOverlayCubit(),
      ),
      BlocProvider(
        create: (final BuildContext context) => ShowMaterialGridsCubit(),
      ),
      BlocProvider(create: (final BuildContext context) => ThemeCubit()),
      BlocProvider(
        create: (final BuildContext context) => PrimaryColorCubit(),
      ),
      // BlocProvider(
      //   create: (final BuildContext context) => BottomNavigationCubit(),
      // ),
      // BlocProvider(
      //   create: (final BuildContext context) => locator<ProfileBloc>(),
    ],
    child: TranslationProvider(
      child: BlocBuilder<ShowPerformanceOverlayCubit, bool>(
        builder: (final context, final showPerformanceOverlayState) {
          return BlocBuilder<ShowMaterialGridsCubit, bool>(
            builder: (final context, final debugShowMaterialGrid) {
              return BlocBuilder<ThemeCubit, ThemeMode?>(
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
                        showPerformanceOverlay: showPerformanceOverlayState,
                        debugShowMaterialGrid: debugShowMaterialGrid,
                        themeMode: themeState,
                        primaryColor: state.primaryColor,
                        lightPrimaryColor: state.lightPrimaryColor,
                      );
                    },
                  );
                },
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
    required this.debugShowMaterialGrid,
    required this.showPerformanceOverlay,
  });

  final ThemeMode? themeMode;
  final Color primaryColor;
  final Color lightPrimaryColor;
  final bool showPerformanceOverlay;
  final bool debugShowMaterialGrid;

  @override
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerConfig: routes,
      title: 'portfolio',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
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
