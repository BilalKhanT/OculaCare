import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/login/widgets/forgot_password_form.dart';
import 'package:cculacare/presentation/login/widgets/login_form.dart';
import 'package:cculacare/presentation/login/widgets/reset_password_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../logic/home_cubit/home_cubit.dart';
import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/login_cubit/login_cubit_state.dart';
import '../../logic/sign_up_cubit/sign_up_cubit.dart';
import '../widgets/cstm_loader.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.screenBackground,
          leading: IconButton(
            onPressed: () {
              context.read<LoginCubit>().dispose();
              context.go(RouteNames.signUpRoute, extra: 'login');
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
            child: BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
              if (state is LoginFailure) {
                AppUtils.showToast(context, 'Invalid Login Credentials',
                    'Please enter valid login credentials', true);
              } else if (state is LoginSuccess) {
                context.read<HomeCubit>().emitHomeAnimation();
                context.go(RouteNames.homeRoute);
              }
            }, builder: (context, state) {
              if (state is LoginStateLoading) {
                return const Center(
                  child: DotLoader(
                    loaderColor: AppColors.appColor,
                  ),
                );
              } else if (state is LoginStateFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is LoginStateForgotPassword) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.3,
                        ),
                        Text(
                          'Reset Password',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontSize: 32.sp,
                            color: AppColors.appColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Enter Registered Email',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
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
                  ),
                );
              } else if (state is LoginStateResetPassword) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.3,
                        ),
                        Text(
                          'New Password',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontSize: 32.sp,
                            color: AppColors.appColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          'Enter New Password',
                          style: TextStyle(
                            fontFamily: 'MontserratMedium',
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
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: FadeInDown(
                          duration: const Duration(milliseconds: 600),
                          child: Image.asset(
                            "assets/images/logo_ocula_login.png",
                            height: screenHeight * 0.15,
                          ),
                        )),
                        Center(
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              'OculaCare',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontSize: 32.sp,
                                color: AppColors.appColor,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: 32.sp,
                              color: AppColors.appColor,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: 16.sp,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: const LoginForm()),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account.',
                                style: TextStyle(
                                  fontFamily: 'MontserratMedium',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w100,
                                  color: AppColors.textGrey,
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.read<SignUpCubit>().loadSignUpScreen();
                                  context.go(RouteNames.signUpRoute,
                                      extra: 'login');
                                },
                                child: Text(
                                  'Signup',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.appColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}
