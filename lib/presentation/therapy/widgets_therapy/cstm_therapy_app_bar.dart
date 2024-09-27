import 'package:flutter/material.dart';

import '../../../configs/presentation/constants/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      backgroundColor: AppColors.backgroundTherapy,
      elevation: 0,
      leading: IconButton(
        icon:
            const Icon(Icons.arrow_back_ios_new, color: AppColors.textTherapy),
        onPressed: onBackPressed,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'MontserratMedium',
          fontWeight: FontWeight.w800,
          fontSize: screenWidth * 0.05,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }
}
