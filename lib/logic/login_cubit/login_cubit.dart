import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/patient/patient_model.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../data/repositories/login/login_repo.dart';
import 'login_cubit_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginStateInitial());

  final LoginRepository loginRepository = LoginRepository();
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
    return formKey.currentState!.validate();
  }

  Future<void> loginUser() async {
    emit(LoginStateLoading());
    try {
      var response = await loginRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      sharedPrefs.email = emailController.text.trim();
      sharedPrefs.password = passwordController.text.trim();
      dispose();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        PatientModel patientModel = PatientModel.fromJson(data);
        Patient patient = patientModel.patient;
        if (patient.gender != null &&
            patient.address != null &&
            patient.profileImage != null) {
          sharedPrefs.isProfileSetup = true;
          sharedPrefs.userName = patient.username!;
          sharedPrefs.email = patient.email!;
          sharedPrefs.patientData = jsonEncode(patient.toJson());
          sharedPrefs.setAddressList(patientModel.addressBook);
        } else {
          sharedPrefs.isProfileSetup = false;
          sharedPrefs.patientData = '';
        }
        sharedPrefs.isLoggedIn = true;
        emit(LoginSuccess());
      } else {
        log(response.body);
        emit(LoginFailure());
      }
    } catch (e) {
      emit(LoginFailure());
      log('Network error: $e');
    }
  }

  Future<bool> changePassword() async {
    try {
      bool isUpdated = await loginRepository.updatePassword(
        sharedPrefs.email,
        recoveryPassController.text,
      );
      return isUpdated;
    } catch (e) {
      log('Error changing password: $e');
      return false;
    }
  }

  Future<void> forgetPassword() async {
    emit(LoginStateForgotPassword());
  }

  Future<void> resetPassword() async {
    emit(LoginStateResetPassword());
  }
}
