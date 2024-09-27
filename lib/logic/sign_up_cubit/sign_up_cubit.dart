import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/sign_up_cubit/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../configs/global/app_globals.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInitial());

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  dispose() {
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  loadSignUpScreen() {
    emit(SignUpStateLoaded());
  }

  Future<bool> submitForm(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createUserWithGoogle() async {
    emit(SignUpStateLoading());
    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return false;
      }
      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      final User? user = authResult.user;
      String? email = user?.email;
      String? name = user?.displayName;
      final flag = await registerGoogleUser(email!, name!);
      if (flag == true) {
        emit(SignUpStateLoaded());
        return true;
      } else {
        emit(SignUpStateLoaded());
        return false;
      }
    } catch (e) {
      emit(SignUpStateLoaded());
      log(e.toString());
      return false;
    }
  }

  Future<bool> createUserWithFacebook() async {
    emit(SignUpStateLoading());
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);
        final UserCredential authResult =
            await auth.signInWithCredential(credential);
        final User? user = authResult.user;
        String? name = user?.displayName;
        final flag = await registerFacebookUser(name!);
        if (flag == true) {
          emit(SignUpStateLoaded());
          return true;
        } else {
          emit(SignUpStateLoaded());
          return false;
        }
      } else if (result.status == LoginStatus.cancelled) {
        emit(SignUpStateLoaded());
        return false;
      } else {
        emit(SignUpStateLoaded());
        return false;
      }
    } catch (e) {
      emit(SignUpStateLoaded());
      log(e.toString());
      return false;
    }
  }

  Future<bool> registerGoogleUser(String email, String userName) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/register-google');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': userName,
          'password': '******',
        }),
      );
      if (response.statusCode == 200) {
        sharedPrefs.isProfileSetup = false;
        sharedPrefs.email = email;
        sharedPrefs.userName = userName;
        sharedPrefs.password = '******';
        return true;
      } else if (response.statusCode == 409) {
        return false;
      } else {
        log('Server error with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Network error: $e');
      return false;
    }
  }

  Future<bool> registerFacebookUser(String userName) async {
    try {
      var url = Uri.parse('$ipServer/api/patients/register-google');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': "awaisjarral37@gmail.com",
          'username': userName,
          'password': '******',
        }),
      );
      if (response.statusCode == 200) {
        sharedPrefs.isProfileSetup = false;
        sharedPrefs.email = "awaisjarral37@gmail.com";
        sharedPrefs.userName = userName;
        sharedPrefs.password = '******';
        return true;
      } else if (response.statusCode == 409) {
        return false;
      } else {
        log('Server error with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      log('Network error: $e');
      return false;
    }
  }
}
