import 'package:cuthair/chooseHairDresser.dart';
import 'package:cuthair/detailScreen.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:flutter/material.dart';

import 'globalMethods.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<HairDressing> peluquerias = [];
    peluquerias
        .add(new HairDressing("Privilege", "Santa Cruz", "BarberShop", "Prueba"));
    peluquerias
        .add(new HairDressing("Privilege", "Santa Cruz", "BarberShop", "Prueba"));
    peluquerias
        .add(new HairDressing("Privilege", "Santa Cruz", "BarberShop", "Prueba"));
    peluquerias
        .add(new HairDressing("Privilege", "Santa Cruz", "BarberShop", "Prueba"));
    peluquerias
        .add(new HairDressing("Privilege", "Santa Cruz", "BarberShop", "Prueba"));
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
                    onTap: (){
                      globalMethods().pushPage(context, DetailScreen());
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
                                      "Privilege",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 18.0),
                                    ),
                                    Text(
                                      "BarberShop",
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
                                          "Santa Cruz",
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
}
