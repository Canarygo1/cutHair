import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  String text;
  FontWeight boolText;

  SmallText(this.text, {this.boolText = FontWeight.bold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: boolText,
      ),
    );
  }
}
