import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'calendar_boss_presenter.dart';

class CalendarBoss extends StatefulWidget {
  Employe employe;
  String hairDressingUid;

  CalendarBoss(this.employe, this.hairDressingUid);

  @override
  _CalendarBossState createState() => _CalendarBossState();
}

class _CalendarBossState extends State<CalendarBoss>
    implements CalendarBossView {
  CalendarBossPresenter _calendarBossPresenter;
  DateTime _currentDate2;
  EventList<Event> _markedDateMap = new EventList<Event>();
  List<DateTime> dates = [];
  List<Schedule> days = [];
  RangeValues values = RangeValues(7, 24);
  RangeLabels labels = RangeLabels('7:00', '24:00');
  RemoteRepository _remoteRepository;
  List<Day> newdays = List<Day>();

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
          this.setState((){
            if(dates.contains(date)){
              dates.remove(date);
              _markedDateMap.getEvents(date).clear();
              days.removeWhere( (item) => item.uid == date);
              _currentDate2 = null;
            }else{
              _currentDate2 = date;
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
              _calendarBossPresenter.init(day.toString());
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
          child: LargeText(
            'Añadir horario',
          ),
          onPressed: () {
            setState(() {
              if (dates.length > 0) {
                newdays.clear();
                for (int i = 0; i < dates.length; i++) {
                  Day day = Day(
                      dates[i], labels.start.toString(), labels.end.toString());
                  newdays.add(day);
                }

                insertSchedule();
                dates.clear();
                days.clear();
                _currentDate2 = null;
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

  Widget schedules() => Container(
        padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.90,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: days.length,
            itemBuilder: (context, index) {
              return Container(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: days[index].ranges.length,
                    itemBuilder: (context, indexranges) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                        ),
                        child: ListTile(
                          dense: true,
                          title: Text(
                            days[index].uid.day.toString() +
                                "-" +
                                days[index].uid.month.toString() +
                                "-" +
                                days[index].uid.year.toString(),
                          ),
                          subtitle: Text('Hora de entrada: ' +
                              days[index].ranges[indexranges]["Entrada"] +
                              ":00" +
                              ' hora de salida: ' +
                              days[index].ranges[indexranges]["Salida"] +
                              ":00"),
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {

                                removeSchedule(days[index].uid, this.widget.employe, this.widget.hairDressingUid, days[index].ranges[indexranges]);
                                /*_markedDateMap.removeAll(days[index].uid);
                                dates.remove(days[index].uid);*/
                                days[index].ranges.removeAt(indexranges);
                                //days.removeAt(index);

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
            }),
      );

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _calendarBossPresenter = CalendarBossPresenter(
        this, widget.employe, this.widget.hairDressingUid, _remoteRepository);
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
            LargeText("Horarios añadidos"),
            schedules(),
          ],
        ),
      ),
    );
  }

  @override
  insertSchedule() {
    _calendarBossPresenter.insertSchedule(newdays);
  }

  @override
  updateList(Schedule schedule) {
    setState(() {
      if(schedule != null) this.days.add(schedule);
    });
  }

  @override
  removeSchedule(DateTime day, Employe employe, String hairDressingUid, Map ranges) {
    _calendarBossPresenter.removeSchedule(day, employe, hairDressingUid, ranges);
    return null;
  }
}
