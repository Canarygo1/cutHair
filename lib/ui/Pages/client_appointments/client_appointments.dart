import 'dart:async';
import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:components/others_components/confirm_dialog.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:cuthair/ui/Components/card_elements/card_with_checkOut.dart';
import 'package:cuthair/ui/Components/card_elements/card_without_checkOut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'client_appointments_presenter.dart';

class ClientAppointments extends StatefulWidget {
  @override
  _ClientAppointmentsState createState() => _ClientAppointmentsState();
}

class _ClientAppointmentsState extends State<ClientAppointments>
    implements MyAppointmentsView {
  List<AppointmentCompleted> myAppointments = [];
  List<AppointmentCompleted> aux = [];
  GlobalMethods global = GlobalMethods();
  RemoteRepository _remoteRepository;
  ClientAppointmentsPresenter _presenter;
  bool isConsulting = true;
  bool filter = true;
  double height;
  double width;
  Calendar calendarWidget;
  ConfirmDialog confirmDialog;
  List<String> allImages;
  bool firstTime = true;
  CardWithCheckOut cardWithCheckOut;
  CardWithoutCheckOut cardWithoutCheckOut;
  Timer timer;

  @override
  void deactivate() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
  }

  @override
  initState() {
    allImages = [];
    super.initState();
    _remoteRepository = HttpRemoteRepository(Client());
    _presenter = ClientAppointmentsPresenter(this, _remoteRepository);
    _presenter.init(DBProvider.users[0].id, false);
    calendarWidget =
        Calendar((DateTime date, List<Event> events) => pressCalendar(date));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: Components.largeText("Mis citas"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            this.filter == true
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Components.smallButton(
                        () => {
                          this.isConsulting == false
                              ? this.setState(() => {
                                    this.filter = false,
                                    this.isConsulting = false
                                  })
                              : () => {},
                        },
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/images/Filter.svg",
                              width: width * 0.063,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: width * 0.024),
                              child: Components.largeText("Día"),
                            ),
                          ],
                        ),
                        height: height * 0.054,
                        verticalMargin: height * 0.035,
                        horizontalPadding: width * 0.03,
                        color: Color.fromRGBO(230, 73, 90, 1),
                      ),
                      calendarWidget.currentDate2 != null
                          ? Components.mediumText(
                              calendarWidget.currentDate2.day.toString() +
                                  "-" +
                                  calendarWidget.currentDate2.month.toString() +
                                  "-" +
                                  calendarWidget.currentDate2.year.toString(),
                              color: Color.fromRGBO(26, 200, 146, 1))
                          : Container(),
                    ],
                  )
                : Container(),
            this.filter == false
                ? Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: height * 0.027),
                          child: Components.largeText(
                            "Seleccione el día.",
                            size: 25,
                          ),
                        ),
                      ),
                      calendarWidget,
                    ],
                  )
                : myAppointment()
          ],
        ),
      ),
    );
  }

  Widget myAppointment() {
    return isConsulting == true
        ? SpinKitWave(
            color: Color.fromRGBO(230, 73, 90, 1),
            type: SpinKitWaveType.start,
          )
        : aux.length == 0
            ? Center(
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
                          Components.mediumText(
                              "Vaya! Parece que todavía no tienes citas"),
                          Components.mediumText(
                              "Puedes reservarlas en el home"),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: aux.length,
                itemBuilder: (context, index) {
                  if (aux[index].business.useCheckout == true) {
                    cardWithCheckOut = CardWithCheckOut(
                      () => controlTimer(index),
                      aux[index],
                    );
                    return cardWithCheckOut;
                  } else {
                    cardWithoutCheckOut = CardWithoutCheckOut(
                        aux[index], () => functionRemove(index));
                    return cardWithoutCheckOut;
                  }
                });
  }

  controlTimer(int index) {
    if (firstTime == true) {
      return functionRemove(index);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          confirmDialog = Components.confirmDialog(
            Components.mediumText(
                "Lo sentimos tiene que esperar 1 minuto para cancelar otra cita."),
            () => {},
            multiOptions: false,
          );
          return confirmDialog;
        },
      );
    }
  }

  functionRemove(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        confirmDialog = Components.confirmDialog(
          Components.mediumText("¿Desea cancelar la cita?"),
          () => {
            this.setState(() {
              isConsulting = true;
              firstTime = false;
            }),
            _presenter.removeAppointment(
                aux[index], calendarWidget.currentDate2),
            GlobalMethods().popPage(confirmDialog.context),
            timer = Timer(
                Duration(minutes: 1),
                () => this.setState(() {
                      firstTime = true;
                    })),
          },
        );
        return confirmDialog;
      },
    );
  }

  checkDay(DateTime day) {
    if (calendarWidget.currentDate2 != null) {
      if (day.day == calendarWidget.currentDate2.day &&
          day.month == calendarWidget.currentDate2.month &&
          day.year == calendarWidget.currentDate2.year) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  generateList() {
    if (myAppointments.isNotEmpty) {
      aux = myAppointments
          .where((element) =>
              checkDay(DateTime.parse(element.appointment.checkIn)))
          .toList();
    }
    setState(() {
      isConsulting = false;
    });
  }

  pressCalendar(DateTime date) {
    if (isConsulting == false) {
      if (date.isAfter(calendarWidget.currentDate) ||
          (date.year == calendarWidget.currentDate.year &&
              date.month == calendarWidget.currentDate.month &&
              date.day == calendarWidget.currentDate.day)) {
        calendarWidget.currentDate2 = date;
        setState(() {
          isConsulting = true;
          this.filter = true;
        });
        if (myAppointments.isEmpty) {
          _presenter.init(DBProvider.users[0].id, true);
        } else {
          generateList();
        }
      }
    }
  }

  @override
  showAppointments(List<AppointmentCompleted> myAppointment) {
    if (mounted) {
      setState(() {
        this.myAppointments = myAppointment;
        generateList();
      });
    }
  }

  @override
  emptyAppointment() {
    if (mounted) {
      setState(() {
        isConsulting = false;
        myAppointments.clear();
      });
    }
  }
}
