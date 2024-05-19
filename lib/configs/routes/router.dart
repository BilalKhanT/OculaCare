import 'package:OculaCare/presentation/patient_profile/profile_view.dart';
import 'package:OculaCare/presentation/result/result_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/presentation/home/home_view.dart';
import 'package:OculaCare/presentation/img_capture/img_capture_view.dart';
import 'package:OculaCare/presentation/onboarding/onboarding_view.dart';
import 'package:OculaCare/presentation/sign_up/sign_up_view.dart';

import '../../presentation/login/login_view.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../presentation/otp/otp_view.dart';


final navigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: RouteNames.signUpRoute,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: RouteNames.resultRoute,
      builder: (context, state) => const ResultView(),
    ),
    GoRoute(
      path: RouteNames.onBoardingRoute,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: RouteNames.loginRoute,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.otpRoute,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      path: RouteNames.homeRoute,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RouteNames.profileRoute,
      builder: (context, state) => const PatientProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.imgCaptureRoute,
      builder: (context, state) => const ImageCaptureScreen(),
    ),
  ],
  initialLocation: sharedPrefs.isLoggedIn ? RouteNames.homeRoute : RouteNames.onBoardingRoute,
);
