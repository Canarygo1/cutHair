import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/schedule.dart';


class CalendarBossPresenter {
  CalendarBossView _calendarBossView;
  Employe employe;
  List<String> hours = [];
  RemoteRepository _remoteRepository;
  String hairDressingUid;

  CalendarBossPresenter(this._calendarBossView, this.employe, this.hairDressingUid, this._remoteRepository);

  init(String day) async {
    _calendarBossView.updateList(await _remoteRepository.getRange(day, employe, hairDressingUid));
  }

  insertSchedule(List<Day> days){
    hours.clear();

    String initialHour = days[0].checkIn.length == 4
        ? days[0].checkIn.substring(0, 1)
        : days[0].checkIn.substring(0, 2);
    String finalHour = days[0].checkOut.length == 4
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
          initialTime.hour.toString() + ":" + initialTime.minute.toString());
      initialTime = initialTime.add(Duration(minutes: 10));
    }

    List<Map<String, dynamic>> schedules = [];
    Map<String, dynamic> range = {"Entrada": initialHour, "Salida": finalHour, "Uid": ""};
    schedules.add(range);

    for (Day day in days) {
      schedules[0].update("Uid", (index) => day.dayId.toString(), ifAbsent: () => day.dayId.toString());
      _remoteRepository.insertSchedule(employe.name, hairDressingUid, day.dayId.toString(), schedules, hours);
    }

  }


}

abstract class CalendarBossView {
  insertSchedule();

  updateList(Schedule schedule);

}
