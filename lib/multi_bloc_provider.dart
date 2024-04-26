import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ocula_care/logic/image_capture/img_capture_cubit.dart';
import 'package:ocula_care/logic/otp_cubit/otp_cubit.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_cubit.dart';

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
        create: (context) => ImageCaptureCubit(),
      ),
      BlocProvider(
        create: (context) => OtpCubit(),
      ),
    ], child: child);
  }
}