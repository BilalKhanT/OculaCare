import 'package:OculaCare/data/models/disease_result/disease_result_model.dart';
import 'package:OculaCare/data/models/tests/score_model.dart';
import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:OculaCare/logic/therapy_cubit/music_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/timer_cubit.dart';
import 'package:OculaCare/presentation/disease_detection/disease_detection_view.dart';
import 'package:OculaCare/presentation/feedback/feedback_view.dart';
import 'package:OculaCare/presentation/location/location_view.dart';
import 'package:OculaCare/presentation/more_section/more_view.dart';
import 'package:OculaCare/presentation/more_section/pdf_view.dart';
import 'package:OculaCare/presentation/patient_profile/profile_view.dart';
import 'package:OculaCare/presentation/result/disease_analysis_view.dart';
import 'package:OculaCare/presentation/result/result_view.dart';
import 'package:OculaCare/presentation/test_dashboard/test_dash_view.dart';
import 'package:OculaCare/presentation/therapy/scheduled_therapy.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/test_report.dart';
import 'package:OculaCare/presentation/therapy/sections/therapy_feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/presentation/home/home_view.dart';
import 'package:OculaCare/presentation/img_capture/img_capture_view.dart';
import 'package:OculaCare/presentation/onboarding/onboarding_view.dart';
import 'package:OculaCare/presentation/sign_up/sign_up_view.dart';
import '../../data/models/therapy/therapy_feedback_model.dart';
import '../../data/models/therapy/therapy_results_model.dart';
import '../../logic/tests/vision_tests/animal_track_cubit.dart';
import '../../logic/tests/test_cubit.dart';
import '../../logic/tests/test_dash_tab_cubit.dart';
import '../../presentation/login/login_view.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../presentation/otp/otp_view.dart';
import '../../presentation/test_dashboard/vision_tests/animal_game_initial.dart';
import '../../presentation/test_dashboard/vision_tests/animal_game_screen.dart';
import '../../presentation/test_dashboard/color_perception_tests/ishihara_test_view.dart';
import '../../presentation/test_dashboard/color_perception_tests/match_color_game.dart';
import '../../presentation/test_dashboard/color_perception_tests/odd_odd_screen.dart';
import '../../presentation/test_dashboard/scheduled_tests.dart';
import '../../presentation/test_dashboard/vision_tests/contrast_game_screen.dart';
import '../../presentation/test_dashboard/vision_tests/game_over_screen.dart';
import '../../presentation/test_dashboard/vision_tests/snellan_initial.dart';
import '../../presentation/test_dashboard/vision_tests/snellar_chart.dart';
import '../../presentation/test_dashboard/widgets/camera.dart';
import '../../presentation/therapy/dashboard_screen.dart';
import '../../presentation/therapy/disease_therapies_screen.dart';
import '../../presentation/therapy/therapy_screen.dart';
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
                  path: RouteNames.detectionRoute,
                  pageBuilder: (context, state) =>
                      const MaterialPage(child: DiseaseDetectionScreen()),
                ),
              ]),
          StatefulShellBranch(
              navigatorKey: _shellTestNavigatorKey,
              routes: <RouteBase>[
                GoRoute(
                    path: RouteNames.testRoute,
                    pageBuilder: (context, state) {
                      context.read<TestDashTabCubit>().toggleTab(0);
                      context.read<TestCubit>().loadTests();
                      return const MaterialPage(child: TestDashView());
                    }),
              ]),
          StatefulShellBranch(
            navigatorKey: _shellTherapyNavigatorKey,
            routes: <RouteBase>[
              GoRoute(
                path: RouteNames.dashboardRoute,
                pageBuilder: (context, state) =>
                    const MaterialPage(child: DashboardScreen()),
              ),
            ],
          ),
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
        builder: (context, state) {
          final flow = state.extra as String;
          return SignUpScreen(
            flow: flow,
          );
        }),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.onBoardingRoute,
      builder: (context, state) => const OnBoardingView(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.feedbackRoute,
      builder: (context, state) => const FeedbackView(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.pdfViewRoute,
      builder: (context, state) => PDFViewScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
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
      builder: (context, state) {
        final flow = state.extra as String;
        return OtpScreen(
          flow: flow,
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.profileRoute,
      builder: (context, state) => const PatientProfileScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.imgCaptureRoute,
      builder: (context, state) => const ImageCaptureScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.resultRoute,
      builder: (context, state) => const DiseaseResultView(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.scheduledRoute,
      builder: (context, state) => const ScheduledTests(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.therapyScheduledRoute,
      builder: (context, state) => const ScheduledTherapies(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.isiharaRoute,
      builder: (context, state) => const IshiharaScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.oddOutRoute,
      builder: (context, state) => const OutOddScreen(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.colorMatchRoute,
      builder: (context, state) => const MatchColorGameScreen(),
    ),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.distanceRoute,
        builder: (context, state) {
          int flag = state.extra as int;
          return CameraDistanceView(
            flag: flag,
          );
        }),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.diseaseAnalysisRoute,
        builder: (context, state) {
          DiseaseResultModel data = state.extra as DiseaseResultModel;
          return DiseaseAnalysisView(
            result: data,
          );
        }),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.trackInitialRoute,
      builder: (context, state) => const AnimalGameInitial(),
    ),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.trackRoute,
        builder: (context, state) {
          final cubit = AnimalTrackCubit();
          cubit.startGame();
          return AnimalGameScreen(cubit: cubit);
        }),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.contrastRoute,
        builder: (context, state) {
          bool flag = state.extra as bool;
          return ContrastGameScreen(
            isHome: flag,
          );
        }),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.trackGameOverRoute,
        builder: (context, state) {
          ScoreModel score = state.extra as ScoreModel;
          return GameOverScreen(
            score1: score.score1,
            score2: score.score2,
            score3: score.score3,
          );
        }),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.snellanInitialRoute,
        builder: (context, state) {
          String data = state.extra as String;
          return SnellanInitialView(eye: data);
        }),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.snellanRoute,
      builder: (context, state) => const SnellanChart(),
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.therapy,
      builder: (context, state) {
        final exercise = state.extra as Map<String, dynamic>;
        return MultiBlocProvider(
          providers: [
            BlocProvider<TimerCubit>(
              create: (context) =>
                  TimerCubit()..startTimer(exercise['timeLimit'] * 60),
            ),
            BlocProvider<MusicCubit>(
              create: (context) => MusicCubit(),
            ),
            BlocProvider<TherapyCubit>(
              create: (context) => TherapyCubit(
                BlocProvider.of<TimerCubit>(context),
                BlocProvider.of<MusicCubit>(context),
              )..startTherapy(
                  exercise['title'],
                  exercise['timeLimit'],
                  exercise['instructions'],
                  exercise['sound'],
                  exercise['category'],
                ),
            ),
          ],
          child: TherapyScreen(exercise: exercise),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.diseaseTherapies,
      builder: (context, state) {
        final disease = state.extra as String;
        return DiseaseTherapiesScreen(disease: disease);
      },
    ),
    GoRoute(
        parentNavigatorKey: navigatorKey,
        path: RouteNames.testReportRoute,
        builder: (context, state) {
          TestResultModel test = state.extra as TestResultModel;
          return TestReport(test: test);
        }),
    GoRoute(
      parentNavigatorKey: navigatorKey,
      path: RouteNames.therapyFeedbackRoute,
      builder: (context, state){
        TherapyModel therapy = state.extra as TherapyModel;
        return  TherapyFeedbackView( therapy : therapy );
      }),
  ],
  initialLocation: sharedPrefs.isLoggedIn
      ? RouteNames.homeRoute
      : RouteNames.onBoardingRoute,
);
