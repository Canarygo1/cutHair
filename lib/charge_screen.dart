import 'package:cuthair/data/remote/push_notification_service.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage("assets/images/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
