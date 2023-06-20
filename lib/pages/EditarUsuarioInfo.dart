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

import '../components/Top_navEditarUsuarioInfo.dart';
import '../comun/ToastAlert.dart';
import '../providers/userProvider.dart';

class EditarUsuarioInfo extends StatefulWidget {
  const EditarUsuarioInfo({super.key});

  @override
  State<EditarUsuarioInfo> createState() => _EditarUsuarioInfoState();
}

class _EditarUsuarioInfoState extends State<EditarUsuarioInfo> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();
    _nombreController.text = usuarioProvider.isLogin
        ? usuarioProvider.currentUser["usuario"]["usuarioVecino"]["nombre"]
                .toString() +
            " "
        : "";
    _apellidoController.text = usuarioProvider.isLogin
        ? usuarioProvider.currentUser["usuario"]["usuarioVecino"]["apellido"]
            .toString()
        : "";
    _direccionController.text = usuarioProvider.isLogin
        ? usuarioProvider.currentUser["usuario"]["usuarioVecino"]["direccion"]
            .toString()
        : "";
    _emailController.text = usuarioProvider.isLogin
        ? usuarioProvider.currentUser["usuario"]["correo_1"].toString()
        : "";
    _telefonoController.text = usuarioProvider.isLogin
        ? usuarioProvider.currentUser["usuario"]["usuarioVecino"]["telefono_1"]
            .toString()
        : "";

    void actualizarDatosUsuario(var usuario) async {
      // print(usuario);
      usuario["usuarioVecino"]["nombre"] = _nombreController.text;
      usuario["usuarioVecino"]["apellido"] = _apellidoController.text;
      usuario["usuarioVecino"]["direccion"] = _direccionController.text;
      usuario["usuarioVecino"]["telefono_1"] = _telefonoController.text;
      usuario["correo_1"] = _emailController.text;
      // print("----------------------  ");
      // print(usuario);

      await ApiCalls().putUsuario(context, usuario).then((value) => {
            if (value == -1)
              {
                setState(() {
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
            Top_navEditarUsuarioInfo(),
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            !isLogin
                ? CircularProgressIndicator()
                : Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              decoration: TemasAyuda().textInputDecoracion(
                                  "Nombre", "Ingrese su nombre"),
                              controller: _nombreController,
                            ),
                            decoration:
                                TemasAyuda().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: TemasAyuda().textInputDecoracion(
                                  "Apellido", "Ingrese su apellido"),
                              controller: _apellidoController,
                            ),
                            decoration:
                                TemasAyuda().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: TemasAyuda().textInputDecoracion(
                                  "Dirección", "Ingrese su dirección"),
                              controller: _direccionController,
                            ),
                            decoration:
                                TemasAyuda().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              decoration: TemasAyuda().textInputDecoracion(
                                  "E-mail", "Ingrese su e-mail"),
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                if (!(val!.isEmpty) &&
                                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                  return "Ingrese un correo válido";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                TemasAyuda().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            child: TextFormField(
                              decoration: TemasAyuda().textInputDecoracion(
                                  "Teléfono", "Ingrese su número de teléfono"),
                              controller: _telefonoController,
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                if (!(val!.isEmpty) &&
                                    !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                  return "Ingrese un número válido";
                                }
                                return null;
                              },
                            ),
                            decoration:
                                TemasAyuda().inputBoxDecorationShaddow(),
                          ),
                          SizedBox(height: 20.0),
                          GestureDetector(
                            onTap: () {
                              // print("Actualizar contrasena");
                              Navigator.pushNamed(
                                  context, '/actualizarContrasena');
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              alignment: Alignment.topRight,
                              child: Text('Actualizar contraseña'),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            decoration:
                                TemasAyuda().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: TemasAyuda().buttonStyle(),
                              onPressed: () {
                                setState(() {
                                  isLogin = false;
                                });
                                actualizarDatosUsuario(
                                    usuarioProvider.currentUser["usuario"]);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
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
                          ),
                          SizedBox(height: 30.0),
                        ],
                      ),
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
