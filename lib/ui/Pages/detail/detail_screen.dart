import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/card_elements/card_service.dart';
import 'package:cuthair/ui/Components/card_elements/restaurant_card.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info.dart';
import 'package:cuthair/ui/Pages/not_login/not_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detail_presenter.dart';

class DetailScreen extends StatefulWidget {
  Business business;
  bool logIn;

  DetailScreen(this.business, this.logIn);

  @override
  _DetailScreenState createState() => _DetailScreenState(business);
}

class _DetailScreenState extends State<DetailScreen> implements DetailView {
  Business business;
  Appointment appointment = Appointment();
  DetailPresenter presenter;
  RemoteRepository remoteRepository;
  List<Service> serviceDetails = [];
  List<String> listImagesFirebase = [];
  List<Widget> child = [];
  bool isConsulting = true;
  bool notImages = true;
  double HEIGHT;
  double WIDHT;

  _DetailScreenState(this.business);

  int _current = 0;

  initState() {
    appointment.business = this.business;
    remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init(business);
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: business.typeBusiness != "Peluquerías"
          ? Padding(
              padding: EdgeInsets.only(bottom: HEIGHT * 0.02),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    if(this.widget.logIn == true){
                      GlobalMethods()
                          .pushPage(context, ChooseExtraInfoScreen(appointment));
                    }else{
                      GlobalMethods().pushPage(context, NotLoginScreen("Reservar cita", "Para acceder, necesitas iniciar sesión"));
                    }
                  },
                  label: Text("Reserva una cita"),
                  backgroundColor: Color.fromRGBO(230, 73, 90, 1)),
            )
          : Container(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            sliderImages(context),
            LargeText(business.name),
            MediumText(business.direction),
            business.typeBusiness != "Playas"
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: HEIGHT * 0.013, left: WIDHT * 0.025),
                      child: Text(
                        "Servicios",
                        style: TextStyle(
                            color: Color.fromRGBO(230, 73, 90, 1),
                            fontSize: 24),
                      ),
                    ),
                  )
                : MediumText("Aforo: " + business.aforo.toString()),
            getCard()
          ],
        ),
      ),
    );
  }

  Widget getCard() {
    if (business.typeBusiness == "Peluquerías") {
      return CardService(business, serviceDetails,
          () => makecall(business.phoneNumber.toString()), this.widget.logIn);
    } else if (business.typeBusiness == "Restaurantes") {
      return RestaurantCard(business, serviceDetails);
    } else {
      return Container();
    }
  }

  List<Widget> getChilds() {
    List prueba = map<Widget>(listImagesFirebase, (index, i) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(children: <Widget>[
            notImages ? Image.network(i, fit: BoxFit.cover, width: WIDHT * 2.546) : Image.asset(i, fit: BoxFit.cover, width: WIDHT * 2.546),
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
                padding: EdgeInsets.symmetric(
                    vertical: HEIGHT * 0.013, horizontal: WIDHT * 0.05),
              ),
            ),
          ]),
        ),
      );
    }).toList();
    return prueba;
  }

  Widget sliderImages(BuildContext context) {
    return isConsulting
        ? Container(
            margin: EdgeInsets.only(top: HEIGHT * 0.027),
            height: HEIGHT * 0.25,
            child: SpinKitWave(
              color: Color.fromRGBO(230, 73, 90, 1),
              type: SpinKitWaveType.start,
            ),
          )
        : Container(
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
                  listImagesFirebase,
                  (index, url) {
                    return Container(
                      width: WIDHT * 0.02,
                      height: HEIGHT * 0.01,
                      margin: EdgeInsets.symmetric(
                          vertical: HEIGHT * 0.013, horizontal: WIDHT * 0.005),
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
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  showServices(List services) {
    if (mounted) {
      setState(() {
        serviceDetails = services;
      });
    }
  }

  @override
  showImages(List images) {
    if (mounted) {
      setState(() {
        listImagesFirebase = images;
        listImagesFirebase.isEmpty
            ? {
                notImages = false,
                listImagesFirebase.add("assets/images/splash.png")
              }
            : notImages = true;
        child = getChilds();
        this.isConsulting = false;
      });
    }
  }

  @override
  makecall(String number) async {
    await launch("tel:" + "+34" + number);
  }
}
