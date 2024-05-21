import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class SignUpPassState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpPassStateInitial extends SignUpPassState {}

class PasswordToggle extends SignUpPassState {
  final bool passVisible;
  final bool confirmPassVisible;

  PasswordToggle(this.passVisible, this.confirmPassVisible);
}

class SignUpPassCubit extends Cubit<SignUpPassState> {
  SignUpPassCubit() : super(SignUpPassStateInitial());

  bool passwordToggle = false;
  bool passwordToggle2 = false;

  togglePasswordVisibility() {
    passwordToggle = !passwordToggle;
    emit(SignUpPassStateInitial());
    emit(PasswordToggle(passwordToggle, passwordToggle2));
  }

  togglePasswordVisibility2() {
    passwordToggle2 = !passwordToggle2;
    emit(SignUpPassStateInitial());
    emit(PasswordToggle(passwordToggle, passwordToggle2));
  }
}