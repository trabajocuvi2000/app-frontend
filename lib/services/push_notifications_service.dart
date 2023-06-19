import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificacionService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;

  // EMERGENCIAS

  static StreamController<String> _messageStream =
      new StreamController.broadcast();

  static Stream<String> get messageStream => _messageStream.stream;

  // CHAT

  static StreamController<String> _chatStream =
      new StreamController.broadcast(); // esto aun no pruebo

  static Stream<String> get chatStream => _chatStream.stream;  // esto aun no pruebo

  static Future _backgroundHandler(RemoteMessage message) async {
    // print("onBackgraund Handler ${message.messageId}");
    // print("onBackgraund Handler");
    // print(message.data);
    // _messageStream.add(message.notification?.title ?? "No Title");
    _messageStream.add(
        message.data["emergenciaReportadaId"] ?? "0");
    _chatStream.add("nuevo chat"); // aun no se prueba
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    // print("onMessage Handler ${message.messageId}");
    // print("onMessage Handler");
    // print(message.data["emergenciaReportadaId"]);
    _messageStream.add(
        message.data["emergenciaReportadaId"] ?? "0");
    _chatStream.add("nuevo chat");// aun no se prueba
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    // print("onMessageOpenApp Handler ${message.messageId}");
    // print("onMessageOpenApp Handler");
    // print(message.data);
    _messageStream.add(
        message.data["emergenciaReportadaId"] ?? "0");
    _chatStream.add("nuevo chat");// aun no se prueba
  }

  static Future initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    // await FirebaseMessaging.instance.unsubscribeFromTopic("comunidad1").then((value) => {
    //       print("UnSubscrito a comunidad 1"),
    //     });
    // ELIMINAR esta SUBSCRIPCION
    await FirebaseMessaging.instance.subscribeToTopic("com1").then((value) => {
          print("Subscrito a comunidad 1"),
        });
    print("TOKEN  $token");

    // Handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static Future subscribeCommunity(int comunidadId) async {
    // para subscribirse a una comunidad solo con letras y numeros
    await FirebaseMessaging.instance
        .subscribeToTopic("comunidad$comunidadId")
        .then((value) => {
              print("Subscrito a comunidad$comunidadId"),
            });
  }

  static Future unSubscribeCommunity(int comunidadId) async {
    await FirebaseMessaging.instance
        .unsubscribeFromTopic("comunidad$comunidadId")
        .then((value) => {
              print("Un.....Subscrito a comunidad$comunidadId"),
            });
  }

  static Future initializeAppWeb() async {
    // Push Notifications
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyD890n4azhKTFnX_9nhG7cL0kh8sqWMCc4",
          authDomain: "flutter-notificaciones-7cba0.firebaseapp.com",
          projectId: "flutter-notificaciones-7cba0",
          storageBucket: "flutter-notificaciones-7cba0.appspot.com",
          messagingSenderId: "828479403263",
          appId: "1:828479403263:web:2875b8f43f79421d8e08ca",
          measurementId: "G-4M49J0KZFP"),
    );
    // token = await FirebaseMessaging.instance.getToken();
    // await FirebaseMessaging.instance.unsubscribeFromTopic("com2").then((value) => {
    //       print("UnSubscrito a comunidad 2"),
    //     });
    await FirebaseMessaging.instance.subscribeToTopic("com1").then((value) => {
          print("Subscrito a comunidad 1"),
        });
    print("TOKEN  $token");

    // Handler
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static _closeStreams() {
    _messageStream.close();
  }
}
