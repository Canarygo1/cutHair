import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'register.dart';

class loginCode{

  final FirebaseAuth auth = FirebaseAuth.instance;

 void pushPage(BuildContext context, Widget page){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
 }

 void iniciarSesion(String email, String password, BuildContext context) async{
   FirebaseUser user;
   user = (await auth.signInWithEmailAndPassword(
       email: email, password: password)).user;
   if(user != null){
     pushPage(context, register());
   }else{
   }
 }
}