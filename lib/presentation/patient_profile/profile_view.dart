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
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '../../logic/location_cubit/location_cubit.dart';
import '../../logic/patient_profile/gender_cubit.dart';
import '../../logic/patient_profile/upload_profile_photo_cubit.dart';
import '../sign_up/widgets/cstm_flat_btn.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w800,
            fontSize: 20.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BlocBuilder<UploadProfilePhotoCubit, UploadProfilePhotoState>(
                      builder: (context, state) {
                        return Center(
                          child: context.read<UploadProfilePhotoCubit>().image !=
                                  null
                              ? GestureDetector(
                                  onTap: () async {
                                    context
                                        .read<UploadProfilePhotoCubit>()
                                        .uploadPhoto(context);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        AppColors.appColor.withOpacity(0.2),
                                    radius: 80.h,
                                    backgroundImage: context
                                                .read<UploadProfilePhotoCubit>()
                                                .image !=
                                            null
                                        ? FileImage(File(context
                                            .read<UploadProfilePhotoCubit>()
                                            .image!
                                            .path))
                                        : null,
                                    child: context
                                                .read<UploadProfilePhotoCubit>()
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
                                        .uploadPhoto(context);
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
                    BlocProvider(
                      create: (_) => GenderCubit(),
                      child: const GenderRow(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'Age',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                    ),
                    TextFormField(
                      controller:
                      context.read<PatientProfileCubit>().ageController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_outline,
                          color: AppColors.appColor,
                        ),
                        suffixIcon: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: screenHeight * 0.2),
                          child: PopupMenuButton<int>(
                            surfaceTintColor: Colors.white,
                            elevation: 3.0,
                            color: Colors.white,
                            offset: const Offset(1, 3),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: AppColors.appColor,
                              size: 40,
                            ),
                            onSelected: (int value) {
                              context
                                  .read<PatientProfileCubit>()
                                  .ageController
                                  .text = value.toString();
                            },
                            itemBuilder: (BuildContext context) {
                              return List<PopupMenuEntry<int>>.generate(
                                100,
                                    (int index) => PopupMenuItem(
                                  value: index + 18,
                                  child: Text((index + 18).toString(),
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18.sp,
                                      color: Colors.black,
                                    ),),
                                ),
                              );
                            },
                          ),
                        ),
                        hintText: 'Select Age',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w100,
                          color: AppColors.textGrey,
                          letterSpacing: 1.0,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appColor),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18.sp,
                        color: Colors.black,
                        letterSpacing: 1.0,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      'Address',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                    ),
                    TextFormField(
                      maxLines: 1,
                      controller:
                          context.read<PatientProfileCubit>().addressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.appColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            context.read<LocationCubit>().setLocation();
                            context.push(RouteNames.locationRoute);
                          },
                          icon: const Icon(
                            Icons.add,
                            color: AppColors.appColor,
                            size: 30,
                          ),
                        ),
                        hintText: 'Add Address',
                        hintStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w100,
                          color: AppColors.textGrey,
                          letterSpacing: 1.0,
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.appColor),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        color: Colors.black,
                        letterSpacing: 1.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 20.sp,
                      ),
                    ),
                    InternationalPhoneNumberInput(
                      textFieldController:
                          context.read<PatientProfileCubit>().phoneController,
                      maxLength: 9,
                      onInputChanged: (PhoneNumber number) {},
                      validator: (p0) {
                        if (p0?.isEmpty ?? false) {
                          return "";
                        }
                        return null;
                      },
                
                      countries: const ["PK"],
                      selectorTextStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                      ),
                      // isEnabled: false,
                      hintText: 'Enter your phone number',
                      textStyle: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      initialValue: PhoneNumber(isoCode: 'PK'),
                    ),
                
                    SizedBox(
                      height: 50.h,
                    ),
                    CustomFlatButton(
                      onTap: () async {
                        context.read<PatientProfileCubit>().savePatientProfile();
                      },
                      text: 'Save',
                      btnColor: AppColors.appColor,
                    ),
                  ],
                ),
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
