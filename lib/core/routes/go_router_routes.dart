import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/home_feature/presentation/screens/home_screen.dart';
import '../../feature/home_feature/presentation/screens/not_found_screen.dart';
import 'go_routes_path.dart';

final GoRouter routes = GoRouter(
  initialLocation: GoRoutesPath.home,
  errorBuilder: (final BuildContext context, final GoRouterState state) {
    return const NotFoundScreen();
  },
  routes: <RouteBase>[
    GoRoute(
      path: GoRoutesPath.home,
      builder: (final BuildContext context, final GoRouterState state) {
        return const HomeScreen();
      },
    ),
    // GoRoute(
    //   path: GoRoutesPath.login,
    //   builder: (final BuildContext context, final GoRouterState state) {
    //     return const Login();
    //   },
    // ),
    // GoRoute(
    //   path: GoRoutesPath.verifyOtp,
    //   builder: (final BuildContext context, final GoRouterState state) {
    //     return VerifyOtp(
    //       mobileNumber: state.extra as String,
    //     );
    //   },
    // ),
    // GoRoute(
    //   path: GoRoutesPath.editProfile,
    //   builder: (final BuildContext context, final GoRouterState state) {
    //     return const EditProfile();
    //   },
    // ),
  ],
);
