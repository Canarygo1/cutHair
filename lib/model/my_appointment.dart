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


  MyAppointment(this.uid, this.businessName, this.extraInformation,
      this.checkIn, this.direction, this.typeBusiness, this.businessUid, { this.checkOut, this.type, this.price});

  factory MyAppointment.fromMap(Map values, String uid, String businessUid, String typeBusiness){

    String negocio =  values["Negocio"];
    String extraInformation = values['extraInformation'];
    String checkIn = values['CheckIn'];
    String direction = values["Direccion"];

    if(typeBusiness == "Peluquerias"){
      return MyAppointment(uid, negocio, extraInformation, checkIn, direction,
          typeBusiness, businessUid, checkOut: values["CheckOut"], type: values["Servicio"], price:  values['Precio']);
    }else{
      return MyAppointment(uid,
          negocio, extraInformation, checkIn, direction, typeBusiness, businessUid);
    }
  }
}
