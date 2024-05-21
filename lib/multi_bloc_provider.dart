import 'package:OculaCare/logic/auth_cubit/auth_cubit.dart';
import 'package:OculaCare/logic/feedback_cubit/feedback_cubit.dart';
import 'package:OculaCare/logic/keyboard_listener_cubit/keyboard_list_cubit.dart';
import 'package:OculaCare/logic/location_cubit/location_cubit.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/patient_profile/upload_profile_photo_cubit.dart';
import 'package:OculaCare/logic/pdf_cubit/pdf_cubit_state.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_pass_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';
import 'package:OculaCare/logic/otp_cubit/otp_cubit.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_cubit.dart';

import 'logic/login_cubit/login_cubit.dart';

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
        create: (context) => LoginCubit(),
      ),
      BlocProvider(
        create: (context) => SignUpPassCubit(),
      ),
      BlocProvider(
        create: (context) => KeyboardListenerCubit(),
      ),
      BlocProvider(
        create: (context) => FeedbackCubit(context.read<KeyboardListenerCubit>()),
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
        create: (context) => OtpCubit(),
      ),
      BlocProvider(
        create: (context) => PDFCubit(),
      ),
      BlocProvider(
        create: (context) => PatientProfileCubit(),
      ),
    ], child: child);
  }
}