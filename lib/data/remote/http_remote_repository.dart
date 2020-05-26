import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuthair/data/remote/remote_repository.dart';
import 'package:cuthair/global_methods.dart';
import 'package:cuthair/model/appointment.dart';
import 'package:cuthair/model/employee.dart';
import 'package:cuthair/model/my_appointment.dart';
import 'package:cuthair/model/schedule.dart';
import 'package:cuthair/model/service.dart';
import 'package:cuthair/model/business.dart';
import 'package:cuthair/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class HttpRemoteRepository implements RemoteRepository {
  Firestore firestore;

  HttpRemoteRepository(this.firestore);

  Future<List<String>> getBusiness() async {
    QuerySnapshot querySnapshot =
        await firestore.collection("Negocios").getDocuments();

    List<String> business = [];
    querySnapshot.documents.forEach((v) => {business.add(v.documentID)});
    return business;
  }

  @override
  Future<Map<String, List<Business>>> getAllBusiness(String business) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Negocios")
        .document(business)
        .collection("Negocios")
        .getDocuments();
    List queryData = querySnapshot.documents;
    List<Business> allHairDressing = [];

    for (int i = 0; i < queryData.length; i++) {
      Business hairDressing = Business.fromMap(
          queryData[i].data, queryData[i].documentID, business);
      allHairDressing.add(hairDressing);
    }

    Map<String, List<Business>> allbusiness = new Map();
    allbusiness[business] = allHairDressing;

    if (allbusiness.length >= 1) {
      return allbusiness;
    } else {
      throw ("No existen peluquerias");
    }
  }

  @override
  Future<List<Service>> getAllServices(String uid, String typeBusiness) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Negocios")
        .document(typeBusiness)
        .collection("Negocios")
        .document(uid)
        .collection("servicios")
        .getDocuments();
    List<Service> services = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      services
          .add(Service.fromMap(querySnapshot.documents[i].data, typeBusiness));
    }

    if (services.length >= 1) {
      return services;
    } else {
      throw ("No existen servicios de esta peluqueria");
    }
  }

  @override
  Future<List<Employee>> getAllEmployes(String uid, String typeBusiness) async {
    QuerySnapshot querySnapshot = await firestore
        .collection("Negocios")
        .document(typeBusiness)
        .collection("Negocios")
        .document(uid)
        .collection("empleados")
        .getDocuments();

    List<Employee> employes = [];
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      Employee employe = Employee(
          querySnapshot.documents[i].data['Nombre'],
          querySnapshot.documents[i].documentID,
          querySnapshot.documents[i].data["orden"]);
      employes.add(employe);
    }

    if (employes.length >= 1) {
      return employes;
    } else {
      throw ("No existen empleados");
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
      throw ("No existe ese usuario");
    }
  }

  @override
  Future<String> getOneImage(
      String businessUid, String employeeName, String directory) async {
    String url = "";
    String nombre =
        businessUid + "/" + directory + "/" + employeeName + ".jpeg";
    try {
      url = await FirebaseStorage.instance.ref().child(nombre).getDownloadURL();
      return url;
    } catch (e) {
      return "";
    }
  }

  @override
  Future<List<String>> getAllImages(Business business) async {
    List<String> list = [];
    for (int i = 0; i < business.numeroFotos; i++) {
      String nombre = business.uid + "/Gallery/" + i.toString() + ".jpeg";
      String url =
          await FirebaseStorage.instance.ref().child(nombre).getDownloadURL();
      list.add(url);
    }

    if (list.length >= 1) {
      return list;
    } else {
      throw ("No existe imagenes en la base de datos de esta peluqueria");
    }
  }

  @override
  Future<bool> insertAppointmentHairDressing(
      Appointment appointment, String uid) async {
    var val = [];
    val = await GetTimeSeparated.getTimeSeparatedBy10(
        appointment.checkIn, appointment.checkOut);

    firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.employee.uid)
        .collection("horarios")
        .document(appointment.day.toString())
        .updateData({"disponibilidad": FieldValue.arrayRemove(val)});

    DocumentReference docRef = await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("citas")
        .add({
      "extraInformation": appointment.employee.name,
      "idUsuario": uid,
      "CheckIn": appointment.checkIn.toString(),
      "CheckOut": appointment.checkOut.toString(),
      "Negocio": appointment.business.name,
      "Servicio": appointment.service.type,
      "Precio": appointment.service.price,
      "Direccion": appointment.business.direction
    });

    List refList = [docRef];
    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
    await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.employee.uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
  }

  @override
  Future<List<MyAppointment>> getUserAppointments(
      String uid, DateTime date, bool firstTime) async {

    List<MyAppointment> myAppointments = [];
    DocumentSnapshot documentSnapshot =
        await firestore.collection("Usuarios").document(uid).get();

    for (int i = 0; i < documentSnapshot.data['citas'].length; i++) {
      await documentSnapshot.data['citas'][i].get().then((datasnapshot) {
        DocumentReference documentReference = documentSnapshot.data['citas'][i];
        MyAppointment myAppointment = MyAppointment.fromMap(
            datasnapshot.data,
            documentReference.documentID,
            documentReference.parent().parent().documentID,
            documentReference.parent().parent().parent().parent().documentID,
            documentReference);
        DateTime checkIn = DateTime.parse(myAppointment.checkIn);
        DateTime dateTime = DateTime.parse(myAppointment.checkIn).subtract(
            Duration(
                microseconds: checkIn.microsecond,
                milliseconds: checkIn.millisecond,
                seconds: checkIn.second,
                minutes: checkIn.minute,
                hours: checkIn.hour));
        if (!firstTime) {
          if (date == dateTime) {
            return myAppointment;
          }
        } else {
          if (dateTime.isAfter(date)) {
            return myAppointment;
          }
        }
      }).then((myAppointment) {
        if (myAppointment != null) {
          myAppointments.add(myAppointment);
        }
      });
    }

    if (myAppointments.length >= 1) {
      return myAppointments;
    } else {
      throw ("No existen citas de esta peluqueria");
    }
  }

  @override
  Future<bool> removeRange(DateTime day, String name, String businessUid,
      String typeBusiness, Map ranges) async {
    var val = [];

    DateTime checkIn = day.add(Duration(hours: int.parse(ranges["Entrada"])));
    DateTime checkOut = day.add(Duration(hours: int.parse(ranges["Salida"])));

    val = await GetTimeSeparated.getTimeSeparatedBy10(checkIn, checkOut);

    var maplist = [];
    maplist.add(ranges);

    firestore
        .collection("Negocios")
        .document(typeBusiness)
        .collection("Negocios")
        .document(businessUid)
        .collection("empleados")
        .document(name)
        .collection("horarios")
        .document(day.toString())
        .updateData({"turnos": FieldValue.arrayRemove(maplist)});

    firestore
        .collection("Negocios")
        .document(typeBusiness)
        .collection("Negocios")
        .document(businessUid)
        .collection("empleados")
        .document(name)
        .collection("horarios")
        .document(day.toString())
        .updateData({"disponibilidad": FieldValue.arrayRemove(val)});
  }

  @override
  Future<Schedule> getRange(
      String day, String name, String businessUid, String typeBusiness) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection("Negocios")
        .document(typeBusiness)
        .collection("Negocios")
        .document(businessUid)
        .collection("empleados")
        .document(name)
        .collection("horarios")
        .document(day)
        .get();

    if (documentSnapshot.data != null) {
      Schedule schedule = Schedule.fromMap(documentSnapshot.data, day);
      return schedule;
    } else {
      throw Exception("No hay horarios");
    }
  }

  @override
  Future<bool> insertAppointmentRestaurant(
      Appointment appointment, String uid) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .collection("horarios")
        .document(appointment.day.toString())
        .get();

    List lista = documentSnapshot.data['disponibilidad'];

    Duration duration = GetTimeSeparated.getDurationFromMinutes(
        appointment.business.durationMeal);

    DateTime firebaseDate;

    for (int i = 0; i < lista.length; i++) {
      List<String> hours = lista[i]["hora"].split(':');

      firebaseDate = appointment.checkIn.subtract(Duration(
          hours: appointment.checkIn.hour,
          minutes: appointment.checkIn.minute,
          seconds: appointment.checkIn.second,
          milliseconds: appointment.checkIn.millisecond,
          microseconds: appointment.checkIn.microsecond));

      firebaseDate = firebaseDate.add(
          Duration(hours: int.parse(hours[0]), minutes: int.parse(hours[1])));
      if(firebaseDate.difference(appointment.checkIn).inMinutes >= 0
          && firebaseDate.difference(appointment.checkIn).inMinutes <= appointment.business.durationMeal){
        lista[i]["totalDisponibles"]--;
      }
    }

    await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .collection("horarios")
        .document(appointment.day.toString())
        .setData({"disponibilidad": lista});

    DocumentReference docRef = await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("citas")
        .add({
      "extraInformation": appointment.numberPersons,
      "idUsuario": uid,
      "CheckIn": appointment.checkIn.toString(),
      "Negocio": appointment.business.name,
      "Direccion": appointment.business.direction
    });

    List refList = [docRef];

    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
  }

  @override
  Future<bool> insertAppointmentBeach(
      Appointment appointment, String uid) async {
    DocumentSnapshot documentSnapshot = await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .collection("horarios")
        .document(appointment.day.toString())
        .get();

    Duration duration = GetTimeSeparated.getDurationFromMinutes(appointment.business.durationMeal);
    List lista = documentSnapshot.data['disponibilidad'];

    DateTime firebaseDataInitial;
    DateTime firebaseDataFinal;

    for (int i = 0; i < lista.length; i++) {

      List<String> hours = lista[i]["hora"].split(':');

      firebaseDataInitial = appointment.checkIn.subtract(Duration(
          hours: appointment.checkIn.hour,
          minutes: appointment.checkIn.minute,
          seconds: appointment.checkIn.second,
          milliseconds: appointment.checkIn.millisecond,
          microseconds: appointment.checkIn.microsecond));

      firebaseDataInitial = firebaseDataInitial.add(
          Duration(hours: int.parse(hours[0]), minutes: int.parse(hours[1])));



      if(firebaseDataInitial.difference(appointment.checkIn).inMinutes >= 0
          && firebaseDataInitial.difference(appointment.checkIn).inMinutes <= appointment.business.durationMeal){
        lista[i]["totalDisponibles"]--;
      }

      if(firebaseDataInitial.difference(appointment.checkIn).inMinutes == 0){
        firebaseDataFinal = firebaseDataInitial.add(Duration(minutes: duration.inMinutes));
      }

    }



    await firestore.collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .collection("horarios")
        .document(appointment.day.toString())
        .setData({"disponibilidad": lista});


    DocumentReference docRef = await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("citas")
        .add({
      "extraInformation": appointment.numberPersons,
      "idUsuario": uid,
      "CheckIn": appointment.checkIn.toString(),
      "CheckOut": firebaseDataFinal.toString(),
      "Negocio": appointment.business.name,
      "Direccion": appointment.business.direction
    });

    List refList = [docRef];

    await firestore
        .collection("Usuarios")
        .document(uid)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);

    await firestore
        .collection("Negocios")
        .document(appointment.business.typeBusiness)
        .collection("Negocios")
        .document(appointment.business.uid)
        .collection("empleados")
        .document(appointment.numberPersons)
        .setData({"citas": FieldValue.arrayUnion(refList)}, merge: true);
  }

  @override
  Future<bool> removeAppointment(MyAppointment appointment) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentReference documentReference = appointment.documentReference;

    List ref = [];
    ref.add(documentReference);

    String checkIn = DateTime.parse(appointment.checkIn).hour.toString() +
        ":" +
        DateTime.parse(appointment.checkIn).minute.toString();
    String checkOut = DateTime.parse(appointment.checkOut).hour.toString() +
        ":" +
        DateTime.parse(appointment.checkOut).minute.toString();

    DateTime date = DateTime.parse(appointment.checkIn);
    DateTime subtract =
        date.subtract(Duration(hours: date.hour, minutes: date.minute));

    List<String> val = [];
    val = GetTimeSeparated.getHours(checkIn, checkOut, subtract);
    Schedule schedule = await getRange(
        subtract.toString(),
        appointment.extraInformation,
        appointment.businessUid,
        appointment.typeBusiness);
    schedule.disponibility.forEach((value) => val.add(value));

    val.sort();

    await firestore
        .collection("Negocios")
        .document(appointment.typeBusiness)
        .collection("Negocios")
        .document(appointment.businessUid)
        .collection("empleados")
        .document(appointment.extraInformation)
        .updateData({"citas": FieldValue.arrayRemove(ref)});

    await firestore
        .collection("Usuarios")
        .document(user.uid)
        .updateData({"citas": FieldValue.arrayRemove(ref)});

    await firestore
        .collection("Negocios")
        .document(appointment.typeBusiness)
        .collection("Negocios")
        .document(appointment.businessUid)
        .collection("empleados")
        .document(appointment.extraInformation)
        .collection("horarios")
        .document(subtract.toString())
        .updateData(
            {"disponibilidad": FieldValue.arrayRemove(schedule.disponibility)});

    await firestore
        .collection("Negocios")
        .document(appointment.typeBusiness)
        .collection("Negocios")
        .document(appointment.businessUid)
        .collection("empleados")
        .document(appointment.extraInformation)
        .collection("horarios")
        .document(subtract.toString())
        .updateData({"disponibilidad": FieldValue.arrayUnion(val)});

    documentReference.delete();
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
  Future<bool> getUserPenalize(String uid) async {
    DocumentSnapshot documentSnapshot =
        await firestore.collection("Usuarios").document(uid).get();
    bool penalize = documentSnapshot.data['Penalizacion'];
    return penalize;
  }
}
