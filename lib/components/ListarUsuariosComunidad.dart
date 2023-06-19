import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Alertas.dart';
import 'package:practica1/components/Spinner.dart';
import 'package:practica1/providers/comundadProvider.dart';
import 'package:practica1/providers/usuariosComunidadProvider.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../comun/Temas.dart';
import '../providers/apiHeader.dart';
import '../providers/apicalls.dart';
import '../providers/userProvider.dart';
import 'package:intl/intl.dart';

String api = ApiHeader().api;

final socketUrl = '$api/ws';

bool isUpdateCommunityUser = false;

class ListarUsuariosComunidad extends StatefulWidget {
  const ListarUsuariosComunidad({super.key});

  @override
  State<ListarUsuariosComunidad> createState() =>
      _ListarUsuariosComunidadState();
}

class _ListarUsuariosComunidadState extends State<ListarUsuariosComunidad> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  // bool isLoanding = true;
  bool aux = false;

  StompClient? stompClient;

  int comunidadId = 0;
  int usuarioId = 0;

  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination:
          '/user/comunidad$comunidadId-usuario$usuarioId/private-usuario-auctualizar-comunidad', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          setState(() {
            print(
                "______________ SOCKET Actualizar Comunidad Usuario _______________");
            print(frame.body);
          });
        }
      },
    );
  }

  void sendMessage(int comunidadId, int usuarioVecinoId, int usuarioAdminId) {
    print("------ SEND message SOCKET ");
    print(comunidadId);
    print(usuarioVecinoId);
    print(usuarioAdminId);
    var chatMessage = {
      "comunidadId": comunidadId,
      "usuarioVecinoId": usuarioVecinoId,
      "usuarioAdminId": usuarioAdminId,
      "isInCommunity": false,
    };
    stompClient?.send(
        destination: '/app/private-usuario-auctualizar-comunidad',
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

  @override
  Widget build(BuildContext context) {
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    UsuariosComunidadProvider usuariosComunidadProvider =
        context.watch<UsuariosComunidadProvider>();
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();
    setState(() {
      // isLoanding = false;
      // if (!usuariosComunidadProvider.usuriosComunidadExist) { // this was before but it just runed one time
      if (!aux) {
        ApiCalls().getUsuariosComunidad(context, comunidadProvider.comunidadId);
        aux = true;
        // print("_____ ListaUsuariosComunidad _______");
      }
      // isLoanding = true;
    });
    var usuariosComunidad = usuariosComunidadProvider.usuriosComunidadExist
        ? usuariosComunidadProvider.currentUsuriosComunidad
        : [];

    // return !isLoanding // this was before but it did not work
    return !usuariosComunidadProvider.usuriosComunidadExist
        ? Spinner()
        : Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Text(
                  "Usuarios Registrados Comunidad",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _primariColor, //0xFF4C53A2
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: usuariosComunidad.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
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
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 4,
                        //     color: Colors.grey.shade400,
                        //   ),
                        // ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        Color.fromARGB(255, 212, 130, 111),
                                    child: Text(
                                      usuariosComunidad[index]
                                                  ["usuarioVecino"] !=
                                              null
                                          ? usuariosComunidad[index]
                                                  ["usuarioVecino"]["nombre"][0]
                                              .toUpperCase()
                                          : "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  // Icon(Icons.person),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  // Datos Usarios
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Nombre: ",
                                                style:
                                                    TemasAyuda.textStyleList),
                                            TextSpan(
                                                text: usuariosComunidad[index]
                                                            ["usuarioVecino"] !=
                                                        null
                                                    ? usuariosComunidad[index]
                                                            ["usuarioVecino"]
                                                        ["nombre"]
                                                    : "",
                                                style:
                                                    TemasAyuda.textStyleList),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                                text: "Correo: ",
                                                style:
                                                    TemasAyuda.textStyleList2),
                                            TextSpan(
                                                text:
                                                    '${usuariosComunidad[index]["correo_1"]}',
                                                style:
                                                    TemasAyuda.textStyleList2),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Container(
                            //   child: Text(
                            //       usuariosComunidad[index]["isAdmin"].toString()),
                            // ),
                            !usuarioProvider.isAdmin
                                ? SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      if (!usuariosComunidad[index]
                                          ["isAdmin"]) {
                                        showAlertDialogUpdateUsuario(
                                            context,
                                            usuariosComunidad[index],
                                            comunidadProvider.comunidadId,
                                            usuarioProvider
                                                    .currentUser["usuario"]
                                                ["usuario_id"]);
                                        // enviamos el mensaje via socket    
                                        if (isUpdateCommunityUser) {
                                          sendMessage(
                                              comunidadId,
                                              usuariosComunidad[index]
                                                  ["usuario"]["usuario_id"],
                                              usuarioProvider
                                                      .currentUser["usuario"]
                                                  ["usuario_id"]);
                                        }
                                      } else {
                                        Alertas().showAlertDialog(
                                            context,
                                            "Lo sentimos",
                                            "No se puede eliminar este usuario");
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            // darkshadow i the bottom right
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: Offset(1, 1),
                                              spreadRadius: 1,
                                            ),
                                            // // lighter on the top left
                                            BoxShadow(
                                              color: Colors.grey.shade50,
                                              offset: Offset(-1, -1),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            )
                                          ]),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
                  },
                  // separatorBuilder: (BuildContext context, int index) => const Divider(),
                ),
              ),
            ],
          );
  }
}

void showAlertDialogUpdateUsuario(
    BuildContext context, var usuarioVecino, comunidadId, int usuarioAdminId) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Eliminar Usuario"),
    content: Text("Esta seguro de que desea eliminar este usuario"),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: TemasAyuda().buttonBoxDecoration(context),
            child: ElevatedButton(
              style: TemasAyuda().buttonStyle(),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: TemasAyuda().buttonBoxDecoration(context),
            child: ElevatedButton(
              style: TemasAyuda().buttonStyle(),
              onPressed: () {
                // print(usuarioVecino["usuario"]);
                ApiCalls()
                    .putUsuarioComunidad(context, usuarioVecino, comunidadId)
                    .then((value) => {
                          if (value != -1)
                            {
                              isUpdateCommunityUser = true,
                              // print("Usuario eliminado correctamente"),
                            }
                        });
                // cerramos la ventana
                Navigator.of(context).pop();
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
          ),
        ],
      ),
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
