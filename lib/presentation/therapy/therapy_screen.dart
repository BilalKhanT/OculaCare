import 'dart:math';
import 'package:cculacare/presentation/therapy/widgets_therapy/corner_dot.dart';
import 'package:cculacare/presentation/therapy/widgets_therapy/cstm_therapies_progress_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../logic/therapy_cubit/therapy_cubit.dart';
import '../../logic/therapy_cubit/therapy_state.dart';
import '../../logic/therapy_cubit/timer_cubit.dart';
import '../widgets/btn_flat.dart';
import '../widgets/cstm_loader.dart';

class TherapyScreen extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const TherapyScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
// ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<TherapyCubit>(context).stopTherapy();
        return true;
      },
      child: BlocConsumer<TherapyCubit, TherapyState>(
        listener: (context, state) {
          if (state is TherapyCompleted) {
            AppUtils.showToast(context, state.therapyTitle,
                "Therapy completed successfully!", false);
          }
        },
        builder: (context, state) {
          if (state is TherapyStepInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: state.therapyTitle,
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                children: [
                  _buildTherapyImage(state.svgPath, width, height,
                      state.stepIndex, state.therapyTitle),
                  _buildInstructionsAndTimer(context, state.instruction, width),
                ],
              ),
            );
          } else if (state is TherapyLottieAnimationInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: exercise['title'],
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Lottie.asset(state.animationPath),
                  ),
                  _buildInstructionsAndTimer(context, state.instruction, width),
                ],
              ),
            );
          } else if (state is TherapyAnimationInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: exercise['title'],
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Stack(
                children: [
                  Positioned(
                    top: state.topPosition,
                    left: state.leftPosition,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Lottie.asset(
                          "assets/lotties/jumpingstripes.json",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: width / 2 - 100,
                    child: _buildRemainingTime(context, width),
                  ),
                ],
              ),
            );
          } else if (state is TherapyDistanceGazingInProgress) {
            return _buildDistanceGazingUI(context, state);
          } else if (state is TherapyYinYangAnimationInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: exercise['title'],
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Transform.rotate(
                      angle: state.rotation * pi / 180,
                      child: Transform.scale(
                        scale: state.scale,
                        child: Image.asset(state.animationPath),
                      ),
                    ),
                  ),
                  _buildInstructionsAndTimer(
                      context, state.instructions, width),
                ],
              ),
            );
          } else if (state is TherapyRiveAnimationInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: exercise['title'],
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Stack(children: [
                      rive.RiveAnimation.asset(
                        state.animationPath,
                        fit: BoxFit.contain,
                      ),
                    ]),
                  ),
                  _buildInstructionsAndTimer(context, "Roll Your Eyes", width),
                ],
              ),
            );
          } else if (state is TherapyBrockStringInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: state.therapyTitle,
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStringAndBeads(width, height, state.beadOpacities),
                  _buildInstructionsAndTimer(context, state.instruction, width),
                ],
              ),
            );
          } else if (state is TherapyCompleted) {
            double screenHeight = MediaQuery.of(context).size.height;
            double screenWidth = MediaQuery.of(context).size.width;
            return Scaffold(
              backgroundColor: AppColors.screenBackground,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: AppColors.screenBackground,
                title: Text(
                  state.therapyTitle,
                  style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.05,
                    color: AppColors.textPrimary,
                  ),
                ),
                centerTitle: true,
                leading: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.screenBackground,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.4,
                        child: Lottie.asset(
                          "assets/lotties/done.json",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Congratulations! You have successfully completed the therapy.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonFlat(
                            btnColor: AppColors.appColor,
                            textColor: AppColors.whiteColor,
                            onPress: () {
                              context.push(RouteNames.therapyFeedbackRoute,
                                  extra: state.therapyModel);
                            },
                            text: "Submit Feedback"),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonFlat(
                            btnColor: AppColors.whiteColor,
                            textColor: Colors.black,
                            onPress: () {
                              BlocProvider.of<TherapyCubit>(context)
                                  .resetTherapy();
                              Navigator.pop(context);
                            },
                            text: "View Dashboard"),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is TherapyMirrorEyeStretchInProgress) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTherapyTitle(state.therapyTitle, width),
                Expanded(
                  child: Stack(
                    children: [
                      CornerDot(
                        dotPositions: state.dotPositions,
                        dotOpacity: state.dotOpacity,
                      ),
                    ],
                  ),
                ),
                _buildInstructionsAndTimer(context, state.instruction, width),
              ],
            );
          } else if (state is TherapyStoryDisplayInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: state.therapyTitle,
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.story,
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontSize: width * 0.045,
                          color: AppColors.textTherapy,
                        ),
                      ),
                    ),
                  ),
                  _buildInstructionsAndTimer(context, state.instruction, width),
                ],
              ),
            );
          } else if (state is TherapyBlinkingAnimationInProgress) {
            return Scaffold(
              backgroundColor: AppColors.backgroundTherapy,
              appBar: CustomTherapiesAppBar(
                title: exercise['title'],
                onBackPressed: () {
                  BlocProvider.of<TherapyCubit>(context).stopTherapy();
                  Navigator.pop(context);
                },
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(state.animationPath),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      state.instruction,
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: AppColors.textTherapy,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Timer
                  BlocBuilder<TimerCubit, int>(
                    builder: (context, remainingTime) {
                      return Text(
                        "Time Left: ${_formattedTime(remainingTime)}",
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w700,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: AppColors.textTherapy,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is TherapyLoading) {
            return const Scaffold(
              backgroundColor: AppColors.screenBackground,
              body: Center(
                child: DotLoader(
                  loaderColor: AppColors.appColor,
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundTherapy,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textTherapy),
        onPressed: () {
          BlocProvider.of<TherapyCubit>(context).stopTherapy();
          Navigator.pop(context);
        },
      ),
    );
  }

  Padding _buildTherapyTitle(String therapyTitle, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          therapyTitle,
          style: TextStyle(
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.06,
            color: AppColors.textTherapy,
          ),
        ),
      ),
    );
  }

  Widget _buildTherapyImage(String svgPath, double width, double height,
      int stepIndex, String therapyTitle) {
    double imageSize;

    if (therapyTitle == "Distance Gazing") {
      imageSize = (stepIndex == 1)
          ? 24
          : (stepIndex == 2)
              ? 512
              : width * 0.7;
    } else if (therapyTitle == "Eye Patch Therapy") {
      imageSize = (stepIndex == 1) ? width : width;
    } else {
      imageSize = width * 0.7;
    }

    return Expanded(
      child: Center(
        child: Image.asset(
          svgPath,
          width: imageSize,
          height: imageSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Padding _buildInstructionsAndTimer(
      BuildContext context, String instruction, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            instruction,
            style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.045,
              color: AppColors.textTherapy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          _buildRemainingTime(context, screenWidth),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  BlocBuilder<TimerCubit, int> _buildRemainingTime(
      BuildContext context, double screenWidth) {
    return BlocBuilder<TimerCubit, int>(
      builder: (context, remainingTime) {
        return Text(
          "Time Left: ${_formattedTime(remainingTime)}",
          style: TextStyle(
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w700,
            fontSize: screenWidth * 0.05,
            color: AppColors.textTherapy,
          ),
        );
      },
    );
  }

  String _formattedTime(int timeLimit) {
    final minutes = (timeLimit ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeLimit % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Widget _buildDistanceGazingUI(
      BuildContext context, TherapyDistanceGazingInProgress state) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTherapy,
      appBar: _buildAppBar(context),
      body: Stack(
        children: [
          Positioned(
            left: 100,
            child: Image.asset(
              state.svgPathFar,
              width: state.farSize,
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 100,
            child:
                _buildRemainingTime(context, MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }

  Widget _buildStringAndBeads(
      double width, double height, List<double> beadOpacities) {
    return SizedBox(
      height: height * 0.4,
      width: width * 0.6,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 5,
                height: height * 0.4,
                color: Colors.grey,
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedOpacity(
                    opacity: beadOpacities[0],
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: beadOpacities[1],
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: beadOpacities[2],
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
