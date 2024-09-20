import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProbabilityChart extends StatelessWidget {
  final double score;

  const ProbabilityChart({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    double finalScore = 0.0;
    Color severityColor = _getSeverityColor(score);
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (score < 0) {
    } else {
      finalScore = score;
    }
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  value: finalScore.toDouble(),
                  color: severityColor,
                  radius: 40,
                  title: '$finalScore',
                  titleStyle: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.04,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  value: (100.0 - finalScore),
                  color: Colors.grey.shade700,
                  radius: 30,
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
