import 'package:flutter/material.dart';

class Appbar extends StatelessWidget {
  String texto;

  Appbar(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(bottom: 50),
      height: MediaQuery.of(context).size.height * 0.12,
      color: Color.fromRGBO(230, 73, 90, 1),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
