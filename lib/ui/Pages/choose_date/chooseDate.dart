import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'choose_date_presenter.dart';

class ChooseDate extends StatefulWidget {
  Appointment appointment;
  BusinessType typeBusiness;
  Service service;
  Business business;

  ChooseDate(this.appointment, this.typeBusiness, this.service, this.business);

  @override
  _ChooseDateState createState() =>
      _ChooseDateState(appointment, typeBusiness, service, business);
}

class _ChooseDateState
    extends State<ChooseDate> implements ChooseDateView {
  Appointment appointment;
  Service service;
  Business business;

  bool isConsulting = true;
  DateTime currentDate2 = DateTime.now();

  _ChooseDateState(this.appointment, this.typeBusiness, this.service, this.business);

  double height;
  double width;
  List<String> availability = [];
  DateTime _finalDate = DateTime.now();
  RemoteRepository _remoteRepository;
  ChooseDatePresenter _presenter;
  Calendar calendarWidget;
  BusinessType typeBusiness;

  initState() {
    _remoteRepository = HttpRemoteRepository(Client());
    _presenter = ChooseDatePresenter(this, _remoteRepository);
    _presenter.init(appointment, currentDate2, typeBusiness.type, service, business);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

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
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Calendar(
                (DateTime date, List<Event> events) => pressCalendar(date),
                currentDate2: currentDate2),
            Padding(
              padding: EdgeInsets.only(left: width * 0.025),
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
        ? Padding(
          padding: EdgeInsets.only(top: height * 0.03),
          child: SpinKitWave(
              color: Color.fromRGBO(230, 73, 90, 1),
              type: SpinKitWaveType.start,
            ),
        )
        : availability.isEmpty
            ? Padding(
                padding:
                    EdgeInsets.only(top: height * 0.03, left: width * 0.03),
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/sad.svg",
                      width: width * 0.229,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
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
                padding: EdgeInsets.only(top: height * 0.027),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.043, vertical: height * 0.005),
                      height: 60.0,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: availability.length,
                          itemBuilder: (context, index) {
                            DateTime dateTime = DateTime.parse(availability[index]);
                            String minutes = dateTime.minute.toString().length == 1 ? dateTime.minute.toString() + "0" : dateTime.minute.toString();
                            String value = dateTime.hour.toString() + ":" + minutes;
                            return Center(
                              child: Components.smallButton(
                                () => pressTimeSelection(dateTime),
                                Components.largeText(value),
                                horizontalPadding: width * 0.025,
                                color: Color.fromRGBO(230, 73, 90, 1),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
  }

  pressTimeSelection(DateTime date) async {
    if (_finalDate != null) {
      _presenter.pressInOption(date, appointment, service);
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
          this._finalDate = date;
          this._presenter.init(appointment, currentDate2, typeBusiness.type, service, business);
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

  @override
  goToNewScreen(Appointment value) {
    appointment = value;
    GlobalMethods().pushPage(context, ConfirmScreen(appointment, typeBusiness, business, service));
  }
}
