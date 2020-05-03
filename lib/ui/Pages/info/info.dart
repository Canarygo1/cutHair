import 'dart:async';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../data/remote/check_connection.dart';

class Info extends StatefulWidget {
  User user;

  Info(this.user);

  @override
  _InfoScreenState createState() => _InfoScreenState(user);
}

class _InfoScreenState extends State<Info>  {
  User user;
  Widget screen;

  _InfoScreenState(this.user);

  globalMethods global = globalMethods();

  changePassword(){
    ConnectionChecked.checkInternetConnectivity(context);
    globalMethods().pushPage(context, resetPassword());
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Stack(
          children: <Widget>[
            Appbar("Mis datos"),
            Container(
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: logOut,
                  child: Container(
                    padding: EdgeInsets.only(right: 20, top: MediaQuery.of(context).size.height * 0.06),
                    child: Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width* 0.03,
                    bottom: MediaQuery.of(context).size.width* 0.1),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width* 0.06),
                      child: Text("Nombre: ",
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ),
                    Container(
                        child: Expanded(
                      child: Text(user.name,
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width* 0.03,
                    bottom: MediaQuery.of(context).size.width* 0.1),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width* 0.06),
                      child: Text("Apellido: ",
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ),
                    Container(
                        child: Expanded(
                      child: Text(user.surname,
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width* 0.03,
                    bottom: MediaQuery.of(context).size.width* 0.1),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width* 0.09),
                      child: Text("Correo: ",
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ),
                    Container(
                        child: Expanded(
                      child: Text(user.email,
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width* 0.03,
                    bottom: MediaQuery.of(context).size.width* 0.1),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: MediaQuery.of(context).size.width* 0.06),
                      child: Text("Teléfono: ",
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ),
                    Container(
                        child: Expanded(
                      child: Text(user.phone,
                          style:
                              TextStyle(color: Colors.white, fontSize: 17.0)),
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width* 0.15,
            bottom: MediaQuery.of(context).size.width* 0.1),
              child: Button(() => changePassword(), LargeText("Cambiar contraseña")),
        ),
      ]),
    );
  }

  Future<void> logOut() async {
    await DBProvider.db.delete();
    screen = login();
    await FirebaseAuth.instance.signOut();
    new Timer(Duration(seconds: 1), changeScreen);
  }

  changeScreen() {
    globalMethods().popPage(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
