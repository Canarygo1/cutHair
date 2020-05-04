import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import '../../../data/remote/check_connection.dart';

class resetPassword extends StatelessWidget {

  TextEditingController emailControler = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  double HEIGHT;
  double WIDHT;

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
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            GoBack(context, "Volver"),
            emailTextField(),
            MyButton(() => sendEmail(context), LargeText("Enviar")),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, HEIGHT * 0.176, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        controller: emailControler,
        decoration: InputDecoration(
          hintText: 'Correo Electronico',
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
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
    GlobalMethods().pushPage(context, Login());
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

