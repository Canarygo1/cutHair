import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'choose_extra_info_presenter.dart';

class ChooseExtraInfoScreen extends StatefulWidget {
  Appointment appointment;
  Business business;
  BusinessType typeBusiness;
  Service service;

  ChooseExtraInfoScreen(this.appointment, this.business, this.typeBusiness, this.service);

  @override
  _ChooseExtraInfoScreenState createState() =>
      _ChooseExtraInfoScreenState(appointment, business, typeBusiness, service);
}

class _ChooseExtraInfoScreenState extends State<ChooseExtraInfoScreen>
    implements ChooseHairDresserView {
  Appointment appointment;
  Service service;
  List<Place> places = [];
  List<Employee> employees = [];
  RemoteRepository _remoteRepository;
  ChooseExtraInfoPresenter presenter;
  double height;
  double width;
  Business business;
  BusinessType typeBusiness;

  _ChooseExtraInfoScreenState(
      this.appointment, this.business, this.typeBusiness, this.service);

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Client());
    presenter = ChooseExtraInfoPresenter(this, _remoteRepository);
    presenter.init(business, typeBusiness.type);
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
            business.useEmployees == true
                ? title("Seleccione un peluquero")
                : title("Seleccione el número de personas"),
            getExtraInformation()
          ],
        ),
      ),
    );
  }

  Widget getExtraInformation() {
    if (business.useEmployees == true) {
      return buttonsEmployees();
    } else {
      return chooseNumberClients(places.length);
    }
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

  Widget buttonsEmployees() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.043, vertical: height * 0.027),
      height: height * 0.80,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: employees.length,
          itemBuilder: (context, index) {
            return Components.smallButton(() => chooseFunction(index),
                Components.largeText(employees[index].name),
                color: Color.fromRGBO(230, 73, 90, 1));
          }),
    );
  }

  Widget chooseNumberClients(int numero) {
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
                  itemBuilder: (context, index) {
                    int number1 = index * 3 + 1;
                    int number2 = index * 3 + 2;
                    int number3 = index * 3 + 3;
                    return Row(children: <Widget>[
                      number1 <= numero
                          ? Expanded(
                              child: Components.smallButton(
                                () => chooseNumberPersons(number1),
                                Components.largeText(places[number1].type),
                                color: Color.fromRGBO(230, 73, 90, 1),
                                horizontalPadding: 20.0,
                              ),
                            )
                          : Container(),
                      number2 <= numero
                          ? Expanded(
                              child: Components.smallButton(
                                  () => chooseNumberPersons(number2),
                                  Components.largeText(places[number2].type),
                                  color: Color.fromRGBO(230, 73, 90, 1),
                                  horizontalPadding: 20.0),
                            )
                          : Container(),
                      number3 <= numero
                          ? Expanded(
                              child: Components.smallButton(
                                  () => chooseNumberPersons(number3),
                                  Components.largeText(places[number3].type),
                                  color: Color.fromRGBO(230, 73, 90, 1),
                                  horizontalPadding: 20.0),
                            )
                          : Container()
                    ]);
                  })
            ],
          ),
        ));
  }

  @override
  showEmployes(List employes) {
    if (mounted) {
      setState(() {
        employees = employes;
      });
    }
  }

  @override
  goToCalendar() {
    GlobalMethods().pushPage(context, ChooseDate(appointment, typeBusiness, service, business));
  }

  chooseFunction(int index) {
    appointment.employeeId = employees[index].id;
    presenter.nextScreen();
  }

  chooseNumberPersons(int index) {
    appointment.plazaCitaId = places[index].id;
    presenter.nextScreen();
  }

  @override
  showPlaces(List places) {
    if (mounted) {
      setState(() {
        this.places = places;
      });
    }
  }
}
