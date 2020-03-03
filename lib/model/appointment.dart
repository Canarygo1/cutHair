import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/service.dart';

import 'user.dart';

class Appointment {
  User _user;
  Employe _employe;
  Service _service;
  DateTime _checkIn;
  DateTime _checkOut;

  Appointment();

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Employe get employe => _employe;

  set employe(Employe value) {
    _employe = value;
  }

  Service get service => _service;

  set service(Service value) {
    _service = value;
  }

  DateTime get checkIn => _checkIn;

  set checkIn(DateTime value) {
    _checkIn = value;
  }

  DateTime get checkOut => _checkOut;

  set checkOut(DateTime value) {
    _checkOut = value;
  }
}
