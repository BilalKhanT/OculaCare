import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../presentation/constants/colors.dart';

abstract class AppUtils {
  static showToast(
      BuildContext context, String title, String description, bool isError) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 3),
      title: title,
      description: description,
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: isError
          ? const Icon(
              Icons.info_outline,
              color: Colors.red,
              size: 30,
            )
          : const Icon(
              Icons.info_outline,
              color: AppColors.appColor,
              size: 30,
            ),
      primaryColor: AppColors.appColor,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.transparent,
          blurRadius: 0,
          offset: Offset(0, 0),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
          color: isError ? Colors.red : AppColors.appColor),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
