import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:cuthair/ui/Pages/send_sms/send_sms.dart';
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
  double height;
  double width;
  String error = "";
  RegisterCode registerCode = RegisterCode();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(230, 73, 90, 1),
          leading: Components.goBack(
            context,
            "",
          ),
          title: Components.largeText("Volver"),
          titleSpacing: 0,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Form(
                  key: keyForm,
                  child: Column(
                    children: <Widget>[
                      textFormNameAndSurName(name, TextInputType.text, "Nombre",
                          topPadding: height * 0.067),
                      textFormNameAndSurName(surname, TextInputType.text, "Apellidos"),
                      textFormEmail(email, TextInputType.emailAddress,
                          "Correo electrónico"),
                      textFormPassword(
                          password, TextInputType.text, "Contraseña",
                          obscureText: true),
                      textFormRepeatPassword(
                          password2, TextInputType.text, "Repetir contraseña",
                          obscureText: true),
                      error.length == 0
                          ? Container()
                          : Components.errorText(error),
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.11, right: width * 0.089),
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
                    ],
                  ),
                ),
                Components.smallButton(
                    () => checkEmail(), Components.largeText("Continuar"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
              ],
            ),
          ),
        ));
  }

  Widget textFormNameAndSurName(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.101, topPadding, width * 0.089, height * 0.027),
      child: TextFormField(
        validator: (value) => registerCode.validateNameAndSurname(value),
        controller: controller,
        keyboardType: textType,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
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
        obscureText: obscureText,
      ),
    );
  }

  Widget textFormEmail(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.101, topPadding, width * 0.089, height * 0.027),
      child: TextFormField(
        validator: (value) => registerCode.checkEmail(value),
        controller: controller,
        keyboardType: textType,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
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
        obscureText: obscureText,
      ),
    );
  }

  Widget textFormPassword(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.101, topPadding, width * 0.089, height * 0.027),
      child: TextFormField(
        validator: (value) => registerCode.checkSecurityPassword(value),
        controller: controller,
        keyboardType: textType,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
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
        obscureText: obscureText,
      ),
    );
  }

  Widget textFormRepeatPassword(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.101, topPadding, width * 0.089, height * 0.027),
      child: TextFormField(
        validator: (value) => registerCode.checkSamePassword(value),
        controller: controller,
        keyboardType: textType,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: width * 0.003),
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
        obscureText: obscureText,
      ),
    );
  }


  Map<String, Object> getData() {
    Map data = Map<String, Object>();
    data.putIfAbsent("Apellidos", () => surname.text.toString());
    data.putIfAbsent("Email", () => email.text.toLowerCase());
    data.putIfAbsent("Nombre", () => name.text.toString());
    return data;
  }

  checkEmail() async {
    if (registerCode.checkCampos(context, keyForm)) {
      if (registerCode.checkCampos(context, keyForm)) {
        setState(() {
          error = "";
        });
        GlobalMethods().pushPage(context, SendSMS(getData(), password.text));
      }
    } else {
      error = "Rellene los campos de forma correcta";
    }
  }
}
