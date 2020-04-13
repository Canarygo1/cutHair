import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/availability.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarEmployee extends StatefulWidget {
  String nombre;

  CalendarEmployee(this.nombre);

  @override
  _CalendarEmployeeState createState() => _CalendarEmployeeState(nombre);
}

class _CalendarEmployeeState extends State<CalendarEmployee> {
  String nombre;

  _CalendarEmployeeState(this.nombre);

  DateTime _currentDate = DateTime.now();
  RemoteRepository _remoteRepository;
  DateTime _currentDate2;
  DateTime date = new DateTime.now();
  List<Availability> availabilities = [];

  Widget calendar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.57,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() {
            if (date.isAfter(_currentDate) ||
                (date.year == _currentDate.year &&
                    date.month == _currentDate.month &&
                    date.day == _currentDate.day)) {
              _currentDate2 = date;
              this.date = date;
            }
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
        showOnlyCurrentMonthDate: true,
        weekFormat: false,
        height: 400.0,
        selectedDateTime: _currentDate2,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        selectedDayButtonColor: Color.fromRGBO(230, 73, 90, 1),
        todayButtonColor: Colors.green,
        daysTextStyle: TextStyle(
          color: Colors.white,
        ),
        prevDaysTextStyle: TextStyle(
          color: Colors.transparent,
        ),
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
                  subtitle:
                      Text('Horario: ' + availabilities[index].disponibilidad),
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
            GoBack(context, "Volver"),
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
