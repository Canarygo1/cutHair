import 'package:components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class contribuyer_screen extends StatefulWidget{

  contribuyer_screen();

  @override
  _contribuyerState createState() => _contribuyerState();
}


class _contribuyerState extends State<contribuyer_screen>{

  double HEIGHT;
  double WIDTH;
  Map<String, String> mapContribuyers = {
    "Ufo: Vitaly Gorbachev": "www.flaticon.com",
    "404 image: Freepik": "http://www.freepik.com/"
  };

  void initState() {
      super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDTH = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(300, 300, 300, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(230, 73, 90, 1),
        leading: Components.goBack(
          context,
          "",
        ),
        title: Components.largeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.04, left: WIDTH * 0.05),
              child: Components.largeText("Lista de contribuidores"),
            ),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemCount: mapContribuyers.keys.length,
                itemBuilder: (context, index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: HEIGHT * 0.02, left: WIDTH * 0.05),
                        child: Components.mediumText(mapContribuyers.keys.elementAt(index) + ":"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: HEIGHT * 0.04, left: WIDTH * 0.10),
                        child: InkWell(
                          child: Components.mediumText(mapContribuyers.values.elementAt(index)),
                          onTap: () => launch(mapContribuyers.values.elementAt(index)),
                        ),
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}