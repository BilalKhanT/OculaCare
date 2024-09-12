
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/camera/camera_cubit.dart';
import '../../../logic/tests/test_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/schedule_bottom_modal.dart';


class AnimalGameInitial extends StatelessWidget {
  const AnimalGameInitial({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.screenBackground,
          centerTitle: true,
          title: Text(
            'Animal Tracking',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.05,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.read<TestCubit>().loadTests();
              context.go(RouteNames.testRoute);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          color: AppColors.screenBackground,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 20.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Lottie.asset(
                    "assets/lotties/track.json",
                    height: screenHeight * 0.35,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Instructions',
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.05,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Flexible(
                  child: Text(
                    '1. Carefully follow animal movements and fix your gaze to keep animal within your focus.',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Flexible(
                  child: Text(
                    '2. Tap on animal to score, you have 5 lives, use them carefully while tapping.',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontSize: screenWidth * 0.04,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ButtonFlat(
                  btnColor: AppColors.appColor,
                  textColor: Colors.white,
                  onPress: () {
                    context.read<CameraCubit>().initializeCamera();
                    context.go(RouteNames.distanceRoute, extra: 2);
                  },
                  text: 'Take Test',
                ),
                SizedBox(height: screenHeight * 0.02),
                ButtonFlat(
                  btnColor: Colors.black,
                  textColor: Colors.white,
                  onPress: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      enableDrag: false,
                      isDismissible: false,
                      builder: (BuildContext bc) {
                        return ScheduleBottomModal(
                          controller:
                          context.read<ScheduleCubit>().controller,
                          test: 'Animal Track Test',
                        );
                      },
                    );
                  },
                  text: 'Schedule Test',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
