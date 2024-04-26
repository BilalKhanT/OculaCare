import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'login_cubit_state.dart';
import 'package:http/http.dart' as http;

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

  Future<bool> submitForm() async {
    if (formKey.currentState!.validate()) {
      try {
        var url = Uri.parse('http://192.168.18.34:3000/api/users/login');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        log('Response status: ${response.statusCode}');
        log('Response body: ${response.body}');

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var otp = data['otp'];
          if (otp == 'User Not Found') {
            return false;
          } else if(otp == 'Incorrect Password'){
            return false;
          } else {
            return true;
          }
        } else {
          log('Server error with status code: ${response.statusCode}');
          return false;
        }
      } catch (e) {
        log('Network error: $e');
        return false;
      }
    } else {
      return false;
    }
  }

  Future forgetPassword() async{
    emit(LoginStateForgotPassword());
  }

  Future resetPassword() async{
    emit(LoginStateResetPassword());
  }
}