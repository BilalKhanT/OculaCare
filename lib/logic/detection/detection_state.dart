import 'package:OculaCare/data/models/disease_result/disease_result_model.dart';
import 'package:equatable/equatable.dart';

abstract class DetectionState extends Equatable {
  const DetectionState();

  @override
  List<Object> get props => [];
}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionLoaded extends DetectionState {
  final List<DiseaseResultModel> diseaseResults;

  const DetectionLoaded(this.diseaseResults);

  @override
  List<Object> get props => [diseaseResults];
}

class DetectionServerError extends DetectionState {}
