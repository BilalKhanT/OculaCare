import 'package:OculaCare/logic/therapy_cubit/therapy_schedule_state.dart';
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

  Future<bool> scheduleTherapy(String therapyName, DateTime scheduledTime) async {
    emit(TherapyScheduleLoading());
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    await NotificationService.scheduleTherapyNotification(
      therapyName,
      'You need to attend $therapyName therapy.',
      scheduledTime,
    );
    clearController();
    emit(TherapyScheduledSuccessfully(therapyName, scheduledTime));
    return true;
  }

  Future<void> loadScheduledTherapies() async {
    List<Map<String, String>> result = [];
    emit(TherapyScheduleLoading());
    final List<Map<String, String>> notifications = await NotificationService.getScheduledNotifications();

    if (notifications.isNotEmpty) {
      for (var scheduled in notifications) {
        if (scheduled['body']?.contains('therapy') ?? false) {
          DateTime scheduledTime = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(scheduledTime)) {
            result.add(scheduled);
          } else {
            await NotificationService.removeScheduledNotification(int.parse(scheduled['id']!));
          }
        }
      }
      emit(TherapyScheduled(result));
    } else {
      emit(const TherapyScheduled([]));
    }
  }

  Future<void> removeScheduledTherapy(String id) async {
    emit(TherapyScheduleLoading());
    await NotificationService.cancelNotification(int.parse(id));
    await loadScheduledTherapies();
  }
}
