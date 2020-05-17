import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/user.dart';

import 'business.dart';

class Appointment {
  User user;
  Employee employee;
  Service service;
  DateTime checkIn;
  DateTime checkOut;
  Business business;
  DateTime day;
  String numberPersons;
}
