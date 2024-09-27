import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../configs/app/notification/notification_service.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleVisionLoaded extends ScheduleState {
  final List<Map<String, String>> scheduledNotifications;

  const ScheduleVisionLoaded(this.scheduledNotifications);
}

class ScheduleColorLoaded extends ScheduleState {
  final List<Map<String, String>> scheduledNotifications;

  const ScheduleColorLoaded(this.scheduledNotifications);
}

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(ScheduleInitial());

  final controller = TextEditingController();
  late DateTime time;

  void clearController() {
    controller.clear();
  }

  Future<bool> scheduleTest(String body) async {
    emit(ScheduleLoading());
    await Future.delayed(const Duration(seconds: 1));
    await NotificationService.scheduleNotification(
        body, 'You need to take $body.', time);
    clearController();
    emit(ScheduleInitial());
    return true;
  }

  Future<void> loadVisionNotifications() async {
    List<Map<String, String>> result = [];
    emit(ScheduleLoading());
    final List<Map<String, String>> notifications =
        await NotificationService.getScheduledNotifications();
    if (notifications.isNotEmpty) {
      for (var scheduled in notifications) {
        if (scheduled['body'] == 'You need to take Match Color Test.' ||
            scheduled['body'] == 'You need to take Odd One Out Test.' ||
            scheduled['body'] == 'You need to take Isihara Plates Test.') {
        } else {
          DateTime time = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(time)) {
            result.add(scheduled);
          } else {
            await NotificationService.removeScheduledNotification(
                int.parse(scheduled['id']!));
          }
        }
      }
      emit(ScheduleVisionLoaded(result));
    } else {
      emit(const ScheduleVisionLoaded([]));
    }
  }

  Future<void> loadColorNotifications() async {
    List<Map<String, String>> result = [];
    emit(ScheduleLoading());
    final List<Map<String, String>> notifications =
        await NotificationService.getScheduledNotifications();
    if (notifications.isNotEmpty) {
      for (var scheduled in notifications) {
        if (scheduled['body'] == 'You need to take Match Color Test.' ||
            scheduled['body'] == 'You need to take Odd One Out Test.' ||
            scheduled['body'] == 'You need to take Isihara Plates Test.') {
          DateTime time = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(time)) {
            result.add(scheduled);
          } else {
            await NotificationService.removeScheduledNotification(
                int.parse(scheduled['id']!));
          }
        } else {}
      }
      emit(ScheduleColorLoaded(result));
    } else {
      emit(const ScheduleColorLoaded([]));
    }
  }

  Future<void> removeNotification(String id, String type) async {
    emit(ScheduleLoading());
    await NotificationService.cancelNotification(int.parse(id));
    if (type == 'color') {
      loadColorNotifications();
    } else {
      loadVisionNotifications();
    }
  }
}
