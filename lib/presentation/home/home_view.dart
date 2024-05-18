import 'package:OculaCare/presentation/home/widgets/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';
import 'package:lottie/lottie.dart';

import '../../configs/presentation/constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 65.0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: const Center(
              child: Icon(
                Icons.person_2_outlined,
                color: Colors.white,
                size: 30.0,
              ),
            ),
          ),
        ),
      ),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome!",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('Bilal Khan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.appColor,
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                width: screenWidth,
                height: screenHeight / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(1, 1),
                      blurRadius: 10,
                      color: const Color(0xFFD3D3D3).withOpacity(.99),
                    ),
                  ],
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Lottie.asset(
                      'assets/lotties/eye_scan.json', // Replace 'assets/your_animation.json' with the path to your Lottie animation JSON file
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              customWidget(
                icon: Icons.camera_alt_outlined,
                text: "Capture Image for Detection.",
                onTap: () {
                  context.read<ImageCaptureCubit>().initializeCamera();
                  context.go(RouteNames.imgCaptureRoute);
                },
              ),
              const SizedBox(height: 40,),
              customWidget(
                icon: Icons.receipt_outlined,
                text: "View Detection Results.",
                onTap: () {
                  context.go(RouteNames.resultRoute);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
