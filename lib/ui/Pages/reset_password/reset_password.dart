import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cuthair/ui/Components/large_text.dart';

import '../../../data/remote/check_connection.dart';

class resetPassword extends StatelessWidget {

  TextEditingController emailControler = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> changePassword() async {
    try {
      auth.setLanguageCode("es");
      await auth.sendPasswordResetEmail(
        email: emailControler.text.toString(),
      );
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            GoBack(context, "Volver"),
            emailTextField(),
            Button(() => sendEmail(context), LargeText("Enviar")),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
      child: TextFormField(
        controller: emailControler,
        decoration: InputDecoration(
          hintText: 'Correo Electronico',
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
    );
  }

  sendEmail(BuildContext context){
    ConnectionChecked.checkInternetConnectivity(context);
    changePassword();
    globalMethods().pushPage(context, login());
    Toast.show(
      'Se ha enviado un correo a este email',
      context,
      gravity: Toast.BOTTOM,
      textColor: Colors.black,
      duration: Toast.LENGTH_LONG,
      backgroundColor: Color.fromRGBO(230, 73, 90, 1),
    );
  }
}

