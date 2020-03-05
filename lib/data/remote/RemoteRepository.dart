import 'package:cuthair/model/Service.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/hairDressing.dart';

abstract class RemoteRepository {
  Future<List<HairDressing>> getAllHairdressing();

  Future<List<Service>> getAllServices();

  Future<List<Employe>> getAllEmployes();
}
