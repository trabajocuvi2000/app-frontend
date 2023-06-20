import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practica1/pages/ActualizarUsuarioContrasena.dart';
import 'package:practica1/pages/Chat.dart';
import 'package:practica1/pages/ComunidadInfo.dart';
import 'package:practica1/pages/Dispositivos.dart';
import 'package:practica1/pages/EditarUsuarioInfo.dart';
import 'package:practica1/pages/Emergencia.dart';
import 'package:practica1/pages/Emergencias%20copy.dart';
import 'package:practica1/pages/Error_404.dart';
import 'package:practica1/pages/GestionUsuarios.dart';
import 'package:practica1/pages/HomePage.dart';
import 'package:practica1/pages/Login.dart';
import 'package:practica1/pages/PerfilUsuario.dart';
import 'package:practica1/pages/RecuperarContreasena.dart';
import 'package:practica1/pages/RegistrarUsuario.dart';
import 'package:practica1/pages/SplashPage.dart';
import 'package:practica1/preferences/preferencesUser.dart';
import 'package:practica1/providers/apicalls.dart';
import 'package:practica1/providers/dispositivosUsuarioProvider.dart';
import 'package:practica1/providers/emergenciaReportadaProvider.dart';
import 'package:practica1/providers/comundadProvider.dart';
import 'package:practica1/providers/emergenciasProvider.dart';
import 'package:practica1/providers/messagesProvider.dart';
import 'package:practica1/providers/spinnerStataus.dart';
import 'package:practica1/providers/userProvider.dart';
import 'package:practica1/providers/usuariosComunidadProvider.dart';
import 'package:practica1/services/notitication_services.dart';
import 'package:practica1/services/push_notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

// void main() {
//   runApp(const MyApp());
// }

// notifiaciones locales (no estoy seguro si funciona o no on servidores)
void main() async {
  // se acgura de que se corran todas las inicializaciones antes de correr el metodo "runApp"
  WidgetsFlutterBinding.ensureInitialized();

  // await PushNotificacionService.initializeApp();
  await initNotifications(); // inicializamos localNotification,
  // luego de iniciarlizarce llama a la aplicaicon y se ejecuta
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  // const MyApp({super.key});
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
   final GlobalKey<NavigatorState> _navigatorKey =
      new GlobalKey<NavigatorState>();

  StompClient? stompClient;

  String message = '';
  var mesanjes = [];

  var chatMessage = {"senderName": "juan", "status": "JOIN"};
  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination: '/chatroom/public', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print("It is Working");
          setState(() {
            print("_____________________________");
            mesanjes.add(frame.body);
            mostrarNotificacion(jsonDecode(frame.body.toString())["senderName"],
                jsonDecode(frame.body.toString())["message"]);

            // for (var i = 0; i < mesanjes.length; i++) {
            //   print(mesanjes[i]);
            //   print(jsonDecode(mesanjes[i])["message"]);
            // }
          });
        }
      },
    );
  }

  void connect() {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: (p0) => onConnect(p0),
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient!.activate();
  }

  void asyncMethod(int emergenciaReportada_id) async {
    var data =
        await ApiCalls().getEmergenciaReportadabyId(emergenciaReportada_id);
    // print(data);
    _navigatorKey.currentContext
        ?.read<EmergenciaReportadaProvider>()
        .setEmergenciaReportada(newEmergency: jsonDecode(data.toString()));
    // print("------------ COMUNIDAD REPORTAD ----------------");
    // print(jsonDecode(data.toString())["usuario"]["comunidad"]);

    var emergenciaReportadaData = {
      "emergenciaReportadaId": emergenciaReportada_id,
      "emergenciaId": jsonDecode(data.toString())["emergencia"]
          ["emergencia_id"],
      "comunidadId": jsonDecode(data.toString())["usuario"]["comunidad"]
          ["comunidad_id"],
      "usuarioSenderId": jsonDecode(data.toString())["usuario"]["usuario_id"],
      "emergenciaReportada": jsonDecode(data.toString()),
    };

    // esto falta
    _navigatorKey.currentContext
        ?.read<EmergenciaReportadaProvider>()
        .setComunidadReporta(comunidadReporta: emergenciaReportadaData);
  }

  void asyncMethodUser() async {
    await PreferencesUser.getUserLoged(_navigatorKey.currentContext);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // // obtenemos los datos de memoria del usuario
    // asyncMethodUser();

    // PushNotificacionService.messageStream.listen((idEmergenciaReportada) {
    //   print("Emergencia Reportada id -> $idEmergenciaReportada");
    //   // comprabar sharpreference tiene datos para saber si el usaurio esta logeado
    //   // Navigator.pushNamed(context, "/home");
    //   // CUANDO LA APP ESTA ABIERTA
    //   _navigatorKey.currentState?.pushNamed("/home");
    //   // GET DE DATA FROM the server
    //   asyncMethod(int.parse(idEmergenciaReportada));
    //   // CUANDO LA APP ESTA EN SEGUNDO PLANO
    // });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   WidgetsBinding.instance.removeObserver(this);
  //   super.dispose();
  // }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    // Detecta si la app esta funcionando en el backgraound
    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      // connect();
      // TextPreferences.setText(controller.text);
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsuarioProvider>(
            create: (_) => UsuarioProvider()),
        ChangeNotifierProvider<ComunidadProvider>(
            create: (_) => ComunidadProvider()),
        ChangeNotifierProvider<EmergenciaProvider>(
            create: (_) => EmergenciaProvider()),
        ChangeNotifierProvider<UsuariosComunidadProvider>(
            create: (_) => UsuariosComunidadProvider()),
        ChangeNotifierProvider<EmergenciaReportadaProvider>(
            create: (_) => EmergenciaReportadaProvider()),
        ChangeNotifierProvider<DispositivosUsuarioProvider>(
            create: (_) => DispositivosUsuarioProvider()),
        ChangeNotifierProvider<SpinnerStataus>(create: (_) => SpinnerStataus()),
        ChangeNotifierProvider<MessagesProvider>(
            create: (_) => MessagesProvider()),
      ],
      builder: (context, _) {
        UsuarioProvider userProvider = context.watch<UsuarioProvider>();
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: _navigatorKey,
          title: 'Flutter Demo',
          // home: HomePage(),
          initialRoute: "/",
          routes: {
            '/': ((context) =>
                userProvider.isLogin ?  HomePage() :  Login(navigatorKey: _navigatorKey)),
            '/perfilUsuario': ((context) => const PerfilUsuario()),
            '/registrarUsuario': ((context) => const RegistrarUsuario()),
            '/home': ((context) => const HomePage()),
            '/splashPage': ((context) => const SplashPage()),
            '/emergencia': ((context) => const Emergencia()),
            '/comunidadInfo': ((context) => const ComunidadInfo()),
            '/editarUsuarioInfo': ((context) => const EditarUsuarioInfo()),
            '/recuperarContrasena': ((context) => const RecuperarContreasena()),
            '/actualizarContrasena': ((context) => const ActualizarUsuarioContrasena()),
            // '/emergencias': ((context) => const Emergencias()),
            // '/dispositivos': ((context) => const Dispositivos()),
            // '/gestionUsuarios': ((context) => const GestionUsuarios()),
            // '/chat': ((context) => const Chat()),
            // link tutorial -> https://www.youtube.com/watch?v=mN5Co64gsT0
          },
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const Error_404(),
            );
          },
        );
      },
    );
  }
}
