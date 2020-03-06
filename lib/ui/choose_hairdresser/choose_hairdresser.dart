import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/ui/choose_date/chooseDate.dart';
import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser_presenter.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/ui/home/home.dart';
import 'package:cuthair/model/employe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../globalMethods.dart';

class chooseHairDresserScreen extends StatefulWidget {
  @override
  _chooseHairDresserScreenState createState() =>
      _chooseHairDresserScreenState();
}

class _chooseHairDresserScreenState extends State<chooseHairDresserScreen>
    implements ChooseHairDresserView {
  List<Employe> nombres = [];
  RemoteRepository _remoteRepository;
  ChooseHairDresserPresenter presenter;

  Widget title() {
    return Container(
      padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Seleccione un peluquero",
            style: TextStyle(
              color: Colors.white,
              fontSize: 23.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget goBack(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0.0, 20.0, 350.0, 0.0),
        child: GestureDetector(
          onTap: () {
            globalMethods().pushPage(context, Home());
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.navigate_before,
                color: Colors.white,
                size: 35.0,
              ),
            ],
          ),
        ));
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
              child: ButtonTheme(
                child: RaisedButton(
                  child: Text(
                    nombres[index].name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                  onPressed: () {
                    globalMethods().pushPage(context, chooseDateScreen());
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                ),
                height: 60.0,
                buttonColor: Color.fromRGBO(230, 73, 90, 1),
              ),
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
          children: <Widget>[goBack(context), title(), hairDressersButtons()],
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
}
