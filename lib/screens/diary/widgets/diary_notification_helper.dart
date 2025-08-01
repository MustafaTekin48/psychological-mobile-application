import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class DiaryNotificationHelper {
  static final FlutterLocalNotificationsPlugin _flp = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _flp.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification(String title, String message, DateTime scheduledTime) async {
    var androidDetails = const AndroidNotificationDetails(
      "diary_channel_id",
      "Diary Notifications",
      channelDescription: "Diary reminders",
      priority: Priority.high,
      importance: Importance.high,
    );
    var iosDetails = const DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.initializeTimeZones();
    var scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await _flp.zonedSchedule(
      0,
      title,
      message,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
