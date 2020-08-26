import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Pages/choose_date/choose_date_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation_presenter.dart';
import 'package:cuthair/ui/Pages/qr_generator/qr_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../global_methods.dart';

class ChooseDateBeach{
  bool type;
  Appointment appointment;
  bool isConsulting = true;
  DateTime currentDate2 = DateTime.now();
  double height;
  double width;
  List<String> availability = [];
  Calendar calendarWidget;
  BuildContext context;

  Widget getTimeSelectorIsNotEmpty(Appointment appointment, bool type, bool isConsulting, DateTime currentDate,
      double HEIGHT, double WIDTH, List<String> availability, Calendar calendar, BuildContext context, Function pressTimeSelection){

    this.type = type;
    this.appointment = appointment;
    this.isConsulting = isConsulting;
    this.currentDate2 = currentDate;
    this.height = HEIGHT;
    this.width = WIDTH;
    this.availability = availability;
    this.calendarWidget = calendar;
    this.context = context;


    return Padding(
      padding: EdgeInsets.only(top: height * 0.027),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.043, vertical: height * 0.005),
            height: height * 0.08,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availability.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Components.smallButton(
                          () => pressTimeSelection(index),
                      Components.largeText(availability[index]),
                      height: height * 0.05,
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

/*getAppointmentModifiedToHairDressing(Appointment appointment, DateTime _finalDate) {
      appointment.checkIn = _finalDate;
      appointment.checkOut = _finalDate
          .add(Duration(minutes: int.parse(appointment.service.duration)));

          return appointment;
  }*/

}

class ChooseDateBeachPresenter implements ChooseDatePresenter{
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDateBeachPresenter(this._view, this._remoteRepository);

  @override
  init(Appointment appointment, String date) async {
    try {
      List availability = await _remoteRepository.getBeachAvailability(
          appointment.business.durationMeal.toString(), appointment.numberPersons, date, appointment.business.uid);

      _view.showAvailability(availability);
    } catch (e) {
      _view.emptyAvailability();
    }
  }
}

class ConfirmScreenBeach {
  Appointment appointment;
  double height;
  double width;
  bool penalize = false;


  Widget getConfirmBeach(Appointment appointment, double HEI, double WID, bool penalize, BuildContext context, bool type, Widget confirmButton, Widget cancelButton) {
    this.appointment = appointment;
    this.height = HEI;
    this.width = WID;
    this.penalize = penalize;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.135, width * 0.089, height * 0.027),
              child: Components.largeText("¿Desea confirmar la reserva?")),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.04, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText("Playa: ")),
                Expanded(
                  child: Components.mediumText(appointment.business.name),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText("Personas: ")),
                Expanded(
                  child: Components.mediumText(appointment.numberPersons),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText("Día: ")),
                Expanded(
                  child: Components.mediumText(appointment.checkIn.day.toString()),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText("Hora: ")),
                Expanded(
                  child: Components.mediumText(appointment.checkIn.hour.toString() +
                      ":" +
                      GetTimeSeparated.getFullTimeIfHasOneValue_Hour(
                          appointment.checkIn.minute.toString())),
                )
              ],
            ),
          ),
          this.penalize == false || this.penalize == null
              ? Container()
              : Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.089, height * 0.013, width * 0.089, 0.0),
            child: Components.mediumText(
              'Existe una penalización hacia usted en este negocio, pueden haber cambios en el precio final.',
              color: Colors.orange,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.025, height * 0.04, width * 0.025, 0),
            margin: EdgeInsets.symmetric(horizontal: width * 0.025),
            child: Row(
              children: <Widget>[
                cancelButton,
                confirmButton,
              ],
            ),
          )
        ]);
  }
}

class CardWithCheckOutUidBeach extends StatelessWidget {
  double HEIGHT;
  double WIDHT;
  int index;
  Function functionRemove;
  List<String> allImages = [];
  List<MyAppointment> myAppointments = [];

  CardWithCheckOutUidBeach(
      this.index, this.functionRemove, this.allImages, this.myAppointments);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WIDHT * 0.06),
      child: Card(
        elevation: 4,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Color.fromRGBO(60, 60, 62, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.025, HEIGHT * 0.01, WIDHT * 0.025, 0),
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 50.0 / 11.0,
                    child: allImages[index].contains("assets/")
                        ? Image.asset(
                      allImages[index],
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      allImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: WIDHT * 0.025, top: HEIGHT * 0.013),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child: Components.mediumText(
                              myAppointments.elementAt(index).businessName)),
                      Container(
                          width: WIDHT * 0.62,
                          padding:
                          EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child: Components.mediumText(
                              myAppointments.elementAt(index).direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: Components.mediumText("Personas: " +
                            myAppointments.elementAt(index).extraInformation),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: HEIGHT * 0.025, left: 1),
                    child: Column(
                      children: <Widget>[
                        Components.smallText(DateTime.parse(
                            myAppointments.elementAt(index).checkIn)
                            .day
                            .toString() +
                            "-" +
                            DateTime.parse(
                                myAppointments.elementAt(index).checkIn)
                                .month
                                .toString() +
                            "-" +
                            DateTime.parse(
                                myAppointments.elementAt(index).checkIn)
                                .year
                                .toString()),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: HEIGHT * 0.006),
                              child: Components.smallText(
                                DateTime.parse(myAppointments
                                    .elementAt(index)
                                    .checkIn)
                                    .hour
                                    .toString() +
                                    ":" +
                                    GetTimeSeparated.getFullTimeIfHasOneValue_Hour(
                                        DateTime.parse(myAppointments
                                            .elementAt(index)
                                            .checkIn)
                                            .minute
                                            .toString()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: HEIGHT * 0.045),
                              child: Components.smallText(DateTime.parse(myAppointments
                                  .elementAt(index)
                                  .checkOut)
                                  .hour
                                  .toString() +
                                  ":" +
                                  GetTimeSeparated.getFullTimeIfHasOneValue_Hour(
                                      DateTime.parse(myAppointments
                                          .elementAt(index)
                                          .checkOut)
                                          .minute
                                          .toString())),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.01, left: WIDHT * 0.098),
                              child: Container(
                                  height: 30,
                                  child: VerticalDivider(
                                    indent: 5,
                                    thickness: 1.1,
                                    width: 4,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.005, left: WIDHT * 0.086),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Color.fromRGBO(230, 73, 90, 1),
                                        width: 7)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.048, left: WIDHT * 0.09),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 5)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Components.smallButton(
                functionRemove,
                Components.smallText(
                  'Cancelar',
                  size: 11,
                ),
                height: HEIGHT * 0.05,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
            Center(
              child: Components.smallButton(
                    () => {
                  GlobalMethods()
                      .pushPage(context, QrGenerator(myAppointments[index]))
                },
                Components.smallText(
                  'Mostrar código',
                  size: 11,
                ),
                height: HEIGHT * 0.05,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmAnimationBeachPresenter implements ConfirmAnimationPresenter{
  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;

  ConfirmAnimationBeachPresenter(this._view, this._remoteRepository);

  @override
  init(Appointment appointment) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      _remoteRepository.insertAppointmentBeach(appointment, user.uid);
      _view.correctInsert();
    }catch(e){
      _view.incorrectInsert();
    }
  }

}