import 'package:cuthair/global_methods.dart';
import 'package:flutter/material.dart';

class GoBack extends StatelessWidget {
  BuildContext screen;
  String texto;

  GoBack(this.screen, this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
        child: new GestureDetector(
          onTap: () {
            globalMethods().popPage(screen);
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
        ));
  }
}
