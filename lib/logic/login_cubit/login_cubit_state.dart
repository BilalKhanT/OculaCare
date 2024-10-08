import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateForgotPassword extends LoginState {}

class LoginStateResetPassword extends LoginState {}

class LoginStateLoaded extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {}

class LoginStateFailure extends LoginState {
  final String errorMsg;

  LoginStateFailure(this.errorMsg);
}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {}
