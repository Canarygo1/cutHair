import 'package:cuthair/ui/Components/button.dart';
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
import '../../../data/remote/check_connection.dart';

class SendSMS extends StatefulWidget {
  Map data;
  String password;
  SendSMS(this.data, this.password);

  @override
  _SendSMSState createState() => _SendSMSState(this.data, this.password);
}

class _SendSMSState extends State<SendSMS> {
  Map data;
  String password;
  _SendSMSState(this.data, this.password);
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  double HEIGHT;
  double WIDHT;
  String error = "";

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      Timer(Duration(minutes: 1, seconds: 30), (){
        setState(() {
          error = 'Tiempo expirado';
        });
        GlobalMethods().pushAndReplacement(context, Login());
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
    };

    final PhoneVerificationFailed verifyFailed = (AuthException e) {
      if(e.message == "ERROR_INVALID_VERIFICATION_CODE"){
        setState(() {
          error = 'El código es incorrecto';
        });
      }else{
        setState(() {
          error = 'Lo sentimos ha ocurrido un error. Intentalo más tarde.';
        });
      }
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      timeout: Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
    ConnectionChecked.checkInternetConnectivity(context);
    data.putIfAbsent("Telefono", () => phoneController.text);
    try {
      RegisterCode().registerAuth(data["Email"], password, context, data);
    }catch(e){
      setState(() {
        error = 'Ha ocurrido un error lo sentimos. Intententelo mas tarde';
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

  Widget codigoTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, HEIGHT * 0.027, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        toolbarOptions: ToolbarOptions(
          copy: false,
          cut: false,
          selectAll: false,
          paste: true,
        ),
        keyboardType: TextInputType.phone,
        controller: codeController,
        decoration: InputDecoration(
          hintText: 'Codigo',
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

  Widget telefonoTextField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(WIDHT * 0.101, HEIGHT * 0.176, WIDHT * 0.089, HEIGHT * 0.027),
      child: TextFormField(
        enableInteractiveSelection: false,
        keyboardType: TextInputType.phone,
        controller: phoneController,
        decoration: InputDecoration(
          hintText: 'Introduce Telefono',
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
            color: Color.fromRGBO(300, 300, 300, 1),
            child: ListView(
              children: <Widget>[
                GoBack(context, "Volver"),
                telefonoTextField(),
                MyButton(() => verifyPhone(), LargeText("Enviar código"), color: Color.fromRGBO(230, 73, 90, 1)),
                codigoTextField(),
                MyButton(() => signIn(codeController.text),LargeText("Confirmar código"), color: Color.fromRGBO(230, 73, 90, 1)),
                error.length == 0 ? Container() : TextError(error),
              ],
            ),
          ),
        ));
  }
}