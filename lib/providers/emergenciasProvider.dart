import 'package:flutter/cupertino.dart';

class EmergenciaProvider with ChangeNotifier {
  var _currentEmergencias = [];
  bool _emergenciasExist = false;

  get currentEmergencias => _currentEmergencias;
  get emergenciasExist => _emergenciasExist;

  Future<void> setEmergencias({required emergencias}) async {
    _currentEmergencias = emergencias;
    _emergenciasExist = true;
    notifyListeners();
  }

  Future<void> delEmergencias() async {
    _currentEmergencias = [];
    _emergenciasExist = false;
    notifyListeners();
  }
}
