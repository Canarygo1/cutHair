import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/push_notification_service.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/ui/Pages/charge_screen/charge_screen_presenter.dart';
import 'package:cuthair/ui/update_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../global_methods.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State implements ChargeScreenView{
  Widget screen;
  PushNotificationService pushNotificationService;
  double HEIGHT;
  double WIDHT;
  String version;
  ChargeScreenPresenter presenter;
  RemoteRepository _remoteRepository;

  @override
  void initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ChargeScreenPresenter(this, _remoteRepository);
    pushNotificationService = PushNotificationService();
    pushNotificationService.initialise();
    Timer(Duration(seconds: 3), () => checkVersion());
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

  checkVersion() async {
    String sofware;
    if(Platform.isIOS){
      sofware = "IOS";
    }else{
      sofware = "Android";
    }
    await presenter.init(sofware);
    String versionApp;
    if(sofware == "IOS"){
      versionApp = DotEnv().env['GET_IOS_VERSION'];
    }else{
      versionApp = DotEnv().env['GET_ANDROID_VERSION'];
    }
    if(versionApp.split(".")[0] != this.version.split(".")[0] || versionApp.split(".")[1] != this.version.split(".")[1]){
      GlobalMethods().pushAndReplacement(context, UpdateAppScreen());
    }else{
      GlobalMethods().searchDBUser(context);
    }
  }

  @override
  showVersion(String version) {
    if(mounted){
      setState(() {
        this.version = version;
      });
    }
  }
}
