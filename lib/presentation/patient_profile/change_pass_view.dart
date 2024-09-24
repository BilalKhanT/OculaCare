import 'package:OculaCare/configs/utils/utils.dart';
import 'package:OculaCare/logic/patient_profile/pass_cubit.dart';
import 'package:OculaCare/logic/patient_profile/pass_state.dart';
import 'package:OculaCare/presentation/widgets/btn_flat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../configs/presentation/constants/colors.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../widgets/cstm_text_field.dart';

class ChangePassView extends StatelessWidget {
  const ChangePassView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final formKey = GlobalKey<FormState>();
    return PopScope(
      canPop: false,
      child: Container(
        height: screenHeight * 0.55,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: AppColors.screenBackground,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    context.read<PassCubit>().clearAll();
                    context.pop();
                  },
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Colors.redAccent,
                    size: 40.0,
                  ),
                ),
              ],
            ),
            Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Password',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    CustomTextField(
                      hintText: 'Enter Password',
                      focusNode: context.read<PassCubit>().passFocus,
                      obscureText: false,
                      controller: context.read<PassCubit>().passController,
                      editable: true,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        if (value == sharedPrefs.password) {
                          return 'Please enter a new password';
                        }
                        String pattern =
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])[A-Za-z\d\W]{6,}$';
                        RegExp regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                          return 'Password must include upper and lower case letters, digits, and . or _';
                        }
                        context.read<PassCubit>().passController.text = value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Text(
                      'Confirm Password',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    CustomTextField(
                      hintText: 'Confirm Password',
                      focusNode: context.read<PassCubit>().conPassFocus,
                      obscureText: false,
                      controller: context.read<PassCubit>().conPassController,
                      editable: true,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value !=
                            context
                                .read<PassCubit>()
                                .passController
                                .text
                                .trim()) {
                          return 'Passwords do not match';
                        }
                        context.read<PassCubit>().conPassController.text =
                            value;
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenHeight * 0.05,
                    ),
                    BlocBuilder<PassCubit, PassState>(
                      builder: (context, state) {
                        if (state is PassLoading) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.appColor,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ButtonFlat(
                              textColor: Colors.white,
                              onPress: () async {
                                if (formKey.currentState!.validate()) {
                                  bool flag = await context
                                      .read<PassCubit>()
                                      .updatePassword();
                                  if (context.mounted) {
                                    if (flag) {
                                      AppUtils.showToast(
                                          context,
                                          'Password Updated',
                                          'Your password has been successfully updated',
                                          false);
                                    } else {
                                      AppUtils.showToast(
                                          context,
                                          'Password Error',
                                          'Something went wrong, please try again',
                                          true);
                                    }
                                  }
                                }
                              },
                              text: 'Update Password',
                              btnColor: AppColors.appColor),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
