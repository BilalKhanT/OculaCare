import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ocula_care/logic/sign_up_cubit/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpStateInitial());

  dispose() {
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPassController.clear();
  }

  final formKey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  loadSignUpScreen() {
    emit(SignUpStateLoaded());
  }

  void submitForm() {
    if (formKey.currentState!.validate()) {

    }
  }
}