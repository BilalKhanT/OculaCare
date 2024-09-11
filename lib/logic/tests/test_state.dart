import 'package:OculaCare/data/models/tests/test_result_model.dart';
import 'package:equatable/equatable.dart';

sealed class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class TestLoading extends TestState {}

class TestLoaded extends TestState {}

class TestHistory extends TestState {
  final List<TestResultModel> data;
  final List<TestResultModel> dataColor;

  const TestHistory(this.data, this.dataColor);

  @override
  List<Object?> get props => [data, dataColor];
}

class TestProgression extends TestState {
  final List<TestResultModel> dataVision;
  final List<TestResultModel> dataColor;
  final Map<DateTime, int> progressData;

  const TestProgression(this.dataVision, this.dataColor, this.progressData);

  @override
  List<Object?> get props => [dataVision, dataColor, progressData];
}
