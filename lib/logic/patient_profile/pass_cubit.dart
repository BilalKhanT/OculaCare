import 'package:bloc/bloc.dart';
import 'package:cculacare/logic/patient_profile/pass_state.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repositories/local/preferences/shared_prefs.dart';
import '../../data/repositories/patient/password_repo.dart';

class PassCubit extends Cubit<PassState> {
  PassCubit() : super(PassInitial());

  final passwordRepo = PasswordRepo();
  final passController = TextEditingController();
  final conPassController = TextEditingController();
  final passFocus = FocusNode();
  final conPassFocus = FocusNode();

  void clearAll() {
    passController.clear();
    conPassController.clear();
  }

  Future<bool> updatePassword() async {
    emit(PassLoading());
    bool flag = await passwordRepo.updatePassword(passController.text.trim());
    if (flag) {
      sharedPrefs.password = passController.text.trim();
      clearAll();
      emit(PassInitial());
      return true;
    } else {
      emit(PassInitial());
      return false;
    }
  }
}
