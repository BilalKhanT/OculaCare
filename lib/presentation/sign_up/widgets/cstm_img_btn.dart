import 'package:flutter/material.dart';

class CustomImageButton extends StatelessWidget {
  final VoidCallback onTap;
  final String imagePath;

  const CustomImageButton({
    Key? key,
    required this.onTap,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(1, 3),
              blurRadius: 20,
              color: const Color(0xFFD3D3D3).withOpacity(.99),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 45,
            width: 45,
          ),
        ),
      ),
    );
  }
}
