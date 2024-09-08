
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/camera/camera_cubit.dart';
import '../../../logic/camera/camera_state.dart';
import '../../../logic/tests/vision_tests/contrast_cubit.dart';
import '../../../logic/tests/vision_tests/snellan_initial_cubit.dart';
import '../../../logic/tests/vision_tests/snellan_test_cubit.dart';
import '../../widgets/cstm_loader.dart';


class CameraDistanceView extends StatelessWidget {
  final int flag;
  const CameraDistanceView({super.key, required this.flag});

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
          leading: IconButton (
            onPressed: () async {
              await context.read<CameraCubit>().disposeCamera();
              if (context.mounted) {
                if (flag == 1) {
                  context.read<ContrastCubit>().emitInitial();
                  context.go(RouteNames.contrastRoute, extra: false);
                }
                else if (flag == 2) {
                  context.go(RouteNames.trackInitialRoute,);
                }
                else if (flag == 3) {
                  context.read<SnellanTestCubit>().loadSnellanTest();
                  context.go(RouteNames.snellanRoute,);
                }
              }
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.appColor,
              size: 30.0,
            ),
          ),
        ),
        body: BlocConsumer<CameraCubit, CameraState>(
          listener: (context, state) {
            if (state is CameraSuccess) {
              context.read<CameraCubit>().disposeCamera();
              if (flag == 1) {
                context.read<ContrastCubit>().startGame();
                context.go(RouteNames.contrastRoute, extra: false);
              }
              else if (flag == 2) {
                context.go(RouteNames.trackRoute,);
              }
              else if (flag == 3) {
                context.read<SnellanInitialCubit>().startSpeaking('left');
                context.push(RouteNames.snellanInitialRoute, extra: 'left');
              }
            }
          },
          builder: (context, state) {
            if (state is CameraLoading) {
              return const Center(
                  child: DotLoader(
                loaderColor: AppColors.appColor,
              ));
            } else if (state is CameraError) {
              return const Center(
                child: Text(
                  'Failed to load camera, please try again',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (state is CameraLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Lottie.asset(
                        "assets/lotties/camera.json",
                        height: screenHeight * 0.3,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
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
                        '1. Keep your phone still at a distance of 30cm.',
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
                        '2. Keep your phone at the same distance throughout the test.',
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
                        '3. Move your phone close or away based on the instructions below.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontSize: screenWidth * 0.04,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.1,),
                    Center(
                      child: Flexible(
                        child: Text(
                          state.state,
                          style: TextStyle(
                            color: state.state == 'Checking' ? Colors.green : Colors.red,
                            fontFamily: 'MontserratMedium',
                            fontSize: screenWidth * 0.04,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}
