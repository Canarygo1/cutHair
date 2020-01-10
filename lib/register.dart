import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class register extends StatelessWidget {

  Widget nombreTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(40.0, 130.0, 35.0, 20.0),
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

  Widget buttonRegister(){
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            nombreTextField(),
            apellidosTextField(),
            correoTextField(),
            passWordTextField(),
            repeatPassWordTextField(),
            numeroTelefono(),
            buttonRegister(),
          ],
        ),
      ),
    );
  }
}