import 'package:animate_do/animate_do.dart';
import 'package:cculacare/configs/routes/route_names.dart';
import 'package:cculacare/configs/utils/utils.dart';
import 'package:cculacare/data/models/disease_result/diagnosis_result_model.dart';
import 'package:cculacare/logic/detection/med_cubit.dart';
import 'package:cculacare/logic/treatment/treatment_cubit.dart';
import 'package:cculacare/logic/treatment/treatment_state.dart';
import 'package:cculacare/presentation/result/widgets/probability_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../data/models/disease_result/disease_result_model.dart';

class DiseaseAnalysisView extends StatelessWidget {
  final DiseaseResultModel result;
  const DiseaseAnalysisView({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
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
          'Disease Analysis',
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BlocBuilder<TreatmentCubit, TreatmentState>(
                builder: (context, state) {
                  if (state is TreatmentLeft) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              height: screenHeight * 0.05,
                              width: screenWidth * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.appColor,
                                    spreadRadius: 1,
                                    blurRadius: 0.5,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(10.0),
                                  dropdownColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  value: context
                                      .read<TreatmentCubit>()
                                      .selectedOption,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Colors.black,
                                  ),
                                  iconSize: screenWidth * 0.05,
                                  elevation: 10,
                                  style: const TextStyle(
                                      color: Colors.deepPurple),
                                  underline: Container(
                                    height: 0,
                                    color: AppColors.appColor,
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue == 'Bulgy Eyes') {
                                      if (result.bulgy!.prediction! == 'normal') {
                                        AppUtils.showToast(
                                            context,
                                            'No Disease Detected',
                                            'You do not have bulgy eyes',
                                            false);
                                        return;
                                      }
                                    }
                                    context
                                        .read<TreatmentCubit>()
                                        .toggleOption(newValue!, result);
                                  },
                                  items: <String>[
                                    'Left Eye',
                                    'Right Eye',
                                    'Bulgy Eyes',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.032,
                                          letterSpacing: 1,
                                          color: Colors.black,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        result.leftEye!.prediction! == 'normal'
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.1,
                                    ),
                                    FadeInDown(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Lottie.asset(
                                        'assets/lotties/no_disease.json',
                                        height: screenHeight * 0.35,
                                        width: screenHeight * 0.35,
                                      ),
                                    ),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Text(
                                        'No Significant Ocular Disease Detected!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.w800,
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: ProbabilityChart(
                                          score: double.parse(result
                                              .leftEye!.probability!
                                              .replaceAll('%', ''))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  Text(
                                    result.leftEye!.prediction!,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'MontserratMedium',
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Center(
                                    child: Text(
                                      'Note: This is is an AI guided diagnosis, seek medical expertise for professional guidance.',
                                      style: TextStyle(
                                        fontFamily: 'MontserratMedium',
                                        fontSize: screenWidth * 0.027,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.red,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Text(
                                    'Description',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'MontserratMedium',
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.05,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Text(
                                    result.leftEye!.prediction! ==
                                            'Cataracts Detected'
                                        ? 'Cataracts are a clouding of the eye natural lens, causing blurred vision and, if untreated, eventual blindness. Common in aging, they can be surgically removed to restore clearvision.'
                                        : result.leftEye!.prediction! ==
                                                'Uveitis Detected'
                                            ? 'Uveitis is an inflammation of the middle layer of the eye, which can affect one or both eyes. It can cause redness, pain, and blurred vision. Early detection is essential to prevent potential complications.'
                                            : result.leftEye!.prediction! ==
                                                    'Pterygium Detected'
                                                ? 'Pterygium is a growth of tissue on the white of the eye that can extend onto the cornea, often caused by UV exposure. It may cause irritation or blurred vision and can be surgically removed if necessary.'
                                                : 'Bulgy eyes refer to the abnormal protrusion of the eyeballs, often caused by thyroid conditions like Graves disease. This can affect vision and may require treatment to prevent further complications.',
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      fontSize: screenWidth * 0.032,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Text(
                                    'Your Test Results',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'MontserratMedium',
                                      fontWeight: FontWeight.w800,
                                      fontSize: screenWidth * 0.045,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeIn(
                                    duration: const Duration(milliseconds: 800),
                                    child: customTileWidget(
                                      title: 'Generate Diagnosis Report',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/results.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        DiagnosisResultModel data =
                                            DiagnosisResultModel(
                                                result: result, flag: 'left');
                                        context.push(RouteNames.diagnosisRoute,
                                            extra: data);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeIn(
                                    duration: const Duration(milliseconds: 800),
                                    child: customTileWidget(
                                      title: 'Medicine Recommendations',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/dots.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        final int medIndex = result
                                                    .leftEye!.prediction! ==
                                                'Cataracts Detected'
                                            ? 0
                                            : result.leftEye!.prediction! ==
                                                    'Pterygium Detected'
                                                ? 1
                                                : result.leftEye!.prediction! ==
                                                        'Uveitis Detected'
                                                    ? 3
                                                    : 2;
                                        context
                                            .read<MedCubit>()
                                            .emitToggled(medIndex, 0);
                                        context.push(RouteNames.medicineRoute,
                                            extra: result.leftEye!.prediction!);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    );
                  } else if (state is TreatmentRight) {
                    return Column(
                      children: [
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.appColor,
                                      spreadRadius: 1,
                                      blurRadius: 0.5,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(10.0),
                                    dropdownColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    value: context
                                        .read<TreatmentCubit>()
                                        .selectedOption,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.black,
                                    ),
                                    iconSize: screenWidth * 0.05,
                                    elevation: 10,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 0,
                                      color: AppColors.appColor,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue == 'Bulgy Eyes') {
                                        if (result.bulgy!.prediction! == 'normal') {
                                          AppUtils.showToast(
                                              context,
                                              'No Disease Detected',
                                              'You do not have bulgy eyes',
                                              false);
                                          return;
                                        }
                                      }
                                      context
                                          .read<TreatmentCubit>()
                                          .toggleOption(newValue!, result);
                                    },
                                    items: <String>[
                                      'Left Eye',
                                      'Right Eye',
                                      'Bulgy Eyes',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: 'MontserratMedium',
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.032,
                                            letterSpacing: 1,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        result.rightEye!.prediction! == 'normal'
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.1,
                                    ),
                                    FadeInDown(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Lottie.asset(
                                        'assets/lotties/no_disease.json',
                                        height: screenHeight * 0.35,
                                        width: screenHeight * 0.35,
                                      ),
                                    ),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Text(
                                        'No Significant Ocular Disease Detected!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.w800,
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: FadeInDown(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: ProbabilityChart(
                                          score: double.parse(result
                                              .rightEye!.probability!
                                              .replaceAll('%', ''))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  FadeInLeft(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      result.rightEye!.prediction!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Center(
                                    child: FadeInLeft(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Text(
                                        'Note: This is is an AI guided diagnosis, seek medical expertise for professional guidance.',
                                        style: TextStyle(
                                          fontFamily: 'MontserratMedium',
                                          fontSize: screenWidth * 0.027,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      result.rightEye!.prediction! ==
                                              'Cataracts Detected'
                                          ? 'Cataracts are a clouding of the eye natural lens, causing blurred vision and, if untreated, eventual blindness. Common in aging, they can be surgically removed to restore clearvision.'
                                          : result.rightEye!.prediction! ==
                                                  'Uveitis Detected'
                                              ? 'Uveitis is an inflammation of the middle layer of the eye, which can affect one or both eyes. It can cause redness, pain, and blurred vision. Early detection is essential to prevent potential complications.'
                                              : result.rightEye!.prediction! ==
                                                      'Pterygium Detected'
                                                  ? 'Pterygium is a growth of tissue on the white of the eye that can extend onto the cornea, often caused by UV exposure. It may cause irritation or blurred vision and can be surgically removed if necessary.'
                                                  : 'Bulgy eyes refer to the abnormal protrusion of the eyeballs, often caused by thyroid conditions like Graves disease. This can affect vision and may require treatment to prevent further complications.',
                                      style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.032,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      'Your Test Results',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: customTileWidget(
                                      title: 'Generate Diagnosis Report',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/results.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        DiagnosisResultModel data =
                                            DiagnosisResultModel(
                                                result: result, flag: 'right');
                                        context.push(RouteNames.diagnosisRoute,
                                            extra: data);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: customTileWidget(
                                      title: 'Medicine Recommendations',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/dots.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        final int medIndex = result
                                                    .rightEye!.prediction! ==
                                                'Cataracts Detected'
                                            ? 0
                                            : result.rightEye!.prediction! ==
                                                    'Pterygium Detected'
                                                ? 1
                                                : result.rightEye!
                                                            .prediction! ==
                                                        'Uveitis Detected'
                                                    ? 3
                                                    : 2;
                                        context
                                            .read<MedCubit>()
                                            .emitToggled(medIndex, 0);
                                        context.push(RouteNames.medicineRoute,
                                            extra:
                                                result.rightEye!.prediction!);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    );
                  } else if (state is TreatmentBulgy) {
                    return Column(
                      children: [
                        FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                height: screenHeight * 0.05,
                                width: screenWidth * 0.35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColors.appColor,
                                      spreadRadius: 1,
                                      blurRadius: 0.5,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: DropdownButton<String>(
                                    borderRadius: BorderRadius.circular(10.0),
                                    dropdownColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    value: context
                                        .read<TreatmentCubit>()
                                        .selectedOption,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down_outlined,
                                      color: Colors.black,
                                    ),
                                    iconSize: screenWidth * 0.05,
                                    elevation: 10,
                                    style: const TextStyle(
                                        color: Colors.deepPurple),
                                    underline: Container(
                                      height: 0,
                                      color: AppColors.appColor,
                                    ),
                                    onChanged: (String? newValue) {
                                      if (newValue == 'Bulgy Eyes') {
                                        if (result.bulgy!.prediction! == 'normal') {
                                          AppUtils.showToast(
                                              context,
                                              'No Disease Detected',
                                              'You do not have bulgy eyes',
                                              false);
                                          return;
                                        }
                                      }
                                      context
                                          .read<TreatmentCubit>()
                                          .toggleOption(newValue!, result);
                                    },
                                    items: <String>[
                                      'Left Eye',
                                      'Right Eye',
                                      'Bulgy Eyes',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: 'MontserratMedium',
                                            fontWeight: FontWeight.bold,
                                            fontSize: screenWidth * 0.032,
                                            letterSpacing: 1,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        result.bulgy!.prediction! == 'Normal'
                            ? Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: screenHeight * 0.1,
                                    ),
                                    FadeInDown(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Lottie.asset(
                                        'assets/lotties/no_disease.json',
                                        height: screenHeight * 0.35,
                                        width: screenHeight * 0.35,
                                      ),
                                    ),
                                    FadeInUp(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Text(
                                        'No Significant Ocular Disease Detected!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontFamily: 'MontserratMedium',
                                          fontWeight: FontWeight.w800,
                                          fontSize: screenWidth * 0.045,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: FadeInDown(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: ProbabilityChart(
                                          score: double.parse(result
                                              .bulgy!.probability!
                                              .replaceAll('%', ''))),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.04,
                                  ),
                                  FadeInLeft(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      result.bulgy!.prediction!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Center(
                                    child: FadeInLeft(
                                      duration:
                                          const Duration(milliseconds: 600),
                                      child: Text(
                                        'Note: This is is an AI guided diagnosis, seek medical expertise for professional guidance.',
                                        style: TextStyle(
                                          fontFamily: 'MontserratMedium',
                                          fontSize: screenWidth * 0.027,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red,
                                        ),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      'Description',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.05,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  FadeInRight(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      'Bulgy eyes refer to the abnormal protrusion of the eyeballs, often caused by thyroid conditions like Graves disease. This can affect vision and may require treatment to prevent further complications.',
                                      style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                        fontSize: screenWidth * 0.032,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: Text(
                                      'Your Test Results',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'MontserratMedium',
                                        fontWeight: FontWeight.w800,
                                        fontSize: screenWidth * 0.045,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: customTileWidget(
                                      title: 'Generate Diagnosis Report',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/results.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        DiagnosisResultModel data =
                                            DiagnosisResultModel(
                                                result: result, flag: 'bulgy');
                                        context.push(RouteNames.diagnosisRoute,
                                            extra: data);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: customTileWidget(
                                      title: 'Medicine Recommendations',
                                      icon: SvgPicture.asset(
                                        'assets/svgs/dots.svg',
                                        // ignore: deprecated_member_use
                                        color: Colors.white,
                                      ),
                                      text: "Ready",
                                      screenWidth: screenWidth,
                                      onTap: () {
                                        const int medIndex = 2;
                                        context
                                            .read<MedCubit>()
                                            .emitToggled(medIndex, 0);
                                        context.push(RouteNames.medicineRoute,
                                            extra: result.bulgy!.prediction!);
                                      },
                                      screenHeight: screenHeight,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTileWidget({
    required String title,
    required Widget icon,
    required String text,
    required double screenWidth,
    required VoidCallback onTap,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    height: screenHeight * 0.06,
                    width: screenHeight * 0.06,
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: icon,
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
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        text,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w900,
                          fontSize: screenWidth * 0.032,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
