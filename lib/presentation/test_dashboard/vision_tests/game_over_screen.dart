import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/routes/route_names.dart';
import '../../../logic/tests/vision_tests/animal_track_score_cubit.dart';
import '../../../logic/tests/vision_tests/animal_track_score_state.dart';
import '../../widgets/cstm_loader.dart';

class GameOverScreen extends StatelessWidget {
  final int score;
  const GameOverScreen({super.key, required this.score});

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
            leading: IconButton(
              onPressed: () {
                context.read<AnimalTrackScoreCubit>().emitInitial();
                context.go(RouteNames.trackInitialRoute);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: BlocBuilder<AnimalTrackScoreCubit, AnimalTrackScoreState>(
            builder: (context, state) {
              if (state is AnimalTrackScoreInitial) {
                context.read<AnimalTrackScoreCubit>().analyseTrackScore();
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
              } else if (state is AnimalTrackScoreLoaded) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$score',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )),
    );
  }
}
