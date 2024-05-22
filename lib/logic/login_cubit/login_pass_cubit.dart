import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class LoginPassState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginPassStateInitial extends LoginPassState {}

class PasswordToggleLogin extends LoginPassState {
  final bool passVisible;

  PasswordToggleLogin(this.passVisible);
}

class LoginPassCubit extends Cubit<LoginPassState> {
  LoginPassCubit() : super(LoginPassStateInitial());

  bool passwordToggle = false;

  togglePasswordVisibility() {
    passwordToggle = !passwordToggle;
    emit(LoginPassStateInitial());
    emit(PasswordToggleLogin(passwordToggle));
  }
}