import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/otp_cubit/otp_cubit.dart';
import '../../../logic/sign_up_cubit/sign_up_cubit.dart';
import '../../../logic/sign_up_cubit/sign_up_pass_cubit.dart';
import 'cstm_flat_btn.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double screenHeight = MediaQuery.sizeOf(context).height;
    final signUpCubit = context.read<SignUpCubit>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: signUpCubit.userNameController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: AppColors.appColor,
                ),
                hintText: 'Name',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
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
                fontFamily: 'MontserratMedium',
                fontSize: 16.sp,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                String pattern = r'^[a-zA-Z]+(?: [a-zA-Z]+)*$';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid username';
                }
                signUpCubit.userNameController.text = value;
                return null;
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            TextFormField(
              controller: signUpCubit.emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.mail_outline_outlined,
                  color: AppColors.appColor,
                ),
                hintText: 'Email',
                hintStyle: TextStyle(
                  fontFamily: 'Montserrat',
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
                fontFamily: 'MontserratMedium',
                fontSize: 16.sp,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                String pattern =
                    r'^[a-zA-Z0-9._%+-]{6,}@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                signUpCubit.emailController.text = value;
                return null;
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            BlocBuilder<SignUpPassCubit, SignUpPassState>(
              builder: (context, state) {
                return TextFormField(
                  controller: signUpCubit.passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.appColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<SignUpPassCubit>()
                            .togglePasswordVisibility();
                      },
                      icon: Icon(
                        state is PasswordToggle && state.passVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.appColor,
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
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
                    fontFamily: 'MontserratMedium',
                    fontSize: 16.sp,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                  obscureText: !(state is PasswordToggle && state.passVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }

                    bool hasUpperCase = value.contains(RegExp(r'[A-Z]'));
                    bool hasLowerCase = value.contains(RegExp(r'[a-z]'));
                    bool hasDigits = value.contains(RegExp(r'\d'));
                    bool hasSpecialCharacters = value.contains(RegExp(
                        r'[!@#\$&*~%^()_+=|<>?{}\[\]\/\\.,-]'));

                    if (!hasUpperCase) {
                      return 'Password must include at least one uppercase letter';
                    }
                    if (!hasLowerCase) {
                      return 'Password must include at least one lowercase letter';
                    }
                    if (!hasDigits) {
                      return 'Password must include at least one number';
                    }
                    if (!hasSpecialCharacters) {
                      return 'Password must include at least one special character';
                    }
                    signUpCubit.passwordController.text = value;
                    return null; // No validation errors
                  },
                );
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            BlocBuilder<SignUpPassCubit, SignUpPassState>(
              builder: (context, state) {
                return TextFormField(
                  controller: signUpCubit.confirmPassController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.appColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => context
                          .read<SignUpPassCubit>()
                          .togglePasswordVisibility2(),
                      icon: Icon(
                        state is PasswordToggle && state.confirmPassVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.appColor,
                      ),
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      fontFamily: 'Montserrat',
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
                    fontFamily: 'MontserratMedium',
                    fontSize: 16.sp,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                  obscureText:
                      !(state is PasswordToggle && state.confirmPassVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (signUpCubit.passwordController.text != value) {
                      return 'Passwords do not match';
                    }
                    signUpCubit.confirmPassController.text = value;
                    return null;
                  },
                );
              },
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            CustomFlatButton(
              onTap: () async {
                bool flag = await signUpCubit.submitForm(formKey);
                if (flag) {
                  if (context.mounted) {
                    context.read<OtpCubit>().sendOtp(
                        signUpCubit.emailController.text.trim(),
                        signUpCubit.userNameController.text.trim(),
                        signUpCubit.passwordController.text.trim());
                    context.read<SignUpCubit>().dispose();
                    context.push(RouteNames.otpRoute, extra: 'signup');
                  }
                }
              },
              text: 'Register',
              btnColor: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }
}
