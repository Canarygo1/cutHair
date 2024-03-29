import 'package:components/components.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class checkSMSCode extends StatefulWidget {
  Map data;
  String password;
  String verificationId;

  checkSMSCode(this.data, this.password, this.verificationId);

  @override
  _checkSMSCodeState createState() =>
      _checkSMSCodeState(this.data, this.password, this.verificationId);
}

class _checkSMSCodeState extends State<checkSMSCode> {
  Map data;
  String password;
  String verificationId;

  _checkSMSCodeState(this.data, this.password, this.verificationId);

  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  double height;
  double width;
  String error = "";

  Future<void> signIn(String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      RegisterCode().registerAuth(data["Email"], password, context, data);
    } catch (e) {
      setState(() {
        error = 'Ha ocurrido un error lo sentimos. Inténtelo más tarde';
      });
    }
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          this.error = 'El código introducido es incorrecto';
        });
        Navigator.of(context).pop();
        break;
      default:
        setState(() {
          this.error = error.message;
        });
        break;
    }
  }

  Widget textFieldWidget(controller, textType, hintText,
      {obscureText = false, topPadding = 0.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          width * 0.101, topPadding, width * 0.089, height * 0.027),
      child: Components.textFieldPredefine(
        controller,
        textType,
        InputDecoration(
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
        TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
        obscureText: obscureText,
      ),
    );
  }

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
                textFieldWidget(
                    codeController, TextInputType.phone, "Introduce el código",
                    topPadding: height * 0.027),
                Components.smallButton(() => signIn(codeController.text),
                    Components.largeText("Confirmar código"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
                error.length == 0 ? Container() : Components.errorText(error),
              ],
            ),
          ),
        ));
  }
}
