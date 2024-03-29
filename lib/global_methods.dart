import 'package:cuthair/data/remote/http_remote_repository.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'data/local/db_sqlite.dart';
import 'ui/Pages/bottom_navigation/menu.dart';
import 'ui/Pages/login/login.dart';

class GlobalMethods {
  BuildContext context;
  var storage = FlutterSecureStorage();
  RemoteRepository _remoteRepository =
  HttpRemoteRepository(Client());

  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  void pushAndReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => widget));
  }

  void popPage(BuildContext page) {
    Navigator.pop(page);
  }

  removePages(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  removePagesAndGoToNewScreen(BuildContext context, Widget widget) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  generateNewAccessToken(String refreshToken) async {
    String newToken = await _remoteRepository.generateNewToken(refreshToken);
    await storage.write(key: 'AccessToken', value: newToken);
  }

  searchDBUser(BuildContext context) async {
    Widget screen;
    await DBProvider.db.getUser();
    if (DBProvider.users.length > 0) {
      try {
        screen = Menu(DBProvider.users[0]);
      } catch (e) {
        DBProvider.db.delete();
        screen = Login();
      }
    } else {
      screen = Login();
    }

    return screen;
  }
}

class GetTimeSeparated {
  static Future<List<dynamic>> getTimeSeparatedBy10(
      DateTime checkIn, DateTime checkOut) async {
    List<String> list = [];
    var duration = checkOut.difference(checkIn).inMinutes;
    duration ~/= 10;
    for (int i = 0; duration > i; i++) {
      DateTime date = checkIn.add(Duration(minutes: (10 * i)));
      date.minute.toString().length == 1
          ? list.add(date.hour.toString() + ":" + date.minute.toString() + '0')
          : list.add(date.hour.toString() + ":" + date.minute.toString());
    }
    return list;
  }

  static List<String> getHours(
      String checkIn, String checkOut, DateTime dayId) {
    List<String> hours = [];

    List<String> arrayCheckIn = checkIn.split(":");
    List<String> arrayCheckOut = checkOut.split(":");

    String initialHour = arrayCheckIn[0];
    String finalHour = arrayCheckOut[0];

    String initialMinute = arrayCheckIn[1];
    String finalMinute = arrayCheckOut[1];

    DateTime initialTime = dayId;
    DateTime finalTime = dayId;

    initialTime = initialTime.add(Duration(
        hours: int.parse(initialHour), minutes: int.parse(initialMinute)));
    finalTime = finalTime.add(
        Duration(hours: int.parse(finalHour), minutes: int.parse(finalMinute)));

    while (
        int.parse(finalTime.difference(initialTime).inMinutes.toString()) > 0) {
      String minute = initialTime.minute.toString().length == 1
          ? initialTime.minute.toString() + '0'
          : initialTime.minute.toString();
      hours.add(initialTime.hour.toString() + ":" + minute);
      initialTime = initialTime.add(Duration(minutes: 10));
    }

    return hours;
  }

  static getFullTimeIfHasOneValue_Hour(String time) {
    if (time.length == 1) {
      return time + "0";
    } else {
      return time;
    }
  }

  static getFullTimeIfHasOneValue_Month(String time) {
    if (time.length == 1) {
      return "0" + time;
    } else {
      return time;
    }
  }

  static getDurationFromMinutes(int minute) {
    double hours = minute / 60;
    int minutes = minute % 60;
    return Duration(hours: hours.toInt(), minutes: minutes);
  }
}

class Images {
  Future<List<Widget>> getChilds(
      List<String> listImagesFirebase, String predefine) async {
    List<Widget> images = [];
    Image image;
    listImagesFirebase.forEach((f) => {
          f.length != 0
              ? image = Image.network(
                  f,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(230, 73, 90, 1)),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                )
              : image = getDefaultImage(predefine),
          images.add(image)
        });
    return images;
  }

  Widget getDefaultImage(String predefine) {
    List pieceImage = predefine.split(".");
    if (pieceImage.last == "svg") {
      return SvgPicture.asset(
        predefine,
      );
    } else {
      return Image.asset(
        predefine,
      );
    }
  }
}
