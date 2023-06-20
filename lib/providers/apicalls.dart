import 'dart:convert';
// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:practica1/providers/emergenciaReportadaProvider.dart';
import 'package:practica1/providers/apiHeader.dart';
import 'package:practica1/providers/comundadProvider.dart';
import 'package:practica1/providers/emergenciasProvider.dart';
import 'package:practica1/providers/userProvider.dart';
import 'package:practica1/providers/usuariosComunidadProvider.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/sock_js/sock_js_utils.dart';

import '../services/push_notifications_service.dart';
import 'dispositivosUsuarioProvider.dart';
import 'messagesProvider.dart';

class ApiCalls {
  String api = ApiHeader().api;

  Future<void> getUsuariosComunidad(
      BuildContext context, int comunidad_Id) async {
    try {
      final response =
          await get(Uri.parse('$api/usuarios/comunidadusers/$comunidad_Id'));

      final statusCode = response.statusCode;
      final headers = response.headers;
      final contentType = headers['content-type'];
      final json = response.body;
      var jsonResponse = jsonDecode(response.body);
      // print("Comunidad $comunidad_Id");
      // print(jsonResponse);
      context
          .read<UsuariosComunidadProvider>()
          .setUsuriosComunidad(usuariosComunidad: jsonResponse);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> delUsuarioComunidad(BuildContext context, int usuario_Id) async {
    print("Usuario a elminar $usuario_Id");
  }

  Future<Object> login(
      BuildContext context, String _correo, String _contrasena) async {
    context.read<UsuarioProvider>().loginStart();
    try {
      final url = Uri.parse('$api/user/login');
      final headers = {"Content-type": "application/json"};
      final json = '{ "correo_1": "$_correo", "contrasena": "$_contrasena" }';
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);

      print(response.statusCode);

      if (jsonResponse['isLogin']) {
        context.read<UsuarioProvider>().loginSuccesfull(user: jsonResponse);
        // guardamos la comunidad a la cual pertenese el usuario asi como las emergencias que tiene esa comunidad, pero solo en caso de que el usuario este ligado a una comunidad
        if (jsonResponse["usuario"]["comunidad"] != null) {
          context
              .read<ComunidadProvider>()
              .setComunidad(comunidad: jsonResponse["usuario"]["comunidad"]);
          context.read<EmergenciaProvider>().setEmergencias(
              emergencias: jsonResponse["usuario"]["comunidad"]["emergencias"]);
          // jsonDecode(value.toString())["comunidad"]["comunidad_id"])

          // // CUANDO el usuario se logea se subcribe a la comunidad
          // await PushNotificacionService.subscribeCommunity(
          //     jsonResponse["usuario"]["comunidad"]["comunidad_id"]);
        }
        return jsonResponse;
      } else {
        context.read<UsuarioProvider>().loginFail();
        return false;
      }

      // final statusCode = response.statusCode;
      // final body = response.body;
    } catch (e) {
      context.read<UsuarioProvider>().loginFail();
      return false;
    }
  }

  Future<bool> updateStatusDevice(int emergenciaID, var comunidad) async {
    // print("-------");
    // print(emergenciaID);

    try {
      final url =
          Uri.parse('$api/dispositivos/actualizarDispositivo/$emergenciaID');
      final headers = {"Content-type": "application/json"};
      // envio la comunidad
      final json = jsonEncode(comunidad);
      final response = await post(url, headers: headers, body: json);
      // print(response);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateStatusDeviceCommunity(
      int comunidadId, var emergencia) async {
    // print(comunidadId);
    // print(emergencia);
    // print("_____________________________________");
    try {
      final url = Uri.parse(
          '$api/dispositivocomunidad/actualizarEstadoDispositivoComunidad/$comunidadId');
      final headers = {"Content-type": "application/json"};
      // envio la comunidad
      final json = jsonEncode(emergencia);
      final response = await post(url, headers: headers, body: json);
      // print(response);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Object> setReportarEmergencia(
      BuildContext context, int emegecia_Id, int usuario_Id) async {
    try {
      final url = Uri.parse('$api/emergencias/reportadas');
      final headers = {"Content-type": "application/json"};
      final json =
          '{ "codigo": "34567", "estadoEmergencia": true, "emergencia": { "emergencia_id": $emegecia_Id },"usuario": { "usuario_id": $usuario_Id}}';
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);

      // print(jsonResponse["emergenciaReportada_id"]);
      // return jsonResponse["emergenciaReportada_id"];
      return response.body;
    } catch (e) {
      context.read<UsuarioProvider>().loginFail();
      return -1;
    }
  }

  Future<Object> getEmergenciaReportadabyId(int emergenciaReportada_Id) async {
    try {
      final response = await get(
          Uri.parse('$api/emergencias/reportadas/$emergenciaReportada_Id'));
      // sample info available in response
      final statusCode = response.statusCode;
      final headers = response.headers;
      final contentType = headers['content-type'];
      final json = response.body;
      var jsonResponse = jsonDecode(response.body);
      return response.body;
    } catch (e) {
      return -1;
    }
  }

  // no se utiliza este metodo
  Future<void> getEmergenciaReportada(BuildContext context) async {
    try {
      final response =
          await get(Uri.parse('$api/emergencias/reportadas/ultimoelemento'));
      // sample info available in response
      final statusCode = response.statusCode;
      final headers = response.headers;
      final contentType = headers['content-type'];
      final json = response.body;
      var jsonResponse = jsonDecode(response.body);
      context
          .read<EmergenciaReportadaProvider>()
          .setEmergenciaReportada(newEmergency: jsonResponse);
    } catch (e) {
      context.read<UsuarioProvider>().loginFail();
    }
  }

  Future<Object> putUsuarioComunidad(
      BuildContext context, var usuario, int comunidadID) async {
    try {
      usuario["comunidad"] = null;
      var usuuarioID = usuario["usuario_id"];
      // print(usuuarioID);

      final url = Uri.parse('$api/usuarios/$usuuarioID');
      final headers = {"Content-type": "application/json"};
      final json = jsonEncode(usuario);
      final response = await put(url, headers: headers, body: json);
      final statusCode = response.statusCode;
      final body = response.body;
      getUsuariosComunidad(context, comunidadID);
      return body;
      // print(body);
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<Object> putUsuario(BuildContext context, var usuario) async {
    try {
      var usuuarioID = usuario["usuario_id"];

      final url = Uri.parse('$api/usuarios/$usuuarioID');
      final headers = {"Content-type": "application/json"};
      final json = jsonEncode(usuario);
      final response = await put(url, headers: headers, body: json);
      final statusCode = response.statusCode;
      final body = jsonDecode(response.body);
      ;
      // actualizamos el provider con los nuevos datos del usuario
      context.read<UsuarioProvider>().updateDataUser(user: body);
      return body;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  Future<Object> postActualizarContraseaUsuario(
      BuildContext context, var usuario, String contrasenaNueva) async {
    try {
      final url = Uri.parse('$api/user/actualizarContrasena/$contrasenaNueva');
      final headers = {"Content-type": "application/json"};

      final json = jsonEncode(usuario);
      final response = await post(url, headers: headers, body: json);

      // actualizamos el provider con los nuevos datos del usuario
      if (response.body.length != 0) { // solo si no regresa null
        final body = jsonDecode(response.body);
        context.read<UsuarioProvider>().updateDataUser(user: body);
      }
      // print(response.statusCode);
      // print(response.body.length);
      // print("-------");
      // response.body.length -> cero cuando regresa un null
      return response.body.length;
    } catch (e) {
      print(e.toString());
      return -1;
    }
  }

  // registrar un nuevo usuario
  Future<bool> postNewUser(String nombre, String apellido, String email,
      String telefono, String contrasena, String direccion) async {
    try {
      final url = Uri.parse('$api/usuarios');
      final headers = {"Content-type": "application/json"};
      final json =
          '{ "correo_1": "$email",  "correo_2": "$email", "contrasena": "$contrasena", "isAdmin": false, "usuarioVecino": { "nombre": "$nombre","apellido": "$apellido", "telefono_1": $telefono,  "direccion": "$direccion"}}';

      final response = await post(url, headers: headers, body: json);

      final statusCode = response.statusCode;
      final body = response.body;
      // print(body);
      print("Usuario registrado corectamente");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Object> addComunidadUsuario(
      BuildContext context, var usuario, String codigoComunidad) async {
    try {
      final url = Uri.parse(
          '$api/usuarios/actualizarusuariocomunidad/$codigoComunidad');
      final headers = {"Content-type": "application/json"};
      final json = jsonEncode(usuario);
      final response = await post(url, headers: headers, body: json);
      // print(response.statusCode);
      var jsonResponse = jsonDecode(response.body);

      // solo se actualzia el usuario los otros datos del user porvider serian los
      // mismo ya que el usuario ya estaba logeado
      // context.read<UsuarioProvider>().updateUser(user: jsonResponse); // this was the error
      if (jsonResponse["comunidad"] != null) {
        // print("^^^^^^^^^^^^^^^^^^^^^^");
        context
            .read<ComunidadProvider>()
            .setComunidad(comunidad: jsonResponse["comunidad"]);
        context.read<EmergenciaProvider>().setEmergencias(
            emergencias: jsonResponse["comunidad"]["emergencias"]);
      } else {
        return false;
      }
      return response.body;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getDevicesByUser(BuildContext context, int userId) async {
    try {
      final response =
          await get(Uri.parse('$api/dispositivousuario/usuario/$userId'));
      // sample info available in response
      final statusCode = response.statusCode;
      final headers = response.headers;
      final contentType = headers['content-type'];
      final json = response.body;
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        context
            .read<DispositivosUsuarioProvider>()
            .setDevicesUser(devicesUser: jsonResponse);
      }
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateStatusDevicesUser(
      int deviceUserID, int userId, BuildContext context) async {
    try {
      final url =
          Uri.parse('$api/dispositivousuario/actualizarEstatus/$deviceUserID');
      final headers = {"Content-type": "application/json"};
      final response = await put(
        url,
        headers: headers,
      );
      final statusCode = response.statusCode;
      final body = response.body;
      getDevicesByUser(context, userId);
      // print(body);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Object> updateStatusDevicesUserByDevice(
      int deviceUserID, int userId, BuildContext context, var device) async {
    try {
      final url = Uri.parse(
          '$api/dispositivousuario/actualizarEstadoDispositivoUsuario/$deviceUserID');
      // final url = Uri.parse('http://localhost:8080/firebase');
      final headers = {"Content-type": "application/json"};
      final body = {
        "nombre": device["nombre"],
        "isActive": !device["isActive"],
      };

      final json = jsonEncode(body);
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);
      // print("#########################################");
      // print(response.statusCode);
      // print(jsonResponse);
      if (response.statusCode == 200) {
        getDevicesByUser(context, userId);
      }
      return response.body;
      // print(body);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Object> notificationEmergncyFirebase(int emergenciaID,
      int emergenciaReportadaId, int comunidadReportaId, int usuarioID) async {
    // print("NOTIFICANDO EMergencias firebase ----------------");
    try {
      final url = Uri.parse('$api/firebase');
      // final url = Uri.parse('http://localhost:8080/firebase');
      final headers = {"Content-type": "application/json"};
      final body = {
        "message": {
          "topic": "comunidad$comunidadReportaId",
          "notification": {
            "title": "Emergencia",
            "body": "Se ha reportado una emergencia en su comunidad"
          },
          "data": {
            "emergenciaReportadaId": emergenciaReportadaId,
            "comunidadId": comunidadReportaId,
            "usuarioSenderId": usuarioID,
            "emergenciaId": emergenciaID
          }
        }
      };

      final json = jsonEncode(body);
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);
      // print("#########################################");
      // print(response.statusCode);
      return response.body;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> getMensajesComunidad(
    BuildContext context,
    int comunidadId,
  ) async {
    try {
      final response =
          await get(Uri.parse('$api/mensaejesComunidad/mensajes/$comunidadId'));

      final statusCode = response.statusCode;
      final headers = response.headers;
      final contentType = headers['content-type'];
      final json = response.body;
      var jsonResponse = jsonDecode(response.body);
      // print("Comunidad $comunidad_Id");
      // print(jsonResponse);
      context
          .read<MessagesProvider>()
          .setMensajesComunidad(mensajesComunidad: jsonResponse);
    } catch (e) {
      print(e.toString());
    }
  }

  // falta implementar
  Future<Object> setMensajeComunidad(BuildContext context, int comunidadId,
      var usuario, String mensaje) async {
    // print(usuario["usuarioVecino"]["nombre"]);
    // print(usuario["usuario_id"]);
    // print(comunidadId);
    try {
      final url = Uri.parse('$api/mensaejesComunidad');
      final headers = {"Content-type": "application/json"};
      final body = {
        "senderName": usuario["usuarioVecino"]["nombre"],
        "senderId": usuario["usuario_id"],
        "receiveGroup": comunidadId,
        "message": mensaje,
        "comunidad": {"comunidad_id": comunidadId},
        "usuarios": {"usuario_id": usuario["usuario_id"]}
      };
      final json = jsonEncode(body);
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);
// print(response.statusCode);
      // print(jsonResponse["emergenciaReportada_id"]);
      // return jsonResponse["emergenciaReportada_id"];
      return response.body;
    } catch (e) {
      context.read<UsuarioProvider>().loginFail();
      return -1;
    }
  }

  Future<Object> notificationMensajeFirebase(
      String usuarioNombre, String mensaje, int comunidadId) async {
    print("-----------------------  $mensaje");
    try {
      final url = Uri.parse('$api/firebase/mensaje');
      final headers = {"Content-type": "application/json"};
      final body = {
        "message": {
          "topic": "comunidad$comunidadId",
          "notification": {"title": usuarioNombre, "body": mensaje},
          "data": {}
        }
      };

      final json = jsonEncode(body);
      final response = await post(url, headers: headers, body: json);
      var jsonResponse = jsonDecode(response.body);
      print(response.statusCode);
      return response.body;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
