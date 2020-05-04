import 'package:cuthair/global_methods.dart';
import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  BuildContext screen;
  String texto;

  GoBack(this.screen, this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.025,
          top: MediaQuery.of(context).size.height * 0.027),
      child: GestureDetector(
        onTap: () {
          GlobalMethods().popPage(screen);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 35.0,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  texto,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
