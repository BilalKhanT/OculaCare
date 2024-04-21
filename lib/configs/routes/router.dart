import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ocula_care/configs/routes/route_names.dart';
import 'package:ocula_care/data/repositories/local/preferences/shared_prefs.dart';
import 'package:ocula_care/presentation/onboarding/onboarding_view.dart';
import 'package:ocula_care/presentation/sign_up/sign_up_view.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: RouteNames.signUpRoute,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: RouteNames.onBoardingRoute,
      builder: (context, state) => const OnBoardingScreen(),
    ),
  ],
  initialLocation: sharedPrefs.isLoggedIn ? RouteNames.signUpRoute : RouteNames.onBoardingRoute,
);
