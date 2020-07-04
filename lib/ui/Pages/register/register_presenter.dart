import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RegisterCode {
  final FirebaseAuth auth = FirebaseAuth.instance;
  static String password1;

  void registerAuth(String email, String password, BuildContext context,
      Map<String, Object> data) async {
    FirebaseUser user;
    user = (await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    if (user != null) {
      Firestore.instance
          .collection(DotEnv().env['GET_USUARIOS'])
          .document(user.uid)
          .setData(data);
      GlobalMethods().removePagesAndGoToNewScreen(
          context,
          Login(
            error: "El usuario se ha creado con éxito",
            color: Colors.green,
          ));
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
    return null;
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
    return null;
  }

  String checkSecurityPassword(String value) {
    password1 = value;
    bool pattern =
        RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9]).{8,}$').hasMatch(value);
    if (!pattern) {
      return "La contraseña debe tener 8 dígitos y mínimo una letra y un número";
    }
    return null;
  }

  String checkSamePassword(String password2) {
    if (password1 != password2) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }

  bool checkCampos(BuildContext context, GlobalKey<FormState> keyForm) {
    if (keyForm.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }
}
