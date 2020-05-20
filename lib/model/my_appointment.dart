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


  MyAppointment(this.uid, this.businessName, this.extraInformation, this.type, this.price,
      this.checkIn, this.checkOut, this.direction, this.typeBusiness, this.businessUid, this.documentReference);

  factory MyAppointment.fromMap(Map values, String uid, String businessUid, String typeBusiness, DocumentReference documentReference){
    return MyAppointment(uid,
        values["Negocio"], values['extraInformation'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"], values["Direccion"], typeBusiness, businessUid, documentReference);
  }
}
