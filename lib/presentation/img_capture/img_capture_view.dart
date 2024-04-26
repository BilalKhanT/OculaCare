import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ocula_care/configs/presentation/constants/colors.dart';
import 'package:ocula_care/configs/routes/route_names.dart';
import 'package:ocula_care/logic/image_capture/img_capture_cubit.dart';
import 'package:ocula_care/logic/image_capture/img_capture_state.dart';
import 'package:ocula_care/presentation/sign_up/widgets/cstm_flat_btn.dart';
import 'package:lottie/lottie.dart';

class ImageCaptureScreen extends StatelessWidget {
  const ImageCaptureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.screenBackground,
          leading: IconButton(
            onPressed: () {
              context.read<ImageCaptureCubit>().dispose();
              context.go(RouteNames.homeRoute);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.appColor,
            ),
          ),
        ),
        body: SizedBox(
          height: height,
          width: width,
          child: BlocBuilder<ImageCaptureCubit, ImageCaptureState>(
            builder: (context, state) {
              if (state is ImageCaptureStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appColor,
                  ),
                );
              } else if (state is ImageCaptureStateFailure) {
                return Center(
                  child: Text(state.message),
                );
              } else if (state is ImageCaptureStateLoaded) {
                bool disable = state.disable;
                CameraController camera =
                    context.read<ImageCaptureCubit>().cameraController;
                return Stack(
                  children: [
                    SizedBox(
                      height: height,
                      width: width,
                      child: CameraPreview(
                        camera,
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          Expanded(
                            child: Lottie.asset(
                              "assets/lotties/face_scan.json",
                              repeat: true,
                            ),
                          ),
                          disable == true ? Text(state.status == 1 ? ' No Face Detected' : 'Please place eyes with in camera frame',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),) : const SizedBox.shrink(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                            child: disable ? CustomFlatButton(onTap: () {}, text: 'Disabled') : CustomFlatButton(onTap: () {}, text: 'Capture'),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}
