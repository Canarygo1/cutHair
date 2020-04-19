import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/schedule.dart';
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
      services.add(Service.fromMap(querySnapshot.documents[i].data));
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
      val.add(date.hour.toString() + '-' + date.minute.toString());
    }
    firestore
        .collection("Peluquerias")
        .document(appointment.hairDressing.uid)
        .collection("empleados")
        .document(appointment.employe.name)
        .collection("horarios")
        .document(appointment.day.toString())
        .updateData({"disponibilidad": FieldValue.arrayRemove(val)});

    DocumentReference docRef = await firestore
        .collection("Peluquerias")
        .document(appointment.hairDressing.uid)
        .collection("citas")
        .add({
      "Peluquero": appointment.employe.name,
      "idUsuario": uid,
      "CheckIn": appointment.checkIn.toString(),
      "CheckOut": appointment.checkOut.toString(),
      "Peluqueria": appointment.hairDressing.name,
      "Servicio": appointment.service.type,
      "Precio": appointment.service.price
    });
    List refList = [docRef];
    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
    await firestore
        .collection("Peluquerias")
        .document(appointment.hairDressing.uid)
        .collection("empleados")
        .document(appointment.employe.name)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    return null;
  }

  @override
  Future<bool> insertSchedule(
      String employe,
      String hairDressingUid,
      String day,
      List<Map<String, dynamic>> schedules,
      List<String> hours) async {
    await firestore
        .collection("Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(employe)
        .collection("horarios")
        .document(day)
        .setData({
      "turnos": FieldValue.arrayUnion(schedules),
      "disponibilidad": FieldValue.arrayUnion(hours)
    }, merge: true);
  }

  @override
  Future<List<MyAppointment>> getUserAppointments(String uid) async {
    List<MyAppointment> myAppointments = [];
    DocumentSnapshot documentSnapshot =
        await firestore.collection("Usuarios").document(uid).get();
    for (int i = 0; i < documentSnapshot.data['citas'].length; i++) {
      await documentSnapshot.data['citas'][i].get().then((datasnapshot) {
        DocumentReference documentReference = documentSnapshot.data['citas'][i];
        MyAppointment myAppointment = MyAppointment.fromMap(
            datasnapshot.data, documentReference.documentID);
        return myAppointment;
      }).then((myAppointment) {
        myAppointments.add(myAppointment);
      });
    }
    return myAppointments;
  }

  @override
  Future<HairDressing> getHairdressingByUid(String hairdressingUid) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection("Peluquerias")
        .document(hairdressingUid)
        .get();
    HairDressing hairDressing =
        HairDressing.fromMap(documentSnapshot.data, hairdressingUid);
    return hairDressing;
  }

  @override
  Future<User> getUserByPhoneNumber(String phoneNumber) async {
    User user;
    CollectionReference collectionReference = firestore.collection("Usuarios");
    var query = await collectionReference
        .where('Telefono', isEqualTo: phoneNumber)
        .getDocuments()
        .then((snapshot) {
      if (snapshot.documents.length < 1) {
        throw Exception;
      }
      return [snapshot.documents[0].data, snapshot.documents[0].documentID];
    }).then((data) async {
      user = User.fromMap(data[0], data[1]);
    });
    return user;
  }

  @override
  Future<User> insertAnonymousUser(User user) async {
    DocumentReference docRef = await firestore.collection("Anonimos").add({
      "Nombre": user.name,
      "Telefono": user.phone,
    });
    user.uid = docRef.documentID;
    return user;
  }

  Future<Schedule> getRange(
      String day, Employe employe, String hairDressingUid) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection("Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(employe.name)
        .collection("horarios")
        .document(day)
        .get();

    if (documentSnapshot.data != null) {
      Schedule schedule = Schedule.fromMap(documentSnapshot.data, day);
      return schedule;
    } else {
      return null;
    }
  }

  @override
  Future<bool> removeRange(
      DateTime day, String name, String hairDressingUid, Map ranges) {
    var val = [];
    DateTime checkIn = day.add(Duration(hours: int.parse(ranges["Entrada"])));
    DateTime checkOut = day.add(Duration(hours: int.parse(ranges["Salida"])));

    var duration = checkOut.difference(checkIn).inMinutes;
    duration ~/= 10;
    for (int i = 0; duration > i; i++) {
      DateTime date = checkIn.add(Duration(minutes: (10 * i)));
      val.add(date.hour.toString() + "-" + date.minute.toString());
    }

    var maplist = [];
    maplist.add(ranges);

    firestore
        .collection("Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(name)
        .collection("horarios")
        .document(day.toString())
        .updateData({"turnos": FieldValue.arrayRemove(maplist)});

    firestore
        .collection("Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(name)
        .collection("horarios")
        .document(day.toString())
        .updateData({"disponibilidad": FieldValue.arrayRemove(val)});
  }

  @override
  Future<bool> removeAppointment(MyAppointment appointment, int index) {
    return null;
  }
}
