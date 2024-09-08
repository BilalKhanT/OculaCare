import 'package:flutter/material.dart';

class ButtonFlat extends StatelessWidget {
  final Color btnColor;
  final Color textColor;
  final String text;
  final Function() onPress;
  const ButtonFlat({super.key, required this.btnColor, required this.textColor, required this.onPress, required this.text});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(text,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
                color: textColor,
              ),),
            ),
          ),
        ),
      ),
    );
  }
}
