import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Top_navEmergencias extends StatefulWidget {
  final GlobalKey<ScaffoldState> data;

  const Top_navEmergencias({super.key, required this.data});

  @override
  State<Top_navEmergencias> createState() => _Top_navEmergenciasState();
}

class _Top_navEmergenciasState extends State<Top_navEmergencias> {
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
          GestureDetector(
            onTap: () {
              print("object");
              widget.data.currentState?.openDrawer();
              print("Abriedno drawer");
              // Navigator.pushNamed(context, "/login");
            },
            child: Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Emergencias",
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
