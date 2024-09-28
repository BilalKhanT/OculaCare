import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../configs/presentation/constants/colors.dart';

class ProbabilityChart extends StatelessWidget {
  final double score;

  const ProbabilityChart({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    double finalScore = 0.0;
    Color severityColor = _getSeverityColor(score);
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    if (score < 0) {
    } else {
      finalScore = score;
    }
    return Column(
      children: [
        Container(
          height: screenHeight * 0.22,
          width: screenHeight * 0.22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.transparent,
            boxShadow:  [
              BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 0.5,
                blurRadius: 7,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: finalScore.toDouble(),
                  color: severityColor,
                  radius: screenHeight * 0.07,
                  title: '$finalScore',
                  titleStyle: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.04,
                    color: Colors.black,
                  ),
                ),
                PieChartSectionData(
                  value: (100.0 - finalScore),
                  color: Colors.grey.shade700,
                  radius: screenHeight * 0.06,
                  titleStyle: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.035,
                    color: Colors.white,
                  ),
                ),
              ],
              sectionsSpace: 5,
              centerSpaceRadius: 30,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(double score) {
    if (score >= 0.0 && score <= 30.0) {
      return Colors.red;
    } else if (score >= 40.0 && score <= 60.0) {
      return Colors.orange;
    } else if (score >= 70.0 && score <= 80.0) {
      return Colors.yellow;
    } else if (score >= 90.0 && score <= 100.0) {
      return Colors.green;
    } else {
      return Colors.grey.shade700;
    }
  }
}
