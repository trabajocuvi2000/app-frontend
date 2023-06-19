import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Top_navDispositivosUsuarios extends StatefulWidget {
  const Top_navDispositivosUsuarios({super.key});

  @override
  State<Top_navDispositivosUsuarios> createState() => Top_navDispositivosUsuariosState();
}

class Top_navDispositivosUsuariosState extends State<Top_navDispositivosUsuarios> {
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: new LinearGradient(
          colors: [_primariColor, _accentColor],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "Mis Dispositivos",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white, //0xFF4C53A2
              ),
            ),
          ),
          Icon(
            Icons.more_vert, size: 30,
            color: Colors.white, //0xFF4C53A2
          ),
        ],
        
      ),
    );
  }
}
