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
    return PopScope(
      canPop: false,
      child: Scaffold(
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


              ],
            ),
          ),
        ),
      ),
    );
  }
}
