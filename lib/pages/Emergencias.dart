import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/EmergenciasLista.dart';
import 'package:practica1/components/EstadoEmergencia.dart';
import 'package:practica1/components/Spinner.dart';
import 'package:practica1/components/Top_navEmergencias.dart';
import 'package:practica1/comun/Temas.dart';
import 'package:practica1/providers/emergenciaReportadaProvider.dart';
import 'package:practica1/providers/apicalls.dart';
import 'package:practica1/providers/comundadProvider.dart';
import 'package:practica1/providers/usuariosComunidadProvider.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../components/EmergenciaReportadaInfo.dart';
import '../providers/apiHeader.dart';
import '../providers/userProvider.dart';

String api = ApiHeader().api;

final socketUrl = '$api/ws';

class Emergencias extends StatefulWidget {
  final GlobalKey<ScaffoldState> data;
  const Emergencias({super.key, required this.data});

  @override
  State<Emergencias> createState() => _EmergenciasState();
}

class _EmergenciasState extends State<Emergencias> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);

  StompClient? stompClient;

  bool isLogin = true;
int comunidadID = 0;

  void onConnectCancelEmergency(StompFrame frame, BuildContext context) {
    // print("socket conectado cancel emergency 222222.......");
    stompClient?.subscribe(
      destination: '/user/comunidad$comunidadID/private-cancel',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          setState(() {
            // print("Cancelando eergencia ......");
            // print(jsonDecode(frame.body.toString()));
            context.read<EmergenciaReportadaProvider>().setCerrarEmergencia();
          });
        }
      },
    );
  }

  void cancelEmergencySocket(int comunidadReportaId) {
    print(comunidadReportaId);
    var emergenciaReportada = {
      "emergenciaReportadaId": 0,
      "emergenciaId": 0,
      "comunidadId": comunidadReportaId,
      "usuarioSenderId": 0
    };
    // print(emergenciaReportada);
    stompClient?.send(
        destination: '/app/private-message-cancel',
        body: jsonEncode(emergenciaReportada)); //  app/aplication
  }

  void connectCancelEmergency(conext) {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: (p0) => onConnectCancelEmergency(p0, context),
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient!.activate();
  }

  @override
  void initState() {
    super.initState();
    connectCancelEmergency(context);
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient!.deactivate();
    }

    super.dispose();
  }

  void desactiveDevice(int emergenciaId, var comunidad) async {
    // print(emergenciaId);
    await ApiCalls()
        .updateStatusDevice(emergenciaId, comunidad)
        .then((value) => {
              if (value)
                {print("Dispositivo desactivado correctamente")}
              else
                {print("NOOOOOO se pudo actualizar el esatdo del dispositivo")}
            });
  }

  Future<bool> desactiveDeviceCommunity(int comunidadId, var emergencia) async {
    // print(comunidadId);
    // print(emergencia);
    // print("Cancelando DISPOSITIVO .............");
    await ApiCalls()
        .updateStatusDeviceCommunity(comunidadId, emergencia)
        .then((value) => {
              if (value)
                {
                  // aviso al socket que ya no hay emergencias, por ende tambien deberia cambiar el estado del provider
                  // indeicado que ya no hay emergencias
                  cancelEmergencySocket(comunidadId),
                  // print(
                  //     "CANCELADO ----------------- se acutalizo correctamente"),
                }
              else
                {print("no se pudo actualziar")}
            });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // setState(() {
    //   ApiCalls().getUsuarisoComunidad(context);
    // });
    UsuarioProvider userProvider = context.watch<UsuarioProvider>();
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    EmergenciaReportadaProvider emergenciaReportadaProvider =
        context.watch<EmergenciaReportadaProvider>();
        setState(() {
      comunidadID  = comunidadProvider.comunidadId;
    });


    // print(emergenciaReportadaProvider.comunidadReporta["usuarioSenderId"]);
    // print(userProvider.currentUser["usuario_id"]);
    return SafeArea(
      child: Column(
        children: [
          // NabBar
          Top_navEmergencias(data: widget.data),

          // Estado de Emergencias
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Text(
              "Estado de emergencia",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _primariColor, //0xFF4C53A2
              ),
            ),
          ),

          EstadoEmergencia(),
          // Emergencias
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.all(10),
            child: Text(
              "Cuál es su emergencia",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: _primariColor, //0xFF4C53A2
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                // color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: ListView(
                children: [
                  // cerrar emergencia
                  (emergenciaReportadaProvider.isNewEmergency &&
                          emergenciaReportadaProvider
                                  .comunidadReporta["usuarioSenderId"] ==
                              userProvider.currentUser["usuario"]["usuario_id"])
                      ? GestureDetector(
                          onTap: () {
                            // desactiveDevice(
                            //     emergenciaReportadaProvider.comunidadReporta["emergencia"],
                            //     comunidadProvider.currentComunidad);
                            setState(() {
                              isLogin = false;
                            });
                            desactiveDeviceCommunity(
                                    comunidadProvider.comunidadId,
                                    emergenciaReportadaProvider
                                        .currentEmergency["emergencia"])
                                .then((value) => {
                                      // Timer(Duration(seconds: 3), () {
                                      //   print(
                                      //       "Yeah, this line is printed after 3 seconds");
                                      //   setState(() {
                                      //     isLogin = true;
                                      //   });
                                      // }),
                                      setState(() {
                                        isLogin = true;
                                      }),
                                    });
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            margin: const EdgeInsets.fromLTRB(10, 2, 10, 16),
                            child: Center(
                              child: Text(
                                "Clic aquí, se desea cancelar su emergencia.",
                                style: TextStyle(
                                  color: _accentColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 5,
                                color: Colors.white,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: const Offset(5, 5),
                                )
                              ],
                            ),
                          ),
                        )
                      : !isLogin
                          ? Spinner()
                          : emergenciaReportadaProvider.isNewEmergency &&
                                  emergenciaReportadaProvider
                                          .comunidadReporta["comunidadId"] ==
                                      comunidadProvider.comunidadId &&
                                  emergenciaReportadaProvider.comunidadReporta[
                                          "usuarioSenderId"] !=
                                      userProvider.currentUser["usuario"]
                                          ["usuario_id"]
                              ? EmergenciaReportadaInfo()
                              : EmergenciasLista()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
