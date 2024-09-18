import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../configs/presentation/constants/colors.dart';

class ForgotPasswordBtn extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const ForgotPasswordBtn({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: onTap,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'MontserratMedium',
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.appColor,
          ),
        ),
      ),
    );;
  }
}
