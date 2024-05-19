import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../keyboard_listener_cubit/keyboard_list_cubit.dart';
import '../keyboard_listener_cubit/keyboard_list_state.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final KeyboardListenerCubit keyboardListenerCubit;
  AuthCubit(this.keyboardListenerCubit) : super(AuthInitial()) {
    listenToKeyboardFocus();
  }


  //focus nodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();

  void listenToKeyboardFocus() {
    emailFocusNode.addListener(_onFocusChanged);
    passwordFocusNode.addListener(_onFocusChanged);
    phoneFocusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() async {
    if (emailFocusNode.hasFocus ||
        passwordFocusNode.hasFocus ||
        phoneFocusNode.hasFocus) {
      keyboardListenerCubit.emit(KeyboardOpened());
    } else {
      await 150.milliseconds.delay;
      keyboardListenerCubit.emit(KeyboardClosed());
    }
  }

  closeKeyboard() async {
    await 150.milliseconds.delay;

    keyboardListenerCubit.emit(KeyboardClosed());
  }

}