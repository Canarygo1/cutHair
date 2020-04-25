import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Pages/login/login.dart';
import 'package:cuthair/ui/Pages/register/register_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';

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

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      Timer(Duration(minutes: 1, seconds: 30), (){
        Toast.show(
          "Tiempo expirado",
          context,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
        );
        globalMethods().PushAndReplacement(context, login());
      });
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
    };

    final PhoneVerificationFailed verifyFailed = (AuthException e) {
      if(e.message == "ERROR_INVALID_VERIFICATION_CODE"){
        Toast.show(
          "El código introducido no es correcto",
          context,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
        );
      }else{
        Toast.show(
          "Lo sentimos ha ocurrido un error. Intentelo más tarde.",
          context,
          gravity: Toast.BOTTOM,
          textColor: Colors.black,
          duration: Toast.LENGTH_LONG,
          backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
        );
      }
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      timeout: const Duration(seconds: 5),
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
    data.putIfAbsent("Telefono", () => phoneController.text);
    registerCode().registerAuth(data["Email"], password, context, data);
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  Widget codigoTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
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

  Widget telefonoTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
      child: TextFormField(
        enableInteractiveSelection: false,
        keyboardType: TextInputType.phone,
        controller: phoneController,
        decoration: InputDecoration(
          hintText: 'Introduce Telefono',
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

  Widget botonEnviarCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Enviar código',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => verifyPhone(),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),

      ),
    );
  }

  Widget confirmarCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Confirmar codigo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          onPressed: () {
            signIn(codeController.text);
          },
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            color: Color.fromRGBO(300, 300, 300, 1),
            child: ListView(
              children: <Widget>[
                GoBack(context, "Volver"),
                telefonoTextField(),
                botonEnviarCode(context),
                codigoTextField(),
                confirmarCode(context)
              ],
            ),
          ),
        ));
  }
}