import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/utils/utils.dart';
import '../../../logic/tests/color_tests/isihara_cubit.dart';
import '../../../logic/tests/color_tests/radio_btn_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/schedule_bottom_modal.dart';
import 'ishihara_painter.dart';

class IshiharaScreen extends StatelessWidget {
  const IshiharaScreen({super.key});

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
            'Match Color',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.05,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.read<IshiharaCubit>().closeGame();
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: BlocBuilder<IshiharaCubit, IshiharaState>(
          builder: (context, state) {
            if (state.testCompleted) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Test Completed!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You got ${state.correctAnswers} out of 10 correct.',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<IshiharaCubit>().restartTest(),
                      child: const Text('Restart Test'),
                    ),
                  ],
                ),
              );
            } else {
              return state.plates.isEmpty
                  ? Container(
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
                                "assets/lotties/sihara.json",
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
                                '1. Try to identify the hidden number within 5 seconds, however there is no time limit.',
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
                                '2. Choose the correct option from the list that matches the number inside isihara plate.',
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
                                context.read<IshiharaCubit>().startGame();
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
                                      controller: context
                                          .read<ScheduleCubit>()
                                          .controller,
                                      test: 'Isihara Plates Test',
                                    );
                                  },
                                );
                              },
                              text: 'Schedule Test',
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),
                        _buildTabBar(context, state, screenWidth),
                        SizedBox(height: screenHeight * 0.05),
                        Text(
                          'What do you see on the plate?',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),
                        _buildIshiharaPlate(context, state),
                        SizedBox(height: screenHeight * 0.05),
                        Center(child: _buildAnswerOptions(context, state)),
                        SizedBox(height: screenHeight * 0.05),
                        _buildButtons(context, state),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabBar(
      BuildContext context, IshiharaState state, double screenWidth) {
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          10,
          (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: height * 0.04,
                width: height * 0.02,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: state.currentIndex == index
                      ? AppColors.appColor
                      : Colors.grey[300],
                ),
                child: Center(
                    child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.04,
                    color: state.currentIndex == index
                        ? Colors.white
                        : Colors.black,
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIshiharaPlate(BuildContext context, IshiharaState state) {
    double height = MediaQuery.sizeOf(context).height;
    return Center(
      child: CustomPaint(
        size: Size(height * 0.3, height * 0.3),
        painter: IshiharaPainter(
          state.plates[state.currentIndex],
          state.numberColor.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(BuildContext context, IshiharaState state) {
    double width = MediaQuery.sizeOf(context).width;
    final options = [
      state.plates[state.currentIndex],
      state.plates[state.currentIndex] + 3,
      state.plates[state.currentIndex] - 3,
    ]..shuffle();

    return BlocBuilder<RadioBtnCubit, RadioBtnState>(
      builder: (context, radioState) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: options.map((option) {
              return Expanded(
                child: RadioListTile<int>(
                  activeColor: AppColors.appColor,
                  value: option,
                  groupValue: context.read<RadioBtnCubit>().answer,
                  onChanged: (value) => context
                      .read<RadioBtnCubit>()
                      .changeValue(value!, context),
                  title: Text(
                    option.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildButtons(BuildContext context, IshiharaState state) {
    double height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Column(
        children: [
          ButtonFlat(
              btnColor: Colors.green,
              textColor: Colors.white,
              onPress: () async {
                bool flag = await context.read<IshiharaCubit>().checkAnswer();
                if (flag) {
                } else {
                  if (context.mounted) {
                    AppUtils.showToast(context, 'Error',
                        'Please select a number from answer options', true);
                  }
                }
              },
              text: 'Submit Answer'),
          SizedBox(
            height: height * 0.02,
          ),
          ButtonFlat(
              btnColor: Colors.black,
              textColor: Colors.white,
              onPress: () => AppUtils.showToast(
                  context,
                  'Answer Hint',
                  'The number inside plate is ${state.plates[state.currentIndex]}',
                  false),
              text: 'Check Answer'),
        ],
      ),
    );
  }
}
