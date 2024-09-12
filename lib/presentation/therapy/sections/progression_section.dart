import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../test_dashboard/widgets/test_progress_heatmap.dart';

class ProgressionSection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;

  const ProgressionSection({super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Text(
            'Tests Progress',
            style: TextStyle(
                fontFamily: 'MontserratMedium',
                fontWeight: FontWeight.w800,
                fontSize: screenWidth * 0.045,
                color: AppColors.appColor),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          // Center(
          //     child: ProgressCalendarScreen(
          //         data: state.progressData)),
          SizedBox(
            height: screenHeight * 0.035,
          ),
        ],
      ),
    );
  }
}
