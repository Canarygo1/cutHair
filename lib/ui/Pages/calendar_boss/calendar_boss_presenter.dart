import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';


class CalendarBossPresenter {
  CalendarBossView _calendarBossView;
  Employe employe;
  List<String> hours = [];

  CalendarBossPresenter(this._calendarBossView, this.employe);

  init(List<Day> days) async {
    String initialHour = days[0].checkIn.length == 3
        ? days[0].checkIn.substring(0, 1)
        : days[0].checkIn.substring(0, 2);
    String finalHour = days[0].checkOut.length == 3
        ? days[0].checkOut.substring(0, 1)
        : days[0].checkOut.substring(0, 2);
    DateTime initialTime = days[0].dayId;
    DateTime finalTime = days[0].dayId;
    initialTime =
        initialTime.add(Duration(hours: int.parse(initialHour), minutes: 0));
    finalTime =
        finalTime.add(Duration(hours: int.parse(finalHour), minutes: 0));
    while (initialTime.hour < finalTime.hour) {
      hours.add(
          initialTime.hour.toString() + "-" + initialTime.minute.toString());
      initialTime = initialTime.add(Duration(minutes: 10));
    }
    for (Day day in days) {
      addSchedule(day);
    }
    hours.clear();
  }

  addSchedule(day) async {
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document(employe.name)
        .collection("horarios")
        .document(day.dayId.toString())
        .setData({"disponibilidad": hours}, merge: true);
    hours.clear();
  }
}

abstract class CalendarBossView {}
