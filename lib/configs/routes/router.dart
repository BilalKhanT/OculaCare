import 'package:OculaCare/presentation/location/location_view.dart';
import 'package:OculaCare/presentation/more_section/more_view.dart';
import 'package:OculaCare/presentation/more_section/pdf_view.dart';
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
import '../../presentation/widgets/scaffold_nav_bar.dart';
import 'package:nb_utils/nb_utils.dart';

final _shellHomeNavigatorKey = GlobalKey<NavigatorState>();
final _shellDetectNavigatorKey = GlobalKey<NavigatorState>();
final _shellTestNavigatorKey = GlobalKey<NavigatorState>();
final _shellTherapyNavigatorKey = GlobalKey<NavigatorState>();
final _shellMoreNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
              navigatorKey: _shellHomeNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RouteNames.homeRoute,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: HomeScreen()),
                ),
              ]),
          StatefulShellBranch(
              navigatorKey: _shellDetectNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RouteNames.imgCaptureRoute,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: ImageCaptureScreen()),
                ),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellTestNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RouteNames.resultRoute,
                  pageBuilder: (context, state) =>
                  const MaterialPage(child: ResultView()),
                ),
              ]),
          StatefulShellBranch(
              navigatorKey: _shellTherapyNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RouteNames.resultRoute,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: ResultView()),
                ),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellMoreNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                  path: RouteNames.moreRoute,
                  pageBuilder: (context, state) =>
                  const MaterialPage(child: MoreView()),
                ),
              ]),
        ]),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.signUpRoute,
      builder: (context, state) => const SignUpScreen(),
    ),
    // GoRoute(
    //   path: RouteNames.resultRoute,
    //   builder: (context, state) => const ResultView(),
    // ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.onBoardingRoute,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.pdfViewRoute,
      builder: (context, state) => PDFViewScreen(),
    ),
    GoRoute(
      // parentNavigatorKey: navigatorKey,
      path: RouteNames.loginRoute,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.locationRoute,
      builder: (context, state) => const LocationScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.otpRoute,
      builder: (context, state) => const OtpScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.profileRoute,
      builder: (context, state) => const PatientProfileScreen(),
    ),
    GoRoute(
      path: RouteNames.imgCaptureRoute,
      builder: (context, state) => const ImageCaptureScreen(),
    ),
    // GoRoute(
    //   path: RouteNames.homeRoute,
    //   builder: (context, state) => const HomeScreen(),
    // ),
    // GoRoute(
    //   path: RouteNames.imgCaptureRoute,
    //   builder: (context, state) => const ImageCaptureScreen(),
    // ),
  ],
  initialLocation: sharedPrefs.isLoggedIn
      ? RouteNames.homeRoute
      : RouteNames.onBoardingRoute,
);
