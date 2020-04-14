import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  String texto;

  LargeText(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }
}
