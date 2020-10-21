import 'dart:async';
import 'dart:io';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/charge_screen/charge_screen_presenter.dart';
import 'package:cuthair/ui/update_app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State implements ChargeScreenView {
  Widget screen;
  double height;
  double width;
  String version;
  ChargeScreenPresenter presenter;
  RemoteRepository _remoteRepository;

  @override
  void initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Client());
    presenter = ChargeScreenPresenter(this, _remoteRepository);
    Timer(Duration(seconds: 3), () => checkVersion());
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
    String versionApp;
    if (Platform.isIOS == true) {
      sofware = "Ios";
      versionApp = DotEnv().env['GET_IOS_VERSION'];
    } else {
      sofware = "Android";
      versionApp = DotEnv().env['GET_ANDROID_VERSION'];
    }
    await presenter.init(sofware);

    if (versionApp.split(".")[0] != this.version.split(".")[0] ||
        versionApp.split(".")[1] != this.version.split(".")[1]) {
      GlobalMethods().pushAndReplacement(context, UpdateAppScreen());
    } else {
      GlobalMethods().pushAndReplacement(context, await GlobalMethods().searchDBUser(context));
    }
  }

  @override
  showVersion(String version) {
    if (mounted) {
      setState(() {
        this.version = version;
      });
    }
  }
}
