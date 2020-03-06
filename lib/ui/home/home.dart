import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/ui/choose_hairdresser/choose_hairdresser.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/ui/home/home_presenter.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:flutter/material.dart';

import '../../data/remote/http_remote_repository.dart';
import '../../globalMethods.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> implements HomeView {
  HomePagePresenter presenter;
  RemoteRepository _remoteRepository;
  List<HairDressing> peluquerias;

  initState() {
    peluquerias = [];
    _remoteRepository = HttpRemoteRepository(Firestore.instance);
    presenter = HomePagePresenter(this, _remoteRepository);
    presenter.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(44, 45, 47, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 90,
            color: Color.fromRGBO(230, 73, 90, 1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 40, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_on),
                  Text("Santa Cruz de Tenerife")
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    "Cercanas",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: peluquerias.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      globalMethods()
                          .pushPage(context, chooseHairDresserScreen());
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
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
                                padding: const EdgeInsets.fromLTRB(7, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      peluquerias[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      peluquerias[index].type,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15.0),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          peluquerias[index].shortDirection,
                                          style: TextStyle(
                                              color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  @override
  showList(List<HairDressing> hairDressing) {
    setState(() {
      peluquerias = hairDressing;
    });
    return null;
  }
}
