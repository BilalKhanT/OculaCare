import 'package:flutter/material.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/general_eye_exercises.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/therapies_data/therapies_list.dart';
import '../widgets_therapy/recommended_therapy_list.dart';

class TherapySection extends StatelessWidget {
  final String selectedTherapyType;
  final double screenHeight;
  final double screenWidth;

  const TherapySection({super.key,
    required this.selectedTherapyType,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'Recommended Therapies',
              style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                  color: AppColors.appColor),
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          DiseaseCardList(
            screenHeight: screenHeight,
            screenWidth: screenWidth,
          ),

          SizedBox(height: screenHeight * 0.02),

          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'General Eye Exercises',
              style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                  color: AppColors.appColor),
            ),
          ),
          SizedBox(height: screenHeight * 0.008),
          GeneralEyeExercises(
            exercisesList: therapiesList,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
        ],
      ),
    );
  }
}
