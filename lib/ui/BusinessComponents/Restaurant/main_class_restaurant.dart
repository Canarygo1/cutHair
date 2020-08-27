
import 'package:components/components.dart';
import 'package:components/others_components/calendar.dart';
import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Pages/choose_date/choose_date_presenter.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../global_methods.dart';

class CardServiceRestaurant extends StatefulWidget {
  Business business;
  List<Service> serviceDetails;

  CardServiceRestaurant(this.business, this.serviceDetails);

  @override
  _CardServiceRestaurantState createState() => _CardServiceRestaurantState();
}

class _CardServiceRestaurantState extends State<CardServiceRestaurant> {
  double HEIGHT;
  double WIDHT;

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;

    return Container(
      child: ListView.builder(
        itemCount: widget.serviceDetails.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Card(
            shape: BeveledRectangleBorder(
                side: BorderSide(
                    color: Color.fromRGBO(300, 300, 300, 1))),
            child: Container(
              color: Color.fromRGBO(300, 300, 300, 1),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                        EdgeInsets.only(left: WIDHT * 0.02),
                        child: SizedBox(
                          height: HEIGHT * 0.135,
                          width: WIDHT * 0.30,
                          child: Container(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              child: Container(
                                child: AspectRatio(
                                  aspectRatio: 4 / 4,
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: ExactAssetImage(
                                        "assets/images/carneFiesta.jpg"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding:
                          EdgeInsets.only(left: WIDHT * 0.05),
                          dense: true,
                          title: Components.largeText(widget.serviceDetails.elementAt(index).type),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: HEIGHT * 0.013),
                                child: Components.mediumText
                                  (
                                    widget.serviceDetails.elementAt(index).description,
                                    boolText: FontWeight.normal),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                                child: Components.mediumText
                                  (
                                    widget.serviceDetails[index].price.toString() + " €",
                                    boolText: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: HEIGHT * 0.013),
                            child: Divider(
                              thickness: 0.6,
                              endIndent: 10.0,
                              indent: 5.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChooseExtraInfoRestaurant{
  Appointment appointment;
  List<Employee> listEmployees = [];
  ChooseExtraInfoPresenter presenter;
  double height;
  double width;


  Widget getExtraInfoRestaurant(Appointment appointment, List<Employee> listEmployees, ChooseExtraInfoPresenter presenter, double HEIGHT, double WIDTH) {
    this.appointment = appointment;
    this.listEmployees = listEmployees;
    this.presenter = presenter;
    this.height = HEIGHT;
    this.width = WIDTH;

    return Column(
      children: <Widget>[
        title("Seleccione el número de personas"),
        chooseNumberClients(appointment.business.maxPeople),
      ],
    );
  }

  Widget title(String text) {
    return Container(
      padding: EdgeInsets.only(top: height * 0.054),
      child: Align(
        alignment: Alignment.center,
        child: Components.largeText(text),
      ),
    );
  }

  Widget chooseNumberClients(int numero){
    int max = (numero / 3).round() + 1;
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.087, vertical: height * 0.027),
        height: height * 0.80,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: max,
                  itemBuilder: (context, index){
                    int number1 = index * 3 + 1;
                    int number2 = index * 3 + 2;
                    int number3 = index * 3 + 3;

                    return Row(
                        children: <Widget>[
                          number1 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number1), Components.largeText(number1.toString()),
                              color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0,),
                          ) : Container(),
                          number2 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number2), Components.largeText(number2.toString()),
                                color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0),
                          ) : Container(),
                          number3 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number3), Components.largeText(number3.toString()),
                                color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0),
                          ) : Container()
                        ]);
                  })],
          ),
        ));
  }

  chooseNumberPersons(int index){
    appointment.numberPersons = index.toString();
    presenter.nextScreen(appointment);
  }
}

class ChooseDateRestaurant{
  Appointment appointment;
  bool isConsulting = true;
  DateTime currentDate2 = DateTime.now();
  double height;
  double width;
  List<String> availability = [];
  Calendar calendarWidget;
  BuildContext context;

  Widget getTimeSelectorIsNotEmpty(Appointment appointment, bool isConsulting, DateTime currentDate,
      double HEIGHT, double WIDTH, List<String> availability, Calendar calendar, BuildContext context, Function pressTimeSelection){

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

/*getAppointmentModifiedToRestaurant(Appointment appointment, DateTime _finalDate) {
      appointment.checkIn = _finalDate;

      return appointment;
  }*/
}

class ChooseDateRestaurantPresenter implements ChooseDatePresenter{
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDateRestaurantPresenter(this._view, this._remoteRepository);

  @override
  init(Appointment appointment, String date) async {
    try {
      List availability = await _remoteRepository.getRestaurantAvailability(
          appointment.business.durationMeal.toString(), appointment.numberPersons, date, appointment.business.uid);

      _view.showAvailability(availability);
    } catch (e) {
      _view.emptyAvailability();
    }
  }
}

class ConfirmScreenRestaurant{
  Appointment appointment;
  double height;
  double width;
  bool penalize = false;

  Widget getConfirmRestaurant(Appointment appointment, double HEI, double WID, bool penalize, BuildContext context, Widget confirmButton, Widget cancelButton) {
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
                Expanded(child: Components.mediumText
                  ("Restaurante: ")),
                Expanded(
                  child: Components.mediumText
                    (appointment.business.name),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText
                  ("Personas: ")),
                Expanded(
                  child: Components.mediumText
                    (appointment.numberPersons),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText
                  ("Día: ")),
                Expanded(
                  child: Components.mediumText
                    (appointment.checkIn.day.toString()),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.254, height * 0.013, width * 0.089, height * 0.027),
            child: Row(
              children: <Widget>[
                Expanded(child: Components.mediumText
                  ("Hora: ")),
                Expanded(
                  child: Components.mediumText
                    (appointment.checkIn.hour.toString() +
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
            child: Components.mediumText
              (
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

class CardWithoutCheckOutRestaurant extends StatelessWidget {
  double HEIGHT;
  double WIDHT;
  int index;
  Function functionRemove;
  List<String> allImages;
  List<MyAppointment> myAppointments = [];

  CardWithoutCheckOutRestaurant(
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
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: Components.mediumText
                          (
                            myAppointments.elementAt(index).businessName),
                      ),
                      Container(
                          width: WIDHT * 0.62,
                          padding:
                          EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child: Components.mediumText
                            (
                              myAppointments.elementAt(index).direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: Components.mediumText
                          ("Personas: " +
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
                              padding: EdgeInsets.only(top: HEIGHT * 0.020),
                              child: Components.mediumText
                                (
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
                            )
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
          ],
        ),
      ),
    );
  }
}

class ConfirmAnimationRestaurantPresenter implements ConfirmAnimationPresenter{
  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;

  ConfirmAnimationRestaurantPresenter(this._view, this._remoteRepository);

  @override
  init(Appointment appointment) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      _remoteRepository.insertAppointmentRestaurant(appointment, user.uid);
      _view.correctInsert();
    }catch(e){
      _view.incorrectInsert();
    }
  }

}