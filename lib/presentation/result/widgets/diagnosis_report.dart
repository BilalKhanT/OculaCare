import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:cculacare/data/models/disease_result/diagnosis_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../data/models/address/address_model.dart';
import '../../../data/models/patient/patient_model.dart';
import '../../../data/repositories/local/preferences/shared_prefs.dart';

class DiagnosisReport extends StatelessWidget {
  final DiagnosisResultModel diagnosis;
  const DiagnosisReport({super.key, required this.diagnosis});

  @override
  Widget build(BuildContext context) {
    const String cataractsCauses =
        '1: Aging and oxidative stress.\n'
        '2: Prolonged exposure to UV light.\n'
        '3: Smoking and alcohol consumption.';
    const String uveitisCauses =
        '1: Autoimmune diseases like rheumatoid arthritis.\n'
        '2: Infections like herpes or tuberculosis.\n'
        '3: Eye injuries or trauma.';
    const String pterygiumCauses =
        '1: Prolonged exposure to wind and dust.\n'
        '2: UV radiation from the sun.\n'
        '3: Dry, arid climates.';
    const String bulgyEyesCauses =
        '1: Overactive thyroid (Graves\' disease).\n'
        '2: Autoimmune reactions.\n'
        '3: Inflammation of the eye muscles and tissues.';

    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    Patient patient = Patient(
        email: '',
        username: '',
        profileImage: '',
        age: 0,
        gender: '',
        contactNumber: '',
        address: Address(lat: 0, long: 0, locationName: ''));
    String? patientData = sharedPrefs.patientData;
    if (patientData != '') {
      Map<String, dynamic> decodedData = jsonDecode(patientData);
      patient = Patient.fromJson(decodedData);
    }
    final String decisionFlag = diagnosis.flag == 'left'
        ? diagnosis.result.leftEye!.prediction!
        : diagnosis.flag == 'right'
        ? diagnosis.result.rightEye!.prediction!
        : diagnosis.result.bulgy!.prediction!;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
            size: 30.0,
          ),
        ),
        title: Text(
          'Diagnosis Report',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 10.0, right: 15.0),
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
                        border:
                            Border.all(color: AppColors.appColor, width: 1.5),
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
              Text(
                'Name:  ${diagnosis.result.patientName}',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.037,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.003,
              ),
              Text(
                'Date:  ${diagnosis.result.date}',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.037,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Text(
                diagnosis.flag == 'left'
                    ? diagnosis.result.leftEye!.prediction!
                    : diagnosis.flag == 'right'
                        ? diagnosis.result.rightEye!.prediction!
                        : diagnosis.result.bulgy!.prediction!,
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
                'Potential Causes',
                style: TextStyle(
                  color: AppColors.appColor,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Text(
                decisionFlag == 'Cataracts Detected' ? cataractsCauses : decisionFlag == 'Pterygium Detected' ? pterygiumCauses : decisionFlag == 'Uveitis Detected' ? uveitisCauses : bulgyEyesCauses,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Treatment Recommendations',
                style: TextStyle(
                  color: AppColors.appColor,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Text(
                decisionFlag == 'Bulgy Eyes Detected' ?
                '${diagnosis.result.treatment2}' : '${diagnosis.result.treatment1}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.035,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              Text(
                'Precautions',
                style: TextStyle(
                  color: AppColors.appColor,
                  fontFamily: 'MontserratMedium',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.045,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.005,
              ),
              Text(
                decisionFlag == 'Bulgy Eyes Detected' ?
                '${diagnosis.result.precaution2}' : '${diagnosis.result.precaution1}',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
