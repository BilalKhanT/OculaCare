import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/disease_result/medicine_model.dart';

class DurationCalendar extends StatelessWidget {
  final MedicineModel medicine;
  const DurationCalendar({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final DateTime now = DateTime.now();
    final DateTime endDate = _calculateEndDate(now, medicine.duration);
    final Map<DateTime, int> dateData = _generateDateRange(now, endDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.appColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 0.5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: HeatMapCalendar(
          colorsets: {
            1: Colors.blue[100]!,
          },
          datasets: dateData,
          colorMode: ColorMode.color,
          defaultColor: Colors.grey[200],
          initDate: now,
          size: height * 0.035,
          fontSize: width * 0.03,
          monthFontSize: width * 0.035,
          textColor: Colors.black,
          weekFontSize: width * 0.03,
          weekTextColor: Colors.blue,
          borderRadius: 50,
          flexible: false,
          margin: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.0),
          onClick: (date) {},
          showColorTip: false,
        ),
      ),
    );
  }

  DateTime _calculateEndDate(DateTime startDate, int durationInWeeks) {
    return startDate.add(Duration(days: durationInWeeks * 7));
  }

  Map<DateTime, int> _generateDateRange(DateTime startDate, DateTime endDate) {
    Map<DateTime, int> data = {};
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
      DateTime dateWithoutTime = DateTime(currentDate.year, currentDate.month, currentDate.day);
      data[dateWithoutTime] = 1;
      currentDate = currentDate.add(const Duration(days: 1));
    };
    return data;
  }
}
