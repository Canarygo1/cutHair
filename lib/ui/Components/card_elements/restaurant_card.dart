import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/ui/Components/textTypes/large_text.dart';
import 'package:cuthair/ui/Components/textTypes/medium_text.dart';
import 'package:flutter/material.dart';

class RestaurantCard extends StatefulWidget {
  Business business;
  List<Service> serviceDetails;

  RestaurantCard(this.business, this.serviceDetails);

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  double HEIGHT;
  double WIDHT;

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;

    return Container(
      child: ListView.builder(
        itemCount: widget.serviceDetails.length,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Card(
            shape: BeveledRectangleBorder(
                side: BorderSide(
                    color: Color.fromRGBO(300, 300, 300, 1))),
            child: Container(
              color: Color.fromRGBO(300, 300, 300, 1),
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Padding(
                        padding:
                        EdgeInsets.only(left: WIDHT * 0.02),
                        child: SizedBox(
                          height: HEIGHT * 0.135,
                          width: WIDHT * 0.30,
                          child: Container(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(8.0),
                              child: Container(
                                child: AspectRatio(
                                  aspectRatio: 4 / 4,
                                  child: Image(
                                    fit: BoxFit.fill,
                                    image: ExactAssetImage(
                                        "assets/images/carneFiesta.jpg"),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          contentPadding:
                          EdgeInsets.only(left: WIDHT * 0.05),
                          dense: true,
                          title: LargeText(widget.serviceDetails.elementAt(index).type),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    top: HEIGHT * 0.013),
                                child: MediumText(
                                    widget.serviceDetails.elementAt(index).description,
                                    boolText: FontWeight.normal),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: HEIGHT * 0.013),
                                child: MediumText(
                                    widget.serviceDetails[index].price.toString() + " €",
                                    boolText: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: HEIGHT * 0.013),
                            child: Divider(
                              thickness: 0.6,
                              endIndent: 10.0,
                              indent: 5.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
