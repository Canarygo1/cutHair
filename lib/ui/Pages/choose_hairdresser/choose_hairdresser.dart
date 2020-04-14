import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/ui/Components/goback.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDate.dart';
import 'package:cuthair/ui/Pages/time_selection/time_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'choose_hairdresser_presenter.dart';

class chooseHairDresserScreen extends StatefulWidget {
  Appointment appointment;

  chooseHairDresserScreen(this.appointment);

  @override
  _chooseHairDresserScreenState createState() =>
      _chooseHairDresserScreenState(appointment);
}

class _chooseHairDresserScreenState extends State<chooseHairDresserScreen>
    implements ChooseHairDresserView {
  Appointment appointment;
  List<Employe> nombres = [];
  RemoteRepository _remoteRepository;
  ChooseHairDresserPresenter presenter;

  _chooseHairDresserScreenState(this.appointment);

  Widget title() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: Align(
        alignment: Alignment.center,
        child: LargeText("Seleccione un peluquero"),
      ),
    );
  }

  Widget hairDressersButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 20.0),
      height: MediaQuery.of(context).size.height * 0.80,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: nombres.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.fromLTRB(40.0, 0.0, 35.0, 20.0),
              child: FlatButton(
                color: Color.fromRGBO(230, 73, 90, 1),
                child: MediumText(nombres[index].name),
                onPressed: () {
                  appointment.employe = nombres[index];
                  if (appointment.user.permission == 3) {
                    globalMethods()
                        .pushPage(context, chooseDateScreen(appointment));
                  }
                  if (appointment.user.permission == 1) {
                    globalMethods()
                        .pushPage(context, TimeSelection(appointment));
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.11,
            );
          }),
    );
  }

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ChooseHairDresserPresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        child: ListView(
          children: <Widget>[
            GoBack(context, "Volver"),
            title(),
            hairDressersButtons()
          ],
        ),
      ),
    );
  }

  @override
  showEmployes(List employes) {
    setState(() {
      nombres = employes;
    });
  }

  @override
  goToNextScreen(int index) {
    return null;
  }
}
