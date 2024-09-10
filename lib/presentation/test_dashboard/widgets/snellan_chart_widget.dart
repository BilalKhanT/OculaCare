import 'package:flutter/material.dart';

class SnellenChartWidget extends StatelessWidget {
  final int snellenValue;

  const SnellenChartWidget({super.key, required this.snellenValue});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    String snellenFraction = _getSnellenFraction(snellenValue);
    double barHeight = _calculateBarHeight(snellenValue, screenHeight);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Snellen Chart Result: $snellenFraction',
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: screenWidth * 0.8,
          height: screenHeight * 0.4,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildChartBars(screenWidth, snellenFraction, barHeight),
          ),
        ),
      ],
    );
  }

  String _getSnellenFraction(int value) {
    switch (value) {
      case 60:
        return '6/60';
      case 36:
        return '6/36';
      case 24:
        return '6/24';
      case 18:
        return '6/18';
      case 12:
        return '6/12';
      case 9:
        return '6/9';
      case 6:
        return '6/6';
      default:
        return 'Unknown';
    }
  }

  double _calculateBarHeight(int value, double maxHeight) {
    double normalizedValue = (60 - value) / 54.0;
    return maxHeight * 0.2 + (normalizedValue * maxHeight * 0.4);
  }

  List<Widget> _buildChartBars(
      double screenWidth, String snellenFraction, double barHeight) {
    List<Map<String, String>> snellenValues = [
      {'value': '6/60', 'label': '6/60'},
      {'value': '6/36', 'label': '6/36'},
      {'value': '6/24', 'label': '6/24'},
      {'value': '6/18', 'label': '6/18'},
      {'value': '6/12', 'label': '6/12'},
      {'value': '6/9', 'label': '6/9'},
      {'value': '6/6', 'label': '6/6'},
    ];

    return snellenValues.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(
              entry['label']!,
              style: TextStyle(
                  fontSize: screenWidth * 0.04, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: entry['label'] == snellenFraction ? barHeight : 20.0,
                color: entry['label'] == snellenFraction
                    ? Colors.blue
                    : Colors.grey.shade300,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
