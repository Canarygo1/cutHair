import 'package:cuthair/model/appointment.dart';
 import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';

abstract class RemoteRepository {

  Future <List<String>> getBusiness();

  Future<Map<String, List<HairDressing>>> getAllBusiness(String business);

  Future<List<Service>> getAllServices(String uid, String typeBusiness);

  Future<List<Employe>> getAllEmployes(String uid, String typeBusiness);

  Future<User> getUser(String uid);

  Future<List<String>> getAllImages(HairDressing hairDressing);

  Future<bool> insertAppointment(Appointment appointment,String uid);

  Future<List<MyAppointment>> getUserAppointments(String uid);

  //Future<HairDressing> getHairdressingByUid(String hairdressingUid);

  Future<User> getUserByPhoneNumber(String phoneNumber);

  Future<User> insertAnonymousUser(User user);

  //Future<bool> insertSchedule(String employe, String hairDressingUid, String day, String typeBusiness, List<Map<String, dynamic>> schedules, List<String> hours);

  Future<Schedule> getRange(String day, String name, String hairDressingUid, String typeBusiness);

  Future<bool> removeRange(DateTime day, String name, String hairDressingUid, String typeBusiness, Map ranges);

  Future<bool> removeAppointment(MyAppointment appointment, int index);

  Future<bool> getUserPenalize(String uid);
}
