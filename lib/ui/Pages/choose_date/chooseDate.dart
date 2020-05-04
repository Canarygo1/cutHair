import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/Api/http_api_remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Components/calendars.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'choose_date_presenter.dart';

class chooseDateScreen extends StatefulWidget {
  Appointment appointment = Appointment();

  chooseDateScreen(this.appointment);

  @override
  _chooseDateScreenState createState() => _chooseDateScreenState(appointment);
}

class _chooseDateScreenState extends State<chooseDateScreen>
    implements ChooseDateView {
  Appointment appointment;
  bool isConsulting = false;

  _chooseDateScreenState(this.appointment);

  DateTime _currentDate = new DateTime.now();
  DateTime _currentDate2;
  DateTime _finalDate;
  ApiRemoteRepository _remoteRepository;
  ChooseDatePresenter _presenter;
  Color amColorButton = Color.fromRGBO(230, 73, 90, 1);
  Color pmColorButton = Color.fromRGBO(230, 73, 90, 0.5);

  initState() {
    _remoteRepository = HttpApiRemoteRepository(Client());
    _presenter = ChooseDatePresenter(this, _remoteRepository);
  }

  List<String> availability = [];

  List<String> availablesHours = [];

  Widget buttonsDay() {
    return Container(
        child: Wrap(direction: Axis.horizontal, children: <Widget>[
      ButtonTheme(
        child: RaisedButton(
          child: LargeText("AM"),
          onPressed: () {
            availablesHours.clear();

            List<String> auxList = [];

            for (int i = 0; i < availability.length; i++) {
              if (int.parse(availability.elementAt(i).substring(0, 2)) < 14) {
                auxList.add(availability.elementAt(i));
              }
            }

            setState(() {
              availablesHours = auxList;
              amColorButton = Color.fromRGBO(230, 73, 90, 1);
              pmColorButton = Color.fromRGBO(230, 73, 90, 0.5);
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        buttonColor: amColorButton,
      ),
      ButtonTheme(
        child: RaisedButton(
          child: LargeText("PM"),
          onPressed: () {
            availablesHours.clear();
            List<String> auxList = [];

            for (int i = 0; i < availability.length; i++) {
              if (int.parse(availability.elementAt(i).substring(0, 2)) > 14) {
                auxList.add(availability.elementAt(i));
              }
            }

            setState(() {
              availablesHours = auxList;

              pmColorButton = Color.fromRGBO(230, 73, 90, 1);
              amColorButton = Color.fromRGBO(230, 73, 90, 0.5);
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
        ),
        buttonColor: pmColorButton,
      )
    ]));
  }

  Widget textHour() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 0.0, 0.0),
      child: LargeText("Horas disponibles"),
    );
  }

  dayChanged(DateTime date) {
    setState(() {
      this.isConsulting = true;
    });
    _currentDate2 = date;
    this._presenter.init(appointment.service.duration,
        _currentDate2.toString(), appointment.employe.name);
  }

  pressCalendar(DateTime date) {
    if (date.isAfter(DateTime.now()) ||
        (date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day)) {
      setState(() {
        this.isConsulting = true;
        this._currentDate2 = date;
        this._presenter.init(appointment.service.duration.toString(),
            _currentDate2.toString(), appointment.employe.name);
      });
    }
  }

  Widget buttonsHour(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.60,
      child: GridView.count(
        crossAxisCount: 4,
        children: List.generate(availablesHours.length, (index) {
          return Center(
            child: ButtonTheme(
              child: RaisedButton(
                child: LargeText(availablesHours.elementAt(index)),
                onPressed: () {
                  if (_finalDate != null) {
                    int hour =
                        int.parse(availablesHours[index].substring(0, 2));
                    int minute =
                        int.parse(availablesHours[index].substring(3, 5));
                    appointment.day = _finalDate;
                    _finalDate = _finalDate
                        .add(new Duration(hours: hour, minutes: minute));
                    appointment.checkIn = _finalDate;
                    appointment.checkOut = _finalDate.add(new Duration(
                        minutes: int.parse(appointment.service.duration)));
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
            GoBack(context, "Volver"),
            CalendarWidget(
                (DateTime date, List<Event> events) => pressCalendar(date),
              currentDate2: this._currentDate2
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0, 0.0, 0.0),
              child: LargeText("Horas disponibles"),
            ),
            timeSelector(),
          ],
        ),
      ),
    );
  }

  Widget timeSelector() {
    return isConsulting == true
        ? SpinKitWave(
            color: Color.fromRGBO(230, 73, 90, 1),
            type: SpinKitWaveType.start,
          )
        : availability.isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.width * 0.03),
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/sad.svg",
                      width: 90,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                        children: <Widget>[
                          MediumText("Lo sentimos, no hay horas disponibles."),
                          MediumText("Prueba con otro día."),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 17, vertical: 4),
                      height: MediaQuery.of(context).size.height * 0.07,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availability.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: ButtonTheme(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: RaisedButton(
                                    child: LargeText(
                                        availability.elementAt(index)),
                                    onPressed: () {
                                      if (_finalDate != null) {
                                        List hours =
                                            availability[index].split(":");
                                        int hour = int.parse(hours[0]);
                                        int minute = int.parse(hours[1]);
                                        appointment.day = _finalDate;
                                        _finalDate = _finalDate.add(
                                            new Duration(
                                                hours: hour, minutes: minute));
                                        appointment.checkIn = _finalDate;
                                        appointment.checkOut = _finalDate.add(
                                            new Duration(
                                                minutes: int.parse(appointment
                                                    .service.duration)));
                                        globalMethods().pushPage(context,
                                            ConfirmScreen(appointment));
                                      }
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                buttonColor: Color.fromRGBO(230, 73, 90, 1),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
  }

  @override
  showAvailability(List<String> availability) {
    if (mounted) {
      setState(() {
        this.isConsulting = false;
        this.availability = availability;
      });
    }
  }

  @override
  emptyAvailability() {
    if (mounted) {
      setState(() {
        this.isConsulting = false;
        this.availability = [];
      });
    }
  }
}
