import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';
import 'package:OculaCare/logic/image_capture/img_capture_state.dart';
import 'package:OculaCare/presentation/sign_up/widgets/cstm_flat_btn.dart';
import 'package:image_picker/image_picker.dart';
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
            onPressed: () async {
              await context.read<ImageCaptureCubit>().dispose();
              if (context.mounted) {
                context.go(RouteNames.homeRoute);
              }
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
                          disable == true
                              ? Text(
                                  state.status == 1
                                      ? ' No Face Detected'
                                      : 'Please place eyes with in camera frame',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontFamily: 'Poppins',
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : const SizedBox.shrink(),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 20.0),
                              child: Row(
                                children: [
                                  disable
                                      ? Expanded(
                                          child: CustomFlatButton(
                                            onTap: () {},
                                            text: 'Disabled',
                                            btnColor: Colors.grey,
                                          ),
                                        )
                                      : Expanded(
                                          child: CustomFlatButton(
                                            onTap: () {
                                              context
                                                  .read<ImageCaptureCubit>()
                                                  .captureEyeImage();
                                            },
                                            text: 'Capture',
                                            btnColor: AppColors.appColor,
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final pickedFile =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.gallery,
                                        maxWidth: 1800,
                                        maxHeight: 1800,
                                        imageQuality: 85,
                                      );
                                      if (context.mounted) {
                                        context
                                            .read<ImageCaptureCubit>()
                                            .uploadEyeImage(pickedFile!);
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.image_outlined,
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                );
              } else if (state is ImagesCropped) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Left Eye',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Image.file(
                              File(state.leftEye.path),
                              height: 150,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Right Eye',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Center(
                            child: Image.file(
                              File(state.rightEye.path),
                              height: 150,
                            ),
                          ),
                          const SizedBox(height: 150.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CustomFlatButton(
                                  onTap: () {},
                                  text: 'Recapture',
                                  btnColor: AppColors.appColor,
                                ),
                              ),
                              const SizedBox(width: 10.0,),
                              Expanded(
                                child: CustomFlatButton(
                                  onTap: () {},
                                  text: 'Upload',
                                  btnColor: AppColors.appColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
