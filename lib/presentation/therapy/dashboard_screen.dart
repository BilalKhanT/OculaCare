import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_dashboard_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_dashboard_states.dart';
import 'package:OculaCare/presentation/therapy/sections/history_section.dart';
import 'package:OculaCare/presentation/therapy/sections/progression_section.dart';
import 'package:OculaCare/presentation/therapy/sections/therapy_section.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/therapy_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  final String selectedTherapyType = "Crossed Eyes";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: const Text("Therapy Dashboard", style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Therapy, History, and Progression Tabs
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

              // Conditional UI Rendering based on state
              BlocBuilder<TherapyDashboardCubit, TherapyDashboardStates>(
                builder: (context, state) {
                  if (state is TherapyDashboardInitialState) {
                    // Show the Therapy Section (Recommended & General Exercises)
                    return TherapySection(
                      selectedTherapyType: selectedTherapyType,
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    );
                  } else if (state is TherapyDashboardHistoryState) {
                    // Show the History Section
                    return HistorySection(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    );
                  } else if (state is TherapyDashboardProgressionState) {
                    // Show the Progression Section
                    return ProgressionSection(
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    );
                  } else {
                    return Container(); // Fallback for any undefined state
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
