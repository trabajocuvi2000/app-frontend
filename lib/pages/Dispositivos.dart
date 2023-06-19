import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Alarmas.dart';
import 'package:practica1/components/Top_navDispositivos.dart';

import '../components/Camaras.dart';

class Dispositivos extends StatefulWidget {
  const Dispositivos({super.key});

  @override
  State<Dispositivos> createState() => _DispositivosState();
}

class _DispositivosState extends State<Dispositivos> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // nav bar
          Top_navDispositivos(),
          // info
          Flexible(
            flex: 1,
            child: ListView(
              children: [
                // Camaras
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Camaras",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primariColor, //0xFF4C53A2
                    ),
                  ),
                ),
                // lista de camaras
                Camaras(),
                // Alarmas
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Text(
                    "Alarmas",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: _primariColor, //0xFF4C53A2
                    ),
                  ),
                ),
                // lista de camaras
                Alarmas(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
