import 'dart:async';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/confirm_dialog.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:cuthair/ui/Components/textTypes/text_error.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/contribuyers/contribuyer_screen.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Info extends StatefulWidget {
  User user;

  Info(this.user);

  @override
  _InfoScreenState createState() => _InfoScreenState(user);
}

class _InfoScreenState extends State<Info> {
  User user;
  Widget screen;
  double HEIGHT;
  double WIDHT;
  String error = "";
  ConfirmDialog confirmDialog;

  _InfoScreenState(this.user);

  GlobalMethods global = GlobalMethods();

  changePassword() {
    ConnectionChecked.checkInternetConnectivity(context);
    ResetPasswordCode(DBProvider.users[0].email).changePassword();
    setState(() {
      error = 'Se ha enviado un correo a dicha direccion email';
    });
    DBProvider.db.delete();
    Timer(Duration(seconds: 2),
        () => GlobalMethods().pushAndReplacement(context, Login()));
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: LargeText("Mis datos"),
        centerTitle: true,
        actions: <Widget>[
          GestureDetector(
            onTap: logOut,
            child: Container(
              padding:
                  EdgeInsets.only(right: WIDHT * 0.05),
              child: Icon(
                Icons.exit_to_app,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(
                WIDHT * 0.2, HEIGHT * 0.04, 0.0, HEIGHT * 0.03),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: WIDHT * 0.03, bottom: HEIGHT * 0.054),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: WIDHT * 0.06),
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
                  padding: EdgeInsets.only(
                      left: WIDHT * 0.03, bottom: HEIGHT * 0.054),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: WIDHT * 0.06),
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
                  padding: EdgeInsets.only(
                      left: WIDHT * 0.03, bottom: HEIGHT * 0.054),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: WIDHT * 0.09),
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
                  padding: EdgeInsets.only(
                      left: WIDHT * 0.03, bottom: HEIGHT * 0.054),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(right: WIDHT * 0.06),
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
            padding:
                EdgeInsets.only(left: WIDHT * 0.15, bottom: HEIGHT * 0.054),
            child: MyButton(
                () => functionResetPassword(), LargeText("Cambiar contraseña"),
                color: Color.fromRGBO(230, 73, 90, 1)),
          ),
          error.length == 0 ? Container() : TextError(error),
          Padding(
            padding: EdgeInsets.only(top: HEIGHT * 0.18),
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://pruebafirebase-44f30.web.app/');
                          },
                        text: " Política de Privacidad.",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 12)),
                    TextSpan(
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            GlobalMethods()
                                .pushPage(context, contribuyer_screen());
                          },
                        text: " Lista de contribuidores",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
          Center(child: SmallText("@Reservaloapp"))
        ]),
      ),
    );
  }

  functionResetPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        confirmDialog = ConfirmDialog(
          MediumText("Seguro que quiere cambiar la contraseña de: " +
              DBProvider.users[0].email),
          () => {
            changePassword(),
            GlobalMethods().popPage(confirmDialog.context)
          },
        );
        return confirmDialog;
      },
    );
  }

  Future<void> logOut() async {
    await DBProvider.db.delete();
    screen = Login();
    await FirebaseAuth.instance.signOut();
    Timer(Duration(seconds: 1), changeScreen);
  }

  changeScreen() {
    GlobalMethods().pushAndReplacement(context, screen);
  }
}
