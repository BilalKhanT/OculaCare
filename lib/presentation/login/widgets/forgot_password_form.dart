
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../configs/routes/route_names.dart';
import '../../../logic/login_cubit/login_cubit.dart';
import '../../../logic/otp_cubit/otp_cubit.dart';
import '../../sign_up/widgets/cstm_flat_btn.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    final loginCubit = context.read<LoginCubit>();
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: loginCubit.recoveryEmailController,
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
                loginCubit.recoveryEmailController.text = value;
                return null;
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
                if (context.mounted) {
                  context.read<OtpCubit>().sendRecoveryOTP(loginCubit.recoveryEmailController.text.trim());
                  loginCubit.recoveryEmailController.clear();
                  context.push(RouteNames.otpRoute, extra: 'recover');
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
