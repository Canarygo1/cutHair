class MyAppointment {
  String hairdressing;
  String hairdresser;
  String type;
  String price;
  String checkIn;
  String checkOut;
  String direction;

  MyAppointment(this.hairdressing, this.hairdresser, this.type, this.price,
      this.checkIn, this.checkOut, this.direction);

  factory MyAppointment.fromMap(Map values){
    return MyAppointment(
        values["Peluqueria"], values['Peluquero'], values["Servicio"],
        values['Precio'], values["CheckIn"], values["CheckOut"], values["Direccion"]);
  }
}
