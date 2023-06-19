import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/providers/apicalls.dart';
import 'package:practica1/providers/userProvider.dart';
import 'package:practica1/services/push_notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../comun/Temas.dart';
import '../providers/comundadProvider.dart';
import '../providers/emergenciasProvider.dart';
import '../providers/usuariosComunidadProvider.dart';
import 'Spinner.dart';

class RegistrarVecino extends StatefulWidget {
  const RegistrarVecino({super.key});

  @override
  State<RegistrarVecino> createState() => _RegistrarVecinoState();
}

class _RegistrarVecinoState extends State<RegistrarVecino> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  TextEditingController _codeQR = TextEditingController();
  bool isLogin = true;

  void scanQR() async {
    String cameraScanResult = await scanner.scan().toString();
    setState(() {
      _codeQR.text = cameraScanResult;
    });
  }

  void isLoginStatus(bool value) {
    setState(() {
      isLogin = value;
    });
  }

  Future<void> subscribeCcmmunity(int comunidadId) async {
    await PushNotificacionService.subscribeCommunity(comunidadId);
  }

  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();
    // para actualizar la vista de los usuarios de la comunidad del usuario
    UsuariosComunidadProvider usuariosComunidadProvider =
        context.watch<UsuariosComunidadProvider>();

    // this two proivder must be delete
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    EmergenciaProvider emergenciasProvider =
        context.watch<EmergenciaProvider>();
    return !isLogin
        ? Spinner()
        : Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(
                  "Unirme a una comunidad",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _primariColor, //0xFF4C53A2
                  ),
                ),
              ),
              // info
              Flexible(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        child: Text(
                          "Escanear código QR",
                          style: TemasAyuda.textStyle2,
                        ),
                      ),
                      // escaner codigo QR
                      GestureDetector(
                        // onTap: () => scanQR(),
                        onTap: () {
                          print("escaneando codigo QR");
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          margin: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                          child: SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(Icons.camera),
                            ),
                          ),
                          // child: Icon(Icons.camera),
                        ),
                      ),

                      Container(
                        child: Text("O", style: TemasAyuda.textStyle2),
                      ),

                      TextField(
                        decoration: TemasAyuda().textInputDecoracion(
                            "Código", "Ingrese el código de la comunidad"),
                        controller: _codeQR,
                      ),

                      // button, when I use "Flexible" the button takes the whole withe
                      Container(
                        decoration: TemasAyuda().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: TemasAyuda().buttonStyle(),
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                            if (_codeQR.text.length > 0) {
                              ApiCalls()
                                  .addComunidadUsuario(
                                      context,
                                      usuarioProvider.currentUser["usuario"],
                                      _codeQR.text)
                                  .then((value) => {
                                        // print(
                                        //     "This is the data after updating user community "),
                                        // print(value),
                                        if (value != false)
                                          {
                                            print("_____________________"),
                                            print(jsonDecode(value.toString())[
                                                "comunidad"]["comunidad_id"]),
                                            print("________DATOS_____________"),
                                            subscribeCcmmunity(
                                                jsonDecode(value.toString())[
                                                        "comunidad"]
                                                    ["comunidad_id"]),
                                            // PushNotificacionService.subscribeCommunity(jsonDecode(value.toString())[
                                            //     "comunidad"]["comunidad_id"]),
                                          },
                                        setState(() {
                                          isLogin = true;
                                        })
                                      });
                            } else {
                              print(
                                  "Porfavor ingrese el codigo de la comunidad");
                            }
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
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
