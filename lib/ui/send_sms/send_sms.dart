import 'package:cuthair/ui/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../global_methods.dart';

class sendSMS extends StatelessWidget {
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
            telefonoTextField(),
            botonEnviarCode(context),
          ],
        ),
      ),
    );
  }

  _verifyPhoneNumber(BuildContext context) async {
    String phoneNumber = "+1 5555215554";
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 20),
        verificationCompleted: (authCredential) =>
            _verificationComplete(context),
        verificationFailed: (authException) =>
            _verificationFailed(authException, context),
        codeAutoRetrievalTimeout: (verificationId) =>
            _codeAutoRetrievalTimeout(verificationId),
        codeSent: (verificationId, [code]) =>
            _smsCodeSent(verificationId, [code]));
  }

  _verificationComplete(BuildContext context) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: _smsVerificationCode,
        smsCode: codeController.text.toString(),
      );
      await auth.signInWithCredential(credential);
      FirebaseUser user = await auth.currentUser();
    } catch (e) {
      print("hola");
    }
  }

  String _smsVerificationCode;

  _smsCodeSent(String verificationId, List<int> code) {
    _smsVerificationCode = verificationId;
    print(verificationId);
  }

  _verificationFailed(AuthException authException, BuildContext context) {
    final snackBar = SnackBar(
        content:
            Text("Exception!! message:" + authException.message.toString()));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    _smsVerificationCode = verificationId;
  }

  Widget codigoTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
      child: TextFormField(
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
          onPressed: () => _verifyPhoneNumber(context),
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
          onPressed: () => _verificationComplete(context),
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
            globalMethods().pushPage(context, login());
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

}
