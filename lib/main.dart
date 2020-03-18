import 'package:cuthair/ui/bottom_navigation/menu.dart';
import 'package:cuthair/ui/calendar_boss/calendar_boss.dart';
import 'package:cuthair/ui/calendar_employee/calendar_employee.dart';
import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser.dart';
import 'package:cuthair/ui/detail/detail_screen.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/ui/home_boss/home_boss.dart';
import 'package:cuthair/ui/login/login.dart';
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
      home: Home(),
    );
  }
}
