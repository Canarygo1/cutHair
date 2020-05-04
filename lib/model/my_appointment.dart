class MyAppointment {
  String uid;
  String hairdressing;
  String hairdresser;
  String type;
  String price;
  String checkIn;
  String checkOut;
  String direction;
  String typeBusiness;

  MyAppointment(this.uid, this.hairdressing, this.hairdresser, this.type, this.price,
      this.checkIn, this.checkOut, this.direction, this.typeBusiness);

  factory MyAppointment.fromMap(Map values, String uid, String typeBusiness){
    return MyAppointment(uid,
        values["Peluqueria"], values['Peluquero'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"], values["Direccion"], typeBusiness);
  }
}
