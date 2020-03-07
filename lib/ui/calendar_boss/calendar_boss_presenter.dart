import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/employe.dart';

class CalendarBossPresenter {
  CalendarBossView _calendarBossView;
  Employe employe;

  CalendarBossPresenter(this._calendarBossView, this.employe);

  init() async {
    print("hola");
    final databaseReference = Firestore.instance;
    await databaseReference
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document(employe.name)
        .collection("horarios")
        .document("13-02-2020")
        .setData({"disponibilidad": "prueba"}, merge: true);
  }
}

abstract class CalendarBossView {}
