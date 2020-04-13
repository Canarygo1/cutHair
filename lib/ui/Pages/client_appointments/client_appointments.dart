import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'client_appointments_presenter.dart';

class ClientAppointments extends StatefulWidget {
  @override
  _ClientAppointmentsState createState() => _ClientAppointmentsState();
}

class _ClientAppointmentsState extends State<ClientAppointments>
    implements MyAppointmentsView {
  List<MyAppointment> myAppointments = [];
  globalMethods global = globalMethods();
  RemoteRepository _remoteRepository;
  ClientAppointmentsPresenter _presenter;

  @override
  initState() {
    super.initState();

    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = ClientAppointmentsPresenter(this, _remoteRepository);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[Appbar("Mis citas"), myAppointment()],
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
                    padding: const EdgeInsets.only(left: 10, top: 10),
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
                                myAppointments.elementAt(index).hairdressing,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                  myAppointments.elementAt(index).type,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                            Container(
                              width:
                              MediaQuery.of(context).size.width * 0.62,
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                //Direccion
                                  "Falta direccion",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                  myAppointments.elementAt(index).hairdresser,
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
                              Text(
                                  DateTime.parse(myAppointments.elementAt(index).checkIn).day.toString() + "-" + DateTime.parse(myAppointments.elementAt(index).checkIn).month.toString() + "-" + DateTime.parse(myAppointments.elementAt(index).checkIn).year.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Stack(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      DateTime.parse(myAppointments.elementAt(index).checkIn).hour.toString() +  ":" + getFullTimeIfHasOneValue(DateTime.parse(myAppointments.elementAt(index).checkIn).minute.toString()),
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 35),
                                    child: Text(
                                      DateTime.parse(myAppointments.elementAt(index).checkOut).hour.toString() +  ":" + getFullTimeIfHasOneValue(DateTime.parse(myAppointments.elementAt(index).checkOut).minute.toString()),
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

  getFullTimeIfHasOneValue(String time){
    if(time.length == 1){
      return time + "0";
    }else{
      return time;
    }
  }
}
