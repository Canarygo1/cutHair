import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
<<<<<<< datosUsuario
import 'package:cuthair/data/local/db_sqlite.dart';
=======
>>>>>>> master
import 'package:cuthair/ui/bottom_navigation/menu.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:cuthair/ui/bottom_navigation/menu.dart';
import '../../global_methods.dart';

class loginCode {
  final FirebaseAuth auth = FirebaseAuth.instance;
  User userLogin;
  RemoteRepository _remoteRepository = HttpRemoteRepository(Firestore.instance);

  void iniciarSesion(
      String email, String password, BuildContext context) async {
    FirebaseUser user;

    String uid;
    Widget widget;

    try {
      user = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      uid = await currentUser();
      userLogin = await _remoteRepository.getUser(uid);
      switch (userLogin.permission) {
        case 1:
          widget = Menu(0);
          break;
        case 2:
          widget = Menu(1);
          break;
        case 3:
          widget = Menu(2);
          break;
      }
      DBProvider.db.delete(userLogin);
      DBProvider.db.getUser();
      //DBProvider.db.insert(userLogin);
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
