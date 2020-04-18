import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Pages/calendar_employee/calendar_employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeHome extends StatefulWidget {
  User user;

  EmployeeHome(this.user);

  @override
  _EmployeeHomeState createState() => _EmployeeHomeState(user);
}

class _EmployeeHomeState extends State<EmployeeHome>{

  globalMethods global = globalMethods();
  User user;

  _EmployeeHomeState(this.user);

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(300, 300, 300, 1)),
            child: ListView(
              children: <Widget>[
                Appbar('Bienvenido'),
                onClickImage(),
              ],
            ),
          ),
        );
  }

  Widget onClickImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            child: LargeText("Mis horarios"),
          ),
          GestureDetector(
            onTap: () {
              globalMethods().pushPage(
                  context, CalendarEmployee(user.name));
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
              width: MediaQuery.of(context).size.width * 0.39,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Center(
                          child: Container(
                            child: AspectRatio(
                              aspectRatio: 4 / 4,
                              child: Image(
                                fit: BoxFit.fill,
                                height: 10,
                                width: 10,
                                image: ExactAssetImage(
                                    "assets/images/privilegeLogo.jpg"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(7, 10, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            LargeText(user.name),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}