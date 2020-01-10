import 'package:flutter/material.dart';

class login extends StatelessWidget {

  Widget emailTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Correo Electronico',
        ),
      ),
    );
  }

  Widget passWordTextField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Contraseña',
        ),
        obscureText: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: ListView(
          children: <Widget>[
            emailTextField(),
            passWordTextField(),
          ],
        ),
      ),
    );
  }
}
