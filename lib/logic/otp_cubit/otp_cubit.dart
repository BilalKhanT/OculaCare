import 'dart:convert';
import 'dart:developer';
import 'package:OculaCare/configs/app/app_globals.dart';
import 'package:OculaCare/data/repositories/local/preferences/shared_prefs.dart';
import 'package:bloc/bloc.dart';
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
    emit(OtpStateLoading());
    userEmail = email;
    userName = name;
    userPassword = password;
    try {
      var url = Uri.parse('http://$ipAddress:3000/api/patients/otp');
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
        emit(OtpStateLoaded(otp, email, name));
      }
      else if (response.statusCode == 409) {
        emit(OtpEmailExists());
      }
      else if (response.statusCode == 400) {
        emit(InvalidEmail());
      }else {
        log('Server error with status code: ${response.statusCode}');
        emit(OtpStateFailure('Ops, something went wrong'));
      }
    } catch (e) {
      log('Network error: $e');
      emit(OtpStateFailure('Ops, something went wrong'));
    }
  }

  Future<void> resendOtp(String flow, String email, String name) async {
    emit(OtpStateLoading());
    if (flow == 'recover') {
      try {
        var url = Uri.parse('http://$ipAddress:3000/api/patients/recovery-otp');
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
          emit(OtpStateLoaded(otp, email, name));
        }
        else if (response.statusCode == 409) {
          emit(OtpEmailNotExists());
        }else {
          log('Server error with status code: ${response.statusCode}');
          emit(OtpStateFailure('Ops, something went wrong'));
        }
      } catch (e) {
        log('Network error: $e');
        emit(OtpStateFailure('Ops, something went wrong'));
      }
      return;
    }
    try {
      var url = Uri.parse('http://$ipAddress:3000/api/patients/otp');
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
        emit(OtpStateLoaded(otp, email, name));
      }
      else if (response.statusCode == 409) {
        emit(OtpEmailExists());
      }
      else if (response.statusCode == 400) {
        emit(InvalidEmail());
      }else {
        log('Server error with status code: ${response.statusCode}');
        emit(OtpStateFailure('Ops, something went wrong'));
      }
    } catch (e) {
      log('Network error: $e');
      emit(OtpStateFailure('Ops, something went wrong'));
    }
  }

  Future<void> sendRecoveryOTP (String email) async{
    emit(OtpStateLoading());
    try {
      var url = Uri.parse('http://$ipAddress:3000/api/patients/recovery-otp');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': sharedPrefs.userName,
        }),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var otp = data['otp'];
        verificationOTP = otp.toString();
        emit(OtpStateLoaded(otp, email, sharedPrefs.userName));
      }
      else if (response.statusCode == 409) {
        emit(OtpEmailNotExists());
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

  Future<void> registerUser(String flow) async {
    if (flow == 'recover') {
      emit(LoadChangePasswordState());
      return;
    }
    try {
      var url = Uri.parse('http://$ipAddress:3000/api/patients/register');
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
        sharedPrefs.userName = userName;
        sharedPrefs.password = userPassword;
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
