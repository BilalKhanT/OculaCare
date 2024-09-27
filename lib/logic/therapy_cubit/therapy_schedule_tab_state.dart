import 'package:equatable/equatable.dart';

abstract class TherapyScheduleTabState extends Equatable {
  const TherapyScheduleTabState();

  @override
  List<Object> get props => [];
}

class TherapyScheduleTabInitial extends TherapyScheduleTabState {}

class TherapyScheduleTabToggled extends TherapyScheduleTabState {
  final bool isGeneral;
  final bool isDiseaseSpecific;

  const TherapyScheduleTabToggled(this.isGeneral, this.isDiseaseSpecific);

  @override
  List<Object> get props => [isGeneral, isDiseaseSpecific];
}
