import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../comun/Temas.dart';
import '../providers/emergenciaReportadaProvider.dart';

class EmergenciaReportadaInfo extends StatefulWidget {
  const EmergenciaReportadaInfo({super.key});

  @override
  State<EmergenciaReportadaInfo> createState() =>
      _EmergenciaReportadaInfoState();
}

class _EmergenciaReportadaInfoState extends State<EmergenciaReportadaInfo> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);

  @override
  Widget build(BuildContext context) {
    EmergenciaReportadaProvider emergenciaReportadaProvider =
        context.watch<EmergenciaReportadaProvider>();

    // print(emergenciaReportadaProvider.isNewEmergency && emergenciaReportadaProvider.currentEmergency);

    return Container(
      padding: EdgeInsets.all(15),
      margin: const EdgeInsets.fromLTRB(10, 2, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Emergencia",
            style: TextStyle(
              color: Color.fromARGB(255, 43, 42, 42),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Emergencia reportada en su comunidad",
            style:
                TextStyle(color: Color.fromARGB(255, 66, 66, 66), fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.emergency_outlined),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tipo de Emergencia",
                    style: TemasAyuda.textStyleList,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    emergenciaReportadaProvider.isNewEmergency
                        ? emergenciaReportadaProvider
                            .currentEmergency["emergencia"]["nombre"]
                        : "",
                    style: TemasAyuda.textStyleList2,
                  ),
                ],
              ),
              // Text.rich(
              //   TextSpan(
              //     children: [
              //       TextSpan(
              //           text: "Emergencia", style: TemasAyuda.textStyleList),
              //       TextSpan(
              // text: emergenciaReportadaProvider.isNewEmergency
              //     ? emergenciaReportadaProvider
              //         .currentEmergency["emergencia"]["nombre"]
              //     : "",
              // style: TemasAyuda.textStyleList2),
              //     ],
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Usuario que reporta",
                    style: TemasAyuda.textStyleList,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    emergenciaReportadaProvider.isNewEmergency
                        ? emergenciaReportadaProvider
                                .currentEmergency["usuario"]["usuarioVecino"]
                            ["nombre"]
                        : "",
                    style: TemasAyuda.textStyleList2,
                  ),
                ],
              ),
              // Text.rich(
              //   TextSpan(
              //     children: [
              //       TextSpan(
              //           text: "Usuario que reporta: ",
              //           style: TemasAyuda.textStyleList),
              //       TextSpan(
              // text: emergenciaReportadaProvider.isNewEmergency
              //     ? emergenciaReportadaProvider
              //             .currentEmergency["usuario"]
              //         ["usuarioVecino"]["nombre"]
              //     : "",
              // style: TemasAyuda.textStyleList2),
              //     ],
              //   ),
              // ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(Icons.people),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Comunidad",
                    style: TemasAyuda.textStyleList,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    emergenciaReportadaProvider.isNewEmergency
                        ? emergenciaReportadaProvider
                            .currentEmergency["usuario"]["comunidad"]["nombre"]
                        : "",
                    style: TemasAyuda.textStyleList2,
                  ),
                ],
              ),
              // Text.rich(
              //   TextSpan(
              //     children: [
              //       TextSpan(
              //           text: "Comunidad", style: TemasAyuda.textStyleList),
              //       TextSpan(
              // text: emergenciaReportadaProvider.isNewEmergency
              //     ? emergenciaReportadaProvider
              //             .currentEmergency["usuario"]["comunidad"]
              //         ["nombre"]
              //     : "",
              //           style: TemasAyuda.textStyleList2),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
      // child: Center(
      //   child: Text(
      //     emergenciaReportadaProvider.isNewEmergency
      //         ? emergenciaReportadaProvider.currentEmergency["emergencia"]
      //             ["nombre"]
      //         : "SE HA REPORTADO UNA EMERGENCIA",
      //     style: TextStyle(
      //       color: _accentColor,
      //       fontSize: 16,
      //     ),
      //   ),
      // ),
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
    );
  }
}
