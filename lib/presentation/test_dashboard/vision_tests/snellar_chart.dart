import 'package:OculaCare/presentation/test_dashboard/widgets/snellan_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/camera/camera_cubit.dart';
import '../../../logic/tests/test_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../../logic/tests/vision_tests/snellan_test_cubit.dart';
import '../../../logic/tests/vision_tests/snellan_test_state.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/cstm_loader.dart';
import '../../widgets/schedule_bottom_modal.dart';

class SnellanChart extends StatelessWidget {
  const SnellanChart({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Snellan Chart',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.05,
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              await context.read<SnellanTestCubit>().emitCompleted();
              if (context.mounted) {
                context.read<TestCubit>().loadTests();
                context.go(RouteNames.testRoute);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: BlocBuilder<SnellanTestCubit, SnellanTestState>(
          builder: (context, state) {
            if (state is SnellanTestLoading) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: DotLoader(
                      loaderColor: AppColors.appColor,
                    ),
                  ),
                ],
              );
            } else if (state is SnellanTestAnalysing) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: DotLoader(
                      loaderColor: AppColors.appColor,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Center(
                    child: Text(
                      'Analysing, please wait.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.05,
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is SnellanTestLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        "assets/images/snellangif.gif",
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
                        '1. Cover your one eye with your hand.',
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
                        '2. Please read out loud the alphabet you see on the screen.',
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
                        '3. Repeat the process for the other eye.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontSize: screenWidth * 0.04,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),
                    ButtonFlat(
                      btnColor: AppColors.appColor,
                      textColor: Colors.white,
                      onPress: () {
                        context.read<CameraCubit>().initializeCamera();
                        context.go(RouteNames.distanceRoute, extra: 3);
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
                              test: 'Snellan Chart Test',
                            );
                          },
                        );
                      },
                      text: 'Schedule Test',
                    ),
                  ],
                ),
              );
            } else if (state is SnellanTestNext) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Text(
                      state.alphabets[state.index],
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: state.fontSize,
                        letterSpacing: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.2,
                    ),
                    Lottie.asset(
                      "assets/lotties/speak.json",
                      height: screenHeight * 0.3,
                    ),
                  ]));
            } else if (state is SnellanTestCompleted) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/result_test.png',
                      height: screenHeight * 0.3,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text('Test Completed !',
                        style: TextStyle(
                          color: Colors.green,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.05,
                        )),
                    SizedBox(height: screenHeight * 0.02),
                    Image.asset(
                      'assets/images/snellan_result.png',
                      height: screenHeight * 0.2,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Your vision acuity is ${state.visionAcuity}.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: ButtonFlat(
                          btnColor: AppColors.appColor,
                          textColor: Colors.white,
                          onPress: () async {
                            await context
                                .read<SnellanTestCubit>()
                                .emitCompleted();
                            if (context.mounted) {
                              context.read<TestCubit>().loadTests();
                              context.go(RouteNames.testRoute);
                            }
                          },
                          text: 'Exit Test'),
                    ),
                  ],
                ),
              );
            } else if (state is SnellanTestError) {
              return const Center(
                child: Text(
                  'An error occurred with speech recognition. Please try again.',
                  style: TextStyle(fontSize: 24, color: Colors.red),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
