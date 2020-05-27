import 'dart:async';
import 'package:cuthair/data/remote/push_notification_service.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'data/local/db_sqlite.dart';
import 'global_methods.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State {
  Widget screen;
  PushNotificationService pushNotificationService;
  double HEIGHT;
  double WIDHT;

  @override
  void initState() {
    super.initState();
    pushNotificationService = PushNotificationService();
    pushNotificationService.initialise();
    GlobalMethods().searchDBUser(context);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
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
                padding: EdgeInsets.only(bottom: HEIGHT * 0.02),
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
}
