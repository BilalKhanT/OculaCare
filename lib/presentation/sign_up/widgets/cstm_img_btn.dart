import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;
  final String text;

  const CustomImageButton({
    Key? key,
    required this.onTap,
    required this.imagePath, required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.appColor, width: 2),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Image.asset(
                imagePath,
                height: screenWidth * 0.07,
                width: screenWidth * 0.07,
              ),
              SizedBox(width: screenWidth * 0.03,),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'MontserratMedium',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
