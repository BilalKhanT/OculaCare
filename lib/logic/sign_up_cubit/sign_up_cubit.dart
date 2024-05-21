import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:OculaCare/logic/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
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
    if (formKey.currentState!.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
