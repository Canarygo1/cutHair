import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class resetPassword extends StatelessWidget {

  TextEditingController emailControler = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> changePassword() async {
    auth.setLanguageCode("es");
    await auth.sendPasswordResetEmail(
        email: emailControler.text.toString(),
    );
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
            botonEnviarCorreo(context),
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

  Widget botonEnviarCorreo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
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
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }
}

