import 'package:cuthair/model/Employe.dart';
import 'package:cuthair/model/Service.dart';

import 'User.dart';

class Appointment {
  final User user;
  final Employe employe;
  final Service service;
  final DateTime checkIn;
  final DateTime checkOut;

  Appointment(
      this.user, this.employe, this.service, this.checkIn, this.checkOut);
}
