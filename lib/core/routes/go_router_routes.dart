import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home_feature/presentation/cubit/home_navigation_cubit.dart';
import '../../feature/home_feature/presentation/screens/home_screen.dart';
import '../../feature/home_feature/presentation/screens/not_found_screen.dart';
import 'go_routes_path.dart';

final GoRouter routes = GoRouter(
  initialLocation: GoRoutesPath.root,
  errorBuilder: (final BuildContext context, final GoRouterState state) {
    return _selectablePage(const NotFoundScreen());
  },
  routes: <RouteBase>[
    GoRoute(
      path: GoRoutesPath.root,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.home),
        );
      },
    ),
    GoRoute(
      path: GoRoutesPath.home,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.home),
        );
      },
    ),
    GoRoute(
      path: GoRoutesPath.about,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.about),
        );
      },
    ),
    GoRoute(
      path: GoRoutesPath.resume,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.resume),
        );
      },
    ),
    GoRoute(
      path: GoRoutesPath.skills,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.skills),
        );
      },
    ),
    GoRoute(
      path: GoRoutesPath.settings,
      builder: (final BuildContext context, final GoRouterState state) {
        return _selectablePage(
          const HomeScreen(initialSection: HomeSection.settings),
        );
      },
    ),
  ],
);

Widget _selectablePage(final Widget child) {
  return SelectionArea(child: child);
}
