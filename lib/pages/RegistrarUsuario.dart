import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practica1/components/HeaderWidget.dart';
import 'package:practica1/comun/Temas.dart';
import 'package:http/http.dart' as http;
import 'package:practica1/providers/apicalls.dart';

import '../components/Spinner.dart';

class RegistrarUsuario extends StatefulWidget {
  const RegistrarUsuario({super.key});

  @override
  State<RegistrarUsuario> createState() => _RegistrarUsuarioState();
}

class _RegistrarUsuarioState extends State<RegistrarUsuario> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  final _formKey = GlobalKey<FormState>();
  bool checkedValue = false;
  bool checkboxValue = false;
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidoController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _contrasenaController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();

  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isLogin
          ? Spinner()
          : SingleChildScrollView(
              child: Stack(
                children: [
                  // nav bar
                  Container(
                    height: 150,
                    child: HeaderWidget(
                      150,
                      false,
                      Icons.person_add_alt_1_rounded,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              GestureDetector(
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 5, color: Colors.white),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 20,
                                            offset: const Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey.shade300,
                                        size: 80.0,
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(80, 80, 0, 0),
                                      child: Icon(
                                        Icons.add_circle,
                                        color: Colors.grey.shade700,
                                        size: 25.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                child: TextFormField(
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Nombre", "Ingrese su Nombre"),
                                  controller: _nombreController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Poravor ingrese su nombre";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Apellido", "Ingrese su Apellido"),
                                  controller: _apellidoController,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return "Poravor ingrese su apellido";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "E-mail", "Ingrese su email"),
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) {
                                    if (val!.isEmpty ||
                                        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                            .hasMatch(val)) {
                                      return "Ingrese un correo valido";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Telefono",
                                      "Ingrese su numero de telefono"),
                                  controller: _telefonoController,
                                  keyboardType: TextInputType.phone,
                                  validator: (val) {
                                    if (val!.isEmpty ||
                                        !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                      return "Ingreese un numero valido";
                                    }
                                    return null;
                                  },
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: TextFormField(
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Dirección", "Ingrese su Dirección"),
                                  controller: _direccionController,
                                ),
                                decoration:
                                    TemasAyuda().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: TemasAyuda().textInputDecoracion(
                                      "Contraseña", "Ingrese su contrasen"),
                                  controller: _contrasenaController,
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
                                height: 10,
                              ),
                              FormField<bool>(
                                builder: (state) {
                                  return Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Checkbox(
                                              value: checkboxValue,
                                              onChanged: (value) {
                                                setState(() {
                                                  checkboxValue = value!;
                                                  state.didChange(value);
                                                });
                                              }),
                                          Text(
                                            "Acepta los terminos y condiciones.",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          state.errorText ?? '',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Theme.of(context).errorColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                                validator: (value) {
                                  if (!checkboxValue) {
                                    return 'Nesesita aceptar los terminos y condiciones';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: "Regresar "),
                                      TextSpan(
                                          text: "Login",
                                          style: TextStyle(
                                            color: _accentColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context, '/');
                                            })
                                    ],
                                  ),
                                ),
                              ),
                              // SizedBox(height: 20.0),
                              Container(
                                decoration:
                                    TemasAyuda().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: TemasAyuda().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Register".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      print("campos VALIDOS");

                                      setState(() {
                                        isLogin = false;
                                      });

                                      ApiCalls()
                                          .postNewUser(
                                              _nombreController.text,
                                              _apellidoController.text,
                                              _emailController.text,
                                              _telefonoController.text,
                                              _contrasenaController.text,
                                              _direccionController.text)
                                          .then((value) {
                                        setState(() {
                                          isLogin = true;
                                        });
                                        print(value);
                                        if (value) {
                                          showAlertDialog(
                                              context,
                                              "Correcto",
                                              "Usted se ha registrado correctamente",
                                              true);
                                        } else {
                                          showAlertDialog(
                                              context,
                                              "Algo salió mal",
                                              "Inténtelo más tarde.",
                                              false);
                                        }
                                      }).catchError(
                                        (e) {
                                          showAlertDialog(
                                              context,
                                              "Algo salió mal",
                                              "Inténtelo más tarde.",
                                              false);
                                        },
                                      );
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
