
import 'package:flutter/cupertino.dart';

class UsuariosComunidadProvider with ChangeNotifier{
  var _currentUsuariosComunidad = [];
  bool _currentUsuariosExist = false;

  get currentUsuriosComunidad => _currentUsuariosComunidad;
  bool get usuriosComunidadExist => _currentUsuariosExist;

  Future<void> setUsuriosComunidad({required usuariosComunidad}) async {
    _currentUsuariosComunidad = usuariosComunidad;
    _currentUsuariosExist = true;
    // print("USUARIOS AGRGADOS CON exito from  UsuariosComunidadProvider");
    notifyListeners();
  }

  Future<void> delUsuriosComunidad() async {
    _currentUsuariosComunidad = [];
    _currentUsuariosExist = false;
    notifyListeners();
  }
}