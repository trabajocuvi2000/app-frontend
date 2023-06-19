import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("app_icon");

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion(String title, String body) async {
  // notificacion de android
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "ejemplo Id",
    "nombre ejemplo",
    importance: Importance.max,
    priority: Priority.high,
  );

  // // notificacion de IOS (por el momento se esta innorando)
  // const DarwinNotificationDetails darwinNotificationDetails =
  //     DarwinNotificationDetails();

  // es le objeto que contine la configuracion para android
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    // iOS: darwinNotificationDetails, // para android
  );

  await flutterLocalNotificationsPlugin.show(
      1, title, body, notificationDetails);
}


Future<void> agendarNotificacion(String title, String body) async {
  // notificacion de android
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    "ejemplo Id",
    "nombre ejemplo",
    importance: Importance.max,
    priority: Priority.high,
  );

  // // notificacion de IOS (por el momento se esta innorando)
  // const DarwinNotificationDetails darwinNotificationDetails =
  //     DarwinNotificationDetails();

  // es le objeto que contine la configuracion para android
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    // iOS: darwinNotificationDetails, // para android
  );

  await flutterLocalNotificationsPlugin.periodicallyShow(1, title, body, RepeatInterval.everyMinute, notificationDetails);
}