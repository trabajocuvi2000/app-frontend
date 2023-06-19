import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/HeaderWidget.dart';
import 'package:provider/provider.dart';

import '../components/Top_navComunidadUsuario.dart';
import '../comun/Temas.dart';
import '../providers/comundadProvider.dart';

class ComunidadInfo extends StatefulWidget {
  const ComunidadInfo({super.key});

  @override
  State<ComunidadInfo> createState() => _ComunidadInfoState();
}

class _ComunidadInfoState extends State<ComunidadInfo> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    return Scaffold(
      body: SafeArea(
        child: ListView(
          // antes estaba colum
          children: [
            Top_navComunidadUsuario(),
            Container(
              height: 100,
              child: HeaderWidget(100, false, Icons.house_rounded),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        width: 5,
                        color: Colors.white,
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(5, 5),
                        )
                      ],
                    ),
                    child: Icon(
                      Icons.group,
                      size: 90,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    comunidadProvider.comunidadExist
                        ? comunidadProvider.currentComunidad["nombre"]
                        : "",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primariColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.only(left: 8.0, bottom: 4.0),
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Información Comunidad",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
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
                                        // ListTile(
                                        //   leading:
                                        //       Icon(Icons.admin_panel_settings),
                                        //   title: Text("Administrador"),
                                        //   subtitle: Text("Juan Perez"),
                                        // ),
                                        ListTile(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 4),
                                          leading: Icon(Icons.qr_code),
                                          title: Text("Código Comunidad"),
                                          subtitle: Text(comunidadProvider
                                                  .comunidadExist
                                              ? comunidadProvider
                                                  .currentComunidad["codigo"]
                                              : ""),
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.my_location),
                                          title: Text("Dirección Comunidad"),
                                          subtitle: Text(comunidadProvider
                                                  .comunidadExist
                                              ? comunidadProvider
                                                  .currentComunidad["direccion"]
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
                        // // Button editar
                        // Container(
                        //   margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        //   decoration: TemasAyuda().buttonBoxDecoration(context),
                        //   child: ElevatedButton(
                        //     style: TemasAyuda().buttonStyle(),
                        //     onPressed: () {
                        //       // Navigator.pushNamed(context, "/editarUsuarioInfo");
                        //     },
                        //     child: Padding(
                        //       padding: EdgeInsets.all(10),
                        //       child: Text(
                        //         "Editar Info",
                        //         style: TextStyle(
                        //           fontSize: 16,
                        //           // fontWeight: FontWeight.bold,
                        //           color: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
