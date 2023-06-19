import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Top_navEmergencias.dart';

class Emergencias extends StatefulWidget {
  final GlobalKey<ScaffoldState> data;

  const Emergencias({super.key, required this.data});

  @override
  State<Emergencias> createState() => _EmergenciasState();
}

class _EmergenciasState extends State<Emergencias> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Top_navEmergencias(data: widget.data),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.red,
            ),
          ),
          Flexible(
            flex: 8,
            child: ListView(
              children: [
                Container(
                  color: Colors.green,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
