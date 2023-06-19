import 'package:flutter/cupertino.dart';

class MessagesProvider with ChangeNotifier {
  var _mensajesComunidad = [];
  bool _mensajesComunidadExist = false;

  get mensajesComunidad => _mensajesComunidad;
  bool get mensajesComunidadExist => _mensajesComunidadExist;

  Future<void> setMensajesComunidad({required mensajesComunidad}) async {
    _mensajesComunidad = mensajesComunidad;
    _mensajesComunidadExist = true;
    notifyListeners();
  }

  Future<void> delMensajesComunidad() async {
    _mensajesComunidad = [];
    _mensajesComunidadExist = false;
    notifyListeners();
  }
}
