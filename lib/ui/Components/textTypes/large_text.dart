import 'package:flutter/material.dart';

class LargeText extends StatelessWidget {
  String text;
  Color color;
  double size;
  FontWeight fontWeight;

  LargeText(this.text, {this.color = Colors.white, this.size = 20.0, this.fontWeight = FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
