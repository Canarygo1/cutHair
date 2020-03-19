import 'package:cuthair/ui/bottom_navigation/menu.dart';
import 'package:cuthair/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'data/local/db_sqlite.dart';
import 'model/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget widget;
  List<User> lista;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    play();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: widget,
    );
  }


  void play(){
    DBProvider.db.getUser();
    lista = DBProvider.listaNueva;
    if(lista.length > 0 ){
      print("hola");
      widget = Menu(lista[0].permission, lista[0]);
    }else if (lista.length == 0){
      print("adios");
      widget = login();
    }
  }
}
