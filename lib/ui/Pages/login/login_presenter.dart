import 'dart:convert';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class LoginCode {
  LoginView loginView;
  LoginCode(this.loginView);

  final storage = new FlutterSecureStorage();
  User userLogin;
  Widget screen;
  RemoteRepository _remoteRepository = HttpRemoteRepository(Client());

  void iniciarSesion(
      String email, String password, BuildContext context) async {
    try {
      Response responseLogin = await _remoteRepository.loginUser(email, password);
      String userId = json.decode(responseLogin.body)['result']['Id'];
      String accessToken = json.decode(responseLogin.body)['result']['AccessToken'];
      String refreshToken = json.decode(responseLogin.body)['result']['RefreshToken'];
      userLogin = await _remoteRepository.getUser(
          userId, accessToken);
      await storage.write(key: 'AccessToken', value: accessToken);
      await storage.write(key: 'RefreshToken', value: refreshToken);
      DBProvider.db.insert(userLogin);
      await GlobalMethods().removePagesAndGoToNewScreen(context, await GlobalMethods().searchDBUser(context));
      loginView.changeTextError("");
    } catch (Exception) {
      loginView.changeTextError("Los datos no son correctos");
    }
  }
}

abstract class LoginView {
  changeTextError(String text);
}