import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String texto;
  FontWeight boolText;

  SmallText(this.texto, {this.boolText = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: boolText,
      ),
    );
  }
}
