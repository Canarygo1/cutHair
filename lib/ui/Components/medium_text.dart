import 'package:flutter/material.dart';

class MediumText extends StatelessWidget {
  String texto;

  MediumText(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
