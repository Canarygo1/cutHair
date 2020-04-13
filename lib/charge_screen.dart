import 'dart:async';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:flutter/material.dart';
import 'data/local/db_sqlite.dart';
import 'model/user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State {
  Widget screen;
  List<User> lista;

  @override
  void initState() {
    super.initState();
    play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Color.fromRGBO(44, 45, 47, 1),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  'Bienvenido a cutHair',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.white,
              ),
            ],
          )
        ],
      ),
    ));
  }

  void play() async {
    await DBProvider.db.getUser();
    if(DBProvider.users.length > 0) lista = DBProvider.users;
    if (lista != null) {
      screen = Menu(lista[0]);
    } else{
      screen = login();
    }
    new Timer(Duration(seconds: 3), changeScreen);
  }

  changeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
  }
}
