import 'package:equatable/equatable.dart';

abstract class TherapyProgressionState extends Equatable {
  const TherapyProgressionState();

  @override
  List<Object?> get props => [];
}

class TherapyProgressionInitial extends TherapyProgressionState {}

class TherapyProgressionToggled extends TherapyProgressionState {
  final Map<DateTime, int> number;

  const TherapyProgressionToggled(this.number);

  @override
  List<Object?> get props => [number];
}
