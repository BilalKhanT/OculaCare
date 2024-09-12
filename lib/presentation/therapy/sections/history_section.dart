import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_state.dart';
import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';
import '../../widgets/cstm_loader.dart';
import '../widgets_therapy/therapy_history_tiles.dart';

class HistorySection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String patientName;

  const HistorySection({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.patientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TherapyCubit>(context).loadTherapyHistory(patientName);

    return BlocBuilder<TherapyCubit, TherapyState>(
      builder: (context, state) {
        if (state is TherapyLoading) {
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
        } else if (state is TherapyHistoryLoaded) {
          if (state.therapyHistory.isEmpty) {
            return Center(
              child: Text(
                'No history available',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            );
          } else {
            final generalTherapies = state.therapyHistory
                .where((therapy) => therapy.therapyType == "General")
                .toList();
            final diseaseTherapies = state.therapyHistory
                .where((therapy) => therapy.therapyType != "General")
                .toList();

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (generalTherapies.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'General Exercises',
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.045,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTherapyList(generalTherapies, screenHeight, screenWidth),
                  ],
                  // Disease-Specific Section
                  if (diseaseTherapies.isNotEmpty) ...[
                    SizedBox(height: screenHeight * 0.04),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Disease-Specific Therapies',
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.045,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    _buildTherapyList(diseaseTherapies, screenHeight, screenWidth),
                  ],
                ],
              ),
            );
          }
        } else {
          return Scaffold(
            backgroundColor: AppColors.screenBackground,
            body: Center(
              child: Text(
                'No therapies taken yet',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Helper method to build therapy list
  Widget _buildTherapyList(List<TherapyModel> therapies, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: therapies.length,
        itemBuilder: (context, index) {
          final TherapyModel therapy = therapies[index];

          return TherapyHistoryTile(
            title: therapy.therapyName,
            date: therapy.date,
            type: therapy.therapyType,
            duration: therapy.duration,
            image: 'assets/images/logo_ocula.png',
            avatarColor: AppColors.screenBackground,
          );
        },
      ),
    );
  }

}
