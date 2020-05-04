import 'package:flutter/material.dart';

class TextError extends StatelessWidget {
  String error;
  double HEIGHT;
  double WIDHT;
  TextError(this.error);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: HEIGHT * 0.005),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
          ),
        ),);
  }
}
