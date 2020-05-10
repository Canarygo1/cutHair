import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  String text;
  Color color;

  LargeText(this.text, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: color,
      ),
    );
  }
}
