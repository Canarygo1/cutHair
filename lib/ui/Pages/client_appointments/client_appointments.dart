import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Components/small_text.dart';
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
  double HEIGHT;
  double WIDHT;

  @override
  initState() {
    super.initState();

    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = ClientAppointmentsPresenter(this, _remoteRepository);
    _presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
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
                padding: EdgeInsets.symmetric(horizontal: WIDHT * 0.06),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  color: Color.fromRGBO(60, 60, 62, 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(WIDHT * 0.025, HEIGHT * 0.01, WIDHT * 0.025, 0),
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
                        padding: EdgeInsets.only(left: WIDHT * 0.025, top: HEIGHT * 0.013),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                                  child: MediumText(myAppointments
                                      .elementAt(index)
                                      .hairdressing),
                                ),
                                Padding(
                                    padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                                    child: MediumText(
                                        myAppointments.elementAt(index).type)),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.62,
                                    padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                                    child: MediumText(
                                        //Direccion
                                        "Falta direccion")),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                                  child: MediumText(myAppointments
                                      .elementAt(index)
                                      .hairdresser),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: HEIGHT * 0.025, left: 1),
                              child: Column(
                                children: <Widget>[
                                  SmallText(DateTime.parse(myAppointments
                                              .elementAt(index)
                                              .checkIn)
                                          .day
                                          .toString() +
                                      "-" +
                                      DateTime.parse(myAppointments
                                              .elementAt(index)
                                              .checkIn)
                                          .month
                                          .toString() +
                                      "-" +
                                      DateTime.parse(myAppointments
                                              .elementAt(index)
                                              .checkIn)
                                          .year
                                          .toString()),
                                  Stack(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: HEIGHT * 0.006),
                                        child: SmallText(
                                          DateTime.parse(myAppointments
                                                      .elementAt(index)
                                                      .checkIn)
                                                  .hour
                                                  .toString() +
                                              ":" +
                                              getFullTimeIfHasOneValue(
                                                  DateTime.parse(myAppointments
                                                          .elementAt(index)
                                                          .checkIn)
                                                      .minute
                                                      .toString()),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: HEIGHT * 0.045),
                                        child: SmallText(DateTime.parse(
                                                    myAppointments
                                                        .elementAt(index)
                                                        .checkOut)
                                                .hour
                                                .toString() +
                                            ":" +
                                            getFullTimeIfHasOneValue(
                                                DateTime.parse(myAppointments
                                                        .elementAt(index)
                                                        .checkOut)
                                                    .minute
                                                    .toString())),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: HEIGHT * 0.01, left: WIDHT * 0.098),
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
                                        padding: EdgeInsets.only(top: HEIGHT * 0.005, left: WIDHT * 0.086),
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
                                        padding: EdgeInsets.only(top: HEIGHT * 0.048, left: WIDHT * 0.09),
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
                            onPressed: () {}),
                      ),
                    ],
                  ),
                ),
              );
            });
  }

  @override
  showAppointments(List<MyAppointment> myAppointment) {
    if (mounted) {
      setState(() {
        myAppointments = myAppointment;
      });
    }
  }

  getFullTimeIfHasOneValue(String time) {
    if (time.length == 1) {
      return time + "0";
    } else {
      return time;
    }
  }
}
