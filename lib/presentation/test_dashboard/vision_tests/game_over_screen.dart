import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/snellan_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/routes/route_names.dart';
import '../../../logic/tests/test_cubit.dart';
import '../../../logic/tests/vision_tests/animal_track_score_cubit.dart';
import '../../../logic/tests/vision_tests/animal_track_score_state.dart';
import '../../widgets/btn_flat.dart';
import '../../widgets/cstm_loader.dart';

class GameOverScreen extends StatelessWidget {
  final int score1;
  final int score2;
  final int score3;
  const GameOverScreen(
      {super.key,
      required this.score1,
      required this.score2,
      required this.score3});

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
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.appColor,),
            ),
          ),
          body: BlocBuilder<AnimalTrackScoreCubit, AnimalTrackScoreState>(
            builder: (context, state) {
              if (state is AnimalTrackScoreInitial) {
                context
                    .read<AnimalTrackScoreCubit>()
                    .analyseTrackScore(score1, score2, score3);
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
                      TrackChart(score: score1 + score2 + score3),
                      Text(
                        'Your vision acuity score is ${score1 + score2 + score3}.',
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
                              context
                                  .read<AnimalTrackScoreCubit>()
                                  .emitInitial();
                              context.go(RouteNames.trackInitialRoute);
                            },
                            text: 'Restart Test'),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ButtonFlat(
                            btnColor: Colors.black,
                            textColor: Colors.white,
                            onPress: () async {
                              context
                                  .read<AnimalTrackScoreCubit>()
                                  .emitInitial();
                              context.read<TestCubit>().loadTests();
                              context.go(RouteNames.testRoute);
                            },
                            text: 'Exit Test'),
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
