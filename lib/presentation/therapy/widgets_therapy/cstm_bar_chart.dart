import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../configs/app/app_globals.dart';
import '../../../configs/presentation/constants/colors.dart';

class TherapyBarChart extends StatelessWidget {
  const TherapyBarChart({super.key});

  Map<String, String> get categoryAbbreviations => {
        'Crossed Eyes': 'Cr',
        'General': 'Ge',
        'Pterygiuym': 'Pt',
        'Cataracts': 'Ca',
        'Bulgy Eyes': 'Bu',
      };

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Therapy Categories',
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(context),
                      swapAnimationDuration: const Duration(milliseconds: 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData(BuildContext context) {
    return BarChartData(
      barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
              tooltipPadding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              tooltipMargin: 0,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final category =
                    categoryDateTherapyCount.keys.toList()[group.x];
                int totalTherapies = categoryDateTherapyCount[category]
                        ?.values
                        .fold<int?>(
                            0, (int? sum, int count) => (sum ?? 0) + count) ??
                    0;

                return BarTooltipItem(
                  '$category\n',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '$totalTherapies Therapies',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              })),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: AppColors.appColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              if (value.toInt() < 0 || value.toInt() >= categoryAbbreviations.length) {
                return const SizedBox.shrink(); // Return an empty widget for invalid values
              }
              String category = categoryAbbreviations.keys.toList()[value.toInt()];
              String abbreviation = categoryAbbreviations[category] ?? category;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 16,
                child: Text(
                  abbreviation,
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      barGroups: showingGroups(),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
    );
  }

  List<BarChartGroupData> showingGroups() {
    return List.generate(categoryAbbreviations.length, (index) {
      String category = categoryAbbreviations.keys.toList()[index];
      int therapyCount = categoryDateTherapyCount[category]
          ?.values
          .fold<int?>(0, (int? sum, int count) => (sum ?? 0) + count) ??
          0;

      return makeGroupData(index, therapyCount.toDouble());
    });
  }


  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        double width = 22,
        Color barColor = AppColors.appColor,  // Blue bar for actual data
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y > 0 ? y : 0.5,  // Show a minimal bar for zero values
          color: y > 0 ? barColor : Colors.transparent,  // Transparent for zero counts
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,  // This is the height for the background bar
            color: AppColors.appColor.withOpacity(0.3),  // Background bar with low opacity
          ),
        ),
      ],
    );
  }
}
