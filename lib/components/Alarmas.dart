import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alarmas extends StatefulWidget {
  const Alarmas({super.key});

  @override
  State<Alarmas> createState() => _AlarmasState();
}

class _AlarmasState extends State<Alarmas> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  var alarmas_lista = [
    {
      "nombre": "Alarma 1",
      "descripcion": "Descripcion 1",
      "alarma": "alarma 1",
    },
    {
      "nombre": "Alarma 2",
      "descripcion": "Descripcion 2",
      "alarma": "alarma 2",
    },
    {
      "nombre": "Alarma 3",
      "descripcion": "Descripcion 3",
      "alarma": "alarma 3",
    },
    {
      "nombre": "Alarma 4",
      "descripcion": "Descripcion 4",
      "alarma": "alarma 4",
    },
    {
      "nombre": "Alarma 5",
      "descripcion": "Descripcion 5",
      "alarma": "alarma 5",
    },
  ];
  @override
  Widget build(BuildContext context) {
     return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // childAspectRatio: 0.60,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: alarmas_lista.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
          margin: const EdgeInsets.fromLTRB(10, 16, 10, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            // shape: BoxShape.circle,
            border: Border.all(
              color: _accentColor, //                   <--- border color
              width: 1.0,
            ),
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
                height: 30,
                padding: EdgeInsets.only(bottom: 8),
                // alignment: Alignment.centerLeft,
                child: SingleChildScrollView(
                  child: Text(
                    "${alarmas_lista[index]['nombre']}",
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
                height: 50,
                child: SingleChildScrollView(
                  child: Text(
                    "${alarmas_lista[index]['descripcion']}",
                    style: TextStyle(
                      fontSize: 15,
                      color: _accentColor, //0xFF4C53A2
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}