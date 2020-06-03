import 'package:cuthair/TestStripe/pages/existing-cards.dart';
import 'package:cuthair/TestStripe/pages/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/TestStripe/pages/home',
      routes: {
        '/TestStripe/pages/home': (context) => HomePage(),
        '/TestStripe/pages/existing-cards': (context) => ExistingCardsPage()
      },
    );
  }
}