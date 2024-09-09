import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../widgets_therapy/therapy_model.dart';

class TherapyCard extends StatelessWidget {
  final Map<String, dynamic> therapy;
  final double screenHeight;
  final double screenWidth;

  TherapyCard({
    required this.therapy,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (BuildContext context) {
              return TherapyModel(therapy: therapy);
            },
          );
        },
        child: Container(
          width: screenWidth * 0.5,
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
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.asset(
                      therapy['svgPath'],
                      fit: BoxFit.contain,
                      width: screenWidth * 0.25,
                      height: screenHeight * 0.12,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    therapy['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Text(
                    "${therapy['timeLimit']} min",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
