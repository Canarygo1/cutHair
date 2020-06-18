import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:components/others_components/confirm_dialog.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Components/card_elements/card_with_checkOut.dart';
import 'package:cuthair/ui/Components/card_elements/card_with_checkOut_Uid.dart';
import 'package:cuthair/ui/Components/card_elements/card_without_checkOut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'client_appointments_presenter.dart';

class ClientAppointments extends StatefulWidget {
  @override
  _ClientAppointmentsState createState() => _ClientAppointmentsState();
}

class _ClientAppointmentsState extends State<ClientAppointments>
    implements MyAppointmentsView {
  List<MyAppointment> myAppointments = [];
  GlobalMethods global = GlobalMethods();
  RemoteRepository _remoteRepository;
  ClientAppointmentsPresenter _presenter;
  bool isConsulting = true;
  bool filter = true;
  double HEIGHT;
  double WIDHT;
  Calendar calendarWidget;
  ConfirmDialog confirmDialog;
  List<String> allImages;
  bool firstTime = true;
  CardWithCheckOut cardWithCheckOut;
  CardWithoutCheckOut cardWithoutCheckOut;
  CardWithCheckOutUid cardWithCheckOutUid;
  Timer timer;

  @override
  void deactivate() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    ;
  }

  @override
  initState() {
    allImages = [];
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = ClientAppointmentsPresenter(this, _remoteRepository);
    _presenter.init(DBProvider.users[0].uid, DateTime.now(), true);
    calendarWidget =
        Calendar((DateTime date, List<Event> events) => pressCalendar(date));
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
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
                ? Padding(
                    padding: EdgeInsets.only(right: WIDHT * 0.61),
                    child: Components.smallButton(
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
                            width: WIDHT * 0.063,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: WIDHT * 0.024),
                            child: Components.largeText("Día"),
                          ),
                        ],
                      ),
                      height: HEIGHT * 0.054,
                      verticalMargin: HEIGHT * 0.035,
                      horizontalPadding: WIDHT * 0.05,
                      color: Color.fromRGBO(230, 73, 90, 1),
                    ),
                  )
                : Container(),
            this.filter == false
                ? Column(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: HEIGHT * 0.027),
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
        : myAppointments.length == 0
            ? Center(
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
                itemCount: myAppointments.length,
                itemBuilder: (context, index) {
                  if (myAppointments.elementAt(index).typeBusiness ==
                      "Peluquerías") {
                    cardWithCheckOut = CardWithCheckOut(index,
                        () => controlTimer(index), allImages, myAppointments);
                    return cardWithCheckOut;
                  } else if (myAppointments.elementAt(index).typeBusiness ==
                      "Restaurantes") {
                    cardWithoutCheckOut = CardWithoutCheckOut(index,
                        () => controlTimer(index), allImages, myAppointments);
                    return cardWithoutCheckOut;
                  } else if (myAppointments.elementAt(index).typeBusiness ==
                      "Playas") {
                    cardWithCheckOutUid = CardWithCheckOutUid(index,
                        () => controlTimer(index), allImages, myAppointments);
                    return cardWithCheckOutUid;
                  } else {
                    return Container();
                  }
                });
  }

  controlTimer(int index) {
    if (firstTime == true) {
      setState(() {
        firstTime = false;
      });
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
              firstTime = !firstTime;
            }),
            GlobalMethods().popPage(confirmDialog.context),
            ConnectionChecked.checkInternetConnectivity(context),
            _presenter.removeAppointment(myAppointments[index], index,
                DBProvider.users[0].uid, DateTime.now()),
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

  pressCalendar(DateTime date) {
    if (isConsulting == false) {
      if (date.isAfter(calendarWidget.currentDate) ||
          (date.year == calendarWidget.currentDate.year &&
              date.month == calendarWidget.currentDate.month &&
              date.day == calendarWidget.currentDate.day)) {
        this.setState(() {
          calendarWidget.currentDate2 = date;
          myAppointments.clear();
          allImages.clear();
          _presenter.init(DBProvider.users[0].uid, date, false);
          this.filter = true;
          this.isConsulting = true;
        });
      }
    }
  }

  @override
  showAppointments(List<MyAppointment> myAppointment) {
    if (mounted) {
      setState(() {
        isConsulting = false;
        myAppointments = myAppointment;
      });
    }
  }

  @override
  showImages(List<String> allImages) {
    if (mounted) {
      setState(() {
        this.allImages = allImages;
      });
    }
  }

  @override
  emptyAppointment() {
    if (mounted) {
      setState(() {
        isConsulting = false;
        myAppointments = [];
      });
    }
  }
}
