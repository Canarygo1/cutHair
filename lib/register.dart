import 'package:cuthair/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'loginCode.dart';
import 'registerCode.dart';

class register extends StatelessWidget {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Widget nombreTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 100.0, 35.0, 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Nombre',
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

  Widget apellidosTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Apellidos',
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

  Widget correoTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
        controller: email,
        decoration: InputDecoration(
          hintText: 'Correo Electronico',
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

  Widget passWordTextField(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: TextFormField(
          controller: password,
          decoration: InputDecoration(
            hintText: 'Contraseña',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
          ),
        )
    );
  }

  Widget repeatPassWordTextField(){
    return Padding(
        padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Repetir contraseña',
            enabledBorder: const UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1.5),
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          obscureText: true,
          style: TextStyle(
            color: Colors.white,
          ),
        )
    );
  }

  Widget numeroTelefono(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: TextFormField(
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

  Widget buttonRegister(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 30.0, 35.0, 20.0),
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
            registerCode().register(email.text.toString(), password.text.toString(), context);
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

  Widget goBack(BuildContext context){
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 230.0, 0.0),
          child: GestureDetector(
            onTap: (){
              loginCode().pushPage(context, login());
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
          )
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            goBack(context),
            nombreTextField(),
            apellidosTextField(),
            correoTextField(),
            passWordTextField(),
            repeatPassWordTextField(),
            numeroTelefono(),
            buttonRegister(context),
          ],
        ),
      ),
    );
  }
}