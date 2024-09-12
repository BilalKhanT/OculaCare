import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class TherapyTile extends StatelessWidget {
  final Map<String, dynamic> therapy;
  final double screenHeight;
  final VoidCallback onTap;

  const TherapyTile({super.key,
    required this.therapy,
    required this.screenHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: screenHeight * 0.14,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  therapy['svgPath'],
                  width: screenHeight * 0.1,
                  height: screenHeight * 0.1,
                  fit: BoxFit.scaleDown,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      therapy['title'],
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.038,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      therapy['description'],
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w900,
                        fontSize: screenWidth * 0.032,
                        color: AppColors.appColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.092,),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.appColor,
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        "${therapy['timeLimit']} min",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.03,
                            color: AppColors.whiteColor
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
