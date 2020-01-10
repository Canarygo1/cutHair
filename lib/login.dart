import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  Widget TextForgetPassword(){
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: GestureDetector(
        onTap: (){

        },
        child: Text(
          '¿Has olvidado tu contraseña?',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Color.fromRGBO(0, 144, 255, 1),
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            decorationColor: Color.fromRGBO(0, 144, 255, 1),
          ),
        ),
      )
    );
  }

  Widget buttonLoginIn(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: RaisedButton(
        child: Text(
          'Entrar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: (){

        },
      ),
    );
  }

  Widget TextRegister(){
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: GestureDetector(
          onTap: (){

          },
          child: Text(
            'Registrarse',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color.fromRGBO(0, 144, 255, 1),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Color.fromRGBO(0, 144, 255, 1),
            ),
          ),
        )
    );
  }

  Widget lineDivisor(){
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        children: [

          Expanded(child: Divider(height: 1)),
          Text(
              ' 0 '
          ),
          Expanded(child: Divider(height: 1)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            buttonLoginIn(),
            TextRegister(),
            lineDivisor(),

          ],
        ),
      ),
    );
  }
}
