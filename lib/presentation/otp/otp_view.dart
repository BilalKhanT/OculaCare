import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:pinput/pinput.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../configs/routes/route_names.dart';
import '../../configs/utils/utils.dart';
import '../../logic/login_cubit/login_cubit.dart';
import '../../logic/otp_cubit/otp_cubit.dart';
import '../../logic/otp_cubit/otp_state.dart';
import '../sign_up/widgets/cstm_flat_btn.dart';
import '../widgets/cstm_loader.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key, required this.flow}) : super(key: key);

  final String flow;

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
            context.pop();
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
        child: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpEmailExists) {
              AppUtils.showToast(context, 'Email Already Registered',
                  'Please use a different email to register', true);
              context.pop();
            } else if (state is InvalidEmail) {
              AppUtils.showToast(context, 'Email Doesn\'t Exists',
                  'Please enter valid email to register', true);
              context.pop();
            } else if (state is OtpEmailNotExists) {
              AppUtils.showToast(
                  context,
                  'Email Not Found',
                  'Please enter registered email to receive recovery OTP',
                  true);
              context.pop();
            } else if (state is LoadChangePasswordState) {
              AppUtils.showToast(context, 'OTP Verified',
                  'OTP has been successfully verified.', false);
              context.read<LoginCubit>().resetPassword();
              context.pushReplacement(RouteNames.loginRoute);
            } else if (state is Registered) {
              AppUtils.showToast(context, 'Account Registered Successfully',
                  'Your account has been registered, please login.', false);
              context.read<LoginCubit>().loadLoginScreen();
              context.pushReplacement(RouteNames.loginRoute);
            }
          },
          builder: (context, state) {
            if (state is OtpStateLoading) {
              return const Center(
                child: DotLoader(
                  loaderColor: AppColors.appColor,
                ),
              );
            } else if (state is OtpStateFailure) {
              return Center(
                child: Text(state.errorMsg),
              );
            } else if (state is OtpStateLoaded) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontFamily: 'MontserratMedium',
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: AppColors.appColor,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.03,
                  ),
                  Text(
                    'Enter the code sent to the email',
                    style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontSize: 16.sp,
                        color: Colors.grey.shade700),
                  ),
                  Text(
                    state.email,
                    style: TextStyle(
                        fontFamily: 'MontserratMedium',
                        fontSize: 16.sp,
                        color: Colors.grey.shade700),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Pinput(
                    mainAxisAlignment: MainAxisAlignment.center,
                    animationCurve: Curves.easeIn,
                    separatorBuilder: (index) => const SizedBox(width: 8),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      context.read<OtpCubit>().userOTP = value.toString();
                      return value == state.otp ? null : 'Pin is incorrect';
                    },
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomFlatButton(
                        onTap: () {
                          bool flag = context.read<OtpCubit>().verifyOtp();
                          if (!flag) {
                            AppUtils.showToast(context, 'Invalid OTP',
                                'Please enter the correct OTP', true);
                            return;
                          }
                          context.read<OtpCubit>().registerUser(flow);
                        },
                        text: 'Verify',
                        btnColor: AppColors.appColor),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Didn\'t receive code?',
                        style: TextStyle(
                            fontFamily: 'MontserratMedium',
                            fontSize: 16.sp,
                            color: Colors.grey.shade700),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          context
                              .read<OtpCubit>()
                              .resendOtp(flow, state.email, state.name);
                        },
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(
                              fontFamily: 'MontserratMedium',
                              fontSize: 16.sp,
                              color: AppColors.appColor),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
