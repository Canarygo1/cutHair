import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';

class CalendarBossPresenter {
  CalendarBossView _calendarBossView;
  Employe employe;

  CalendarBossPresenter(this._calendarBossView, this.employe);

  init(Day day) async {
    final databaseReference = Firestore.instance;
    print(day.dayId.toString());
    await databaseReference
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document(employe.name)
        .collection("horarios")
        .document(day.dayId.toString())
        .setData({
      "disponibilidad": day.checkIn.toString() + " - " + day.checkOut.toString()
    }, merge: true);
  }
}

abstract class CalendarBossView {}
