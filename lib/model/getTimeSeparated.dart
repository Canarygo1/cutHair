import 'day.dart';

class getTimeSeparated {

  static Future<List<dynamic>> getTimeSeparatedBy10 (
      DateTime checkIn, DateTime checkOut) async {
    List<String> list = [];
    var duration = checkOut.difference(checkIn).inMinutes;
    duration ~/= 10;
    for (int i = 0; duration > i; i++) {
      DateTime date = checkIn.add(Duration(minutes: (10 * i)));
      list.add(date.hour.toString() + "-" + date.minute.toString());
    }

    return list;
  }

  static List<String> getHours(String checkIn, String checkOut, DateTime dayId){
    List<String> hours = [];

    List<String> arrayCheckIn = checkIn.split(":");
    List<String> arrayCheckOut = checkOut.split(":");

    String initialHour = arrayCheckIn[0];
    String finalHour = arrayCheckOut[0];

    String initialMinute = arrayCheckIn[1];
    String finalMinute = arrayCheckOut[1];

    DateTime initialTime = dayId;
    DateTime finalTime = dayId;

    initialTime =
        initialTime.add(Duration(hours: int.parse(initialHour), minutes: int.parse(initialMinute)));
    finalTime =
        finalTime.add(Duration(hours: int.parse(finalHour), minutes: int.parse(finalMinute)));

    while (int.parse(finalTime.difference(initialTime).inMinutes.toString()) > 0) {
      hours.add(
          initialTime.hour.toString() + ":" + initialTime.minute.toString());
      initialTime = initialTime.add(Duration(minutes: 10));
    }

    return hours;
  }
}
