import 'dart:async';
import 'package:components/components.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password_code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> implements ResetPasswordView{
  TextEditingController emailControler = TextEditingController();
  double height;
  double width;
  String error = "";
  ResetPasswordCode presenter;
  RemoteRepository remoteRepository;

  @override
  void initState() {
    remoteRepository = HttpRemoteRepository(Client());
    presenter = ResetPasswordCode(remoteRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        leading: Components.goBack(
          context,
          "",
        ),
        title: Components.largeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.101, height * 0.176, width * 0.089, height * 0.027),
              child: Components.textFieldPredefine(
                emailControler,
                TextInputType.emailAddress,
                InputDecoration(
                  hintText: 'Correo Electrónico',
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white, width: width * 0.003),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            Components.smallButton(() => sendEmail(context), Components.largeText("Enviar"),
                color: Color.fromRGBO(230, 73, 90, 1), width: width,),
            error.length == 0 ? Container() : Components.errorText(error),
          ],
        ),
      ),
    );
  }

  sendEmail(BuildContext context) {
    presenter.changePassword(emailControler.text);
    Timer(Duration(seconds: 2),
        () => GlobalMethods().pushAndReplacement(context, Login()));
  }

  @override
  showEmailSend(String texto) {
    if(mounted){
      setState(() {
        error = texto;
      });
    }
  }
}
