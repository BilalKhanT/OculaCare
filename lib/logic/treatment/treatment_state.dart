import 'package:cculacare/data/models/disease_result/disease_result_model.dart';
import 'package:equatable/equatable.dart';

abstract class TreatmentState extends Equatable {
  const TreatmentState();
  @override
  List<Object> get props => [];
}

class TreatmentInitial extends TreatmentState {}

class TreatmentLeft extends TreatmentState {
  final DiseaseResultModel result;
  const TreatmentLeft(this.result);
}

class TreatmentRight extends TreatmentState {
  final DiseaseResultModel result;
  const TreatmentRight(this.result);
}

class TreatmentBulgy extends TreatmentState {
  final DiseaseResultModel result;
  const TreatmentBulgy(this.result);
}

class TreatmentCrossed extends TreatmentState {
  final DiseaseResultModel result;
  const TreatmentCrossed(this.result);
}

class TreatmentError extends TreatmentState {}
