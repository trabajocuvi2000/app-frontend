import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../comun/Temas.dart';

class Alertas {
  void showAlertDialog(BuildContext context, String title, String content) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("$title"),
    content: Text("$content"), // inide hhere I can add other type of coding such us container, colum, etc
    actions: [
      Container(
        decoration: TemasAyuda().buttonBoxDecoration(context),
        child: ElevatedButton(
          style: TemasAyuda().buttonStyle(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "Aceptar",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      )
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

}
