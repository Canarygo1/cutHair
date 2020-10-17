import 'package:cuthair/model/Place.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/business_type.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/user.dart';

class AppointmentCompleted {
  Employee employee;
  Place place;
  Business business;
  Service service;
  BusinessType businessType;
  Appointment appointment;
  User user;

  AppointmentCompleted(this.appointment, this.business, this.businessType, this.service, this.user, {this.employee, this.place});

}
