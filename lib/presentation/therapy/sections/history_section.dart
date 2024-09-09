import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class HistorySection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  HistorySection({
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Therapy History',
          style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontWeight: FontWeight.w800,
              fontSize: screenWidth * 0.045,
              color: AppColors.appColor),
        ),
        SizedBox(height: screenHeight * 0.008),
        Center(
          child: Text(
            'No history available',
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
