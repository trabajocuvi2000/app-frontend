// maneja nuestro esdo del usaurio

import 'package:flutter/cupertino.dart';

class UsuarioProvider with ChangeNotifier {
  // variables
  // Map<String, dynamic> user = jsonDecode(jsonString);
  // para definir un objeto
  // Map<String, dynamic> _currentUser = {};
  var _currentUser = {};

  // String _currentUser = ""; // est es el usuario y debe ser un objeto
  bool _isFetching = false;
  bool _isLogin = false;
  bool _error = false;
  String _tokenUser = '';
  bool _isAmin = false;

  // Map<String, dynamic> get currentUser => _currentUser;
  get currentUser => _currentUser;
  bool get isFetching => _isFetching;
  bool get isLogin => _isLogin;
  bool get error => _error;
  String get tokenUser => _tokenUser;
  bool get isAdmin => _isAmin;

  //loging exitoso
  Future<void> loginSuccesfull({required user}) async {
    _currentUser = user;
    _isFetching = false;
    _isLogin = true;
    _error = false;
    _tokenUser = user["token"]; //esto seria algo asi -> user.token
    _isAmin = user["usuario"]["isAdmin"];
    // actualizar las variables y estan disponibles en los GETs
    notifyListeners();
  }

   Future<void> updateDataUser({required user}) async {
    _currentUser["usuario"] = user;
    print("--------------------- Provider data user actualizado correctamente");
    // actualizar las variables y estan disponibles en los GETs
    notifyListeners();
  }

  // empesando a logearse
  Future<void> loginStart() async {
    _isLogin = false;
    _currentUser = {};
    _isFetching = false;
    _error = false;
    _tokenUser = ""; //user.token
    notifyListeners();
  }

  // Inicio de seccion fallida
  Future<void> loginFail() async {
    print("login fail");
    _isLogin = false;
    _currentUser = {};
    _isFetching = false;
    _error = true;
    _tokenUser = ""; //user.token
    notifyListeners();
  }

  Future<void> cerrarSeccion() async {
    print("login fail");
    _isLogin = false;
    _currentUser = {};
    _isFetching = false;
    _error = false;
    _tokenUser = ""; //user.token
    notifyListeners();
  }

  // Future<void> updateUser({required user}) async {
  //   _currentUser = user;
  //   notifyListeners();
  // }
}
