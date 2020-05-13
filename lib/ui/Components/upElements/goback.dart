import 'package:flutter/material.dart';
import '../../../global_methods.dart';

class GoBack extends StatelessWidget {
  BuildContext screen;
  String text;
  double HEIGHT;
  double WIDTH;

  GoBack(this.screen, this.text, {this.HEIGHT, this.WIDTH});

  @override
  Widget build(BuildContext context) {
    if(HEIGHT == null) HEIGHT = MediaQuery.of(context).size.height;
    if(WIDTH == null) WIDTH = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: WIDTH * 0.025, top: HEIGHT * 0.027),
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
                  text,
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
