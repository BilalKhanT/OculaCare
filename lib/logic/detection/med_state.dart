import 'package:cculacare/data/models/disease_result/medicine_model.dart';
import 'package:equatable/equatable.dart';

abstract class MedState extends Equatable {
  const MedState();

  @override
  List<Object?> get props => [];
}

class MedInitial extends MedState {}

class MedLoading extends MedState {}

class MedToggled extends MedState {
  final MedicineModel medicines;
  final int subIndex;

  const MedToggled(this.medicines, this.subIndex);

  @override
  List<Object?> get props => [medicines, subIndex];
}
