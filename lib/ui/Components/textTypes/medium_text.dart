import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  String text;
  Color color;
  FontWeight boolText;
  MediumText(this.text, {this.color = Colors.white, this.boolText = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: boolText,
      ),
    );
  }
}
