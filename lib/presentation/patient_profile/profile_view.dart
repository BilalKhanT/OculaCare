import 'dart:io';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:OculaCare/logic/patient_profile/upload_profile_photo_state.dart';
import 'package:OculaCare/presentation/patient_profile/widgets/gender_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../logic/patient_profile/upload_profile_photo_cubit.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w800,
              fontSize: 18.sp,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              context.go(RouteNames.moreRoute);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.appColor,
            ),
          ),
        ),
        body: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: BlocBuilder<PatientProfileCubit, PatientProfileState>(
                builder: (context, state) {
              if (state is PatientProfileStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.appColor,
                  ),
                );
              } else if (state is PatientProfileStateSetUp) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BlocBuilder<UploadProfilePhotoCubit,
                          UploadProfilePhotoState>(
                        builder: (context, state) {
                          return Center(
                            child: context
                                        .read<UploadProfilePhotoCubit>()
                                        .image !=
                                    null
                                ? GestureDetector(
                                    onTap: () async {
                                      context
                                          .read<UploadProfilePhotoCubit>()
                                          .uploadPhoto();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppColors.appColor.withOpacity(0.2),
                                      radius: 80.h,
                                      backgroundImage: context
                                                  .read<
                                                      UploadProfilePhotoCubit>()
                                                  .image !=
                                              null
                                          ? FileImage(File(context
                                              .read<UploadProfilePhotoCubit>()
                                              .image!
                                              .path))
                                          : null,
                                      child: context
                                                  .read<
                                                      UploadProfilePhotoCubit>()
                                                  .image ==
                                              null
                                          ? const Icon(Icons.person,
                                              color: Colors.white, size: 50)
                                          : null,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      context
                                          .read<UploadProfilePhotoCubit>()
                                          .uploadPhoto();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor:
                                          AppColors.appColor.withOpacity(0.2),
                                      radius: 80.h,
                                      child: const Icon(Icons.person,
                                          color: Colors.white, size: 50),
                                    ),
                                  ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Gender',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 20.sp,
                        ),
                      ),
                      const GenderRow(),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Address',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is PatientProfileStateLoaded) {
                return const SizedBox.shrink();
              } else if (state is PatientProfileStateFailure) {
                return Center(
                  child: Text(
                    state.errorMsg,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),
    );
  }
}
