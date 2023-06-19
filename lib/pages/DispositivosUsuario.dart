import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practica1/components/Alarmas.dart';
import 'package:practica1/components/Top_navDispositivos.dart';
import 'package:practica1/comun/ToastAlert.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../components/Camaras.dart';
import '../components/Spinner.dart';
import '../components/Top_navDispositivosUsuarios.dart';
import '../comun/Temas.dart';
import '../providers/apiHeader.dart';
import '../providers/apicalls.dart';
import '../providers/comundadProvider.dart';
import '../providers/dispositivosUsuarioProvider.dart';
import '../providers/userProvider.dart';

String api = ApiHeader().api;

final socketUrl = '$api/ws';

class DispositivosUsuario extends StatefulWidget {
  const DispositivosUsuario({super.key});

  @override
  State<DispositivosUsuario> createState() => _DispositivosUsuarioState();
}

class _DispositivosUsuarioState extends State<DispositivosUsuario> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  var dispositivosUsuarios = [];

  bool isLogin = true;
  StompClient? stompClient;

  int comunidadId = 0;
  int usuarioId = 0;

  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination: '/user/comunidad$comunidadId-usuario$usuarioId/private-dispositivo-usuario', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print("It is Working DISPOSITIVOS");
          setState(() {
            // print("______________ SOCKET Dispositivo Usuario _______________");
            // print(frame.body);
          });
        }
      },
    );
  }

  void sendMessage(
      var dispositivo, int dispositivoUserId, int usuarioId, int comunidadId) {
    var chatMessage = {
      "isActive": dispositivo["isActive"],
      "nombre": dispositivo["nombre"],
      "dispositivoId": dispositivoUserId,
      "mensaje": "Dispositivo ACTUALIZADO CORECTAMETNE ",
      "isUpdate": true,
      "comunidadId": comunidadId,
      "usuarioId": usuarioId
    };
    stompClient?.send(
        destination: '/app/private-dispositivo-usuario',
        body: jsonEncode(chatMessage)); //  app/aplication
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

  @override
  void initState() {
    super.initState();
    connect();
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient!.deactivate();
    }

    super.dispose();
  }

  void actualizarDispositivo(var dispositivo, int dispositivoUserId,
      int usuarioId, int comunidadId) async {
    // print("----- DAtos del Dispositivo -----");
    // print("----- DispositivoID -> $dispositivoUserId");
    // print("----- UsuarioID -> $usuarioId");
    // print(dispositivo);
    // print("----- DAtos del Dispositivo FIN -----");

    await ApiCalls()
        .updateStatusDevicesUserByDevice(
            dispositivoUserId, usuarioId, context, dispositivo)
        .then((value) => {
              if (value != false)
                {
                  setState(() {
                    isLogin = true;
                  }),
                  sendMessage(
                      dispositivo, dispositivoUserId, usuarioId, comunidadId),
                  ToastAlert.showCustom(
                      context, dispositivo["nombre"], "Dispositivo Activado"),
                }
              else
                {print("--------  NOOOOOOOOOOOOOOOOOOOOOOOOOOO")}
            });
  }

  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();
    DispositivosUsuarioProvider devicesUserProvider =
        context.watch<DispositivosUsuarioProvider>();
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();

    setState(() {
      // guardamos la comunidad ID y el usuario Id para lo SOCKET
      comunidadId = comunidadProvider.comunidadId;
      usuarioId = usuarioProvider.currentUser["usuario"]["usuario_id"];

      if (!devicesUserProvider.devicesUserExist) {
        ApiCalls().getDevicesByUser(
            context, usuarioProvider.currentUser["usuario"]["usuario_id"]);
      }
    });

    dispositivosUsuarios = devicesUserProvider.devicesUserExist
        ? devicesUserProvider.currentDevicesUser
        : [];
    // var dispositivosUsuarios =  [];
    return SafeArea(
      child: Column(
        children: [
          // nav bar
          // Top_navDispositivos(),
          Top_navDispositivosUsuarios(),
          // info
          !devicesUserProvider.devicesUserExist
              ? Flexible(
                  flex: 1,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: const Offset(5, 5),
                          )
                        ],
                      ),
                      child: Text("Usted no tine dispositivos registrados"),
                    ),
                  ),
                )
              : Flexible(
                  flex: 1,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: dispositivosUsuarios.length,
                    itemBuilder: (BuildContext context, int index) {
                      // !isLogin
                      //     ? Spinner()
                      //     :
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: const Offset(5, 5),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            // CircleAvatar(
                            //   backgroundColor: Colors.amber,
                            //   child: Icon(Icons.abc),
                            // ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: new BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.device_hub,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dispositivosUsuarios[index]["nombre"]
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  dispositivosUsuarios[index]["isActive"]
                                      ? "Activado"
                                      : "Desactivado",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  isLogin = false;
                                });
                                actualizarDispositivo(
                                    dispositivosUsuarios[index],
                                    dispositivosUsuarios[index]
                                        ["dispositivoUsuario_id"],
                                    usuarioProvider.currentUser["usuario"]
                                        ["usuario_id"],
                                    comunidadProvider.comunidadId);

                                // await ApiCalls()
                                //     .updateStatusDevicesUser(
                                // dispositivosUsuarios[index]
                                //     ["dispositivoUsuario_id"],
                                // usuarioProvider.currentUser["usuario"]
                                //     ["usuario_id"],
                                //         context)
                                //     .then(
                                //       (value) => {
                                //         setState(() {
                                //           isLogin = true;
                                //         }),
                                //         ToastAlert().showCustom(
                                //             context, "Dispositivo Activado"),
                                //       },
                                //     );
                              },
                              child: !isLogin
                                  ? CircularProgressIndicator()
                                  : Container(
                                      width: 40,
                                      height: 40,
                                      decoration: new BoxDecoration(
                                        color: !dispositivosUsuarios[index]
                                                ["isActive"]
                                            ? Color.fromARGB(255, 0, 255, 145)
                                            : Color.fromARGB(
                                                255, 196, 245, 224),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.offline_bolt,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
