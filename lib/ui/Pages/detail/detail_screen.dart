import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/card_service.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_presenter.dart';

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
  double HEIGHT;
  double WIDHT;

  _DetailScreenState(this.hairDressing);
  int _current = 0;

  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init(hairDressing);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              sliderImages(context),
              LargeText(hairDressing.name),
              MediumText(hairDressing.direction),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: HEIGHT * 0.013, left: WIDHT * 0.025),
                  child: Text(
                    "Servicios",
                    style: TextStyle(
                        color: Color.fromRGBO(230, 73, 90, 1), fontSize: 24),
                  ),
                ),
              ),
              CardService(hairDressing, detallesServicio,
                      () => makecall(hairDressing.phoneNumber.toString())),
            ],
          ),
        ));
  }

  List<Widget> getChilds() {
    List prueba = map<Widget>(listaImagenesFirebase, (index, i) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(children: <Widget>[
            Image.network(i, fit: BoxFit.cover, width: WIDHT * 2.546),
            Positioned(
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
                padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.013, horizontal: WIDHT * 0.05),
              ),
            ),
          ]),
        ),
      );
    }).toList();
    return prueba;
  }

  Widget sliderImages(BuildContext context) {
    if (child.length > 0) {
      return Container(
        margin: EdgeInsets.only(top: HEIGHT * 0.027),
        child: Column(children: [
          CarouselSlider(
            height: HEIGHT * 0.23,
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
                  width: WIDHT * 0.02,
                  height: HEIGHT * 0.01,
                  margin: EdgeInsets.symmetric(vertical: HEIGHT * 0.013, horizontal: WIDHT * 0.005),
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
        margin: EdgeInsets.only(top: HEIGHT * 0.027),
        height: HEIGHT * 0.25,
        child: SpinKitWave(
          color: Color.fromRGBO(230, 73, 90, 1),
          type: SpinKitWaveType.start,
        ),
      );
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  showServices(List servicios) {
    if (mounted) {
      setState(() {
        detallesServicio = servicios;
      });
    }
  }

  @override
  showImages(List imagenes) {
    if (mounted) {
      setState(() {
        listaImagenesFirebase = imagenes;
        child = getChilds();
      });
    }
  }

  @override
  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}
