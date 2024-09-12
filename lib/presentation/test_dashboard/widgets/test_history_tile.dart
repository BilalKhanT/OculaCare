import 'package:flutter/material.dart';
import '../../../configs/presentation/constants/colors.dart';

class TestHistoryTile extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final Color avatarColor;
  final Function() onPress;
  const TestHistoryTile(
      {super.key,
      required this.title,
      required this.description,
      required this.image,
      required this.onPress,
      required this.avatarColor});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
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
                        child: image == 'assets/images/isihara_test.png' ||
                                image == 'assets/images/snellan_test.png' ||
                                image == 'assets/images/drag_test.png'
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                image,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
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
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w900,
                            fontSize: screenWidth * 0.032,
                            color: AppColors.appColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05,),
                    Text(
                          'View Report',
                          style: TextStyle(
                            color: AppColors.appColor,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w700,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
