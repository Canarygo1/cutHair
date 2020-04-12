import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/Api/http_api_remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/choose_date/choose_date_presenter.dart';
import 'package:cuthair/ui/confirm/confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:http/http.dart';
import '../../global_methods.dart';
import '../home/home.dart';
import '../login/login.dart';

class chooseDateScreen extends StatefulWidget {
  Appointment appointment = Appointment();

  chooseDateScreen(this.appointment);

  @override
  _chooseDateScreenState createState() => _chooseDateScreenState(appointment);
}

class _chooseDateScreenState extends State<chooseDateScreen>
    implements ChooseDateView {
  Appointment appointment;

  _chooseDateScreenState(this.appointment);

  DateTime _currentDate = new DateTime.now();
  DateTime _currentDate2;
  DateTime _finalDate;
  ApiRemoteRepository _remoteRepository;
  ChooseDatePresenter _presenter;

  initState() {
    _remoteRepository = HttpApiRemoteRepository(Client());
    _presenter = ChooseDatePresenter(this, _remoteRepository);
  }

  List<String> availability = [
    "10:30",
    "11:00",
    "11:30",
    "15:00",
    "15:45",
    "17:00"
  ];

  Widget goBack(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10,),
        child: GestureDetector(
          onTap: () {
            globalMethods().popPage(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
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

  Widget textHour() {
    return Container(
      padding: EdgeInsets.fromLTRB(10.0, 0, 0.0, 0.0),
      child: Text(
        "Horas disponibles",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );
  }

  dayChanged(DateTime date) {
    _currentDate2 = date;
    //Todo:Para poder coger las horas bien hay que hacer dos cosas cambiar (- -> :) y (0 --> 00)
//    this._presenter.init(appointment.service.duracion.toString(), _currentDate2.toString(), appointment.employe.name);
  }

  Widget calendar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.57,
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => dayChanged(date));
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
        selectedDayButtonColor: Colors.transparent,
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
            _finalDate = day;
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: Icon(
                    Icons.content_cut,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget buttonsHour(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(availability.length, (index) {
          return Center(
            child: ButtonTheme(
              child: RaisedButton(
                child: Text(
                  availability.elementAt(index),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                onPressed: () {
                  if (_finalDate != null) {
                    int hour = int.parse(availability[index].substring(0, 2));
                    int minute = int.parse(availability[index].substring(3, 5));
                    _finalDate = _finalDate
                        .add(new Duration(hours: hour, minutes: minute));
                    appointment.checkIn = _finalDate;
                    appointment.checkOut = _finalDate.add(new Duration(
                        minutes: int.parse(appointment.service.duracion)));
                    globalMethods()
                        .pushPage(context, ConfirmScreen(appointment));
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
              buttonColor: Color.fromRGBO(230, 73, 90, 1),
            ),
          );
        }),
      ),
    );
  }

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
            textHour(),
            buttonsHour(context),
          ],
        ),
      ),
    );
  }

  @override
  showAvailability(List<String> availability) {
    setState(() {
      this.availability = availability;
    });
  }
}
