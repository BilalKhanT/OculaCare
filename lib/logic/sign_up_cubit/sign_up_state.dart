import 'package:equatable/equatable.dart';

abstract class SignUpState extends Equatable {
  @override
  List<Object> get props => [];
}

class SignUpStateInitial extends SignUpState {}

class SignUpStateLoading extends SignUpState {}

class SignUpStateLoaded extends SignUpState {
  final bool passVisible;
  final bool confirmPassvisible;

  SignUpStateLoaded(this.passVisible, this.confirmPassvisible);
}

class SignUpStateFailure extends SignUpState {
  final String errorMsg;

  SignUpStateFailure(this.errorMsg);
}