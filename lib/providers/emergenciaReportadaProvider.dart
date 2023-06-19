import 'package:flutter/cupertino.dart';

class EmergenciaReportadaProvider with ChangeNotifier {
  var _currentEmergency = {};
  var _comunidadReporta = {};
  bool _isNewEmergency = false;
  int _nivelEmergencia = 0;
  int _currentEmergencyId = 0;

  get currentEmergency => _currentEmergency;
  get comunidadReporta => _comunidadReporta;
  bool get isNewEmergency => _isNewEmergency;
  int get nivelEmergencia => _nivelEmergencia;
  int get emergenciReportadaId => _currentEmergencyId;

  Future<void> setEmergenciaReportada({required newEmergency}) async {
    _currentEmergency = newEmergency;
    _isNewEmergency = true;

    _nivelEmergencia = newEmergency["emergencia"]["nivel_emergencia"];
    // print("_________Emegencia Reportada______");
    // print(newEmergency);
    // _nivelEmergencia =
    //     newEmergency["emergencia"]["nivelEmergencia"]["nivelEmergencia"];
    _currentEmergencyId = newEmergency["emergencia"]["emergencia_id"];
    notifyListeners(); // it has to be this becuase in that way we can see the changes in the app in real time
  }

  Future<void> setComunidadReporta({required comunidadReporta}) async {
    _isNewEmergency = true;
    _comunidadReporta = comunidadReporta;
    notifyListeners(); // it has to be this becuase in that way we can see the changes in the app in real time
  }

  Future<void> setCerrarEmergencia() async {
    _currentEmergency = {};
     _comunidadReporta = {};
    _isNewEmergency = false;
    _nivelEmergencia = 0;
    _currentEmergencyId = 0;
    notifyListeners(); // it has to be this becuase in that way we can see the changes in the app in real time
  }
}
