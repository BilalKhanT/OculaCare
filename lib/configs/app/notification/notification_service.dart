import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../data/repositories/local/preferences/shared_prefs.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin localNotificationPlugin =
  FlutterLocalNotificationsPlugin();

  // Method to handle received notifications
  static Future<void> onDidReceiveNotification(
      NotificationResponse response) async {}

  // Initialize the notification service
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

  // Instant notification for general purposes
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

  // Method to schedule a test notification
  static Future<void> scheduleTestNotification(
      String title, String body, DateTime time) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('test_channel_Id', 'test_channel_Name',
          importance: Importance.high, priority: Priority.high),
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await localNotificationPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(time, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
    await addScheduledNotification(id, title, body, time.toString(), 'test');
  }

  // Method to schedule a therapy notification
  static Future<void> scheduleTherapyNotification(
      String title, String body, DateTime time) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
          'therapy_channel_Id', 'therapy_channel_Name',
          importance: Importance.high, priority: Priority.high),
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await localNotificationPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(time, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);
    await addScheduledNotification(id, title, body, time.toString(), 'therapy');
  }

  // Helper method to add a scheduled notification
  static Future<void> addScheduledNotification(
      int id, String title, String body, String time, String type) async {
    List<String> notifications =
        sharedPrefs.getStringList('scheduled_notifications') ?? [];
    notifications.add('$id|$title|$body|$time|$type');
    await sharedPrefs.setStringList('scheduled_notifications', notifications);
  }

  // Helper method to remove a scheduled notification
  static Future<void> removeScheduledNotification(int id) async {
    List<String> notifications =
        sharedPrefs.getStringList('scheduled_notifications') ?? [];
    notifications.removeWhere((notification) => notification.startsWith('$id|'));
    await sharedPrefs.setStringList('scheduled_notifications', notifications);
  }

  // Retrieve all scheduled notifications (tests + therapies)
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
        'type': parts[4], // Indicates whether it's for test or therapy
      };
    }).toList();
  }

  // Cancel a notification
  static Future<void> cancelNotification(int id) async {
    await localNotificationPlugin.cancel(id);
    await removeScheduledNotification(id);
  }
}
