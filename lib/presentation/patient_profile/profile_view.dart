import 'dart:convert';
import 'dart:io';

import 'package:cculacare/configs/extension/extensions.dart';
import 'package:cculacare/presentation/patient_profile/widgets/gender_row.dart';
import 'package:cculacare/presentation/patient_profile/widgets/profile_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../logic/location_cubit/location_cubit.dart';
import '../../logic/patient_profile/gender_cubit.dart';
import '../../logic/patient_profile/patient_profile_cubit.dart';
import '../../logic/patient_profile/patient_profile_state.dart';
import '../../logic/patient_profile/upload_profile_photo_cubit.dart';
import '../../logic/patient_profile/upload_profile_photo_state.dart';
import '../widgets/btn_flat.dart';
import '../widgets/cstm_loader.dart';
import '../widgets/cstm_text_field.dart';
import 'change_pass_view.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKeyA = GlobalKey<FormState>();
    final formKeyB = GlobalKey<FormState>();
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        title: Text(
          'ACCOUNT DETAILS',
          style: TextStyle(
            fontFamily: 'MontserratMedium',
            color: AppColors.appColor,
            fontWeight: FontWeight.w800,
            fontSize: 18.sp,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.read<UploadProfilePhotoCubit>().dispose();
            context.read<PatientProfileCubit>().disposeEdit();
            context.read<GenderCubit>().dispose();
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
              child: DotLoader(
                loaderColor: AppColors.appColor,
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
                              : Stack(
                                  children: [
                                    GestureDetector(
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
                                    Positioned(
                                      bottom: 10,
                                      right: 10,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.appColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      'Gender',
                      style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontWeight: FontWeight.w800,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    const GenderRow(),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Form(
                      key: formKeyA,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          CustomTextField(
                            hintText: 'Enter Age',
                            focusNode:
                                context.read<PatientProfileCubit>().focusAge,
                            obscureText: false,
                            controller: context
                                .read<PatientProfileCubit>()
                                .ageController,
                            editable: true,
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter age';
                              }
                              final RegExp regex = RegExp(r'^[0-9]+$');
                              if (!regex.hasMatch(value)) {
                                return 'Age must be a valid number';
                              }
                              final int? age = int.tryParse(value);
                              if (age == null || age <= 0 || age > 120) {
                                return 'Please enter a valid age between 1 and 120';
                              }

                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Text(
                            'Address',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          SizedBox(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: TextFormField(
                                readOnly: true,
                                controller: context
                                    .read<PatientProfileCubit>()
                                    .addressController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter address';
                                  }
                                  return null;
                                },
                                focusNode: context
                                    .read<PatientProfileCubit>()
                                    .focusAdd,
                                cursorColor: AppColors.appColor,
                                style: context.appTheme.textTheme.labelMedium
                                    ?.copyWith(
                                        color: AppColors.secondaryText,
                                        fontSize:
                                            MediaQuery.sizeOf(context).width *
                                                0.04),
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        context
                                            .read<LocationCubit>()
                                            .setLocation();
                                        context.push(RouteNames.locationRoute);
                                      },
                                      icon: const Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.appColor,
                                      )),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: context
                                      .appTheme.textTheme.labelMedium
                                      ?.copyWith(
                                          color: context.appTheme.focusColor,
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  0.04),
                                  hintText: 'Set Address',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    top: MediaQuery.sizeOf(context).height *
                                        0.015,
                                    left: 20.w,
                                    bottom: MediaQuery.sizeOf(context).height *
                                        0.015,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.03,
                          ),
                          Text(
                            'Contact',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontWeight: FontWeight.w800,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          CustomTextField(
                            hintText: 'Enter Contact Number',
                            focusNode:
                                context.read<PatientProfileCubit>().focusPhone,
                            obscureText: false,
                            controller: context
                                .read<PatientProfileCubit>()
                                .phoneController,
                            editable: true,
                            validatorFunction: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact number';
                              }
                              final RegExp phoneRegExp =
                                  RegExp(r'^(03|92)\d{9}$');
                              if (!phoneRegExp.hasMatch(value)) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.05,
                          ),
                          ButtonFlat(
                            textColor: Colors.white,
                            onPress: () async {
                              if (formKeyA.currentState!.validate()) {
                                context
                                    .read<PatientProfileCubit>()
                                    .savePatientProfile(context);
                              }
                            },
                            text: 'Save Profile',
                            btnColor: AppColors.appColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is PatientProfileStateLoaded) {
            final patient = state.patientData;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: AppColors.appColor, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Container(
                            height: screenHeight * 0.2,
                            width: screenHeight * 0.2,
                            color: Colors.white,
                            child: Image.memory(
                              base64Decode(patient.profileImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Center(
                      child: Text(
                        patient.username!,
                        style: TextStyle(
                          fontFamily: 'MontserratMedium',
                          fontWeight: FontWeight.w800,
                          fontSize: 24.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profileEmail.svg"),
                      title: 'Email',
                      value: patient.email!,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/account.svg"),
                      title: 'Gender',
                      value: patient.gender!,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profileAge.svg"),
                      title: 'Age',
                      value: patient.age.toString(),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profilePhone.svg"),
                      title: 'Contact',
                      value: patient.contactNumber!,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    ProfileListTile(
                      leading:
                          SvgPicture.asset("assets/svgs/profileAddress.svg"),
                      title: 'Address',
                      value: patient.address!.locationName!,
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ButtonFlat(
                          btnColor: AppColors.appColor,
                          textColor: Colors.white,
                          onPress: () {
                            context
                                .read<GenderCubit>()
                                .setGender(patient.gender!);
                            context.read<PatientProfileCubit>().emitEditProfile(
                                context,
                                patient.age.toString(),
                                patient.gender,
                                patient.address!.locationName.toString(),
                                patient.contactNumber!,
                                patient.profileImage!,
                                patient.address!.lat!,
                                patient.address!.long!);
                          },
                          text: 'Edit Profile'),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ButtonFlat(
                          btnColor: AppColors.secondaryBtnColor,
                          textColor: Colors.white,
                          onPress: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              enableDrag: false,
                              isDismissible: false,
                              builder: (BuildContext bc) {
                                return const ChangePassView();
                              },
                            );
                          },
                          text: 'Change Password'),
                    )
                  ],
                ),
              ),
            );
          } else if (state is PatientProfileStateFailure) {
            return Center(
              child: Text(
                state.errorMsg,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w800,
                  fontSize: 18.sp,
                ),
              ),
            );
          } else if (state is PatientProfileStateEdit) {
            String image64 = state.image;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder<UploadProfilePhotoCubit, UploadProfilePhotoState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: () async {
                          String img = await context
                              .read<UploadProfilePhotoCubit>()
                              .changeProfilePhoto();
                          if (img != '') {
                            image64 = img;
                          }
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Container(
                                height: screenHeight * 0.2,
                                width: screenHeight * 0.2,
                                color: Colors.white,
                                child: Image.memory(
                                  base64Decode(image64),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  Text(
                    'Gender',
                    style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontWeight: FontWeight.w800,
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                  const GenderRow(),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Form(
                    key: formKeyB,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Age',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        CustomTextField(
                          hintText: '',
                          focusNode:
                              context.read<PatientProfileCubit>().ageFocusNode,
                          obscureText: false,
                          controller: context
                              .read<PatientProfileCubit>()
                              .updateAgeController,
                          editable: true,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select age';
                            }
                            context
                                .read<PatientProfileCubit>()
                                .updateAgeController
                                .text = value;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: TextFormField(
                              readOnly: true,
                              controller: context
                                  .read<PatientProfileCubit>()
                                  .updateAddressController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter address';
                                }
                                return null;
                              },
                              focusNode: context
                                  .read<PatientProfileCubit>()
                                  .addressFocusNode,
                              cursorColor: AppColors.appColor,
                              style: context.appTheme.textTheme.labelMedium
                                  ?.copyWith(
                                      color: AppColors.secondaryText,
                                      fontSize:
                                          MediaQuery.sizeOf(context).width *
                                              0.04),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      context
                                          .read<LocationCubit>()
                                          .setLocation();
                                      context.push(RouteNames.locationRoute);
                                    },
                                    icon: const Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.appColor,
                                    )),
                                fillColor: Colors.white,
                                filled: true,
                                hintStyle: context
                                    .appTheme.textTheme.labelMedium
                                    ?.copyWith(
                                        color: context.appTheme.focusColor,
                                        fontSize:
                                            MediaQuery.sizeOf(context).width *
                                                0.04),
                                hintText: 'Set Address',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  top:
                                      MediaQuery.sizeOf(context).height * 0.015,
                                  left: 20.w,
                                  bottom:
                                      MediaQuery.sizeOf(context).height * 0.015,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontWeight: FontWeight.w800,
                            fontSize: screenWidth * 0.045,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        CustomTextField(
                          hintText: '',
                          focusNode: context
                              .read<PatientProfileCubit>()
                              .contactFocusNode,
                          obscureText: false,
                          controller: context
                              .read<PatientProfileCubit>()
                              .updateContactController,
                          editable: true,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter contact number';
                            }
                            final RegExp phoneRegExp =
                                RegExp(r'^(03|92)\d{9}$');
                            if (!phoneRegExp.hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            context
                                .read<PatientProfileCubit>()
                                .updateContactController
                                .text = value;
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: ButtonFlat(
                              btnColor: AppColors.appColor,
                              textColor: Colors.white,
                              onPress: () async {
                                if (formKeyB.currentState!.validate()) {
                                  context
                                      .read<PatientProfileCubit>()
                                      .editProfile(
                                          context,
                                          context
                                              .read<PatientProfileCubit>()
                                              .updatePasswordController
                                              .text,
                                          image64,
                                          context
                                              .read<PatientProfileCubit>()
                                              .updateAgeController
                                              .text,
                                          context
                                              .read<PatientProfileCubit>()
                                              .updateContactController
                                              .text,
                                          context
                                              .read<PatientProfileCubit>()
                                              .updateAddressController
                                              .text);
                                }
                              },
                              text: 'Save Profile'),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
