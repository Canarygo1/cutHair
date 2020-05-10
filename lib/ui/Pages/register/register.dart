import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:cuthair/ui/Pages/send_sms/send_sms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Form(
            key: keyForm,
            child: Container(
                color: Color.fromRGBO(300, 300, 300, 1),
                child: ListView(
                  children: <Widget>[
                    GoBack(context, "Volver"),
                    nombreTextField(),
                    apellidosTextField(),
                    correoTextField(),
                    passWordTextField(),
                    repeatPassWordTextField(),
                    error.length == 0 ? Container() : textError(),
                    MyButton(() => checkEmail(), LargeText("Entrar"), color: Color.fromRGBO(230, 73, 90, 1))
                  ],
                )),
          ),
        ));
  }

  Widget nombreTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, HEIGHT * 0.067, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: name,
        validator: registerCode.validateNameAndSurname,
        decoration: InputDecoration(
          hintText: 'Nombre',
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
    );
  }

  Widget apellidosTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: surname,
        validator: registerCode.validateNameAndSurname,
        decoration: InputDecoration(
          hintText: 'Apellidos',
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
    );
  }

  Widget correoTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        enableInteractiveSelection: false,
        controller: email,
        validator: registerCode.checkEmail,
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
    );
  }

  Widget passWordTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          controller: password,
          enableInteractiveSelection: false,
          validator: registerCode.checkSecurityPassword,
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

  Widget repeatPassWordTextField() {
    return Padding(
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: TextFormField(
          controller: password2,
          enableInteractiveSelection: false,
          validator: registerCode.checkSamePassword,
          decoration: InputDecoration(
            hintText: 'Repetir contraseña',
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

  Widget buttonRegister(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
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
        padding: EdgeInsets.fromLTRB(WIDHT * 0.101, 0.0, WIDHT * 0.089, HEIGHT * 0.027),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: HEIGHT * 0.005),
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
    var tokkens = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email: email.text);
    if (registerCode.checkCampos(context, keyForm)) {
      if(tokkens.length == 0){
        setState(() {
          error = "";
        });
        GlobalMethods().pushPage(
            context, SendSMS(getData(), password.text));
      }else{
        setState(() {
          error = "El email introducido ya existe";
        });
      }
    } else {
      error = "Rellene los campos de forma correcta";
    }
  }
}
