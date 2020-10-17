import 'package:components/components.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:flutter/material.dart';

class CardWithoutCheckOut extends StatelessWidget {
  double height;
  double width;
  Function functionRemove;
  AppointmentCompleted appointment;

  CardWithoutCheckOut(this.appointment, this.functionRemove);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
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
                  width * 0.025, height * 0.01, width * 0.025, 0),
              child: Column(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 50.0 / 11.0,
                      child: appointment.business.widget),
                ],
              ),
            ),
            Padding(
              padding:
              EdgeInsets.only(left: width * 0.025, top: height * 0.013),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.006),
                        child: Components.mediumText(
                            appointment.business.name),
                      ),
                      Container(
                          width: width * 0.62,
                          padding:
                          EdgeInsets.symmetric(vertical: height * 0.006),
                          child: Components.mediumText(
                              appointment.business.direction)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.006),
                        child: Components.mediumText("Nº personas: " +
                            appointment.appointment.plazaCitaId),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 0.025, left: 1),
                    child: Column(
                      children: <Widget>[
                        Components.smallText(GetTimeSeparated
                            .getFullTimeIfHasOneValue_Month(DateTime.parse(
                            appointment.appointment.checkIn)
                            .day
                            .toString()) +
                            "-" +
                            GetTimeSeparated.getFullTimeIfHasOneValue_Month(
                                DateTime.parse(
                                    appointment.appointment.checkIn)
                                    .month
                                    .toString()) +
                            "-" +
                            DateTime.parse(
                                appointment.appointment.checkIn)
                                .year
                                .toString()),
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.006),
                              child: Components.smallText(
                                DateTime.parse(appointment.appointment.checkIn)
                                    .hour
                                    .toString() +
                                    ":" +
                                    GetTimeSeparated
                                        .getFullTimeIfHasOneValue_Hour(
                                        DateTime.parse(appointment.appointment.checkIn)
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
            Expanded(
              child: Components.smallButton(
                functionRemove,
                Components.smallText(
                  'Cancelar',
                  size: 11,
                ),
                height: height * 0.05,
                horizontalPadding: width * 0.008,
                color: Color.fromRGBO(230, 73, 90, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
