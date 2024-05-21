import 'package:equatable/equatable.dart';

abstract class OtpState extends Equatable {
  @override
  List<Object> get props => [];
}

class OtpStateInitial extends OtpState {}

class OtpStateLoading extends OtpState {}

class OtpEmailExists extends OtpState {}

class Registered extends OtpState {}

class OtpStateLoaded extends OtpState {
  final String email;
  final String otp;

  OtpStateLoaded(this.otp, this.email);
}

class OtpStateFailure extends OtpState {
  final String errorMsg;

  OtpStateFailure(this.errorMsg);
}