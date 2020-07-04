import 'dart:io';

import 'package:components/components.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateAppScreen extends StatefulWidget {
  @override
  _UpdateAppScreenState createState() => _UpdateAppScreenState();
}

class _UpdateAppScreenState extends State<UpdateAppScreen> {
  String software;

  @override
  void initState() {
    if (Platform.isIOS) {
      software = "IOS";
    } else {
      software = "Android";
    }
    launchStore();
    super.initState();
  }

  launchStore() {
    if (software == "IOS") {
      launch('https://apps.apple.com/es/app/res%C3%A9rvalo/id1511570047');
    } else {
      launch(
          'https://play.google.com/store/apps/details?id=capihair.cuthair&gl=ES');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(230, 73, 90, 1),
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: 150,
              ),
            ),
            Flexible(child: Components.mediumText("¡Vaya! Han llegado nuevas funcionalidades.")),
            Flexible(child: Components.mediumText("Actualiza tu app y disfrútalas.")),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Components.smallButton(
                () => launchStore(),
                Components.mediumText("Actualizar"),
                color: Color.fromRGBO(230, 73, 90, 1),
                width: MediaQuery.of(context).size.width,
              ),
            )
          ],
        ),
      ),
    );
  }
}
