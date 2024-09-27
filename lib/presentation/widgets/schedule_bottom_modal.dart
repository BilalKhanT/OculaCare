import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/utils/utils.dart';
import '../../logic/tests/test_schedule_cubit.dart';
import 'btn_flat.dart';

class ScheduleBottomModal extends StatelessWidget {
  final TextEditingController controller;
  final String test;
  const ScheduleBottomModal(
      {super.key, required this.controller, required this.test});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Container(
        height: screenHeight * 0.4,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: AppColors.screenBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      context.read<ScheduleCubit>().clearController();
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.cancel_rounded,
                      color: Colors.redAccent,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Schedule Time',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: TextFormField(
                    readOnly: true,
                    controller: controller,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return "Please enter a message";
                      }
                      return null;
                    },
                    cursorColor: AppColors.appColor,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontserratMedium',
                        fontSize: MediaQuery.sizeOf(context).width * 0.04),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontFamily: 'MontserratMedium',
                          fontSize: MediaQuery.sizeOf(context).width * 0.04),
                      hintText: 'Pick date and time',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        top: MediaQuery.sizeOf(context).height * 0.015,
                        left: 20.0,
                        bottom: MediaQuery.sizeOf(context).height * 0.015,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        DateTime? time = await _selectDateTime(context);
                        if (context.mounted && time != null) {
                          context.read<ScheduleCubit>().time = time;
                          controller.text = time.toString();
                        }
                      },
                      child: Text(
                        'Select',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.04,
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              BlocBuilder<ScheduleCubit, ScheduleState>(
                builder: (context, state) {
                  if (state is ScheduleLoading) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
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
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ButtonFlat(
                    btnColor: AppColors.appColor,
                    textColor: Colors.white,
                    onPress: () async {
                      if (controller.text.trim() == '') {
                        AppUtils.showToast(context, 'Error',
                            'Please select date and time', true);
                        return;
                      }
                      try {
                        DateTime scheduledTime =
                            DateTime.parse(controller.text.trim());
                        await context.read<ScheduleCubit>().scheduleTest(test);
                        if (context.mounted) {
                          DateTime now = DateTime.now();
                          if (scheduledTime.isBefore(now)) {
                            AppUtils.showToast(
                                context,
                                "Error",
                                "Test not scheduled. Please choose a valid future time.",
                                true);
                          } else {
                            AppUtils.showToast(
                                context,
                                "Test Scheduled",
                                "Your test has been successfully scheduled",
                                false);
                          }
                          context.pop();
                        }
                      } catch (e) {
                        if (context.mounted) {
                          AppUtils.showToast(
                              context,
                              "Error",
                              "Invalid date format. Please enter a valid date and time.",
                              true);
                        }
                      }
                    },
                    text: 'Confirm',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.appColor,
              ),
            ),
            dialogBackgroundColor: AppColors.whiteColor,
          ),
          child: child!,
        );
      },
    );

    if (date == null) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context.mounted == true ? context : context,
      initialTime: TimeOfDay.fromDateTime(now),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.appColor,
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.appColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
