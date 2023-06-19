import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SmsWidgetOther extends StatefulWidget {
  final String sender;
  final String sms;
  const SmsWidgetOther({super.key, required this.sender, required this.sms});

  @override
  State<SmsWidgetOther> createState() => _SmsWidgetOtherState();
}

class _SmsWidgetOtherState extends State<SmsWidgetOther> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
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
                      color: Colors.red),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  widget.sms,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}