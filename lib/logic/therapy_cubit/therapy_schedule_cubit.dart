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

  Future<bool> scheduleTherapy(Map<String, dynamic> therapy, DateTime scheduledTime) async {
    emit(TherapyScheduleLoading());

    String category = therapy['category'] ?? 'Disease Specific';
    String therapyName = therapy['title'] ?? 'Unknown Therapy';

    await Future.delayed(const Duration(seconds: 1));
    await NotificationService.scheduleTherapyNotification(
        therapyName,
        'You need to attend $therapyName therapy.',
        scheduledTime,
        category
    );

    clearController();
    emit(TherapyScheduledSuccessfully(therapyName, scheduledTime));
    return true;
  }

  Future<void> loadGeneralTherapies() async {
    List<Map<String, String>> generalTherapies = [];
    emit(TherapyScheduleLoading());

    final List<Map<String, String>> therapyNotifications = await NotificationService.getScheduledTherapyNotifications();

    if (therapyNotifications.isNotEmpty) {
      for (var scheduled in therapyNotifications) {
        if (scheduled.isNotEmpty && scheduled['category'] == 'General') {
          DateTime scheduledTime = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(scheduledTime)) {
            generalTherapies.add(scheduled);
          } else {
            await NotificationService.removeScheduledTherapyNotification(int.parse(scheduled['id']!));
          }
        }
      }
      emit(TherapyScheduled(generalTherapies));
    } else {
      emit(const TherapyScheduled([]));
    }
  }

  Future<void> loadDiseaseSpecificTherapies() async {
    List<Map<String, String>> diseaseTherapies = [];
    emit(TherapyScheduleLoading());

    final List<Map<String, String>> therapyNotifications = await NotificationService.getScheduledTherapyNotifications();

    if (therapyNotifications.isNotEmpty) {
      for (var scheduled in therapyNotifications) {
        if (scheduled['category'] != 'General') {
          DateTime scheduledTime = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(scheduledTime)) {
            diseaseTherapies.add(scheduled);
          } else {
            await NotificationService.removeScheduledTherapyNotification(int.parse(scheduled['id']!));
          }
        }
      }
      emit(TherapyScheduled(diseaseTherapies));
    } else {
      emit(const TherapyScheduled([]));
    }
  }

  Future<void> removeScheduledTherapy(String id) async {
    emit(TherapyScheduleLoading());
    await NotificationService.cancelTherapyNotification(int.parse(id));
    await loadScheduledTherapies();
  }


  Future<void> loadScheduledTherapies() async {
    List<Map<String, String>> result = [];
    emit(TherapyScheduleLoading());
    final List<Map<String, String>> therapyNotifications = await NotificationService.getScheduledTherapyNotifications();

    if (therapyNotifications.isNotEmpty) {
      for (var scheduled in therapyNotifications) {
        if (scheduled['body']?.contains('therapy') ?? false) {
          DateTime scheduledTime = DateTime.parse(scheduled['time']!);
          if (DateTime.now().isBefore(scheduledTime)) {
            result.add(scheduled);
          } else {
            await NotificationService.removeScheduledTherapyNotification(int.parse(scheduled['id']!));
          }
        }
      }
      emit(TherapyScheduled(result));
    } else {
      emit(const TherapyScheduled([]));
    }
  }
}
