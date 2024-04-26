import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'otp_state.dart';
import 'package:http/http.dart' as http;

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpStateInitial());

  final otpController = TextEditingController();

  Future<void> sendOtp(String email, String username, String password) async {
    emit(OtpStateLoading());
    try {
      // var url = Uri.parse('http://192.168.18.34:3000/api/users/signup');
      // var response = await http.post(
      //   url,
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({
      //     'email': email,
      //     'username': username,
      //     'password': password,
      //   }),
      // );
      Future.delayed(Duration(seconds: 2));
      emit(OtpStateLoaded('123456', email));
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body);
      //   var otp = data['otp'];
      //   emit(OtpStateLoaded(otp));
      // } else {
      //   log('Server error with status code: ${response.statusCode}');
      //   emit(OtpStateFailure('Ops, something went wrong'));
      // }
    } catch (e) {
      log('Network error: $e');
      emit(OtpStateFailure('Ops, something went wrong'));
    }
  }

  verifyOtp() {

  }
}
