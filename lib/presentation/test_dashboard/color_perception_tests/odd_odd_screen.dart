import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/tests/color_tests/odd_out_cubit.dart';
import '../../../logic/tests/test_schedule_cubit.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/schedule_bottom_modal.dart';

class OutOddScreen extends StatelessWidget {
  const OutOddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: _buildAppBar(context),
        body: BlocBuilder<OddOutCubit, OddOutState>(
          builder: (context, state) {
            switch (state.status) {
              case OddOutStatus.gameOver:
                return _GameOverScreen(score: state.score);
              case OddOutStatus.initialLoading:
                return _InstructionsScreen();
              default:
                return _GameInProgressScreen(state: state);
            }
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.screenBackground,
      centerTitle: true,
      title: const Text(
        'Odd One Out',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'MontserratMedium',
          fontWeight: FontWeight.w800,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          context.read<OddOutCubit>().endGame();
          context.pop();
        },
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.appColor,
          size: 30.0,
        ),
      ),
    );
  }
}

class _InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Container(
      color: AppColors.screenBackground,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Lottie.asset(
              "assets/lotties/oddout.json",
              height: screenHeight * 0.3,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          _buildInstructionTitle(screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildInstructionText(screenWidth,
              '1. You start out with cubes, and click on the one where the shade looks slightly different.'),
          _buildInstructionText(screenWidth,
              '2. Each time you pick the correct cube, a new set of cubes is shown and you must once again pick the cube that stands out to you as different.'),
          SizedBox(height: screenHeight * 0.05),
          _buildButton(context, 'Take Test', AppColors.appColor, Colors.white,
              () {
            context.read<OddOutCubit>().restartGame();
          }),
          SizedBox(height: screenHeight * 0.02),
          _buildButton(context, 'Schedule Test', Colors.black, Colors.white,
              () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: false,
              isDismissible: false,
              builder: (BuildContext bc) {
                return ScheduleBottomModal(
                  controller: context.read<ScheduleCubit>().controller,
                  test: 'Odd One Out Test',
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInstructionTitle(double screenWidth) {
    return Text(
      'Instructions',
      style: TextStyle(
        color: AppColors.appColor,
        fontFamily: 'MontserratMedium',
        fontWeight: FontWeight.w800,
        fontSize: screenWidth * 0.05,
      ),
    );
  }

  Widget _buildInstructionText(double screenWidth, String text) {
    return Flexible(
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'MontserratMedium',
          fontSize: screenWidth * 0.04,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, Color btnColor,
      Color textColor, VoidCallback onPress) {
    return ButtonFlat(
      btnColor: btnColor,
      textColor: textColor,
      onPress: onPress,
      text: text,
    );
  }
}

class _GameOverScreen extends StatelessWidget {
  final int score;

  const _GameOverScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Game Over! Your Score: $score',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.read<OddOutCubit>().restartGame(),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}

class _GameInProgressScreen extends StatelessWidget {
  final OddOutState state;

  const _GameInProgressScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LivesDisplay(livesLeft: state.livesLeft),
        _TimerDisplay(timeLeft: state.timeLeft),
        _GridBlocks(state: state),
      ],
    );
  }
}

class _LivesDisplay extends StatelessWidget {
  final int livesLeft;

  const _LivesDisplay({required this.livesLeft});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          livesLeft,
          (index) => const Icon(
            Icons.favorite,
            color: Colors.redAccent,
            size: 40,
          ),
        ),
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final int timeLeft;

  const _TimerDisplay({required this.timeLeft});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.white,
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
            '$timeLeft',
            style: TextStyle(
              color: timeLeft <= 3 ? Colors.red : Colors.black,
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w900,
              fontSize: screenWidth * 0.07,
            ),
          ),
        ),
      ),
    );
  }
}

class _GridBlocks extends StatelessWidget {
  final OddOutState state;

  const _GridBlocks({required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: state.gridColors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.read<OddOutCubit>().selectBlock(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              decoration: BoxDecoration(
                color: state.gridColors[index],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  if (index == state.selectedIndex)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
