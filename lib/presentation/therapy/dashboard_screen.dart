import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_dashboard_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_dashboard_states.dart';
import 'package:OculaCare/presentation/therapy/sections/history_section.dart';
import 'package:OculaCare/presentation/therapy/sections/progression_section.dart';
import 'package:OculaCare/presentation/therapy/sections/therapy_section.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/therapy_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../configs/routes/route_names.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/therapy_cubit/therapy_schedule_tab_cubit.dart';
import '../../logic/therapy_cubit/therapy_schedule_cubit.dart';

class DashboardScreen extends StatelessWidget {
  final String selectedTherapyType = "Crossed Eyes";

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Therapy Dashboard',
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
                context.read<TherapyScheduleTabCubit>().toggleTab(0);
                context.read<TherapyScheduleCubit>().loadGeneralTherapies();
                context.push(RouteNames.therapyScheduledRoute);
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                      'assets/svgs/schedule.svg',
                      // ignore: deprecated_member_use
                      color: AppColors.appColor
                  ),
                  const SizedBox(
                    width: 6.0,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<TherapyDashboardCubit, TherapyDashboardStates>(
                builder: (context, state) {
                  bool therapySelected = state is TherapyDashboardInitialState;
                  bool historySelected = state is TherapyDashboardHistoryState;
                  bool progressionSelected = state is TherapyDashboardProgressionState;

                  return TherapyTabs(
                    therapySelected: therapySelected,
                    historySelected: historySelected,
                    progressionSelected: progressionSelected,
                    onSelectTherapy: () => context.read<TherapyDashboardCubit>().loadInitial(),
                    onSelectHistory: () => context.read<TherapyDashboardCubit>().loadHistory(),
                    onSelectProgression: () => context.read<TherapyDashboardCubit>().loadProgression(),
                  );
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              BlocBuilder<TherapyDashboardCubit, TherapyDashboardStates>(
                builder: (context, state) {
                  if (state is TherapyDashboardInitialState) {
                    return TherapySection(
                      selectedTherapyType: selectedTherapyType,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    );
                  } else if (state is TherapyDashboardHistoryState) {
                    return HistorySection(
                      screenHeight: MediaQuery.of(context).size.height,
                      screenWidth: MediaQuery.of(context).size.width,
                      patientName: sharedPrefs.userName,
                    );
                  } else if (state is TherapyDashboardProgressionState) {
                    return ProgressionSection(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                      patientName: sharedPrefs.userName,
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
