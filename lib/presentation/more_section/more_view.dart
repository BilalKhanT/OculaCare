import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';
import 'package:OculaCare/logic/login_cubit/login_cubit.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/pdf_cubit/pdf_cubit_state.dart';
import '../widgets/need_to_setup_profile_widget.dart';


class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
                child: Padding(
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
                                    fontFamily: "Poppins",
                                    color: AppColors.appColor,
                                    fontWeight: FontWeight.bold,
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
                                      child:
                                      Image.asset("assets/images/eye_leaflet.jpg")),
                                ),
                              )
                            ]),
                      ),
                      Container(
                        color: AppColors.appColor.withOpacity(0.2),
                        padding: const EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: () {
                            if (!sharedPrefs.isProfileSetup) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const Dialog(child: NeedToSetupProfileWidget());
                                },
                              );
                              return;
                            }
                            context.read<ImageCaptureCubit>().initializeCamera();
                            context.push(RouteNames.imgCaptureRoute);
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
                                      SizedBox(width: 5.w,),
                                      Text('Scan&Detect',
                                      style: TextStyle(
                                        color: AppColors.appColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                      ),),
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
                                      fontFamily: 'Poppins',
                                    ),
                                  )
                                ],
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
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            MoreTab(
                              text: "Account",
                              icon: "assets/svgs/account.svg",
                              onTap: () {
                                context.read<PatientProfileCubit>().loadPatientProfile('eee');
                                context.push(RouteNames.profileRoute);
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Address Book",
                              icon: "assets/svgs/bookmark_hospital.svg",
                              onTap: () {

                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Explore Eye Hospitals",
                              icon: "assets/svgs/charm_search.svg",
                              onTap: () {
                                if (!sharedPrefs.isLoggedIn) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Dialog(child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  // context.push(RouteNames.addPaymentMethod);
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
                                      return const Dialog(child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  // context.push(RouteNames);
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
                                      return const Dialog(child: NeedToSetupProfileWidget());
                                    },
                                  );
                                  return;
                                } else {
                                  context.push(RouteNames.resultRoute);
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
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            MoreTab(
                              text: "FAQs",
                              icon: "assets/svgs/faq.svg",
                              onTap: () async {
                                // const url =
                                //     "https://almeeraloyalty.com/portal/Index.aspx?MenuId=6&LanguageId=1";
                                // Uri faqLaunchUrl = Uri.parse(
                                //   url,
                                // );
                                // if (await canLaunchUrl(faqLaunchUrl)) {
                                //   await launchUrl(faqLaunchUrl);
                                // }
                              },
                            ),
                            divider(),
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
                              onTap: () {
                                // context.push(RouteNames.partnerRoute);
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Terms and Conditions",
                              icon: "assets/svgs/terms-and-conditions.svg",
                              onTap: () async {
                                // const url =
                                //     "https://almeeraloyalty.com/portal/Index.aspx?MenuId=6&LanguageId=1";
                                // Uri tcLaunchUrl = Uri.parse(
                                //   url,
                                // );
                                // if (await canLaunchUrl(tcLaunchUrl)) {
                                //   await launchUrl(tcLaunchUrl);
                                // }
                              },
                            ),
                            divider(),
                            MoreTab(
                              text: "Privacy Policy",
                              icon: "assets/svgs/privacy-policy.svg",
                              onTap: () async {
                                // const url =
                                //     "https://almeeraloyalty.com/portal/Index.aspx?MenuId=15";
                                // Uri privacyPolicyLaunchUrl = Uri.parse(
                                //   url,
                                // );
                                // if (await canLaunchUrl(privacyPolicyLaunchUrl)) {
                                //   await launchUrl(privacyPolicyLaunchUrl);
                                // }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      sharedPrefs.isLoggedIn ?
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.h,
                          ),
                          padding:
                          EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: MoreTab(
                            text: "Logout",
                            icon: "assets/svgs/log_out.svg",
                            onTap: () {
                              sharedPrefs.isLoggedIn = false;
                              context.go(RouteNames.loginRoute);
                            },
                          ),
                        ) : Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20.h,
                        ),
                        padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: MoreTab(
                          text: "Logout",
                          icon: "assets/svgs/log_out.svg",
                          onTap: () {
                            sharedPrefs.isLoggedIn = false;
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
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              "${DateTime.now().year} OculaCare All Rights Reserved.",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
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
                fontFamily: "Poppins",
                fontSize: 15.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
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
    padding: EdgeInsets.symmetric(vertical: 15.h),
    child: Divider(
      height: 0.2,
      color: Colors.grey.withOpacity(0.2),
    ),
  );
}
