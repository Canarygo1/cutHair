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
  var url;
  Appointment appointment = Appointment();
  String nombrePeluqueria = "Privilege";
  String direccionPeluqueria = "Calle San Patricio";
  DetailPresenter presenter;
  RemoteRepository remoteRepository;
  List<Service> detallesServicio = [];

  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    getImagen();
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Column(
          children: <Widget>[
            url != null
                ? Image.network(url)
                : Image(
                    image: ExactAssetImage('assets/images/Login.jpg')),
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

  getImagen() async {
    String nombreimagen = "privilege/privilege1.jpeg";
    var ref = FirebaseStorage.instance.ref().child(nombreimagen);
    //ref.getMetadata().
    //Directory direct = ref.getParent().
    url = await ref.getDownloadURL();
    print(url);
  }

  @override
  showServices(List servicios) {
    setState(() {
      detallesServicio = servicios;
    });
  }
}
