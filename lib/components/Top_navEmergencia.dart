import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Top_navEmergencia extends StatefulWidget {
  const Top_navEmergencia({super.key});

  @override
  State<Top_navEmergencia> createState() => _Top_navEmergenciasState();
}

class _Top_navEmergenciasState extends State<Top_navEmergencia> {
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
          Row(
            children: [
              InkWell(
                onTap: () {
                  // goes back to the previous pegae/screen
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, 'emergencias');
                  // https://www.youtube.com/watch?v=mN5Co64gsT0
                  // Navigator.pushReplacementNamed(context, "/emergencias");
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.white,
                  // #009fe3
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Emergencia",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, //0xFF4C53A2
                  ),
                ),
              ),
            ],
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
