import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';

abstract class RemoteRepository {
  Future<List<HairDressing>> getAllHairdressing();

  Future<List<Service>> getAllServices();

  Future<List<Employe>> getAllEmployes();

  Future<User> getUser(String uid);

  Future<List<String>> getAllImages(HairDressing hairDressing);
  
  Future<bool> insertAppointment(Appointment appointment,String uid);

  Future<List<MyAppointment>> getUserAppointments(String uid);

  Future<HairDressing> getHairdressingByUid(String hairdressingUid);

  Future<User> getUserByPhoneNumber(String phoneNumber);

  Future<User> insertAnonymousUser(User user);
}
