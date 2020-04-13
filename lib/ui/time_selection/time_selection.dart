import 'package:cuthair/model/appointment.dart';
import 'package:flutter/cupertino.dart';

class TimeSelection extends StatefulWidget {
  Appointment appointment;

  TimeSelection(this.appointment);

  @override
  _TimeSelectionState createState() => _TimeSelectionState();
}

class _TimeSelectionState extends State<TimeSelection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("hola"),
        ],
      ),
    );
  }
}
