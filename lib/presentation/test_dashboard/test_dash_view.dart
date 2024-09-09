import 'package:OculaCare/presentation/test_dashboard/widgets/test_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/tests/color_more_cubit.dart';
import '../../logic/tests/color_more_state.dart';
import '../../logic/tests/color_tests/isihara_cubit.dart';
import '../../logic/tests/color_tests/match_color_cubit.dart';
import '../../logic/tests/color_tests/odd_out_cubit.dart';
import '../../logic/tests/test_cubit.dart';
import '../../logic/tests/test_dash_tab_cubit.dart';
import '../../logic/tests/test_dash_tab_state.dart';
import '../../logic/tests/test_more_cubit.dart';
import '../../logic/tests/test_more_state.dart';
import '../../logic/tests/test_schedule_cubit.dart';
import '../../logic/tests/test_schedule_tab_cubit.dart';
import '../../logic/tests/test_state.dart';
import '../../logic/tests/vision_tests/contrast_cubit.dart';
import '../../logic/tests/vision_tests/snellan_test_cubit.dart';
import '../widgets/cstm_loader.dart';

class TestDashView extends StatelessWidget {
  const TestDashView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Test Dashboard',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                context.read<ScheduleTabCubit>().toggleTab(0);
                context.read<ScheduleCubit>().loadVisionNotifications();
                context.push(RouteNames.scheduledRoute);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.bookmark_border,
                    color: AppColors.appColor,
                  ),
                  const SizedBox(
                    width: 3.0,
                  ),
                  Text(
                    'Scheduled',
                    style: TextStyle(
                      color: AppColors.appColor,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<TestDashTabCubit, TestDashTabState>(
                builder: (context, state) {
                  bool testSelected = false;
                  bool historySelected = false;
                  bool progressionSelected = false;

                  if (state is TestDashTabToggled) {
                    testSelected = state.isTest;
                    historySelected = state.isHistory;
                    progressionSelected = state.isProgression;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<TestDashTabCubit>().toggleTab(0);
                            context.read<TestCubit>().loadTests();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: testSelected ? AppColors.appColor.withOpacity(0.85) : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            child: Text(
                              'Tests',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                                color: testSelected
                                    ? AppColors.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenHeight * 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<TestDashTabCubit>().toggleTab(1);
                            context.read<TestCubit>().loadTestHistory();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: historySelected ? AppColors.appColor.withOpacity(0.85) : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child: Text(
                              'History',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                                color: historySelected
                                    ? AppColors.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenHeight * 0.01,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<TestDashTabCubit>().toggleTab(2);
                            context.read<TestCubit>().loadTestProgression();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: progressionSelected ? AppColors.appColor.withOpacity(0.85) : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                            child: Text(
                              'Progression',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.045,
                                color: progressionSelected
                                    ? AppColors.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              BlocBuilder<TestCubit, TestState>(
                builder: (context, state) {
                  if (state is TestLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.35),
                          const DotLoader(
                            loaderColor: AppColors.appColor,
                          ),
                        ],
                      ),
                    );
                  } else if (state is TestLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Vision Acuity Tests',
                            style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.w800,
                                fontSize: screenWidth * 0.045,
                                color: AppColors.appColor),
                          ),
                          SizedBox(
                            height: screenHeight * 0.008,
                          ),
                          TestTile(
                              title: 'Snellan Chart',
                              description:
                              'Test snellan chart test to\nmeasure your vision acuity.',
                              image: 'assets/images/snellan_test.png',
                              onPress: () {
                                context.read<SnellanTestCubit>().loadSnellanTest();
                                context.go(RouteNames.snellanRoute,);
                              },
                              avatarColor: AppColors.appColor.withOpacity(0.4)),
                          TestTile(
                              title: 'Animal Tracking',
                              description:
                              'Track animals and maintain\nfocus to test vision.',
                              image: 'assets/images/drag_test.png',
                              onPress: () {
                                context.go(RouteNames.trackInitialRoute,);
                              },
                              avatarColor: Colors.blueAccent.withOpacity(0.2)),
                          BlocBuilder<TestMoreCubit, TestMoreState>(
                            builder: (context, state) {
                              bool flag = false;
                              if (state is TestMoreToggled) {
                                flag = state.flag;
                              }
                              return flag == false
                                  ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<TestMoreCubit>()
                                              .toggle(true);
                                        },
                                        child: Text(
                                          'View more',
                                          style: TextStyle(
                                              fontFamily:
                                              'MontserratMedium',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              screenWidth * 0.035,
                                              color: AppColors.appColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                                  : Column(
                                children: <Widget>[
                                  TestTile(
                                      title: 'Contrast Sensitivity',
                                      description:
                                      'Distinguish high and low\ncontrasts.',
                                      image: 'assets/images/contrast_test.png',
                                      onPress: () {
                                        context.read<ContrastCubit>().emitInitial();
                                        context.go(RouteNames.contrastRoute, extra: true);
                                      },
                                      avatarColor: Colors.grey.withOpacity(0.4)),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<TestMoreCubit>()
                                              .toggle(false);
                                        },
                                        child: Text(
                                          'View Less',
                                          style: TextStyle(
                                              fontFamily:
                                              'MontserratMedium',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              screenWidth * 0.035,
                                              color: AppColors.appColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            'Color Perception Tests',
                            style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.w800,
                                fontSize: screenWidth * 0.045,
                                color: AppColors.appColor),
                          ),
                          SizedBox(
                            height: screenHeight * 0.008,
                          ),
                          TestTile(
                              title: 'Isihara Plates',
                              description:
                              'Identify digits and patterns\nin isihara plates.',
                              image: 'assets/images/isihara_test.png',
                              onPress: () {
                                context.read<IshiharaCubit>().restartTest();
                                context.push(RouteNames.isiharaRoute);
                              },
                              avatarColor: Colors.black.withOpacity(0.6)),
                          TestTile(
                              title: 'Odd Out',
                              description:
                              'Identify and pick the tile\nwith odd color.',
                              image: 'assets/images/odd_test.png',
                              onPress: () {
                                context.read<OddOutCubit>().emitInitial();
                                context.push(RouteNames.oddOutRoute);
                              },
                              avatarColor: Colors.green.withOpacity(0.3)),
                          BlocBuilder<ColorMoreCubit, ColorMoreState>(
                            builder: (context, state) {
                              bool flag2 = false;
                              if (state is ColorMoreToggled) {
                                flag2 = state.flag;
                              }
                              return flag2 == false
                                  ? Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ColorMoreCubit>()
                                              .toggle(true);
                                        },
                                        child: Text(
                                          'View more',
                                          style: TextStyle(
                                              fontFamily:
                                              'MontserratMedium',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              screenWidth * 0.035,
                                              color: AppColors.appColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                                  : Column(
                                children: <Widget>[
                                  TestTile(
                                      title: 'Match Color',
                                      description:
                                      'Match the flowing color\nfrom the list.',
                                      image: 'assets/images/color_match_test.png',
                                      onPress: () {
                                        context.read<MatchColorCubit>().emitInitial();
                                        context.push(RouteNames.colorMatchRoute);
                                      },
                                      avatarColor: Colors.grey.withOpacity(0.4)),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          context
                                              .read<ColorMoreCubit>()
                                              .toggle(false);
                                        },
                                        child: Text(
                                          'View Less',
                                          style: TextStyle(
                                              fontFamily:
                                              'MontserratMedium',
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                              screenWidth * 0.035,
                                              color: AppColors.appColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else if (state is TestHistory) {
                    return Column(
                      children: [
                    SizedBox(
                      height: 200,
                      width: 300,
                      child: ListView.builder(
                      itemCount: state.data.length,
                        itemBuilder: (context, index) {
                          return Text(state.data[index].testName);
                        },
                      ),
                    ),
                      ],
                    );
                  } else if (state is TestProgression) {
                    return const Column(
                      children: [
                        Text('Progression'),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
