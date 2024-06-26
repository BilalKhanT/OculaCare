import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/logic/login_cubit/login_cubit.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_cubit.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_state.dart';
import 'package:OculaCare/presentation/sign_up/widgets/cstm_img_btn.dart';
import 'package:OculaCare/presentation/sign_up/widgets/sign_up_form.dart';

import '../../configs/presentation/constants/colors.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        leading: IconButton(
          onPressed: () {
            context.read<SignUpCubit>().dispose();
            context.push(RouteNames.homeRoute);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.appColor,
          ),
        ),
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
              if (state is SignUpStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SignUpStateFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is SignUpStateLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32.sp,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Create Your New Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      SignUpForm(
                        passVisible: state.passVisible,
                        confirmPassVisible: state.confirmPassvisible,
                      ),
                      Center(
                        child: Text(
                          'or',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w100,
                            color: AppColors.textGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'signup with',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w100,
                            color: AppColors.textGrey,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomImageButton(
                            onTap: () {},
                            imagePath: 'assets/images/googleIcon.png',
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          CustomImageButton(
                            onTap: () {},
                            imagePath: 'assets/images/fbIcon.png',
                          )
                        ],
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account.',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w100,
                              color: AppColors.textGrey,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {
                              context.read<LoginCubit>().loadLoginScreen();
                              context.push(RouteNames.loginRoute);
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.appColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ),
        ),
      ),
    );
  }
}
