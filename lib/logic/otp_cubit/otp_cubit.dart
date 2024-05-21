import 'dart:convert';
import 'dart:developer';
import 'package:OculaCare/configs/app/environment/env_configs.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'otp_state.dart';
import 'package:http/http.dart' as http;

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpStateInitial());

  late String userOTP;
  late String verificationOTP;
  late String userEmail;
  late String userName;
  late String userPassword;

  Future<void> sendOtp(String email, String name, String password) async {
    print('aaaa ${email + name + password}');
    emit(OtpStateLoading());
    userEmail = email;
    userName = name;
    userPassword = password;
    try {
      var url = Uri.parse('http://192.168.18.29:3000/api/patients/otp');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': name,
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var otp = data['otp'];
        verificationOTP = otp.toString();
        emit(OtpStateLoaded(otp, email));
      }
      else if (response.statusCode == 409) {
        emit(OtpEmailExists());
      }else {
        log('Server error with status code: ${response.statusCode}');
        emit(OtpStateFailure('Ops, something went wrong'));
      }
    } catch (e) {
      log('Network error: $e');
      emit(OtpStateFailure('Ops, something went wrong'));
    }
  }

  bool verifyOtp() {
    if (userOTP == verificationOTP) {
      return true;
    }
    else {
      return false;
    }
  }

  Future<void> registerUser() async {
    try {
      var url = Uri.parse('http://192.168.18.29:3000/api/patients/register');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': userEmail,
          'username': userName,
          'password': userPassword,
        }),
      );
      if (response.statusCode == 200) {
        emit(Registered());
      }
      else {
        log('Server error with status code: ${response.statusCode}');
        emit(OtpStateFailure('Ops, something went wrong'));
      }
    } catch (e) {
      log('Network error: $e');
      emit(OtpStateFailure('Ops, something went wrong'));
    }
  }
}
