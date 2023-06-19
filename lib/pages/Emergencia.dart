import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Top_navEmergencia.dart';

class Emergencia extends StatefulWidget {
  const Emergencia({super.key});

  @override
  State<Emergencia> createState() => _EmergenciaState();
}

class _EmergenciaState extends State<Emergencia> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);

  Color _colorEmergencia = Color.fromARGB(255, 243, 132, 132);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // nav bar
            Top_navEmergencia(),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.all(10),
              child: Text(
                "Se ha reportado una emergecia",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: _primariColor, //0xFF4C53A2
                ),
              ),
            ),
            // info
            Flexible(
              flex: 1,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                    color: _colorEmergencia,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 10,
                  ),
                  margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.man_outlined,
                        size: 90,
                        color: Colors.white,
                      ),
                      Container(
                        alignment: Alignment.center,
                        // height: 50,
                        child: SingleChildScrollView(
                          child: Text(
                            "Comunal",
                            style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "Tipo de Emergencia: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Grave.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Direccion: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Sector Parque Industrial.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Persona que Reporta: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "Juan Perez.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "Lugar: ",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.gps_fixed,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
