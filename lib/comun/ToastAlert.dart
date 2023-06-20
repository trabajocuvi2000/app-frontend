import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastAlert {
  static showCustom(BuildContext context, String nombreDispositivo , String text) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
        // color: Color.fromARGB(255, 182, 243, 184),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Dispositivo activado',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
    );
  }

   static showCustomUserUpdate(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.green,
        // color: Color.fromARGB(255, 182, 243, 184),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
          Icon(
            Icons.check,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Datos actualizados correctamente',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
    );
  }

    static showCustomUserUpdateFailed(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
        // color: Color.fromARGB(255, 182, 243, 184),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: const [
          Icon(
            Icons.cancel,
            color: Colors.white,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Lo sentimos no se pudo realizar su solicitud',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
      gravity: ToastGravity.BOTTOM,
    );
  }
}
