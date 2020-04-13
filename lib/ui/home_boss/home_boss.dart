import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/user.dart';
import 'package:cuthair/ui/calendar_boss/calendar_boss.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/ui/calendar_employee/calendar_employee.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_boss_presenter.dart';

class HomeBoss extends StatefulWidget {
  User user;

  HomeBoss(this.user);

  @override
  _HomeBossState createState() => _HomeBossState(user);
}

class _HomeBossState extends State<HomeBoss> implements HomeBossView {
  User user;

  _HomeBossState(this.user);

  List<Employe> employees = [];
  List<Appointment> appointments = [];
  RemoteRepository _remoteRepository;
  HomeBossPresenter _homeBossPresenter;
  globalMethods global = globalMethods();

  @override
  initState() {
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    _homeBossPresenter = HomeBossPresenter(this, _remoteRepository);
    _homeBossPresenter.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return WillPopScope(
        onWillPop: global.onWillPop,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(44, 45, 47, 1),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 90,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromRGBO(230, 73, 90, 1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
                      child: Text(
                        "Bienvenido",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                    child: Text(
                      "Asignar horarios",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.03,
                        left: MediaQuery.of(context).size.width * 0.05),
                    height: MediaQuery.of(context).size.height * 0.28,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              globalMethods().pushPage(
                                  context, CalendarBoss(employees[index]));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Center(
                                          child: Container(
                                            child: AspectRatio(
                                              aspectRatio: 4 / 4,
                                              child: Image(
                                                fit: BoxFit.fill,
                                                height: 10,
                                                width: 10,
                                                image: ExactAssetImage(
                                                    "assets/images/privilegeLogo.jpg"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(7, 10, 0, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              employees[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 18.0),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              child: Text(
                                "Mis horarios",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                globalMethods().pushPage(
                                    context, CalendarEmployee(user.name));
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                                width: MediaQuery.of(context).size.width * 0.39,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Container(
                                    child: Column(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: Center(
                                            child: Container(
                                              child: AspectRatio(
                                                aspectRatio: 4 / 4,
                                                child: Image(
                                                  fit: BoxFit.fill,
                                                  height: 10,
                                                  width: 10,
                                                  image: ExactAssetImage(
                                                      "assets/images/privilegeLogo.jpg"),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              7, 10, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                user.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  @override
  showHairdresser(List<Employe> employes) {
    setState(() {
      employees = employes;
    });
  }
}
