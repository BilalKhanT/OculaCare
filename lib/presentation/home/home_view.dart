import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cculacare/configs/extension/extensions.dart';
import 'package:cculacare/logic/home_cubit/home_cubit.dart';
import 'package:cculacare/logic/home_cubit/home_state.dart';
import 'package:cculacare/presentation/home/widgets/grid_btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../configs/global/app_globals.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../data/models/address/address_model.dart';
import '../../data/models/patient/patient_model.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/detection/question_cubit.dart';
import '../../logic/image_capture/img_capture_cubit.dart';
import '../../logic/pdf_cubit/pdf_cubit_state.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    final hour = DateTime.now().hour;
    final String date = DateFormat('d MMMM').format(DateTime.now());
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    String? patientData = sharedPrefs.patientData;
    if (patientData != '') {
      Map<String, dynamic> decodedData = jsonDecode(patientData);
      patient = Patient.fromJson(decodedData);
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        body: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeStateAnimate) {
                return SizedBox(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Text(
                              'Today, $date',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontSize: screenWidth * 0.03,
                                fontWeight: FontWeight.w800,
                                color: AppColors.appColor,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInLeft(
                                  duration: const Duration(milliseconds: 600),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Text(
                                            hour < 12
                                                ? 'Good Morning!'
                                                : 'Good Evening!',
                                            style: TextStyle(
                                              fontFamily: 'MontserratMedium',
                                              fontSize: 27.sp,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        sharedPrefs.userName,
                                        style: TextStyle(
                                          fontFamily: 'MontserratMedium',
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey.shade800,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(right: 25.0, left: 10.0),
                                  child: FadeInRight(
                                    duration: const Duration(milliseconds: 600),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: AppColors.whiteColor, width: 0.5),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 0.5,
                                            blurRadius: 2,
                                            offset: Offset(0, 1.5),
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          height: screenHeight * 0.06,
                                          width: screenHeight * 0.06,
                                          color: Colors.white,
                                          child: patient.profileImage == ''
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
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: FadeInUp(
                              duration: const Duration(milliseconds: 600),
                              child: GestureDetector(
                                onTap: () {
                                  AppUtils.showToast(
                                      context,
                                      'Feature under development',
                                      'This feature will be available in future versions',
                                      false);
                                },
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.9,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(80.0),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.tune,
                                            color: AppColors.textSecondary,
                                          ),
                                          Expanded(
                                              child: TextFormField(
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  hintStyle: context
                                                      .appTheme.textTheme.labelMedium
                                                      ?.copyWith(
                                                      fontFamily: 'MontserratMedium',
                                                      color: Colors.grey.shade400,
                                                      fontSize:
                                                      MediaQuery.sizeOf(context)
                                                          .width *
                                                          0.04),
                                                  hintText: 'Search for hospital',
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                    top: MediaQuery.sizeOf(context)
                                                        .height *
                                                        0.015,
                                                    left: 20.w,
                                                    bottom: MediaQuery.sizeOf(context)
                                                        .height *
                                                        0.015,
                                                  ),
                                                ),
                                                style: TextStyle(
                                                  fontFamily: 'MontserratMedium',
                                                  fontSize: screenWidth * 0.035,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.appColor,
                                                ),
                                              )),
                                          Padding(
                                            padding: EdgeInsets.all(15.h),
                                            child: SvgPicture.asset(
                                              'assets/svgs/charm_search.svg',
                                              // ignore: deprecated_member_use
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.04,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: SizedBox(
                              height: screenHeight * 0.18,
                              width: MediaQuery.of(context).size.width,
                              child: LayoutBuilder(builder: (context, constraints) {
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: FadeInLeft(
                                          duration: const Duration(milliseconds: 500),
                                          child: GridButtonWidget(
                                            onTap: () {
                                              if (!sharedPrefs.isProfileSetup) {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return const Dialog(
                                                        child:
                                                        NeedToSetupProfileWidget());
                                                  },
                                                );
                                                return;
                                              }
                                              isHome = true;
                                              isMore = false;
                                              context.read<QuestionCubit>().startQuestionnaire();
                                              context.push(RouteNames.questionRoute);
                                            },
                                            iconData: "assets/svgs/eye_scan.svg",
                                            constraints: constraints,
                                            title: "Fast Way",
                                            subtitle: "To Detect",
                                            color: const Color(0xFF9673D4),
                                            colorSecondary: const Color(0xFF6B4FA0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenHeight * 0.025,
                                      ),
                                      FadeInUp(
                                        duration: const Duration(milliseconds: 600),
                                        child: GridButtonWidget(
                                          onTap: () {
                                            if (!sharedPrefs.isProfileSetup) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const Dialog(
                                                      child:
                                                      NeedToSetupProfileWidget());
                                                },
                                              );
                                              return;
                                            }
                                            context.go(RouteNames.testRoute);
                                          },
                                          iconData: "assets/svgs/tests.svg",
                                          constraints: constraints,
                                          title: "Tests",
                                          subtitle: 'Vision-Color',
                                          color: const Color(0xFF59AFCC),
                                          colorSecondary: const Color(0xFF357C92),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenHeight * 0.025,
                                      ),
                                      FadeInRight(
                                        duration: const Duration(milliseconds: 700),
                                        child: GridButtonWidget(
                                          onTap: () {
                                            AppUtils.showToast(
                                                context,
                                                'Feature Under Development',
                                                'Hold on as we build this feature',
                                                false);
                                          },
                                          iconData: "assets/svgs/hospital.svg",
                                          constraints: constraints,
                                          title: "Hospital",
                                          subtitle: "Explore",
                                          color: const Color(0xFFF683A2),
                                          colorSecondary: const Color(0xFFCF617F),
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenHeight * 0.025,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: FadeInUp(
                                          duration:
                                          const Duration(milliseconds: 800),
                                          child: GridButtonWidget(
                                            onTap: () {
                                              context
                                                  .read<PDFCubit>()
                                                  .fetchAndInitializePDFList();
                                              context.push(RouteNames.pdfViewRoute);
                                            },
                                            constraints: constraints,
                                            iconData: 'assets/svgs/leaflet.svg',
                                            title: "Explore",
                                            subtitle: "Leaflets",
                                            color: const Color(0xffbbbcbf),
                                            colorSecondary: const Color(0xFF8D8D90),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInLeft(
                                  duration: const Duration(milliseconds: 600),
                                  child: Text(
                                    'Vision & Wellness',
                                    style: TextStyle(
                                      fontFamily: 'MontserratMedium',
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                FadeInRight(
                                  duration: const Duration(milliseconds: 600),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: AppColors.appColor.withOpacity(0.7),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SvgPicture.asset(
                                        'assets/svgs/leaflet.svg',
                                        height: screenHeight * 0.03,
                                        width: screenHeight * 0.03,
                                        // ignore: deprecated_member_use
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: CarouselSlider(
                              items: [
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.5,
                                              child: Image.asset(
                                                  'assets/images/edu_1.png'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.only(
                                        right: 5.0, top: 5.0, bottom: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          height: 150.h,
                                          child: Image.asset(
                                            'assets/images/edu_1.png',
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.5,
                                              child: Image.asset(
                                                  'assets/images/eye_2.png'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        height: 150.h,
                                        child: Image.asset(
                                          'assets/images/eye_2.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.5,
                                              child: Image.asset(
                                                  'assets/images/edu_eye.png'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        height: 150.h,
                                        child: Image.asset(
                                          'assets/images/edu_eye.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.5,
                                              child: Image.asset(
                                                  'assets/images/edu_3.png'),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 2,
                                          blurRadius: 8,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.only(
                                        left: 5.0, top: 5.0, bottom: 5.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.blue.withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        height: 150.h,
                                        child: Image.asset(
                                          'assets/images/edu_3.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              options: CarouselOptions(
                                  height: screenHeight * 0.28,
                                  aspectRatio: 16 / 9,
                                  autoPlay: true,
                                  viewportFraction: 0.5,
                                  enlargeCenterPage: true,
                                  initialPage: 2,
                                  scrollDirection: Axis.horizontal,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  enableInfiniteScroll: false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

