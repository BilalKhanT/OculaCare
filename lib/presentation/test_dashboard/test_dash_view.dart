import 'package:OculaCare/data/models/tests/history_args_model.dart';
import 'package:OculaCare/logic/tests/test_progression_cubit.dart';
import 'package:OculaCare/logic/tests/test_progression_state.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/test_history_tile.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/test_progress_heatmap.dart';
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

  HistoryArgsModel getPath(String testName) {
    if (testName == 'Snellan Chart') {
      return HistoryArgsModel(
          imagePath: 'assets/images/snellan_test.png',
          color: AppColors.appColor.withOpacity(0.4));
    } else if (testName == 'Contrast Sensitivity') {
      return HistoryArgsModel(
          imagePath: 'aassets/images/contrast_test.png',
          color: Colors.grey.withOpacity(0.4));
    } else if (testName == 'Animal Track') {
      return HistoryArgsModel(
          imagePath: 'assets/images/drag_test.png',
          color: Colors.blueAccent.withOpacity(0.2));
    } else if (testName == 'Isihara Plates') {
      return HistoryArgsModel(
          imagePath: 'assets/images/isihara_test.png',
          color: Colors.black.withOpacity(0.6));
    } else if (testName == 'Match Color') {
      return HistoryArgsModel(
          imagePath: 'assets/images/color_match_test.png',
          color: Colors.grey.withOpacity(0.4));
    } else if (testName == 'Odd One Out') {
      return HistoryArgsModel(
          imagePath: 'assets/images/odd_test.png',
          color: Colors.green.withOpacity(0.3));
    } else {
      return HistoryArgsModel(
          imagePath: 'assets/images/isihara_test.png',
          color: Colors.black.withOpacity(0.6));
    }
  }

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
                              color: testSelected
                                  ? AppColors.appColor.withOpacity(0.85)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 6.0),
                            child: Text(
                              'Tests',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                                color: testSelected
                                    ? AppColors.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenHeight * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<TestDashTabCubit>().toggleTab(1);
                            context.read<TestCubit>().loadTestHistory();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: historySelected
                                  ? AppColors.appColor.withOpacity(0.85)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10.0),
                            child: Text(
                              'History',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
                                color: historySelected
                                    ? AppColors.whiteColor
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenHeight * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<TestDashTabCubit>().toggleTab(2);
                            context.read<TestCubit>().loadTestProgression();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: progressionSelected
                                  ? AppColors.appColor.withOpacity(0.85)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10.0),
                            child: Text(
                              'Progression',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.04,
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
                                context
                                    .read<SnellanTestCubit>()
                                    .loadSnellanTest();
                                context.go(
                                  RouteNames.snellanRoute,
                                );
                              },
                              avatarColor: AppColors.appColor.withOpacity(0.4)),
                          TestTile(
                              title: 'Animal Tracking',
                              description:
                                  'Track animals and maintain\nfocus to test vision.',
                              image: 'assets/images/drag_test.png',
                              onPress: () {
                                context.go(
                                  RouteNames.trackInitialRoute,
                                );
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
                                            image:
                                                'assets/images/contrast_test.png',
                                            onPress: () {
                                              context
                                                  .read<ContrastCubit>()
                                                  .emitInitial();
                                              context.go(
                                                  RouteNames.contrastRoute,
                                                  extra: true);
                                            },
                                            avatarColor:
                                                Colors.grey.withOpacity(0.4)),
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
                                            image:
                                                'assets/images/color_match_test.png',
                                            onPress: () {
                                              context
                                                  .read<MatchColorCubit>()
                                                  .emitInitial();
                                              context.push(
                                                  RouteNames.colorMatchRoute);
                                            },
                                            avatarColor:
                                                Colors.grey.withOpacity(0.4)),
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.005,
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
                            height: screenHeight * 0.005,
                          ),
                          SizedBox(
                            height: screenHeight * 0.35,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: state.data.length,
                              itemBuilder: (context, index) {
                                final HistoryArgsModel data =
                                    getPath(state.data[index].testName);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2.0),
                                  child: TestHistoryTile(
                                      title: state.data[index].testName,
                                      description: state.data[index].date,
                                      image: data.imagePath,
                                      onPress: () {},
                                      avatarColor: data.color),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
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
                            height: screenHeight * 0.005,
                          ),
                          SizedBox(
                            height: screenHeight * 0.35,
                            width: double.infinity,
                            child: ListView.builder(
                              itemCount: state.dataColor.length,
                              itemBuilder: (context, index) {
                                final HistoryArgsModel data =
                                    getPath(state.dataColor[index].testName);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2.0),
                                  child: TestHistoryTile(
                                      title: state.dataColor[index].testName,
                                      description: state.dataColor[index].date,
                                      image: data.imagePath,
                                      onPress: () {},
                                      avatarColor: data.color),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is TestProgression) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Text(
                            'Tests Progress',
                            style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.w800,
                                fontSize: screenWidth * 0.045,
                                color: AppColors.appColor),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Center(
                              child: ProgressCalendarScreen(
                                  data: state.progressData)),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          BlocBuilder<TestProgressionCubit,
                              TestProgressionState>(
                            builder: (context, state) {
                              Map<DateTime, double> score = {};
                              if (state is TestProgressionToggled) {
                                score = state.scores;
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        context
                                            .read<TestProgressionCubit>()
                                            .selectedTest,
                                        style: TextStyle(
                                            fontFamily: 'MontserratMedium',
                                            fontWeight: FontWeight.w800,
                                            fontSize: screenWidth * 0.045,
                                            color: AppColors.appColor),
                                      ),
                                      Container(
                                        height: screenHeight * 0.05,
                                        width: screenWidth * 0.4,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              blurRadius: 10,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            dropdownColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5.0),
                                            value: context
                                                .read<TestProgressionCubit>()
                                                .selectedTest,
                                            icon: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.black,
                                            ),
                                            iconSize: screenWidth * 0.05,
                                            elevation: 10,
                                            style: const TextStyle(
                                                color: Colors.deepPurple),
                                            underline: Container(
                                              height: 0,
                                              color: AppColors.appColor,
                                            ),
                                            onChanged: (String? newValue) {
                                              context
                                                  .read<TestProgressionCubit>()
                                                  .toggleProgression(newValue!);
                                            },
                                            items: <String>[
                                              'Snellan Chart',
                                              'Animal Track',
                                              'Contrast Test',
                                              'Isihara Plates',
                                              'Match Color',
                                              'Odd One Out',
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'MontserratMedium',
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        screenWidth * 0.032,
                                                    letterSpacing: 1,
                                                    color: Colors.black,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              );
                                            }).toList(),
                                          ),
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
