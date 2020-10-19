import 'package:components/components.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment appointment;
  BusinessType businessType;
  Business business;
  Service service;

  ConfirmScreen(
      this.appointment, this.businessType, this.business, this.service);

  @override
  _ConfirmScreenState createState() =>
      _ConfirmScreenState(appointment, businessType, business, service);
}

class _ConfirmScreenState extends State<ConfirmScreen> implements ConfirmView {
  Appointment appointment;
  Widget screen;
  Business business;
  List<User> listUser;
  bool penalize = false;
  ConfirmPresenter presenter;
  RemoteRepository _remoteRepository;
  double height;
  double width;
  BusinessType businessType;
  Employee employee;
  Place place;
  Service service;
  bool isCharging = false;

  _ConfirmScreenState(
      this.appointment, this.businessType, this.business, this.service);

  initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Client());
    presenter = ConfirmPresenter(this, _remoteRepository);
    presenter.init(appointment, business);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(
        child: isCharging == false ? Container() : confirmWidget(),
      ),
    );
  }

  Widget confirmWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.135, width * 0.089, height * 0.027),
            child: Components.largeText("¿Desea confirmar la cita?")),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.04, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              business.useEmployees == false
                  ? Expanded(child: Components.mediumText("Plazas: "))
                  : Expanded(child: Components.mediumText("Empleado: ")),
              business.useEmployees == false
                  ? Expanded(child: Components.mediumText(place.type))
                  : Expanded(child: Components.mediumText(employee.name)),
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
                child: Components.mediumText(
                    DateTime.parse(appointment.checkIn).day.toString()),
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
                child: Components.mediumText(DateTime.parse(appointment.checkIn)
                        .hour
                        .toString() +
                    ":" +
                    GetTimeSeparated.getFullTimeIfHasOneValue_Hour(
                        DateTime.parse(appointment.checkIn).minute.toString())),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Tipo servicio: ")),
              appointment.plazaCitaId == null
                  ? Expanded(child: Components.mediumText(service.name))
                  : Expanded(child: Components.mediumText(businessType.type)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Duración cita: ")),
              Expanded(
                  child: Components.mediumText(
                      service.duration.toString() + " minutos")),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.254, height * 0.013, width * 0.089, height * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Precio cita: ")),
              appointment.plazaCitaId == null
                  ? Expanded(
                      child:
                          Components.mediumText(service.price.toString() + "€"))
                  : Expanded(child: Components.mediumText('No establecido')),
            ],
          ),
        ),
        this.business.name == 'Privilege'
            ? this.penalize == false || this.penalize == null
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.089, height * 0.013, width * 0.089, 0.0),
                    child: Components.mediumText(
                      'Existe una penalización hacia usted en este negocio, pueden haber cambios en el precio final.',
                      color: Colors.orange,
                    ),
                  )
            : Container(),
        Container(
          padding: EdgeInsets.fromLTRB(
              width * 0.025, height * 0.04, width * 0.025, 0),
          margin: EdgeInsets.symmetric(horizontal: width * 0.025),
          child: Row(
            children: <Widget>[
              buttonCancel(),
              buttonConfirm(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buttonConfirm() {
    return Expanded(
      child: Components.smallButton(
        () => {
          GlobalMethods().pushAndReplacement(context,
              ConfirmAnimation(appointment, business, businessType, service))
        },
        Components.largeText("Confirmar"),
        horizontalPadding: width * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: height * 0.067,
      ),
    );
  }

  Widget buttonCancel() {
    return Expanded(
      child: Components.smallButton(
        () => {
          GlobalMethods().removePages(context)
        },
        Components.largeText("Cancelar"),
        horizontalPadding: width * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: height * 0.067,
      ),
    );
  }

  @override
  showPenalize(bool penalize) {
    if (mounted) {
      setState(() {
        this.penalize = penalize;
      });
    }
  }

  @override
  viewEmployee(Employee result) {
    if (this.mounted) {
      employee = result;
      setState(() {
        isCharging = true;
      });
    }
  }

  @override
  viewPlaza(place) {
    if (mounted) {
      this.place = place;
      setState(() {
        isCharging = true;
      });
    }
  }
}
