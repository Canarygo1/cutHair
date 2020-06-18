import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/Api/http_api_remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'choose_date_presenter.dart';

class ChooseDateRestaurantScreen extends StatefulWidget {
  Appointment appointment = Appointment();

  ChooseDateRestaurantScreen(this.appointment);

  @override
  _ChooseDateScreenState createState() =>
      _ChooseDateScreenState(this.appointment);
}

class _ChooseDateScreenState extends State<ChooseDateRestaurantScreen>
    implements ChooseDateView {
  Appointment appointment;
  bool isConsulting = true;
  DateTime currentDate2 = DateTime.now();

  _ChooseDateScreenState(this.appointment);

  double HEIGHT;
  double WIDHT;
  List<String> availability = [];
  DateTime _finalDateCheckIn = DateTime.now();
  ApiRemoteRepository _remoteRepository;
  ChooseDatePresenter _presenter;

  initState() {
    _remoteRepository = HttpApiRemoteRepository(Client());
    _presenter = ChooseDatePresenter(this, _remoteRepository);
    DateTime initial = currentDate2.subtract(Duration(
        hours: currentDate2.hour,
        minutes: currentDate2.minute,
        seconds: currentDate2.second,
        microseconds: currentDate2.microsecond,
        milliseconds: currentDate2.millisecond));
    this._presenter.init(appointment, initial.toString());

    showAvailability(availability);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        leading: Components.goBack(
          context,
          "",
        ),
        title: Components.largeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Calendar(
                (DateTime date, List<Event> events) => pressCalendar(date),
                currentDate2: currentDate2),
            Padding(
              padding: EdgeInsets.only(left: WIDHT * 0.025),
              child: Components.largeText("Horas disponibles"),
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
                padding:
                    EdgeInsets.only(top: HEIGHT * 0.03, left: WIDHT * 0.03),
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/sad.svg",
                      width: WIDHT * 0.229,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: HEIGHT * 0.03),
                      child: Column(
                        children: <Widget>[
                          Components.mediumText("Lo sentimos, no hay horas disponibles."),
                          Components.mediumText("Prueba con otro día."),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.027),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: WIDHT * 0.043, vertical: HEIGHT * 0.005),
                      height: HEIGHT * 0.08,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availability.length,
                          itemBuilder: (context, index) {
                            return Center(
                              child: Components.smallButton(
                                () => pressTimeSelection(index),
                                Components.largeText(availability[index]),
                                height: HEIGHT * 0.05,
                                horizontalPadding: WIDHT * 0.025,
                                color: Color.fromRGBO(230, 73, 90, 1),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
  }

  pressTimeSelection(int index) {
    if (_finalDateCheckIn != null) {
      _finalDateCheckIn = _finalDateCheckIn.subtract(Duration(
          hours: _finalDateCheckIn.hour,
          minutes: _finalDateCheckIn.minute,
          seconds: _finalDateCheckIn.second,
          milliseconds: _finalDateCheckIn.millisecond,
          microseconds: _finalDateCheckIn.microsecond));
      List hours = availability[index].split(':');
      appointment.day = _finalDateCheckIn;

      _finalDateCheckIn = _finalDateCheckIn.add(
          Duration(hours: int.parse(hours[0]), minutes: int.parse(hours[1])));
      appointment.checkIn = _finalDateCheckIn;
      GlobalMethods().pushPage(context, ConfirmScreen(appointment));
    }
  }

  pressCalendar(DateTime date) {
    if (isConsulting == false) {
      if (date.isAfter(DateTime.now()) ||
          (date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day)) {
        setState(() {
          this.isConsulting = true;
          this.currentDate2 = date;
          this._finalDateCheckIn = date;

          _presenter.init(appointment, currentDate2.toString());
        });
      }
    }
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
