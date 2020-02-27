import 'package:cuthair/confirmScreen.dart';
import 'package:cuthair/chooseHairDresser.dart';
import 'package:cuthair/model/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'globalMethods.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String nombrePeluqueria = "Privilege";
  String direccionPeluqueria = "Calle San Patricio";

  List<Service> detallesServicio = [
    new Service("Corte Cabello", 20, 15.65),
    new Service("Rapado al estilo Llanero Solitario", 15, 10.42),
    new Service("Tinte", 120, 35),
    new Service("Barba", 120, 35),
    new Service("Cejas", 120, 35)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Column(
          children: <Widget>[
            Image(
              image: ExactAssetImage("assets/images/privilegeLogo.jpg"),
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
              height: MediaQuery.of(context).size.height * 0.38,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: detallesServicio.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        globalMethods()
                            .pushPage(context, chooseHairDresserScreen());
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
                                Text(
                                    " " +
                                        detallesServicio.elementAt(index).tipo,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0),
                                    textAlign: TextAlign.center),
                                Text(
                                    " " +
                                        detallesServicio
                                            .elementAt(index)
                                            .duracion
                                            .toString() +
                                        " minutos",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0)),
                                Text(
                                    " " +
                                        detallesServicio
                                            .elementAt(index)
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 26, 0, 0),
              child: ButtonTheme(
                child: RaisedButton(
                  child: Text(
                    'Reservar cita',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {

                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
                height: 60.0,
                minWidth: 200,
                buttonColor: Color.fromRGBO(230, 73, 90, 1),
              ),
            )
          ],
        ));
  }
}
