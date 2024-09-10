import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_state.dart';

class HistorySection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String patientName;

  const HistorySection({super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TherapyCubit>(context).loadTherapyHistory(patientName);
    return BlocBuilder<TherapyCubit, TherapyState>(
      builder: (context, state) {
        if (state is TherapyLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TherapyHistoryLoaded) {
          if (state.therapyHistory.isEmpty) {
            return Center(
              child: Text(
                'No history available',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: screenWidth * 0.045,
                ),
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Therapy History',
                  style: TextStyle(
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.045,
                    color: AppColors.appColor,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.therapyHistory.length,
                  itemBuilder: (context, index) {
                    final therapy = state.therapyHistory[index];

                    return Card(
                      color: AppColors.whiteColor,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3, // Subtle shadow for card
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Date Row
                            Text(
                              therapy['therapy_name'] ?? 'N/A',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.05, // Larger font for title
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            // Date with Calendar Icon
                            Row(
                              children: [
                                Text(
                                  therapy['date'] ?? 'N/A',
                                  style: TextStyle(
                                    fontFamily: 'MontserratMedium',
                                    fontWeight: FontWeight.w500,
                                    fontSize: screenWidth * 0.035,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Icon(
                                  Icons.calendar_today,
                                  size: screenWidth * 0.05,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),

                            // Therapy Type
                            Text(
                              'Type: ${therapy['therapy_type'] ?? 'N/A'}',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth * 0.04,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            // Duration in pill-shaped container
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                              decoration: BoxDecoration(
                                color: AppColors.appColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Duration: ${therapy['duration'] ?? 'N/A'} min',
                                style: TextStyle(
                                  fontFamily: 'MontserratMedium',
                                  fontWeight: FontWeight.w500,
                                  fontSize: screenWidth * 0.035,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        } else {
          return Center(
            child: Text(
              'Failed to load history',
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.045,
              ),
            ),
          );
        }
      },
    );
  }
}
