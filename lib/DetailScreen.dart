import 'package:cuthair/ConfirmScreen.dart';
import 'package:cuthair/DetailCita.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String nombrePeluqueria = "Privilege";
  String direccionPeluqueria = "Calle San Patricio";

  List<DetailCita> detallesServicio = [
    new DetailCita("Corte Cabello", 20, 15.65),
    new DetailCita("Rapado al estilo Llanero Solitario", 15, 10.42),
    new DetailCita("Tinte", 120, 35)
  ];

  @override
  Widget build(BuildContext context) {
    // Declaración de texto para la prueba de el boton
    detallesServicio.elementAt(0).peluquero = "Pedro";
    detallesServicio.elementAt(0).fechaCita = new DateTime(1992, 10, 15);
    detallesServicio.elementAt(0).horaCita = "16:00";

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
                    child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1.0,
                              endIndent: 0.0,
                              color: Colors.white,
                            ),
                          ),
                        ])
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.38,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: detallesServicio.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return new Card(
                      shape: BeveledRectangleBorder(side: BorderSide(color: Color.fromRGBO(300, 300, 300, 1))),
                        child: new Container(
                          color: Color.fromRGBO(300, 300, 300, 1),
                          child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(" "+ detallesServicio.elementAt(index).tipoServicio,
                              style: TextStyle(color: Colors.white, fontSize: 18.0),
                              textAlign: TextAlign.center),
                            Text(" "+ detallesServicio.elementAt(index).duracionServicio.toString() +
                                  " minutos",
                              style: TextStyle(color: Colors.white, fontSize: 16.0)),
                            Text(" "+ detallesServicio.elementAt(index).precioServicio.toString() + " €",
                              style: TextStyle(color: Colors.white, fontSize: 14.0)),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(

                                      thickness: 2.0,
                                      endIndent: 0.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ])
                            )
                        ],
                      ),
                    ));
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
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ConfirmScreen(detallesServicio.elementAt(0)
                    )));

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
