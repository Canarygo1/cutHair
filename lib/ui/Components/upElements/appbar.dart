import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  String text;

  Appbar(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.10,
      color: Color.fromRGBO(230, 73, 90, 1),
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
