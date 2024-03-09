import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocula_care/presentation/login/widgets/login_form.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    var userController = TextEditingController();
    var passController = TextEditingController();

    return Scaffold(
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.h,),
                  SvgPicture.asset('assets/svgs/logo.svg', height: 150.w,),
                  Text("Welcome Back",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 24.sp,
                    ),),
                  Text("Sign in to your account",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                    ),),
                  LoginForm(userController: userController, passController: passController, formKey: formKey,),
                ],
              ),
            ),
          )),
    );
  }
}
