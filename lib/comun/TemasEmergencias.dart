import 'dart:ui';

class TemasEmergencias {
  String backGraundEmergencia(int nivelEmergencia) {
    if (nivelEmergencia == 1) {
      return "0xFFff534b"; // rojo
    } else if (nivelEmergencia == 2) {
      return "0xFFFF8000"; // naranja
    } else if (nivelEmergencia == 3) {
      return "0xFF4646FF"; // azul
    } else {
      return "0xFFFFFFFF"; //
    }
  }

  //  Color ssss = Color(0xFF008f39);
  // Color _accentaaaColor = Color(0xFFFF0000);
  // Color rojo = Color(0xFFff534b);
  // Color azz = Color(0xFF99CCFF);

  //  Color _accentColor = Color.fromARGB(255, 240, 29, 29);
  // Color azul = Color.fromARGB(255, 70, 103, 248);
  // Color verde = Color.fromARGB(255, 91, 248, 70);
  // Color white = Color.fromARGB(255, 255, 255, 255);

}
