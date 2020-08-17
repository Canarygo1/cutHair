import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment appointment;

  ConfirmScreen(this.appointment);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState(appointment);
}

class _ConfirmScreenState extends State<ConfirmScreen> implements ConfirmView {
  Appointment appointment;
  Widget screen;
  List<User> listUser;
  bool penalize = false;
  ConfirmPresenter presenter;
  RemoteRepository _remoteRepository;
  double HEIGHT;
  double WIDHT;

  _ConfirmScreenState(this.appointment);

  initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ConfirmPresenter(this, _remoteRepository);
    presenter.init(DBProvider.users[0].uid);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(child: getConfirmScreen()),
    );
  }

  Widget getConfirmScreen() {
    if (appointment.business.typeBusiness == "Peluquerías") {
      return confirmHairDressing();
    } else if (appointment.business.typeBusiness == "Restaurantes") {
      return confirmRestaurant();
    } else {
      return confirmBeach();
    }
  }

  Widget confirmHairDressing() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(
                WIDHT * 0.05, HEIGHT * 0.135, WIDHT * 0.089, HEIGHT * 0.027),
            child: Components.largeText("¿Desea confirmar la cita?")),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.04, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Peluquero: ")),
              Expanded(
                child: Components.mediumText(appointment.employee.name),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Día: ")),
              Expanded(
                child:
                    Components.mediumText(appointment.checkIn.day.toString()),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Hora: ")),
              Expanded(
                child: Components.mediumText(
                    appointment.checkIn.hour.toString() +
                        ":" +
                        GetTimeSeparated.getFullTimeIfHasOneValue_Hour(
                            appointment.checkIn.minute.toString())),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Tipo servicio: ")),
              Expanded(child: Components.mediumText(appointment.service.type)),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Duración cita: ")),
              Expanded(
                  child: Components.mediumText(
                      appointment.service.duration.toString() + " minutos")),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
          child: Row(
            children: <Widget>[
              Expanded(child: Components.mediumText("Precio cita: ")),
              Expanded(
                  child: Components.mediumText(
                      appointment.service.price.toString() + "€")),
            ],
          ),
        ),
        this.appointment.business.uid == 'PR01'
            ? this.penalize == false || this.penalize == null
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(
                        WIDHT * 0.089, HEIGHT * 0.013, WIDHT * 0.089, 0.0),
                    child: Components.mediumText(
                      'Existe una penalización hacia usted en este negocio, pueden haber cambios en el precio final.',
                      color: Colors.orange,
                    ),
                  )
            : Container(),
        Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.025, HEIGHT * 0.04, WIDHT * 0.025, 0),
          margin: EdgeInsets.symmetric(horizontal: WIDHT * 0.025),
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

  Widget confirmRestaurant() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
        Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.05, HEIGHT * 0.135, WIDHT * 0.089, HEIGHT * 0.027),
          child: Components.largeText("¿Desea confirmar la reserva?")),
      Container(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.254, HEIGHT * 0.04, WIDHT * 0.089, HEIGHT * 0.027),
        child: Row(
          children: <Widget>[
            Expanded(child: Components.mediumText("Restaurante: ")),
            Expanded(
              child: Components.mediumText(appointment.business.name),
            )
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
      Container(
        padding:
            EdgeInsets.fromLTRB(WIDHT * 0.025, HEIGHT * 0.04, WIDHT * 0.025, 0),
        margin: EdgeInsets.symmetric(horizontal: WIDHT * 0.025),
        child: Row(
          children: <Widget>[
            buttonCancel(),
            buttonConfirm(),
          ],
        ),
      )
    ]);
  }

  Widget confirmBeach() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
        Widget>[
      Container(
          padding: EdgeInsets.fromLTRB(
              WIDHT * 0.05, HEIGHT * 0.135, WIDHT * 0.089, HEIGHT * 0.027),
          child: Components.largeText("¿Desea confirmar la reserva?")),
      Container(
        padding: EdgeInsets.fromLTRB(
            WIDHT * 0.254, HEIGHT * 0.04, WIDHT * 0.089, HEIGHT * 0.027),
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
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
            WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
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
      Container(
        padding:
            EdgeInsets.fromLTRB(WIDHT * 0.025, HEIGHT * 0.04, WIDHT * 0.025, 0),
        margin: EdgeInsets.symmetric(horizontal: WIDHT * 0.025),
        child: Row(
          children: <Widget>[
            buttonCancel(),
            buttonConfirm(),
          ],
        ),
      )
    ]);
  }

  Widget buttonConfirm() {
    return Expanded(
      child: Components.smallButton(
        () => {
          ConnectionChecked.checkInternetConnectivity(context),
          GlobalMethods()
              .pushAndReplacement(context, ConfirmAnimation(appointment))
        },
        Components.largeText("Confirmar"),
        horizontalPadding: WIDHT * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: HEIGHT * 0.067,
      ),
    );
  }

  Widget buttonCancel() {
    return Expanded(
      child: Components.smallButton(
        () => {
          ConnectionChecked.checkInternetConnectivity(context),
          GlobalMethods().removePages(context)
        },
        Components.largeText("Cancelar"),
        horizontalPadding: WIDHT * 0.025,
        color: Color.fromRGBO(230, 73, 90, 1),
        height: HEIGHT * 0.067,
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
}
