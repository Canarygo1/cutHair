import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/day.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/getTimeSeparated.dart';
import 'package:cuthair/model/schedule.dart';

class CalendarPresenter {
  CalendarView _calendarBossView;
  Employe employe;
  List<String> hours = [];
  RemoteRepository _remoteRepository;
  String hairDressingUid;

  CalendarPresenter(this._calendarBossView, this.employe, this.hairDressingUid, this._remoteRepository);

  init(String day) async {
    try {
      _calendarBossView.updateList(
          await _remoteRepository.getRange(day, employe.name, hairDressingUid));
    }catch(e){
      print(e.toString());
    }
  }

  insertSchedule(List<Day> days) async {
    hours.clear();
    String initialHour = days[0].checkIn.length == 4
        ? days[0].checkIn.substring(0, 1)
        : days[0].checkIn.substring(0, 2);
    String finalHour = days[0].checkOut.length == 4
        ? days[0].checkOut.substring(0, 1)
        : days[0].checkOut.substring(0, 2);

    hours = getTimeSeparated.getHours(days[0].checkIn, days[0].checkOut, days[0].dayId);

    List<Map<String, dynamic>> schedules = [];
    Map<String, dynamic> range = {"Entrada": initialHour, "Salida": finalHour, "Uid": ""};
    schedules.add(range);

    for (Day day in days) {
      schedules[0].update("Uid", (index) => day.dayId.toString(), ifAbsent: () => day.dayId.toString());
      await _remoteRepository.insertSchedule(employe.name, hairDressingUid, day.dayId.toString(), schedules, hours);
    }
  }
}

abstract class CalendarView {
  insertSchedule();
  updateList(Schedule schedule);
}
