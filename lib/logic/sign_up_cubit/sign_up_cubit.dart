import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_state.dart';

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
    emit(SignUpStateInitial());
    emit(SignUpStateLoaded(passwordToggle, passwordToggle2));
  }

  togglePasswordVisibility2() {
    passwordToggle2 = !passwordToggle2;
    emit(SignUpStateInitial());
    emit(SignUpStateLoaded(passwordToggle, passwordToggle2));
  }

  loadSignUpScreen() {
    emit(SignUpStateLoaded(passwordToggle, passwordToggle2));
  }

  Future<bool> submitForm() async {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
