import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Top_navChat extends StatefulWidget {
  const Top_navChat({super.key});

  @override
  State<Top_navChat> createState() => _Top_navEmergenciasState();
}

class _Top_navEmergenciasState extends State<Top_navChat> {
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
              "Chats",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white, //0xFF4C53A2
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
               Navigator.pushNamed(context, "/home");
            },
            child: Icon(
              Icons.more_vert, size: 30,
              color: Colors.white, //0xFF4C53A2
            ),
          ),
        ],
        
      ),
    );
  }
}
