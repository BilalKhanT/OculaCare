import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

abstract class AppUtils {

  static showToast(
      BuildContext context, String title, String description, bool isError) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 3),
      title: Text(title),
      description: Text(description),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      icon: Icon(Icons.check, color: isError ? Colors.red : Colors.green),
      primaryColor: Colors.green,
      backgroundColor: Colors.white,
      foregroundColor: Colors.green,
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