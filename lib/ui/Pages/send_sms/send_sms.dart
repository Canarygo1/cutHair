
import 'package:cuthair/ui/Components/goback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';

class sendSMS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Authentication',
      routes: <String, WidgetBuilder>{
        '/loginpage': (BuildContext context) => MyApp(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyAppPage(title: 'Phone Authentication'),
    );
  }
}

class MyAppPage extends StatefulWidget {
  MyAppPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppPageState createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  String phoneNo ="+34671606191";
  String smsOTP = "123456";
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
    };
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneController.text,
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });

  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: "123456",
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)) as FirebaseUser;
      final FirebaseUser currentUser = await _auth.currentUser();

      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
    } catch (e) {
      handleError(e);
    }
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
            _auth.currentUser().then((user) {
              if (user != null) {
                Navigator.of(context).pop();
              } else {
                signIn();
              }
            });
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

