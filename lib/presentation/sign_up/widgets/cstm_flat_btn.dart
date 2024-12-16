import 'package:cculacare/configs/global/app_globals.dart';
import 'package:flutter/material.dart';

class CustomFlatButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color btnColor;

  const CustomFlatButton({
    Key? key,
    required this.onTap,
    required this.text,
    required this.btnColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'MontserratMedium',
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
