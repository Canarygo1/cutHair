import 'dart:async';
import 'dart:math';
import 'package:components/components.dart';
import 'package:cuthair/data/remote/push_notification_service.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/register/register.dart';
import 'package:cuthair/ui/Pages/reset_password/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login_presenter.dart';

class Login extends StatefulWidget {
  String error;
  Color color;
  Login({this.error = '', this.color});

  @override
  _LoginState createState() => _LoginState(error, color);
}

class _LoginState extends State<Login> implements LoginView {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  Color color;
  LoginCode loginCode;
  double HEIGHT;
  double WIDHT;
  List list;
  Random rnd;
  List<String> backgroundImages = [
    "assets/images/hairdressingBg.jpg",
    "assets/images/clubBg.jpg",
    "assets/images/restaurantBg.jpg"
  ];
  int randomBackground;

  PushNotificationService pushNotificationService;

  _LoginState(this.error, this.color);

  @override
  void initState() {
    color == null ? color = Color.fromRGBO(230, 73, 90, 1) : color = color;
    Timer(Duration(seconds: 3), () => this.setState(() {error = '';}));
    rnd = new Random();
    randomBackground = 0 + rnd.nextInt(3 - 0);
    loginCode = LoginCode(this);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage(backgroundImages[randomBackground]),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: <Widget>[
                TextLoginWithoutAccount(context),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      WIDHT * 0.200, HEIGHT * 0.126, WIDHT * 0.200, 0),
                  child: Container(
                      child: Image.asset("assets/images/logo.png",
                          fit: BoxFit.cover)),
                ),
                textFieldWidget(emailController, TextInputType.emailAddress,
                    "Correo electrónico",
                    topPadding: HEIGHT * 0.07),
                textFieldWidget(
                    passwordController, TextInputType.text, "Contraseña",
                    obscureText: true),
                error.length == 0 ? Container() : Components.errorText(error, color: color,),
                TextForgetPassword(context),
                Components.smallButton(() => logIn(), Components.largeText("Entrar"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
                TextRegister(context),
              ],
            ),
          ),
        ));
  }

  Widget textFieldWidget(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          WIDHT * 0.101, topPadding, WIDHT * 0.089, HEIGHT * 0.027),
      child: Components.textFieldPredefine(
        controller,
        textType,
        InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
        TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        obscureText: obscureText,
      ),
    );
  }

  Widget logo(BuildContext context) {}

  Widget TextRegister(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, right: MediaQuery.of(context).size.width * 0.10),
            child: GestureDetector(
              onTap: () {
                GlobalMethods().pushPage(context, register());
              },
              child: Text(
                'Registrarse',
                style: TextStyle(
                  color: Color.fromRGBO(0, 144, 255, 1),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromRGBO(0, 144, 255, 1),
                  fontSize: 16.0,
                ),
              ),
            )));
  }

  Widget TextLoginWithoutAccount(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(
                top: HEIGHT * 0.02,
                right: MediaQuery.of(context).size.width * 0.05),
            child: GestureDetector(
              onTap: () {
                GlobalMethods().pushAndReplacement(context, Menu(null));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Omitir',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      decorationColor: Color.fromRGBO(0, 144, 255, 1),
                      fontSize: 13.0,
                    ),
                  ),
                ),
              ),
            )));
  }

  Widget TextForgetPassword(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding:
                EdgeInsets.only(bottom: HEIGHT * 0.027, right: WIDHT * 0.10),
            child: GestureDetector(
              onTap: () {
                GlobalMethods().pushPage(context, ResetPassword());
              },
              child: Text(
                '¿Has olvidado tu contraseña?',
                style: TextStyle(
                  color: Color.fromRGBO(0, 144, 255, 1),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromRGBO(0, 144, 255, 1),
                  fontSize: 16.0,
                ),
              ),
            )));
  }

  logIn() {
    changeTextError("");
    loginCode.iniciarSesion(emailController.text.toLowerCase(),
        passwordController.text.toString(), context);
  }

  @override
  changeTextError(String text) {
    if (mounted) {
      setState(() {
        error = text;
      });
    }
  }
}
