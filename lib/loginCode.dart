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
   try{
     user = (await auth.signInWithEmailAndPassword(
         email: email, password: password)).user;
   }catch(e){
     print(e.toString());
   }finally{
     if(user != null){
       print('adios');
       pushPage(context, register());
     }else{
       print('Hola');
     }
   }
 }
}