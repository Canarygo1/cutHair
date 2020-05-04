import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../Components/button.dart';
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
  List<Employee> nombres = [];
  RemoteRepository _remoteRepository;
  ChooseHairDresserPresenter presenter;
  double HEIGHT;
  double WIDHT;

  _chooseHairDresserScreenState(this.appointment);

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ChooseHairDresserPresenter(this, _remoteRepository);
    presenter.init(appointment.hairDressing.uid, appointment.hairDressing.typeBusiness);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
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

  Widget title() {
    return Container(
      padding: EdgeInsets.only(top: HEIGHT * 0.054),
      child: Align(
        alignment: Alignment.center,
        child: LargeText("Seleccione un peluquero"),
      ),
    );
  }

  Widget hairDressersButtons() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: WIDHT * 0.043, vertical: HEIGHT * 0.027),
      height: HEIGHT * 0.80,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: nombres.length,
          itemBuilder: (context, index) {
            return MyButton(
                  () => chooseFunction(index), LargeText(nombres[index].name),);
          }),
    );
  }

  @override
  showEmployes(List employes) {
    if (mounted) {
      setState(() {
        nombres = employes;
      });
    }
  }

  @override
  goToCalendar() {
    GlobalMethods()
          .pushPage(context, ChooseDateScreen(appointment));
  }

  chooseFunction(int index){
    appointment.employe = nombres[index];
    presenter.nextScreen(appointment);
  }
}
