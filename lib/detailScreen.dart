import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/DetailPresenter.dart';
import 'package:cuthair/chooseHairDresser.dart';
import 'package:cuthair/data/remote/HttpRemoteRepository.dart';
import 'package:cuthair/data/remote/RemoteRepository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globalMethods.dart';
import 'home.dart';
import 'model/service.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> implements DetailView {
  Appointment appointment = Appointment();
  String nombrePeluqueria = "Privilege";
  String direccionPeluqueria = "Calle San Patricio";
  DetailPresenter presenter;
  RemoteRepository remoteRepository;
  List<Service> detallesServicio = [];

  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init();
  }

  Widget goBack(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 30.0, 350.0, 0.0),
        child: GestureDetector(
          onTap: () {
            globalMethods().pushPage(context, Home());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigate_before,
                color: Colors.black,
                size: 40.0,
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.33,
              child: Column(
                children: <Widget>[
                  goBack(context),
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: ExactAssetImage("assets/images/privilegeLogo.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(""),
                Text(nombrePeluqueria,
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
                Text(direccionPeluqueria,
                    style: TextStyle(color: Colors.white)),
                Container(
                    child: Row(children: [
                  Expanded(
                    child: Divider(
                      thickness: 1.0,
                      endIndent: 0.0,
                      color: Colors.white,
                    ),
                  ),
                ]))
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.50,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: detallesServicio.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        appointment.service = detallesServicio[index];
                        globalMethods().pushPage(
                            context, chooseHairDresserScreen(appointment));
                      },
                      child: new Card(
                          shape: BeveledRectangleBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(300, 300, 300, 1))),
                          child: new Container(
                            color: Color.fromRGBO(300, 300, 300, 1),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(" " + detallesServicio[index].tipo,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                    textAlign: TextAlign.center),
                                Text(
                                    " " +
                                        detallesServicio[index]
                                            .duracion
                                            .toString() +
                                        " minutos",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                Text(
                                    " " +
                                        detallesServicio[index]
                                            .precio
                                            .toString() +
                                        " €",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14.0)),
                                Container(
                                    child: Row(children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 2.0,
                                      endIndent: 0.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]))
                              ],
                            ),
                          )),
                    );
                  }),
            ),
          ],
        ));
  }

  @override
  showServices(List servicios) {
    setState(() {
      detallesServicio = servicios;
    });
  }
}
