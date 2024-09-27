import 'package:OculaCare/configs/utils/utils.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_pass_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/login_cubit/login_cubit.dart';
import '../../sign_up/widgets/cstm_flat_btn.dart';

class ResetPasswordForm extends StatelessWidget {
  const ResetPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    final formKey = GlobalKey<FormState>();
    final loginCubit = context.read<LoginCubit>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            BlocBuilder<SignUpPassCubit, SignUpPassState> (
              builder: (context, state) {
                return TextFormField(
                  controller: loginCubit.recoveryPassController,
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
                      icon: Icon(state is PasswordToggle && state.passVisible
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
                    String pattern =
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])[A-Za-z\d\W]{6,}$';
                    RegExp regExp = RegExp(pattern);
                    if (!regExp.hasMatch(value)) {
                      return 'Password must include upper and lower case letters, digits, and . or _';
                    }
                    loginCubit.passwordController.text = value;
                    return null;
                  },
                );
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            BlocBuilder<SignUpPassCubit, SignUpPassState> (
              builder: (context, state) {
                return TextFormField(
                  controller: loginCubit.recoveryConfirmPassController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.appColor,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        context
                            .read<SignUpPassCubit>()
                            .togglePasswordVisibility2();
                      },
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
                  obscureText: !(state is PasswordToggle && state.confirmPassVisible),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (loginCubit.passwordController.text != value) {
                      return 'Passwords do not match';
                    }
                    loginCubit.recoveryConfirmPassController.text = value;
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
                bool check = await loginCubit.submitForm(formKey);
                if (!check) {
                  return;
                }
                bool flag = await loginCubit.changePassword();
                if (flag && context.mounted) {
                  AppUtils.showToast(context, 'Password Changed Successfully', 'Your password has been changed successfully.', false);
                  context.read<LoginCubit>().loadLoginScreen();
                } else {
                  if (context.mounted) {
                    AppUtils.showToast(
                        context, 'Server Error', 'Please try again later.',
                        true);
                  }
                }
              },
              text: 'Submit Password',
              btnColor: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }
}
