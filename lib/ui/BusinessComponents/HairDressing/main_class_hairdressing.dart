import 'package:cuthair/data/remote/Api/api_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/calendars.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:cuthair/ui/Pages/choose_date/choose_date_presenter.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardServiceHairDressing extends StatelessWidget {
  List<Service> servicesDetails = [];
  Business business;
  Appointment appointment = Appointment();
  double HEIGHT;
  double WIDHT;

  CardServiceHairDressing(this.business, this.servicesDetails);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: servicesDetails.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            appointment.service = servicesDetails[index];
            appointment.business = business;
            GlobalMethods()
                .pushPage(context, ChooseExtraInfoScreen(appointment));
          },
          child: Card(
            shape: BeveledRectangleBorder(
                side: BorderSide(color: Color.fromRGBO(300, 300, 300, 1))),
            child: Container(
              color: Color.fromRGBO(300, 300, 300, 1),
              child: Column(
                children: [
                  cardServices(context, index),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: HEIGHT * 0.013),
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
          ),
        );
      },
    );
  }

  Widget cardServices(BuildContext context, int index) {
    if (servicesDetails[index].duration == "llamada") {
      return GestureDetector(
        onTap: () => makecall(business.phoneNumber.toString()),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: WIDHT * 0.05),
          dense: true,
          title: LargeText(servicesDetails[index].type),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                child: MediumText(
                  "Llame al número para más información",
                  boolText: FontWeight.normal,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                child: MediumText(
                    "Teléfono: " + business.phoneNumber.toString(),
                    boolText: FontWeight.normal),
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.phone, color: Color.fromRGBO(230, 73, 90, 1)),
          ),
        ),
      );
    } else {
      return ListTile(
        contentPadding: EdgeInsets.only(left: WIDHT * 0.05),
        dense: true,
        title: LargeText(servicesDetails[index].type),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.013),
              child: MediumText(
                  servicesDetails[index].duration.toString() + " minutos",
                  boolText: FontWeight.normal),
            ),
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.013),
              child: MediumText(servicesDetails[index].price.toString() + " €",
                  boolText: FontWeight.normal),
            )
          ],
        ),
      );
    }
  }

  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}

class ChooseExtraInfoHairDressing{
  Appointment appointment;
  List<Employee> listEmployees = [];
  ChooseExtraInfoPresenter presenter;
  double height;
  double width;

  Widget getExtraInfoHairDressing(Appointment appointment, List<Employee> listEmployees, ChooseExtraInfoPresenter presenter, double HEIGHT, double WIDTH) {
    this.appointment = appointment;
    this.listEmployees = listEmployees;
    this.presenter = presenter;
    this.height = HEIGHT;
    this.width = WIDTH;

    return Column(
      children: <Widget>[
        title("Seleccione un peluquero"),
        hairDressersButtons(),
      ],
    );
  }

  Widget title(String text) {
    return Container(
      padding: EdgeInsets.only(top: height * 0.054),
      child: Align(
        alignment: Alignment.center,
        child: LargeText(text),
      ),
    );
  }

  Widget hairDressersButtons() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.043, vertical: height * 0.027),
      height: height * 0.80,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: listEmployees.length,
          itemBuilder: (context, index) {
            return MyButton(
                    () => chooseHairdresser(index), LargeText(listEmployees[index].name),
                color: Color.fromRGBO(230, 73, 90, 1));
          }),
    );
  }


  chooseHairdresser(int index) {
    appointment.employee = listEmployees[index];
    presenter.nextScreen(appointment);
  }
}

class ChooseDateHairDressing{
  bool type;
  Appointment appointment;
  bool isConsulting = true;
  DateTime currentDate2 = DateTime.now();
  double height;
  double width;
  List<String> availability = [];
  CalendarWidget calendarWidget;
  BuildContext context;

  Widget getTimeSelectorIsNotEmpty(Appointment appointment, bool type, bool isConsulting, DateTime currentDate,
      double HEIGHT, double WIDTH, List<String> availability, CalendarWidget calendar, BuildContext context, Function pressTimeSelection){

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
            height: 60.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: availability.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: MyButton(
                          () => pressTimeSelection(index),
                      LargeText(availability[index]),
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

class ChooseDateHairDressingPresenter implements ChooseDatePresenter{
  ChooseDateView _view;
  ApiRemoteRepository _remoteRepository;

  ChooseDateHairDressingPresenter(this._view, this._remoteRepository);

  @override
  init(Appointment appointment, String date) async {
    try {
      List availability = await _remoteRepository.getHairDressingAvailability(
          appointment.service.duration.toString(), appointment.employee.name, date, appointment.business.uid);

      _view.showAvailability(availability);
    } catch (e) {
      _view.emptyAvailability();
    }
  }
}

class ConfirmScreenHairDressing{
  Appointment appointment;
  double height;
  double width;
  bool penalize = false;

  Widget getConfirmHairDressing(Appointment appointment, double HEI, double WID, bool penalize, BuildContext context, bool type, Widget confirmButton, Widget cancelButton) {
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
            child: LargeText("¿Desea confirmar la cita?")),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.04, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Peluquero: ")),
              Expanded(
                child: MediumText(appointment.employee.name),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Día: ")),
              Expanded(
                child: MediumText(appointment.checkIn.day.toString()),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Hora: ")),
              Expanded(
                child: MediumText(appointment.checkIn.hour.toString() +
                    ":" +
                    GetTimeSeparated.getFullTimeIfHasOneValue(
                        appointment.checkIn.minute.toString())),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Tipo servicio: ")),
              Expanded(child: MediumText(appointment.service.type)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Duración cita: ")),
              Expanded(
                  child: MediumText(
                      appointment.service.duration.toString() + " minutos")),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: MediumText("Precio cita: ")),
              Expanded(
                  child:
                  MediumText(appointment.service.price.toString() + "€")),
            ],
          ),
        ),
        this.penalize == false
            ? Container()
            : Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.089, height * 0.013, width * 0.089, 0.0),
          child: MediumText(
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
        ),
      ],
    );
  }
}

class CardWithCheckOutHairDressing extends StatelessWidget {
  double HEIGHT;
  double WIDHT;
  int index;
  Function functionRemove;
  List<String> allImages = [];
  List<MyAppointment> myAppointments = [];

  CardWithCheckOutHairDressing(this.index, this.functionRemove,
      this.allImages, this.myAppointments);

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
                        child: MediumText(
                            myAppointments.elementAt(index).businessName),
                      ),
                      Padding(
                          padding:
                          EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child:
                          MediumText(myAppointments.elementAt(index).type)),
                      Container(
                          width: WIDHT * 0.62,
                          padding:
                          EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child: MediumText(
                              myAppointments.elementAt(index).direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: MediumText(
                            myAppointments.elementAt(index).extraInformation),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: HEIGHT * 0.025, left: 1),
                    child: Column(
                      children: <Widget>[
                        SmallText(DateTime.parse(
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
                              child: SmallText(
                                DateTime.parse(myAppointments
                                    .elementAt(index)
                                    .checkIn)
                                    .hour
                                    .toString() +
                                    ":" +
                                    GetTimeSeparated.getFullTimeIfHasOneValue(
                                        DateTime.parse(myAppointments
                                            .elementAt(index)
                                            .checkIn)
                                            .minute
                                            .toString()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: HEIGHT * 0.045),
                              child: SmallText(DateTime.parse(myAppointments
                                  .elementAt(index)
                                  .checkOut)
                                  .hour
                                  .toString() +
                                  ":" +
                                  GetTimeSeparated.getFullTimeIfHasOneValue(
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
              child: MyButton(
                functionRemove,
                SmallText(
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

class ConfirmAnimationHairDressingPresenter implements ConfirmAnimationPresenter{
  ConfirmAnimationView _view;
  RemoteRepository _remoteRepository;
  ApiRemoteRepository _apiRemoteRepository;

  ConfirmAnimationHairDressingPresenter(this._view, this._remoteRepository, this._apiRemoteRepository);

  @override
  init(Appointment appointment) async {
    try {
      DateTime initial = appointment.checkIn.subtract(Duration(
          hours: appointment.checkIn.hour,
          minutes: appointment.checkIn.minute,
          seconds: appointment.checkIn.second,
          microseconds: appointment.checkIn.microsecond,
          milliseconds: appointment.checkIn.millisecond));
      List<String> appointments = await _apiRemoteRepository.getHairDressingAvailability(
          appointment.service.duration.toString(),
          appointment.employee.name,
          initial.toString(), appointment.business.uid
      );

      bool isInAppointments = appointments.contains(
          appointment.checkIn.hour.toString() + ":" +
              GetTimeSeparated.getFullTimeIfHasOneValue(
                  appointment.checkIn.minute.toString()));


      if (!isInAppointments) {
        throw Exception;
      }

      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      _remoteRepository.insertAppointmentHairDressing(appointment, user.uid);
      _view.correctInsert();
    }catch(e){
      _view.incorrectInsert();
    }
  }

}