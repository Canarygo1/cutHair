
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';

class HttpRemoteRepository implements RemoteRepository {
  Firestore firestore;

  HttpRemoteRepository(this.firestore);

  @override
  Future<List<HairDressing>> getAllHairdressing() async {
    QuerySnapshot querySnapshot =
    await firestore.collection("Peluquerias").getDocuments();
    List queryData = querySnapshot.documents;
    List<HairDressing> allHairDressing = [];

    for (int i = 0; i < queryData.length; i++) {
      HairDressing hairDressing = HairDressing.fromMap(queryData[i].data);
      allHairDressing.add(hairDressing);
    }

    return allHairDressing;
  }

  @override
  Future<List<Service>> getAllServices() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("servicios")
        .getDocuments();
    List<Service> services = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      String tipo = querySnapshot.documents[i].documentID;
      services.add(Service.fromMap(querySnapshot.documents[i].data, tipo));
    }
    return services;
  }

  @override
  Future<List<Employe>> getAllEmployes() async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados").getDocuments();
    List<Employe>employes = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      Employe employe = Employe(querySnapshot.documents[i].data['Nombre']);
      print(employe.name);
      employes.add(employe);
    }
    return employes;
  }

  @override
  Future<User> getUser(String uid) async {
    DocumentSnapshot document = await firestore.collection("Usuarios").document(uid).get();
    User user = User.fromMap(document.data,uid);
    return user;
  }
}
