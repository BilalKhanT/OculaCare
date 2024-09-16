import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

Widget customWidget({
  required String title,
  required Widget icon,
  required String text,
  required double screenWidth,
  required VoidCallback onTap,
  required double screenHeight,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: screenHeight * 0.06,
                  width: screenHeight * 0.06,
                  decoration: BoxDecoration(
                    color: AppColors.appColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: icon,
                  ),
                ),
                const SizedBox(width: 15.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.035,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                        fontSize: screenWidth * 0.032,
                        color: AppColors.appColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
