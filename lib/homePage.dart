import 'package:cuthair/DesignHome/itemList.dart';
import 'package:flutter/material.dart';

class homePage extends StatelessWidget {

  List<Peluqueria> itemList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: Container(
        color: Color.fromRGBO(300, 300, 300, 1),
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
        child: ListView(
          children: <Widget>[
            Upbar(),
            GridView.count(
              crossAxisCount: 4,
              padding: EdgeInsets.all(4.0),
              childAspectRatio: 8.0 / 9.0,
              children: itemList
              .map(
                (Peluqueria) => ItemList(peluqueria: Peluqueria),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget Upbar(){
    return Container(
      color: Color.fromRGBO(230, 73, 90, 1),
      child: Padding(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.place,
              color: Colors.black,
            ),
            Text(
              'Santa Cruz de Teneride',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
