import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/service.dart';

import 'user.dart';

class Appointment {
  final User user;
  final Employe employe;
  final Service service;
  final DateTime checkIn;
  final DateTime checkOut;

  Appointment(
      this.user, this.employe, this.service, this.checkIn, this.checkOut);
}
