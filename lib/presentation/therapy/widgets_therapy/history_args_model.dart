import 'package:flutter/material.dart';

import '../../../configs/presentation/constants/colors.dart';

class HistoryArgsModel {
  final String imagePath;
  final Color avatarColor;

  HistoryArgsModel({required this.imagePath, required this.avatarColor});
}

HistoryArgsModel getTherapyAsset(String therapyName) {
  if (therapyName == 'Crossed Eyes') {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
        );
  } else if (therapyName == 'General') {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
    );
  } else if (therapyName == 'Pterygiuym') {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
    );
  } else if (therapyName == 'Cataracts') {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
    );
  } else if (therapyName == 'Bulgy Eyes') {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
    );
  } else {
    return HistoryArgsModel(
        imagePath: 'assets/images/general_eye_exercise.png',
        avatarColor: AppColors.screenBackground,
    );
  }
}
