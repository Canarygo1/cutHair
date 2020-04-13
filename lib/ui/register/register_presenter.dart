import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class registerCode {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static String password1;

  void registerAuth(String email, String password, BuildContext context,
      Map<String, Object> data) async {
    FirebaseUser user;
    try {
      user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      if (user != null) {
        Firestore.instance
            .collection("Usuarios")
            .document(user.uid)
            .setData(data);
        globalMethods().pushPage(context, login());
      }
    } catch (e) {
      print(e);
      Toast.show(
        "Los datos no son correctos",
        context,
        gravity: Toast.BOTTOM,
        textColor: Colors.white,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
      );
    }
  }

  String validateNameAndSurname(String value) {
    String pattern =
        r'^[a-zA-ZÀ-ÿ\u00f1\u00d1]+(\s*[a-zA-ZÀ-ÿ\u00f1\u00d1]*)*[a-zA-ZÀ-ÿ\u00f1\u00d1]+$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "El nombre es necesario";
    } else if (!regExp.hasMatch(value)) {
      return "El nombre debe de ser a-z y A-Z";
    }
  }

  String checkEmail(String value) {
    bool pattern = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (value.length == 0) {
      return "El campo email no puede estar vacio";
    } else if (!pattern) {
      return 'Formato de email incorrecto';
    }
  }

  String checkSecurityPassword(String value) {
    password1 = value;
    bool pattern =
        RegExp(r'^(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value);
    if (!pattern) {
      return "La contraseña no tiene el formato correcto";
    }
  }

  String checkSamePassword(String password2) {
    if (password1 != password2) {
      return 'Las contraseñas no coinciden';
    }
  }

  bool checkCampos(BuildContext context, GlobalKey<FormState> keyForm) {
    if (keyForm.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  CheckUserExist(String email, String password) async {
    try {
      await auth.fetchSignInMethodsForEmail(email: email);
      FirebaseUser user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      return true;
    } catch (e) {
      return false;
    }
  }
}
