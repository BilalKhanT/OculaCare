import 'package:equatable/equatable.dart';

abstract class SnellanTestState extends Equatable {
  const SnellanTestState();

  @override
  List<Object?> get props => [];
}

class SnellanTestInitial extends SnellanTestState {}

class SnellanTestLoading extends SnellanTestState {}

class SnellanTestAnalysing extends SnellanTestState {}

class SnellanTestLoaded extends SnellanTestState {}

class SnellanTestNext extends SnellanTestState {
  final List<String> alphabets;
  final int index;
  final double fontSize;

  const SnellanTestNext(this.alphabets, this.index, this.fontSize);

  @override
  List<Object?> get props => [alphabets, index, fontSize];
}

class SnellanTestCompleted extends SnellanTestState {
  final int score;
  final String visionAcuity;

  const SnellanTestCompleted(this.score, this.visionAcuity);

  @override
  List<Object?> get props => [score, visionAcuity];
}


class SnellanTestError extends SnellanTestState {}
