import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/user.dart';

import 'hairDressing.dart';

class Appointment {
  User user;
  Employee employe;
  Service service;
  DateTime checkIn;
  DateTime checkOut;
  HairDressing hairDressing;
  DateTime day;
}
