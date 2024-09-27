import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SeverityChart extends StatelessWidget {
  final int score;

  const SeverityChart({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    int finalScore = 0;
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
                  value: (10 - finalScore).toDouble(),
                  color: Colors.grey.shade800,
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

  Color _getSeverityColor(int score) {
    if (score >= 0 && score <= 3) {
      return Colors.red;
    } else if (score >= 4 && score <= 6) {
      return Colors.orange;
    } else if (score >= 7 && score <= 8) {
      return Colors.yellow;
    } else if (score >= 9 && score <= 10) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }
}
