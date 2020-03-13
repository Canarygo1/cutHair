import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../global_methods.dart';

class loginCode {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void iniciarSesion(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    User userLogin = User();
    Widget widget;

    try {
      user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      print(currentUser());
      switch (userLogin.permission) {
        case 1:
          widget = HomeBoss();
          break;
        case 2:
          widget = Home();
          break;
        case 3:
          widget = Home();
          break;
      }
      globalMethods().pushPage(context, widget);
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

  Future<String> currentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid;
    return uid;
  }

}
