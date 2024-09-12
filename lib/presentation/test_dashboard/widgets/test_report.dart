import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class TestReport extends StatelessWidget {
  final TestResultModel test;
  const TestReport({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Test Report',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
        leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.appColor, width: 3.0),
                    ),
                    child: ClipOval(
                      child: Container(
                        height: screenHeight * 0.15,
                        width: screenHeight * 0.15,
                        color: Colors.white,
                        child: Image.asset(
                          'assets/images/profile_place.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30.0,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(test.patientName,
                        style: TextStyle(
                          color: AppColors.appColor,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.05,
                        ),),
                      SizedBox(height: screenHeight * 0.006,),
                      Text(test.date,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.035,
                        ),),
                      SizedBox(height: screenHeight * 0.003,),
                      Text(test.testType,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.035,
                        ),),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.03,),
              Text(test.testName,
                style: TextStyle(
                  color: AppColors.appColor,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.05,
                ),),
            ],
          ),
        ),
      ),
    );
  }
}
