import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/ListarUsuariosComunidad.dart';
import 'package:practica1/components/RegistrarUsuariosComunidad.dart';
import 'package:practica1/components/Top_navGestionUsuarios.dart';

class GestionUsuarios extends StatefulWidget {
  const GestionUsuarios({super.key});

  @override
  State<GestionUsuarios> createState() => _GestionUsuariosState();
}

class _GestionUsuariosState extends State<GestionUsuarios> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Top_navGestionUsuarios(),
              // tab bar
              TabBar(
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
                      Icons.person_add,
                      color: _primariColor,
                    ),
                  ),
                ],
              ),

              Flexible(
                flex: 1,
                child: TabBarView(
                  children: [
                    // Listar usuarios comunidad
                    ListarUsuariosComunidad(),
                    // Registrar usuarios comunidad
                    RegistrarUsuariosComunidad(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
