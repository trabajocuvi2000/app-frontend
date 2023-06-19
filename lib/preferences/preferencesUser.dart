import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/comundadProvider.dart';
import '../providers/emergenciasProvider.dart';
import '../providers/userProvider.dart';

class PreferencesUser {
  static getUserLoged(
    BuildContext? context,
  ) async {
    var thereIsUsuarLoged;

    final prefs = await SharedPreferences.getInstance();
    thereIsUsuarLoged = prefs.getString('userLoged') ?? 0;
    if (thereIsUsuarLoged == 0) {
      print("--------- Usuario no registado ");
    } else {
      var jsonResponse = jsonDecode(thereIsUsuarLoged);

      // guardamos los datos en el provider
      // provider USUARIO
      context?.read<UsuarioProvider>().loginSuccesfull(user: jsonResponse);
      print("1_______________ USUARIO Guardado ......___________________");
      // provider COMUNIDAD y EMERGENCIAS
      if (jsonResponse["usuario"]["comunidad"] != null) {
        context?.read<ComunidadProvider>()
            .setComunidad(comunidad: jsonResponse["usuario"]["comunidad"]);
        print("2_______________ COMUNIDAD Guardado ......___________________");
        context?.read<EmergenciaProvider>().setEmergencias(
            emergencias: jsonResponse["usuario"]["comunidad"]["emergencias"]);
        print(
            "3_______________ EMERGENCIAS Guardado ......___________________");
      }

      
      // print("_____--------- Datos Usuario LOgeado ");
      // print(jsonResponse);
      // print("______________________________COMUNIDAD ");
      // print(jsonResponse["usuario"]["comunidad"]);
      // print("______________________________EMERGENCIAS  ");
      // print(jsonResponse["usuario"]["comunidad"]["emergencias"]);
    }
  }

  static delUserLoged() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userLoged');
    print("Datos eliminados de SHAREPREFERENCES _______________");
  }
}
