import 'package:cuthair/ui/Components/textTypes/text_error.dart';
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

  @override
  void initState() {
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
                image: ExactAssetImage('assets/images/Login_6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: <Widget>[
                emailTextField(context),
                passWordTextField(),
                error.length == 0 ? Container() : TextError(error),
                TextForgetPassword(context),
                MyButton(() => logIn(), LargeText("Entrar")),
              ],
            ),
          ),
        ));
  }

  Widget emailTextField(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, HEIGHT * 0.176, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Correo Electronico',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: WIDHT * 0.003),
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget passWordTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: WIDHT * 0.003),
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          obscureText: true,
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }

  Widget TextForgetPassword(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: HEIGHT * 0.027, right: WIDHT * 0.10),
            child: GestureDetector(
              onTap: () {
                GlobalMethods().pushPage(context, resetPassword());
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
