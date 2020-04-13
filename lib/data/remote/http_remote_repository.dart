import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
      HairDressing hairDressing =
          HairDressing.fromMap(queryData[i].data, queryData[i].documentID);
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
        .collection("empleados")
        .getDocuments();
    List<Employe> employes = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      Employe employe = Employe(querySnapshot.documents[i].data['Nombre']);
      print(employe.name);
      employes.add(employe);
    }
    return employes;
  }

  @override
  Future<User> getUser(String uid) async {
    DocumentSnapshot document =
        await firestore.collection("Usuarios").document(uid).get();
    User user = User.fromMap(document.data, uid);

    return user;
  }

  @override
  Future<List<String>> getAllImages(HairDressing hairDressing) async {
    List<String> lista = [];
    for (int i = 0; i < hairDressing.numeroFotos; i++) {
      String nombre = hairDressing.uid + "/" + i.toString() + ".jpeg";
      String url =
          await FirebaseStorage.instance.ref().child(nombre).getDownloadURL();
      lista.add(url);
    }
    return lista;
  }

  @override
  Future<bool> insertAppointment(Appointment appointment, String uid) async {
    var val = [];
    var duration =
        appointment.checkOut.difference(appointment.checkIn).inMinutes;
    duration ~/= 10;
    for (int i = 0; duration > i; i++) {
      DateTime date = appointment.checkIn.add(Duration(minutes: (10 * i)));
      val.add(date.hour.toString() + "-" + date.minute.toString());
      print(val[i]);
    }

    firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document("Carlos")
        .collection("horarios")
        .document("2020-04-13 00:00:00.000")
        .updateData({"disponibilidad": FieldValue.arrayRemove(val)});

    DocumentReference docRef = await firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("citas")
        .add({
      "Peluquero": appointment.employe.name,
      "idUsuario":uid,
      "CheckIn": appointment.checkIn.toString(),
      "CheckOut": appointment.checkOut.toString(),
      "Peluqueria":"Privilege",
      "Servicio":appointment.service.tipo,
      "Precio":appointment.service.precio
    });
    List refList = [docRef];
    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
//Todo:Hay que hacer qu la peluqueria sea una variable
    await firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document("Carlos")
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    return null;
  }

  @override
  Future<List<MyAppointment>> getUserAppointments(String uid) async {
    List<MyAppointment> myAppointments = [];
    DocumentSnapshot documentSnapshot =
        await firestore.collection("Usuarios").document(uid).get();
        for(int i= 0;i<documentSnapshot.data['citas'].length;i++){
          await documentSnapshot.data['citas'][i].get().then((datasnapshot){
            MyAppointment myAppointment = MyAppointment.fromMap(datasnapshot.data);
            return myAppointment;
          }).then((myAppointment){
            myAppointments.add(myAppointment);
          });
        }
    return myAppointments;
  }
}
