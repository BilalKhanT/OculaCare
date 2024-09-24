import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:flutter/material.dart';

class PauseMenu extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;

  const PauseMenu({
    super.key,
    required this.onResume,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
        height: screenHeight * 0.25,
        width: screenHeight * 0.37,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Exit Game?',
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),

                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Divider(
                  color: AppColors.secondaryBtnColor,
                  height: 2,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Flexible(
                  child: Text(
                    'You will loose your progress if you exit the game.',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.03,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all<Color>(AppColors.appColor),
                      ),
                      onPressed: onResume,
                      child: Text(
                        'Resume',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: onQuit,
                      child: Text(
                        ' Exit ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.035,
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
