import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_presenter.dart';
import 'package:cuthair/ui/Pages/confirm_animation/confirm_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/local/db_sqlite.dart';
import '../../../data/local/db_sqlite.dart';
import '../../../data/remote/check_connection.dart';
import '../../../data/remote/http_remote_repository.dart';
import '../../../data/remote/remote_repository.dart';
import '../../../global_methods.dart';
import '../../Components/large_text.dart';
import '../../Components/medium_text.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment appointment;

  ConfirmScreen(this.appointment);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState(appointment);
}

class _ConfirmScreenState extends State<ConfirmScreen> implements ConfirmView {
  Appointment appointment;
  Widget screen;
  List<User> lista;
  bool penalize = false;
  ConfirmPresenter presenter;
  RemoteRepository _remoteRepository;

  _ConfirmScreenState(this.appointment);

  initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ConfirmPresenter(this, _remoteRepository);
    presenter.init(DBProvider.users[0].uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(20.0, 100.0, 35.0, 20.0),
                child: LargeText("¿Desea confirmar la cita?")),
            Container(
              padding: EdgeInsets.fromLTRB(100.0, 30.0, 35.0, 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Peluquero: ")),
                  Expanded(
                    child: MediumText(appointment.employe.name),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
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
              padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
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
              padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Tipo servicio: ")),
                  Expanded(child: MediumText(appointment.service.type)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
              child: Row(
                children: <Widget>[
                  Expanded(child: MediumText("Duracion cita: ")),
                  Expanded(
                      child: MediumText(
                          appointment.service.duration.toString() + " minutos")),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
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
                    padding: EdgeInsets.fromLTRB(35.0, 10.0, 35.0, 0.0),
                      child: MediumText(
                        'Existe una penalización hacia usted en este negocio, pueden haber cambios en el precio final.',
                        color: Colors.orange,
                    ),
                  ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 35, 10, 0),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: ButtonTheme(
                        child: RaisedButton(
                          child: LargeText('Cancelar cita'),
                          onPressed: () {
                            ConnectionChecked.checkInternetConnectivity(context);
                            play();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        height: 60.0,
                        buttonColor: Color.fromRGBO(230, 73, 90, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ButtonTheme(
                        child: RaisedButton(
                          child: LargeText('Confirmar'),
                          onPressed: () {
                            ConnectionChecked.checkInternetConnectivity(context);
                            play();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        height: 60.0,
                        buttonColor: Color.fromRGBO(230, 73, 90, 1),
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
  }

  void play() async {
    await DBProvider.db.getUser();
    if (DBProvider.users.length > 0) lista = DBProvider.users;
    if (lista != null) {
      screen = Menu(lista[0]);
    }
    changeScreen();
  }

  changeScreen() {
    globalMethods().pushPage(context, ConfirmAnimation(appointment));
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
