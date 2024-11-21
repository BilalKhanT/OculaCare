import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

Widget customDetectionBtnWidget({
  required String title,
  required Widget icon,
  required String text,
  required double screenWidth,
  required VoidCallback onTap,
  required double screenHeight,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: AppColors.textPrimary.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 0.5,
          offset: const Offset(0, 0),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 13.0, top: 8.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'MontserratBold',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.04,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w900,
                  fontSize: screenWidth * 0.032,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
                    child: Text(
                      'Start Diagnosis',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w900,
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Image.asset('assets/images/eye_diagnosis.png',
          height: screenHeight * 0.17, width: screenHeight * 0.21,)
        ],
      ),
    ),
  );
}
