import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class AppUtils {
  static showToast(
      BuildContext context, String title, String description, bool isError) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 6),
      title: title,  // Pass the title as String
      description: description,  // Pass the description as String
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: isError
          ? const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
        size: 30,
      )
          : const Icon(
        Icons.check,
        color: AppColors.appColor,
        size: 30,
      ),
      primaryColor: AppColors.appColor,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.appColor,
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
          color: isError ? Colors.red : Colors.green),
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
    );
  }
}
