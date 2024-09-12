import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ProgressCalendarScreen extends StatelessWidget {
  final Map<DateTime, int> data;
  const ProgressCalendarScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
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
          size: 30,
          fontSize: 12,
          monthFontSize: 14,
          textColor: Colors.black,
          weekFontSize: 12,
          weekTextColor: AppColors.appColor,
          borderRadius: 50,
          flexible: false,
          margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
          onClick: (date) {
            print('Selected Date: $date');
          },
          showColorTip: false,
        ),
      ),
    );
  }
}
