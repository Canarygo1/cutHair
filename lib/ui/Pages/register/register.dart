import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/textTypes/my_textField.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:cuthair/ui/Pages/send_sms/send_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'register_presenter.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey();
  double HEIGHT;
  double WIDHT;
  String error = "";
  RegisterCode registerCode = RegisterCode();

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 73, 90, 1),
          leading: GoBack(
            context,
            "",
            HEIGHT: HEIGHT * 0.013,
          ),
          title: LargeText("Volver"),
          titleSpacing: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: keyForm,
              child: Column(
                children: <Widget>[
                  textFieldWidget(name, TextInputType.text, "Nombre",
                      topPadding: HEIGHT * 0.067),
                  textFieldWidget(surname, TextInputType.text, "Apellidos"),
                  textFieldWidget(
                      email, TextInputType.emailAddress, "Correo electrónico"),
                  textFieldWidget(password, TextInputType.text, "Contraseña",
                      obscureText: true),
                  textFieldWidget(
                      password2, TextInputType.text, "Repetir contraseña",
                      obscureText: true),
                  error.length == 0 ? Container() : textError(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: WIDHT * 0.11, right: WIDHT * 0.089),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text:
                                  "Al continuar, aceptas nuestras Condiones de uso y confirmas que has leído nuestra",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 12)),
                          TextSpan(
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  launch(
                                      'https://pruebafirebase-44f30.web.app/');
                                },
                              text: " Política de Privacidad",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  MyButton(() => checkEmail(), LargeText("Continuar"),
                      color: Color.fromRGBO(230, 73, 90, 1)),
                ],
              ),
            ),
          ),
        ));
  }

  Widget textFieldWidget(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          WIDHT * 0.101, topPadding, WIDHT * 0.089, HEIGHT * 0.027),
      child: MyTextField(
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

  Widget buttonRegister(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Entrar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          onPressed: () {
            checkEmail();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }

  Widget textError() {
    return Container(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.005),
            child: Text(
              error,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
          ),
        ));
  }

  Map<String, Object> getData() {
    Map data = Map<String, Object>();
    data.putIfAbsent("Apellidos", () => surname.text.toString());
    data.putIfAbsent("Email", () => email.text.toString());
    data.putIfAbsent("Nombre", () => name.text.toString());
    data.putIfAbsent("Permisos", () => 3);
    return data;
  }

  checkEmail() async {
    var tokkens = await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(email: email.text);
    if (registerCode.checkCampos(context, keyForm)) {
      if (tokkens.length == 0) {
        setState(() {
          error = "";
        });
        GlobalMethods().pushPage(context, SendSMS(getData(), password.text));
      } else {
        setState(() {
          error = "El email introducido ya existe";
        });
      }
    } else {
      error = "Rellene los campos de forma correcta";
    }
  }
}
