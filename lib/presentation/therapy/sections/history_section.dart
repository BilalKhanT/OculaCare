import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../configs/presentation/constants/colors.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_cubit.dart';
import 'package:OculaCare/logic/therapy_cubit/therapy_state.dart';
import 'package:OculaCare/data/models/therapy/therapy_results_model.dart';
import '../widgets_therapy/history_args_model.dart';
import '../widgets_therapy/therapy_history_tiles.dart';

class HistorySection extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final String patientName;

  const HistorySection({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
    required this.patientName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TherapyCubit>(context)
        .loadTherapyHistory(sharedPrefs.email);

    return BlocBuilder<TherapyCubit, TherapyState>(
      builder: (context, state) {
        if (state is TherapyLoading) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.35,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 3.0),
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60.0,
                                height: 60.0,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 12.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Container(
                                      width: double.infinity,
                                      height: 12.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Container(
                                      width: 100.0,
                                      height: 12.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (state is TherapyHistoryError) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(
                color: AppColors.appColor,
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
            ),
          );
        } else if (state is TherapyHistoryLoaded) {
          final generalTherapies = state.therapyHistory
              .where((therapy) => therapy.therapyType == "General")
              .toList();
          final diseaseTherapies = state.therapyHistory
              .where((therapy) => therapy.therapyType != "General")
              .toList();

          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (generalTherapies.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'General Exercises',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        color: AppColors.appColor,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: _buildTherapyList(
                        generalTherapies, screenHeight, screenWidth),
                  ),
                ],
                if (generalTherapies.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'General Exercises',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        color: AppColors.appColor,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: Text(
                      'No General Therapies',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
                if (diseaseTherapies.isNotEmpty) ...[
                  SizedBox(height: screenHeight * 0.04),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      'Disease-Specific Therapies',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        color: AppColors.appColor,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  SizedBox(
                    height: screenHeight * 0.3,
                    child: _buildTherapyList(
                        diseaseTherapies, screenHeight, screenWidth),
                  ),
                ],
                if (diseaseTherapies.isEmpty) ...[
                  SizedBox(height: screenHeight * 0.2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      height: screenHeight * 0.4,
                      child: Text(
                        'Disease-Specific Therapies',
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.045,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Center(
                    child: Text(
                      'No Diseases-Specific Therapies',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildTherapyList(
      List<TherapyModel> therapies, double screenHeight, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: therapies.length,
        itemBuilder: (context, index) {
          final TherapyModel therapy = therapies[index];
          final HistoryArgsModel assetData =
              getTherapyAsset(therapy.therapyName);
          return TherapyHistoryTile(
            title: therapy.therapyName,
            date: therapy.date,
            type: therapy.therapyType,
            duration: therapy.duration,
            image: assetData.imagePath,
            avatarColor: assetData.avatarColor,
          );
        },
      ),
    );
  }
}
