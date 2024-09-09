import 'dart:convert';
import 'dart:io';
import 'package:OculaCare/configs/presentation/constants/colors.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_cubit.dart';
import 'package:OculaCare/logic/patient_profile/patient_profile_state.dart';
import 'package:OculaCare/logic/patient_profile/upload_profile_photo_state.dart';
import 'package:OculaCare/presentation/patient_profile/widgets/gender_row.dart';
import 'package:OculaCare/presentation/patient_profile/widgets/profile_list_tile.dart';
import 'package:OculaCare/presentation/widgets/btn_flat.dart';
import 'package:OculaCare/presentation/widgets/cstm_loader.dart';
import 'package:OculaCare/presentation/widgets/cstm_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../logic/location_cubit/location_cubit.dart';
import '../../logic/patient_profile/gender_cubit.dart';
import '../../logic/patient_profile/upload_profile_photo_cubit.dart';
import '../sign_up/widgets/cstm_flat_btn.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKeyA = GlobalKey<FormState>();
    final formKeyB = GlobalKey<FormState>();
    double screenHeight = MediaQuery.sizeOf(context).height;
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
                    const GenderRow(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Form(
                      key: formKeyA,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w800,
                              fontSize: 20.sp,
                            ),
                          ),
                          TextFormField(
                            controller: context
                                .read<PatientProfileCubit>()
                                .ageController,
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_clock),
                              suffixIcon: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: screenHeight * 0.2),
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
                                        child: Text(
                                          (index + 18).toString(),
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                          ),
                                        ),
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
                                borderSide:
                                    BorderSide(color: AppColors.appColor),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select age';
                              }
                              return null;
                            },
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
                            controller: context
                                .read<PatientProfileCubit>()
                                .addressController,
                            readOnly: true,
                            decoration: InputDecoration(
                              prefixIcon:
                                  const Icon(Icons.location_on_outlined),
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
                                borderSide:
                                    BorderSide(color: AppColors.appColor),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
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
                          TextFormField(
                            keyboardType: TextInputType.number,
                            maxLines: 1,
                            controller: context
                                .read<PatientProfileCubit>()
                                .phoneController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.phone_outlined),
                              hintText: 'Enter Contact Number',
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w100,
                                color: AppColors.textGrey,
                                letterSpacing: 1.0,
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.appColor),
                              ),
                            ),
                            validator: (value) {
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
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.sp,
                              color: Colors.black,
                              letterSpacing: 1.0,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // InternationalPhoneNumberInput(
                          //   textFieldController:
                          //       context.read<PatientProfileCubit>().phoneController,
                          //   maxLength: 9,
                          //   onInputChanged: (PhoneNumber number) {},
                          //   validator: (p0) {
                          //     if (p0?.isEmpty ?? false) {
                          //       return "";
                          //     }
                          //     return null;
                          //   },
                          //
                          //   countries: const ["PK"],
                          //   selectorTextStyle: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 18.sp,
                          //   ),
                          //   // isEnabled: false,
                          //   hintText: 'Enter your phone number',
                          //   textStyle: TextStyle(
                          //     fontSize: 18.sp,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          //   initialValue: PhoneNumber(isoCode: 'PK'),
                          // ),
                          SizedBox(
                            height: 50.h,
                          ),
                          CustomFlatButton(
                            onTap: () async {
                              if (formKeyA.currentState!.validate()) {
                                context
                                    .read<PatientProfileCubit>()
                                    .savePatientProfile(context);
                              }
                            },
                            text: 'Save',
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
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircleAvatar(
                        radius: 80.h,
                        backgroundImage:
                            MemoryImage(base64Decode(patient.profileImage!)),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
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
                      height: 30.h,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profileEmail.svg"),
                      title: 'Email',
                      value: patient.email!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/account.svg"),
                      title: 'Gender',
                      value: patient.gender!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profileAge.svg"),
                      title: 'Age',
                      value: patient.age.toString(),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ProfileListTile(
                      leading: SvgPicture.asset("assets/svgs/profilePhone.svg"),
                      title: 'Contact',
                      value: patient.contactNumber!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    ProfileListTile(
                      leading:
                          SvgPicture.asset("assets/svgs/profileAddress.svg"),
                      title: 'Address',
                      value: patient.address!.locationName!,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Divider(
                        height: 0.2,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: ButtonFlat(btnColor: Colors.black, textColor: Colors.white, onPress: () {
                        context
                            .read<GenderCubit>()
                            .setGender(patient.gender!);
                        context
                            .read<PatientProfileCubit>()
                            .emitEditProfile(
                            context,
                            patient.age.toString(),
                            patient.gender,
                            patient.address!.locationName.toString(),
                            patient.contactNumber!,
                            patient.profileImage!);
                      }, text: 'Edit Profile'),
                    )
                  ],
                ),
              ),
            );
          } else if (state is PatientProfileStateFailure) {
            return Center(
              child: Text(
                state.errorMsg,
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
                          child: CircleAvatar(
                            backgroundColor:
                                AppColors.appColor.withOpacity(0.2),
                            radius: 80.h,
                            backgroundImage: MemoryImage(base64Decode(image64)),
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
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      fontSize: 18.sp,
                    ),
                  ),
                  const GenderRow(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Form(
                    key: formKeyB,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        CustomTextField(hintText: '', focusNode: context
                            .read<PatientProfileCubit>()
                            .passwordFocusNode, obscureText: false, controller: context
                            .read<PatientProfileCubit>()
                            .updatePasswordController, editable: true),
                        // TextFormField(
                        //   maxLines: 1,
                        //   controller: context
                        //       .read<PatientProfileCubit>()
                        //       .updatePasswordController,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter a password';
                        //     }
                        //     if (value.length < 6) {
                        //       return 'Password must be at least 6 characters long';
                        //     }
                        //     if (value == sharedPrefs.password) {
                        //       return 'Please enter a new password';
                        //     }
                        //     String pattern =
                        //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])[A-Za-z\d\W]{6,}$';
                        //     RegExp regExp = RegExp(pattern);
                        //     if (!regExp.hasMatch(value)) {
                        //       return 'Password must include upper and lower case letters, digits, and . or _';
                        //     }
                        //     context
                        //         .read<PatientProfileCubit>()
                        //         .updatePasswordController
                        //         .text = value;
                        //     return null;
                        //   },
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(Icons.lock_outline_rounded),
                        //     hintStyle: TextStyle(
                        //       fontFamily: 'MontserratMedium',
                        //       fontSize: 16.sp,
                        //       fontWeight: FontWeight.w100,
                        //       color: AppColors.textGrey,
                        //       letterSpacing: 1.0,
                        //     ),
                        //     focusedBorder: const UnderlineInputBorder(
                        //       borderSide: BorderSide(color: AppColors.appColor),
                        //     ),
                        //   ),
                        //   style: TextStyle(
                        //     fontFamily: 'MontserratMedium',
                        //     fontSize: 16.sp,
                        //     color: Colors.black,
                        //     letterSpacing: 1.0,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Age',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        CustomTextField(hintText: '', focusNode: context
                            .read<PatientProfileCubit>()
                            .ageFocusNode, obscureText: false, controller: context
                            .read<PatientProfileCubit>()
                            .updateAgeController, editable: true),
                        // TextFormField(
                        //   controller: context
                        //       .read<PatientProfileCubit>()
                        //       .updateAgeController,
                        //   readOnly: true,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please select age';
                        //     }
                        //     context
                        //         .read<PatientProfileCubit>()
                        //         .updateAgeController
                        //         .text = value;
                        //     return null;
                        //   },
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(
                        //       Icons.lock_clock,
                        //     ),
                        //     suffixIcon: ConstrainedBox(
                        //       constraints:
                        //           BoxConstraints(maxHeight: screenHeight * 0.2),
                        //       child: PopupMenuButton<int>(
                        //         surfaceTintColor: Colors.white,
                        //         elevation: 3.0,
                        //         color: Colors.white,
                        //         offset: const Offset(1, 3),
                        //         icon: const Icon(
                        //           Icons.keyboard_arrow_down_rounded,
                        //           color: AppColors.appColor,
                        //           size: 40,
                        //         ),
                        //         onSelected: (int value) {
                        //           context
                        //               .read<PatientProfileCubit>()
                        //               .updateAgeController
                        //               .text = value.toString();
                        //         },
                        //         itemBuilder: (BuildContext context) {
                        //           return List<PopupMenuEntry<int>>.generate(
                        //             100,
                        //             (int index) => PopupMenuItem(
                        //               value: index + 18,
                        //               child: Text(
                        //                 (index + 18).toString(),
                        //                 style: TextStyle(
                        //                   fontFamily: 'MontserratMedium',
                        //                   fontSize: 18.sp,
                        //                   color: Colors.black,
                        //                 ),
                        //               ),
                        //             ),
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //     hintStyle: TextStyle(
                        //       fontFamily: 'MontserratMedium',
                        //       fontSize: 18.sp,
                        //       fontWeight: FontWeight.w100,
                        //       color: AppColors.textGrey,
                        //       letterSpacing: 1.0,
                        //     ),
                        //     focusedBorder: const UnderlineInputBorder(
                        //       borderSide: BorderSide(color: AppColors.appColor),
                        //     ),
                        //   ),
                        //   style: TextStyle(
                        //     fontFamily: 'MontserratMedium',
                        //     fontSize: 18.sp,
                        //     color: Colors.black,
                        //     letterSpacing: 1.0,
                        //   ),
                        // ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Address',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        CustomTextField(hintText: '', focusNode: context
                            .read<PatientProfileCubit>()
                            .addressFocusNode, obscureText: false, controller: context
                            .read<PatientProfileCubit>()
                            .updateAddressController, editable: true),
                        // TextFormField(
                        //   maxLines: 1,
                        //   controller: context
                        //       .read<PatientProfileCubit>()
                        //       .updateAddressController,
                        //   readOnly: true,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter address';
                        //     }
                        //     context
                        //         .read<PatientProfileCubit>()
                        //         .updateAddressController
                        //         .text = value;
                        //     return null;
                        //   },
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(Icons.location_on_outlined),
                        //     suffixIcon: IconButton(
                        //       onPressed: () {
                        //         context.read<LocationCubit>().setLocation();
                        //         context.push(RouteNames.locationRoute);
                        //       },
                        //       icon: const Icon(
                        //         Icons.add,
                        //         color: AppColors.appColor,
                        //         size: 30,
                        //       ),
                        //     ),
                        //     hintStyle: TextStyle(
                        //       fontFamily: 'MontserratMedium',
                        //       fontSize: 16.sp,
                        //       fontWeight: FontWeight.w100,
                        //       color: AppColors.textGrey,
                        //       letterSpacing: 1.0,
                        //     ),
                        //     focusedBorder: const UnderlineInputBorder(
                        //       borderSide: BorderSide(color: AppColors.appColor),
                        //     ),
                        //   ),
                        //   style: TextStyle(
                        //     fontFamily: 'MontserratMedium',
                        //     fontSize: 16.sp,
                        //     color: Colors.black,
                        //     letterSpacing: 1.0,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Contact',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            fontSize: 18.sp,
                          ),
                        ),
                        const SizedBox(height: 5.0,),
                        CustomTextField(hintText: '', focusNode: context
                            .read<PatientProfileCubit>()
                            .contactFocusNode, obscureText: false, controller: context
                            .read<PatientProfileCubit>()
                            .updateContactController, editable: true),
                        // TextFormField(
                        //   maxLines: 1,
                        //   controller: context
                        //       .read<PatientProfileCubit>()
                        //       .updateContactController,
                        //   keyboardType: TextInputType.number,
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please enter contact number';
                        //     }
                        //     final RegExp phoneRegExp =
                        //         RegExp(r'^(03|92)\d{9}$');
                        //     if (!phoneRegExp.hasMatch(value)) {
                        //       return 'Please enter a valid number';
                        //     }
                        //     context
                        //         .read<PatientProfileCubit>()
                        //         .updateContactController
                        //         .text = value;
                        //     return null;
                        //   },
                        //   decoration: InputDecoration(
                        //     prefixIcon: const Icon(Icons.phone_outlined),
                        //     hintStyle: TextStyle(
                        //       fontFamily: 'MontserratMedium',
                        //       fontSize: 16.sp,
                        //       fontWeight: FontWeight.w100,
                        //       color: AppColors.textGrey,
                        //       letterSpacing: 1.0,
                        //     ),
                        //     focusedBorder: const UnderlineInputBorder(
                        //       borderSide: BorderSide(color: AppColors.appColor),
                        //     ),
                        //   ),
                        //   style: TextStyle(
                        //     fontFamily: 'MontserratMedium',
                        //     fontSize: 16.sp,
                        //     color: Colors.black,
                        //     letterSpacing: 1.0,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: ButtonFlat(btnColor: Colors.black, textColor: Colors.white, onPress: () async {
                            if (formKeyB.currentState!.validate()) {
                              context.read<PatientProfileCubit>().editProfile(
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
                          }, text: 'Save Profile'),
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
