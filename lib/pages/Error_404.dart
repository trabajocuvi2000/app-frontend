import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error_404 extends StatefulWidget {
  const Error_404({super.key});

  @override
  State<Error_404> createState() => _Error_404State();
}

class _Error_404State extends State<Error_404> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                child: Center(child: Text("Something has gone wrong")),
                color: Colors.red[200],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
