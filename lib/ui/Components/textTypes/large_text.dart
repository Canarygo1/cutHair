import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  String texto;
  Color color;

  LargeText(this.texto, {this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 20,
        color: color,
      ),
    );
  }
}
