import 'package:OculaCare/logic/tests/therapy_schedule_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../configs/app/notification/notification_service.dart';

class TherapyScheduleCubit extends Cubit<TherapyScheduleState> {
  TherapyScheduleCubit() : super(TherapyScheduleInitial());

  final controller = TextEditingController();
  late DateTime time;

  void clearController() {
    controller.clear();
  }

  Future<bool> scheduleTherapy(String body) async {
    emit(TherapyScheduleLoading());
    await Future.delayed(const Duration(seconds: 1));
    await NotificationService.scheduleNotification(
        body, 'You need to take $body.', time);
    clearController();
    emit(TherapyScheduleInitial());
    return true;
  }

  Future<void> loadDiseaseNotifications() async {
    List<Map<String, String>> result = [];
    emit(TherapyScheduleLoading());
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
      emit(TherapyScheduleDiseaseLoaded(result));
    } else {
      emit(const TherapyScheduleDiseaseLoaded([]));
    }
  }

  Future<void> loadGeneralNotifications() async {
    List<Map<String, String>> result = [];
    emit(TherapyScheduleLoading());
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
      emit(TherapyScheduleGeneralLoaded(result));
    } else {
      emit(const TherapyScheduleGeneralLoaded([]));
    }
  }

  Future<void> removeNotification(String id, String type) async {
    emit(TherapyScheduleLoading());
    await NotificationService.cancelNotification(int.parse(id));
    if (type == 'color') {
      loadDiseaseNotifications();
    } else {
      loadDiseaseNotifications();
    }
  }
}
