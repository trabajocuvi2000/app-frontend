import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../comun/Temas.dart';
import '../comun/TemasEmergencias.dart';
import '../providers/comundadProvider.dart';
import '../providers/emergenciaReportadaProvider.dart';
import '../providers/userProvider.dart';

class EstadoEmergencia extends StatefulWidget {
  const EstadoEmergencia({super.key});

  @override
  State<EstadoEmergencia> createState() => _EstadoEmergenciaState();
}

class _EstadoEmergenciaState extends State<EstadoEmergencia> {
  @override
  Widget build(BuildContext context) {
    UsuarioProvider userProvider = context.watch<UsuarioProvider>();
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();

    EmergenciaReportadaProvider emergenciaReportadaProvider =
        context.watch<EmergenciaReportadaProvider>();
    // color backgraund
    Color colorBackGraund = Color(int.parse(TemasEmergencias()
        .backGraundEmergencia(emergenciaReportadaProvider.isNewEmergency
            ? emergenciaReportadaProvider.nivelEmergencia
            : 0)));

    // print(emergenciaReportadaProvider.comunidadReporta["comunidadId"]);
    // print(comunidadProvider.comunidadId);
    // print("Pintura -----------");
    // print(emergenciaReportadaProvider.isNewEmergency
    //         ? emergenciaReportadaProvider.nivelEmergencia
    //         : 0);
    return (emergenciaReportadaProvider.isNewEmergency &&
            emergenciaReportadaProvider.comunidadReporta["comunidadId"] ==
                comunidadProvider.comunidadId)
        ? Container(
            padding: EdgeInsets.all(15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorBackGraund,
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   // width: 5,
              //   color: Colors.white,
              // ),
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
                Icon(
                  Icons.emergency,
                  color: Colors.white,
                  size: 30
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Emergencia",
                        style: TextStyle(
                          // color: Color(0xFF4C53A2),
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Se ha reportado una emergencia",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(15),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 44, 223, 136),
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   // width: 5,
              //   color: Colors.white,
              // ),
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
                Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 30
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Emergencia",
                        style: TextStyle(
                          // color: Color(0xFF4C53A2),
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "No hay emergencias",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
