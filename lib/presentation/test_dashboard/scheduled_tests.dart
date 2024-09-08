import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../logic/tests/test_schedule_cubit.dart';
import '../../logic/tests/test_schedule_tab_cubit.dart';
import '../../logic/tests/test_schedule_tab_state.dart';
import '../widgets/cstm_loader.dart';

class ScheduledTests extends StatelessWidget {
  const ScheduledTests({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
        title: Text(
          'Scheduled Tests',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BlocBuilder<ScheduleTabCubit, ScheduleTabState>(
              builder: (context, state) {
                bool visionSelected = false;
                bool colorSelected = false;

                if (state is ScheduleTabToggled) {
                  visionSelected = state.isVision;
                  colorSelected = state.isColor;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<ScheduleTabCubit>().toggleTab(0);
                          context
                              .read<ScheduleCubit>()
                              .loadVisionNotifications();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: visionSelected
                                    ? AppColors.appColor
                                    : Colors.transparent,
                                width: 4.0,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text(
                            'Vision Tests',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.045,
                              color: visionSelected
                                  ? AppColors.appColor
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<ScheduleTabCubit>().toggleTab(1);
                          context
                              .read<ScheduleCubit>()
                              .loadColorNotifications();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colorSelected
                                    ? AppColors.appColor
                                    : Colors.transparent,
                                width: 4.0,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text(
                            'Color Tests',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w700,
                              fontSize: screenWidth * 0.045,
                              color: colorSelected
                                  ? AppColors.appColor
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
            BlocBuilder<ScheduleCubit, ScheduleState>(
              builder: (context, state) {
                if (state is ScheduleLoading) {
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
                } else if (state is ScheduleVisionLoaded) {
                  return state.scheduledNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: screenHeight * 0.35),
                              Text(
                                'No Scheduled Vision Tests',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.appColor,
                                  fontFamily: 'MontserratMedium',
                                  fontWeight: FontWeight.w900,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: screenHeight * 0.05),
                              SizedBox(
                                height: screenHeight * 0.7,
                                child: ListView.builder(
                                  itemCount:
                                      state.scheduledNotifications.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    top: 10.0,
                                                    bottom: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${state.scheduledNotifications[index]['title']}',
                                                      style: TextStyle(
                                                        color: AppColors.appColor,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Time:',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${state.scheduledNotifications[index]['time']}',
                                                      style: TextStyle(
                                                        color:
                                                            Colors.grey.shade700,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            screenWidth * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: SizedBox(
                                                width: 60,
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 40.0,
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<ScheduleCubit>()
                                                          .removeNotification(
                                                              '${state.scheduledNotifications[index]['id']}',
                                                              'vision');
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                } else if (state is ScheduleColorLoaded) {
                  return state.scheduledNotifications.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: screenHeight * 0.35),
                              Text(
                                'No Scheduled Color Tests',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.appColor,
                                  fontFamily: 'MontserratMedium',
                                  fontWeight: FontWeight.w900,
                                  fontSize: screenWidth * 0.045,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: screenHeight * 0.05),
                              SizedBox(
                                height: screenHeight * 0.7,
                                child: ListView.builder(
                                  itemCount:
                                      state.scheduledNotifications.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    top: 10.0,
                                                    bottom: 10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      '${state.scheduledNotifications[index]['title']}',
                                                      style: TextStyle(
                                                        color: AppColors.appColor,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      'Time:',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize:
                                                            screenWidth * 0.04,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${state.scheduledNotifications[index]['time']}',
                                                      style: TextStyle(
                                                        color:
                                                            Colors.grey.shade700,
                                                        fontFamily:
                                                            'MontserratMedium',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            screenWidth * 0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: SizedBox(
                                                width: 60,
                                                child: Center(
                                                  child: IconButton(
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 40.0,
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<ScheduleCubit>()
                                                          .removeNotification(
                                                              '${state.scheduledNotifications[index]['id']}',
                                                              'color');
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
          ],
        )),
      ),
    );
  }
}
