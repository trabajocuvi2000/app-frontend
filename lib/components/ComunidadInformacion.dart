import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../providers/comundadProvider.dart';

class ComunidadInformacion extends StatefulWidget {
  const ComunidadInformacion({super.key});

  @override
  State<ComunidadInformacion> createState() => _ComunidadInformacionState();
}

class _ComunidadInformacionState extends State<ComunidadInformacion> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Text(
            "Información Comunidad",
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
            // padding: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
            // margin: EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ...ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: Icon(Icons.house),
                                  title: Text("Comunidad"),
                                  subtitle: Text(
                                      comunidadProvider.comunidadExist
                                          ? comunidadProvider
                                              .currentComunidad["nombre"]
                                          : ""),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: Icon(Icons.qr_code),
                                  title: Text("Código Comunidad"),
                                  subtitle: Text(
                                      comunidadProvider.comunidadExist
                                          ? comunidadProvider
                                              .currentComunidad["codigo"]
                                          : ""),
                                ),
                                ListTile(
                                  leading: Icon(Icons.my_location),
                                  title: Text("Dirección Comunidad"),
                                  subtitle: Text(
                                      comunidadProvider.comunidadExist
                                          ? comunidadProvider
                                              .currentComunidad["direccion"]
                                          : ""),
                                ),
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text("Acerca de la comunidad"),
                                  subtitle: Text(
                                      comunidadProvider.comunidadExist
                                          ? comunidadProvider
                                              .currentComunidad["descripcion"]
                                          : ""),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
