import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:flutter/material.dart';

class CardWithoutCheckOut extends StatelessWidget {
  double HEIGHT;
  double WIDHT;
  int index;
  Function functionRemove;
  List<String> allImages;
  List<MyAppointment> myAppointments = [];

  CardWithoutCheckOut(
      this.index, this.functionRemove, this.allImages, this.myAppointments);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WIDHT * 0.06),
      child: Card(
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        color: Color.fromRGBO(60, 60, 62, 1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(
                  WIDHT * 0.025, HEIGHT * 0.01, WIDHT * 0.025, 0),
              child: Column(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 50.0 / 11.0,
                    child: allImages[index].contains("assets/")
                        ? Image.asset(
                      allImages[index],
                      fit: BoxFit.cover,
                    )
                        : Image.network(
                      allImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: WIDHT * 0.025, top: HEIGHT * 0.013),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: Components.mediumText(
                            myAppointments.elementAt(index).businessName),
                      ),
                      Container(
                          width: WIDHT * 0.62,
                          padding:
                              EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                          child: Components.mediumText(
                              myAppointments.elementAt(index).direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: HEIGHT * 0.006),
                        child: Components.mediumText("Personas: " +
                            myAppointments.elementAt(index).extraInformation),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: HEIGHT * 0.025, left: 1),
                    child: Column(
                      children: <Widget>[
                        Components.smallText(DateTime.parse(
                                    myAppointments.elementAt(index).checkIn)
                                .day
                                .toString() +
                            "-" +
                            DateTime.parse(
                                    myAppointments.elementAt(index).checkIn)
                                .month
                                .toString() +
                            "-" +
                            DateTime.parse(
                                    myAppointments.elementAt(index).checkIn)
                                .year
                                .toString()),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: HEIGHT * 0.020),
                              child: Components.mediumText(
                                DateTime.parse(myAppointments
                                            .elementAt(index)
                                            .checkIn)
                                        .hour
                                        .toString() +
                                    ":" +
                                    GetTimeSeparated.getFullTimeIfHasOneValue(
                                        DateTime.parse(myAppointments
                                                .elementAt(index)
                                                .checkIn)
                                            .minute
                                            .toString()),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Components.smallButton(
                functionRemove,
                Components.smallText(
                  'Cancelar',
                  size: 11,
                ),
                height: HEIGHT * 0.05,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
