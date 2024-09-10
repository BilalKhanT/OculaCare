import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/tests/vision_tests/animal_track_cubit.dart';
import 'animal_track_game.dart';

class AnimalGameScreen extends StatelessWidget {
  final AnimalTrackCubit cubit;
  const AnimalGameScreen({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final game = AnimalTrackGame(cubit, context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: GameWidget(
                game: game,
              ),
            ),
            Positioned(
              top: 80,
              left: 30,
              child: BlocBuilder<AnimalTrackCubit, AnimalTrackState>(
                bloc: cubit,
                builder: (context, state) {
                  return Container(
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Text(
                          'Score: ${state.score}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w900,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 80,
              right: 20,
              child: BlocBuilder<AnimalTrackCubit, AnimalTrackState>(
                bloc: cubit,
                builder: (context, state) {
                  return Container(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          (5 - state.mistaps),
                          (index) => const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 80,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: ValueListenableBuilder<int>(
                valueListenable: game.timeLeftNotifier,
                builder: (context, timeLeft, child) {
                  return Container(
                    height: 50,
                    width: 50,
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
                        '$timeLeft',
                        style: TextStyle(
                          color: timeLeft <= 3 ? Colors.red : Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
