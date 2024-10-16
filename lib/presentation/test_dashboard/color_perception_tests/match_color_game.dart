import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/tests/color_tests/match_color_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/cstm_loader.dart';
import '../../widgets/schedule_bottom_modal.dart';
import '../widgets/severity_chart.dart';
import 'flowing_painter.dart';

class MatchColorGameScreen extends StatelessWidget {
  const MatchColorGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final colors = [
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.pink,
      Colors.blue
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
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
              context.read<MatchColorCubit>().closeCubit();
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/screen_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            BlocBuilder<MatchColorCubit, MatchColorState>(
              builder: (context, state) {
                if (state is MatchColorGameInitial) {
                  return _buildInitialInstructions(
                      context, screenHeight, screenWidth);
                } else if (state is MatchColorGameLoading) {
                  return Container(
                    color: AppColors.screenBackground,
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
                  );
                } else if (state is MatchColorGameOver) {
                  return _buildGameOverScreen(context, state);
                } else if (state is MatchColorGameInProgress) {
                  return _buildGameInProgress(
                      context, state, screenHeight, screenWidth, colors);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialInstructions(
      BuildContext context, double screenHeight, double screenWidth) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: AppColors.screenBackground,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Lottie.asset(
                "assets/lotties/colormatch.json",
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
                '1. Your goal is to match the given color with the closest possible color from the available options.',
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
                '2. You are provided with 3 lives, use them carefully while clicking.',
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
                context.read<MatchColorCubit>().restartGame();
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
                      controller: context.read<ScheduleCubit>().controller,
                      test: 'Match Color Test',
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
  }

  Widget _buildGameOverScreen(BuildContext context, MatchColorGameOver state) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      color: AppColors.screenBackground,
      height: screenHeight,
      width: screenWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          SeverityChart(score: state.score),
          Text(
            'You got ${state.score} out of 10 correct.',
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
                onPress: () => context.read<MatchColorCubit>().restartGame(),
                text: 'Restart Test'),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ButtonFlat(
                btnColor: Colors.black,
                textColor: Colors.white,
                onPress: () {
                  context.read<MatchColorCubit>().closeCubit();
                  context.pop();
                },
                text: 'Exit Test'),
          )
        ],
      ),
    );
  }

  Widget _buildGameInProgress(
      BuildContext context,
      MatchColorGameInProgress state,
      double screenHeight,
      double screenWidth,
      List<Color> colors) {
    return Container(
      height: screenHeight,
      width: screenWidth,
      color: AppColors.backgroundTherapy,
      child: Column(
        children: [
          Expanded(
            child: FlowingWavePaint(
              color: state.currentColor,
              shouldAnimate: state.timeLeft == 10,
            ),
          ),
          _buildLivesLeft(state.livesLeft),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: AppColors.textTherapy,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Center(
                child: Text(
                  '${state.timeLeft}',
                  style: TextStyle(
                    color: state.timeLeft <= 3 ? Colors.red : Colors.black,
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w900,
                    fontSize: screenWidth * 0.06,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: state.options.map((color) {
                return GestureDetector(
                  onTap: () {
                    context.read<MatchColorCubit>().chooseColor(color);
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/bucket.svg',
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    width: screenHeight * 0.1,
                    height: screenHeight * 0.1,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLivesLeft(int livesLeft) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        livesLeft,
        (index) => const Icon(
          Icons.favorite,
          color: Colors.redAccent,
          size: 40,
        ),
      ),
    );
  }
}
