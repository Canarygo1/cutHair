import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/my_textField.dart';
import 'package:cuthair/ui/Components/textTypes/text_error.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class checkSMSCode extends StatefulWidget {
  Map data;
  String password;
  String verificationId;

  checkSMSCode(this.data, this.password, this.verificationId);

  @override
  _checkSMSCodeState createState() => _checkSMSCodeState(this.data, this.password, this.verificationId);
}

class _checkSMSCodeState extends State<checkSMSCode> {
  Map data;
  String password;
  String verificationId;

  _checkSMSCodeState(this.data, this.password, this.verificationId);

  String phoneNo;
  String smsOTP;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double HEIGHT;
  double WIDHT;
  String error = "";

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
    ConnectionChecked.checkInternetConnectivity(context);
    data.putIfAbsent("Teléfono", () => phoneController.text);
    data.putIfAbsent("Penalización", () => false);
    try {
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
            child: Column(
              children: <Widget>[
                textFieldWidget(
                    codeController, TextInputType.phone, "Introduce el código",
                    topPadding: HEIGHT * 0.027),
                MyButton(() => signIn(codeController.text),
                    LargeText("Confirmar código"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
                error.length == 0 ? Container() : TextError(error),
              ],
            ),
          ),
        ));
  }
}
