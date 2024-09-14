import 'dart:convert';
import 'dart:developer';

import 'package:OculaCare/data/models/patient/patient_model.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../configs/app/app_globals.dart';
import 'login_cubit_state.dart';
import 'package:http/http.dart' as http;

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginStateInitial());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final recoveryEmailController = TextEditingController();
  final recoveryPassController = TextEditingController();
  final recoveryConfirmPassController = TextEditingController();

  dispose() {
    emailController.clear();
    passwordController.clear();
  }

  loadLoginScreen() {
    emit(LoginStateLoaded());
  }

  Future<bool> submitForm(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loginUser() async {
    emit(LoginStateLoading());
    try {
      var url = Uri.parse('$ipServer/api/patients/login');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );
      sharedPrefs.email = emailController.text.trim();
      sharedPrefs.password = passwordController.text.trim();
      dispose();
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        Patient patient = Patient.fromJson(data);
        if (patient.gender != null &&
            patient.address != null &&
            patient.profileImage != null) {
          sharedPrefs.isProfileSetup = true;
          String encodedPatient = jsonEncode(patient.toJson());
          sharedPrefs.patientData = encodedPatient;
        } else {
          sharedPrefs.patientData = '';
          sharedPrefs.isProfileSetup = false;
        }
        sharedPrefs.isLoggedIn = true;
        emit(LoginSuccess());
      } else {
        emit(LoginFailure());
      }
    } catch (e) {
      emit(LoginFailure());
      log('Network error: $e');
    }
  }

  Future forgetPassword() async {
    emit(LoginStateForgotPassword());
  }

  Future<void> checkRecoveryEmail() async {}

  Future<bool> changePassword() async {
    try {
      var url = Uri.parse('$ipServer/api/patients/update-password');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': sharedPrefs.email,
          'newPassword': recoveryPassController.text.trim(),
        }),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        log('${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('$e');
      return false;
    }
  }

  Future resetPassword() async {
    emit(LoginStateResetPassword());
  }
}
