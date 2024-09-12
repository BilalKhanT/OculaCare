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
    InitializationSettings(android: androidInitializationSettings);

    await localNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotification,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification);

    await localNotificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // Instant Notification
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

  // General Notifications (Test-Related)
  static Future<void> scheduleNotification(
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
    notifications.removeWhere((notification) => notification.startsWith('$id|'));
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

  // Therapy Notifications with category
  static Future<void> scheduleTherapyNotification(
      String title, String body, DateTime time, String category) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails('therapy_channel_Id', 'therapy_channel_Name',
          importance: Importance.high, priority: Priority.high),
    );
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await localNotificationPlugin.zonedSchedule(id, title, body,
        tz.TZDateTime.from(time, tz.local), notificationDetails,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime);

    await addScheduledTherapyNotification(id, title, body, time.toString(), category);
  }

  static Future<void> addScheduledTherapyNotification(
      int id, String title, String body, String time, String category) async {
    List<String> therapyNotifications =
        sharedPrefs.getStringList('scheduled_therapy_notifications') ?? [];
    therapyNotifications.add('$id|$title|$body|$time|$category'); // Include category in the string
    await sharedPrefs.setStringList('scheduled_therapy_notifications', therapyNotifications);
  }

  static Future<void> removeScheduledTherapyNotification(int id) async {
    List<String> therapyNotifications =
        sharedPrefs.getStringList('scheduled_therapy_notifications') ?? [];
    therapyNotifications.removeWhere((notification) => notification.startsWith('$id|'));
    await sharedPrefs.setStringList('scheduled_therapy_notifications', therapyNotifications);
  }

  static Future<List<Map<String, String>>> getScheduledTherapyNotifications() async {
    List<String> therapyNotifications =
        sharedPrefs.getStringList('scheduled_therapy_notifications') ?? [];

    // Ensure the map only contains String values
    return therapyNotifications.map((notification) {
      List<String> parts = notification.split('|');

      // Only return if all parts are available and of String type
      if (parts.length == 5) {
        return {
          'id': parts[0],
          'title': parts[1],
          'body': parts[2],
          'time': parts[3],
          'category': parts[4], // Category added to notification
        };
      } else {
        return <String, String>{}; // Return an empty map for invalid notifications
      }
    }).where((notification) => notification.isNotEmpty).toList();
  }



  static Future<void> cancelTherapyNotification(int id) async {
    await localNotificationPlugin.cancel(id);
    await removeScheduledTherapyNotification(id);
  }
}
