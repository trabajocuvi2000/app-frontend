import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practica1/pages/Login.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isVisible = false;
  // Color(0xFFB74093)
  Color _primariColor = Color(0xFF4C53A2);
  Color _accentColor = Color(0xFF0071bc);
  _SplashScreenState() {
    new Timer(const Duration(microseconds: 2000), () {
      setState(() {
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => Login()), (route) => false);
      });
    });

    new Timer(Duration(microseconds: 10), () {
      setState(() {
        _isVisible = true; // now it is showing fade efect and navigation to Login Page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [_accentColor, _primariColor],
              begin: const FractionalOffset(0, 0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 1200),
            child: Center(
              child: Container(
                height: 140.0,
                width: 140.0,
                child: Center(
                  child: ClipOval(
                    child: Icon(
                      // add my logo here
                      Icons.android_outlined,
                      size: 128,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 2.0,
                        offset: Offset(5.0, 3.0),
                        spreadRadius: 2.0,
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
