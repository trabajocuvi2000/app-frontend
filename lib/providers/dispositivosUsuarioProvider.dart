import 'package:flutter/cupertino.dart';

class DispositivosUsuarioProvider with ChangeNotifier {
  var _currentDevicesUser = [];
  bool _devicesUserExist = false;

  get currentDevicesUser => _currentDevicesUser;
  get devicesUserExist => _devicesUserExist;

  Future<void> setDevicesUser({required devicesUser}) async {
    _currentDevicesUser = devicesUser;
    _devicesUserExist = true;
    print("Dispositivos usurio guardado .......");
    notifyListeners();
  }

  Future<void> delDevicesUser() async {
    _currentDevicesUser = [];
    _devicesUserExist = false;
    notifyListeners();
  }
}
