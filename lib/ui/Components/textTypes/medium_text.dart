import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  String texto;
  Color color;
  MediumText(this.texto, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
