import 'package:cuthair/ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../global_methods.dart';

class sendSMS extends StatefulWidget {
  @override
  _sendSMSState createState() => _sendSMSState();
}

class _sendSMSState extends State<sendSMS> {
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  TextEditingController codeController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            goBack(context),
            numeroTelefono(),
            botonEnviarCode(context),
            codigoTextField(),
            botonEnviarCode2(context),
          ],
        ),
      ),
    );
  }

  Widget codigoTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
      child: TextFormField(
        controller: _smsCodeController,
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

  Widget botonEnviarCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Enviar',
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

  Widget botonEnviarCode2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 20.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Enviar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          //onPressed: () => _signInWithPhoneNumber(codeController.text.toString()),
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
        child: GestureDetector(
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

  Widget numeroTelefono() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
        controller: _phoneNumberController,
        decoration: InputDecoration(
          hintText: 'Número de teléfono',
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

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await auth.verifyPhoneNumber(
          phoneNumber: "+15555215554",
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      print(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: Text('Done'),
                onPressed: () {
                  auth.currentUser().then((user) {
                    signIn();
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      await auth.signInWithCredential(credential);
      FirebaseUser user = await auth.currentUser();
      print(user.uid);
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }
}
