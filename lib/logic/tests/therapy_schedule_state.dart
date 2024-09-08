import 'package:equatable/equatable.dart';

abstract class TherapyScheduleState extends Equatable {
  const TherapyScheduleState();

  @override
  List<Object?> get props => [];
}

class TherapyScheduleInitial extends TherapyScheduleState {}

class TherapyScheduleLoading extends TherapyScheduleState {}

class TherapyScheduleGeneralLoaded extends TherapyScheduleState {
  final List<Map<String, String>> scheduledNotifications;

  const TherapyScheduleGeneralLoaded(this.scheduledNotifications);
}

class TherapyScheduleDiseaseLoaded extends TherapyScheduleState {
  final List<Map<String, String>> scheduledNotifications;

  const TherapyScheduleDiseaseLoaded(this.scheduledNotifications);
}
