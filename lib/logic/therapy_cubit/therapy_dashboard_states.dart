import 'package:equatable/equatable.dart';

abstract class TherapyDashboardStates extends Equatable {
  const TherapyDashboardStates();

  @override
  List<Object> get props => [];
}

class TherapyDashboardInitialState extends TherapyDashboardStates {}

class TherapyDashboardHistoryState extends TherapyDashboardStates {}

class TherapyDashboardProgressionState extends TherapyDashboardStates {}
