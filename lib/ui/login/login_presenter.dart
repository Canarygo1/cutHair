import 'package:cuthair/ui/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../global_methods.dart';

class loginCode {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void iniciarSesion(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      globalMethods().pushPage(context, Home());
    } catch (Exception) {
      Toast.show(
        "Los datos no son correctos",
        context,
        gravity: Toast.BOTTOM,
        textColor: Colors.black,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
      );
    }
  }
}
