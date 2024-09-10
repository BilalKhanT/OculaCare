import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/camera/camera_cubit.dart';
import '../../../logic/tests/test_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../../logic/tests/vision_tests/contrast_cubit.dart';
import '../../../logic/tests/vision_tests/contrast_state.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/cstm_loader.dart';
import '../../widgets/schedule_bottom_modal.dart';

class ContrastGameScreen extends StatelessWidget {
  final bool isHome;
  const ContrastGameScreen({super.key, required this.isHome});

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
            'Contrast Sensitivity',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.05,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.read<ContrastCubit>().closeGame();
              context.read<TestCubit>().loadTests();
              context.go(RouteNames.testRoute);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: BlocBuilder<ContrastCubit, ContrastState>(
          builder: (context, state) {
            if (state is ContrastInitial) {
              return Container(
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
                          "assets/lotties/contrast.json",
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
                          '1. You will see group of letters and three options below it. Select the correct option.',
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
                          '2. On each new screen, you will see that the letters reduce in contrast.',
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
                          context.go(RouteNames.distanceRoute, extra: 1);
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
                                test: 'Contrast Test',
                              );
                            },
                          );
                        },
                        text: 'Schedule Test',
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ContrastLoading) {
              return Container(
                height: screenHeight,
                width: screenWidth,
                color: AppColors.screenBackground,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const DotLoader(
                        loaderColor: AppColors.appColor,
                      ),
                      SizedBox(
                        height: screenHeight * 0.1,
                      ),
                      Text(
                        'Analysing, please wait.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ContrastGameInProgress ||
                state is ContrastQuestion) {
              return _buildQuestionScreen(context, state);
            } else if (state is ContrastGameOver) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Game Over! Your Score: ${state.score}',
                        style: const TextStyle(fontSize: 24)),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ContrastCubit>().startGame(),
                      child: const Text('Restart'),
                    ),
                  ],
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

  Widget _buildQuestionScreen(BuildContext context, ContrastState state) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    if (state is ContrastQuestion) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.correctWord,
              style: TextStyle(
                color: Colors.black.withOpacity(state.contrast),
                fontFamily: 'MontserratMedium',
                fontWeight: FontWeight.w800,
                letterSpacing: 40,
                fontSize: screenWidth * 0.15,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            ...state.options.map((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: optionButton(() {
                    context
                        .read<ContrastCubit>()
                        .selectOption(option, state.correctWord);
                  }, Colors.deepOrangeAccent, Colors.white, option,
                      screenWidth),
                )),
          ],
        ),
      );
    }
    return Container();
  }
}

Widget optionButton(Function() onPress, Color btnColor, Color textColor,
    String text, double screenWidth) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50.0),
    child: GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
                letterSpacing: 15,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
