import 'package:flutter/material.dart';

import '../../configs/presentation/constants/colors.dart';

class ButtonFlat extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final String text;
  final Function() onPress;
  const ButtonFlat(
      {super.key,
      required this.btnColor,
      required this.textColor,
      required this.onPress,
      required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(9.0),
            boxShadow: [
              BoxShadow(
                color: btnColor.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.043,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
