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


  MyAppointment(this.uid, this.businessName, this.extraInformation, this.type, this.price,
      this.checkIn, this.checkOut, this.direction, this.typeBusiness, this.businessUid);

  factory MyAppointment.fromMap(Map values, String uid, String businessUid, String typeBusiness){
    return MyAppointment(uid,
        values["Negocio"], values['extraInformation'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"], values["Direccion"], typeBusiness, businessUid);
  }
}
