import 'package:animate_do/animate_do.dart';
import 'package:cculacare/presentation/sign_up/widgets/cstm_img_btn.dart';
import 'package:cculacare/presentation/sign_up/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../logic/home_cubit/home_cubit.dart';
import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/sign_up_cubit/sign_up_cubit.dart';
import '../../logic/sign_up_cubit/sign_up_state.dart';
import '../widgets/cstm_loader.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key, required this.flow}) : super(key: key);

  final String flow;

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
              context.read<SignUpCubit>().dispose();
              if (flow == 'login') {
                context.go(RouteNames.loginRoute);
              } else if (flow == 'boarding') {
                context.go(RouteNames.onBoardingRoute);
              }
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
            child: BlocBuilder<SignUpCubit, SignUpState>(
                builder: (context, state) {
              if (state is SignUpStateLoading) {
                return const Center(
                  child: DotLoader(
                    loaderColor: AppColors.appColor,
                  ),
                );
              } else if (state is SignUpStateFailure) {
                return Center(
                  child: Text(state.errorMsg),
                );
              } else if (state is SignUpStateLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: 32.sp,
                              color: AppColors.appColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 600),
                          child: Text(
                            'Create Your New Account',
                            style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: 16.sp,
                              color: AppColors.textGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        FadeInDown(
                            duration: const Duration(milliseconds: 600),child: const SignUpForm()),
                        Center(
                          child: FadeInLeft(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w100,
                                color: AppColors.textGrey,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: FadeInLeft(
                            duration: const Duration(milliseconds: 600),
                            child: Text(
                              'signup with',
                              style: TextStyle(
                                fontFamily: 'MontserratMedium',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w100,
                                color: AppColors.textGrey,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        FadeInRight(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomImageButton(
                                onTap: () async {
                                  bool flag = await context
                                      .read<SignUpCubit>()
                                      .createUserWithGoogle();
                                  if (!flag && context.mounted) {
                                    AppUtils.showToast(
                                        context,
                                        'Email Already Registered',
                                        'Please use a different google account to register a new account',
                                        true);
                                  } else {
                                    if (context.mounted) {
                                      AppUtils.showToast(
                                          context,
                                          'Update Password',
                                          'Your account password has been set as \'******\', update it in profile',
                                          false);
                                      context.read<HomeCubit>().emitHomeAnimation();
                                      context.go(RouteNames.homeRoute);
                                    }
                                  }
                                },
                                imagePath: 'assets/images/googleIcon.png',
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              CustomImageButton(
                                onTap: () async {
                                  bool flag = await context
                                      .read<SignUpCubit>()
                                      .createUserWithFacebook();
                                  if (!flag && context.mounted) {
                                    AppUtils.showToast(
                                        context,
                                        'Email Already Registered',
                                        'Please use a different google account to register a new account',
                                        true);
                                  } else {
                                    if (context.mounted) {
                                      AppUtils.showToast(
                                          context,
                                          'Update Password',
                                          'Your account password has been set as \'******\', update it in profile',
                                          false);
                                      context.read<HomeCubit>().emitHomeAnimation();
                                      context.go(RouteNames.homeRoute);
                                    }
                                  }
                                },
                                imagePath: 'assets/images/fbIcon.png',
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account.',
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
                              InkWell(
                                onTap: () {
                                  context.read<LoginCubit>().loadLoginScreen();
                                  context.push(RouteNames.loginRoute);
                                },
                                child: Text(
                                  'Signin',
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
