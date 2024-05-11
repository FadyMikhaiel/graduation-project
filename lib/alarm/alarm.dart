import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload == 'AzkarAlarm') {
      //navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => AzkarScreen()));
    }
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;

    if (payload == 'AzkarAlarm') {
      //navigatorKey.currentState!.push(MaterialPageRoute(builder: (_) => AzkarScreen()));
    }
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> mainFun() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  static Future<void> scheduleAlarm(String title, String description,
     ) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'task_notify', 'task_notify',
        channelDescription: 'Channel for Alarm notification',
        // sound: RawResourceAndroidNotificationSound('alarmringtone'),
        priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
      // sound: 'a_long_cold_sting.wav',
      presentAlert: true,
      presentBadge: true,
      // presentSound: true,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    var notificationDetails = NotificationDetails(android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      description,
      notificationDetails,
      payload: 'task',
      
    );
  }

  static tz.TZDateTime convertStringToTZDateTime(String dateTimeString) {
    // Parse the string into individual components (year, month, day, hour, minute)
    final dateTimeComponents = dateTimeString.split(' ');
    final dateComponents = dateTimeComponents[0].split('-');
    final timeComponents = dateTimeComponents[1].split(':');

    final year = int.parse(dateComponents[0]);
    final month = int.parse(dateComponents[1]);
    final day = int.parse(dateComponents[2]);
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);

    // Create a TZDateTime object using the parsed components and the specified time zone
    final location = tz.getLocation(tz.local.name);
    final tzDateTime = tz.TZDateTime(
      location,
      year,
      month,
      day,
      hour,
      minute,
    );

    return tzDateTime.subtract(Duration(hours: 3));
  }
}
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
