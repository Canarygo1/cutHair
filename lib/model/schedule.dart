
class Schedule{
  DateTime uid;
  List disponibility;
  List ranges;

  Schedule(this.uid, this.disponibility, this.ranges);

  factory Schedule.fromMap(Map values, String uid) {
    List disponibility = values["disponibilidad"];
    List range =  values["turnos"];

    return Schedule(DateTime.parse(uid), disponibility, range);
  }
}