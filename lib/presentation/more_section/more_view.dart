import 'package:animate_do/animate_do.dart';
import 'package:cculacare/logic/more_animate/more_cubit.dart';
import 'package:cculacare/logic/more_animate/more_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../configs/global/app_globals.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/address_book/address_book_cubit.dart';
import '../../logic/detection/detection_cubit.dart';
import '../../logic/detection/question_cubit.dart';
import '../../logic/detection_animation/detection_animation_cubit.dart';
import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/patient_profile/patient_profile_cubit.dart';
import '../../logic/pdf_cubit/pdf_cubit_state.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocBuilder<MoreCubit, MoreState>(
            builder: (context, state) {
              if (state is MoreStateAnimate) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leaflets",
                                style: TextStyle(
                                    fontFamily: "MontserratMedium",
                                    color: AppColors.appColor,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1,
                                    fontSize: 17.sp),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<PDFCubit>()
                                      .fetchAndInitializePDFList();
                                  context.push(RouteNames.pdfViewRoute);
                                },
                                child: Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                          "assets/images/eye_leaflet.png")),
                                ),
                              )
                            ]),
                      ),
                      FadeInUp(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          color: AppColors.appColor.withOpacity(0.2),
                          padding: const EdgeInsets.all(15),
                          child: GestureDetector(
                            onTap: () {
                              if (!sharedPrefs.isProfileSetup) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Dialog(
                                        child: NeedToSetupProfileWidget());
                                  },
                                );
                                return;
                              }
                              isHome = false;
                              isMore = true;
                              context.read<QuestionCubit>().startQuestionnaire();
                              context.push(RouteNames.questionRoute);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Center(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        SvgPicture.asset(
                                          "assets/svgs/eye_scan.svg",
                                          // ignore: deprecated_member_use
                                          color: AppColors.appColor,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          'Scan&Detect',
                                          style: TextStyle(
                                            fontFamily: 'MontserratMedium',
                                            color: AppColors.appColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Detect Eye Disease",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.sp,
                                        fontFamily: 'Montserrat',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
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
                          ],),
                        child: Column(
                          children: [
                            MoreTab(
                              text: "Account",
                              icon: "assets/svgs/account.svg",
                              onTap: () {
                                context
                                    .read<PatientProfileCubit>()
                                    .loadPatientProfile(sharedPrefs.email);
                                context.push(RouteNames.profileRoute);
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Address Book",
                              icon: "assets/svgs/bookmark_hospital.svg",
                              onTap: () {
                                if (!sharedPrefs.isProfileSetup) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(
                                          child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                }
                                context.read<AddressBookCubit>().getAddresses();
                                context.push(RouteNames.addressBookRoute);
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Explore Eye Hospitals",
                              icon: "assets/svgs/charm_search.svg",
                              onTap: () {
                                if (!sharedPrefs.isProfileSetup) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(
                                          child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  AppUtils.showToast(
                                      context,
                                      'Feature Under Development',
                                      'This feature will be available in next version',
                                      false);
                                }
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "View Bookmarked Hospitals",
                              icon: "assets/svgs/hospital.svg",
                              onTap: () {
                                if (!sharedPrefs.isProfileSetup) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(
                                          child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  AppUtils.showToast(
                                      context,
                                      'Feature Under Development',
                                      'This feature will be available in next version',
                                      false);
                                }
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "View Detection Results",
                              icon: "assets/svgs/detection_result.svg",
                              onTap: () {
                                if (!sharedPrefs.isProfileSetup) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(
                                          child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  context.read<DetectionAnimationCubit>().emitHomeAnimation();
                                  context.read<DetectionCubit>().loadDiseaseResults();
                                  context.go(RouteNames.detectionRoute);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
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
                          ],),
                        child: Column(
                          children: [
                            MoreTab(
                              text: "Feedback",
                              icon: "assets/svgs/feedback.svg",
                              onTap: () {
                                context.push(RouteNames.feedbackRoute);
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Partners",
                              icon: "assets/svgs/partners.svg",
                              onTap: () async {
                                const url =
                                    'https://oculastatic.web.app/partners.html';
                                Uri privacyPolicyLaunchUrl = Uri.parse(
                                  url,
                                );
                                if (await canLaunchUrl(privacyPolicyLaunchUrl)) {
                                  await launchUrl(privacyPolicyLaunchUrl);
                                }
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Terms and Conditions",
                              icon: "assets/svgs/terms-and-conditions.svg",
                              onTap: () async {
                                const url =
                                    'https://oculastatic.web.app/terms_conditions.html';
                                Uri tcLaunchUrl = Uri.parse(
                                  url,
                                );
                                if (await canLaunchUrl(tcLaunchUrl)) {
                                  await launchUrl(tcLaunchUrl);
                                }
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Privacy Policy",
                              icon: "assets/svgs/privacy-policy.svg",
                              onTap: () async {
                                const url =
                                    'https://oculastatic.web.app/privacy_policy.html';
                                Uri privacyPolicyLaunchUrl = Uri.parse(
                                  url,
                                );
                                if (await canLaunchUrl(privacyPolicyLaunchUrl)) {
                                  await launchUrl(privacyPolicyLaunchUrl);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      sharedPrefs.isLoggedIn
                          ? Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.h),
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
                          ],),
                        child: MoreTab(
                          text: "Logout",
                          icon: "assets/svgs/log_out.svg",
                          onTap: () {
                            clearGlobalDataOnLogout();
                            sharedPrefs.isLoggedIn = false;
                            sharedPrefs.isProfileSetup = false;
                            sharedPrefs.patientData = '';
                            sharedPrefs.userName = '';
                            sharedPrefs.email = '';
                            sharedPrefs.password = '';
                            sharedPrefs.therapyFetched = false;
                            sharedPrefs.historyFetched = false;
                            context.go(RouteNames.loginRoute);
                          },
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 20.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: MoreTab(
                          text: "Logout",
                          icon: "assets/svgs/log_out.svg",
                          onTap: () async {
                            clearGlobalDataOnLogout();
                            sharedPrefs.isLoggedIn = false;
                            sharedPrefs.isProfileSetup = false;
                            sharedPrefs.patientData = '';
                            sharedPrefs.userName = '';
                            sharedPrefs.email = '';
                            sharedPrefs.password = '';
                            sharedPrefs.therapyFetched = false;
                            sharedPrefs.historyFetched = false;
                            sharedPrefs.clearAddressList();
                            sharedPrefs.clearCurrentAddress();
                            context.read<LoginCubit>().loadLoginScreen();
                            context.go(RouteNames.loginRoute);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Version 0.0.1 (1)",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade400,
                                fontFamily: 'MontserratMedium',
                              ),
                            ),
                            Text(
                              "${DateTime.now().year} OculaCare All Rights Reserved.",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'MontserratMedium',
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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

class MoreTab extends StatelessWidget {
  const MoreTab({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });
  final dynamic icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(icon),
          SizedBox(
            width: 10.w,
          ),
          FittedBox(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

Widget divider() {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10),
    child: Divider(
      height: 0.2,
      color: Colors.grey.withOpacity(0.2),
    ),
  );
}
