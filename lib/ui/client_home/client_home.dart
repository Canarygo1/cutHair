import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/client_home/my_appointments_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ClienteHome extends StatefulWidget {
  @override
  _ClienteHomeState createState() => _ClienteHomeState();
}

class _ClienteHomeState extends State<ClienteHome>
    implements MyAppointmentsView {
  List<MyAppointment> myAppointments = [];
  globalMethods global = globalMethods();
  RemoteRepository _remoteRepository;
  MyAppointmentsPresenter _presenter;

  @override
  initState() {
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = MyAppointmentsPresenter(this, _remoteRepository);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[topTitle(), myAppointment()],
      ),
    );
  }

  Widget topTitle() {
    return Container(
      height: 90,
      color: Color.fromRGBO(230, 73, 90, 1),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 40, 0, 0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "Mis citas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget myAppointment() {
    return myAppointments.length == 0
        ? SpinKitPulse(
            color: Colors.red,
          )
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: 1,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)
                  ),
                  color: Color.fromRGBO(60, 60, 62, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                                aspectRatio: 50.0 / 11.0,
                                child: Image.asset(
                                  "assets/images/privilegeLogo.jpg",
                                  fit: BoxFit.cover,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                    "Peluqueria Privilege",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.62,
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text(
                                      "Direccion Avenida de los Majuelos 54",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Peluquero Carlos",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: Text("Servicio Corte",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 19, left: 1),
                              child: Column(
                                children: <Widget>[
                                  Text("17-05-2020",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          "12:30",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 35),
                                        child: Text(
                                          "13:00",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, left: 38),
                                        child: Container(
                                            height: 30,
                                            child: VerticalDivider(
                                              indent: 5,
                                              thickness: 1.1,
                                              width: 4,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 34.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Color.fromRGBO(
                                                      230, 73, 90, 1),
                                                  width: 7)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 37, left: 35),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 5)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color.fromRGBO(230, 73, 90, 1),
                            onPressed: () {
                              print("Hola");
                            }),
                      ),
                    ],
                  ),
                ),
              );
            });
  }

  @override
  showAppointments(List<MyAppointment> myAppointment) {
    setState(() {
      myAppointments = myAppointment;
    });
  }
}
