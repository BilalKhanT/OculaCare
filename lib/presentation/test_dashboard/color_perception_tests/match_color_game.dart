import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/tests/color_tests/match_color_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/schedule_bottom_modal.dart';
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
              Icons.arrow_back,
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
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Score: ${state.score}'),
          ButtonFlat(
            btnColor: Colors.black,
            textColor: Colors.white,
            onPress: () {
              context.read<MatchColorCubit>().restartGame();
            },
            text: 'Restart',
          ),
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
    return Column(
      children: [
        Expanded(
          child: FlowingWavePaint(
            color: state.currentColor,
            shouldAnimate: state.timeLeft == 10,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(50.0),
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
              child: Text(
                '${state.timeLeft}',
                style: TextStyle(
                  color: state.timeLeft <= 3 ? Colors.red : Colors.black,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.07,
                ),
              ),
            ),
          ),
        ),
        _buildLivesLeft(state.livesLeft),
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
