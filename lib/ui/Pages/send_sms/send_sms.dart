import 'package:components/components.dart';
import 'package:cuthair/ui/Pages/send_sms/check_smd_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:cuthair/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  TextEditingController phoneController = TextEditingController();
  double HEIGHT;
  double WIDHT;
  bool sending = true;
  String error = "";

  Future<void> verifyPhone() async {
    setState(() {
      if (mounted) {
        sending = true;
      }
    });
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      this.widget.data.putIfAbsent("Teléfono", () => "+34" + phoneController.text);
      setState(() {
        if (mounted) {
          sending = false;
        }
      });
      GlobalMethods().pushPage(context,
          checkSMSCode(this.widget.data, this.widget.password, verificationId));
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      GlobalMethods().pushPage(context,
          checkSMSCode(this.widget.data, this.widget.password, verificationId));
    };

    final PhoneVerificationFailed verifyFailed = (AuthException e) {
      if (e.message == "ERROR_INVALID_VERIFICATION_CODE") {
        setState(() {
          error = 'El código es incorrecto';
        });
      } else {
        setState(() {
          print(e.message);
          error = 'Lo sentimos ha ocurrido un error. Inténtalo más tarde.';
        });
      }
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+34" + phoneController.text,
      timeout: Duration(seconds: 120),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
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
      child: Components.textFieldPredefine(
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
          leading: Components.goBack(
            context,
            "",
          ),
          title: Components.largeText("Volver"),
          titleSpacing: 0,
        ),
        body: sending ? GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                textFieldWidget(phoneController, TextInputType.phone,
                    'Introduce el teléfono',
                    topPadding: HEIGHT * 0.176),
                Components.smallButton(() => verifyPhone(), Components.largeText("Enviar código"),
                    color: Color.fromRGBO(230, 73, 90, 1)),
                error.length == 0 ? Container() : Components.errorText(error),
              ],
            ),
          ),
        ) : Padding(
          padding: EdgeInsets.only(top: 50),
          child: SpinKitWave(
            color: Color.fromRGBO(230, 73, 90, 1),
            type: SpinKitWaveType.start,
          ),
        ));
  }
}
