import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';

abstract class RemoteRepository {
  Future<List<HairDressing>> getAllHairdressing();

  Future<List<Service>> getAllServices();

  Future<List<Employe>> getAllEmployes();

  Future<User> getUser(String uid);

  Future<bool> insertAppointment(Appointment appointment,String uid);
}
