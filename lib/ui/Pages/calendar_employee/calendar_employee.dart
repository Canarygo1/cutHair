import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/availability.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/schedules_screen.dart';
import 'package:cuthair/ui/Pages/calendar_boss/calendar_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class CalendarEmployee extends StatefulWidget {
  String name;
  String hairdresingUid;
  CalendarEmployee(this.name, this.hairdresingUid);

  @override
  _CalendarEmployeeState createState() => _CalendarEmployeeState(this.name, this.hairdresingUid);
}

class _CalendarEmployeeState extends State<CalendarEmployee> implements CalendarView{
  String name;
  String hairdresingUid;
  CalendarPresenter calendarPresenter;
  _CalendarEmployeeState(this.name, this.hairdresingUid);
  List<Schedule> days = [];
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
              calendarPresenter.init(date.toString());
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

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    Employe employe = Employe(name);
    calendarPresenter = CalendarPresenter(
        this, employe, this.hairdresingUid, _remoteRepository);
    super.initState();
  }

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
            LargeText("Horarios asignados"),
            ScheduleScreen(this.days, this.name, this.hairdresingUid),
          ],
        ),
      ),
    );
  }

  @override
  insertSchedule() {
    return null;
  }

  @override
  updateList(Schedule schedule) {
    setState(() {
      days.clear();
      if(schedule != null) this.days.add(schedule);
    });
  }
}
