import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSearchBar extends StatelessWidget {
  final Function()? onTap;
  final String hintText;

  const CustomSearchBar({
    Key? key,
    this.onTap,
    this.hintText = 'Search for hospital',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: screenWidth * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(80.0),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.tune,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: TextStyle(
                          fontFamily: 'MontserratMedium',
                          color: Colors.grey.shade400,
                          fontSize: screenWidth * 0.04,
                        ),
                        hintText: hintText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                          top: screenHeight * 0.015,
                          left: 20.0,
                          bottom: screenHeight * 0.015,
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w800,
                        color: Colors.black, // Replace with AppColors.appColor if defined
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      'assets/svgs/charm_search.svg',
                      color: Colors.grey, // Replace with AppColors.textSecondary if defined
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
