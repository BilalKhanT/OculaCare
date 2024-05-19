import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/pdf_cubit/pdf_cubit_state.dart';
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