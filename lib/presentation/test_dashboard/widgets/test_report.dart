import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/test_dashboard/widgets/pdf_generator_test.dart';
import 'package:cculacare/presentation/test_dashboard/widgets/severity_chart.dart';
import 'package:cculacare/presentation/test_dashboard/widgets/snellan_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/address/address_model.dart';
import '../../../data/models/patient/patient_model.dart';
import '../../../data/models/tests/test_result_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';
import '../../../logic/tests/test_dash_tab_cubit.dart';

class TestReport extends StatelessWidget {
  final TestResultModel test;
  const TestReport({super.key, required this.test});

  @override
  Widget build(BuildContext context) {
    Patient patient = Patient(
        email: '',
        username: '',
        profileImage: '',
        age: 0,
        gender: '',
        contactNumber: '',
        address: Address(lat: 0, long: 0, locationName: ''));
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    String? patientData = sharedPrefs.patientData;
    if (patientData != '') {
      Map<String, dynamic> decodedData = jsonDecode(patientData);
      patient = Patient.fromJson(decodedData);
    }
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
            onPressed: () {
              context.read<TestDashTabCubit>().toggleTab(1);
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
            )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                final report = PdfReportGenerator(
                    userName: test.patientName,
                    testDate: test.date,
                    testType: test.testType,
                    testName: test.testName,
                    testScore: test.testScore,
                    analysis: test.resultDescription,
                    recommendations: test.recommendation,
                    impacts: test.precautions,
                    userProfileImageBase64: patient.profileImage!);
                downloadReport(context, report);
              },
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
            ),
          )
        ],
      ),
      body: FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 5.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeInLeft(
                        duration: const Duration(milliseconds: 600),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.appColor, width: 1.5),
                          ),
                          child: ClipOval(
                            child: Container(
                              height: screenHeight * 0.13,
                              width: screenHeight * 0.13,
                              color: Colors.white,
                              child: patientData == ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SvgPicture.asset(
                                        "assets/svgs/account.svg",
                                        // ignore: deprecated_member_use
                                        color: Colors.grey.shade800,
                                      ),
                                    )
                                  : Image.memory(
                                      base64Decode(patient.profileImage!),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      FadeInRight(
                        duration: const Duration(milliseconds: 600),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/logo_ocula_login.png',
                              height: screenHeight * 0.04,
                              width: screenHeight * 0.04,
                            ),
                            Text(
                              'OculaCare',
                              style: TextStyle(
                                color: AppColors.appColor,
                                fontFamily: 'MontserratMedium',
                                fontWeight: FontWeight.w800,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.05,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Name: ${test.patientName}',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.037,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Date: ${test.date}',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.037,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  FadeInDown(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Test Type: ${test.testType}',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.037,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  FadeInLeft(
                    duration: const Duration(milliseconds: 600),
                    child: Row(
                      children: [
                        Text(
                          'Test Name:',
                          style: TextStyle(
                            color: AppColors.appColor,
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          test.testName,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.037,
                          ),
                        ),
                      ],
                    ),
                  ),
                  test.testName == 'Animal Track'
                      ? FadeInUp(
                    duration: const Duration(milliseconds: 600),
                        child: TrackChart(
                            score: test.testScore,
                          ),
                      )
                      : test.testName == 'Snellan Chart'
                          ? Center(
                              child: FadeInUp(
                                duration: const Duration(milliseconds: 600),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/result_test.png',
                                      height: screenHeight * 0.15,
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Text(
                                      '6/${test.testScore}',
                                      style: TextStyle(
                                        color: AppColors.appColor,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.04,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.02,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SeverityChart(score: test.testScore),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Analysis:',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      test.resultDescription,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.034,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Recommendations:',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      test.recommendation,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.034,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.025,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      'Impacts:',
                      style: TextStyle(
                        color: AppColors.appColor,
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.04,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: Text(
                      test.precautions,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.034,
                        letterSpacing: 0.5,
                      ),
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
