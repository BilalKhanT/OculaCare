import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class ProgressionSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  ProgressionSection({
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Therapy Progression',
          style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.045,
              color: AppColors.appColor),
        ),
        SizedBox(height: screenHeight * 0.008),
        Center(
          child: Text(
            'Track your progress here',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: screenWidth * 0.045,
            ),
          ),
        ),
      ],
    );
  }
}
