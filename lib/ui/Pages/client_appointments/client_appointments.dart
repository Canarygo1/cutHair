import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Components/upElements/appbar.dart';
import 'package:cuthair/ui/Components/confirm_dialog.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'client_appointments_presenter.dart';

class ClientAppointments extends StatefulWidget {
  @override
  _ClientAppointmentsState createState() => _ClientAppointmentsState();
}

class _ClientAppointmentsState extends State<ClientAppointments>
    implements MyAppointmentsView {
  List<MyAppointment> myAppointments = [];
  GlobalMethods global = GlobalMethods();
  RemoteRepository _remoteRepository;
  ClientAppointmentsPresenter _presenter;
  bool isConsulting = false;
  double HEIGHT;
  double WIDHT;
  ConfirmDialog confirmDialog;
  List<String> allImages;

  @override
  initState() {
    allImages = [];
    super.initState();
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = ClientAppointmentsPresenter(this, _remoteRepository);
    isConsulting = true;
    _presenter.init(DBProvider.users[0].uid);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[Appbar("Mis citas"), myAppointment()],
        ),
      ),
    );
  }

  Widget myAppointment() {
    return isConsulting == true
        ? SpinKitWave(
            color: Color.fromRGBO(230, 73, 90, 1),
            type: SpinKitWaveType.start,
          )
        : myAppointments.length == 0
            ? Center(
                child: Column(
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/sad.svg",
                      width: WIDHT * 0.229,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: HEIGHT * 0.03),
                      child: Column(
                        children: <Widget>[
                          MediumText(
                              "Vaya! Parece que todavia no tienes citas reservadas"),
                          MediumText("Pruedes reservarlas en el home"),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: myAppointments.length,
                itemBuilder: (context, index) {
                  if(myAppointments.elementAt(index).typeBusiness == "Peluquerias"){
                    return cardWithCheckOut(index, context);
                  }else{
                    return card(index, context);
                  }
                });
  }

  Padding cardWithCheckOut(int index, BuildContext context){
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
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.025, HEIGHT * 0.01, WIDHT * 0.025, 0),
              child: Column(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 50.0 / 11.0,
                      child: Image.network(
                        allImages.elementAt(index),
                        fit: BoxFit.cover,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: WIDHT * 0.025, top: HEIGHT * 0.013),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: HEIGHT * 0.006),
                        child: MediumText(myAppointments
                            .elementAt(index)
                            .businessName),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: HEIGHT * 0.006),
                          child: MediumText(myAppointments
                              .elementAt(index)
                              .type)),
                      Container(
                          width: WIDHT * 0.62,
                          padding: EdgeInsets.symmetric(
                              vertical: HEIGHT * 0.006),
                          child: MediumText(myAppointments
                              .elementAt(index)
                              .direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: HEIGHT * 0.006),
                        child: MediumText(myAppointments
                            .elementAt(index)
                            .extraInformation),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: HEIGHT * 0.025, left: 1),
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
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.006),
                              child: SmallText(
                                DateTime.parse(myAppointments
                                    .elementAt(index)
                                    .checkIn)
                                    .hour
                                    .toString() +
                                    ":" +
                                    getFullTimeIfHasOneValue(
                                        DateTime.parse(
                                            myAppointments
                                                .elementAt(
                                                index)
                                                .checkIn)
                                            .minute
                                            .toString()),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.045),
                              child: SmallText(DateTime.parse(
                                  myAppointments
                                      .elementAt(index)
                                      .checkOut)
                                  .hour
                                  .toString() +
                                  ":" +
                                  getFullTimeIfHasOneValue(
                                      DateTime.parse(
                                          myAppointments
                                              .elementAt(
                                              index)
                                              .checkOut)
                                          .minute
                                          .toString())),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.01,
                                  left: WIDHT * 0.098),
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
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.005,
                                  left: WIDHT * 0.086),
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
                              padding: EdgeInsets.only(
                                  top: HEIGHT * 0.048,
                                  left: WIDHT * 0.09),
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
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13.0)),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white),
                ),
                color: Color.fromRGBO(230, 73, 90, 1),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    confirmDialog = ConfirmDialog(
                      MediumText("¿Desea cancelar la cita?"),
                          () => {
                        ConnectionChecked
                            .checkInternetConnectivity(context),
                        _presenter.removeAppointment(
                            myAppointments[index],
                            index,
                            DBProvider.users[0].uid),
                        GlobalMethods()
                            .popPage(confirmDialog.context),
                      },
                    );
                    return confirmDialog;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding card(int index, BuildContext context) {
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
                          padding: EdgeInsets.fromLTRB(
                              WIDHT * 0.025, HEIGHT * 0.01, WIDHT * 0.025, 0),
                          child: Column(
                            children: <Widget>[
                              AspectRatio(
                                  aspectRatio: 50.0 / 11.0,
                                  child: Image.asset(
                                    allImages.elementAt(index),
                                    fit: BoxFit.cover,
                                  ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: WIDHT * 0.025, top: HEIGHT * 0.013),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: HEIGHT * 0.006),
                                    child: MediumText(myAppointments
                                        .elementAt(index)
                                        .businessName),
                                  ),
                                  Container(
                                      width: WIDHT * 0.62,
                                      padding: EdgeInsets.symmetric(
                                          vertical: HEIGHT * 0.006),
                                      child: MediumText(myAppointments
                                          .elementAt(index)
                                          .direction)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: HEIGHT * 0.006),
                                    child: MediumText("Nº personas: "+ myAppointments
                                        .elementAt(index)
                                        .extraInformation),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: HEIGHT * 0.025, left: 1),
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
                                          padding: EdgeInsets.only(
                                              top: HEIGHT * 0.006),
                                          child: SmallText(
                                            DateTime.parse(myAppointments
                                                        .elementAt(index)
                                                        .checkIn)
                                                    .hour
                                                    .toString() +
                                                ":" +
                                                getFullTimeIfHasOneValue(
                                                    DateTime.parse(
                                                            myAppointments
                                                                .elementAt(
                                                                    index)
                                                                .checkIn)
                                                        .minute
                                                        .toString()),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.0)),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Color.fromRGBO(230, 73, 90, 1),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                confirmDialog = ConfirmDialog(
                                  MediumText("¿Desea cancelar la cita?"),
                                  () => {
                                    ConnectionChecked
                                        .checkInternetConnectivity(context),
                                    _presenter.removeAppointment(
                                        myAppointments[index],
                                        index,
                                        DBProvider.users[0].uid),
                                    GlobalMethods()
                                        .popPage(confirmDialog.context),
                                  },
                                );
                                return confirmDialog;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
  }

  @override
  showAppointments(List<MyAppointment> myAppointment) {
    if (mounted) {
      setState(() {
        isConsulting = false;
        myAppointments = myAppointment;
      });
    }
  }

  @override
  showImages(List<String> allImages){
    if(mounted) {
      setState(() {
        this.allImages = allImages;
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

  @override
  emptyAppointment() {
    if (mounted) {
      setState(() {
        isConsulting = false;
        myAppointments = [];
      });
    }
  }
}
