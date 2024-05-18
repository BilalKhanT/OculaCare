import 'package:equatable/equatable.dart';

abstract class PatientProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class PatientProfileStateInitial extends PatientProfileState {}

class PatientProfileStateLoading extends PatientProfileState {}

class PatientProfileStateSetUp extends PatientProfileState {}

class PatientProfileStateLoaded extends PatientProfileState {

}

class PatientProfileStateFailure extends PatientProfileState {
  final String errorMsg;

  PatientProfileStateFailure(this.errorMsg);
}