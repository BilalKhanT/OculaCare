import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_state.dart';
import 'package:http/http.dart' as http;

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
      try {
        var url = Uri.parse('http://192.168.18.34:3000/api/users/signup');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': emailController.text.trim(),
            'username': userNameController.text.trim(),
            'password': passwordController.text.trim(),
          }),
        );

        log('Response status: ${response.statusCode}');
        log('Response body: ${response.body}');

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          var otp = data['otp'];
          if (otp == 'Email already exists') {
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

}