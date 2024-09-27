
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'logic/auth_cubit/auth_cubit.dart';
import 'logic/camera/camera_cubit.dart';
import 'logic/detection/detection_cubit.dart';
import 'logic/feedback_cubit/feedback_cubit.dart';
import 'logic/image_capture/img_capture_cubit.dart';
import 'logic/image_capture/toggle_capture_btn_cubit.dart';
import 'logic/keyboard_listener_cubit/keyboard_list_cubit.dart';
import 'logic/location_cubit/location_cubit.dart';
import 'logic/login_cubit/login_cubit.dart';
import 'logic/login_cubit/login_pass_cubit.dart';
import 'logic/onboarding/onboarding_cubit.dart';
import 'logic/otp_cubit/otp_cubit.dart';
import 'logic/patient_profile/gender_cubit.dart';
import 'logic/patient_profile/pass_cubit.dart';
import 'logic/patient_profile/patient_profile_cubit.dart';
import 'logic/patient_profile/upload_profile_photo_cubit.dart';
import 'logic/pdf_cubit/pdf_cubit_state.dart';
import 'logic/sign_up_cubit/sign_up_cubit.dart';
import 'logic/sign_up_cubit/sign_up_pass_cubit.dart';
import 'logic/tests/color_more_cubit.dart';
import 'logic/tests/color_tests/radio_btn_cubit.dart';
import 'logic/tests/test_progression_cubit.dart';
import 'logic/tests/vision_tests/animal_track_cubit.dart';
import 'logic/tests/color_tests/isihara_cubit.dart';
import 'logic/tests/color_tests/match_color_cubit.dart';
import 'logic/tests/color_tests/odd_out_cubit.dart';
import 'logic/tests/test_cubit.dart';
import 'logic/tests/test_dash_tab_cubit.dart';
import 'logic/tests/test_more_cubit.dart';
import 'logic/tests/test_schedule_cubit.dart';
import 'logic/tests/test_schedule_tab_cubit.dart';
import 'logic/tests/vision_tests/animal_track_score_cubit.dart';
import 'logic/tests/vision_tests/contrast_cubit.dart';
import 'logic/tests/vision_tests/snellan_initial_cubit.dart';
import 'logic/tests/vision_tests/snellan_test_cubit.dart';
import 'logic/tests/vision_tests/stt_cubit.dart';
import 'logic/therapy_cubit/music_cubit.dart';
import 'logic/therapy_cubit/therapy_cubit.dart';
import 'logic/therapy_cubit/therapy_dashboard_cubit.dart';
import 'logic/therapy_cubit/therapy_feedback_cubit.dart';
import 'logic/therapy_cubit/therapy_schedule_cubit.dart';
import 'logic/therapy_cubit/therapy_schedule_tab_cubit.dart';
import 'logic/therapy_cubit/timer_cubit.dart';

class ProvideMultiBloc extends StatelessWidget {
  final Widget child;

  const ProvideMultiBloc({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => SignUpCubit(),
      ),
      BlocProvider(
        create: (context) => GenderCubit(),
      ),
      BlocProvider(
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => SignUpPassCubit(),
      ),
      BlocProvider(
        create: (context) => LoginPassCubit(),
      ),
      BlocProvider(
        create: (context) => KeyboardListenerCubit(),
      ),
      BlocProvider(
        create: (context) =>
            FeedbackCubit(context.read<KeyboardListenerCubit>()),
      ),
      BlocProvider(
        create: (context) => AuthCubit(context.read<KeyboardListenerCubit>()),
      ),
      BlocProvider(
        create: (context) => UploadProfilePhotoCubit(),
      ),
      BlocProvider(
        create: (context) => LocationCubit(),
      ),
      BlocProvider(
        create: (context) => ImageCaptureCubit(),
      ),
      BlocProvider(
        create: (context) => ToggleCaptureButtonCubit(),
      ),
      BlocProvider(
        create: (context) => OtpCubit(),
      ),
      BlocProvider(
        create: (context) => PDFCubit(),
      ),
      BlocProvider(
        create: (context) => PatientProfileCubit(),
      ),
      BlocProvider(
        create: (context) => TestDashTabCubit(),
      ),
      BlocProvider(
        create: (context) => TestCubit(),
      ),
      BlocProvider(
        create: (context) => TestMoreCubit(),
      ),
      BlocProvider(
        create: (context) => ColorMoreCubit(),
      ),
      BlocProvider(
        create: (context) => ScheduleTabCubit(),
      ),
      BlocProvider(
        create: (context) => ScheduleCubit(),
      ),
      BlocProvider(
        create: (context) => IshiharaCubit(),
      ),
      BlocProvider(
        create: (context) => RadioBtnCubit(),
      ),
      BlocProvider(
        create: (context) => OddOutCubit(),
      ),
      BlocProvider(
        create: (context) => MatchColorCubit(),
      ),
      BlocProvider(
        create: (context) => CameraCubit(),
      ),
      BlocProvider(
        create: (context) => AnimalTrackCubit(),
      ),
      BlocProvider(
        create: (context) => SnellanTestCubit(),
      ),
      BlocProvider(
        create: (context) => SnellanInitialCubit(),
      ),
      BlocProvider(
        create: (context) => ContrastCubit(),
      ),
      BlocProvider(
        create: (context) => AnimalTrackScoreCubit(),
      ),
      BlocProvider(
        create: (context) => TestProgressionCubit(),
      ),
      BlocProvider(create: (context) => TimerCubit()),
      BlocProvider(create: (context) => MusicCubit()),
      BlocProvider(create: (context) => TherapyScheduleCubit()),
      BlocProvider(create: (context) => TherapyScheduleTabCubit()),
      BlocProvider(create: (context) => TherapyCubit(
          BlocProvider.of<TimerCubit>(context),
          BlocProvider.of<MusicCubit>(context))),
      BlocProvider(create: (context) => TherapyDashboardCubit()),
      BlocProvider(
        create: (context) => DetectionCubit(),
      ),
      BlocProvider(
        create: (context) => PassCubit(),
      ),
      BlocProvider(
        create: (context) => OnBoardingCubit(),
      ),
      BlocProvider(
        create: (context) => SttCubit(),
      ),
      BlocProvider(
        create: (context) =>
            TherapyFeedbackCubit(context.read<KeyboardListenerCubit>()),
      ),
    ], child: child);
  }
}
