import 'package:components/components.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  MyAppointment myAppointment;

  QrGenerator(this.myAppointment);

  @override
  _QrGeneratorState createState() => _QrGeneratorState(myAppointment);
}

class _QrGeneratorState extends State<QrGenerator> {
  MyAppointment myAppointment;
  double HEIGHT;
  double WIDHT;
  _QrGeneratorState(this.myAppointment);

  @override
  Widget build(BuildContext context) {
    HEIGHT = MediaQuery.of(context).size.height;
    WIDHT = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color.fromRGBO(300, 300, 300, 1),
        body: Padding(
          padding: EdgeInsets.only(top:HEIGHT *0.15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Components.mediumText("Tu código de entrada")),
              Padding(
                padding: EdgeInsets.only(top:HEIGHT *0.05),
                child: QrImage(
                  foregroundColor: Color.fromRGBO(230, 73, 90, 1) ,
                  data: myAppointment.uid,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left:HEIGHT*0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left:HEIGHT*0.001,top:HEIGHT *0.02),
                      child: Components.largeText("Detalles de la reserva"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:HEIGHT*0.001,top:HEIGHT *0.01),
                      child: Components.mediumText(myAppointment.uid),
                    ),
                    Components.mediumText(myAppointment.businessName),
                    Components.mediumText(myAppointment.direction),
                    Components.mediumText("Personas: "+myAppointment.extraInformation),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}
