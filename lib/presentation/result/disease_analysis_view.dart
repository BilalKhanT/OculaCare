import 'package:OculaCare/data/models/disease_result/disease_result_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';

class DiseaseAnalysisView extends StatelessWidget {
  final DiseaseResultModel result;
  const DiseaseAnalysisView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
        title: Text(
          'Disease Analysis',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
    );
  }
}
