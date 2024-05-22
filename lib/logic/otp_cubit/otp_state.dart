import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

class OtpStateInitial extends OtpState {}

class OtpStateLoading extends OtpState {}

class OtpEmailExists extends OtpState {}

class OtpEmailNotExists extends OtpState {}

class InvalidEmail extends OtpState {}

class Registered extends OtpState {}

class OtpStateLoaded extends OtpState {
  final String email;
  final String otp;

  OtpStateLoaded(this.otp, this.email);
}

class LoadChangePasswordState extends OtpState {}

class OtpStateFailure extends OtpState {
  final String errorMsg;

  OtpStateFailure(this.errorMsg);
}