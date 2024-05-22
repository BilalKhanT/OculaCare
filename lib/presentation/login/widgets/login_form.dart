
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:OculaCare/presentation/login/widgets/forgot_password_btn.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/login_cubit/login_cubit.dart';
import '../../../logic/login_cubit/login_pass_cubit.dart';
import '../../sign_up/widgets/cstm_flat_btn.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    double screenHeight = MediaQuery.sizeOf(context).height;
    final loginCubit = context.read<LoginCubit>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: loginCubit.emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.mail_outline_outlined,
                  color: AppColors.appColor,
                ),
                hintText: 'Email',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an email';
                }
                loginCubit.emailController.text = value;
                return null;
              },
            ),
            SizedBox(
              height: screenHeight * 0.01,
            ),
            BlocBuilder<LoginPassCubit, LoginPassState>(
                builder: (context, state) {
                  return TextFormField(
                    controller: loginCubit.passwordController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: AppColors.appColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.read<LoginPassCubit>().togglePasswordVisibility();
                        },
                        icon: Icon(
                          context.read<LoginPassCubit>().passwordToggle ? Icons.visibility_off : Icons.visibility,
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
                    obscureText: !context.read<LoginPassCubit>().passwordToggle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      loginCubit.passwordController.text = value;
                      return null;
                    },
                  );
                }),
            SizedBox(
              height: screenHeight * 0.03,
            ),
            ForgotPasswordBtn(
              onTap: () async {
                loginCubit.forgetPassword();
              },
              text: 'Forgot Password?',
            ),
            SizedBox(
              height: screenHeight * 0.05,
            ),
            CustomFlatButton(
              onTap: () async {
                bool flag = await loginCubit.submitForm(formKey);
                if (flag == true) {
                  await context.read<LoginCubit>().loginUser();
                }
              },
              text: 'Login',
              btnColor: AppColors.appColor,
            ),
          ],
        ),
      ),
    );
  }
}
