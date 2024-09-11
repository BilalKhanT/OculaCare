import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/therapy_cubit/therapy_schedule_cubit.dart';
import '../../../logic/therapy_cubit/therapy_schedule_state.dart';
import '../../widgets/btn_flat.dart';

class TherapyModel extends StatelessWidget {
  final Map<String, dynamic> therapy;
  const TherapyModel({super.key, required this.therapy});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (_) => TherapyScheduleCubit(),
      child: Builder(builder: (context) {
        return BlocConsumer<TherapyScheduleCubit, TherapyScheduleState>(
          listener: (context, state) {
            if (state is TherapyScheduledSuccessfully) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'Therapy "${state.therapyName}" scheduled successfully for ${state.scheduledTime}.'),
                backgroundColor: Colors.green,
              ));
            }
          },
          builder: (context, state) {
            return Container(
              height: screenHeight * 0.65,
              width: screenWidth,
              decoration: const BoxDecoration(
                color: AppColors.screenBackground,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
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
                      height: screenHeight * 0.2,
                      width: screenWidth * 0.5,
                      child: Image.asset(
                        therapy['svgPath'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Therapy title
                    Text(
                      therapy['title'],
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.05,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Therapy benefits
                    therapy.containsKey('benefits')
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: therapy['benefits']
                            .map<Widget>(
                              (benefit) => Text(
                            "• $benefit",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        )
                            .toList(),
                      ),
                    )
                        : const SizedBox.shrink(),
                    SizedBox(height: screenHeight * 0.03),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ButtonFlat(
                            btnColor: AppColors.appColor,
                            textColor: AppColors.whiteColor,
                            onPress: () {
                              Navigator.pop(context);
                              context.push(
                                RouteNames.therapy,
                                extra: therapy,
                              );
                            },
                            text: "Play Therapy",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: ButtonFlat(
                            btnColor: Colors.black,
                            textColor: AppColors.whiteColor,
                            onPress: () async {
                              DateTime? selectedDateTime =
                              await _selectDateTime(context);
                              if (selectedDateTime != null) {
                                context
                                    .read<TherapyScheduleCubit>()
                                    .scheduleTherapy(
                                  therapy['title'],
                                  selectedDateTime,
                                );
                              }
                            },
                            text: "Schedule Therapy",
                          ),
                        ),
                        if (state is TherapyScheduledSuccessfully)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              'Therapy "${state.therapyName}" scheduled for ${state.scheduledTime}',
                              style: TextStyle(
                                color: Colors.green,
                                fontFamily: 'MontserratMedium',
                                fontSize: screenWidth * 0.04,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );

    if (date == null) return null;

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}
