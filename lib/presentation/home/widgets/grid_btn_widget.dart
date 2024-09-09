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
        required this.constraints});

  final Function onTap;
  final String iconData;
  final String title;
  final String subtitle;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: constraints.maxHeight * 0.9,
        width: constraints.maxWidth * 0.35,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4C000000),
              blurRadius: 2,
              offset: Offset(0, 1.33),
              spreadRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconData,
              height: 20,
              width: 30,
              // ignore: deprecated_member_use
              color: AppColors.appColor,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(
              height: 7,
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontFamily: 'MontserratMedium',
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'MontserratBold',
                color: Colors.black,
                fontSize: 10,
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