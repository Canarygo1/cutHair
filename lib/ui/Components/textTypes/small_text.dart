import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String texto;

  SmallText(this.texto, {Key key});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
