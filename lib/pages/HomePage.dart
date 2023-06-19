import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/components/Bottom_nav.dart';
import 'package:practica1/routes.dart';

import '../components/SideNavbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  Bottom_nav? myBoN;

  @override
  void initState() {
    // TODO: implement initState
    myBoN = Bottom_nav(currentIndex: (i) {
      setState(() {
        // es el index de arriba
        index = i;
      });
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  // Map <String, Object> data = {};

  @override
  Widget build(BuildContext context) {
    final infoUser = ModalRoute.of(context)!.settings.arguments ;
    if (infoUser != null){
      print(infoUser);
    }
    // data = {"dataKey":ModalRoute.of(context).settings.arguments};
    return Scaffold(
      key: _scaffoldState,
      drawer: SideNavBar(),
      backgroundColor: Colors.white, // I added this, this was no before
      bottomNavigationBar: myBoN,
      body: Routes(index: index, data: _scaffoldState),
    );
  }
}
