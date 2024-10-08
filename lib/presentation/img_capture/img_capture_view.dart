import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:camera/camera.dart';
import 'package:cculacare/configs/global/app_globals.dart';
import 'package:cculacare/configs/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/utils/utils.dart';
import '../../logic/image_capture/img_capture_cubit.dart';
import '../../logic/image_capture/img_capture_state.dart';
import '../widgets/border_painter.dart';
import '../widgets/btn_flat.dart';
import '../widgets/cstm_loader.dart';

class ImageCaptureScreen extends StatelessWidget {
  final String modelFlag;
  const ImageCaptureScreen({Key? key, required this.modelFlag})
      : super(key: key);

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
          child: BlocConsumer<ImageCaptureCubit, ImageCaptureState>(
            listener: (context, state) async {
              if (state is ImageCaptureStateFailure) {
                AppUtils.showToast(context, 'Image Quality Error',
                    'Please upload a high quality image', true);
                await context.read<ImageCaptureCubit>().dispose();
                if (context.mounted) {
                  if (isHome) {
                    context.go(RouteNames.homeRoute);
                  } else if (isMore) {
                    context.go(RouteNames.moreRoute);
                  } else {
                    context.go(RouteNames.detectionRoute);
                  }
                }
              }
            },
            builder: (context, state) {
              if (state is ImageCaptureStateLoading) {
                return const Center(
                  child: DotLoader(
                    loaderColor: AppColors.appColor,
                  ),
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
                                            if (isHome) {
                                              context.go(RouteNames.homeRoute);
                                            } else {
                                              context.go(
                                                  RouteNames.detectionRoute);
                                            }
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
                                        sigmaX: 5.0, sigmaY: 5.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
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
                                                    if (isHome) {
                                                      context.go(
                                                          RouteNames.homeRoute);
                                                    } else if (isMore) {
                                                      context.go(
                                                          RouteNames.moreRoute);
                                                    } else {
                                                      context.go(RouteNames
                                                          .detectionRoute);
                                                    }
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
                return SafeArea(
                  child: Column(
                    children: [
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              context.read<ImageCaptureCubit>().dispose();
                              if (context.mounted) {
                                if (isHome) {
                                  context.go(RouteNames.homeRoute);
                                } else if (isMore) {
                                  context.go(RouteNames.moreRoute);
                                } else {
                                  context.go(RouteNames.detectionRoute);
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.appColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: height * 0.05,
                              ),
                              FadeInLeft(
                                duration: const Duration(milliseconds: 600),
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Left Eye',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'MontserratMedium',
                                                      fontSize: width * 0.05,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      bool flag = await context
                                                          .read<
                                                              ImageCaptureCubit>()
                                                          .downloadFile(
                                                              state
                                                                  .leftEye.path,
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
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Download Image',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'MontserratMedium',
                                                            fontSize:
                                                                width * 0.035,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .appColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: height * 0.003,
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: AppColors
                                                              .appColor,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: SizedBox(
                                                            height:
                                                                height * 0.3,
                                                            child: Image.file(
                                                              File(state.leftEye
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Image.file(
                                                    File(state.leftEye.path),
                                                    height: height * 0.1,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              FadeInRight(
                                duration: const Duration(milliseconds: 600),
                                child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0, vertical: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Right Eye',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'MontserratMedium',
                                                      fontSize: width * 0.05,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  GestureDetector(
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
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Download Image',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'MontserratMedium',
                                                            fontSize:
                                                                width * 0.035,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: AppColors
                                                                .appColor,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: height * 0.003,
                                                        ),
                                                        const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color: AppColors
                                                              .appColor,
                                                          size: 15,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return Dialog(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: SizedBox(
                                                            height:
                                                                height * 0.3,
                                                            child: Image.file(
                                                              File(state
                                                                  .rightEye
                                                                  .path),
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  child: Image.file(
                                                    File(state.rightEye.path),
                                                    height: height * 0.1,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              SizedBox(
                                height: height * 0.3,
                              ),
                              Column(
                                children: [
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: ButtonFlat(
                                        btnColor: AppColors.appColor,
                                        textColor: Colors.white,
                                        onPress: () async {
                                          context
                                              .read<ImageCaptureCubit>()
                                              .uploadImageToServer(
                                                  state.leftEye,
                                                  state.rightEye,
                                                  state.fullFace,
                                                  modelFlag);
                                        },
                                        text: 'Upload to Server'),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  FadeInUp(
                                    duration: const Duration(milliseconds: 600),
                                    child: ButtonFlat(
                                        btnColor: AppColors.secondaryBtnColor,
                                        textColor: Colors.white,
                                        onPress: () {
                                          context
                                              .read<ImageCaptureCubit>()
                                              .initializeCamera();
                                        },
                                        text: 'Recapture Image'),
                                  ),
                                ],
                              )
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
