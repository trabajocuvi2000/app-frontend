import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Spinner.dart';
import 'package:practica1/providers/apicalls.dart';
import 'package:practica1/providers/emergenciasProvider.dart';
import 'package:practica1/providers/userProvider.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import '../providers/apiHeader.dart';
import '../providers/comundadProvider.dart';
import '../providers/emergenciaReportadaProvider.dart';

String api = ApiHeader().api;
final socketUrl = '$api/ws';

class EmergenciasLista extends StatefulWidget {
  const EmergenciasLista({super.key});

  @override
  State<EmergenciasLista> createState() => _EmergenciasListaState();
}

class _EmergenciasListaState extends State<EmergenciasLista> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);

  StompClient? stompClient;

  bool isLoandingEmergency = true;

  bool isEmergencyReoorted = false;

  int emergenciaReportadaId = 0;

  int comunidadID = 0;

  void onConnect(StompFrame frame, BuildContext context) {
    // print("socket Emergencia Reportar conectado.......");
    stompClient?.subscribe(
      destination: '/user/comunidad$comunidadID/private', // all/message
      callback: (StompFrame frame) {
        if (frame.body != null) {
          setState(() {
            // print("Soket Emergeny Reported is Working ....");
            // print(jsonDecode(frame.body.toString()));
            context.read<EmergenciaReportadaProvider>().setComunidadReporta(
                comunidadReporta: jsonDecode(frame.body.toString()));
            // this should be in this way
            // print(jsonDecode(frame.body.toString())["emergenciaReportada"]);
            context.read<EmergenciaReportadaProvider>().setEmergenciaReportada(
                newEmergency:
                    jsonDecode(frame.body.toString())["emergenciaReportada"]);
            // print("___________________________________");
            // print(frame.body);
          });
        }
      },
    );
  }

  void sendEmergency(var emergenciaReportadaObj, int emergenciaId,
      int emergenciaReportadaId, int comunidadReportaId, int usuarioID) {
    var emergenciaReportada = {
      "emergenciaReportadaId": emergenciaReportadaId,
      "emergenciaId": emergenciaId,
      "comunidadId": comunidadReportaId,
      "usuarioSenderId": usuarioID,
      "emergenciaReportada":
          emergenciaReportadaObj, // there was an error when I didi t in this was -> jsonEncode(emergenciaReportadaObj)
    };
    stompClient?.send(
        destination: '/app/private-message',
        body: jsonEncode(emergenciaReportada)); //  app/aplication
  }

  void connect(conext) {
    stompClient = StompClient(
      config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: (p0) => onConnect(p0, context),
        onWebSocketError: (dynamic error) => print(error.toString()),
      ),
    );
    stompClient!.activate();
  }

  void onPress(var emergencia, var comunidad, var usuario) async {
    setState(() {
      isLoandingEmergency = false;
    });
    // // actualiza el esatdo del dispositivo si hay
    print("Activando DISPOSITIVO .................");
    await ApiCalls()
        .updateStatusDeviceCommunity(comunidad["comunidad_id"], emergencia)
        .then((value) => {
              if (value)
                {print("----------------- se acutalizo correctamente")}
              else
                {print("no se pudo actualziar")}
            });

    // guardamos la emergencia reportada en la base de datos
    // y aviamos al socket
    await ApiCalls()
        .setReportarEmergencia(context, emergencia['emergencia_id'],
            usuario["usuario"]["usuario_id"])
        .then((emergenciaReportada) async => {
              // "emergenciaReportada" tiene el id de la emergencia reportada
              // jsonResponseemergenciaReportada
              if (emergenciaReportada != -1)
                {
                  // print("Esta es la emergencia reportada ..--------------"),
                  // print(jsonDecode(emergenciaReportada.toString())[
                  //     "emergenciaReportada_id"]),
                  await ApiCalls()
                      .getEmergenciaReportadabyId(
                          jsonDecode(emergenciaReportada.toString())[
                              "emergenciaReportada_id"])
                      .then((emergenciaReport) => {
                            if (emergenciaReport != -1)
                              {
                                print("________________)))))))))))))))))))"),
                                // variables para notificar emergencias
                                setState(() {
                                  isEmergencyReoorted = true;
                                  emergenciaReportadaId = jsonDecode(
                                          emergenciaReportada.toString())[
                                      "emergenciaReportada_id"];
                                }),

                                // llamo al socket
                                sendEmergency(
                                  jsonDecode(emergenciaReport.toString()),
                                  emergencia['emergencia_id'],
                                  jsonDecode(emergenciaReportada.toString())[
                                      "emergenciaReportada_id"],
                                  comunidad["comunidad_id"],
                                  usuario["usuario"]["usuario_id"],
                                ),
                              }
                          })
                }
              else
                {print("no se ingreseo la emregencia reportada ........")}
            });

    // notifico con FIREBASE

    if (isEmergencyReoorted && emergenciaReportadaId != 0) {
      await ApiCalls()
          .notificationEmergncyFirebase(
            emergencia['emergencia_id'],
            emergenciaReportadaId,
            comunidad["comunidad_id"],
            usuario["usuario"]["usuario_id"],
          )
          .then(
            (value) => {
              if (value != false)
                {
                  print("Emergencia Notificadad con FIREBASE"),
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

    // obtenermos la emergencia reportada de la base de datos

    // // esto se utiliza para obtener la ultima emergencia reportada y actualizar le provider
    // // aun que no seria nesesario ya que al ingresar la emeregcnia reportada devuleve dicha emergencia
    // // y por lo tanto se actulizaria el provider
    // ApiCalls().getEmergenciaReportada(context);
    // showAlertDialog(context);
    // setState(() {
    //   isLoandingEmergency = true;
    // });
  }

  @override
  void initState() {
    super.initState();
    connect(context);
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient!.deactivate();
    }

    super.dispose();
  }

  Timer? timer;
  @override
  Widget build(BuildContext context) {
    EmergenciaProvider emergenciasProvider =
        context.watch<EmergenciaProvider>();

    UsuarioProvider usuarioProvider = context.watch<UsuarioProvider>();

    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();

    EmergenciaReportadaProvider emergenciaReportadaProvider =
        context.watch<EmergenciaReportadaProvider>();

    var emergencias_lista = emergenciasProvider.emergenciasExist
        ? emergenciasProvider.currentEmergencias
        : [];

    setState(() {
      comunidadID  = comunidadProvider.comunidadId;
    });

    // print(emergencias_lista);
    return !isLoandingEmergency
        ? Spinner()
        : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              // childAspectRatio: 0.60,
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: emergencias_lista.length,
            itemBuilder: (BuildContext ctx, index) {
              return GestureDetector(
                onTapDown: (_) {
                  timer = Timer(
                      Duration(
                          milliseconds: emergencias_lista[index]
                                      ['tiempoActivacion']
                                  .toInt() * // this worked in CHROME but did not work in phone, because it has to be an INT and not a DOUBLE
                              1000),
                      () => onPress(
                          emergencias_lista[index],
                          comunidadProvider.currentComunidad,
                          usuarioProvider.currentUser));
                  // timer = Timer.periodic(Duration(seconds: emergencias_lista[index]['tiempoActivacion']*1000), (Timer t) => onPress(index));
                },
                onTapUp: (_) {
                  timer?.cancel();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10), // this was before
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(20),
                    shape: BoxShape.circle,
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Image.network(
                          "https://cdn-icons-png.flaticon.com/512/1084/1084987.png",
                          // "${emergencias_lista[index]['imagen']}",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      Container(
                        height: 30,
                        padding: EdgeInsets.only(bottom: 8),
                        // alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          child: Text(
                            "${emergencias_lista[index]['nombre']}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _accentColor, //0xFF4C53A2
                            ),
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.centerLeft,
                        // before it was 50 in "height", but when runs in small devices show some errors,
                        // and it is because teh screen is small
                        height: 30,
                        child: SingleChildScrollView(
                          child: Text(
                            "${emergencias_lista[index]['descripcion']}",
                            style: TextStyle(
                              fontSize: 15,
                              color: _accentColor, //0xFF4C53A2
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

void showAlertDialog(BuildContext context) {
  // Create button
  // Widget okButton = FlatButton(
  //   child: Text("OK"),
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  // );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Se ha notificado su emergencia"),
    content: Text("Porfavor espere, pronto recibirá asistencia"),
    // actions: [
    //   okButton,
    // ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
