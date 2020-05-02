import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/ui/Components/appbar.dart';
import 'package:cuthair/ui/Components/medium_text.dart';
import 'package:cuthair/ui/Pages/detail/detail_screen.dart';
import 'package:flutter/material.dart';
import 'home_client_presenter.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> implements HomeView {
  HomeClientPresenter presenter;
  RemoteRepository _remoteRepository;
  List<String> business;
  Map<String, List<HairDressing>> peluquerias;
  globalMethods global = globalMethods();
  bool loading = false;

  initState() {
    business = [];
    peluquerias = new Map();
    loading = false;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = HomeClientPresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    return Scaffold(
      backgroundColor: Color.fromRGBO(44, 45, 47, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Appbar("Negocios"),
          loading
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10.0),
                  height: MediaQuery.of(context).size.height * 0.81,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: business.length,
                      itemBuilder: (context, indexTipo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                              child: MediumText(business.elementAt(indexTipo)),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height * 0.31,
                              child: Row(
                                children: <Widget>[
                                  ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: peluquerias[
                                              business.elementAt(indexTipo)]
                                          .length,
                                      itemBuilder: (context, index) {
                                        return new GestureDetector(
                                          onTap: () {
                                            ConnectionChecked
                                                .checkInternetConnectivity(
                                                    context);
                                            HairDressing hairDressing =
                                                peluquerias[business.elementAt(
                                                    indexTipo)][index];
                                            globalMethods().pushPage(context,
                                                DetailScreen(hairDressing));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.34,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 18, 0),
                                              child: Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
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
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          7, 10, 0, 0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            peluquerias[business
                                                                    .elementAt(
                                                                        indexTipo)][index]
                                                                .name,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18.0),
                                                          ),
                                                          Text(
                                                            peluquerias[business
                                                                    .elementAt(
                                                                        indexTipo)][index]
                                                                .type,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 15.0),
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons
                                                                    .location_on,
                                                                size: 12,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                peluquerias[business
                                                                        .elementAt(
                                                                            indexTipo)][index]
                                                                    .shortDirection,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12.0),
                                                              ),
                                                            ],
                                                          ),
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
                                ],
                              ),
                            )
                          ],
                        );
                      }),
                )
              : Container()
        ],
      ),
    );
  }

  @override
  showList(Map<String, List<HairDressing>> hairDressing) {
    if (mounted) {
      setState(() {
        peluquerias.addAll(hairDressing);
        loading = true;
      });
    }
  }

  @override
  showBusiness(List<String> business) {
    if (mounted) {
      setState(() {
        this.business = business;
      });
    }
  }

  @override
  chargeBusiness() {
    for (int i = 0; i < this.business.length; i++) {
      this.presenter.getBusiness(business.elementAt(i));
    }
  }
}
