import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/app/app_globals.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/therapy_cubit/therapy_cubit.dart';
import '../../../logic/therapy_cubit/therapy_state.dart';
import '../../test_dashboard/widgets/test_progress_heatmap.dart';
import '../widgets_therapy/cstm_bar_chart.dart';

class ProgressionSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String patientName;

  const ProgressionSection({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    context.read<TherapyCubit>().mapTherapies(patientName);

    return BlocBuilder<TherapyCubit, TherapyState>(
      builder: (context, state) {
        Widget content;
        if (state is TherapyLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state is TherapyProgressionLoaded) {
          content = Column(
            children: [
              ProgressCalendarScreen(
                data: globalTherapyProgressData,
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0, vertical: 10.0),
                child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const TherapyBarChart()),
              ),
            ],
          );
        } else if (state is TherapyProgressError) {
          content = Center(
            child: Text(
              state.therapyProgressErr,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          content = const Center(child: Text('No Data Available'));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Therapy Progress',
                style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                  color: AppColors.appColor,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: content,
              ),
            ],
          ),
        );
      },
    );
  }
}
