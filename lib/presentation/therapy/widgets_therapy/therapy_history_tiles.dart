import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class TherapyHistoryTile extends StatelessWidget {
  final String title;
  final String date;
  final String type;
  final int duration;
  final String image;
  final Color avatarColor;

  const TherapyHistoryTile({
    Key? key,
    required this.title,
    required this.date,
    required this.type,
    required this.duration,
    required this.image,
    required this.avatarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7.0),
                    child: Container(
                      height: screenHeight * 0.07,
                      width: screenHeight * 0.07,
                      color: avatarColor,
                      child: Image.asset(
                        image,
                        fit: BoxFit.contain,
                      ),
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
                      const SizedBox(height: 5.0),
                      Text(
                        type,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.032,
                          color: AppColors.appColor,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$duration min',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05), // Spacing
                  Text(
                    date,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.03,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
