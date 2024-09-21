import 'dart:io';
import 'dart:ui';
import 'package:OculaCare/presentation/widgets/cstm_loader.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/image_capture/img_capture_cubit.dart';
import 'package:OculaCare/logic/image_capture/img_capture_state.dart';
import 'package:OculaCare/presentation/sign_up/widgets/cstm_flat_btn.dart';
import 'package:image_picker/image_picker.dart';
import '../../configs/utils/utils.dart';
import '../widgets/border_painter.dart';

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
        body: SizedBox(
          height: height,
          width: width,
          child: BlocBuilder<ImageCaptureCubit, ImageCaptureState>(
            builder: (context, state) {
              if (state is ImageCaptureStateLoading) {
                return const Center(
                  child: DotLoader(
                    loaderColor: AppColors.appColor,
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
                return camera.value.isInitialized == true
                    ? Stack(
                        children: [
                          SizedBox(
                            height: height,
                            width: width,
                            child: AspectRatio(
                              aspectRatio: camera.value.aspectRatio,
                              child: CameraPreview(camera),
                            ),
                          ),
                          Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 50.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          await context
                                              .read<ImageCaptureCubit>()
                                              .dispose();
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.25),
                                Expanded(
                                  child: Column(
                                    children: [
                                      CustomPaint(
                                        foregroundPainter: BorderPainter(),
                                        child: SizedBox(
                                          width: width * 0.75,
                                          height: height * 0.175,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                disable == true
                                    ? Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10),
                                              child: Text(
                                                state.status == 1
                                                    ? ' No Face Detected'
                                                    : 'Please place eyes within camera frame',
                                                style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  fontFamily:
                                                      'MontserratMedium',
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.1,
                                          ),
                                        ],
                                      )
                                    : const SizedBox.shrink(),
                                ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 35.0, vertical: 13.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  context
                                                      .read<ImageCaptureCubit>()
                                                      .dispose();
                                                  if (context.mounted) {
                                                    context.go(
                                                        RouteNames.homeRoute);
                                                  }
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0.0),
                                                      child: SvgPicture.asset(
                                                        'assets/svgs/trial2.svg',
                                                        // ignore: deprecated_member_use
                                                        color: Colors.white,
                                                        height: height * 0.045,
                                                        width: height * 0.045,
                                                      ),
                                                    ))),
                                            disable
                                                ? Container(
                                                    height: 70,
                                                    width: 70,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 3.0,
                                                          color: Colors.white),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    child: Center(
                                                      child: Container(
                                                        height: 65,
                                                        width: 65,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.0),
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<
                                                              ImageCaptureCubit>()
                                                          .captureEyeImage();
                                                    },
                                                    child: Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 3.0,
                                                            color:
                                                                Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50.0),
                                                      ),
                                                      child: Center(
                                                        child: Container(
                                                          height: 65,
                                                          width: 65,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50.0),
                                                            color: AppColors
                                                                .appColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                            GestureDetector(
                                              onTap: () async {
                                                final pickedFile =
                                                    await ImagePicker()
                                                        .pickImage(
                                                  source: ImageSource.gallery,
                                                  maxWidth: 1800,
                                                  maxHeight: 1800,
                                                  imageQuality: 85,
                                                );
                                                if (pickedFile != null &&
                                                    context.mounted) {
                                                  context
                                                      .read<ImageCaptureCubit>()
                                                      .uploadEyeImage(
                                                          pickedFile);
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: SvgPicture.asset(
                                                    'assets/svgs/camera_img.svg',
                                                    // ignore: deprecated_member_use
                                                    color: Colors.white,
                                                    height: height * 0.045,
                                                    width: height * 0.045,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.appColor,
                        ),
                      );
              } else if (state is ImagesCropped) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ImageCaptureCubit>()
                                    .switchButtonLeft(
                                        state.leftEye,
                                        state.rightEye,
                                        !state.leftOpen,
                                        state.rightOpen);
                              },
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(1, 3),
                                        blurRadius: 20,
                                        color: const Color(0xFFD3D3D3)
                                            .withOpacity(.99),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  'Left Eye',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: AppColors.appColor,
                                              size: 40.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      state.leftOpen == true
                                          ? Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 10.0),
                                                  child: Image.file(
                                                    File(state.leftEye.path),
                                                    height: 150,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20.0),
                                                    child: CustomFlatButton(
                                                      onTap: () async {
                                                        bool flag = await context
                                                            .read<
                                                                ImageCaptureCubit>()
                                                            .downloadFile(
                                                                state.leftEye
                                                                    .path,
                                                                'image');
                                                        if (context.mounted) {
                                                          AppUtils.showToast(
                                                              context,
                                                              flag
                                                                  ? 'Success'
                                                                  : 'Failed',
                                                              flag
                                                                  ? 'File downloaded successfully'
                                                                  : 'Failed to download file',
                                                              !flag);
                                                        }
                                                      },
                                                      text: 'Download',
                                                      btnColor:
                                                          AppColors.appColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<ImageCaptureCubit>()
                                    .switchButtonRight(
                                        state.leftEye,
                                        state.rightEye,
                                        state.leftOpen,
                                        !state.rightOpen);
                              },
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(1, 3),
                                        blurRadius: 20,
                                        color: const Color(0xFFD3D3D3)
                                            .withOpacity(.99),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.appColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                  ),
                                                  child: const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 15.0,
                                                ),
                                                Text(
                                                  'Right Eye',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: AppColors.appColor,
                                              size: 40.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      state.rightOpen == true
                                          ? Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 10.0),
                                                  child: Image.file(
                                                    File(state.rightEye.path),
                                                    height: 150,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20.0),
                                                    child: CustomFlatButton(
                                                      onTap: () async {
                                                        bool flag = await context
                                                            .read<
                                                                ImageCaptureCubit>()
                                                            .downloadFile(
                                                                state.rightEye
                                                                    .path,
                                                                'image');
                                                        if (context.mounted) {
                                                          AppUtils.showToast(
                                                              context,
                                                              flag
                                                                  ? 'Success'
                                                                  : 'Failed',
                                                              flag
                                                                  ? 'File downloaded successfully'
                                                                  : 'Failed to download file',
                                                              !flag);
                                                        }
                                                      },
                                                      text: 'Download',
                                                      btnColor:
                                                          AppColors.appColor,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 60,
                                width: width - ((width / 2) + 30),
                                child: CustomFlatButton(
                                  onTap: () {
                                    context
                                        .read<ImageCaptureCubit>()
                                        .initializeCamera();
                                  },
                                  text: 'Recapture',
                                  btnColor: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              SizedBox(
                                height: 60,
                                width: width - ((width / 2) + 30),
                                child: CustomFlatButton(
                                  onTap: () {
                                    context
                                        .read<ImageCaptureCubit>()
                                        .uploadImageToServer(
                                            state.leftEye, state.rightEye);
                                    AppUtils.showToast(
                                        context,
                                        'Upload Successful',
                                        'Image uploaded to the server successfully please check results tab.',
                                        false);
                                  },
                                  text: 'Upload',
                                  btnColor: AppColors.appColor,
                                ),
                              ),
                            ],
                          ),
                        ),
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
