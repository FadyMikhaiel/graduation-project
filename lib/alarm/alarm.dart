// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class AlarmService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initializeNotifications() async {
//     var initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');
//     var initializationSettingsIOS = IOSInitializationSettings(
//         requestSoundPermission: true,
//         requestBadgePermission: true,
//         requestAlertPermission: true,
//         onDidReceiveLocalNotification:
//             (int id, String? title, String? body, String? payload) async {});
//     var initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? payload) async {
//       if (payload != null) {
//         debugPrint('notification payload: $payload');
//       }
//     });
//   }

//   static Future<void> scheduleNotification() async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'alarm_channel', 'Alarm', 'Alarm notification channel',
//         importance: Importance.high, priority: Priority.high);
//     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics,
//         iOS: iOSPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//         0,
//         'Alarm',
//         'Your alarm message',
//         _nextInstanceOfEightPM(),
//         platformChannelSpecifics,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absolute,
//         matchDateTimeComponents: DateTimeComponents.time);
//   }

//   static tz.TZDateTime _nextInstanceOfEightPM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate =
//         tz.TZDateTime(tz.local, now.year, now.month, now.day, 20);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }
// }
