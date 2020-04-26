import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/card_service.dart';
import 'package:cuthair/ui/Components/large_text.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  _DetailScreenState(this.hairDressing);

  int _current = 0;

  initState() {
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init(hairDressing);
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
              LargeText(hairDressing.name),
              MediumText(hairDressing.direction),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
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

  @override
  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}
