import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';

import '../../configs/presentation/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<ImageCaptureCubit>().initializeCamera();
          context.go(RouteNames.imgCaptureRoute);
        },
      ),
    );
  }
}
