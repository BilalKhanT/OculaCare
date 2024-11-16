import 'package:cculacare/presentation/widgets/btn_flat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../configs/presentation/constants/colors.dart';

class CstmDialogueBox extends StatelessWidget {
  const CstmDialogueBox({super.key});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Container(
          height: height * 0.2,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 0.5,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error!",
                    style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: height * 0.025,
                      color: AppColors.appColor,
                  ),),
                  SizedBox(height: height * 0.02,),
                  Text("User Location Not Available.",
                    style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: width * 0.035,
                      color: Colors.black,
                    ),),
                  SizedBox(height: height * 0.02,),
                  ButtonFlat(btnColor: AppColors.appColor, textColor: AppColors.whiteColor, onPress: () {

                  }, text: "Try Again")
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
