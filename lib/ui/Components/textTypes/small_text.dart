import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String text;
  FontWeight boolText;
  double size;

  SmallText(this.text, {this.boolText = FontWeight.bold, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: Colors.white,
        fontWeight: boolText,
      ),
    );
  }
}
