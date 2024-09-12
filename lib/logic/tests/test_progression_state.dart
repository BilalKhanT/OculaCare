import 'package:equatable/equatable.dart';

abstract class TestProgressionState extends Equatable {
  const TestProgressionState();

  @override
  List<Object?> get props => [];
}

class TestProgressionInitial extends TestProgressionState {}

class TestProgressionToggled extends TestProgressionState {
  final Map<DateTime, double> scores;

  const TestProgressionToggled(this.scores);

  @override
  List<Object?> get props => [scores];
}
