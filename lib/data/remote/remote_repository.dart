import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/user.dart';

abstract class RemoteRepository {
  Future<List<String>> getBusiness();

  Future<Map<String, List<Business>>> getAllBusiness(String business);


  Future<List<Service>> getAllServices(String uid, String typeBusiness);

  Future<List<Employee>> getAllEmployes(String uid, String typeBusiness);

  Future<User> getUser(String uid);

  Future<String> getOneImage(
      String businessUid, String employeeName, String directory);

  Future<List<String>> getAllImages(Business business);

  Future<bool> insertAppointmentHairDressing(
      Appointment appointment, String uid);

  Future<bool> insertAppointmentRestaurant(Appointment appointment, String uid);

  Future<List<MyAppointment>> getUserAppointments(
      String uid, DateTime date, bool firstTime);

  Future<bool> insertAppointmentBeach(Appointment appointment, String uid);

  Future<User> getUserByPhoneNumber(String phoneNumber);

  Future<User> insertAnonymousUser(User user);

  Future<Schedule> getRange(
      String day, String name, String businessUid, String typeBusiness);

  Future<bool> removeRange(DateTime day, String name, String businessUid,
      String typeBusiness, Map ranges);

  Future<bool> removeAppointment(MyAppointment appointment);

  Future<bool> getUserPenalize(String uid);
}
