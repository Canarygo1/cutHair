import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Components/small_text.dart';
import 'package:cuthair/ui/Pages/choose_date/chooseDate.dart';
import 'package:cuthair/ui/Pages/confirm/confirm_screen.dart';
import 'package:cuthair/ui/Pages/time_selection/time_selection_presenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeSelection extends StatefulWidget {
  Appointment appointment;

  TimeSelection(this.appointment);

  @override
  _TimeSelectionState createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection>
    implements TimeSelectionView {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  bool condition = false;
  User user;
  int positionSelected;
  RemoteRepository _remoteRepository;
  TimeSelectionPresenter _presenter;
  bool buttonCondition = false;

  @override
  void initState() {
    widget.appointment.user;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _presenter = TimeSelectionPresenter(this, _remoteRepository);
    super.initState();
  }

  var timer = {
    "show": [
      "0:10",
      "0:20",
      "0:30",
      "0:40",
      "0:50",
      "1:00",
      "1:10",
      "1:20",
      "1:30",
      "1:40",
      "1:50",
      "2:00",
      "2:10",
      "2:20",
      "2:30",
      "2:40",
      "2:50",
      "3:00"
    ],
    "insert": [
      "10",
      "20",
      "30",
      "40",
      "50",
      "60",
      "70",
      "80",
      "90",
      "100",
      "110",
      "120",
      "130",
      "140",
      "150",
      "160",
      "170",
      "180",
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(44, 45, 47, 1),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05),
              child: cardInfo(),
            ),
            timeSelector(),
            numberTextField(),
            condition == false
                ? Container()
                : userInfo(),
          ],
        ),
      ),
    );
  }

  Widget userInfo() {
    return user != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.34),
                child: MediumText("Datos de reserva"),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.34,
                top: MediaQuery.of(context).size.width * 0.05),
                child: MediumText(user.name + " " + user.surname),
              ),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.34),
                child: MediumText(user.email),
              ),
              Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.34),
                child: MediumText(user.phone),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
                child: Center(child: sendButton()),
              )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.15),
                child: MediumText("Introduce un nombre para crear la cita"),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: nameController,
                  cursorColor: Color.fromRGBO(230, 73, 90, 1),
                  decoration: InputDecoration(
                      hintText: "Nombre de la cita",
                      hintStyle: TextStyle(color:Colors.white),
                      counterStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Color.fromRGBO(230, 73, 90, 1))
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color:Color.fromRGBO(230, 73, 90, 1))
                      )),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.15),
                child: Center(child: sendButton()),
              )
            ],
          );
  }

  Widget numberTextField() {
    return Padding(
      padding: EdgeInsets.only(top:MediaQuery.of(context).size.width * 0.1),
      child: TextField(
        textAlign: TextAlign.center,
        controller: phoneController,
          cursorColor: Color.fromRGBO(230, 73, 90, 1),
          decoration: InputDecoration(
              counterStyle: TextStyle(color: Colors.white),
              hintText: "Número de teléfono",
              hintStyle: TextStyle(color:Colors.white),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color:Color.fromRGBO(230, 73, 90, 1))
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:Color.fromRGBO(230, 73, 90, 1))
              )),
          style: TextStyle(color: Colors.white),
          maxLength: 9,
          onChanged: (content) => onSizeChange(content)),
    );
  }

  Widget cardInfo() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.1),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03),
          child: Container(
            child: Card(
              color: Color.fromRGBO(230, 73, 90, 1),
              child: Padding(
                padding:  EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height *0.02),
                child: Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                               left: MediaQuery.of(context).size.width * 0.1),
                          child: MediumText("Tipo"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                               left: MediaQuery.of(context).size.width * 0.1),
                          child: SmallText(widget.appointment.service.type),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                               left: MediaQuery.of(context).size.width * 0.1),
                          child: MediumText("Duracion"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                               left: MediaQuery.of(context).size.width * 0.1),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.04),
                            child: SmallText(positionSelected == null
                                ? " "
                                : timer["show"][positionSelected]),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                               left: MediaQuery.of(context).size.width * 0.1),
                          child: MediumText("Nombre"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.12),
                          child: SmallText(user == null ? " " : user.name),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget timeSelector() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.3,
              right: MediaQuery.of(context).size.width * 0.3
            ),
            child: MediumText(
              "Duracion del servicio",
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 4),
            height: MediaQuery.of(context).size.height * 0.07,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: timer["show"].length,
                itemBuilder: (context, index) {
                  return Container(
                    child: GestureDetector(
                      onTap: () => timeSelection(index),
                      child: Card(
                          color: positionSelected == index
                              ? Color.fromRGBO(230, 73, 90, 1)
                              : Color.fromRGBO(230, 73, 90, 0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(child: Text(timer["show"][index])),
                          )),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }



  timeSelection(int hourIndex) {
    setState(() {
      positionSelected = hourIndex;
    });
  }

  onSizeChange(content) {
    if (content.length >= 9) {
      FocusScope.of(context).requestFocus(new FocusNode());
      _presenter.phoneNumberCheck(content);
      setState(() {
        condition = true;
      });
    }
  }
  Widget sendButton() {
    return FlatButton(
      color: Color.fromRGBO(230, 73, 90, 1),
      child: MediumText(user == null ? "Crear":"Confirmar"),
      onPressed: () => onSendClicked(),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(10.0),
      ),
    );
  }
  onSendClicked(){
    _presenter.checkUser(user,positionSelected,nameController.text,phoneController.text);
  }
  @override
  userNotExist() {
    setState(() {
      this.user = null;
      this.buttonCondition = true;
    });
  }
  
  @override
  userExist(User user) {
    setState(() {
      this.buttonCondition = false;
      this.user = user;
    });
  }

  @override
  goToNextScreen(User user) {
    widget.appointment.user = user;
    widget.appointment.service.duration = timer["insert"][positionSelected];
    globalMethods().pushPage(context, chooseDateScreen(widget.appointment));
  }

  @override
  userCreated(user) {
    setState(() {
      this.buttonCondition = false;
      this.user = user;
    });
  }
}
