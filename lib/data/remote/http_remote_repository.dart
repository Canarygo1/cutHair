import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employe.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/hairDressing.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    if (allHairDressing.length >= 1) {
      return allHairDressing;
    } else {
      throw("No existen peluquerias");
    }
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

    if (services.length >= 1) {
      return services;
    } else {
      throw("No existen servicios de esta peluqueria");
    }
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

    if (employes.length >= 1) {
      return employes;
    } else {
      throw("No existen empleados");
    }
  }

  @override
  Future<User> getUser(String uid) async {
    DocumentSnapshot document =
    await firestore.collection("Usuarios").document(uid).get();
    User user = User.fromMap(document.data, uid);

    if (user != null) {
      return user;
    } else {
      throw("No existe ese usuario");
    }
  }

  @override
  Future<List<String>> getAllImages(HairDressing hairDressing) async {
    List<String> list = [];
    for (int i = 0; i < hairDressing.numeroFotos; i++) {
      String nombre = hairDressing.uid + "/" + i.toString() + ".jpeg";
      String url =
      await FirebaseStorage.instance.ref().child(nombre).getDownloadURL();
      list.add(url);
    }

    if (list.length >= 1) {
      return list;
    } else {
      throw("No existe imagenes en la base de datos de esta peluqueria");
    }
  }

  @override
  Future<bool> insertAppointment(Appointment appointment, String uid) async {
    var val = [];
    var duration =
        appointment.checkOut
            .difference(appointment.checkIn)
            .inMinutes;
    duration ~/= 10;
    for (int i = 0; duration > i; i++) {
      DateTime date = appointment.checkIn.add(Duration(minutes: (10 * i)));
      val.add(date.hour.toString() + "-" + date.minute.toString());
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
      "idUsuario": uid,
      "CheckIn": appointment.checkIn.toString(),
      "CheckOut": appointment.checkOut.toString(),
      "Peluqueria": "Privilege",
      "Servicio": appointment.service.tipo,
      "Precio": appointment.service.precio
    });

    List refList = [docRef];
    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    await firestore
        .collection("Peluquerias")
        .document("PR01")
        .collection("empleados")
        .document("Carlos")
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    return null;
  }

  @override
  Future<bool> insertSchedule(String employe, String hairDressingUid,
      String day, List<Map<String, dynamic>> schedules,
      List<String> hours) async {
    await firestore
        .collection("Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(employe)
        .collection("horarios")
        .document(day)
        .setData({"turnos": FieldValue.arrayUnion(schedules),
      "disponibilidad": FieldValue.arrayUnion(hours), "Uid": day}, merge: true);
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

    if (myAppointments.length >= 1) {
      return myAppointments;
    } else {
      throw("No existen citas de esta peluqueria");
    }
  }

  @override
  Future<HairDressing> getHairdressingByUid(String hairdressingUid) async {
    DocumentSnapshot documentSnapshot = await firestore.collection(
        "Peluquerias").document(hairdressingUid).get();
    HairDressing hairDressing = HairDressing.fromMap(
        documentSnapshot.data, hairdressingUid);


    if (hairDressing != null) {
      return hairDressing;
    } else {
      throw("No existen peluquerias");
    }
  }

  @override
  Future<Schedule> getRange(String day, Employe employe,
      String hairDressingUid) async {
    DocumentSnapshot documentSnapshot = await firestore.collection(
        "Peluquerias")
        .document(hairDressingUid)
        .collection("empleados")
        .document(employe.name)
        .collection("horarios")
        .document(day).get();

    if (documentSnapshot.data != null) {
      Schedule schedule = Schedule.fromMap(documentSnapshot.data, day);
      return schedule;
    } else {
      throw Exception("No hay horarios");
    }
  }

  @override
  Future<bool> removeRange(DateTime day, String name,
      String hairDressingUid, Map ranges) {
    var val = [];
    DateTime checkIn = day.add(Duration(hours: int.parse(ranges["Entrada"])));
    DateTime checkOut = day.add(Duration(hours: int.parse(ranges["Salida"])));

    var duration =
        checkOut
            .difference(checkIn)
            .inMinutes;
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
  Future<bool> removeAppointment(MyAppointment appointment, int index) async{

    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot documentsnap = await firestore.collection("Usuarios")
        .document(user.uid)
        .get();


    DocumentReference documentReference = documentsnap.data["citas"][index];
    String idPeluqueria = documentReference.parent().parent().documentID;

    List ref = [];
    ref.add(documentReference.path);
    
    await firestore
        .collection("Peluquerias")
        .document(idPeluqueria)
        .collection("empleados")
        .document(appointment.hairdresser)
        .updateData({"citas": FieldValue.arrayRemove(ref)});
    
    await firestore
        .collection("Usuarios")
        .document(user.uid)
        .updateData({"citas": FieldValue.arrayRemove(ref)});


    documentReference.delete();
  }
}
