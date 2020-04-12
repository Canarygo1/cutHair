import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/ui/detail/detail_presenter.dart';
import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../global_methods.dart';

class DetailScreen extends StatefulWidget {
  HairDressing hairDressing;

  DetailScreen(this.hairDressing);

  @override
  _DetailScreenState createState() => _DetailScreenState(hairDressing);
}

class _DetailScreenState extends State<DetailScreen> implements DetailView {
  HairDressing hairDressing;
  Appointment appointment = Appointment();
  DetailPresenter presenter;
  RemoteRepository remoteRepository;
  List<Service> detallesServicio = [];
  List<String> listaImagenesFirebase = [];
  List<Widget> child = [];

  _DetailScreenState(this.hairDressing);

  int _current = 0;


  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init(hairDressing);
    print(child.length);
  }

  List<Widget> getChilds() {
    List prueba = map<Widget>(listaImagenesFirebase, (index, i) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(children: <Widget>[
            Image.network(i, fit: BoxFit.cover, width: 1000.0),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'No. $index image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    }).toList();
    return prueba;
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            sliderImages(context),
            Column(
              children: <Widget>[
                Text(""),
                Text(hairDressing.name,
                    style: TextStyle(color: Colors.white, fontSize: 22.0)),
                Text(hairDressing.direction,
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            ListView.builder(
              itemCount: detallesServicio.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {

                    appointment.service = detallesServicio[index];
                    appointment.hairDressing = hairDressing;

                    globalMethods().pushPage(
                        context, chooseHairDresserScreen(appointment));
                  },
                  child: new Card(
                    elevation: 0.0,
                    shape: BeveledRectangleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(300, 300, 300, 1))),
                    child: new Container(
                      color: Color.fromRGBO(300, 300, 300, 1),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(" " + detallesServicio.elementAt(index).tipo,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                              textAlign: TextAlign.center),
                          Text(
                              " " +
                                  detallesServicio
                                      .elementAt(index)
                                      .duracion
                                      .toString() +
                                  " minutos",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16.0)),
                          Text(
                              " " +
                                  detallesServicio
                                      .elementAt(index)
                                      .precio
                                      .toString() +
                                  " €",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 14.0)),
                          Container(
                              child: Row(children: [
                            Expanded(
                              child: Divider(
                                thickness: 1.0,
                                endIndent: 10.0,
                                indent: 5.0,
                                color: Colors.white,
                              ),
                            ),
                          ]))
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  showServices(List servicios) {
    setState(() {
      detallesServicio = servicios;
    });
  }

  @override
  showImages(List imagenes) {
    setState(() {
      listaImagenesFirebase = imagenes;
      child = getChilds();
    });
  }

  Widget sliderImages(BuildContext context) {
    if (child.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: Column(children: [
          CarouselSlider(
            height: MediaQuery.of(context).size.height * 0.25,
            items: child,
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index) {
              setState(() {
                _current = index;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              listaImagenesFirebase,
              (index, url) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == index
                          ? Color.fromRGBO(230, 73, 90, 1)
                          : Colors.white),
                );
              },
            ),
          ),
        ]),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.25,
        child: SpinKitWave(
          color: Color.fromRGBO(230, 73, 90, 1),
          type: SpinKitWaveType.start,
        ),
      );
    }
  }
}
