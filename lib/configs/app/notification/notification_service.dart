import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../data/repositories/local/preferences/shared_prefs.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin localNotificationPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
      NotificationResponse response) async {}

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidInitializationSettings,
    );

    await localNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification);

    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('channel_Id', 'channel_Name',
          importance: Importance.high, priority: Priority.high),
    );
    await localNotificationPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails);
  }

  static Future<void> scheduleNotification(
      String title, String body, DateTime time) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('channel_Id', 'channel_Name',
          importance: Importance.high, priority: Priority.high),
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await localNotificationPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(time, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
    await addScheduledNotification(id, title, body, time.toString());
  }

  static Future<void> addScheduledNotification(
      int id, String title, String body, String time) async {
    List<String> notifications =
        sharedPrefs.getStringList('scheduled_notifications') ?? [];
    notifications.add('$id|$title|$body|$time');
    await sharedPrefs.setStringList('scheduled_notifications', notifications);
  }

  static Future<void> removeScheduledNotification(int id) async {
    List<String> notifications =
        sharedPrefs.getStringList('scheduled_notifications') ?? [];
    notifications
        .removeWhere((notification) => notification.startsWith('$id|'));
    await sharedPrefs.setStringList('scheduled_notifications', notifications);
  }

  static Future<List<Map<String, String>>> getScheduledNotifications() async {
    List<String> notifications =
        sharedPrefs.getStringList('scheduled_notifications') ?? [];
    return notifications.map((notification) {
      List<String> parts = notification.split('|');
      return {
        'id': parts[0],
        'title': parts[1],
        'body': parts[2],
        'time': parts[3],
      };
    }).toList();
  }

  static Future<void> cancelNotification(int id) async {
    await localNotificationPlugin.cancel(id);
    await removeScheduledNotification(id);
  }
}
