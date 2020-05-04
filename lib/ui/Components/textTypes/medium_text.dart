import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  String texto;
  Color color;
  FontWeight boolText;
  MediumText(this.texto, {this.color = Colors.white, this.boolText = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: boolText,
      ),
    );
  }
}
