import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import '../../../global_methods.dart';
import 'calendar_boss_presenter.dart';

class CalendarBoss extends StatefulWidget {
  Employe employe;

  CalendarBoss(this.employe);

  @override
  _CalendarBossState createState() => _CalendarBossState();
}

class _CalendarBossState extends State<CalendarBoss>
    implements CalendarBossView {
  CalendarBossPresenter _calendarBossPresenter;
  DateTime _currentDate2;
  EventList<Event> _markedDateMap = new EventList<Event>();
  List<DateTime> dates = List<DateTime>();
  List<Day> days = List<Day>();
  RangeValues values = RangeValues(7, 24);
  RangeLabels labels = RangeLabels('7:00', '24:00');

  Widget _presentIcon(String day) => Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: Color.fromRGBO(230, 73, 90, 1),
          borderRadius: BorderRadius.all(Radius.circular(90)),
        ),
        child: Icon(
          Icons.content_cut,
          color: Colors.black,
        ),
      );

  Widget calendar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.57,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate2 = date);
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
        markedDateShowIcon: true,
        markedDateMoreShowTotal: true,
        markedDateIconBorderColor: Colors.transparent,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        markedDatesMap: _markedDateMap,
        height: MediaQuery.of(context).size.height * 0.52,
        customGridViewPhysics: NeverScrollableScrollPhysics(),
        markedDateCustomTextStyle: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        todayTextStyle: TextStyle(
          color: Colors.white,
        ),
        selectedDayButtonColor: Colors.transparent,
        todayButtonColor: Color.fromRGBO(230, 73, 90, 1),
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
          if (day == _currentDate2 &&
              (day.isAfter(DateTime.now()) || isToday)) {
            _markedDateMap.getEvents(day).clear();
            _markedDateMap.add(
                day, new Event(date: day, icon: _presentIcon(day.toString())));
            if (!dates.contains(day)) {
              dates.add(day);
            }
            return Center(
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(230, 73, 90, 1),
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Icon(
                  Icons.content_cut,
                  color: Colors.black,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  Widget rangeSlider() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: RangeSlider(
        min: 7,
        max: 24,
        values: values,
        divisions: 17,
        labels: labels,
        onChanged: (value) {
          setState(() {
            values = value;
            labels = RangeLabels('${value.start.toInt().toString()}\:00',
                '${value.end.toInt().toString()}\:00');
          });
        },
      ),
    );
  }

  Widget buttonAddSchedule() {
    return Container(
      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
      child: ButtonTheme(
        child: RaisedButton(
          child: Text(
            'Añadir horario',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
          onPressed: () {
            setState(() {
              if (dates.length > 0) {
                for (int i = 0; i < dates.length; i++) {
                  Day day = Day(dates[i], labels.start.toString(), labels.end.toString());
                  days.add(day);
                }
                _calendarBossPresenter.init(days);
                _currentDate2 = null;
                days.clear();
                _markedDateMap.clear();
              }
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        height: 60.0,
        buttonColor: Color.fromRGBO(230, 73, 90, 1),
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

  Widget simpleText() {
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

  Widget schedules() => Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.90,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: days.length,
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
                    days.elementAt(index).dayId.day.toString() +
                        "-" +
                        days.elementAt(index).dayId.month.toString() +
                        "-" +
                        days.elementAt(index).dayId.year.toString(),
                  ),
                  subtitle: Text('Hora de entrada: ' +
                      days.elementAt(index).checkIn.toString() +
                      ' hora de salida: ' +
                      days.elementAt(index).checkOut.toString()),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _markedDateMap.removeAll(days.elementAt(index).dayId);
                        dates.remove(days.elementAt(index).dayId);
                        days.removeAt(index);
                      });
                    },
                    child: Container(
                      child: Icon(
                        Icons.restore_from_trash,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
      );

  @override
  void initState() {
    _calendarBossPresenter = CalendarBossPresenter(this, widget.employe);
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
            rangeSlider(),
            calendar(),
            buttonAddSchedule(),
            divider(),
            simpleText(),
            schedules(),
          ],
        ),
      ),
    );
  }
}
