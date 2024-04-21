import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInitial());

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  bool passwordToggle = false;
  bool passwordToggle2 = false;

  dispose() {
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  togglePasswordVisibility() {
    passwordToggle = !passwordToggle;
  }

  togglePasswordVisibility2() {
    passwordToggle2 = !passwordToggle2;
  }

  loadSignUpScreen() {
    emit(SignUpStateLoaded());
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {

    }
  }
}