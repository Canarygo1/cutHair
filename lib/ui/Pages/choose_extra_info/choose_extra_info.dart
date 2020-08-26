import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/ui/BusinessComponents/HairDressing/main_class_hairdressing.dart';
import 'package:cuthair/ui/BusinessComponents/Restaurant/main_class_restaurant.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/choose_date/choose_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'choose_extra_info_presenter.dart';

class ChooseExtraInfoScreen extends StatefulWidget {
  Appointment appointment;

  ChooseExtraInfoScreen(this.appointment);

  @override
  _ChooseExtraInfoScreenState createState() =>
      _ChooseExtraInfoScreenState(appointment);
}

class _ChooseExtraInfoScreenState extends State<ChooseExtraInfoScreen>
    implements ChooseHairDresserView {
  Appointment appointment;
  List<Employee> employeeNames = [];
  RemoteRepository _remoteRepository;
  ChooseExtraInfoPresenter presenter;
  double HEIGHT;
  double WIDHT;

  _ChooseExtraInfoScreenState(this.appointment);

  @override
  void initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = ChooseExtraInfoPresenter(this, _remoteRepository);
    if(appointment.business.typeBusiness == "Peluquerías"){
      presenter.init(appointment.business.uid, appointment.business.typeBusiness);
    }
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        leading: GoBack(
          context,
          "",
          HEIGHT: HEIGHT * 0.013,
        ),
        title: LargeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            getExtraInfoScreen()
          ],
        ),
      ),
    );
  }

  Widget getExtraInfoScreen(){
    if(appointment.business.typeBusiness == "Peluquerías"){
      return ChooseExtraInfoHairDressing().getExtraInfoHairDressing(appointment, this.employeeNames, presenter, HEIGHT, WIDHT);
    }else{
      return ChooseExtraInfoRestaurant().getExtraInfoRestaurant(appointment, this.employeeNames, presenter, HEIGHT, WIDHT);
    }
  }

  @override
  showEmployes(List employes) {
    if (mounted) {
      setState(() {
        employeeNames = employes;
      });
    }
  }

  @override
  goToCalendar() {
      GlobalMethods().pushPage(context, ChooseDateScreen(appointment));
  }

  chooseFunction(int index) {
    appointment.employee = employeeNames[index];
    presenter.nextScreen(appointment);
  }

  chooseNumberPersons(int index){
    appointment.numberPersons = index.toString();
    presenter.nextScreen(appointment);
  }
}
