import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/RemoteRepository.dart';
import 'package:cuthair/model/hairDressing.dart';

class HttpRemoteRepository implements RemoteRepository {
  Firestore firestore;

  HttpRemoteRepository(this.firestore);

  @override
  Future<List<HairDressing>> getAllHairdressing() async {
    // TODO: implement getAllHairdressing
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("Peluquerias").getDocuments();
    List queryData = querySnapshot.documents;
    List<HairDressing> allHairDressing = [];

    for (int i = 0; i < queryData.length; i++) {
      HairDressing hairDressing = HairDressing.fromMap(queryData[i].data);
      allHairDressing.add(hairDressing);
    }
    return allHairDressing;
  }
}
