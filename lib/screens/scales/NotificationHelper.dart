import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static var flp = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidSettings = const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosSettings = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await flp.initialize(initializationSettings);
  }

  static Future<void> scheduleNotification(String title, String message, DateTime scheduledTime) async {
    var androidDetails = const AndroidNotificationDetails(
        "kanal_id",
        "kanal başlığı",
        channelDescription: "kanal açıklaması",
        priority: Priority.max,
        importance: Importance.high
    );
    var iosDetails = const DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    tz.initializeTimeZones();
    var scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);

    await flp.zonedSchedule(
        0,
        title,
        message,
        scheduledDate,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle
    );
  }
}