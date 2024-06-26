import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:OculaCare/presentation/login/widgets/forgot_password_form.dart';
import 'package:OculaCare/presentation/login/widgets/login_form.dart';
import 'package:OculaCare/presentation/login/widgets/reset_password_form.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/login_cubit/login_cubit_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      // appBar: AppBar(
      //   leading: IconButton(
      //     onPressed: () {
      //       context.read<LoginCubit>().dispose();
      //       context.pop();
      //     },
      //     icon: const Icon(
      //       Icons.arrow_back_ios_new,
      //       color: AppColors.appColor,
      //     ),
      //   ),
      // ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
              if (state is LoginStateLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is LoginStateFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is LoginStateLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: Image.asset("assets/images/app_logo.png", height: screenHeight * 0.3,)),

                      Text(
                        'Login',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32.sp,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Welcome Back!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      LoginForm(
                        passVisible: state.passVisible,
                      ),
                      SizedBox(height: screenHeight * 0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t have an account.',
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
                          Text(
                            'Signup',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.appColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }else if(state is LoginStateForgotPassword){
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32.sp,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Enter Registered Email',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      const ForgotPasswordForm(),
                    ],
                  ),
                );
              }else if(state is LoginStateResetPassword){
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 32.sp,
                          color: AppColors.appColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        'Enter New Password',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          color: AppColors.textGrey,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      const ResetPasswordForm(),
                    ],
                  ),
                );
              }
              else {
                return const SizedBox.shrink();
              }
            }),
          ),
        ),
      ),
    );
  }
}
