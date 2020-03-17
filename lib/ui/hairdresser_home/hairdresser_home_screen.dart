import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/calendar_employee/calendar_employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HairdreserHome extends StatefulWidget {
  @override
  _HairdreserHomeState createState() => _HairdreserHomeState();
}

class _HairdreserHomeState extends State<HairdreserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(300, 300, 300, 1)),
        child: ListView(
          children: <Widget>[
            topTitle('Bienvenido'),
            onClickImage(),
          ],
        ),
      ),
    );
  }

  Widget topTitle(String mensaje) {
    return Container(
        height: 90,
        padding: const EdgeInsets.fromLTRB(10, 30, 0, 0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 73, 90, 1),
        ),
        child: Text(
          mensaje,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,

          ),
        ));
  }

  Widget onClickImage() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              "Mis horarios",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          GestureDetector(
            onTap: () {
              globalMethods().pushPage(context, CalendarEmployee());
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
                            Text(
                              "Nombre",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18.0),
                            )
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
