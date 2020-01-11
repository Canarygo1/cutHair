import 'package:cuthair/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginCode.dart';
import 'login.dart';

class registerCode{
  final FirebaseAuth auth =FirebaseAuth.instance;

  void register(String email, String password, BuildContext context) async {
    FirebaseUser user;
    user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    if (user != null) {

      loginCode().pushPage(context, login());
    } else {

    }
  }

}