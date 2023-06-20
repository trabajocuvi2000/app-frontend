import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practica1/components/HeaderWidget.dart';
import 'package:practica1/comun/Temas.dart';
import 'package:http/http.dart' as http;
import 'package:practica1/providers/apicalls.dart';
import 'package:provider/provider.dart';

import '../components/Top_navActualizarUsuarioContrasena.dart';
import '../components/Top_navEditarUsuarioInfo.dart';
import '../comun/ToastAlert.dart';
import '../providers/userProvider.dart';

class ActualizarUsuarioContrasena extends StatefulWidget {
  const ActualizarUsuarioContrasena({super.key});

  @override
  State<ActualizarUsuarioContrasena> createState() =>
      _ActualizarUsuarioContrasenaState();
}

class _ActualizarUsuarioContrasenaState
    extends State<ActualizarUsuarioContrasena> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;

  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _contrasenaNuevaController = TextEditingController();

  bool isLogin = true;

  bool contrasenaValido = true;

  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();

    void actualizarDatosUsuario(var usuario) async {
      usuario["contrasena"] = _contrasenaController
          .text; // ingresamos la contrasena anterior para comprobar
      ApiCalls()
          .postActualizarContraseaUsuario(
              context, usuario, _contrasenaNuevaController.text)
          .then((value) => {
                if (value == -1 || value == 0)
                  {
                    setState(() {
                      if (value == 0) {
                        contrasenaValido = false;
                      }
                      isLogin = true;
                    }),
                    ToastAlert.showCustomUserUpdateFailed(context),
                  }
                else
                  {
                    setState(() {
                      isLogin = true;
                    }),
                    ToastAlert.showCustomUserUpdate(context),
                  }
              });
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Top_navActualizarUsuarioContrasena(),
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            !isLogin
                ? CircularProgressIndicator()
                : Container(
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Contraseña", "Ingrese su contraseña"),
                                  controller: _contrasenaController,
                                  onChanged: (value) {
                                    setState(() {
                                      contrasenaValido = true;
                                    });
                                  },
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Poravor ingrese su contrasena";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Contraseña nueva",
                                      "Ingrese su nueva contraseña"),
                                  controller: _contrasenaNuevaController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Poravor ingrese su nueva contrasena";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              !contrasenaValido
                                  ? Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 20, 10, 0),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Su contraseña no coincide',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                decoration:
                                    TemasAyuda().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: TemasAyuda().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Aceptar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        isLogin = false;
                                      });
                                      actualizarDatosUsuario(usuarioProvider
                                          .currentUser["usuario"]);
                                    } else {
                                      print("Campos incorrectos");
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 30.0),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

void showAlertDialog(
    BuildContext context, String title, String content, bool val) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$content"),
    actions: [
      val
          ? Container(
              decoration: TemasAyuda().buttonBoxDecoration(context),
              child: ElevatedButton(
                style: TemasAyuda().buttonStyle(),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Aceptar",
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Text("")
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
