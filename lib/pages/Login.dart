import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practica1/components/Spinner.dart';
import 'package:practica1/comun/temas.dart';
import 'package:practica1/providers/apicalls.dart';
import 'package:practica1/services/notitication_services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';

import '../components/HeaderWidget.dart';
import '../preferences/preferencesUser.dart';
import '../providers/emergenciaReportadaProvider.dart';
import '../providers/userProvider.dart';
import '../services/push_notifications_service.dart';

class Login extends StatefulWidget {
  // final GlobalKey<ScaffoldState> data;
  final GlobalKey<NavigatorState>? navigatorKey;
  const Login({super.key, required this.navigatorKey});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  TextEditingController _correoController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();

  bool isLogin = true;

  var thereIsUsuarLoged;
  // Future<Object> _makePostLogin() async {
  //   String _correo = _correoController.text;
  //   String _contrasena = _contrasenaController.text;

  //   try {
  //     final url = Uri.parse('http://localhost:8080/user/login');
  //     final headers = {"Content-type": "application/json"};
  //     // final json = '{"title": "Hello", "body": "body text", "userId": 1}';
  //     final json = '{ "correo_1": "$_correo", "contrasena": "$_contrasena" }';

  //     // make POST request
  //     final response = await post(url, headers: headers, body: json);

  //     // check the status code for the result
  //     final statusCode = response.statusCode;

  //     // this API passes back the id of the new item added to the body
  //     final body = response.body;
  //     var jsonResponse = jsonDecode(response.body);

  //     // print(jsonResponse['isLogin']);

  //     // print(statusCode.toInt());
  //     // print(body);
  //     if (jsonResponse['isLogin']) {
  //       return jsonResponse;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  void changeLoandingStatus() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  void asyncMethod(context) async {
    await PreferencesUser.getUserLoged(context);
  }

  void asyncMethodEmer(int emergenciaReportada_id) async {
    var data =
        await ApiCalls().getEmergenciaReportadabyId(emergenciaReportada_id);
    // print(data);
    await widget.navigatorKey?.currentContext
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
    await widget.navigatorKey?.currentContext
        ?.read<EmergenciaReportadaProvider>()
        .setComunidadReporta(comunidadReporta: emergenciaReportadaData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asyncMethod(context);

    PushNotificacionService.messageStream.listen((idEmergenciaReportada) {
      print("Emergencia Reportada id -> $idEmergenciaReportada");
      // comprabar sharpreference tiene datos para saber si el usaurio esta logeado
      // Navigator.pushNamed(context, "/home");
      // CUANDO LA APP ESTA ABIERTA
      if (idEmergenciaReportada != "0") {
        // Navigator.pushNamed(context, "/home");
        widget.navigatorKey?.currentState?.pushNamed("/home");
        // GET DE DATA FROM the server
        asyncMethodEmer(int.parse(idEmergenciaReportada));
        // CUANDO LA APP ESTA EN SEGUNDO PLANO
      }else{
        print("ES un MENSAJE");
      }
    });

    // PushNotificacionService.chatStream.listen((event) {
    //   // navega a la pagina de chat
    //   widget.navigatorKey?.currentState?.pushNamed("/perfilUsuario");
    // });
  }

  @override
  Widget build(BuildContext context) {
    UsuarioProvider userProvider = context.watch<UsuarioProvider>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: !isLogin
          ? Spinner()
          : SingleChildScrollView(
              child: Column(
                children: [
                  // header
                  Container(
                    height: _headerHeight,
                    child:
                        HeaderWidget(_headerHeight, true, Icons.login_rounded),
                  ),
                  // login form
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Text(
                            // "Inicio de Seccion",
                            userProvider.isLogin
                                ? userProvider.currentUser["usuario"]
                                        ["correo_1"]
                                    .toString()
                                : "Inicio",
                            // "Inicio Seccion",
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: _primariColor),
                          ),
                          Text(
                            "Ingrese en su cuenta",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Form(
                              child: Column(
                            children: [
                              TextField(
                                decoration: TemasAyuda().textInputDecoracion(
                                    "Correo", "Ingrese su correo"),
                                controller: _correoController,
                                onChanged: (value) {
                                  userProvider.loginStart();
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                obscureText: true,
                                decoration: TemasAyuda().textInputDecoracion(
                                  "Contrasena",
                                  "Ingrese su contrasena",
                                ),
                                onChanged: (value) {
                                  userProvider.loginStart();
                                },
                                controller: _contrasenaController,
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // print("Notidficacion");
                                  // mostrarNotificacion("Emergencia",
                                  //     "Se ha reportado una emergencia");
                                  Navigator.pushNamed(
                                      context, '/recuperarContrasena');
                                  // agendarNotificacion("title"," body");
                                },
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                  alignment: Alignment.topRight,
                                  child: Text('Olvido su contrasena?'),
                                ),
                              ),
                              userProvider.error
                                  ? Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 0, 10, 20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Su correo o contrasena no coinciden',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : Container(),
                              Container(
                                decoration:
                                    TemasAyuda().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: TemasAyuda().buttonStyle(),
                                  onPressed: () async {
                                    // _makePostLogin().then((value) {
                                    //   // print("---------------");
                                    //   // print(value);
                                    //   if (value != false) {
                                    //     Navigator.pushNamed(context, '/home',
                                    //         arguments: value);
                                    //     // showAlertDialog(context, "Usuario Logeado",
                                    //     //     "Usuario logeado correctamente");
                                    //   } else {
                                    //     showAlertDialog(
                                    //         context,
                                    //         "Error. Algo salio mal",
                                    //         "Su correo o contrasena no coinciden");
                                    //   }
                                    // }).catchError(
                                    //   (e) {
                                    //     showAlertDialog(
                                    //         context,
                                    //         "Error. Algo salio mal",
                                    //         "Su correo o contrasena no coinciden");
                                    //   },
                                    // );
                                    // enviamos el contexto y el usuario PERO solo hay que enviar el contexto
                                    // print("****************");
                                    // enviamos el contexto y el correo y la contrasena

                                    setState(() {
                                      isLogin = false;
                                    });
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    // obtenemos los datos del sharePreference en caso de que el suarios ya sea haya logerado por primera ves
                                    // leemos los datos si no existe regresa cero
                                    thereIsUsuarLoged =
                                        prefs.getString('userLoged') ?? 0;

                                    // el usuari se logeo por prmera ves
                                    ApiCalls()
                                        .login(context, _correoController.text,
                                            _contrasenaController.text)
                                        .then((value) async => {
                                              // Intenta leer datos de la clave del contador. Si no existe, retorna 0.
                                              // guardamos los datos en el sharePreference
                                              // cuando el usuario se logea por primnera ves
                                              // print(value),
                                              // print(
                                              //     "________________________________"),
                                              if (thereIsUsuarLoged == 0)
                                                {
                                                  await prefs.setString(
                                                      'userLoged',
                                                      jsonEncode(value)),
                                                  // print(
                                                  //     "_____------ Datos Guardados en PREFERENCES"),
                                                }
                                              else
                                                {
                                                  print(
                                                      "Datos previamnete registrados usuario ......."),
                                                },

                                              if (this.mounted)
                                                {
                                                  setState(() {
                                                    // Your state change code goes here
                                                    // print(value);
                                                    isLogin = true;
                                                  }),
                                                }
                                              // setState(() {
                                              //   print(value);
                                              //   isLogin = true;
                                              // })
                                            });

                                    // print("___________________________");
                                    // print(userProvider.currentUser);
                                    // context.read<UsuarioProvider>().loginSuccesfull(user: "Jonnathan", token: "Carmen");
                                    // Navigator.pushNamed(context, '/home');
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      "Ingresar".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: "Si no tienes un cuenta?"),
                                      TextSpan(
                                          text: "Registrate",
                                          style: TextStyle(
                                            color: _accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(
                                                  context, '/registrarUsuario');
                                            })
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}

void showAlertDialog(BuildContext context, String title, String content) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$content"),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
