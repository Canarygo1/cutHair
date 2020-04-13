import 'dart:collection';

import 'package:cuthair/ui/login/login.dart';
import 'package:cuthair/ui/register/register_presenter.dart';
import 'package:cuthair/ui/send_sms/send_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import '../../global_methods.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  TextEditingController nombre = TextEditingController();
  TextEditingController apellidos = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password2 = TextEditingController();
  GlobalKey<FormState> keyForm = new GlobalKey();
  bool checkIn = false;

  Widget nombreTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 50.0, 35.0, 20.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: nombre,
        validator: registerCode().validateNameAndSurname,
        decoration: InputDecoration(
          hintText: 'Nombre',
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
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
    );
  }

  Widget apellidosTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: apellidos,
        validator: registerCode().validateNameAndSurname,
        decoration: InputDecoration(
          hintText: 'Apellidos',
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
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
    );
  }

  Widget correoTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: email,
        validator: registerCode().checkEmail,
        decoration: InputDecoration(
          hintText: 'Correo Electronico',
          enabledBorder: const UnderlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
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
    );
  }

  Widget passWordTextField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: TextFormField(
          controller: password,
          enableInteractiveSelection: false,
          validator: registerCode().checkSecurityPassword,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
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

  Widget repeatPassWordTextField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: TextFormField(
          controller: password2,
          enableInteractiveSelection: false,
          validator: registerCode().checkSamePassword,
          decoration: InputDecoration(
            hintText: 'Repetir contraseña',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
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

  Widget buttonRegister(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 30.0, 35.0, 20.0),
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
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }

  Widget goBack(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(10.0, 20.0, 230.0, 0.0),
        child: new GestureDetector(
          onTap: () {
            globalMethods().popPage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigate_before,
                color: Color.fromRGBO(230, 73, 90, 1),
                size: 35.0,
              ),
              Expanded(
                child: Text(
                  'Volver al login',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(230, 73, 90, 1),
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        body: new GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Form(
        key: keyForm,
        child: Container(
            color: Color.fromRGBO(300, 300, 300, 1),
            child: ListView(
              children: <Widget>[
                goBack(context),
                nombreTextField(),
                apellidosTextField(),
                correoTextField(),
                passWordTextField(),
                repeatPassWordTextField(),
                buttonRegister(context),
              ],
            )),
      ),
    ));
  }

  Map<String, Object> getData() {
    Map data = Map<String, Object>();
    data.putIfAbsent("Apellidos", () => apellidos.text.toString());
    data.putIfAbsent("Email", () => email.text.toString());
    data.putIfAbsent("Nombre", () => nombre.text.toString());
    data.putIfAbsent("Permisos", () => 3);
    return data;
  }

  checkEmail() async {
    checkIn = await registerCode().CheckUserExist(email.text, password.text);
    if (registerCode().checkCampos(context, keyForm) && checkIn) {
      globalMethods().pushPage(
          context, sendSMS(getData(), password.text.toString()));
    } else {
      Toast.show(
        "El email introducido ya existe",
        context,
        gravity: Toast.BOTTOM,
        textColor: Colors.black,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
      );
    }
  }
}
