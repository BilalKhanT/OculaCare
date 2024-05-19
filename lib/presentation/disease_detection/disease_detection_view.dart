import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/image_capture/img_capture_cubit.dart';
import '../home/widgets/custom_widget.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final hour = DateTime.now().hour;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text( hour < 12 ? 'Good Morning' : 'Good Evening',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 27.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1,
                          ),
                        ),
                        Text('Bilal Khan',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset('assets/svgs/notifcation.svg', height: 35.h,),
                  ],
                ),
                SizedBox(height: 10.h,),
                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10.0),
                //     color: Colors.grey.shade200,
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                //     child: Center(
                //       child: Text('Utilize our advanced ML technology to analyze images of your eyes. Simply capture a photo, and our system will assess it for signs of eye diseases.',
                //         style: TextStyle(
                //           fontFamily: 'Poppins',
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w400,
                //         ),
                //         textAlign: TextAlign.justify,),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: screenWidth,
                  height: screenHeight / 4,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Lottie.asset(
                        'assets/lotties/eye_scan.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Text('Disease Detection',
                  style: TextStyle(
                    fontFamily: 'PoppinsBold',
                    fontSize: 24.sp,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20,),
                customWidget(
                  icon: SvgPicture.asset('assets/svgs/eye_scan.svg',
                    // ignore: deprecated_member_use
                    color: Colors.white,),
                  text: "Capture Image for Disease Detection.",
                  onTap: () {
                    if (sharedPrefs.isProfileSetup) {
                      context.read<ImageCaptureCubit>().initializeCamera();
                      context.push(RouteNames.imgCaptureRoute);
                    }
                    else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(child: NeedToSetupProfileWidget());
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 20,),
                customWidget(
                  icon: SvgPicture.asset('assets/svgs/detection_result.svg',
                    // ignore: deprecated_member_use
                    color: Colors.white,),
                  text: "View Disease Detection Results.",
                  onTap: () {
                    context.push(RouteNames.resultRoute);
                  },
                ),
                SizedBox(height: 40.h,),
                Center(
                  child: Text('Note: This is is an AI guided diagnosis, seek medical expertise for professional guidance.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.justify,),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
