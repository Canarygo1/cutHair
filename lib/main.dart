import 'dart:io';
import 'package:cuthair/charge_screen.dart';
import 'package:cuthair/ui/bottom_navigation/menu.dart';
import 'package:cuthair/ui/hairdresser_home/hairdresser_home_screen.dart';
import 'package:cuthair/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'data/local/db_sqlite.dart';
import 'model/user.dart';
import 'ui/detail/detail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        dividerColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: DetailScreen(),
    );
  }
}
