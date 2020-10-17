import 'dart:convert';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegisterCode {
  static String password1;
  RemoteRepository remoteRepository =
  HttpRemoteRepository(Client());

  void registerAuth(String email, String password, BuildContext context,
      Map<String, Object> data) async {
    String responseAuth =
    await remoteRepository.createUserAuth(email, password);
    var userId = await json.decode(responseAuth)['result'];
    var code = await json.decode(responseAuth)['code'];
    Response responseUser = await remoteRepository.createUserData(data, userId);
    code = await json.decode(responseUser.body)['code'];

    if (code == 200) {
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
      return "El campo nombre no puede estar vacío";
    } else if (!regExp.hasMatch(value)) {
      return "Introduzca un nombre correcto.";
    }
    return null;
  }

  String checkEmail(String value) {
    bool pattern = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    if (value.length == 0) {
      return "El campo email no puede estar vacío";
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
      return "Debe tener letras y números. Min 8 dígitos.";
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
