import 'dart:async';
import 'package:cuthair/data/remote/push_notification_service.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'data/local/db_sqlite.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State {
  Widget screen;
  PushNotificationService pushNotificationService;

  @override
  void initState() {
    super.initState();
    pushNotificationService = new PushNotificationService();
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
    await pushNotificationService.initialise();

    if (DBProvider.users.length > 0) {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      if (user.uid == DBProvider.users[0].uid) {
        screen = Menu(DBProvider.users[0]);
      } else {
        DBProvider.db.delete();
        screen = login();
      }
    } else {
      screen = login();
    }
    new Timer(Duration(seconds: 3), changeScreen);
  }

  changeScreen() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => screen));
  }
}
