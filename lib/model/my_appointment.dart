import 'package:cloud_firestore/cloud_firestore.dart';

class MyAppointment {
  String uid;
  String businessUid;
  String businessName;
  String extraInformation;
  String type;
  String price;
  String checkIn;
  String checkOut;
  String direction;
  String typeBusiness;
  DocumentReference documentReference;

  MyAppointment(this.uid, this.businessName, this.extraInformation,
      this.checkIn, this.direction, this.typeBusiness, this.businessUid, this.documentReference, { this.checkOut, this.type, this.price});

  factory MyAppointment.fromMap(Map values, String uid, String businessUid, String typeBusiness, DocumentReference documentReference){

    String negocio =  values["Negocio"];
    String extraInformation = values['extraInformation'];
    String checkIn = values['CheckIn'];
    String direction = values["Direccion"];

    if(typeBusiness == "Peluquerias"){
      return MyAppointment(uid, negocio, extraInformation, checkIn, direction,
          typeBusiness, businessUid, checkOut: values["CheckOut"], type: values["Servicio"], price:  values['Precio'], this.documentReference);
    }else{
      return MyAppointment(uid,
          negocio, extraInformation, checkIn, direction, typeBusiness, businessUid, this.documentReference);
    }
  }
}
