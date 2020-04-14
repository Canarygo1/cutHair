import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';
import '../register/register.dart';
import '../reset_password/reset_password.dart';
import 'login_presenter.dart';

class login extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget emailTextField(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: emailController,
          decoration: InputDecoration(
            hintText: 'Correo Electronico',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }

  Widget passWordTextField() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: TextFormField(
          enableInteractiveSelection: false,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            hintStyle: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
            ),
          ),
          obscureText: true,
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }

  Widget TextForgetPassword(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, right: MediaQuery.of(context).size.width * 0.10),
            child: GestureDetector(
              onTap: () {
                globalMethods().pushPage(context, resetPassword());
              },
              child: Text(
                '¿Has olvidado tu contraseña?',
                style: TextStyle(
                  color: Color.fromRGBO(0, 144, 255, 1),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromRGBO(0, 144, 255, 1),
                  fontSize: 16.0,
                ),
              ),
            )));
  }

  Widget buttonLoginIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: LargeText('Entrar'),
          onPressed: () {
            loginCode().iniciarSesion(emailController.text.toString(),
                passwordController.text.toString(), context);
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

  Widget TextRegister(BuildContext context) {
    return Align(
        alignment: Alignment.centerRight,
        child: Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, right: MediaQuery.of(context).size.width * 0.10),
            child: GestureDetector(
              onTap: () {
                globalMethods().pushPage(context, register());
              },
              child: Text(
                'Registrarse',
                style: TextStyle(
                  color: Color.fromRGBO(0, 144, 255, 1),
                  decoration: TextDecoration.underline,
                  decorationColor: Color.fromRGBO(0, 144, 255, 1),
                  fontSize: 16.0,
                ),
              ),
            )));
  }

  Widget lineDivisor() {
    return Container(
      padding: EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 2.0,
              endIndent: 10.0,
              color: Colors.black,
            ),
          ),
          Text(
            ' 0 ',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Divider(
              indent: 10.0,
              thickness: 2.0,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget facebookButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.facebook,
                color: Colors.white,
              ),
              Expanded(
                child: Text(
                  'Entrar con facebook',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              )
            ],
          ),
          onPressed: () {
            facebookLogin(context).then((user) {
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 50.0,
        buttonColor: Color.fromRGBO(59, 89, 152, 1),
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/Login_6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: <Widget>[
                emailTextField(context),
                passWordTextField(),
                TextForgetPassword(context),
                buttonLoginIn(context),
                TextRegister(context),
                lineDivisor(),
                facebookButton(context),
              ],
            ),
          ),
        ));
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FacebookLogin fbLogin = new FacebookLogin();

  Future<FirebaseUser> facebookLogin(BuildContext context) async {
    FirebaseUser currentUser;
    // fbLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    // if you remove above comment then facebook login will take username and pasword for login in Webview
    try {
      final FacebookLoginResult facebookLoginResult =
          await fbLogin.logIn(['email', 'public_profile']);
      if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
        FacebookAccessToken facebookAccessToken =
            facebookLoginResult.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final AuthResult authResult =
            await auth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);
        currentUser = await auth.currentUser();
        assert(user.uid == currentUser.uid);
        return currentUser;
      }
    } catch (e) {
      Toast.show(
        "Error al iniciar sesión con facebook",
        context,
        gravity: Toast.BOTTOM,
        textColor: Colors.black,
        duration: Toast.LENGTH_LONG,
        backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
      );
    }
    return currentUser;
  }
}
