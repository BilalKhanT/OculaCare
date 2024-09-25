import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../logic/therapy_cubit/therapy_schedule_cubit.dart';
import '../../logic/therapy_cubit/therapy_schedule_state.dart';
import '../../logic/therapy_cubit/therapy_schedule_tab_cubit.dart';
import '../../logic/therapy_cubit/therapy_schedule_tab_state.dart';
import '../widgets/cstm_loader.dart';

class ScheduledTherapies extends StatelessWidget {
  const ScheduledTherapies({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
        title: Text(
          'Scheduled Therapies',
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
              BlocBuilder<TherapyScheduleTabCubit, TherapyScheduleTabState>(
                builder: (context, state) {
                  bool generalSelected = false;
                  bool diseaseSpecificSelected = false;

                  if (state is TherapyScheduleTabToggled) {
                    generalSelected = state.isGeneral;
                    diseaseSpecificSelected = state.isDiseaseSpecific;
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                      child: Row(
                        children: [
                          _buildScheduleTab(
                            context,
                            'General',
                            generalSelected,
                                () {
                              context.read<TherapyScheduleTabCubit>().toggleTab(0);
                              context.read<TherapyScheduleCubit>().loadGeneralTherapies();
                            },
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                          _buildScheduleTab(
                            context,
                            'Disease Specific',
                            diseaseSpecificSelected,
                                () {
                              context.read<TherapyScheduleTabCubit>().toggleTab(1);
                              context.read<TherapyScheduleCubit>().loadDiseaseSpecificTherapies();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              BlocBuilder<TherapyScheduleCubit, TherapyScheduleState>(
                builder: (context, state) {
                  if (state is TherapyScheduleLoading) {
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
                  } else if (state is TherapyScheduled &&
                      state.scheduledTherapies.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            height: screenHeight * 0.7,
                            child: ListView.builder(
                              itemCount: state.scheduledTherapies.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            bool isGeneralSelected = context.read<TherapyScheduleTabCubit>().state is TherapyScheduleTabToggled &&
                                                (context.read<TherapyScheduleTabCubit>().state as TherapyScheduleTabToggled).isGeneral;
                                            context.read<TherapyScheduleCubit>().removeScheduledTherapy(
                                                '${state.scheduledTherapies[index]['id']}',
                                                isGeneralSelected
                                            );
                                          },
                                          icon: Icons.delete,
                                          backgroundColor: const Color(0xffB81736),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
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
                                                    '${state.scheduledTherapies[index]['title']}',
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
                                                    DateFormat('dd MMM hh:mm a').format(
                                                      DateTime.parse(state.scheduledTherapies[index]['time']!),
                                                    ),
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
                                        ],
                                      ),
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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: screenHeight * 0.35),
                          Text(
                            'No Scheduled Therapies',
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
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTab(
      BuildContext context, String title, bool isSelected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor.withOpacity(0.85) : Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.04,
            color: isSelected ? AppColors.whiteColor : Colors.black,
          ),
        ),
      ),
    );
  }
}