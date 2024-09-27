import 'package:equatable/equatable.dart';

sealed class ScheduleTabState extends Equatable {
  const ScheduleTabState();

  @override
  List<Object> get props => [];
}

final class ScheduleTabInitial extends ScheduleTabState {}

final class ScheduleTabToggled extends ScheduleTabState {
  final bool isVision;
  final bool isColor;

  const ScheduleTabToggled(
    this.isVision,
    this.isColor,
  );

  @override
  List<Object> get props => [isVision, isColor];
}
