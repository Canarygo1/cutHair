import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDateHairDressing.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDateRestaurant.dart';
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
        leading: Components.goBack(
          context,
          "",
        ),
        title: Components.largeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            appointment.business.typeBusiness == "Peluquerías" ? title("Seleccione un peluquero") : title("Seleccione el número de personas"),
            getExtraInformation()
          ],
        ),
      ),
    );
  }

  Widget getExtraInformation(){
    if(appointment.business.typeBusiness == "Peluquerías"){
      return hairDressersButtons();
    }else{
      return chooseNumberClients(appointment.business.maxPeople);
    }

  }

  Widget title(String text) {
    return Container(
      padding: EdgeInsets.only(top: HEIGHT * 0.054),
      child: Align(
        alignment: Alignment.center,
        child: Components.largeText(text),
      ),
    );
  }

  Widget hairDressersButtons() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: WIDHT * 0.043, vertical: HEIGHT * 0.027),
      height: HEIGHT * 0.80,
      child: ListView.builder(
        shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.vertical,
          itemCount: employeeNames.length,
          itemBuilder: (context, index) {
            return Components.smallButton(
                () => chooseFunction(index), Components.largeText(employeeNames[index].name),
                color: Color.fromRGBO(230, 73, 90, 1));
          }),
    );
  }

  Widget chooseNumberClients(int numero){
    int max = (numero / 3).round() + 1;
    return Container(
          padding: EdgeInsets.symmetric(
              horizontal: WIDHT * 0.087, vertical: HEIGHT * 0.027),
            height: HEIGHT * 0.80,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: max,
                    itemBuilder: (context, index){
                    int number1 = index * 3 + 1;
                    int number2 = index * 3 + 2;
                    int number3 = index * 3 + 3;

                      return Row(
                        children: <Widget>[
                          number1 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number1), Components.largeText(number1.toString()),
                                  color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0,),
                          ) : Container(),
                          number2 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number2), Components.largeText(number2.toString()),
                                color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0),
                          ) : Container(),
                          number3 <= numero ? Expanded(
                            child: Components.smallButton(() => chooseNumberPersons(number3), Components.largeText(number3.toString()),
                                color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0),
                          ) : Container()
                         ]);
                  })],
            ),
          ));
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
    if(appointment.business.typeBusiness == "Peluquerías"){
      GlobalMethods().pushPage(context, ChooseDateHairDressingScreen(appointment));
    }else{
      GlobalMethods().pushPage(
          context, ChooseDateRestaurantScreen(appointment));
    }
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
