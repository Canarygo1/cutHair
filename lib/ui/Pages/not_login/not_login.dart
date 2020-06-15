import 'dart:math';

import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotLoginScreen extends StatefulWidget {

  String title;
  String message;

  NotLoginScreen(this.title, this.message);

  @override
  _notLoginState createState() => _notLoginState();
}

class _notLoginState extends State<NotLoginScreen> {
  double HEIGHT;
  double WIDHT;
  Random rnd;
  List<String> backgroundImages = [
    "assets/images/hairdressingBg.jpg",
    "assets/images/clubBg.jpg",
    "assets/images/restaurantBg.jpg"
  ];
  int randomBackground;

  @override
  void initState() {
    rnd = new Random();
    randomBackground = 0 + rnd.nextInt(3 - 0);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 73, 90, 1),
          title: LargeText(this.widget.title),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ExactAssetImage(backgroundImages[randomBackground]),
              fit: BoxFit.cover,
            ),
          ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.35, bottom: 1),
                child: LargeText(
                  this.widget.title,
                  fontWeight: FontWeight.bold,
                  size: 22,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.02, bottom: 10.0),
                child: MediumText(
                  this.widget.message,
                  boolText: FontWeight.normal,
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: EdgeInsets.only(
                        top: HEIGHT * 0.04),
                    child: GestureDetector(
                      onTap: () {
                        GlobalMethods().removePages(context);
                        GlobalMethods().pushAndReplacement(context, Login());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(6.0))),
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              decorationColor: Color.fromRGBO(0, 144, 255, 1),
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      ),
                    )))
          ],
        ),
    ));
  }
}
