import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser.dart';
import 'package:flutter/material.dart';

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
      home: chooseHairDresserScreen(),
    );
  }
}
