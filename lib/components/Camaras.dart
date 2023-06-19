import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Camaras extends StatefulWidget {
  const Camaras({super.key});

  @override
  State<Camaras> createState() => _CamarasState();
}

class _CamarasState extends State<Camaras> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  var camaras_lista = [
    {
      "nombre": "Camara 1",
      "descripcion": "Descripcion 1",
      "video": "video 1",
    },
    {
      "nombre": "Camara 2",
      "descripcion": "Descripcion 2",
      "video": "video 2",
    },
    {
      "nombre": "Camara 3",
      "descripcion": "Descripcion 3",
      "video": "video 3",
    },
    {
      "nombre": "Camara 4",
      "descripcion": "Descripcion 4",
      "video": "video 4",
    },
    {
      "nombre": "Camara 5",
      "descripcion": "Descripcion 5",
      "video": "video 5",
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
      itemCount: camaras_lista.length,
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
                    "${camaras_lista[index]['nombre']}",
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
                    "${camaras_lista[index]['descripcion']}",
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
