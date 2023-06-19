import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Alarmas.dart';
import 'package:practica1/components/ComunidadInformacion.dart';
import 'package:practica1/components/RegistrarVecino.dart';
import 'package:provider/provider.dart';

import '../components/Camaras.dart';
import '../components/ListarUsuariosComunidad.dart';
import '../components/RegistrarUsuariosComunidad.dart';
import '../components/Top_navGestionUsuarios.dart';
import '../comun/Temas.dart';
import '../providers/comundadProvider.dart';

class UsuarioVecino extends StatefulWidget {
  const UsuarioVecino({super.key});

  @override
  State<UsuarioVecino> createState() => _UsuarioVecinoState();
}

class _UsuarioVecinoState extends State<UsuarioVecino> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    ComunidadProvider comunidadProvider = context.watch<ComunidadProvider>();
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            // nav bar
            Top_navGestionUsuarios(),
            !comunidadProvider.comunidadExist
                ? SizedBox.shrink()
                : TabBar(
                    indicatorColor: _primariColor,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.people,
                          color: _primariColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.house,
                          color: _primariColor,
                        ),
                      ),
                    ],
                  ),

            // Contenido
            Flexible(
              flex: 1,
              child: !comunidadProvider.comunidadExist
                  ? RegistrarVecino()
                  : TabBarView(
                      children: [
                        // Listar usuarios comunidad
                        ListarUsuariosComunidad(),
                        // Registrar usuarios comunidad
                        ComunidadInformacion(),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
