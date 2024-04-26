import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../configs/presentation/constants/colors.dart';
import '../../../logic/login_cubit/login_cubit.dart';
import '../../sign_up/widgets/cstm_flat_btn.dart';

class ForgotPasswordForm extends StatelessWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    final loginCubit = context.read<LoginCubit>();
    return Form(
      key: loginCubit.formKey,
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
              height: screenHeight * 0.05,
            ),
            CustomFlatButton(
              onTap: () async {
                loginCubit.resetPassword();
              },
              text: 'Submit Email',
            ),
          ],
        ),
      ),
    );
  }
}
