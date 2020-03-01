import 'package:cuthair/model/hairDressing.dart';

abstract class RemoteRepository{
  Future<List<HairDressing>> getAllHairdressing();
}