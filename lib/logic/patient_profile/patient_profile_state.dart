import 'package:equatable/equatable.dart';

import '../../data/models/patient/patient_model.dart';

abstract class PatientProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class PatientProfileStateInitial extends PatientProfileState {}

class PatientProfileStateLoading extends PatientProfileState {}

class PatientProfileStateSetUp extends PatientProfileState {}

class PatientProfileStateEdit extends PatientProfileState {
  final String image;

  PatientProfileStateEdit(this.image);
}

class PatientProfileStateLoaded extends PatientProfileState {
  final Patient patientData;

  PatientProfileStateLoaded(this.patientData);
}

class PatientProfileStateFailure extends PatientProfileState {
  final String errorMsg;

  PatientProfileStateFailure(this.errorMsg);
}