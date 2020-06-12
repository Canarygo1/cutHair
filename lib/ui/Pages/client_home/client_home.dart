import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/ui/Components/button.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/textTypes/small_text.dart';
import 'package:cuthair/ui/Pages/detail/detail_screen.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'home_client_presenter.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> implements HomeView {
  HomeClientPresenter presenter;
  RemoteRepository _remoteRepository;
  List<String> businessType;
  Map<String, List<Business>> mapBusiness = Map();
  List<Widget> logoBusinesses = [];
  GlobalMethods global = GlobalMethods();
  bool loading = true;
  double HEIGHT;
  double WIDHT;
  List<String> selectedCountList = [];
  Map<String, List<String>> selectedFilters = Map();

  initState() {
    businessType = [];
    loading = true;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = HomeClientPresenter(this, _remoteRepository);
    presenter.init(selectedFilters);
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: LargeText("Negocios"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            loading
                ? Padding(
              padding: EdgeInsets.only(top: 50),
              child: SpinKitWave(
                color: Color.fromRGBO(230, 73, 90, 1),
                type: SpinKitWaveType.start,
              ),
            )
                : Container(
              height: HEIGHT * 0.81,
              child: ListView(
                shrinkWrap: true,
                primary: false,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      MyButton(
                            () => _openFilterList(businessType, "tipo"),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            MediumText("Negocios"),
                          ],
                        ),
                        horizontalPadding: 10.0,
                        verticalMargin: 20.0,
                        //width: 200.0,
                        height: 30.0,
                        color: Color.fromRGBO(230, 73, 90, 1),
                      ),
                    ],
                  ),
                  selectedCountList.length == 0
                      ? Container()
                      : Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: WIDHT * 0.043,
                        vertical: HEIGHT * 0.005),
                    height: 40.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedCountList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                              BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () => removeElements(index),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    EdgeInsets.only(right: 5.0),
                                    child: SmallText(
                                        selectedCountList[index]),
                                  ),
                                  Icon(
                                    Icons.remove_circle_outline,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: WIDHT * 0.043, vertical: 0),
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    itemCount: mapBusiness.length,
                    itemBuilder: (context, indexTipo) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, top: HEIGHT * 0.01),
                            child: LargeText(
                              businessType[indexTipo],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            height: 230,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                mapBusiness[businessType[indexTipo]]
                                    .length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      ConnectionChecked
                                          .checkInternetConnectivity(
                                          context);
                                      Business business = mapBusiness[
                                      businessType[indexTipo]][index];

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
                                                      child: logoBusinesses[
                                                      index +
                                                          indexTipo],
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
                                                      mapBusiness[businessType
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
                                                          mapBusiness[businessType
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
                          )
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  removeElements(int index) {
    String text = selectedCountList[index];
    setState(() {
      List<List<String>> auxList = selectedFilters.values.toList();
      List<String> keys = List.from(selectedFilters.keys);
      for (var v = 0; v < auxList.length; v++) {
        if (auxList[v].contains(text)) {
          auxList[v].remove(text);
        }
        if (auxList[v].isEmpty) {
          auxList.removeAt(v);
          keys.removeAt(v);
        }
      }
      selectedFilters = Map();
      for (var v = 0; v < auxList.length; v++) {
        selectedFilters.putIfAbsent(keys[v], () => auxList[v]);
      }
      selectedCountList.removeAt(index);
      mapBusiness.clear();
      presenter.init(selectedFilters);
    });
  }

  void _openFilterList(List type, String key) async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: type,
      allButtonText: "Todos",
      resetButtonText: "Ninguno",
      applyButtonText: "Aceptar",
      height: 450,
      applyButtonElevation: 0.0,
      textSelectedCounts: "filtros seleccionados",
      selectedTextBackgroundColor: Color.fromRGBO(230, 73, 90, 1),
      borderRadius: 20,
      allResetButonColor: Colors.black,
      applyButonTextBackgroundColor: Colors.transparent,
      applyButonTextColor: Colors.black,
      headlineText: "Negocios",
      searchFieldHintText: "Buscar aquí",
      selectedTextList: selectedCountList,
    );

    if (list != null) {
      setState(() {
        selectedCountList.removeWhere((element) => type.contains(element));
        selectedCountList.addAll(List.from(list));
        selectedCountList = List.from(list);
        if (selectedFilters.containsKey(key)) {
          selectedFilters.remove(key);
        }
        if (list.isNotEmpty) {
          selectedFilters.putIfAbsent(key, () => List.from(list));
        }
        presenter.init(selectedFilters);
      });
    }
  }

  @override
  showList(Map<String, List> business, List<Widget> images) {
    if (mounted) {
      setState(() {
        logoBusinesses = images;
        mapBusiness = business;
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
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }
}
