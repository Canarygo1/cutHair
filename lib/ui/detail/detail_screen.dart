import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/ui/detail/detail_presenter.dart';
import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../global_methods.dart';

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
  List<String> listaImagenesFirebase = [];

  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Column(
          children: <Widget>[
            FutureBuilder(
                future: cargarImagenes(),
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.none &&
                      snapshot.hasData == null) || listaImagenesFirebase.isEmpty) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        margin: EdgeInsets.only(right: 5),
                        child: new Image(
                            image:
                                AssetImage('assets/images/noencontrado.jpg')));
                  }else {
                    return getListImages();
                  }
                }),
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
          ],
        ));
  }

  getListImages() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.38,
        child: ListView.builder(
            itemCount: listaImagenesFirebase.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return getUnicaImagen(position);
            }));
  }

  getUnicaImagen(int index) {
    String url = listaImagenesFirebase.elementAt(index);
    print(url);

    return new Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 5),
        child: Card(
          child: Wrap(
            children: <Widget>[
              url != null
                  ? new Image.network(url, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.38)
                  : new Image(
                      image: AssetImage('assets/images/noencontrado.jpg'))
            ],
          ),
        ));
  }

  cargarImagenes() async {
    List<String> lista = [];
    listaImagenesFirebase = [];

    //cambiar el 7 por el valor del hairDressing
    for (int i = 0; i < 7; i++) {
      //modificar nombre para la utilización de la carpeta según la peluqueria
      String nombre = "PRO1/" + i.toString() + ".jpeg";
      String url = await FirebaseStorage.instance.ref().child(nombre).getDownloadURL();
      lista.add(url);
    }

    listaImagenesFirebase = lista;
  }

  @override
  showServices(List servicios) {
    setState(() {
      detallesServicio = servicios;
    });
  }
}
