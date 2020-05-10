import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/ui/Components/upElements/appbar.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
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
  List<String> businessType;
  Map<String, List> mapBusiness = Map();
  GlobalMethods global = GlobalMethods();
  bool loading;
  double HEIGHT;
  double WIDHT;

  initState() {
    businessType = [];
    loading = false;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = HomeClientPresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(44, 45, 47, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Appbar("Negocios"),
            loading
                ? Container(
              height: HEIGHT * 0.81,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                    horizontal: WIDHT * 0.043, vertical: HEIGHT * 0.013),
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: businessType.length,
                itemBuilder: (context, indexTipo) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: HEIGHT * 0.02),
                        child: MediumText(businessType[indexTipo]),
                      ),
                      Container(
                        height: HEIGHT * 0.31,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                            mapBusiness[businessType[indexTipo]].length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  ConnectionChecked
                                      .checkInternetConnectivity(context);
                                  Business business = mapBusiness[
                                  businessType.elementAt(indexTipo)]
                                  [index];
                                  GlobalMethods().pushPage(context,
                                      DetailScreen(business));
                                },
                                child: Container(
                                  width: WIDHT * 0.34,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: WIDHT * 0.045),
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
                                                  child: mapBusiness["Images"][indexTipo + index],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: WIDHT * 0.017,
                                                top: HEIGHT * 0.025),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: <Widget>[
                                                Text(
                                                  mapBusiness[businessType
                                                      .elementAt(
                                                      indexTipo)]
                                                  [index]
                                                      .name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 18.0),
                                                ),
                                                Text(
                                                  mapBusiness[businessType
                                                      .elementAt(
                                                      indexTipo)]
                                                  [index]
                                                      .type,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.0),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 12,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      mapBusiness[businessType
                                                          .elementAt(
                                                          indexTipo)][index]
                                                          .shortDirection,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .white,
                                                          fontSize: 12.0),
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
                      )
                    ],
                  );
                },
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  @override
  showList(Map<String, List> hairDressing) {
    if (mounted) {
      setState(() {
        mapBusiness.addAll(hairDressing);
      });
    }
  }

  @override
  showBusiness(List<String> business) {
    if (mounted) {
      setState(() {
        this.businessType = business;
      });
    }
  }

  @override
  changeLoading() {
    if(mounted){
      setState(() {
        loading = true;
      });
    }
  }
}