import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDateHairDressing.dart';
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
    if(appointment.business.typeBusiness == "Peluquerias"){
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.035),
              child: GoBack(context, "Volver"),
            ),
            appointment.business.typeBusiness == "Peluquerias" ? title("Seleccione un peluquero") : title("Seleccione el número de personas"),
            appointment.business.typeBusiness == "Peluquerias" ? hairDressersButtons() : chooseNumberClients(),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Container(
      padding: EdgeInsets.only(top: HEIGHT * 0.054),
      child: Align(
        alignment: Alignment.center,
        child: LargeText(text),
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
            return MyButton(
                () => chooseFunction(index), LargeText(employeeNames[index].name),
                color: Color.fromRGBO(230, 73, 90, 1));
          }),
    );
  }

  Widget chooseNumberClients(){
    int max = (appointment.business.maxPeople / 3).round();
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
                          number1 <= appointment.business.maxPeople ? Expanded(
                            child: MyButton(() => chooseTable(number1), LargeText(number1.toString()),
                                  color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0,),
                          ) : Container(),
                          number2 <= appointment.business.maxPeople ? Expanded(
                            child: MyButton(() => chooseTable(number2), LargeText(number2.toString()),
                                color: Color.fromRGBO(230, 73, 90, 1), horizontalPadding: 20.0),
                          ) : Container(),
                          number3 <= appointment.business.maxPeople ? Expanded(
                            child: MyButton(() => chooseTable(number3), LargeText(number3.toString()),
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
    GlobalMethods().pushPage(context, ChooseDateHairDressingScreen(appointment));
  }

  chooseFunction(int index) {
    appointment.employee = employeeNames[index];
    presenter.nextScreen(appointment);
  }

  chooseTable(int index){
    appointment.table = index.toString();
    presenter.nextScreen(appointment);
  }
}
