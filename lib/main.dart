import 'package:cuthair/chooseHairDresser.dart';
import 'package:cuthair/homePage.dart';
import 'package:flutter/material.dart';
import 'chooseDate.dart';
import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: chooseDateScreen(),
    );
  }
}

