import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

import '../../../configs/presentation/constants/colors.dart';

class ProgressCalendarScreen extends StatelessWidget {
  final Map<DateTime, int> data;
  const ProgressCalendarScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: HeatMapCalendar(
          colorsets: {
            1: Colors.blue[100]!,
          },
          datasets: data,
          colorMode: ColorMode.color,
          defaultColor: Colors.grey[200],
          initDate: DateTime.now(),
          size: height * 0.04,
          fontSize: width * 0.03,
          monthFontSize: width * 0.035,
          textColor: Colors.black,
          weekFontSize: width * 0.03,
          weekTextColor: AppColors.appColor,
          borderRadius: 50,
          flexible: false,
          margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
          onClick: (date) {},
          showColorTip: false,
        ),
      ),
    );
  }
}
