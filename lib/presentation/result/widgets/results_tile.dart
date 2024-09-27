
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../data/models/disease_result/disease_result_model.dart';

class DiseaseResultTile extends StatelessWidget {
  final DiseaseResultModel result;

  const DiseaseResultTile({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.push(RouteNames.diseaseAnalysisRoute, extra: result);
            },
            icon: Icons.info_outline,
            backgroundColor: AppColors.appColor,
          ),
        ],
      ),
      child: Builder(
        builder: (context) => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.patientName}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.04,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.004),
                        Text(
                          'Date: ${result.date}',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.032,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Slidable.of(context)?.openEndActionPane();
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: AppColors.appColor,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 0.75,
                  height: 15,
                  color: AppColors.appColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Left Eye:',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.002),
                        Text(
                          result.leftEye?.prediction ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.033,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      result.leftEye?.probability ?? '',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.008),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Right Eye:',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.002),
                        Text(
                          result.rightEye?.prediction ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.033,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      result.rightEye?.probability ?? '',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w600,
                        fontSize: screenWidth * 0.032,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
