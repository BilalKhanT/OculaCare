import 'package:OculaCare/logic/patient_profile/pass_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

class PassCubit extends Cubit<PassState> {
  PassCubit() : super(PassInitial());

  final passController = TextEditingController();
  final conPassController = TextEditingController();
  final passFocus = FocusNode();
  final conPassFocus = FocusNode();

  void clearAll() {
    passController.clear();
    conPassController.clear();
  }

  Future<void> updatePassword() async {
    emit(PassLoading());
    await Future.delayed(Duration(seconds: 4));
    emit(PassInitial());
  }
}