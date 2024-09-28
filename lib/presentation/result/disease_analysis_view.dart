import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/result/widgets/probability_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

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
              Center(
                child: FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: ProbabilityChart(
                      score: double.parse(
                          result.leftEye!.probability!.replaceAll('%', ''))),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.04,
              ),
              FadeInLeft(
                duration: const Duration(milliseconds: 600),
                child: Text(
                  result.leftEye!.prediction!,
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
                  duration: const Duration(milliseconds: 600),
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
                  'Cataracts are a clouding of the eye natural lens, causing blurred vision and, if untreated, eventual blindness. Common in aging, they can be surgically removed to restore clearvision.',
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
                  onTap: () {},
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
                  onTap: () {},
                  screenHeight: screenHeight,
                ),
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
