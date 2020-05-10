import 'dart:math';

import 'package:cuthair/ui/Components/textTypes/text_error.dart';
import 'package:cuthair/ui/Pages/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../../global_methods.dart';
import '../../Components/button.dart';
import '../../Components/textTypes/large_text.dart';
import '../reset_password/reset_password.dart';
import 'login_presenter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> implements LoginView {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String error = "";
  LoginCode loginCode;
  double HEIGHT;
  double WIDHT;
  List list;
  Random rnd;
  List<String> backgroundImages = ["assets/images/hairdressingBg.jpg","assets/images/clubBg.jpg","assets/images/restaurantBg.jpg"];
  int randomBackground ;
  @override
  void initState() {

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
                Padding(
                  padding: EdgeInsets.fromLTRB(WIDHT * 0.200,HEIGHT * 0.126,
                      WIDHT * 0.200, 0),
                  child: Container(
                      child: Image.asset("assets/images/logo.png",
                          fit: BoxFit.cover)),
                ),
                emailTextField(context),
                passWordTextField(),
                error.length == 0 ? Container() : TextError(error),
                TextForgetPassword(context),
                MyButton(() => logIn(), LargeText("Entrar"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
                TextRegister(context),
              ],
            ),
          ),
        ));
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

  Widget emailTextField(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.101, HEIGHT * 0.05, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Correo Electronico',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget passWordTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: WIDHT * 0.003),
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
          ),
        ));
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
    loginCode.iniciarSesion(emailController.text.toString(),
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
