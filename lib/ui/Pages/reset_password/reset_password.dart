import 'dart:async';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/my_textField.dart';
import 'package:cuthair/ui/Components/textTypes/text_error.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password_code.dart';
import 'package:flutter/material.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';


class ResetPassword extends StatefulWidget {

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailControler = TextEditingController();
  double HEIGHT;
  double WIDHT;
  String error;

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery
        .of(context)
        .size
        .height;
    WIDHT = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            GoBack(context, "Volver"),
            MyTextField(
              emailControler, TextInputType.emailAddress, InputDecoration(
              hintText: 'Correo Electronico',
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.white, width: WIDHT * 0.003),
              ),
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ), TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),),
            MyButton(() => sendEmail(context), LargeText("Enviar"),
                color: Color.fromRGBO(230, 73, 90, 1)),
            error.length == 0 ? Container() : TextError(error),
          ],
        ),
      ),
    );
  }

  sendEmail(BuildContext context) {
    ConnectionChecked.checkInternetConnectivity(context);
    ResetPasswordCode(emailControler.text.toString()).changePassword();
    setState(() {
      error = 'Se ha enviado un correo a dicho email';
    });
    Timer(Duration(seconds: 2), () =>
        GlobalMethods().pushAndReplacement(context, Login()));
  }
}

