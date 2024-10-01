import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cculacare/data/repositories/sign_up/signup_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/local/preferences/shared_prefs.dart';
import 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepository signUpRepository = SignUpRepository();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SignUpCubit() : super(SignUpStateInitial());

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

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
    return formKey.currentState!.validate();
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
      return flag;
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
        return flag;
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
      var response = await signUpRepository.registerGoogleUser(email, userName);
      if (response.statusCode == 200) {
        sharedPrefs.isProfileSetup = false;
        sharedPrefs.email = email;
        sharedPrefs.userName = userName;
        sharedPrefs.password = '******';
        emit(SignUpStateLoaded());
        return true;
      } else if (response.statusCode == 409) {
        emit(SignUpStateLoaded());
        return false;
      } else {
        log('Server error with status code: ${response.statusCode}');
        emit(SignUpStateLoaded());
        return false;
      }
    } catch (e) {
      log('Error registering Google user: $e');
      emit(SignUpStateLoaded());
      return false;
    }
  }

  Future<bool> registerFacebookUser(String userName) async {
    try {
      var response = await signUpRepository.registerFacebookUser(userName);
      if (response.statusCode == 200) {
        sharedPrefs.isProfileSetup = false;
        sharedPrefs.email = "awaisjarral37@gmail.com";
        sharedPrefs.userName = userName;
        sharedPrefs.password = '******';
        emit(SignUpStateLoaded());
        return true;
      } else if (response.statusCode == 409) {
        emit(SignUpStateLoaded());
        return false;
      } else {
        log('Server error with status code: ${response.statusCode}');
        emit(SignUpStateLoaded());
        return false;
      }
    } catch (e) {
      log('Error registering Facebook user: $e');
      emit(SignUpStateLoaded());
      return false;
    }
  }
}
