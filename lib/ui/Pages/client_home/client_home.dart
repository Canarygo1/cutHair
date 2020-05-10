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
  List<String> businessesTypes;
  Map<String, List<Business>> mapBusinesses = Map();
  GlobalMethods global = GlobalMethods();
  bool loading;
  double HEIGHT;
  double WIDTH;

  initState() {
    businessesTypes = [];
    loading = false;
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = HomeClientPresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    HEIGHT = MediaQuery.of(context).size.height;
    WIDTH = MediaQuery.of(context).size.width;
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
                          horizontal: WIDTH * 0.043, vertical: HEIGHT * 0.013),
                      shrinkWrap: true,
                      primary: false,
                      scrollDirection: Axis.vertical,
                      itemCount: businessesTypes.length,
                      itemBuilder: (context, indexTipo) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: HEIGHT * 0.02),
                              child: MediumText(businessesTypes[indexTipo]),
                            ),
                            Container(
                              height: HEIGHT * 0.31,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      mapBusinesses[businessesTypes[indexTipo]].length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        ConnectionChecked
                                            .checkInternetConnectivity(context);
                                        Business hairDressing = mapBusinesses[
                                                businessesTypes.elementAt(indexTipo)]
                                            [index];
                                        GlobalMethods().pushPage(context,
                                            DetailScreen(hairDressing));
                                      },
                                      child: Container(
                                        width: WIDTH * 0.34,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: WIDTH * 0.045),
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
                                                          height:
                                                              HEIGHT * 0.013,
                                                          width: WIDTH * 0.025,
                                                          image: ExactAssetImage(
                                                              "assets/images/privilegeLogo.jpg"),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: WIDTH * 0.017,
                                                      top: HEIGHT * 0.025),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        mapBusinesses[businessesTypes
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
                                                        mapBusinesses[businessesTypes
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
                                                            mapBusinesses[businessesTypes
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
  showList(Map<String, List<Business>> mapBusinesses) {
    if (mounted) {
      setState(() {
        this.mapBusinesses.addAll(mapBusinesses);
      });
    }
  }

  @override
  showBusiness(List<String> business) {
    if (mounted) {
      setState(() {
        this.businessesTypes = business;
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
