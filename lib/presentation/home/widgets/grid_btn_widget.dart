import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GridButtonWidget extends StatelessWidget {
  const GridButtonWidget(
      {super.key,
      required this.onTap,
      required this.iconData,
      required this.title,
      required this.subtitle,
      required this.constraints,
      required this.color,
      required this.colorSecondary});

  final Function onTap;
  final String iconData;
  final String title;
  final String subtitle;
  final Color color;
  final Color colorSecondary;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: screenHeight * 0.3,
        width: constraints.maxWidth * 0.25,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: colorSecondary),
              child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: SvgPicture.asset(
                  iconData,
                  height: screenHeight * 0.04,
                  width: screenHeight * 0.04,
                  // ignore: deprecated_member_use
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.032,
                fontFamily: 'MontserratMedium',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'MontserratBold',
                color: Colors.white,
                fontSize: screenWidth * 0.027,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
