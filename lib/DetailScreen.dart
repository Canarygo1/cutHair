import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String nombrePeluqueria = "Privilege";
  String direccionPeluqueria = "Calle tu madre";

  List<String> tipoServicio = [
    'Corte Cabello',
    'Rapado al estilo Llanero Solitario'
  ];
  List<int> duracionServicio = [20, 15];
  List<double> precioServicio = [15.65, 10.42];

  @override
  Widget build(BuildContext context) {
    print(tipoServicio);
    print(duracionServicio);
    print(precioServicio);

    return Scaffold(
        backgroundColor: Colors.grey,
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image(
              fit: BoxFit.fill,
              height: 10,
              width: 10,
              image: ExactAssetImage("assets/images/privilegeLogo.jpg"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(nombrePeluqueria,
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
                Text(direccionPeluqueria,
                    style: TextStyle(color: Colors.white)),
                Text("")
              ],
            ),
            Container(
              child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(tipoServicio.elementAt(index),
                              style: TextStyle(color: Colors.white)),
                          Text(
                              duracionServicio.elementAt(index).toString(),
                              style: TextStyle(color: Colors.white)),
                          Text(
                              precioServicio.elementAt(index).toString(),
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    );
                  }),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Tinte", style: TextStyle(color: Colors.white)),
                Text("Duracion: 40 minutos",
                    style: TextStyle(color: Colors.white)),
                Text("30.00€", style: TextStyle(color: Colors.white))
              ],
            ),
            /*Container(
              alignment: FractionalOffset.bottomCenter,
              child: ButtonTheme(
                  child: RaisedButton(
                      child: Text(
                        'Reservar cita',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                      )),
                  height: 50.0,
                  minWidth: 200.0,
                  buttonColor: Color.fromRGBO(230, 73, 90, 1)),
            )*/
          ],
        ));
  }
}
