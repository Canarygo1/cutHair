import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/ui/Components/card_elements/card_with_checkOut.dart';
import 'package:cuthair/ui/Components/card_elements/card_without_checkOut.dart';
import 'package:cuthair/ui/Components/upElements/appbar.dart';
import 'package:cuthair/ui/Components/confirm_dialog.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
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
                    return CardWithCheckOut(index, () => functionRemove(index), allImages, myAppointments);
                  }else{
                    return CardWithoutCheckOut(index, () => functionRemove(index), allImages, myAppointments);
                  }
                });
  }

  functionRemove(int index){
    showDialog(
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
