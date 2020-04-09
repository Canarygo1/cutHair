import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/availability.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

import '../../global_methods.dart';

class CalendarEmployee extends StatefulWidget {
  String nombre;
  CalendarEmployee(this.nombre);

  @override
  _CalendarEmployeeState createState() => _CalendarEmployeeState(nombre);
}

class _CalendarEmployeeState extends State<CalendarEmployee>{
  String nombre;

  _CalendarEmployeeState(this.nombre);

  RemoteRepository _remoteRepository;
  DateTime _currentDate = new DateTime.now();
  DateTime _currentDate2;
  DateTime date = new DateTime.now();
  List<Availability> availabilities;

  Widget goBack(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 350.0, 0.0),
        child: GestureDetector(
          onTap: () {
            globalMethods().popPage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigate_before,
                color: Colors.white,
                size: 35.0,
              ),
            ],
          ),
        ));
  }

  Widget calendar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.57,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() {
            _currentDate2 = date;
            this.date = date;
          });
        },
        weekendTextStyle: TextStyle(
          color: Colors.white,
        ),
        firstDayOfWeek: 1,
        locale: "es",
        headerTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
        ),
        showHeaderButton: false,
        showOnlyCurrentMonthDate: false,
        weekFormat: false,
        height: 400.0,
        selectedDateTime: _currentDate2,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        selectedDayButtonColor: Colors.red,
        todayButtonColor: Colors.green,
        daysTextStyle: TextStyle(
          color: Colors.white,
        ),
        prevDaysTextStyle: TextStyle(
          color: Colors.transparent,
        ),
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          if (day == _currentDate2 && day.isAfter(_currentDate)) {
            date = day;
            return null;
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget divider() {
    return Container(
      child: Row(children: [
        Expanded(
          child: Divider(
            thickness: 2.0,
            endIndent: 0.0,
            color: Colors.black,
          ),
        ),
      ]),
    );
  }

  Widget simpleText2() {
    return Container(
      child: Text(
        "Horarios añadidos",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget simpleText() {
    return Container(
      child: Text(
        "Horarios asignados",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget schedule() => Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.90,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: availabilities.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    date.day.toString() +
                        '-' +
                        date.month.toString() +
                        '-' +
                        date.year.toString(),
                  ),
                  subtitle: Text('Horario: ' + availabilities[index].disponibilidad),
                ),
              );
            }),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            goBack(context),
            calendar(),
            simpleText(),
            schedule(),
            divider(),
            simpleText2(),
          ],
        ),
      ),
    );
  }
}
