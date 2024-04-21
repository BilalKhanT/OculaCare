import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'login_cubit_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginStateInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passwordToggle = false;

  dispose() {
    emailController.clear();
    passwordController.clear();
  }

  togglePasswordVisibility() {
    passwordToggle = !passwordToggle;
    emit(LoginStateLoaded(passwordToggle));
  }

  loadLoginScreen() {
    emit(LoginStateLoaded(passwordToggle));
  }
}