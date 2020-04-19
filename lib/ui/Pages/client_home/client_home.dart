import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<HairDressing> peluquerias;
  globalMethods global = globalMethods();

  initState() {
    peluquerias = [];
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
          Appbar("Peluquerias"),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: MediumText("Disponibles"),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 17, vertical: 24.0),
            height: MediaQuery.of(context).size.height * 0.40,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: peluquerias.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      HairDressing hairDressing = peluquerias[index];
                      globalMethods()
                          .pushPage(context, DetailScreen(hairDressing));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.34,
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
    if (mounted) {
      setState(() {
        peluquerias = hairDressing;
      });
    }
  }
}
