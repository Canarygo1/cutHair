import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/client_home/client_home.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/remote/check_connection.dart';
import '../../../data/remote/http_remote_repository.dart';
import '../../../data/remote/remote_repository.dart';
import '../../../global_methods.dart';
import '../../Components/button.dart';
import '../confirm_animation/confirm_animation.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(WIDHT * 0.05, HEIGHT * 0.135,
                    WIDHT * 0.089, HEIGHT * 0.027),
                child: LargeText("¿Desea confirmar la cita?")),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.254, HEIGHT * 0.04, WIDHT * 0.089, HEIGHT * 0.027),
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
                  WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Dia: ")),
                  Expanded(
                    child: MediumText(appointment.checkIn.day.toString()),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Hora: ")),
                  Expanded(
                    child: MediumText(appointment.checkIn.hour.toString() +
                        ":" +
                        appointment.checkIn.minute.toString()),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Tipo servicio: ")),
                  Expanded(child: MediumText(appointment.service.type)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Duracion cita: ")),
                  Expanded(
                      child: MediumText(
                          appointment.service.duration.toString() +
                              " minutos")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.254, HEIGHT * 0.013, WIDHT * 0.089, HEIGHT * 0.027),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Precio cita: ")),
                  Expanded(
                      child: MediumText(
                          appointment.service.price.toString() + "€")),
                ],
              ),
            ),
            this.penalize == false
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(
                        WIDHT * 0.089, HEIGHT * 0.013, WIDHT * 0.089, 0.0),
                    child: MediumText(
                      'Existe una penalización hacia usted en este negocio, pueden haber cambios en el precio final.',
                      color: Colors.orange,
                    ),
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.025, HEIGHT * 0.04, WIDHT * 0.025, 0),
              margin: EdgeInsets.symmetric(horizontal: WIDHT * 0.025),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: MyButton(
                      () => {
                        ConnectionChecked.checkInternetConnectivity(context),
                        GlobalMethods().pushAndReplacement(
                            context, Menu(DBProvider.users[0]))
                      },
                      LargeText("Cancelar cita"),
                      horizontalPadding: WIDHT * 0.025,
                      color: Color.fromRGBO(230, 73, 90, 1),
                      height: HEIGHT * 0.067,
                    ),
                  ),
                  Expanded(
                    child: MyButton(
                      () => {
                        ConnectionChecked.checkInternetConnectivity(context),
                        GlobalMethods().pushAndReplacement(
                            context, ConfirmAnimation(appointment))
                      },
                      LargeText("Confirmar"),
                      horizontalPadding: WIDHT * 0.025,
                      color: Color.fromRGBO(230, 73, 90, 1),
                      height: HEIGHT * 0.067,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
