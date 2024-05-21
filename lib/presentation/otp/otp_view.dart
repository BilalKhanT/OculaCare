import 'package:OculaCare/configs/routes/route_names.dart';
import 'package:OculaCare/configs/utils/utils.dart';
import 'package:OculaCare/presentation/sign_up/widgets/cstm_flat_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:OculaCare/logic/otp_cubit/otp_cubit.dart';
import 'package:OculaCare/logic/otp_cubit/otp_state.dart';
import 'package:pinput/pinput.dart';
import '../../configs/presentation/constants/colors.dart';
import '../../logic/login_cubit/login_cubit.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

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
              AppUtils.showToast(context, 'Email Already Registered', 'Please use a different email to register', true);
              context.pop();
            }
            else if (state is Registered) {
              AppUtils.showToast(context, 'Account Registered Successfully', 'Your account has been registered, please login.', false);
              context.read<LoginCubit>().loadLoginScreen();
              context.pushReplacement(RouteNames.loginRoute);
            }
          },
          builder: (context, state) {
            if (state is OtpStateLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appColor,
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
                      fontFamily: 'Poppins',
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
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        color: Colors.grey.shade700),
                  ),
                  Text(
                    state.email,
                    style: TextStyle(
                        fontFamily: 'Poppins',
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
                            AppUtils.showToast(context, 'Invalid OTP', 'Please enter the correct OTP', true);
                            return;
                          }
                          context.read<OtpCubit>().registerUser();
                        },
                        text: 'Verify',
                        btnColor: AppColors.appColor),
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
