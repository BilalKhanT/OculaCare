import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginStateInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateLoaded extends LoginState {
  final bool passVisible;

  LoginStateLoaded(this.passVisible);
}

class LoginStateFailure extends LoginState {
  final String errorMsg;

  LoginStateFailure(this.errorMsg);
}