import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/tests/test_progression_cubit.dart';
import '../../../logic/tests/test_progression_state.dart';
import '../../widgets/test_progress_chart.dart';

class TestGraphProgress extends StatelessWidget {
  const TestGraphProgress({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return BlocBuilder<TestProgressionCubit, TestProgressionState>(
      builder: (context, state) {
        Map<DateTime, double> score = {};
        if (state is TestProgressionToggled) {
          score = state.scores;
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.read<TestProgressionCubit>().selectedTest,
                  style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.045,
                      color: AppColors.appColor),
                ),
                Container(
                  height: screenHeight * 0.05,
                  width: screenWidth * 0.4,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(10.0),
                      dropdownColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      value: context.read<TestProgressionCubit>().selectedTest,
                      icon: const Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.black,
                      ),
                      iconSize: screenWidth * 0.05,
                      elevation: 10,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 0,
                        color: AppColors.appColor,
                      ),
                      onChanged: (String? newValue) {
                        context
                            .read<TestProgressionCubit>()
                            .toggleProgression(newValue!);
                      },
                      items: <String>[
                        'Snellan Chart',
                        'Animal Track',
                        'Contrast Test',
                        'Isihara Plates',
                        'Match Color',
                        'Odd One Out',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.032,
                              letterSpacing: 1,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            ProgressChartScreen(
              test: context.read<TestProgressionCubit>().selectedTest,
              testScores: score,
            )
          ],
        );
      },
    );
  }
}
