
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import '../main.dart';

class NotificationControl {
  late BuildContext context;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

  void initialNotification() async {
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,  onDidReceiveNotificationResponse:onDidReceiveNotificationResponse);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context,
        MaterialPageRoute<void>(builder: (context) => const MyApp())
    );
  }
  //
  // void sendNotification(
  //     {
  //       String? title,
  //       String? body,
  //     }
  //     )async{
  //   DateTime now = DateTime.now().add(const Duration(seconds: 10));
  //   AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
  //       "channelId 1",
  //       "channelName 1",
  //       importance: Importance.max,
  //       priority: Priority.max
  //   );
  //   NotificationDetails notificationDetails =NotificationDetails(
  //       android: androidNotificationDetails
  //   );
  //   await flutterLocalNotificationsPlugin.show( 0, title, body, notificationDetails);
  //
  // }

  void scheduleNotification(
      int id,
      String? title,
      String? body,
      DateTime scheduleTime
      )async{
    int scheduleTimeInMilliSeconds = scheduleTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    print(scheduleTime);
    print(DateTime.now().millisecondsSinceEpoch);
    print(scheduleTimeInMilliSeconds);
    DateTime now = DateTime.now().add(const Duration(seconds: 10));
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
        "Schedule1",
        "Remainder alert1",
        sound: RawResourceAndroidNotificationSound("notifications"),
        importance: Importance.max,
        priority: Priority.max
    );
    NotificationDetails notificationDetails =NotificationDetails(
        android: androidNotificationDetails
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, tz.TZDateTime.now(tz.local).add( Duration(milliseconds: scheduleTimeInMilliSeconds )), notificationDetails , uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,);
  }

  void cancelNotification()async{
    flutterLocalNotificationsPlugin.cancelAll();
  }

}