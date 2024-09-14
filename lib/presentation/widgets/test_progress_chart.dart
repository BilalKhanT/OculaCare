import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressChartScreen extends StatelessWidget {
  final Map<DateTime, double> testScores;

  const ProgressChartScreen({super.key, required this.testScores});

  LineChartData generateLineChartData(
      List<MapEntry<DateTime, double>> sortedEntries) {
    List<FlSpot> spots = sortedEntries.asMap().entries.map((entry) {
      int index = entry.key;
      double score = entry.value.value;
      return FlSpot(index.toDouble(), score);
    }).toList();

    return LineChartData(
      backgroundColor: const Color(0xFF1B233E),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xFF2E3251),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xFF2E3251),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 10,
                  fontFamily: 'MontserratMedium',
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < sortedEntries.length) {
                DateTime date = sortedEntries[index].key;
                return Text(
                  DateFormat('MMM d').format(date),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 10,
                    fontFamily: 'MontserratMedium',
                  ),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color(0xFF2E3251),
          width: 1,
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.lightBlueAccent,
          barWidth: 3,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1D76E3).withOpacity(0.4),
                const Color(0xFF1B233E).withOpacity(0.1)
              ], // Gradient effect
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: const FlDotData(
            show: false,
          ),
          aboveBarData: BarAreaData(show: false),
          preventCurveOverShooting: true,
        ),
      ],
      minX: 0,
      maxX: sortedEntries.length.toDouble() - 1,
      minY:
          sortedEntries.map((e) => e.value).reduce((a, b) => a < b ? a : b) - 5,
      maxY:
          sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b) + 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    if (testScores.isEmpty || testScores.length == 1) {
      return Center(
        child: Text(
          'Not enough data to plot graph',
          style: TextStyle(
              fontFamily: 'MontserratMedium',
              fontSize: screenWidth * 0.035,
              color: Colors.red),
        ),
      );
    } else {
      final sortedEntries = testScores.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      final entriesToPlot = sortedEntries.length > 5
          ? sortedEntries.sublist(sortedEntries.length - 5)
          : sortedEntries;

      return SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: LineChart(generateLineChartData(entriesToPlot)),
        ),
      );
    }
  }
}
