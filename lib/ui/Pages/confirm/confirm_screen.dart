import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/Pages/bottom_navigation/menu.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'confirm_screen_presenter.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment appointment;


  ConfirmScreen(this.appointment);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState(appointment);
}

class _ConfirmScreenState extends State<ConfirmScreen> implements ConfirmScreenView {
  Appointment appointment;
  RemoteRepository _remoteRepository;
  ConfirmScreenPresenter _confirmScreenPresenter;
  Widget screen;
  List<User> lista;
  _ConfirmScreenState(this.appointment);

  initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _confirmScreenPresenter = ConfirmScreenPresenter(this,_remoteRepository);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20.0, 120.0, 35.0, 20.0),
              child: Text("¿Desea confirmar la cita?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ))),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 30.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Peluquero: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.employe.name,
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Dia: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.checkIn.day.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Hora: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.checkIn.hour.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Tipo servicio: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.service.tipo,
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Duracion cita: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.service.duracion.toString() + " minutos",
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100.0, 10.0, 35.0, 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text("Precio cita: ",
                        style: TextStyle(color: Colors.white, fontSize: 17.0))),
                Expanded(
                  child: Text(appointment.service.precio.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 17.0)),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 45, 10, 0),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: ButtonTheme(
                      child: RaisedButton(
                        child: Text(
                          'Cancelar cita',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          play();
                          Toast.show(
                            "Cancelar",
                            context,
                            gravity: Toast.BOTTOM,
                            textColor: Colors.black,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                      height: 60.0,
                      minWidth: 150,
                      buttonColor: Color.fromRGBO(230, 73, 90, 1),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ButtonTheme(
                      child: RaisedButton(
                        child: Text(
                          'Confirmar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          play();
                          _confirmScreenPresenter.init(appointment);
                          Toast.show(
                            "Cita reservada",
                            context,
                            gravity: Toast.BOTTOM,
                            textColor: Colors.black,
                            duration: Toast.LENGTH_LONG,
                            backgroundColor: Color.fromRGBO(230, 73, 90, 0.7),
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                        ),
                      ),
                      height: 60.0,
                      minWidth: 150,
                      buttonColor: Color.fromRGBO(230, 73, 90, 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void play() async {
    await DBProvider.db.getUser();
    if(DBProvider.users.length > 0) lista = DBProvider.users;
    if (lista != null) {
      screen = Menu(lista[0]);
    }
    new Timer(Duration(seconds: 1), changeScreen);
  }

  changeScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
