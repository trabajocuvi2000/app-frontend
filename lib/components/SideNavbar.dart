import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/services/push_notifications_service.dart';
import 'package:provider/provider.dart';

import '../preferences/preferencesUser.dart';
import '../providers/comundadProvider.dart';
import '../providers/dispositivosUsuarioProvider.dart';
import '../providers/emergenciaReportadaProvider.dart';
import '../providers/emergenciasProvider.dart';
import '../providers/userProvider.dart';
import '../providers/usuariosComunidadProvider.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);

  double _drawericonSize = 24;
  @override
  Widget build(BuildContext context) {
    UsuarioProvider userProvider = context.watch<UsuarioProvider>();
    EmergenciaReportadaProvider emergenciaReportadaProvider =
        context.watch<EmergenciaReportadaProvider>();
    UsuariosComunidadProvider usuariosComunidadProvider =
        context.watch<UsuariosComunidadProvider>();
    EmergenciaProvider emergenciasProvider =
        context.watch<EmergenciaProvider>();
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    DispositivosUsuarioProvider devicesUserProvider =
        context.watch<DispositivosUsuarioProvider>();


    Color _primariColor = Color(0xFF4C53A2);
    Color _accentColor = Color(0xFF0071bc);
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.3,
      child: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     stops: [0.0, 1.0],
        //     colors: [
        //       _primariColor.withOpacity(0.2),
        //       _accentColor.withOpacity(0.4)
        //     ],
        //   ),
        // ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: _primariColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [_primariColor, _accentColor],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "Seguridad App",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      Icons.person,
                      size: 50,
                      color: Colors.grey.shade300,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: userProvider.isLogin
                              ? userProvider.currentUser["usuario"]
                                      ["usuarioVecino"]["nombre"] +
                                  " "
                              : "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: userProvider.isLogin
                              ? userProvider.currentUser["usuario"]
                                  ["usuarioVecino"]["apellido"]
                              : "",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                size: _drawericonSize,
                color: _accentColor,
              ),
              title: Text(
                "Mi Perfil",
                style: TextStyle(
                  fontSize: 17,
                  color: _accentColor,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/perfilUsuario');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                size: _drawericonSize,
                color: _accentColor,
              ),
              title: Text(
                "Mi Comunidad",
                style: TextStyle(
                  fontSize: 17,
                  color: _accentColor,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/comunidadInfo');
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                size: _drawericonSize,
                color: _accentColor,
              ),
              title: Text(
                "Cerrar Sesion",
                style: TextStyle(
                  fontSize: 17,
                  color: _accentColor,
                ),
              ),
              onTap: () {
                // // FIREBASE
                // // unsubscribe de la comundiad 
                // PushNotificacionService.unSubscribeCommunity(comunidadProvider.comunidadId);


                // eliminamos los datos de los providers
                emergenciaReportadaProvider.setCerrarEmergencia();
                usuariosComunidadProvider.delUsuriosComunidad();
                emergenciasProvider.delEmergencias();
                comunidadProvider.delComunidad();
                devicesUserProvider.delDevicesUser();
                userProvider.cerrarSeccion(); // ESTABA PRIMERO -- LO PUSE AQUI Y FUNCIONO
                // eliminamos los datos del usuario almacenados en el dispositivo 
                PreferencesUser.delUserLoged();
                // Navigator.pushNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
