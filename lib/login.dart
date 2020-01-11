import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'loginCode.dart';
import 'register.dart';

class login extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget emailTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
      child: TextFormField(
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
    );
  }

  Widget passWordTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
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
      )
    );
  }

  Widget TextForgetPassword(){
    return Container(
      padding: EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: GestureDetector(
        onTap: (){

        },
        child: Text(
          '¿Has olvidado tu contraseña?',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color.fromRGBO(0, 144, 255, 1),
            decoration: TextDecoration.underline,
            decorationColor: Color.fromRGBO(0, 144, 255, 1),
            fontSize: 16.0,
          ),
        ),
      )
    );
  }

  Widget buttonLoginIn(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Entrar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          onPressed: (){
            print('eyyy');
            loginCode().iniciarSesion(emailController.text.toString(), passwordController.text.toString(), context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
      ),
    );
  }

  Widget TextRegister(BuildContext context){
    return Container(
        padding: EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: GestureDetector(
          onTap: (){
            loginCode().pushPage(context, register());
          },
          child: Text(
            'Registrarse',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.fromRGBO(0, 144, 255, 1),
              decoration: TextDecoration.underline,
              decorationColor: Color.fromRGBO(0, 144, 255, 1),
              fontSize: 16.0,
            ),
          ),
        )
    );
  }

  Widget lineDivisor(){
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

  Widget facebookButton(){
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
          onPressed: (){

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
      resizeToAvoidBottomInset : false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/Login_6.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: <Widget>[
            emailTextField(),
            passWordTextField(),
            TextForgetPassword(),
            buttonLoginIn(context),
            TextRegister(context),
            lineDivisor(),
            facebookButton(),
          ],
        ),
      ),
    );
  }
}
