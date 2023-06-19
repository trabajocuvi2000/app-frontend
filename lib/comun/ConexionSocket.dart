import 'dart:convert';
import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../providers/emergenciaReportadaProvider.dart';
final socketUrl = 'http://localhost:8080/ws';

class ConexionSocket {

   StompClient? stompClient;

    void onConnect(StompFrame frame, BuildContext context) {
    print("socket conectado.......");
    stompClient?.subscribe(
      destination: '/chatroom/emergencia', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          
            print(jsonDecode(frame.body.toString()));
            context
                .read<EmergenciaReportadaProvider>()
                .setComunidadReporta(comunidadReporta: jsonDecode(frame.body.toString()));
            print(frame.body);
          
        }
      },
    );
  }

  void sendEmergency(int emergenciaReportadaId, int comunidadReportaId, int usuarioID) {
    var emergenciaReportada = {
      "emergenciaId": emergenciaReportadaId,
      "comunidadId": comunidadReportaId,
      "usuarioSenderId": usuarioID
    };
    // print(emergenciaReportada);
    stompClient?.send(
        destination: '/app/emergencia',
        body: jsonEncode(emergenciaReportada)); //  app/aplication
  }

  void connect(conext) {
    print("_____________");
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: (p0) => onConnect(p0, context as BuildContext),
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient!.activate();
  }

}