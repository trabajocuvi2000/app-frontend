import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// change item shape -> https://stackoverflow.com/questions/70229321/how-do-i-change-the-labels-color-in-a-bottomnavigationbaritem-in-flutter

class Bottom_nav extends StatefulWidget {
  final Function currentIndex;
  const Bottom_nav({super.key, required this.currentIndex});

  @override
  State<Bottom_nav> createState() => _Bottom_navState();
}

class _Bottom_navState extends State<Bottom_nav> {
  int index = 0;
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              // color: Colors.black38,
              // spreadRadius: 0,
              // blurRadius: 10,
              blurRadius: 4,
              color: Colors.grey.shade400,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: (int i) {
              setState(() {
                index = i;
                widget.currentIndex(i);
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: _primariColor,
            iconSize: 25.0,
            selectedFontSize: 14.0,
            unselectedFontSize: 12.0,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.emergency_recording), label: 'Alarmas'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.contact_emergency_outlined), label: 'Camaras'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.manage_accounts), label: 'Usuarios'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.devices), label: 'Dispositivos'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
            ],
          ),
        ));
  }
}
