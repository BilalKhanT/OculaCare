import 'package:flutter/material.dart';
import 'package:OculaCare/presentation/therapy/widgets_therapy/general_eye_exercises.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/therapies_data/bulgy_eyes.dart';
import '../../../data/therapies_data/cataract_therapies.dart';
import '../../../data/therapies_data/crossed_eye_therapies.dart';
import '../../../data/therapies_data/pterygium_therapies.dart';
import '../../../data/therapies_data/therapies_list.dart';
import '../widgets_therapy/recommended_therapy_list.dart';

class TherapySection extends StatelessWidget {
  final String selectedTherapyType;
  final double screenHeight;
  final double screenWidth;

  TherapySection({
    required this.selectedTherapyType,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Therapies',
          style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.045,
              color: AppColors.appColor),
        ),
        SizedBox(height: screenHeight * 0.008),

        // Replace RecommendedTherapies with DiseaseCardList
        DiseaseCardList(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
        ),

        SizedBox(height: screenHeight * 0.02),

        Text(
          'General Eye Exercises',
          style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.045,
              color: AppColors.appColor),
        ),
        SizedBox(height: screenHeight * 0.008),
        GeneralEyeExercises(
          exercisesList: therapiesList,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
        ),
      ],
    );
  }

  // Method to get the recommended therapies based on selected therapy type
  List<Map<String, dynamic>> _getRecommendedList() {
    if (selectedTherapyType == "Cataracts") return therapiesCataract;
    if (selectedTherapyType == "Crossed Eyes") return crossedEyeTherapies;
    if (selectedTherapyType == "Pterygium") return pterygiumTherapies;
    return bulgyEyeTherapies;
  }
}
