import 'dart:async';

import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/bottom_navigation/menu.dart';
import 'package:cuthair/ui/login/login.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ConfirmScreen extends StatefulWidget {
  Appointment detallesCita;

  ConfirmScreen(this.detallesCita);

  @override
  _ConfirmScreenState createState() => _ConfirmScreenState(detallesCita);
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  Appointment details;
  List<User> lista = [];
  Widget screen;
  _ConfirmScreenState(this.details);

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
                  child: Text(details.employe.name,
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
                  child: Text(details.checkIn.day.toString(),
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
                  child: Text(details.checkIn.hour.toString(),
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
                  child: Text(details.service.tipo,
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
                  child: Text(details.service.duracion.toString() + " minutos",
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
                  child: Text(details.service.precio.toString(),
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
                          'Cancelar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: () {
                          play();
                          Toast.show(
                            "Cita cancelada",
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
    if(DBProvider.listaNueva.length > 0) lista = DBProvider.listaNueva;
    if (lista != null) {
      screen = Menu(lista[0]);
    }
    new Timer(Duration(seconds: 1), changeScreen);
  }

  changeScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }
}
