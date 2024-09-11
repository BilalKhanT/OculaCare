import 'package:equatable/equatable.dart';

abstract class TherapyScheduleState extends Equatable {
  const TherapyScheduleState();

  @override
  List<Object?> get props => [];
}

class TherapyScheduleInitial extends TherapyScheduleState {}

class TherapyScheduleLoading extends TherapyScheduleState {}

class TherapyScheduledSuccessfully extends TherapyScheduleState {
  final String therapyName;
  final DateTime scheduledTime;

  const TherapyScheduledSuccessfully(this.therapyName, this.scheduledTime);

  @override
  List<Object?> get props => [therapyName, scheduledTime];
}

class TherapyScheduled extends TherapyScheduleState {
  final List<Map<String, String>> scheduledTherapies;

  const TherapyScheduled(this.scheduledTherapies);

  @override
  List<Object?> get props => [scheduledTherapies];
}
