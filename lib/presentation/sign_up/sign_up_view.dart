import 'package:OculaCare/configs/utils/utils.dart';
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
              }
              else if (flow == 'boarding') {
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
                    child: CircularProgressIndicator(color: AppColors.appColor,),
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
                          const SignUpForm(
                      
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
                                onTap: () async{
                                  bool flag = await context.read<SignUpCubit>().createUserWithGoogle();
                                  if (!flag) {
                                    AppUtils.showToast(context, 'Email Already Registered', 'Please use a different google account to register a new account', true);
                                  }
                                  else {
                                    AppUtils.showToast(context, 'Update Password', 'Your account password has been set as \'******\', update it in profile', false);
                                    context.go(RouteNames.homeRoute);
                                  }
                                },
                                imagePath: 'assets/images/googleIcon.png',
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              CustomImageButton(
                                onTap: () async {
                                  bool flag = await context.read<SignUpCubit>().createUserWithFacebook();
                                  if (!flag) {
                                    AppUtils.showToast(context, 'Email Already Registered', 'Please use a different google account to register a new account', true);
                                  }
                                  else {
                                    context.go(RouteNames.homeRoute);
                                  }
                                },
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
