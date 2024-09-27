import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../logic/detection/detection_cubit.dart';
import '../../logic/image_capture/img_capture_cubit.dart';
import '../home/widgets/custom_widget.dart';
import '../widgets/need_to_setup_profile_widget.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'MontserratMedium',
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.05,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
                onTap: () => AppUtils.showToast(
                    context,
                    'Feature Under Development',
                    'Hold on as we build this feature',
                    false),
                child: SvgPicture.asset(
                  'assets/svgs/notifcation.svg',
                  height: 35.h,
                )),
          ),
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.h,
                ),
                const SizedBox(
                  height: 20,
                ),
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
                Text(
                  'Detect Disease',
                  style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontSize: 24.sp,
                      color: AppColors.appColor,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 20,
                ),
                customWidget(
                  title: 'Capture Image',
                  icon: SvgPicture.asset(
                    'assets/svgs/eye_scan.svg',
                    // ignore: deprecated_member_use
                    color: Colors.white,
                  ),
                  text: "Capture Image for Disease\nDetection.",
                  screenWidth: screenWidth,
                  onTap: () {
                    if (sharedPrefs.isProfileSetup) {
                      context.read<ImageCaptureCubit>().initializeCamera();
                      context.push(RouteNames.imgCaptureRoute);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Dialog(
                              child: NeedToSetupProfileWidget());
                        },
                      );
                    }
                  },
                  screenHeight: screenHeight,
                ),
                const SizedBox(
                  height: 20,
                ),
                customWidget(
                  title: 'Detection Results',
                  icon: SvgPicture.asset(
                    'assets/svgs/results.svg',
                    // ignore: deprecated_member_use
                    color: Colors.white,
                  ),
                  text: "View Disease Detection\nResults.",
                  screenWidth: screenWidth,
                  onTap: () {
                    context.read<DetectionCubit>().loadDiseaseResults();
                    context.push(RouteNames.resultRoute);
                  },
                  screenHeight: screenHeight,
                ),
                SizedBox(
                  height: 40.h,
                ),
                Center(
                  child: Text(
                    'Note: This is is an AI guided diagnosis, seek medical expertise for professional guidance.',
                    style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.justify,
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
