import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/severity_chart.dart';
import 'package:OculaCare/presentation/test_dashboard/widgets/snellan_chart_widget.dart';
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.upload_outlined,
                  color: AppColors.appColor,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Download',
                  style: TextStyle(
                    color: AppColors.appColor,
                    fontFamily: 'MontserratMedium',
                    fontWeight: FontWeight.w800,
                    fontSize: screenWidth * 0.04,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
          child: Card(
            color: Colors.white,
            shadowColor: Colors.grey.withOpacity(0.5),
            elevation: 5.0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.appColor, width: 3.0),
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
                      const SizedBox(
                        width: 30.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            test.patientName,
                            style: TextStyle(
                              color: AppColors.appColor,
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.006,
                          ),
                          Text(
                            test.date,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.003,
                          ),
                          Text(
                            test.testType,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Row(
                    children: [
                      Text(
                        'Test Name:',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        test.testName,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.05,
                        ),
                      ),
                    ],
                  ),
                  test.testName == 'Animal Track'
                      ? TrackChart(
                          score: test.testScore,
                        )
                      : SeverityChart(score: test.testScore),
                  Text(
                    'Analysis:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    test.resultDescription,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Recommendations:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    test.recommendation,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.05,
                  ),
                  Text(
                    'Impacts:',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.05,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Text(
                    test.precautions,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
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
