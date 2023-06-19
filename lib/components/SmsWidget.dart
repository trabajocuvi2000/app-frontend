import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmsWidget extends StatefulWidget {
  final String sender;
  final String sms;
  const SmsWidget({super.key, required this.sender, required this.sms});

  @override
  State<SmsWidget> createState() => _SmsWidgetState();
}

class _SmsWidgetState extends State<SmsWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color.fromARGB(255, 81, 248, 231),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.sender,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 79, 59, 255),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  widget.sms,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
