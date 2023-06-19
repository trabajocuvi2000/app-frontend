import 'package:flutter/cupertino.dart';

class ComunidadProvider with ChangeNotifier {
  var _currentComunidad = {};
  int _comunidadId = 0;
  bool _comunidadExist = false;

  get currentComunidad => _currentComunidad;
  get comunidadExist => _comunidadExist;
  int get comunidadId => _comunidadId;

  Future<void> setComunidad({required comunidad}) async {
    _currentComunidad = comunidad;
    _comunidadExist = true;
    _comunidadId = comunidad["comunidad_id"];
    notifyListeners();
  }

  Future<void> delComunidad() async {
   _currentComunidad = {};
   _comunidadId = 0;
   _comunidadExist = false;
    notifyListeners();
  }
}
