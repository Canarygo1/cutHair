import 'package:components/components.dart';
import 'package:cuthair/data/remote/check_connection.dart';
import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/ui/Pages/detail/detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'home_client_presenter.dart';

class ClientHome extends StatefulWidget {
  bool logIn;

  ClientHome(this.logIn);

  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> implements HomeView {
  HomeClientPresenter presenter;
  RemoteRepository _remoteRepository;
  List<BusinessType> businessType;
  Map<String, List<Business>> mapBusiness = Map();
  GlobalMethods global = GlobalMethods();
  bool loading = true;
  double height;
  double width;

  initState() {
    businessType = [];
    loading = true;
    _remoteRepository = HttpRemoteRepository(Client());
    presenter = HomeClientPresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    global.context = context;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        title: Components.largeText("Negocios"),
        centerTitle: true,
      ),
      body: loading
          ? Padding(
        padding: EdgeInsets.only(top: 50),
        child: SpinKitWave(
          color: Color.fromRGBO(230, 73, 90, 1),
          type: SpinKitWaveType.start,
        ),
      )
          : ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.043, vertical: 5),
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
            itemCount: businessType.length,
            itemBuilder: (context, indexTipo) {
              return Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Components.largeText(
                      businessType[indexTipo].type,
                      boolText: FontWeight.bold,
                    ),
                    Container(
                      height: 250,
                      padding: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                          mapBusiness[businessType[indexTipo].type].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Business business = mapBusiness[
                                businessType[indexTipo].type]
                                [index];
                                GlobalMethods().pushPage(context,
                                    DetailScreen(business, this.widget.logIn, businessType[indexTipo]));
                              },
                              child: Container(
                                width: 134,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: width * 0.045),
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
                                                child:
                                                mapBusiness[
                                                businessType[
                                                indexTipo]
                                                    .type][index]
                                                    .widget,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.017,
                                              top: height * 0.025),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              Text(
                                                mapBusiness[businessType[indexTipo].type][index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.white,
                                                    fontSize: 18.0),
                                              ),
                                              Text(
                                                mapBusiness[businessType[indexTipo].type][index].type,
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
                                                    mapBusiness[businessType[indexTipo].type][index].shortDirection,
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
                ),
              );
            },
          ),
    );
  }

  @override
  showList(Map<String, List<Business>> business) {
    if (mounted) {
      setState(() {
        mapBusiness.addAll(business);
      });
    }
  }

  @override
  showBusiness(List<BusinessType> business) {
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
        loading = false;
      });
    }
  }
}