import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:cuthair/ui/Components/upElements/goback.dart';
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
    "1": "link 1",
    "2": "https://www.youtube.com/watch?v=-y7aXFRJESg"
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
        leading: GoBack(
          context,
          "",
          HEIGHT: HEIGHT * 0.013,
        ),
        title: LargeText("Volver"),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: HEIGHT * 0.04, left: WIDTH * 0.05),
              child: LargeText("Lista de contribuidores"),
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
                        child: MediumText(mapContribuyers.keys.elementAt(index) + ":"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: HEIGHT * 0.04, left: WIDTH * 0.10),
                        child: InkWell(
                          child: MediumText(mapContribuyers.values.elementAt(index)),
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