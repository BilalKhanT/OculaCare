import 'package:OculaCare/configs/extension/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../configs/presentation/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode focusNode;
  final TextInputType? textInputType;
  final bool editable;
  const CustomTextField(
      {super.key,
        required this.hintText,
        this.prefixIcon,
        this.suffixIcon,
        this.validator,
        this.textInputType,
        required this.focusNode,
        required this.obscureText,
        required this.controller,
        required this.editable});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: TextFormField(
          readOnly: !editable,
          controller: controller,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return "Please enter a message";
            }
            return null;
          },
          focusNode: focusNode,
          cursorColor: AppColors.appColor,
          style: context.appTheme.textTheme.labelMedium?.copyWith(
              color: AppColors.secondaryText,
              fontSize: MediaQuery.sizeOf(context).width * 0.04),
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintStyle: context.appTheme.textTheme.labelMedium?.copyWith(
                color: context.appTheme.focusColor,
                fontSize: MediaQuery.sizeOf(context).width * 0.04),
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * 0.015,
              left: 20.w,
              bottom: MediaQuery.sizeOf(context).height * 0.015,
            ),
          ),
        ),
      ),
    );
  }
}