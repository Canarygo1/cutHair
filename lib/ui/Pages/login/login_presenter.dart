import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../global_methods.dart';

class LoginCode {
  LoginView loginView;

  LoginCode(this.loginView);

  final FirebaseAuth auth = FirebaseAuth.instance;
  User userLogin;
  Widget screen;
  RemoteRepository _remoteRepository = HttpRemoteRepository(Firestore.instance);

  void iniciarSesion(
      String email, String password, BuildContext context) async {
    FirebaseUser user;
    try {
      user = (await auth.signInWithEmailAndPassword(
          email: email, password: password))
          .user;
      userLogin = await _remoteRepository.getUser(user.uid);
      play(context);
      loginView.changeTextError("");
    } catch (Exception) {
      loginView.changeTextError("Los datos no son correctos");
    }
  }

  void play(BuildContext context) async {
    screen = Menu(userLogin);
    DBProvider.db.insert(userLogin);
    globalMethods().PushAndReplacement(context, screen);
  }
}

abstract class LoginView {
  changeTextError(String text);
}