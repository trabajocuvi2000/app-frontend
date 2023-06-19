import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/SmsWidget.dart';
import 'package:practica1/components/SmsWidgetOther.dart';
import 'package:practica1/components/Top_navChat.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../components/Spinner.dart';
import '../providers/apiHeader.dart';
import '../providers/apicalls.dart';
import '../providers/comundadProvider.dart';
import '../providers/messagesProvider.dart';
import '../providers/userProvider.dart';

String api = ApiHeader().api;

final socketUrl = '$api/ws';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  TextEditingController _mensaje = TextEditingController();
  var comunidadiD;

  StompClient? stompClient;

  String message = '';
  var mesanjes = [];

  ScrollController _scrrollController = ScrollController();
  bool _needsScroll = false;

  bool isLoandingChat = true;

  bool isNewMessage = false;

  int comunidadID = 0;

  bool isSendingMessage = true;

  var chatMessage = {"senderName": "juan", "status": "JOIN"};
  void onConnect(StompFrame frame) {
    stompClient?.subscribe(
      destination: '/user/comunidad$comunidadID/private-chat', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print("It is Working");
          setState(() {
            // print("___________ socket CHAT __________________");
            mesanjes.add(jsonDecode(frame.body.toString()));
            // print(comunidadiD);
            _needsScroll = true;

            // for (var i = 0; i < mesanjes.length; i++) {
            //   print(mesanjes[i]);
            //   print(jsonDecode(mesanjes[i])["message"]);
            // }
          });
        }
      },
    );
  }

  void sendMessage(int sendeId, String name, int groupId) {
    var chatMessage = {
      "senderName": name,
      "senderId": sendeId,
      "message": _mensaje.text,
      "receiveGroup": groupId,
      "status": "MESSAGE"
    };
    stompClient?.send(
        destination: '/app/private-chat',
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

  Future<void> setMessage(var usuario, int comunidadId) async {
    await ApiCalls()
        .setMensajeComunidad(context, comunidadId, usuario, _mensaje.text)
        .then(
          (value) => {
            if (value != -1)
              {
                sendMessage(usuario["usuario_id"],
                    usuario["usuarioVecino"]["nombre"], comunidadId),
                // print("Mensaje  Guardad  y NOTIFICADO ...."),
                setState(() {
                  message = _mensaje.text;
                  isNewMessage = true;
                  isSendingMessage = true;
                }),
                _mensaje.clear(),
              }
            else
              {print("Mensje NOOOOOOOOOO guardado....")},
          },
        );

    // notifico Mensaje FIREBASE
    if (isNewMessage) {
      await ApiCalls()
          .notificationMensajeFirebase(
              usuario["usuarioVecino"]["nombre"], message, comunidadId)
          .then(
            (value) => {
              if (value != false)
                {
                  print("Mensaje NOtificado Firebase"),
                }
              else
                {
                  print("Emergencia NOOOOOO Notificadad con FIREBASE"),
                }
            },
          );
    } else {
      print("_____NOOOOOOOOOOOOOOOOOOOOOOo_____________");
    }
  }

  _scrollToEnd() async {
    _scrrollController.animateTo(_scrrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  bool aux = false;

  Future<void> getMessages(int comunidadId) async {
    setState(() {
      _needsScroll = true;
    });
    await ApiCalls()
        .getMensajesComunidad(context, comunidadId)
        .then((value) => {
              setState(() {
                print("//////// is loging chat $isLoandingChat");
                isLoandingChat = true;
                print("//////// is loging chat $isLoandingChat");
              }),
            });
  }

  @override
  Widget build(BuildContext context) {
    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    MessagesProvider mensajesProvider = context.watch<MessagesProvider>();

    setState(() {
      // guardamos el ID de la comunidad para usar en el socket
      comunidadID = comunidadProvider.comunidadId;
      if (!aux) {
        isLoandingChat = false;
        getMessages(comunidadProvider.comunidadId);
        aux = true;
      }
    });

    mesanjes = mensajesProvider.mensajesComunidadExist
        ? mensajesProvider.mensajesComunidad
        : [];
    // print("-- Mensajes --");
    // print(mesanjes);
    // print("----- MENSJAES alamcenados ------");
    // print(mensajesProvider.mensajesComunidadExist
    //     ? mensajesProvider.mensajesComunidad : "_______ No hay mesnajes _____");

    return SafeArea(
      child: Column(
        children: [
          Top_navChat(),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        // padding: EdgeInsets.all(5),
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 246, 247, 253),
                          // border: Border.all(
                          //     color: const Color.fromARGB(255, 177, 178, 180),
                          //     width: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: !isLoandingChat
                            ? Spinner()
                            : ListView.builder(
                                controller: _scrrollController,
                                padding: const EdgeInsets.all(5),
                                itemCount: mesanjes.length,
                                itemBuilder: (BuildContext context, int index) {
                                  if (_needsScroll) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                            (_) => _scrollToEnd());
                                    _needsScroll = false;
                                  }
                                  comunidadiD = comunidadProvider.comunidadId;
                                  if (mesanjes[index]["receiveGroup"] ==
                                      comunidadiD) {
                                    if (mesanjes[index]["senderId"] ==
                                        usuarioProvider.currentUser["usuario"]
                                            ["usuario_id"]) {
                                      return SmsWidget(
                                          sender: mesanjes[index]["senderName"]
                                              .toString(),
                                          sms: mesanjes[index]["message"]
                                              .toString());
                                    } else {
                                      return SmsWidgetOther(
                                          sender: mesanjes[index]["senderName"]
                                              .toString(),
                                          sms: mesanjes[index]["message"]
                                              .toString());
                                    }
                                  } else {
                                    // return Text("comunidad $comunidadiD");
                                    return SizedBox.shrink();
                                  }
                                },
                                // separatorBuilder: (BuildContext context, int index) => const Divider(),
                              )),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _mensaje,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            hintText: "Escriba aqui ...",
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide: BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.teal,
                        radius: 25,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: !isSendingMessage
                              ? CircularProgressIndicator()
                              : Icon(Icons.send),
                          color: Colors.white,
                          onPressed: () {
                            if (_mensaje.text.length > 0) {
                              // _scrrollController.animateTo(_scrrollController.position.maxScrollExtent, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
                              setState(() {
                                isSendingMessage = false;
                              });
                              setMessage(usuarioProvider.currentUser["usuario"],
                                  comunidadProvider.comunidadId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
