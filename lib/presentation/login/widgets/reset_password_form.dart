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
            TextFormField(
              controller: loginCubit.passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.appColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // loginCubit.togglePasswordVisibility();
                  },
                  icon: const Icon(Icons.visibility,
                    color: AppColors.appColor,
                  ),
                ),
                hintText: 'Password',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
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
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                String pattern =
                    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[._])[A-Za-z._\d]{6,}$';
                RegExp regExp = RegExp(pattern);
                if (!regExp.hasMatch(value)) {
                  return 'Password must include upper and lower case letters, digits, and . or _';
                }
                loginCubit.passwordController.text = value;
                return null;
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.appColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                        Icons.visibility_off,
                    color: AppColors.appColor,
                  ),
                ),
                hintText: 'Confirm Password',
                hintStyle: TextStyle(
                  fontFamily: 'Poppins',
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
                fontFamily: 'Poppins',
                fontSize: 16.sp,
                color: Colors.black,
                letterSpacing: 1.0,
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (loginCubit.passwordController.text != value) {
                  return 'Passwords do not match';
                }
                loginCubit.passwordController.text.toString();
                return null;
              },
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            CustomFlatButton(
              onTap: () async {
                bool flag = await loginCubit.submitForm(formKey);
                if (flag) {
                  print('Success');
                } else {
                  print('FUCK HGYA');
                }
              },
              text: 'Submit Email',
              btnColor: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }
}
