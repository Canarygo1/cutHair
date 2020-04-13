import 'dart:async';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Info extends StatefulWidget {
  User user;

  Info(this.user);

  @override
  _InfoScreenState createState() => _InfoScreenState(user);
}

class _InfoScreenState extends State<Info> {
  User user;
  Widget screen;

  _InfoScreenState(this.user);

  globalMethods global = globalMethods();

  Widget ButtonChangePassword(BuildContext context) {
    return Center(
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Cambiar contraseña',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          onPressed: () {
            globalMethods().pushPage(context, resetPassword());
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.10,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
          backgroundColor: Color.fromRGBO(300, 300, 300, 1),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Appbar("Mis datos"),
            GestureDetector(
              onTap: logOut,
              child: Container(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  FontAwesomeIcons.solidCaretSquareLeft,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40.0, 20.0, 0.0, 20.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: new EdgeInsets.only(right: 30.0),
                          child: Text("Nombre: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ),
                        Container(
                            child: Expanded(
                          child: Text(user.name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: new EdgeInsets.only(right: 30.0),
                          child: Text("Apellido: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ),
                        Container(
                            child: Expanded(
                          child: Text(user.surname,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 30.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: new EdgeInsets.only(right: 40.0),
                          child: Text("Correo: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ),
                        Container(
                            child: Expanded(
                          child: Text(user.email,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 0.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: new EdgeInsets.only(right: 25.0),
                          child: Text("Teléfono: ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ),
                        Container(
                            child: Expanded(
                          child: Text(user.phone,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0)),
                        ))
                      ],
                    ),
                  )
                ],
              ),
            ),
            ButtonChangePassword(context)
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
