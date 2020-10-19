import 'package:components/components.dart';
import 'package:cuthair/data/local/db_sqlite.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/image_business.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/card_elements/card_service.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cuthair/ui/Pages/choose_extra_info/choose_extra_info.dart';
import 'package:cuthair/ui/Pages/not_login/not_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'detail_presenter.dart';

class DetailScreen extends StatefulWidget {
  Business business;
  bool logIn;
  BusinessType businessType;

  DetailScreen(this.business, this.logIn, this.businessType);

  @override
  _DetailScreenState createState() =>
      _DetailScreenState(business, businessType);
}

class _DetailScreenState extends State<DetailScreen> implements DetailView {
  Business business;
  Appointment appointment = Appointment();
  DetailPresenter presenter;
  RemoteRepository remoteRepository;
  List<Service> serviceDetails = [];
  List<Widget> child = [];
  bool isConsulting = true;
  bool notImages = true;
  double height;
  double width;
  BusinessType businessType;

  _DetailScreenState(this.business, this.businessType);

  int _current = 0;

  initState() {
    appointment.businessId = business.id;
    appointment.userId = this.widget.logIn == true ? DBProvider.users[0].id : "";
    remoteRepository = HttpRemoteRepository(Client());
    presenter = DetailPresenter(this, remoteRepository);
    presenter.init(business);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: business.isServiceSelected == false
          ? Padding(
              padding: EdgeInsets.only(bottom: height * 0.02),
              child: FloatingActionButton.extended(
                  onPressed: () {
                    if (this.widget.logIn == true) {
                      GlobalMethods().pushPage(
                          context,
                          ChooseExtraInfoScreen(appointment, business,
                              businessType, serviceDetails[0]));
                    } else {
                      GlobalMethods().pushPage(
                          context,
                          NotLoginScreen("Reservar cita",
                              "Para acceder, necesitas iniciar sesión"));
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
            Components.largeText(business.name),
            Components.mediumText(business.direction),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(top: height * 0.013, left: width * 0.025),
                child: Text(
                  "Servicios",
                  style: TextStyle(
                      color: Color.fromRGBO(230, 73, 90, 1), fontSize: 24),
                ),
              ),
            ),
            CardService(appointment, business, serviceDetails,
                this.widget.logIn, businessType),
          ],
        ),
      ),
    );
  }

  List<Widget> getChilds() {
    List prueba = map<Widget>(business.images, (index, i) {
      notImages = business.images.isEmpty || business.images[0].url.contains("assets") ? false : true;
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(children: <Widget>[
            notImages == true
                ? Image.network(business.images[index].url,
                    fit: BoxFit.cover, width: width * 2.546)
                : Image.asset(business.images[index].url,
                    fit: BoxFit.cover, width: width * 2.546),
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
                    vertical: height * 0.013, horizontal: width * 0.05),
              ),
            ),
          ]),
        ),
      );
    }).toList();
    return prueba;
  }

  Widget sliderImages(BuildContext context) {
    return isConsulting || business.images.length == 0
        ? Container(
            margin: EdgeInsets.only(top: height * 0.027),
            height: height * 0.25,
            child: SpinKitWave(
              color: Color.fromRGBO(230, 73, 90, 1),
              type: SpinKitWaveType.start,
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: height * 0.027),
            child: Column(children: [
              CarouselSlider(
                height: height * 0.23,
                items: child,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 1, milliseconds: 500),
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
                  business.images,
                  (index, url) {
                    return Container(
                      width: width * 0.02,
                      height: height * 0.01,
                      margin: EdgeInsets.symmetric(
                          vertical: height * 0.013, horizontal: width * 0.005),
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
  showImages(List<ImageBusiness> images) {
    if (mounted) {
      setState(() {
        images.isEmpty
            ? {
                notImages = false,
                business.images.add(
                    ImageBusiness("aux", "assets/images/splash.png", "aux")),
              }
            : {
                notImages = true,
                business.images = images,
              };
        child = getChilds();
        this.isConsulting = false;
      });
    }
  }
}
