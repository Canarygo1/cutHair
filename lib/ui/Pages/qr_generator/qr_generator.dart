import 'package:components/components.dart';
import 'package:cuthair/model/appointment_completed.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  AppointmentCompleted appointmentCompleted;

  QrGenerator(this.appointmentCompleted);

  @override
  _QrGeneratorState createState() => _QrGeneratorState(appointmentCompleted);
}

class _QrGeneratorState extends State<QrGenerator> {
  AppointmentCompleted appointmentCompleted;
  double height;
  double width;
  _QrGeneratorState(this.appointmentCompleted);

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Padding(
          padding: EdgeInsets.only(top:height *0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Components.mediumText("Tu código de entrada")),
              Padding(
                padding: EdgeInsets.only(top:height *0.05),
                child: QrImage(
                  foregroundColor: Color.fromRGBO(230, 73, 90, 1) ,
                  data: appointmentCompleted.appointment.id,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:height*0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:height*0.001,top:height *0.02),
                      child: Components.largeText("Detalles de la reserva"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:height*0.001,top:height *0.01),
                      child: Components.mediumText(appointmentCompleted.appointment.id),
                    ),
                    Components.mediumText(appointmentCompleted.business.name),
                    Components.mediumText(appointmentCompleted.business.direction),
                    Components.mediumText("Personas: " + appointmentCompleted.place.type),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
